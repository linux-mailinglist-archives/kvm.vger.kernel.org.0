Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D507434FA98
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 09:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhCaHmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 03:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234329AbhCaHmX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 03:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617176543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCixOYNQFJEmCwNjkKeRd8lCZMOXCEBzJPf2kb2CuW8=;
        b=FV0TGc/4JFgtF3ZHi8r0i1zAQ8g1XwjjgkpVPtagq7lcpAB1cRNSDWpyXl12fuZiqRG8Qj
        ztjRolBIam0TBr8NdjYAJSCQk6BjKdGptX9NRZ7v0T89uu0Z8r1wvfav9lz/YUMrWUMIHB
        leGXVKQORg2ZblogyhyVklDpnuiYuYE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-up16NgqlNfOLkuCQ2EC4Yg-1; Wed, 31 Mar 2021 03:41:41 -0400
X-MC-Unique: up16NgqlNfOLkuCQ2EC4Yg-1
Received: by mail-wm1-f69.google.com with SMTP id n17so115800wmi.2
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 00:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HCixOYNQFJEmCwNjkKeRd8lCZMOXCEBzJPf2kb2CuW8=;
        b=iyOVa8q61K+lh7IEgYIgF8UCwawvDuyKGRnmH30jWHfbBIfyVbF7e9f+zLUfs2fky9
         I+hoNgibgtVEt6kEdTYdGDZJpekHDFcW/+HAs574KS2NZ/Mcu4in7Fqozmx7JqwlpOKR
         t+6Vczk3M8STkQb301KmMm125hD+4ospmJaSYBoUkHIClEbPxMwV++f6oLy+5tuBPkmi
         elzbBHtgytA1YaN84VOKmxx5VY8H7Z0UQ/vrn7lj3PbwDD1UsFlpTcUSoJrV6yUC7J1k
         yZ35UoPrHPl3b3etwgYj3GN4UyMJMsDs1sEtLBFc42zFtPFfZp6C1TPCQsZ3Iu/uJvx/
         J1Mw==
X-Gm-Message-State: AOAM532HMnKbfUUe2ZBfnN5FuX50yI0xWg4nPcfssl6qOYccSWFboNSl
        oc5jcEi2cCryXD4lmZoG+m8hZKC3Rs22Qw8O/uwlV/EdQMiJxtznCuMuvr7BwiXQoG241m5mr6k
        fX0uDBGnTjC2t
X-Received: by 2002:a1c:b789:: with SMTP id h131mr1904506wmf.106.1617176499782;
        Wed, 31 Mar 2021 00:41:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiHmYD2Le+p2rRCHafUQsuCWJvR5BP1vyRx1fx+QhpZoWEEC9/7YIvjmyyJZB+n8xVLiTOmA==
X-Received: by 2002:a1c:b789:: with SMTP id h131mr1904488wmf.106.1617176499531;
        Wed, 31 Mar 2021 00:41:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a131sm2662492wmc.48.2021.03.31.00.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 00:41:38 -0700 (PDT)
Subject: Re: [PATCH 12/18] KVM: MIPS/MMU: Convert to the gfn-based MMU
 notifier callbacks
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-13-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <26c87b3e-7a89-6cfa-1410-25486b114f32@redhat.com>
Date:   Wed, 31 Mar 2021 09:41:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-13-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/21 03:19, Sean Christopherson wrote:
> Move MIPS to the gfn-based MMU notifier APIs, which do the hva->gfn
> lookup in common code, and whose code is nearly identical to MIPS'
> lookup.
> 
> No meaningful functional change intended, though the exact order of
> operations is slightly different since the memslot lookups occur before
> calling into arch code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I'll post a couple patches to enable more coalescing of the flushes, but 
this particular patch is okay.

Paolo

> ---
>   arch/mips/include/asm/kvm_host.h |  1 +
>   arch/mips/kvm/mmu.c              | 97 ++++++--------------------------
>   2 files changed, 17 insertions(+), 81 deletions(-)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index feaa77036b67..374a3c8806e8 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -967,6 +967,7 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
>   						   bool write);
>   
>   #define KVM_ARCH_WANT_MMU_NOTIFIER
> +#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
>   
>   /* Emulation */
>   int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 3dabeda82458..3dc885df2e32 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -439,85 +439,36 @@ static int kvm_mips_mkold_gpa_pt(struct kvm *kvm, gfn_t start_gfn,
>   				  end_gfn << PAGE_SHIFT);
>   }
>   
> -static int handle_hva_to_gpa(struct kvm *kvm,
> -			     unsigned long start,
> -			     unsigned long end,
> -			     int (*handler)(struct kvm *kvm, gfn_t gfn,
> -					    gpa_t gfn_end,
> -					    struct kvm_memory_slot *memslot,
> -					    void *data),
> -			     void *data)
> +bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
> -	int ret = 0;
> -
> -	slots = kvm_memslots(kvm);
> -
> -	/* we only care about the pages that the guest sees */
> -	kvm_for_each_memslot(memslot, slots) {
> -		unsigned long hva_start, hva_end;
> -		gfn_t gfn, gfn_end;
> -
> -		hva_start = max(start, memslot->userspace_addr);
> -		hva_end = min(end, memslot->userspace_addr +
> -					(memslot->npages << PAGE_SHIFT));
> -		if (hva_start >= hva_end)
> -			continue;
> -
> -		/*
> -		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
> -		 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
> -		 */
> -		gfn = hva_to_gfn_memslot(hva_start, memslot);
> -		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
> -
> -		ret |= handler(kvm, gfn, gfn_end, memslot, data);
> -	}
> -
> -	return ret;
> -}
> -
> -
> -static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -				 struct kvm_memory_slot *memslot, void *data)
> -{
> -	kvm_mips_flush_gpa_pt(kvm, gfn, gfn_end);
> -	return 1;
> -}
> -
> -int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
> -			unsigned flags)
> -{
> -	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
> +	kvm_mips_flush_gpa_pt(kvm, range->start, range->end);
>   
>   	kvm_mips_callbacks->flush_shadow_all(kvm);
>   	return 0;
>   }
>   
> -static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -				struct kvm_memory_slot *memslot, void *data)
> +static bool __kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	gpa_t gpa = gfn << PAGE_SHIFT;
> -	pte_t hva_pte = *(pte_t *)data;
> +	gpa_t gpa = range->start << PAGE_SHIFT;
> +	pte_t hva_pte = range->pte;
>   	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
>   	pte_t old_pte;
>   
>   	if (!gpa_pte)
> -		return 0;
> +		return false;
>   
>   	/* Mapping may need adjusting depending on memslot flags */
>   	old_pte = *gpa_pte;
> -	if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
> +	if (range->slot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
>   		hva_pte = pte_mkclean(hva_pte);
> -	else if (memslot->flags & KVM_MEM_READONLY)
> +	else if (range->slot->flags & KVM_MEM_READONLY)
>   		hva_pte = pte_wrprotect(hva_pte);
>   
>   	set_pte(gpa_pte, hva_pte);
>   
>   	/* Replacing an absent or old page doesn't need flushes */
>   	if (!pte_present(old_pte) || !pte_young(old_pte))
> -		return 0;
> +		return false;
>   
>   	/* Pages swapped, aged, moved, or cleaned require flushes */
>   	return !pte_present(hva_pte) ||
> @@ -526,27 +477,21 @@ static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
>   	       (pte_dirty(old_pte) && !pte_dirty(hva_pte));
>   }
>   
> -int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
> +bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	unsigned long end = hva + PAGE_SIZE;
> -	int ret;
> -
> -	ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
> -	if (ret)
> +	if (__kvm_set_spte_gfn(kvm, range))
>   		kvm_mips_callbacks->flush_shadow_all(kvm);
> -	return 0;
> +	return false;
>   }
>   
> -static int kvm_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -			       struct kvm_memory_slot *memslot, void *data)
> +bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	return kvm_mips_mkold_gpa_pt(kvm, gfn, gfn_end);
> +	return kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
>   }
>   
> -static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -				    struct kvm_memory_slot *memslot, void *data)
> +bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	gpa_t gpa = gfn << PAGE_SHIFT;
> +	gpa_t gpa = range->start << PAGE_SHIFT;
>   	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
>   
>   	if (!gpa_pte)
> @@ -554,16 +499,6 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
>   	return pte_young(*gpa_pte);
>   }
>   
> -int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
> -{
> -	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
> -}
> -
> -int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
> -{
> -	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
> -}
> -
>   /**
>    * _kvm_mips_map_page_fast() - Fast path GPA fault handler.
>    * @vcpu:		VCPU pointer.
> 

