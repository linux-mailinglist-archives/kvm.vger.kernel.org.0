Return-Path: <kvm+bounces-27794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A37998C803
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 00:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17C72B20D2B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 22:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099141CEE9C;
	Tue,  1 Oct 2024 22:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IEF0QXML"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8676A199FCF
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 22:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727821027; cv=none; b=OFjGHDR0uCIz6kpbup0ZfKAJ27o36JlcpOr3xBFJzl4xON4RO2FUV4Tjwi205Tx4C14fyCJOgOMvBs3zDZ4wXFwgibQ0U/9uf3mIG+m7ZlEk5ghm3Y92lVnGi+FHQ07klNM9WVrmHivxZU6IyZTfnn6GcLXbqNpMCOnVj3/gtTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727821027; c=relaxed/simple;
	bh=aUycHbqaI1GxiTXNAuLFzydIxxDE2ASlSYxOxFOpKmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ja+7wd2+kWeGDjqAJnp9oxgbHzFkEhfpGY9QbHpHJHUlq243YWkOO/T+lu5fSyfyVQm6/Uo3uK4Y8ma+UxSYdNDZkXzOzmJh7jMV/h8CE3mj3mOUjflK7d7Za/HBRfPHUV+VOS/akG5K9yzpzO6aklX+Mkw4774RHz1DBvMpGNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IEF0QXML; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71db62281aeso204527b3a.0
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 15:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727821024; x=1728425824; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FSwzDsaIMy9+ZyD0fmi1eb2qHMifMlGySR6mVsA4DyE=;
        b=IEF0QXML//ylGfHiiEuQ7h2LzUOoWk4YxR3HjuyFPk1VicoDkO11pxSwG7wdbM+w1t
         HfxGJ7tFz6TjQUetgI+uZ+GCiRKoyzdwBQd2p99imJ6COYVKB1kOVBL/Vru3Z/d1CXRk
         O+SRST87cYxzymV/AiiE/e3ZlHOAXfOz+Z6RCWjbBI3fDASy07HiArv0wz9gX3o+gDxl
         LlaOXhmBpFyyFz1iBxB9Ia21s59nDMUqJkVXssF2iyLbZoNXOu0CUBuQO4XUbpzSl8QR
         dJQl1nvI39Jjp/o3yegYYq+UbRLJu3jKS94v5ZU61SmGbmvrLSrVQpzjs3rqoTNv8INb
         3eEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727821024; x=1728425824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FSwzDsaIMy9+ZyD0fmi1eb2qHMifMlGySR6mVsA4DyE=;
        b=iyJJFXSgGMrXcu06NG4ss9/gget4wZQ76p8SK8rs5ZsIxD2ro/1yshwoJjXUt5xOM8
         V9oTtRjJ4QWam24l4JLTnL4FwGmEsgwAF7adlNgeT87ezmU1UiukhqcUyK9UYh1I3HwX
         AnWs+uYJFx6gYy98mcd6gY2jCzVqavua7VRFeuH82D6VenZXvqTgw8CMk6bVa53Dm86a
         oreMvu8syd8Poi33HEWy/fkLqXAZPfiLdR8G64rO+GU24q0xTxjYzSZB3GlVo7chtdpg
         0yMs002YoTZ2x7Kymu29SIstIP8X2lPp+xttox96VtZSKizqoJMoyCkVWo+kArBmx66L
         WtQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVINebxELbD/EKe8VUyOOiJepfq/mkbIwrzhaCjlxEpYuzz3x4t73HI5aTjE8bkW8MNrxY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ1bxc4MebZ6Qj86lc5cWn3UTl3dHfafo2EsAkaDUAoFeRWsO3
	YEz9NlZyzbkDqMGbKutczrnH/owYRq6XJ4testMMMKk7yfFxCN5J3tMKcGLuZA==
X-Google-Smtp-Source: AGHT+IEwweHTjwunyGCO7vEqdEao2XuJo6kPSMJhifYwsVemZvbeHHj398MLBV6ASijYoj8B0VDfYg==
X-Received: by 2002:a05:6a00:66cc:b0:717:98e7:3d0 with SMTP id d2e1a72fcca58-71db787e996mr8161121b3a.0.1727821023427;
        Tue, 01 Oct 2024 15:17:03 -0700 (PDT)
Received: from google.com (46.242.125.34.bc.googleusercontent.com. [34.125.242.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26518a2asm8617710b3a.107.2024.10.01.15.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 15:17:02 -0700 (PDT)
Date: Tue, 1 Oct 2024 15:16:58 -0700
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, zhi.wang.linux@gmail.com,
	weijiang.yang@intel.com, mizhang@google.com,
	liangchen.linux@gmail.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU
 memory caches
Message-ID: <Zvx02r8XjllG7oI_@google.com>
References: <20240913214316.1945951-1-vipinsh@google.com>
 <20240913214316.1945951-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913214316.1945951-3-vipinsh@google.com>

On 2024-09-13 02:43 PM, Vipin Sharma wrote:
> Use MMU shrinker to iterate through all the vCPUs of all the VMs and
> free pages allocated in MMU memory caches. Protect cache allocation in
> page fault and MMU load path from MMU shrinker by using a per vCPU
> mutex. In MMU shrinker, move the iterated VM to the end of the VMs list
> so that the pain of emptying cache spread among other VMs too.
> 
> The specific caches to empty are mmu_shadow_page_cache and
> mmu_shadowed_info_cache as these caches store whole pages. Emptying them
> will give more impact to shrinker compared to other caches like
> mmu_pte_list_desc_cache{} and mmu_page_header_cache{}
> 
> Holding per vCPU mutex lock ensures that a vCPU doesn't get surprised
> by finding its cache emptied after filling them up for page table
> allocations during page fault handling and MMU load operation. Per vCPU
> mutex also makes sure there is only race between MMU shrinker and all
> other vCPUs. This should result in very less contention.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 +++
>  arch/x86/kvm/mmu/mmu.c          | 69 +++++++++++++++++++++++++++------
>  arch/x86/kvm/mmu/paging_tmpl.h  | 14 ++++---
>  include/linux/kvm_host.h        |  1 +
>  virt/kvm/kvm_main.c             |  8 +++-
>  5 files changed, 81 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cbfe31bac6cf..63eaf03111eb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -811,6 +811,12 @@ struct kvm_vcpu_arch {
>  	 */
>  	struct kvm_mmu *walk_mmu;
>  
> +	/*
> +	 * Protect cache from getting emptied in MMU shrinker while vCPU might
> +	 * use cache for fault handling or loading MMU.  As this is a per vCPU
> +	 * lock, only contention might happen when MMU shrinker runs.
> +	 */
> +	struct mutex mmu_memory_cache_lock;
>  	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 213e46b55dda..8e2935347615 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4524,29 +4524,33 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (r != RET_PF_INVALID)
>  		return r;
>  
> +	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
>  	r = mmu_topup_memory_caches(vcpu, false);
>  	if (r)
> -		return r;
> +		goto out_mmu_memory_cache_unlock;
>  
>  	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
>  	if (r != RET_PF_CONTINUE)
> -		return r;
> +		goto out_mmu_memory_cache_unlock;
>  
>  	r = RET_PF_RETRY;
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = direct_map(vcpu, fault);
>  
> -out_unlock:
> +out_mmu_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  	kvm_release_pfn_clean(fault->pfn);
> +out_mmu_memory_cache_unlock:
> +	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
> +
>  	return r;
>  }
>  
> @@ -4617,25 +4621,28 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  	if (r != RET_PF_INVALID)
>  		return r;
>  
> +	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
>  	r = mmu_topup_memory_caches(vcpu, false);
>  	if (r)
> -		return r;
> +		goto out_mmu_memory_cache_unlock;
>  
>  	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
>  	if (r != RET_PF_CONTINUE)
> -		return r;
> +		goto out_mmu_memory_cache_unlock;
>  
>  	r = RET_PF_RETRY;
>  	read_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = kvm_tdp_mmu_map(vcpu, fault);
>  
> -out_unlock:
> +out_mmu_unlock:
>  	read_unlock(&vcpu->kvm->mmu_lock);
>  	kvm_release_pfn_clean(fault->pfn);
> +out_mmu_memory_cache_unlock:
> +	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
>  	return r;
>  }
>  #endif
> @@ -5691,6 +5698,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  {
>  	int r;
>  
> +	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
>  	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
>  	if (r)
>  		goto out;
> @@ -5717,6 +5725,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	 */
>  	kvm_x86_call(flush_tlb_current)(vcpu);
>  out:
> +	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
>  	return r;
>  }
>  
> @@ -6303,6 +6312,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
>  		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>  
> +	mutex_init(&vcpu->arch.mmu_memory_cache_lock);
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
>  
> @@ -6997,13 +7007,50 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
>  static unsigned long mmu_shrink_scan(struct shrinker *shrink,
>  				     struct shrink_control *sc)
>  {
> -	return SHRINK_STOP;
> +	struct kvm *kvm, *next_kvm, *first_kvm = NULL;
> +	unsigned long i, freed = 0;
> +	struct kvm_vcpu *vcpu;
> +
> +	mutex_lock(&kvm_lock);
> +	list_for_each_entry_safe(kvm, next_kvm, &vm_list, vm_list) {
> +		if (!first_kvm)
> +			first_kvm = kvm;
> +		else if (first_kvm == kvm)
> +			break;
> +
> +		list_move_tail(&kvm->vm_list, &vm_list);
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			if (!mutex_trylock(&vcpu->arch.mmu_memory_cache_lock))
> +				continue;
> +			freed += kvm_mmu_empty_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +			freed += kvm_mmu_empty_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> +			mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
> +			if (freed >= sc->nr_to_scan)
> +				goto out;

Looking at the caller in mm/shrinker.c, sc->nr_to_scan will be <= 128
(SHRINK_BATCH), which is only enough for 2 vCPUs. So I think the
shrinker will only ever free 2 vCPU caches of each VM (probably the
first 2 vCPUs) before reordering the list and moving onto the next VM on
the next call.

Does that match the behavior you observe?

> +		}
> +	}
> +out:
> +	mutex_unlock(&kvm_lock);
> +	return freed;
>  }
>  
>  static unsigned long mmu_shrink_count(struct shrinker *shrink,
>  				      struct shrink_control *sc)
>  {
> -	return SHRINK_EMPTY;
> +	unsigned long i, count = 0;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm *kvm;
> +
> +	mutex_lock(&kvm_lock);
> +	list_for_each_entry(kvm, &vm_list, vm_list) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			count += READ_ONCE(vcpu->arch.mmu_shadow_page_cache.nobjs);
> +			count += READ_ONCE(vcpu->arch.mmu_shadowed_info_cache.nobjs);
> +		}
> +	}
> +	mutex_unlock(&kvm_lock);
> +	return !count ? SHRINK_EMPTY : count;
>  }
>  
>  static struct shrinker *mmu_shrinker;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 405bd7ceee2a..084a5c532078 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -809,13 +809,14 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  		return RET_PF_EMULATE;
>  	}
>  
> +	mutex_lock(&vcpu->arch.mmu_memory_cache_lock);
>  	r = mmu_topup_memory_caches(vcpu, true);
>  	if (r)
> -		return r;
> +		goto out_mmu_memory_cache_unlock;
>  
>  	r = kvm_faultin_pfn(vcpu, fault, walker.pte_access);
>  	if (r != RET_PF_CONTINUE)
> -		return r;
> +		goto out_mmu_memory_cache_unlock;
>  
>  	/*
>  	 * Do not change pte_access if the pfn is a mmio page, otherwise
> @@ -840,16 +841,19 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	if (is_page_fault_stale(vcpu, fault))
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
> -		goto out_unlock;
> +		goto out_mmu_unlock;
>  	r = FNAME(fetch)(vcpu, fault, &walker);
>  
> -out_unlock:
> +out_mmu_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  	kvm_release_pfn_clean(fault->pfn);
> +out_mmu_memory_cache_unlock:
> +	mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
> +
>  	return r;
>  }
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b23c6d48392f..288e503f14a0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1446,6 +1446,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
>  int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
> +int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc);
>  void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
>  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cb2b78e92910..5d89ca218791 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -451,15 +451,21 @@ int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
>  	return mc->nobjs;
>  }
>  
> -void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> +int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc)
>  {
> +	int freed = mc->nobjs;
>  	while (mc->nobjs) {
>  		if (mc->kmem_cache)
>  			kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
>  		else
>  			free_page((unsigned long)mc->objects[--mc->nobjs]);
>  	}
> +	return freed;
> +}
>  
> +void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> +{
> +	kvm_mmu_empty_memory_cache(mc);
>  	kvfree(mc->objects);
>  
>  	mc->objects = NULL;
> -- 
> 2.46.0.662.g92d0881bb0-goog
> 

