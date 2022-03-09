Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3B4D35F6
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiCIRIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237604AbiCIRIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:08:38 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000355A14C;
        Wed,  9 Mar 2022 08:58:11 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nRzdI-0001mC-K3; Wed, 09 Mar 2022 17:57:52 +0100
Message-ID: <421f4fba-3e1c-b676-d74c-02c6c3f804d2@maciej.szmigiero.name>
Date:   Wed, 9 Mar 2022 17:57:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <20220308043857.13652-10-nikunj@amd.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH RFC v1 9/9] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
In-Reply-To: <20220308043857.13652-10-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8.03.2022 05:38, Nikunj A Dadhania wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Pin the memory for the data being passed to launch_update_data()
> because it gets encrypted before the guest is first run and must
> not be moved which would corrupt it.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> [ * Use kvm_for_each_memslot_in_hva_range() to find slot and iterate
>    * Updated sev_pin_memory_in_mmu() error handling.
>    * As pinning/unpining pages is handled within MMU, removed
>      {get,put}_user(). ]
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 146 +++++++++++++++++++++++++++++++++++++----
>   1 file changed, 134 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7e39320fc65d..1c371268934b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -22,6 +22,7 @@
>   #include <asm/trapnr.h>
>   #include <asm/fpu/xcr.h>
>   
> +#include "mmu.h"
>   #include "x86.h"
>   #include "svm.h"
>   #include "svm_ops.h"
> @@ -428,9 +429,93 @@ static void *sev_alloc_pages(struct kvm_sev_info *sev, unsigned long uaddr,
>   	return pages;
>   }
>   
> +#define SEV_PFERR_RO (PFERR_USER_MASK)
> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
> +
> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
> +					   unsigned long size,
> +					   unsigned long *npages)
> +{
> +	unsigned long hva_start, hva_end, uaddr, end, slot_start, slot_end;
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct interval_tree_node *node;
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	int idx, ret = 0, i = 0;
> +	struct kvm_vcpu *vcpu;
> +	struct page **pages;
> +	kvm_pfn_t pfn;
> +	u32 err_code;
> +	gfn_t gfn;
> +
> +	pages = sev_alloc_pages(sev, addr, size, npages);
> +	if (IS_ERR(pages))
> +		return pages;
> +
> +	vcpu = kvm_get_vcpu(kvm, 0);
> +	if (mutex_lock_killable(&vcpu->mutex)) {
> +		kvfree(pages);
> +		return ERR_PTR(-EINTR);
> +	}
> +
> +	vcpu_load(vcpu);
> +	idx = srcu_read_lock(&kvm->srcu);
> +
> +	kvm_mmu_load(vcpu);
> +
> +	end = addr + (*npages << PAGE_SHIFT);
> +	slots = kvm_memslots(kvm);
> +
> +	kvm_for_each_memslot_in_hva_range(node, slots, addr, end) {
> +		slot = container_of(node, struct kvm_memory_slot,
> +				    hva_node[slots->node_idx]);
> +		slot_start = slot->userspace_addr;
> +		slot_end = slot_start + (slot->npages << PAGE_SHIFT);
> +		hva_start = max(addr, slot_start);
> +		hva_end = min(end, slot_end);
> +
> +		err_code = (slot->flags & KVM_MEM_READONLY) ?
> +			SEV_PFERR_RO : SEV_PFERR_RW;
> +
> +		for (uaddr = hva_start; uaddr < hva_end; uaddr += PAGE_SIZE) {
> +			if (signal_pending(current)) {
> +				ret = -ERESTARTSYS;
> +				break;
> +			}
> +
> +			if (need_resched())
> +				cond_resched();
> +
> +			/*
> +			 * Fault in the page and sev_pin_page() will handle the
> +			 * pinning
> +			 */
> +			gfn = hva_to_gfn_memslot(uaddr, slot);
> +			pfn = kvm_mmu_map_tdp_page(vcpu, gfn_to_gpa(gfn),
> +						   err_code, PG_LEVEL_4K);
> +			if (is_error_noslot_pfn(pfn)) {
> +				ret = -EFAULT;
> +				break;
> +			}
> +			pages[i++] = pfn_to_page(pfn);
> +		}
> +	}

This algorithm looks much better than the previews one - thanks!

By the way, as far as I know, there could be duplicates in the "page" array
above since the same hva can be mapped to multiple gfns (in different memslots).
Is the code prepared to deal with this possibility?

Thanks,
Maciej
