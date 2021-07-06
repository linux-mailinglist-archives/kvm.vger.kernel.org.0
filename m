Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDD53BD92A
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhGFO7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:59:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231460AbhGFO6w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUEPkdf2rzvjptwOm0DguI5Fsj71Wg4RO38W/Ug9+f0=;
        b=KxkaCaltB2ZE3PMaexuTkjDrNW4V7obW2WfRiy5VCMK1lEtVkpejIwtK+P6N3TF37Ho1TV
        kOqpoxYFF9ueNEpO8ZoOMImEvR55TLIgLjyBCuCLdz2LegUrjAQt75l9/U2RBomKhMyFpg
        h45/V4LtMpWR5ChGRuhJfIjMACbH2A0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-5eL3B_I7PrKR_z3WFxk5vQ-1; Tue, 06 Jul 2021 10:56:12 -0400
X-MC-Unique: 5eL3B_I7PrKR_z3WFxk5vQ-1
Received: by mail-ed1-f72.google.com with SMTP id f20-20020a0564020054b0290395573bbc17so10932294edu.19
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:56:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KUEPkdf2rzvjptwOm0DguI5Fsj71Wg4RO38W/Ug9+f0=;
        b=UiD4gbDHIcH4kol0drhhnhZpRpKag1aggI008zdlM1F89bN+Z7D9CBdVVd5/2+PfuW
         +LiZ9mNPfXwBfmxXHsPYLFCKrWjZNBk+oGxEopxbK5txRDB/QEOcWCwAmern68LWyQx+
         XI4GGN3cD//KlHwR1OkU39Q9iXwoypFXVn4uw0orrvEvDdpOBSUETLTe1Owu40tA5Xqo
         ABmzKhuUaBaUvZDUAYQ7CTs10O7TU65vHvGrXPqd35jAEy4ZxSzXdCYwFfFJUay+RDG2
         YktXpYss8C5w3GZ/ePqn8uatRvxsRfL3bnZgmHF04FoGwazLs+a3Clz7CI5qNI443hvh
         J53Q==
X-Gm-Message-State: AOAM532+rOURVnBby4bCX8C97CUVVCdszNGJkLBUKBvp282d1NTcZx1b
        /ax9zolBR0S+tPXtnOh5u0frbnnwF4944crta6bhOfPk32qiu5QEDNd8RruitKAgJhpMRx8S5IP
        s15LY2g8AUjTe
X-Received: by 2002:a17:906:2552:: with SMTP id j18mr10887703ejb.199.1625583371030;
        Tue, 06 Jul 2021 07:56:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVqr9MREHDsbIstBVC6+m6GTlR07Ik7ygsS9hb74hhhq00636GIdnNZWXOllPaVB/P2V5sBQ==
X-Received: by 2002:a17:906:2552:: with SMTP id j18mr10887684ejb.199.1625583370845;
        Tue, 06 Jul 2021 07:56:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d22sm6002762ejj.47.2021.07.06.07.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:56:09 -0700 (PDT)
Subject: Re: [RFC PATCH v2 43/69] KVM: x86/mmu: Allow non-zero init value for
 shadow PTE
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <2a12f8867229459dba2da233bf7762cb1ac2722c.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c27da555-b0f2-045c-d577-7e9afb858da1@redhat.com>
Date:   Tue, 6 Jul 2021 16:56:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2a12f8867229459dba2da233bf7762cb1ac2722c.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX will run with EPT violation #VEs enabled, which means KVM needs to
> set the "suppress #VE" bit in unused PTEs to avoid unintentionally
> reflecting not-present EPT violations into the guest.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu.h      |  1 +
>   arch/x86/kvm/mmu/mmu.c  | 50 +++++++++++++++++++++++++++++++++++------
>   arch/x86/kvm/mmu/spte.c | 10 +++++++++
>   arch/x86/kvm/mmu/spte.h |  2 ++
>   4 files changed, 56 insertions(+), 7 deletions(-)

Please ensure that this also works for tdp_mmu.c (if anything, consider 
supporting TDX only for TDP MMU; it's quite likely that mmu.c support 
for EPT/NPT will go away).

Paolo

> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 69b82857acdb..6ec8d9fdff35 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -61,6 +61,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
>   
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> +void kvm_mmu_set_spte_init_value(u64 init_value);
>   
>   void
>   reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 631b92e6e9ba..1c40dfd05979 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -550,9 +550,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
>   	u64 old_spte = *sptep;
>   
>   	if (!spte_has_volatile_bits(old_spte))
> -		__update_clear_spte_fast(sptep, 0ull);
> +		__update_clear_spte_fast(sptep, shadow_init_value);
>   	else
> -		old_spte = __update_clear_spte_slow(sptep, 0ull);
> +		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
>   
>   	if (!is_shadow_present_pte(old_spte))
>   		return 0;
> @@ -582,7 +582,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
>    */
>   static void mmu_spte_clear_no_track(u64 *sptep)
>   {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, shadow_init_value);
>   }
>   
>   static u64 mmu_spte_get_lockless(u64 *sptep)
> @@ -660,6 +660,42 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>   	local_irq_enable();
>   }
>   
> +static inline void kvm_init_shadow_page(void *page)
> +{
> +#ifdef CONFIG_X86_64
> +	int ign;
> +
> +	asm volatile (
> +		"rep stosq\n\t"
> +		: "=c"(ign), "=D"(page)
> +		: "a"(shadow_init_value), "c"(4096/8), "D"(page)
> +		: "memory"
> +	);
> +#else
> +	BUG();
> +#endif
> +}
> +
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> +	int start, end, i, r;
> +
> +	if (shadow_init_value)
> +		start = kvm_mmu_memory_cache_nr_free_objects(mc);
> +
> +	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> +	if (r)
> +		return r;
> +
> +	if (shadow_init_value) {
> +		end = kvm_mmu_memory_cache_nr_free_objects(mc);
> +		for (i = start; i < end; i++)
> +			kvm_init_shadow_page(mc->objects[i]);
> +	}
> +	return 0;
> +}
> +
>   static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>   {
>   	int r;
> @@ -669,8 +705,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>   				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>   	if (r)
>   		return r;
> -	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -				       PT64_ROOT_MAX_LEVEL);
> +	r = mmu_topup_shadow_page_cache(vcpu);
>   	if (r)
>   		return r;
>   	if (maybe_indirect) {
> @@ -3041,7 +3076,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	struct kvm_shadow_walk_iterator iterator;
>   	struct kvm_mmu_page *sp;
>   	int ret = RET_PF_INVALID;
> -	u64 spte = 0ull;
> +	u64 spte = shadow_init_value;
>   	uint retry_count = 0;
>   
>   	if (!page_fault_can_be_fast(error_code))
> @@ -5383,7 +5418,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>   	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>   
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	if (!shadow_init_value)
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>   	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 66d43cec0c31..0b931f1c2210 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -34,6 +34,7 @@ u64 __read_mostly shadow_mmio_access_mask;
>   u64 __read_mostly shadow_present_mask;
>   u64 __read_mostly shadow_me_mask;
>   u64 __read_mostly shadow_acc_track_mask;
> +u64 __read_mostly shadow_init_value;
>   
>   u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>   u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
> @@ -211,6 +212,14 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
>   	return new_spte;
>   }
>   
> +void kvm_mmu_set_spte_init_value(u64 init_value)
> +{
> +	if (WARN_ON(!IS_ENABLED(CONFIG_X86_64) && init_value))
> +		init_value = 0;
> +	shadow_init_value = init_value;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_spte_init_value);
> +
>   static u8 kvm_get_shadow_phys_bits(void)
>   {
>   	/*
> @@ -355,6 +364,7 @@ void kvm_mmu_reset_all_pte_masks(void)
>   	shadow_present_mask	= PT_PRESENT_MASK;
>   	shadow_acc_track_mask	= 0;
>   	shadow_me_mask		= sme_me_mask;
> +	shadow_init_value	= 0;
>   
>   	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITEABLE;
>   	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITEABLE;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index bca0ba11cccf..f88cf3db31c7 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -152,6 +152,8 @@ extern u64 __read_mostly shadow_mmio_access_mask;
>   extern u64 __read_mostly shadow_present_mask;
>   extern u64 __read_mostly shadow_me_mask;
>   
> +extern u64 __read_mostly shadow_init_value;
> +
>   /*
>    * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_MASK;
>    * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
> 

