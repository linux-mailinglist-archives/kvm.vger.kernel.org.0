Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB633882F1
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 01:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352837AbhERXFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 19:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352832AbhERXFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 19:05:38 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B209FC061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 16:04:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s19so6296335pfe.8
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 16:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mSnep0E6p740HwmxCoTsibVSy/5YhYtyFAmCVDEAaLA=;
        b=Akkz5CURmoJcRlEXLzqx1M5h7Hp2+Ve7uVqZaCwDi9WcE2h/XN4698GPVVGax7o+dB
         W3kEhApCTEEMW8g0u6pSYHI4SCP8sMBdTo3+RUKx8Q/DxqDuhi6RAr8Vj2HbMmscllXZ
         U3wgtYLjloxYJzgWz/FWbGyDFd0m7J1RgIhUbCkix/9b3sCNXRY8PdLa7+j/F423XEKa
         9oO6JsspTSOKgBVsG7NhZ5rqkx7k9ydyVYZ+tsu1/2c5fUl76sLP5vChWa2yD6i5+y9s
         jKNVXhlqbDVbiJqcueJ2PTPuKJIliWYjUM0E+j00NKk2wsfcjXtSfIRdfAJgP2s8ZwzL
         0XSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mSnep0E6p740HwmxCoTsibVSy/5YhYtyFAmCVDEAaLA=;
        b=bY0j6h2L+HOpMs9xooTSj/V0L9FCfb5EOK1Lq1zbNIUHJN246FMZsBNURvS9lazkSX
         Flk5BwWCkB1RsysGGW8zEJXgHrXeuMQoYDYBfYl4xXKVzhly8rLl9BGcB2t7Cx3XMxbj
         uUYQHK/6c8vRyeV2nSxVrwr+DtAp0Z/aSscA+Ti+3MggnGmwj7TB9e8yd6hJaWRTi8zg
         D2mjubro4uP0bzdNgagpCJD328ByEga1AECsoEGBGS+u7gJlxx7WSGXfYYbuUM7upHrc
         TFAqsByNzLIPMl1ivHdE4DIzk4+361LtgApevcJakfR+IqLLCBbb1g4X9uvAyW+YuQ7+
         Mqnw==
X-Gm-Message-State: AOAM530mPbrxejMS7ghNFVZMixRWugpClcoi/dmQxo8N6vPL5xARnQzO
        EwP5kpccZoiWgb6qFTiLoxrNpA==
X-Google-Smtp-Source: ABdhPJwmhbK3o/picrfTp8QXUtTamx591kpVEksxVbdNg7OCnAY3fgc79GACPhEtTlN2lePA+3zroQ==
X-Received: by 2002:a63:2542:: with SMTP id l63mr7622151pgl.128.1621379059000;
        Tue, 18 May 2021 16:04:19 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g19sm8007685pfj.138.2021.05.18.16.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 16:04:18 -0700 (PDT)
Date:   Tue, 18 May 2021 23:04:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ilias Stamatis <ilstam@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH v2 03/10] KVM: X86: Add kvm_scale_tsc_l1() and
 kvm_compute_tsc_offset_l1()
Message-ID: <YKRH7qVHpow6kwi5@google.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
 <20210512150945.4591-4-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512150945.4591-4-ilstam@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Ilias Stamatis wrote:
> The existing kvm_scale_tsc() scales the TSC using the current TSC
> scaling ratio. That used to be the same as L1's scaling ratio but now
> with nested TSC scaling support it is no longer the case.
> 
> This patch adds a new kvm_scale_tsc_l1() function that scales the TSC
> using L1's scaling ratio. The existing kvm_scale_tsc() can still be used
> for scaling L2 TSC values.
> 
> Additionally, this patch renames the kvm_compute_tsc_offset() function
> to kvm_compute_tsc_offset_l1() and has the function treat its TSC
> argument as an L1 TSC value. All existing code uses this function
> passing L1 values to it.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 41 ++++++++++++++++++++++-----------
>  2 files changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7dfc609eacd6..be59197e5eb7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1789,6 +1789,7 @@ static inline bool kvm_is_supported_user_return_msr(u32 msr)
>  }
>  
>  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
> +u64 kvm_scale_tsc_l1(struct kvm_vcpu *vcpu, u64 tsc);
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);

I don't really care which version is used, but we should be consistent, i.e. choose
kvm_<action>_tsc_l1 or kvm_<action>_tsc_l1, not both.  The easy choice is the
former since it's already there.

>  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 07cf5d7ece38..84af1af7a2cc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2319,18 +2319,30 @@ u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
>  }
>  EXPORT_SYMBOL_GPL(kvm_scale_tsc);
>  
> -static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
> +u64 kvm_scale_tsc_l1(struct kvm_vcpu *vcpu, u64 tsc)
> +{
> +	u64 _tsc = tsc;
> +	u64 ratio = vcpu->arch.l1_tsc_scaling_ratio;
> +
> +	if (ratio != kvm_default_tsc_scaling_ratio)
> +		_tsc = __scale_tsc(ratio, tsc);
> +
> +	return _tsc;
> +}

Just make the ratio a param.  This is complete copy+paste of kvm_scale_tsc(),
with 3 characters added.  And all of the callers are already in an L1-specific
function or have L1 vs. L2 awareness.  IMO, that makes the code less magical, too,
as I don't have to dive into a helper to see that it reads l1_tsc_scaling_ratio
versus tsc_scaling_ratio.

> +EXPORT_SYMBOL_GPL(kvm_scale_tsc_l1);
> +
> +static u64 kvm_compute_tsc_offset_l1(struct kvm_vcpu *vcpu, u64 target_tsc)
>  {
>  	u64 tsc;
>  
> -	tsc = kvm_scale_tsc(vcpu, rdtsc());
> +	tsc = kvm_scale_tsc_l1(vcpu, rdtsc());
>  
>  	return target_tsc - tsc;
>  }
>  
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
>  {
> -	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
> +	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc_l1(vcpu, host_tsc);
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
>  
> @@ -2363,7 +2375,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	bool synchronizing = false;
>  
>  	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> -	offset = kvm_compute_tsc_offset(vcpu, data);
> +	offset = kvm_compute_tsc_offset_l1(vcpu, data);
>  	ns = get_kvmclock_base_ns();
>  	elapsed = ns - kvm->arch.last_tsc_nsec;
>  
> @@ -2402,7 +2414,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  		} else {
>  			u64 delta = nsec_to_cycles(vcpu, elapsed);
>  			data += delta;
> -			offset = kvm_compute_tsc_offset(vcpu, data);
> +			offset = kvm_compute_tsc_offset_l1(vcpu, data);
>  		}
>  		matched = true;
>  		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
> @@ -2463,7 +2475,7 @@ static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
>  {
>  	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
>  		WARN_ON(adjustment < 0);
> -	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment);
> +	adjustment = kvm_scale_tsc_l1(vcpu, (u64) adjustment);
>  	adjust_tsc_offset_guest(vcpu, adjustment);
>  }
>  
> @@ -2846,7 +2858,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	/* With all the info we got, fill in the values */
>  
>  	if (kvm_has_tsc_control)
> -		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz);
> +		tgt_tsc_khz = kvm_scale_tsc_l1(v, tgt_tsc_khz);
>  
>  	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
>  		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
> @@ -3235,7 +3247,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (msr_info->host_initiated) {
>  			kvm_synchronize_tsc(vcpu, data);
>  		} else {
> -			u64 adj = kvm_compute_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
> +			u64 adj = kvm_compute_tsc_offset_l1(vcpu, data) - vcpu->arch.l1_tsc_offset;
>  			adjust_tsc_offset_guest(vcpu, adj);
>  			vcpu->arch.ia32_tsc_adjust_msr += adj;
>  		}
> @@ -3537,10 +3549,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 * return L1's TSC value to ensure backwards-compatible
>  		 * behavior for migration.
>  		 */
> -		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
> -							    vcpu->arch.tsc_offset;
> -
> -		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
> +		if (msr_info->host_initiated) {

Unnecessary curly braces.

> +			msr_info->data = kvm_scale_tsc_l1(vcpu, rdtsc()) +
> +					 vcpu->arch.l1_tsc_offset;
> +		} else {
> +			msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) +
> +					 vcpu->arch.tsc_offset;
> +		}
>  		break;
>  	}
>  	case MSR_MTRRcap:
> @@ -4123,7 +4138,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  			mark_tsc_unstable("KVM discovered backwards TSC");
>  
>  		if (kvm_check_tsc_unstable()) {
> -			u64 offset = kvm_compute_tsc_offset(vcpu,
> +			u64 offset = kvm_compute_tsc_offset_l1(vcpu,
>  						vcpu->arch.last_guest_tsc);
>  			kvm_vcpu_write_tsc_offset(vcpu, offset);
>  			vcpu->arch.tsc_catchup = 1;
> -- 
> 2.17.1
> 
