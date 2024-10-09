Return-Path: <kvm+bounces-28274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B739970F9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63A0D28634C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D811F1E1044;
	Wed,  9 Oct 2024 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="efDQlFm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5081E8845
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489536; cv=none; b=OcGvVYz875+/oiRa5uVv+w/BlFWXSMhlcLK5dNmTaZWn1tLt1/yVlIGxDmGVv1/03bi3S62UM3Z99CvCCsV33D3GwBWs9VeBLuhr6bJjvgiz+QvfPKzZOD6Ml7RCTV6PkSfCBLRrQfnxXL7SQJ7cIRsLHfF451CipfCtaeFs6Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489536; c=relaxed/simple;
	bh=30NfKZLT1MP0Qf5dqi1pKIQDdlau/ThSQgfyAgM6+P8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CQB/fNezAkUEPHE3hi6QH/W11gW88IdDn03uBE3YanTIc2UAvcqj+2ACpEuc4qMK4gTD2MWTq0OsV7f4t3jrHsGajH4m3JONj29UVl+ZnGUc7HM+8/n1wBQTzkSrdINItCsTUAg3ZgZomF3BN/y4MveFof3nYVpCq+6u40zgvz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=efDQlFm8; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7c6a9c1a9b8so4286985a12.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489534; x=1729094334; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ts8G/W/YzP17g23owGIref200B1OWyhLngxKHV0B+lc=;
        b=efDQlFm8MZCaJHxQvWjUxPJb2fxRycc2wUyJIHIoItp2DIqmreaiAZi4BDk0Jjsptq
         srXKWdF8i/0XS531f2tU9qD1tEJHww8WYaKB4h9wPbcWwwpNk3NliSLo9yUCnGDITFjB
         jcGjI+fFauUmGXj8RFLMVvueuxttyZ+HuvZ5KmgYhlKAfNVo4a9dpKw4ogDyp9N0Miab
         07L4w6jtODKYexhbAr6t9b+9/eTSr3BHCWYErGYQLTUjJ4etcaTEYnLMi7T+1BOK/ron
         tchEyuto1i+epfCba3NH5WmaGfCSEgNBkQ6BN2y2ps3TWGqlsfhV/djZplEQKx3p1Ory
         OldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489534; x=1729094334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ts8G/W/YzP17g23owGIref200B1OWyhLngxKHV0B+lc=;
        b=NNIWODfMKUaNgB+9/4DBQK3JonYfCnXh9dg432NApxewypHvMvLzrdACvKW/vwbbNI
         WxP2sGImfkSvd18yfFiSLhDfCJhwmmlkZscfYAqxu7ZO3jIebGFm4vhH+9pJZ7Oy09WV
         BymwX21D37LzyE8uTA55p8SAmAjblIiiNNnhOUeLZMIWUE2cE5czKB4abd6YC/acHpvT
         zO1vpKTIDOvVOiGmB5O/6kOJY5NjZtrLaacqWn0DpjNs1SMHDqAKRtl7G5xVHlAnCyPr
         wwapE6WgbE+JVwJz5ol4qibuD3yzVL8YAgR0jyzX4rB97EhONzKoDHzlVnaUAeDMpIFc
         dPtg==
X-Forwarded-Encrypted: i=1; AJvYcCU8VzCXi+1cMDDf1m0pqvfne1Dd4cvnALeHjxyqJI94aHRcQEINob8ZyWl16tGUDCJXBis=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfZUUsWxud5hEyZqsWCboGFqzAjEv0spuOZScYOA406/NuFeeB
	vvE7BLRVwxTkOCUEdJ1tzXOif0SDpiP+EySHQ7Vw5o9uQqPhCidmnPpFiaBBlKv/ZUTMTJa6GO2
	r1g==
X-Google-Smtp-Source: AGHT+IErBgFQtjMZqfp0oDNhjjbYCy24dN9A+KXRX4mSCBJh5Vs/DdeBKoJmqZriJq7aAZ+opCLOPUMDfz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:408b:0:b0:7c6:af2b:196f with SMTP id
 41be03b00d2f7-7ea320d7ddamr3399a12.6.1728489533794; Wed, 09 Oct 2024 08:58:53
 -0700 (PDT)
Date: Wed, 9 Oct 2024 08:58:52 -0700
In-Reply-To: <20241009092850.197575-17-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009092850.197575-1-nikunj@amd.com> <20241009092850.197575-17-nikunj@amd.com>
Message-ID: <ZwaoPJYN-FuSWRxc@google.com>
Subject: Re: [PATCH v12 16/19] x86/kvmclock: Use clock source callback to
 update kvm sched clock
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 09, 2024, Nikunj A Dadhania wrote:
> Although the kernel switches over to stable TSC clocksource instead of
> kvmclock, the scheduler still keeps on using kvmclock as the sched clock.
> This is due to kvm_sched_clock_init() updating the pv_sched_clock()
> unconditionally.

All PV clocks are affected by this, no?  This seems like something that should
be handled in common code, which is the point I was trying to make in v11.

> Use the clock source enable/disable callbacks to initialize
> kvm_sched_clock_init() and update the pv_sched_clock().
> 
> As the clock selection happens in the stop machine context, schedule
> delayed work to update the static_call()
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kernel/kvmclock.c | 34 +++++++++++++++++++++++++++++-----
>  1 file changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c15214a6b..5cd3717e103b 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -21,6 +21,7 @@
>  #include <asm/hypervisor.h>
>  #include <asm/x86_init.h>
>  #include <asm/kvmclock.h>
> +#include <asm/timer.h>
>  
>  static int kvmclock __initdata = 1;
>  static int kvmclock_vsyscall __initdata = 1;
> @@ -148,12 +149,39 @@ bool kvm_check_and_clear_guest_paused(void)
>  	return ret;
>  }
>  
> +static u64 (*old_pv_sched_clock)(void);
> +
> +static void enable_kvm_sc_work(struct work_struct *work)
> +{
> +	u8 flags;
> +
> +	old_pv_sched_clock = static_call_query(pv_sched_clock);
> +	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
> +	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
> +}
> +
> +static DECLARE_DELAYED_WORK(enable_kvm_sc, enable_kvm_sc_work);
> +
> +static void disable_kvm_sc_work(struct work_struct *work)
> +{
> +	if (old_pv_sched_clock)

This feels like it should be a WARN condition, as IIUC, pv_sched_clock() should
never be null.  And it _looks_ wrong too, as it means kvm_clock will remain the
sched clock if there was no old clock, which should be impossible.

> +		paravirt_set_sched_clock(old_pv_sched_clock);

