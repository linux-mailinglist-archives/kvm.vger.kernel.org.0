Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CDD358AE3
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhDHRIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHRIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 13:08:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6873AC061762
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 10:08:34 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id ay2so1387628plb.3
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 10:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lQ5FJuYAdemeQPR+BYJiVntd5fDu24NRSQN06r03aP4=;
        b=PBUU8Eag8Z8PXgTEmQcMaob7vxEJ7RtBcR3bdNaaNS1eB8n2lyXIyGH3hopYnFORoC
         h59cs9nf5xrWkQPffxCF3q4CsmqjFxRZFqhNMd8x+IEVDz4UE5fYB0v4H9r0LgYkejSJ
         ApTaviquOiS0H4Kj8z32bmUgOMDsydV3UXLqzAw+4neaHyyfeutIIEydbIJ9vnSoF/QM
         UQOGsaRqTFL0DmxmAiWFC7Bwlo8sm0UjGiNPd3W11BAidGxezBLXT2fPb3WrFz4eOh6R
         u+Pw6oC8sdzKlAeYTFbVjjPxmERS3p2fOUOB0GHznaFFGopCum3lIWIG8YsaiX9bgOIv
         gPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lQ5FJuYAdemeQPR+BYJiVntd5fDu24NRSQN06r03aP4=;
        b=GjSAnPKP4Gd6yJKqb82iKXpJMY98mm2mDKlfVDsh6Qk8N4JEKroopSitdS/KZeCZJ+
         lzWKiJlsNsDCokd8WpKEzWJoI6eu0h97Hlj64tKDS3TRHC4facCreqeQUjWtlMVWKSTv
         QFAJ9oFLO5BH5ddDkU063vxUFXuNUvHFywu1Ku7f1vWPk62DBJnInWTRBO0wKempADW4
         7C9nIhbi85C+wahg0i7Hsz6rLTEEqPM+12y5DpZhLGdEruUr1ZHT2jcny44FG4Cynv5V
         C3PlCHItWw62x0RfgWXHCiZyckRi5OUkl7+/DpgaeZukyLAfqA3DujERlhoW9IDqp9SU
         a8ag==
X-Gm-Message-State: AOAM533fKf0iKVFnl9cSS1XiLFOEsTYBggmQ7uA/2RBtQZviu40QuGes
        5p1mw0fvfFzzxUJIDODFBJ87WqdrV0TQ2Q==
X-Google-Smtp-Source: ABdhPJw8KnyPE7BnHv+dlRLx0x6/4c3hMDSJ0Czjq4vcCGNe5ukTcT4cLyJ4wWVZ20eyz5Lozlbogw==
X-Received: by 2002:a17:902:9a0a:b029:e6:bf00:8a36 with SMTP id v10-20020a1709029a0ab02900e6bf008a36mr8702094plp.51.1617901713728;
        Thu, 08 Apr 2021 10:08:33 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x9sm53062pfd.158.2021.04.08.10.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 10:08:33 -0700 (PDT)
Date:   Thu, 8 Apr 2021 17:08:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: X86: Count success and invalid yields
Message-ID: <YG84jSpRtgfhWaiw@google.com>
References: <1617697935-4158-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617697935-4158-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> To analyze some performance issues with lock contention and scheduling,
> it is nice to know when directed yield are successful or failing.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/x86.c              | 26 ++++++++++++++++++++------
>  2 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 44f8930..157bcaa 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1126,6 +1126,8 @@ struct kvm_vcpu_stat {
>  	u64 halt_poll_success_ns;
>  	u64 halt_poll_fail_ns;
>  	u64 nested_run;
> +	u64 yield_directed;
> +	u64 yield_directed_ignore;
>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 16fb395..3b475cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -246,6 +246,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
>  	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
>  	VCPU_STAT("nested_run", nested_run),
> +	VCPU_STAT("yield_directed", yield_directed),

This is ambiguous, it's not clear without looking at the code if it's counting
attempts or actual yields.

> +	VCPU_STAT("yield_directed_ignore", yield_directed_ignore),

"ignored" also feels a bit misleading, as that implies KVM deliberately ignored
a valid request, whereas many of the failure paths are due to invalid requests
or errors of some kind.

What about mirroring the halt poll stats, i.e. track "attempted" and "successful",
as opposed to "attempted" and "ignored/failed".    And maybe switched directed
and yield?  I.e. directed_yield_attempted and directed_yield_successful.

Alternatively, would it make sense to do s/directed/pv, or is that not worth the
potential risk of being wrong if a non-paravirt use case comes along?

	pv_yield_attempted
	pv_yield_successful

>  	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
>  	VM_STAT("mmu_pte_write", mmu_pte_write),
>  	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
> @@ -8211,21 +8213,33 @@ void kvm_apicv_init(struct kvm *kvm, bool enable)
>  }
>  EXPORT_SYMBOL_GPL(kvm_apicv_init);
>  
> -static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
> +static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>  {
>  	struct kvm_vcpu *target = NULL;
>  	struct kvm_apic_map *map;
>  
> +	vcpu->stat.yield_directed++;
> +
>  	rcu_read_lock();
> -	map = rcu_dereference(kvm->arch.apic_map);
> +	map = rcu_dereference(vcpu->kvm->arch.apic_map);
>  
>  	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
>  		target = map->phys_map[dest_id]->vcpu;
>  
>  	rcu_read_unlock();
> +	if (!target)
> +		goto no_yield;
> +
> +	if (!READ_ONCE(target->ready))

I vote to keep these checks together.  That'll also make the addition of the
"don't yield to self" check match the order of ready vs. self in kvm_vcpu_on_spin().

	if (!target || !READ_ONCE(target->ready))

> +		goto no_yield;
>  
> -	if (target && READ_ONCE(target->ready))
> -		kvm_vcpu_yield_to(target);
> +	if (kvm_vcpu_yield_to(target) <= 0)
> +		goto no_yield;
> +	return;
> +
> +no_yield:
> +	vcpu->stat.yield_directed_ignore++;
> +	return;
>  }
>  
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> @@ -8272,7 +8286,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  			break;
>  
>  		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
> -		kvm_sched_yield(vcpu->kvm, a1);
> +		kvm_sched_yield(vcpu, a1);
>  		ret = 0;
>  		break;
>  #ifdef CONFIG_X86_64
> @@ -8290,7 +8304,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED_YIELD))
>  			break;
>  
> -		kvm_sched_yield(vcpu->kvm, a0);
> +		kvm_sched_yield(vcpu, a0);
>  		ret = 0;
>  		break;
>  	default:
> -- 
> 2.7.4
> 
