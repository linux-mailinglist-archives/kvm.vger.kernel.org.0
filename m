Return-Path: <kvm+bounces-12750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E737F88D5E6
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:36:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F035B21ED9
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 05:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B2C14273;
	Wed, 27 Mar 2024 05:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WJXv6naU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2910949
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 05:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711517788; cv=none; b=D3bRKei6V/DKBDdP60kKLi6JnbWbH96ffT9ion458rlZwSOjYE5zVxRGmLQ7K/FvZAgZQguNccC1PvXeE+M4GHATGF2Q/pdIOlkiAp5bK+NlRNzZ0v7UpGxhKubFuXaNqT7jaoq1HYCg0xIzyCWZrQH8EtF71ULz7EamT6BSqwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711517788; c=relaxed/simple;
	bh=BLcCxiJXQZXgvVd25qKk9yY3fM3yD7KnkVdkHfMgu30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhHRlmuti4Hc5WhEOkTfTlbnIai4lP7tslKhDPBquJ7F9JWpZqQVu+AzCjnlI8u19TFKi8TKWfPXydmRL0OS+lywJwDNhjJBhc1SQitPvoetZCN8mIPN4UoCLZ+VuLKr/mY/t3/YsPgVSCReMr7MGPbXSnhHb7jAkUQ/YXmMVuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WJXv6naU; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e67b5d6dd8so3511498a34.2
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 22:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711517786; x=1712122586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xDotf3qLJ0XcUAR4+tlCSoc4OzTuiL/EZY6fMJlWYbc=;
        b=WJXv6naUH9ZDONeFxPO27M9H6OCF3oW0tO9BDHTfe1jCxKENoNpl7X7iVkiQsBaQQ7
         DSPy4oIZkabs+hHHMCjmjO5c1qvVY63SpRcyOP9Bmf+UZdAPdO5OZSl5or4qbjxNqelC
         /2gQjeY/dA/wc8HakqUCcSAcnvw95k67Quuav8h/VLiluRNkheWr7U3hbeRv6ceCOvKz
         Oud+MTNRetldVzmn7mTzuLnkHoWjUetKBcE4+5ipdiegpn558Wp0GQa262ISMgSrvP6F
         HxjM6IjxMoe6vMz7zMYqLXQUaop5/O6YjWuEm/TVogkqDiAJIR0Utcysb1nd1stUpP7Y
         ZenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711517786; x=1712122586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDotf3qLJ0XcUAR4+tlCSoc4OzTuiL/EZY6fMJlWYbc=;
        b=Zqiprcf9CWZ0sU/jC76FCuinLERZEoEQpMCoFrs4TEFrwYT382YHmm2D/Uno5VqEsg
         70VxFD8gQCxxv/Xu6B6eHCPWgeZQnyXL414a1yoAiueFcKbvbhYKf0MKahHVziymWsyN
         MKSYgdSnDjzlHHVgZ8xz5fRkVUuIG5OlX6sjZJ99e2hUj209h/zQJHSxr2UTWSeTciSf
         x9roCafIfkxoO+uyfKnISCEZEf7d2mtLXYPsV5LFwPECPWQY7IJf10m5IqEApPggpuFh
         rm1rGqzLPMl3sxE+XHvTaZMPdX2OWy1PPP4Ud6iXqa28RMB6C10NsXrJ1vEbruO3rkq5
         hHKg==
X-Forwarded-Encrypted: i=1; AJvYcCXyXLh/RfC2lMTPIlaFg4SXp8UDtQDUyRlLzQnsgVMGln7h3zotc9/eRPYIEC+Lr11K2fTUVbFWmcLK3sbwMUqj+i3k
X-Gm-Message-State: AOJu0YwDHTL6/12k0GcAKH0c8+Dghq+aRF3PSC/7F0ODUEyeZCmMxrWw
	to3QZhYWzzYgKwJQrj+kG+MIXzp+hoh2LDlGxd3nKGdZ6+zQmLTkMwklWUMpBg==
X-Google-Smtp-Source: AGHT+IEuE5FASfwS2a02hHGLgVM33pzIj6gKaHZRiHAoyJqFpJTEzROn3oPFMAyhwrxAlo6eeX93AQ==
X-Received: by 2002:a9d:77ce:0:b0:6e6:d509:bf8a with SMTP id w14-20020a9d77ce000000b006e6d509bf8amr243606otl.38.1711517785719;
        Tue, 26 Mar 2024 22:36:25 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id m24-20020a635818000000b005dc4f9cecdcsm8515531pgb.86.2024.03.26.22.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 22:36:25 -0700 (PDT)
Date: Wed, 27 Mar 2024 05:36:22 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch v3 04/11] x86: pmu: Switch instructions
 and core cycles events sequence
Message-ID: <ZgOwVvTVlvk3iN3x@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-5-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103031409.2504051-5-dapeng1.mi@linux.intel.com>

On Wed, Jan 03, 2024, Dapeng Mi wrote:
> When running pmu test on SPR, sometimes the following failure is
> reported.
> 
> PMU version:         2
> GP counters:         8
> GP counter width:    48
> Mask length:         8
> Fixed counters:      3
> Fixed counter width: 48
> 1000000 <= 55109398 <= 50000000
> FAIL: Intel: core cycles-0
> 1000000 <= 18279571 <= 50000000
> PASS: Intel: core cycles-1
> 1000000 <= 12238092 <= 50000000
> PASS: Intel: core cycles-2
> 1000000 <= 7981727 <= 50000000
> PASS: Intel: core cycles-3
> 1000000 <= 6984711 <= 50000000
> PASS: Intel: core cycles-4
> 1000000 <= 6773673 <= 50000000
> PASS: Intel: core cycles-5
> 1000000 <= 6697842 <= 50000000
> PASS: Intel: core cycles-6
> 1000000 <= 6747947 <= 50000000
> PASS: Intel: core cycles-7
> 
> The count of the "core cycles" on first counter would exceed the upper
> boundary and leads to a failure, and then the "core cycles" count would
> drop gradually and reach a stable state.
> 
> That looks reasonable. The "core cycles" event is defined as the 1st
> event in xxx_gp_events[] array and it is always verified at first.
> when the program loop() is executed at the first time it needs to warm
> up the pipeline and cache, such as it has to wait for cache is filled.
> All these warm-up work leads to a quite large core cycles count which
> may exceeds the verification range.
> 
> The event "instructions" instead of "core cycles" is a good choice as
> the warm-up event since it would always return a fixed count. Thus
> switch instructions and core cycles events sequence in the
> xxx_gp_events[] array.

The observation is great. However, it is hard to agree that we fix the
problem by switching the order. Maybe directly tweaking the N from 50 to
a larger value makes more sense.

Thanks.
-Mingwei
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a42fff8d8b36..67ebfbe55b49 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -31,16 +31,16 @@ struct pmu_event {
>  	int min;
>  	int max;
>  } intel_gp_events[] = {
> -	{"core cycles", 0x003c, 1*N, 50*N},
>  	{"instructions", 0x00c0, 10*N, 10.2*N},
> +	{"core cycles", 0x003c, 1*N, 50*N},
>  	{"ref cycles", 0x013c, 1*N, 30*N},
>  	{"llc references", 0x4f2e, 1, 2*N},
>  	{"llc misses", 0x412e, 1, 1*N},
>  	{"branches", 0x00c4, 1*N, 1.1*N},
>  	{"branch misses", 0x00c5, 0, 0.1*N},
>  }, amd_gp_events[] = {
> -	{"core cycles", 0x0076, 1*N, 50*N},
>  	{"instructions", 0x00c0, 10*N, 10.2*N},
> +	{"core cycles", 0x0076, 1*N, 50*N},
>  	{"branches", 0x00c2, 1*N, 1.1*N},
>  	{"branch misses", 0x00c3, 0, 0.1*N},
>  }, fixed_events[] = {
> @@ -307,7 +307,7 @@ static void check_counter_overflow(void)
>  	int i;
>  	pmu_counter_t cnt = {
>  		.ctr = MSR_GP_COUNTERx(0),
> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
>  	};
>  	overflow_preset = measure_for_overflow(&cnt);
>  
> @@ -365,11 +365,11 @@ static void check_gp_counter_cmask(void)
>  {
>  	pmu_counter_t cnt = {
>  		.ctr = MSR_GP_COUNTERx(0),
> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
>  	};
>  	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
>  	measure_one(&cnt);
> -	report(cnt.count < gp_events[1].min, "cmask");
> +	report(cnt.count < gp_events[0].min, "cmask");
>  }
>  
>  static void do_rdpmc_fast(void *ptr)
> @@ -446,7 +446,7 @@ static void check_running_counter_wrmsr(void)
>  	uint64_t count;
>  	pmu_counter_t evt = {
>  		.ctr = MSR_GP_COUNTERx(0),
> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
>  	};
>  
>  	report_prefix_push("running counter wrmsr");
> @@ -455,7 +455,7 @@ static void check_running_counter_wrmsr(void)
>  	loop();
>  	wrmsr(MSR_GP_COUNTERx(0), 0);
>  	stop_event(&evt);
> -	report(evt.count < gp_events[1].min, "cntr");
> +	report(evt.count < gp_events[0].min, "cntr");
>  
>  	/* clear status before overflow test */
>  	if (this_cpu_has_perf_global_status())
> @@ -493,7 +493,7 @@ static void check_emulated_instr(void)
>  	pmu_counter_t instr_cnt = {
>  		.ctr = MSR_GP_COUNTERx(1),
>  		/* instructions */
> -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
> +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
>  	};
>  	report_prefix_push("emulated instruction");
>  
> -- 
> 2.34.1
> 

