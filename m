Return-Path: <kvm+bounces-10433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCAC86C1C5
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F5452897BA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA5044C62;
	Thu, 29 Feb 2024 07:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WsTSQUJi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F37F446A5
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 07:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191110; cv=none; b=S+5RM3ECffe/2TNiFwfk3rpJBvbLGBwNve2woWKrP1wRdyAAarGjy1oraWysDkDjJOGTrn+sjHFwDWYJGvVcGcvwn5BVP1YhFnYu2kZdted7I3HRATcgj7BpTaEkAp3qMMO8qTlnJSZd6H4+GmEw0bJNpnS0bKH/PaOJnE+VWW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191110; c=relaxed/simple;
	bh=GhixuPCJop3CQ7uM+Otpi7oYdK+2nPR9qnaYQWpKqFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=lbBXHTYSWRJ5rUI1q3kzyTGywEwnNIkkdiW177eOdaezmjyFR6Mj+Gtb4pZQuVOhNCxkjygxnjnec0cA2kzXz8TYCjO3dg3EXKjty/RIrUCirIneYog9NlFdtHmJCmaG4yEiYUbWoR7Qn0qazUCr+AFXox5woY29+b8F74RPUuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WsTSQUJi; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e55bb75c9eso482722b3a.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 23:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709191107; x=1709795907; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9OiU1uRfDNy6p1Qc40VjEVZUwgaccjvt7vZFMebCYpU=;
        b=WsTSQUJiX0/v6WW7yjfai6mBHH4CLAJSdPISYtkK5/ucy3dEnrtAj4IDcx0mPleEe4
         Lhu5WgW4/n06CJcyNH3Z/HrcsHedttgORccPVKANu1froKAAJ3DCovwHvnmFVI5An2JO
         3mGyWQDL2wlmfW9VJHl7WeuFEVeVbW1jqnT0w7wau1YxKwwoekeKNKmHNeE3fLm42EFQ
         wov8fyrQIgQjcpazLKRya83LYGdIWa3eAiGQMr/k1PpPmQwleD5ZtOziasav+VrQ9lgK
         DGapHrbgdT+5EY1WBQxYA/tUDpVizoRfBDrVINGvE+nR/tDVgb3jPJkZyMa9+PNUYaSt
         hSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709191107; x=1709795907;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9OiU1uRfDNy6p1Qc40VjEVZUwgaccjvt7vZFMebCYpU=;
        b=Yk4fBFzKbBKTjWKfiqVB7p+FenrsuEdEJj50FET8anHXsBoIxwnfNRv8y1EwfRPC4r
         Ml52UbuYdAnvzIaCJISz9c6/yvyKimpTOFWGPvR8GMUFAISUDOuOSH8aX5aUrHaMqKrw
         tFBAfwFPEw5C+gMtGik/MW32v+wC7EO4cvo+LxtzMawcKnU+9kPD5FuIyo+mUk6Z5NHR
         hieH+y7oVFXmy7xi1FWRsWEawKgehI6qfMQNNhjFrnk2SOtOQFakpBUQmmUOxQhCq9R1
         j23OWoGaDChxbrePQxPPXtoW72wrTwHcVnMhE7wExS+es8gmPX0gO1v4FNQiTHMjh7sK
         nkBg==
X-Forwarded-Encrypted: i=1; AJvYcCUijzU9fMjZ1ifv07lyh9sBUmZNbMBvU6yIPfdgdnymArzLkOKkS6aUa4QABOI8GUGoTuccyweFXzdAmgZoSHqQ4eVi
X-Gm-Message-State: AOJu0YyC4PSVUJsTI1fPGDTY0+hNWBdFdXPBPyQ6atEeVPn0znRb1Vz3
	q9cwvpEp2x2yAYZoi7jW4WE6soe8oOSHBCNLMzYXOyzrRfEorvKU
X-Google-Smtp-Source: AGHT+IGM3tk8lccJHdNW/8EHkLQcqTsdRYggB5m5PHY4ZgJhxkvmfv6t9Lb0tek7+UgYAYKKr/cCvw==
X-Received: by 2002:a05:6a21:2d84:b0:1a0:e128:60ad with SMTP id ty4-20020a056a212d8400b001a0e12860admr1681134pzb.46.1709191107519;
        Wed, 28 Feb 2024 23:18:27 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090aeb0400b0029b03b78cbesm1142712pjz.18.2024.02.28.23.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 23:18:27 -0800 (PST)
Message-ID: <1d75dfb0-63c2-46a5-bdac-d2164664820a@gmail.com>
Date: Thu, 29 Feb 2024 15:18:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/21] KVM: pfncache: remove KVM_GUEST_USES_PFN usage
Content-Language: en-US
To: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>
References: <20240215152916.1158-1-paul@xen.org>
 <20240215152916.1158-6-paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
 kvm@vger.kernel.org
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20240215152916.1158-6-paul@xen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/2/2024 11:29 pm, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> As noted in [1] the KVM_GUEST_USES_PFN usage flag is never set by any
> callers of kvm_gpc_init(), which also makes the 'vcpu' argument redundant.
> Moreover, all existing callers specify KVM_HOST_USES_PFN so the usage
> check in hva_to_pfn_retry() and hence the 'usage' argument to
> kvm_gpc_init() are also redundant.
> Remove the pfn_cache_usage enumeration and remove the redundant arguments,
> fields of struct gfn_to_hva_cache, and all the related code.
> 
> [1] https://lore.kernel.org/all/ZQiR8IpqOZrOpzHC@google.com/
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: x86@kernel.org
> 
> v8:
>   - New in this version.
> ---
>   arch/x86/kvm/x86.c        |  2 +-
>   arch/x86/kvm/xen.c        | 14 ++++-----
>   include/linux/kvm_host.h  | 11 +------
>   include/linux/kvm_types.h |  8 -----
>   virt/kvm/pfncache.c       | 61 ++++++---------------------------------
>   5 files changed, 16 insertions(+), 80 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 16269430006f..31cd5d803dae 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12042,7 +12042,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.regs_avail = ~0;
>   	vcpu->arch.regs_dirty = ~0;
>   
> -	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm, vcpu, KVM_HOST_USES_PFN);
> +	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm);
>   
>   	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
>   		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 2d001a9c6378..e90464225467 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -2108,14 +2108,10 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
>   
>   	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
>   
> -	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm, NULL,
> -		     KVM_HOST_USES_PFN);
> -	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache, vcpu->kvm, NULL,
> -		     KVM_HOST_USES_PFN);
> -	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm, NULL,
> -		     KVM_HOST_USES_PFN);
> -	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache, vcpu->kvm, NULL,
> -		     KVM_HOST_USES_PFN);
> +	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm);
> +	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache, vcpu->kvm);
> +	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm);
> +	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache, vcpu->kvm);
>   }
>   
>   void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
> @@ -2158,7 +2154,7 @@ void kvm_xen_init_vm(struct kvm *kvm)
>   {
>   	mutex_init(&kvm->arch.xen.xen_lock);
>   	idr_init(&kvm->arch.xen.evtchn_ports);
> -	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN);
> +	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm);
>   }
>   
>   void kvm_xen_destroy_vm(struct kvm *kvm)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5a27b4389d32..da20b7018cc8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1318,21 +1318,12 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
>    *
>    * @gpc:	   struct gfn_to_pfn_cache object.
>    * @kvm:	   pointer to kvm instance.
> - * @vcpu:	   vCPU to be used for marking pages dirty and to be woken on
> - *		   invalidation.
> - * @usage:	   indicates if the resulting host physical PFN is used while
> - *		   the @vcpu is IN_GUEST_MODE (in which case invalidation of
> - *		   the cache from MMU notifiers---but not for KVM memslot
> - *		   changes!---will also force @vcpu to exit the guest and
> - *		   refresh the cache); and/or if the PFN used directly
> - *		   by KVM (and thus needs a kernel virtual mapping).
>    *
>    * This sets up a gfn_to_pfn_cache by initializing locks and assigning the
>    * immutable attributes.  Note, the cache must be zero-allocated (or zeroed by
>    * the caller before init).
>    */
> -void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
> -		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage);
> +void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm);
>   
>   /**
>    * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 9d1f7835d8c1..d93f6522b2c3 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -49,12 +49,6 @@ typedef u64            hfn_t;
>   
>   typedef hfn_t kvm_pfn_t;
>   
> -enum pfn_cache_usage {
> -	KVM_GUEST_USES_PFN = BIT(0),
> -	KVM_HOST_USES_PFN  = BIT(1),
> -	KVM_GUEST_AND_HOST_USE_PFN = KVM_GUEST_USES_PFN | KVM_HOST_USES_PFN,
> -};
> -
>   struct gfn_to_hva_cache {
>   	u64 generation;
>   	gpa_t gpa;
> @@ -69,13 +63,11 @@ struct gfn_to_pfn_cache {
>   	unsigned long uhva;
>   	struct kvm_memory_slot *memslot;
>   	struct kvm *kvm;
> -	struct kvm_vcpu *vcpu;
>   	struct list_head list;
>   	rwlock_t lock;
>   	struct mutex refresh_lock;
>   	void *khva;
>   	kvm_pfn_t pfn;
> -	enum pfn_cache_usage usage;
>   	bool active;
>   	bool valid;
>   };
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index f3571f44d9af..6f4b537eb25b 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -25,9 +25,7 @@
>   void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
>   				       unsigned long end, bool may_block)
>   {
> -	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>   	struct gfn_to_pfn_cache *gpc;
> -	bool evict_vcpus = false;
>   
>   	spin_lock(&kvm->gpc_lock);
>   	list_for_each_entry(gpc, &kvm->gpc_list, list) {
> @@ -37,43 +35,10 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
>   		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
>   		    gpc->uhva >= start && gpc->uhva < end) {
>   			gpc->valid = false;
> -
> -			/*
> -			 * If a guest vCPU could be using the physical address,
> -			 * it needs to be forced out of guest mode.
> -			 */
> -			if (gpc->usage & KVM_GUEST_USES_PFN) {
> -				if (!evict_vcpus) {
> -					evict_vcpus = true;
> -					bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
> -				}
> -				__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
> -			}
>   		}
>   		write_unlock_irq(&gpc->lock);
>   	}
>   	spin_unlock(&kvm->gpc_lock);
> -
> -	if (evict_vcpus) {
> -		/*
> -		 * KVM needs to ensure the vCPU is fully out of guest context
> -		 * before allowing the invalidation to continue.
> -		 */
> -		unsigned int req = KVM_REQ_OUTSIDE_GUEST_MODE;
> -		bool called;
> -
> -		/*
> -		 * If the OOM reaper is active, then all vCPUs should have
> -		 * been stopped already, so perform the request without
> -		 * KVM_REQUEST_WAIT and be sad if any needed to be IPI'd.
> -		 */
> -		if (!may_block)
> -			req &= ~KVM_REQUEST_WAIT;
> -
> -		called = kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap);
> -
> -		WARN_ON_ONCE(called && !may_block);

Starting with this change, the incoming parameter 'bool may_block' is no
longer needed. Please double check if this change is expected and if it is
worth cleaning up or leave it as it is for potential new code.

> -	}
>   }
>   
>   bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
> @@ -206,16 +171,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>   		 * pfn.  Note, kmap() and memremap() can both sleep, so this
>   		 * too must be done outside of gpc->lock!
>   		 */
> -		if (gpc->usage & KVM_HOST_USES_PFN) {
> -			if (new_pfn == gpc->pfn)
> -				new_khva = old_khva;
> -			else
> -				new_khva = gpc_map(new_pfn);
> -
> -			if (!new_khva) {
> -				kvm_release_pfn_clean(new_pfn);
> -				goto out_error;
> -			}
> +		if (new_pfn == gpc->pfn)
> +			new_khva = old_khva;
> +		else
> +			new_khva = gpc_map(new_pfn);
> +
> +		if (!new_khva) {
> +			kvm_release_pfn_clean(new_pfn);
> +			goto out_error;
>   		}
>   
>   		write_lock_irq(&gpc->lock);
> @@ -346,18 +309,12 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
>   	return __kvm_gpc_refresh(gpc, gpc->gpa, len);
>   }
>   
> -void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
> -		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage)
> +void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
>   {
> -	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
> -	WARN_ON_ONCE((usage & KVM_GUEST_USES_PFN) && !vcpu);
> -
>   	rwlock_init(&gpc->lock);
>   	mutex_init(&gpc->refresh_lock);
>   
>   	gpc->kvm = kvm;
> -	gpc->vcpu = vcpu;
> -	gpc->usage = usage;
>   	gpc->pfn = KVM_PFN_ERR_FAULT;
>   	gpc->uhva = KVM_HVA_ERR_BAD;
>   }

