Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BC711D136
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 16:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfLLPk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 10:40:58 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:42907 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729013AbfLLPk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 10:40:58 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifQaG-0003ws-9n; Thu, 12 Dec 2019 16:40:56 +0100
To:     James Morse <james.morse@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a  poisoned page
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 12 Dec 2019 15:40:56 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <b0a2b074-b80f-84ee-bfaa-f81ab345b8c2@arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-3-maz@kernel.org>
 <88f65ab4ac87f53534fbbfd2410d1cc5@www.loen.fr>
 <b0a2b074-b80f-84ee-bfaa-f81ab345b8c2@arm.com>
Message-ID: <238ff4a1b763f51cc1f8670bfc72fc15@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On 2019-12-12 15:34, James Morse wrote:
> Hi Marc,
>
> On 12/12/2019 11:33, Marc Zyngier wrote:
>> On 2019-12-11 16:56, Marc Zyngier wrote:
>>> When we check for a poisoned page, we use the VMA to tell userspace
>>> about the looming disaster. But we pass a pointer to this VMA
>>> after having released the mmap_sem, which isn't a good idea.
>
> Sounds like a bug! The vma-size might not match the poisoned pfn.
>
>
>>> Instead, re-check that we have still have a VMA, and that this
>>> VMA still points to a poisoned page. If the VMA isn't there,
>>> userspace is playing with our nerves, so lety's give it a -EFAULT
>>> (it deserves it). If the PFN isn't poisoned anymore, let's restart
>>> from the top and handle the fault again.
>
>
>>>  virt/kvm/arm/mmu.c | 25 +++++++++++++++++++++++--
>>>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> ... yeah ...
>

[...]

> How about (untested):
> -------------------------%<-------------------------
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..80212d4935bd 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1591,16 +1591,8 @@ static void
> invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned
> long size)
>         __invalidate_icache_guest_page(pfn, size);
>  }
>
> -static void kvm_send_hwpoison_signal(unsigned long address,
> -                                    struct vm_area_struct *vma)
> +static void kvm_send_hwpoison_signal(unsigned long address, short 
> lsb)
>  {
> -       short lsb;
> -
> -       if (is_vm_hugetlb_page(vma))
> -               lsb = huge_page_shift(hstate_vma(vma));
> -       else
> -               lsb = PAGE_SHIFT;
> -
>         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, 
> current);
>  }
>
> @@ -1673,6 +1665,7 @@ static int user_mem_abort(struct kvm_vcpu
> *vcpu, phys_addr_t fault_ipa,
>         struct kvm *kvm = vcpu->kvm;
>         struct kvm_mmu_memory_cache *memcache = 
> &vcpu->arch.mmu_page_cache;
>         struct vm_area_struct *vma;
> +       short stage1_vma_size;
>         kvm_pfn_t pfn;
>         pgprot_t mem_type = PAGE_S2;
>         bool logging_active = memslot_is_logging(memslot);
>
> @@ -1703,6 +1696,12 @@ static int user_mem_abort(struct kvm_vcpu
> *vcpu, phys_addr_t fault_ipa,
>                 vma_pagesize = PAGE_SIZE;
>         }
>
> +       /* For signals due to hwpoison, we need to use the stage1 
> size */
> +       if (is_vm_hugetlb_page(vma))
> +               stage1_vma_size = huge_page_shift(hstate_vma(vma));
> +       else
> +               stage1_vma_size = PAGE_SHIFT;
> +
>         /*
>          * The stage2 has a minimum of 2 level table (For arm64 see
>          * kvm_arm_setup_stage2()). Hence, we are guaranteed that we 
> can
> @@ -1735,7 +1734,7 @@ static int user_mem_abort(struct kvm_vcpu
> *vcpu, phys_addr_t fault_ipa,
>
>         pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>         if (pfn == KVM_PFN_ERR_HWPOISON) {
> -               kvm_send_hwpoison_signal(hva, vma);
> +               kvm_send_hwpoison_signal(hva, stage1_vma_size);
>                 return 0;
>         }
>         if (is_error_noslot_pfn(pfn))
> -------------------------%<-------------------------
>
> Its possible this could even be the original output of
> vma_kernel_pagesize()... (Punit supplied the original
> huge_page_shift(hstate_vma()) runes...)

I'd be happy with something along these lines. Any chance you could
a proper patch?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
