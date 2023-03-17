Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C246BF0AC
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjCQS1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjCQS1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:27:19 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA5B311E2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:27:14 -0700 (PDT)
Date:   Fri, 17 Mar 2023 18:27:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679077633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4oKF9l25tYdyvWLnXrBZe3srNKkedksE/M0x/BYjlLw=;
        b=ngjU+Uzunf8+sUBFoB1rW4gjXEc7yaAOxJ4JpVjR2EMHmSnRtMhev8TN0AoC07lpYURv9/
        1PU0FCnoQNu+V1TOlVklWjzBYUuvApNcazbHMyl3K2Bvy+Cb5aKAdaTPO89ddQfV2Dv5yt
        7EQA+ewGFcRZfGfVeXQU8zyWsW1zQ4s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 12/14] KVM: arm64: Implement
 KVM_CAP_MEMORY_FAULT_NOWAIT
Message-ID: <ZBSw/jh/WfAwu3ga@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-13-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315021738.1151386-13-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:36AM +0000, Anish Moorthy wrote:
> When a memslot has the KVM_MEM_MEMORY_FAULT_EXIT flag set, exit to
> userspace upon encountering a page fault for which the userspace
> page tables do not contain a present mapping.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Acked-by: James Houghton <jthoughton@google.com>
> ---
>  arch/arm64/kvm/arm.c |  1 +
>  arch/arm64/kvm/mmu.c | 14 ++++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf0872..f8337e757c777 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  	case KVM_CAP_PTP_KVM:
>  	case KVM_CAP_ARM_SYSTEM_SUSPEND:
> +	case KVM_CAP_MEMORY_FAULT_NOWAIT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 735044859eb25..0d04ffc81f783 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1206,6 +1206,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	unsigned long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> +	bool exit_on_memory_fault = kvm_slot_fault_on_absent_mapping(memslot);
>  
>  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
>  	write_fault = kvm_is_write_fault(vcpu);
> @@ -1303,8 +1304,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 */
>  	smp_rmb();
>  
> -	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
> -				   write_fault, &writable, NULL);
> +	pfn = __gfn_to_pfn_memslot(
> +		memslot, gfn, exit_on_memory_fault, false, NULL,
> +		write_fault, &writable, NULL);

As stated before [*], this google3-esque style does not match the kernel style
guide. You may want to check if your work machine is setting up a G3-specific
editor configuration behind your back.

[*] https://lore.kernel.org/kvm/Y+0QRsZ4yWyUdpnc@google.com/

> +	if (exit_on_memory_fault && pfn == KVM_PFN_ERR_FAULT) {

nit: I don't think the local is explicitly necessary. I still find this
readable:

	if (pfn == KVM_PFN_ERR_FAULT && kvm_slot_fault_on_absent_mapping(memslot))

> +		vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +		vcpu->run->memory_fault.flags = 0;
> +		vcpu->run->memory_fault.gpa = gfn << PAGE_SHIFT;
> +		vcpu->run->memory_fault.len = vma_pagesize;
> +		return 0;
> +	}
>  	if (pfn == KVM_PFN_ERR_HWPOISON) {
>  		kvm_send_hwpoison_signal(hva, vma_shift);
>  		return 1;
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
> 

-- 
Thanks,
Oliver
