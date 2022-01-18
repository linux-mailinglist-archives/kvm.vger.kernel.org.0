Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6874929A8
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 16:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345786AbiARP2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 10:28:52 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:36944 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345777AbiARP2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 10:28:41 -0500
X-Greylist: delayed 1636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 10:28:41 EST
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1n9pyn-00084x-Lw; Tue, 18 Jan 2022 16:01:01 +0100
Message-ID: <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
Date:   Tue, 18 Jan 2022 16:00:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
In-Reply-To: <20220118110621.62462-7-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikunj,

On 18.01.2022 12:06, Nikunj A Dadhania wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Pin the memory for the data being passed to launch_update_data()
> because it gets encrypted before the guest is first run and must
> not be moved which would corrupt it.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
>    * Updated sev_pin_memory_in_mmu() error handling.
>    * As pinning/unpining pages is handled within MMU, removed
>      {get,put}_user(). ]
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 119 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 14aeccfc500b..1ae714e83a3c 100644
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
> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>   	return pages;
>   }
>   
> +#define SEV_PFERR_RO (PFERR_USER_MASK)
> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
> +
> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
> +					      unsigned long hva)
> +{
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +	struct kvm_memory_slot *memslot;
> +	int bkt;
> +
> +	kvm_for_each_memslot(memslot, bkt, slots) {
> +		if (hva >= memslot->userspace_addr &&
> +		    hva < memslot->userspace_addr +
> +		    (memslot->npages << PAGE_SHIFT))
> +			return memslot;
> +	}
> +
> +	return NULL;
> +}

We have kvm_for_each_memslot_in_hva_range() now, please don't do a linear
search through memslots.
You might need to move the aforementioned macro from kvm_main.c to some
header file, though.

> +static gpa_t hva_to_gpa(struct kvm *kvm, unsigned long hva, bool *ro)
> +{
> +	struct kvm_memory_slot *memslot;
> +	gpa_t gpa_offset;
> +
> +	memslot = hva_to_memslot(kvm, hva);
> +	if (!memslot)
> +		return UNMAPPED_GVA;
> +
> +	*ro = !!(memslot->flags & KVM_MEM_READONLY);
> +	gpa_offset = hva - memslot->userspace_addr;
> +	return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
> +}
> +
> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
> +					   unsigned long size,
> +					   unsigned long *npages)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_vcpu *vcpu;
> +	struct page **pages;
> +	unsigned long i;
> +	u32 error_code;
> +	kvm_pfn_t pfn;
> +	int idx, ret = 0;
> +	gpa_t gpa;
> +	bool ro;
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
> +	for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
> +		if (signal_pending(current)) {
> +			ret = -ERESTARTSYS;
> +			break;
> +		}
> +
> +		if (need_resched())
> +			cond_resched();
> +
> +		gpa = hva_to_gpa(kvm, addr, &ro);
> +		if (gpa == UNMAPPED_GVA) {
> +			ret = -EFAULT;
> +			break;
> +		}

This function is going to have worst case O(n²) complexity if called with
the whole VM memory (or O(n * log(n)) when hva_to_memslot() is modified
to use kvm_for_each_memslot_in_hva_range()).

That's really bad for something that can be done in O(n) time - look how
kvm_for_each_memslot_in_gfn_range() does it over gfns.

Thanks,
Maciej
