Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7078B44C5A8
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 18:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhKJRG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 12:06:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232203AbhKJRGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 12:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636563817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQBQ5GV6gdxpV3LZ1YIPdhUG1JWyAiTVUj8IYWvvfMw=;
        b=afLcOD3BhFQy8Syr3vv5idnYSn1dzEw0+usQXgrbSdxvwVZNMr+I2B7nRbyjs13c5wr5IH
        1beGPIrjdCnEb9bDgvuKUy/92yrsvUKjD5xcZBT+5DNSMeP3e53sy/cmXdp+bDUCq5wic4
        Hn/2zqY0LTgOyLUZJzNak1c3GgDcnaQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-S0VIsMH1OoSL6uxBOw_acQ-1; Wed, 10 Nov 2021 12:03:36 -0500
X-MC-Unique: S0VIsMH1OoSL6uxBOw_acQ-1
Received: by mail-wr1-f72.google.com with SMTP id y10-20020adffa4a000000b0017eea6cb05dso561315wrr.6
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 09:03:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FQBQ5GV6gdxpV3LZ1YIPdhUG1JWyAiTVUj8IYWvvfMw=;
        b=RliwSdEK9Q781q3pwp9IUFu//4TKSBZK2Xdbbm2u17I3VV8YRj5+ivrCdf76WNMgBd
         S9tvhIHWW+R43ldJGKuv9tStcepmfoGJIJIIUosBPxRQK09R895nMM4qS7Ns+RjXm1ys
         P6KCxAJu19SWgg4Nb6NihCvWq6Ak1+X7NTcebnef0SFzuIyuEKVJFM8CcB+w3jeB3srv
         AqffspsXai+nUMmv1aIZTW3PkDq13FA2UMyMtDc2lHxmu8ZeTBAIoeZxd/MrMa2UrmYS
         VMeLxIZe88sR0yac6fe83RI9btOj5tsuZmUfvx72Z0AY8fU1x1+wF9LDJCFtz/UMOIEX
         UiLQ==
X-Gm-Message-State: AOAM530KuV5oj3iSU2YXfuHq9bCKD+YJvorb5mjJBGsYVgQGf4yXq8le
        3N2AKu74jALZP5lklouKeKCHLip/LEOtXeyJo16hv50Htl1X86tQVaqIZDm9subAflYnB1PO6uJ
        6+ThJx/jhbAF6
X-Received: by 2002:adf:ce0e:: with SMTP id p14mr551581wrn.423.1636563814649;
        Wed, 10 Nov 2021 09:03:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrsIiuV6DLoUx3vhu7fe0Z8vzAwRCp5SwwfYqbhWvnsnUeDV0lvT6ihmH7onVoe32Y3qScgA==
X-Received: by 2002:adf:ce0e:: with SMTP id p14mr551532wrn.423.1636563814405;
        Wed, 10 Nov 2021 09:03:34 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p2sm6723185wmq.23.2021.11.10.09.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 09:03:33 -0800 (PST)
Subject: Re: [PATCH v4 04/15] KVM: x86: Use generic async PF slot management
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-5-gshan@redhat.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <a3b0e70a-eddd-9a85-2c9c-ba5446ac542b@redhat.com>
Date:   Wed, 10 Nov 2021 18:03:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-5-gshan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 8/15/21 2:59 AM, Gavin Shan wrote:
> This uses the generic slot management mechanism for asynchronous
Now we have moved the hash table management in the generic code, Use
this latter ...
> page fault by enabling CONFIG_KVM_ASYNC_PF_SLOT because the private
> implementation is totally duplicate to the generic one.
> 
> The changes introduced by this is pretty mechanical and shouldn't
> cause any logical changes.
suggest: No functional change intended.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 -
>  arch/x86/kvm/Kconfig            |  1 +
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              | 86 +++------------------------------
>  4 files changed, 8 insertions(+), 83 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..409c1e7137cd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -810,7 +810,6 @@ struct kvm_vcpu_arch {
>  
>  	struct {
>  		bool halted;
> -		gfn_t gfns[ASYNC_PF_PER_VCPU];
>  		struct gfn_to_hva_cache data;
>  		u64 msr_en_val; /* MSR_KVM_ASYNC_PF_EN */
>  		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
> @@ -1878,7 +1877,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
>  			       struct kvm_async_pf *work);
>  void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu);
>  bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
> -extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>  
>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
>  int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ac69894eab88..53a6ef30b6ee 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -32,6 +32,7 @@ config KVM
>  	select HAVE_KVM_IRQ_ROUTING
>  	select HAVE_KVM_EVENTFD
>  	select KVM_ASYNC_PF
> +	select KVM_ASYNC_PF_SLOT
>  	select USER_RETURN_NOTIFIER
>  	select KVM_MMIO
>  	select SCHED_INFO
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c4f4fa23320e..cd8aaa662ac2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3799,7 +3799,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  
>  	if (!prefault && kvm_can_do_async_pf(vcpu)) {
>  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
> -		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
> +		if (kvm_async_pf_find_slot(vcpu, gfn)) {
>  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
>  			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
>  			return true;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7f35d9324b99..a5f7d6122178 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -332,13 +332,6 @@ static struct kmem_cache *kvm_alloc_emulator_cache(void)
>  
>  static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
>  
> -static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
> -{
> -	int i;
> -	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
> -		vcpu->arch.apf.gfns[i] = ~0;
> -}
> -
>  static void kvm_on_user_return(struct user_return_notifier *urn)
>  {
>  	unsigned slot;
> @@ -854,7 +847,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  {
>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>  		kvm_clear_async_pf_completion_queue(vcpu);
> -		kvm_async_pf_hash_reset(vcpu);
> +		kvm_async_pf_reset_slot(vcpu);
>  	}
>  
>  	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
> @@ -3118,7 +3111,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  
>  	if (!kvm_pv_async_pf_enabled(vcpu)) {
>  		kvm_clear_async_pf_completion_queue(vcpu);
> -		kvm_async_pf_hash_reset(vcpu);
> +		kvm_async_pf_reset_slot(vcpu);
>  		return 0;
>  	}
>  
> @@ -10704,7 +10697,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
>  
> -	kvm_async_pf_hash_reset(vcpu);
> +	kvm_async_pf_reset_slot(vcpu);
>  	kvm_pmu_init(vcpu);
>  
>  	vcpu->arch.pending_external_vector = -1;
> @@ -10828,7 +10821,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	kvmclock_reset(vcpu);
>  
>  	kvm_clear_async_pf_completion_queue(vcpu);
> -	kvm_async_pf_hash_reset(vcpu);
> +	kvm_async_pf_reset_slot(vcpu);
>  	vcpu->arch.apf.halted = false;
>  
>  	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
> @@ -11737,73 +11730,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
>  }
>  
> -static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
> -{
> -	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
> -
> -	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
> -}
> -
> -static inline u32 kvm_async_pf_next_probe(u32 key)
> -{
> -	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
> -}
> -
> -static void kvm_add_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> -{
> -	u32 key = kvm_async_pf_hash_fn(gfn);
> -
> -	while (vcpu->arch.apf.gfns[key] != ~0)
> -		key = kvm_async_pf_next_probe(key);
> -
> -	vcpu->arch.apf.gfns[key] = gfn;
> -}
> -
> -static u32 kvm_async_pf_gfn_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
> -{
> -	int i;
> -	u32 key = kvm_async_pf_hash_fn(gfn);
> -
> -	for (i = 0; i < ASYNC_PF_PER_VCPU &&
> -		     (vcpu->arch.apf.gfns[key] != gfn &&
> -		      vcpu->arch.apf.gfns[key] != ~0); i++)
> -		key = kvm_async_pf_next_probe(key);
> -
> -	return key;
> -}
> -
> -bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> -{
> -	return vcpu->arch.apf.gfns[kvm_async_pf_gfn_slot(vcpu, gfn)] == gfn;
> -}
> -
> -static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> -{
> -	u32 i, j, k;
> -
> -	i = j = kvm_async_pf_gfn_slot(vcpu, gfn);
> -
> -	if (WARN_ON_ONCE(vcpu->arch.apf.gfns[i] != gfn))
> -		return;
> -
> -	while (true) {
> -		vcpu->arch.apf.gfns[i] = ~0;
> -		do {
> -			j = kvm_async_pf_next_probe(j);
> -			if (vcpu->arch.apf.gfns[j] == ~0)
> -				return;
> -			k = kvm_async_pf_hash_fn(vcpu->arch.apf.gfns[j]);
> -			/*
> -			 * k lies cyclically in ]i,j]
> -			 * |    i.k.j |
> -			 * |....j i.k.| or  |.k..j i...|
> -			 */
> -		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
> -		vcpu->arch.apf.gfns[i] = vcpu->arch.apf.gfns[j];
> -		i = j;
> -	}
> -}
> -
>  static inline int apf_put_user_notpresent(struct kvm_vcpu *vcpu)
>  {
>  	u32 reason = KVM_PV_REASON_PAGE_NOT_PRESENT;
> @@ -11867,7 +11793,7 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  	struct x86_exception fault;
>  
>  	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa);
> -	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
> +	kvm_async_pf_add_slot(vcpu, work->arch.gfn);
>  
>  	if (kvm_can_deliver_async_pf(vcpu) &&
>  	    !apf_put_user_notpresent(vcpu)) {
> @@ -11904,7 +11830,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  	if (work->wakeup_all)
>  		work->arch.token = ~0; /* broadcast wakeup */
>  	else
> -		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
> +		kvm_async_pf_remove_slot(vcpu, work->arch.gfn);
>  	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
>  
>  	if ((work->wakeup_all || work->notpresent_injected) &&
> 
Looks good to me

Eric

