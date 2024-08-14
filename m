Return-Path: <kvm+bounces-24090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C609512BE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 04:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C784B2166C
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD4332C85;
	Wed, 14 Aug 2024 02:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zYhhB9Vj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6683D18E3F
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 02:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723604300; cv=none; b=IfO0w/YjbcsYTXYGTm4LaxwDQ0lipMHCGb7UD+f6fDli14YFwwY3PtT9s3fkWkuXhtisPxy+DMW7ZCQ4krkKAQxXd8hmsW3rJZq7yp6N4PCSJxJ1pqucHdVDOYPSMh5xgdg5S6r33t3HsnFcJvaxI7LELr97e4BN5qk8nQZHKFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723604300; c=relaxed/simple;
	bh=Es5KsrEC1BxHcts1C6mDXT8TpgRA/q5oXkaroAxBcPY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mLZ36GtYgVetIFufSFRRwYFAz0CyUW4B+qO+GHmt6ABjEaE+ep6EfGaL92DEt0gQnEgvJxDZdPxBZ/aJ+SbkGzxhzfz+x9bQ1D4X5CzlszLAXnJpK1wDGB7Tb5/TTk2LMRLWdMR/wMjawWuK1WeaVv7jHTNRELmyKtvZMcQB8J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zYhhB9Vj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb68c23a00so414453a91.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 19:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723604298; x=1724209098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/TbiCqhnCvnsz9ogWMe2mKYUfm6ld6l7PiIeVapd+tc=;
        b=zYhhB9Vj27jeTFmc+wnOYR7AWhWHDZk5KkadNavhZjbMgqMaje8cqIiBoKt4x5qLv1
         geT0v2W94kvjpFHg830NPU/yOsd6YqfVLcFSeNpQa2K3Z71rPI8ssKT9xzMTFrL2K7wb
         lHPmBy72exROmEnJtmPND5HkFZyjrws+ID7ZUq8T3ArdA3CGdeRmmJsJmSAC5SduOJF6
         +zpCjE6a2KN44WBdUYFC4S0WpevuhpTVTYaQTWnZKY5DQWjPlYpKQCEfCURSeaXiYKbI
         ezb9YeTTFsS9dSgnuY9JKeX4rpBfRzdEkuv3MSryssqg3oIVdJzXeIx/5ZpCPZqCbrvv
         3HcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723604298; x=1724209098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/TbiCqhnCvnsz9ogWMe2mKYUfm6ld6l7PiIeVapd+tc=;
        b=XWeYHGGUNulAY2SKp8LcnMR2QiL9N2AhoyBm1nPj/3P42g4FXEnjOUChOKHj9JLuGs
         HFIAnOBqnwnUwSQv7TdEUAPgvbAli9nwm8OmmsWDk8PyPl764PYPi4IPLqP+hMSznHZv
         6mIIO18OfW55Wt9mn+d2RN7zkpehxCPEeGoFoajKGIoL+IMmDMDDPv02Q0m+5AN0RhLo
         AXJdTcz7HKXj5MVCtKSlAoiAkAjIwz4qWGntiAtpUqxClD+eVq6XCCtw2CZ9u55PmANx
         A/1OviCu0hxny/aTaKJNRYgCdy03b3SDk7nZMc2Sk61RZKQ+32v+w9A/OVRjnILMZN61
         Pq/Q==
X-Gm-Message-State: AOJu0Yxx4LODzgJV8RejE0JHgbjj1jtZz/pkJLmPftXujcgAwzxwV/sW
	rJya0gjZYq6cHwcdoFd1R4D6IxyyKO+67rW2PMR0oejUg3+v1/m6a4Rlxc+LlZBc3WN8vEdS3ZW
	Bjg==
X-Google-Smtp-Source: AGHT+IGAHPSVk4Du2ortUE2qCh4n0/+jkWQcVqkje8HZoyPJTj2YYbKInTjuo66+vNywSakhJZPTGE8bey4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a613:b0:2d3:96b5:4940 with SMTP id
 98e67ed59e1d1-2d3a9c67b9dmr7183a91.0.1723604297438; Tue, 13 Aug 2024 19:58:17
 -0700 (PDT)
Date: Tue, 13 Aug 2024 19:58:16 -0700
In-Reply-To: <20240522001817.619072-10-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-10-dwmw2@infradead.org>
Message-ID: <ZrwdSLvlhde6uaAB@google.com>
Subject: Re: [RFC PATCH v3 09/21] KVM: x86: Fix KVM clock precision in __get_kvmclock()
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When in 'master clock mode' (i.e. when host and guest TSCs are behaving
> sanely and in sync), the KVM clock is defined in terms of the guest TSC.
> 
> When TSC scaling is used, calculating the KVM clock directly from *host*
> TSC cycles leads to a systemic drift from the values calculated by the
> guest from its TSC.
> 
> Commit 451a707813ae ("KVM: x86/xen: improve accuracy of Xen timers")
> had a simple workaround for the specific case of Xen timers, as it had an
> actual vCPU to hand and could use its scaling information. That commit
> noted that it was broken for the general case of get_kvmclock_ns(), and
> said "I'll come back to that".
> 
> Since __get_kvmclock() is invoked without a specific CPU, it needs to
> be able to find or generate the scaling values required to perform the
> correct calculation.
> 
> Thankfully, TSC scaling can only happen with X86_FEATURE_CONSTANT_TSC,
> so it isn't as complex as it might have been.
> 
> In __kvm_synchronize_tsc(), note the current vCPU's scaling ratio in
> kvm->arch.last_tsc_scaling_ratio. That is only protected by the
> tsc_write_lock, so in pvclock_update_vm_gtod_copy(), copy it into a
> separate kvm->arch.master_tsc_scaling_ratio so that it can be accessed
> using the kvm->arch.pvclock_sc seqcount lock. Also generate the mul and
> shift factors to convert to nanoseconds for the corresponding KVM clock,
> just as kvm_guest_time_update() would.
> 
> In __get_kvmclock(), which runs within a seqcount retry loop, use those
> values to convert host to guest TSC and then to nanoseconds. Only fall
> back to using get_kvmclock_base_ns() when not in master clock mode.
> 
> There was previously a code path in __get_kvmclock() which looked like
> it could set KVM_CLOCK_TSC_STABLE without KVM_CLOCK_REALTIME, perhaps
> even on 32-bit hosts. In practice that could never happen as the
> ka->use_master_clock flag couldn't be set on 32-bit, and even on 64-bit
> hosts it would never be set when the system clock isn't TSC-based. So
> that code path is now removed.

This should be a separate patch.  Actually, patches, plural.  More below

> The kvm_get_wall_clock_epoch() function had the same problem; make it
> just call get_kvmclock() and subtract kvmclock from wallclock, with
> the same fallback as before.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---

...

> @@ -3100,36 +3131,49 @@ static unsigned long get_cpu_tsc_khz(void)
>  static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  {
>  	struct kvm_arch *ka = &kvm->arch;
> -	struct pvclock_vcpu_time_info hv_clock;
> +
> +#ifdef CONFIG_X86_64
> +	uint64_t cur_tsc_khz = 0;
> +	struct timespec64 ts;
>  
>  	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
>  	get_cpu();
>  
> -	data->flags = 0;
>  	if (ka->use_master_clock &&
> -	    (static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz))) {
> -#ifdef CONFIG_X86_64
> -		struct timespec64 ts;
> +	    (cur_tsc_khz = get_cpu_tsc_khz()) &&

That is mean.  And if you push it inside the if-statement, the {get,put}_cpu()
can be avoided when the master clock isn't being used, e.g.

	if (ka->use_master_clock) {
		/*
		 * The RDTSC needs to happen on the same CPU whose frequency is
		 * used to compute kvmclock's time.
		 */
		get_cpu();
    
    		cur_tsc_khz = get_cpu_tsc_khz();
		if (cur_tsc_khz &&
	    	    !kvm_get_walltime_and_clockread(&ts, &data->host_tsc))
			cur_tsc_khz = 0;

		put_cpu();
	}

However, the changelog essentially claims kvm_get_walltime_and_clockread() should
never fail when use_master_clock is enabled, which suggests a WARN is warranted.

    There was previously a code path in __get_kvmclock() which looked like
    it could set KVM_CLOCK_TSC_STABLE without KVM_CLOCK_REALTIME, perhaps
    even on 32-bit hosts. In practice that could never happen as the
    ka->use_master_clock flag couldn't be set on 32-bit, and even on 64-bit
    hosts it would never be set when the system clock isn't TSC-based. So
    that code path is now removed.

But, I think kvm_get_walltime_and_clockread() can fail when use_master_clock is
true, i.e. I don't think a WARN is viable as it could get false positives.

Ah, this is protected by pvclock_sc, so a stale use_master_clock should result
in a retry.  What if we WARN on that?

Hrm, that requires plumbing in the original sequence count.  Ah, but looking at
the patch as a whole, if we keep kvm_get_wall_clock_epoch()'s style, then it's
much easier.  And FWIW, I like the existing kvm_get_wall_clock_epoch() style a
lot more than the get_kvmclock() => __get_kvmclock() approach.

So, can we do this as prep patch #1?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c14d0f5a684..98806a59e110 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3360,9 +3360,16 @@ uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
 
                local_tsc_khz = get_cpu_tsc_khz();
 
+               /*
+                * The master clock depends on the pvclock being based on TSC,
+                * so the only way kvm_get_walltime_and_clockread() can fail is
+                * if the clocksource changed and use_master_clock is stale, in
+                * which case a seqcount retry should be pending.
+                */
                if (local_tsc_khz &&
-                   !kvm_get_walltime_and_clockread(&ts, &host_tsc))
-                       local_tsc_khz = 0; /* Fall back to old method */
+                   !kvm_get_walltime_and_clockread(&ts, &host_tsc) &&
+                   WARN_ON_ONCE(!read_seqcount_retry(&ka->pvclock_sc, seq)))
+                           local_tsc_khz = 0; /* Fall back to old method */
 
                put_cpu();
 

And then as patch(es) 2..7 (give or take)

  (2) fold __get_kvmclock() into get_kvmclock()
  (3) and the same WARN on the seqcount in get_kvmclock() (but skimp on the comments)
  (4) use get_kvmclock_base_ns() as the fallback in get_kvmclock(), i.e. delete
      the raw rdtsc() and setting of KVM_CLOCK_TSC_STABLE w/o KVM_CLOCK_REALTIME
  (5) use get_cpu_tsc_khz() instead of open coding something similar
  (6) scale TSC when computing kvmclock (the core of this patch)
  (7) use get_kvmclock() in kvm_get_wall_clock_epoch() as the will be 100%
      equivalent at this point.

> +	    !kvm_get_walltime_and_clockread(&ts, &data->host_tsc))
> +		cur_tsc_khz = 0;
>  
> -		if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
> -			data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
> -			data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
> -		} else
> -#endif
> -		data->host_tsc = rdtsc();
> -
> -		data->flags |= KVM_CLOCK_TSC_STABLE;
> -		hv_clock.tsc_timestamp = ka->master_cycle_now;
> -		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> -		kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
> -				   &hv_clock.tsc_shift,
> -				   &hv_clock.tsc_to_system_mul);
> -		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
> -	} else {
> -		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
> +	put_cpu();
> +
> +	if (cur_tsc_khz) {
> +		uint64_t tsc_cycles;
> +		uint32_t mul;
> +		int8_t shift;
> +
> +		tsc_cycles = data->host_tsc - ka->master_cycle_now;
> +
> +		if (kvm_caps.has_tsc_control)
> +			tsc_cycles = kvm_scale_tsc(tsc_cycles,
> +						   ka->master_tsc_scaling_ratio);
> +
> +		if (static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +			mul = ka->master_tsc_mul;
> +			shift = ka->master_tsc_shift;
> +		} else {
> +			kvm_get_time_scale(NSEC_PER_SEC, cur_tsc_khz * 1000LL,
> +					   &shift, &mul);
> +		}
> +		data->clock = ka->master_kernel_ns + ka->kvmclock_offset +
> +			pvclock_scale_delta(tsc_cycles, mul, shift);
> +		data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
> +		data->flags = KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC | KVM_CLOCK_TSC_STABLE;
> +		return;
>  	}
> +#endif
>  
> -	put_cpu();
> +	data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
> +	data->flags = 0;
>  }


