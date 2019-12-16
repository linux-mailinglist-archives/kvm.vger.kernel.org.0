Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E42121669
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 19:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbfLPS3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 13:29:04 -0500
Received: from foss.arm.com ([217.140.110.172]:37022 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731465AbfLPS3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 13:29:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2955C1007;
        Mon, 16 Dec 2019 10:29:03 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 088123F719;
        Mon, 16 Dec 2019 10:29:01 -0800 (PST)
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
To:     Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-3-maz@kernel.org>
 <20191213092239.GB28840@e113682-lin.lund.arm.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <1723e51d-28a2-d2e5-e45a-12acc2991bcc@arm.com>
Date:   Mon, 16 Dec 2019 18:29:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191213092239.GB28840@e113682-lin.lund.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christoffer,

On 13/12/2019 09:22, Christoffer Dall wrote:
> On Wed, Dec 11, 2019 at 04:56:49PM +0000, Marc Zyngier wrote:
>> When we check for a poisoned page, we use the VMA to tell userspace
>> about the looming disaster. But we pass a pointer to this VMA
>> after having released the mmap_sem, which isn't a good idea.
>>
>> Instead, re-check that we have still have a VMA, and that this
>> VMA still points to a poisoned page. If the VMA isn't there,
>> userspace is playing with our nerves, so lety's give it a -EFAULT
>> (it deserves it). If the PFN isn't poisoned anymore, let's restart
>> from the top and handle the fault again.

> If I read this code correctly, then all we use the VMA for is to find
> the page size used by the MMU to back the VMA, which we've already
> established in the vma_pagesize (and possibly adjusted to something more
> accurate based on our constraints in stage 2 which generated the error),
> so all we need is the size and a way to convert that into a shift.
> 
> Not being 100% confident about the semantics of the lsb bit we pass to
> user space (is it indicating the size of the mapping which caused the
> error or the size of the mapping where user space could potentially

Its the size of the hole that has opened up in the address map. The error was very likely
to be much smaller, but all we can do is unmap pages.
Transparent huge-pages are split up to minimise the impact. This code is for hugetlbfs
(?), whose pages are dedicated for that use, so don't get split.

arch/arm64/mm/fault.c::do_page_fault() has:
|	lsb = PAGE_SHIFT;
|	if (fault & VM_FAULT_HWPOISON_LARGE)
|		lsb = hstate_index_to_shift(VM_FAULT_GET_HINDEX(fault));
|
|	arm64_force_sig_mceerr(BUS_MCEERR_AR, (void __user *)addr, lsb,

(I assume its a shift because bytes in the signal union are precious)


> trigger an error?), or wheter we care enough at that level, could we
> consider something like the following instead?

> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..2509d9dec42d 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1592,15 +1592,9 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>  }
>  
>  static void kvm_send_hwpoison_signal(unsigned long address,
> -				     struct vm_area_struct *vma)
> +				     unsigned long vma_pagesize)
>  {
> -	short lsb;
> -
> -	if (is_vm_hugetlb_page(vma))
> -		lsb = huge_page_shift(hstate_vma(vma));
> -	else
> -		lsb = PAGE_SHIFT;
> -
> +	short lsb = __ffs(vma_pagesize);
>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>  }
>  
> @@ -1735,7 +1729,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>  	if (pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(hva, vma);
> +		kvm_send_hwpoison_signal(hva, vma_pagesize);
>  		return 0;
>  	}
>  	if (is_error_noslot_pfn(pfn))

This changes the meaning, vma_pagesize is a value like 4K, not a shift like 12.

But yes, caching the shift value under the mmap_sem and passing it in is the
right-thing-to-do(tm). I have a patch which I'll post, once I remember how to test this thing!



Thanks,

James
