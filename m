Return-Path: <kvm+bounces-12758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C8988D636
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 07:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50E0BB228CD
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5FD1A26E;
	Wed, 27 Mar 2024 06:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mIvWuUAh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D750B175AA
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 06:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711519684; cv=none; b=UO2HRxQrJodxqLIBS7ObIYgr8qeDqO0VNM2upMoWKeF0qxhEMgFnoFDIlD+NBn+ZipTkWo1MLNOTVGvkh2KzwNWNLvFy+L/P5pTeSU2AEY8vM2xK/oAx1h7YT7p9V+s8B3a2SD5vUBR459KRKPgd9UAritAkgSuLs8790W2OUQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711519684; c=relaxed/simple;
	bh=EmM0QgEugr9Tp1yVqSa2+Xa7ceJ4bQDYge9Q0TUTqMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oa4okt9bqk9B3wmrqYULu/OVX8/SBg3sXxM88mqV41m5u/qE5lagjYmfaSc01XYPEBEB2K0dsVZ7ttSNO5fLN1IULgSWnGaVJ3QHaR2CiCLF7ZUrFk12eInxanaPByniaSTECsMT/Rphz0dmJpYBGyB4D2fLx7+eCJ/+tWP3T40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mIvWuUAh; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e6b54a28d0so4282041b3a.2
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 23:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711519682; x=1712124482; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pcJzo6dQ1uUw06/34PGthyuoNx0HppBpOfdRwJVr39E=;
        b=mIvWuUAhzsJo/d/4Z9qLmOl8G+Ep6ANoy64qbYlzUoAM8ov8SGVpUHjO6oheDDTPcN
         qz51YAIEcElNqQT1TLLI8QJAFG9UaIcEIVWioXYPTSU95Fc0HvfM4wipcF3f8KCjdGw5
         ofu3pCnZCCZV8F/gjfN1y8EmhwvmHyj1k23uv2yXmQ/2A43DbHRD7Qog69Zz1skyGyMG
         BmDctDLiFLSFkuIp9MKT0iajcQUq76Qdetrp+Hnp+TdNcmjDnwJJ/ZB8cC1nPdaczYw3
         qhAUPA8/1L0k100IcXPX2o3cgswtLZSj/+3wjFcHuwUamwKjMXZPuS9Wio42oGkWr2Hu
         di0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711519682; x=1712124482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcJzo6dQ1uUw06/34PGthyuoNx0HppBpOfdRwJVr39E=;
        b=boCJ/8lKK23uFwbRq/vLsBaKiFIIjG9X7pny+CuXdnQnwkJwJ0V3jDB3yjNvkjFoOZ
         wPvya36958/xlFtgoKjI9lpYR4xtJRUlQZLuUD6kDTWLn2HpbIdYO3L9OId/7k7wDxeK
         57OoMe6pBTfPm6I271m5TdPCa5HNcMF8835yRzVR3nwTZB6HMk/orI807oDHE6Ct6N/j
         CyXbXb6orXCcj4GTp55IhR9yODk/vG4rpJ1weLo5Mo9D+e2UeoGw+kP45Eaost8ZmDAL
         UTaWDZ3C5j4oH5wHEfHR/Md0V1CGdtdHkEhut54fm74YXl6D1sDY+BYLtwdMVeWAlfkq
         RJJg==
X-Forwarded-Encrypted: i=1; AJvYcCWggK5YeoiCvZk2k1RZTgAdFv7Nx6b3KYI47DTyu+km63aCA4+FZp0jbYr2c/hfCy2JpPAdsJn9skIODgdU7Awk5R1/
X-Gm-Message-State: AOJu0Yz0t5+t9xF0ilhevGd2TvXGvhbKMJfywAEl0hhhxoHBqB0KKSN4
	Z5bTQqVr2IDUh4R/vpSuUNX4omobMvVrMB3ASg/lESUYCNs7U+zfzXzUHi0s2/mcTccFkXxrAr6
	b3g==
X-Google-Smtp-Source: AGHT+IHAVjv/IXiOWJ+Hpi8Jji1NcoUc6hm+qAp6VDkhX5ygF30RDezaDzkCsNHmyqSzHDy61qfe9A==
X-Received: by 2002:a05:6a00:1496:b0:6ea:baed:a136 with SMTP id v22-20020a056a00149600b006eabaeda136mr1980039pfu.8.1711519681818;
        Tue, 26 Mar 2024 23:08:01 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id h25-20020aa786d9000000b006ea6ca5295bsm6984864pfo.164.2024.03.26.23.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 23:08:01 -0700 (PDT)
Date: Wed, 27 Mar 2024 06:07:57 +0000
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
Subject: Re: [kvm-unit-tests Patch v3 07/11] x86: pmu: Enable and disable
 PMCs in loop() asm blob
Message-ID: <ZgO3vWIeC3sk_B5N@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-8-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103031409.2504051-8-dapeng1.mi@linux.intel.com>

On Wed, Jan 03, 2024, Dapeng Mi wrote:
> Currently enabling PMCs, executing loop() and disabling PMCs are divided
> 3 separated functions. So there could be other instructions executed
> between enabling PMCS and running loop() or running loop() and disabling
> PMCs, e.g. if there are multiple counters enabled in measure_many()
> function, the instructions which enabling the 2nd and more counters
> would be counted in by the 1st counter.
> 
> So current implementation can only verify the correctness of count by an
> rough range rather than a precise count even for instructions and
> branches events. Strictly speaking, this verification is meaningless as
> the test could still pass even though KVM vPMU has something wrong and
> reports an incorrect instructions or branches count which is in the rough
> range.
> 
> Thus, move the PMCs enabling and disabling into the loop() asm blob and
> ensure only the loop asm instructions would be counted, then the
> instructions or branches events can be verified with an precise count
> instead of an rough range.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

> ---
>  x86/pmu.c | 83 +++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 69 insertions(+), 14 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 46bed66c5c9f..88b89ad889b9 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -18,6 +18,20 @@
>  #define EXPECTED_INSTR 17
>  #define EXPECTED_BRNCH 5
>  
> +// Instrustion number of LOOP_ASM code
> +#define LOOP_INSTRNS	10
> +#define LOOP_ASM					\
> +	"1: mov (%1), %2; add $64, %1;\n\t"		\
> +	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
> +	"loop 1b;\n\t"
> +
> +#define PRECISE_LOOP_ASM						\
> +	"wrmsr;\n\t"							\
> +	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
> +	LOOP_ASM							\
> +	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
> +	"wrmsr;\n\t"

Can we add "FEP" prefix into the above blob? This way, we can expand the
testing for emulated instructions.
> +
>  typedef struct {
>  	uint32_t ctr;
>  	uint64_t config;
> @@ -54,13 +68,43 @@ char *buf;
>  static struct pmu_event *gp_events;
>  static unsigned int gp_events_size;
>  
> -static inline void loop(void)
> +
> +static inline void __loop(void)
> +{
> +	unsigned long tmp, tmp2, tmp3;
> +
> +	asm volatile(LOOP_ASM
> +		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
> +		     : "0"(N), "1"(buf));
> +}
> +
> +/*
> + * Enable and disable counters in a whole asm blob to ensure
> + * no other instructions are counted in the time slot between
> + * counters enabling and really LOOP_ASM code executing.
> + * Thus counters can verify instructions and branches events
> + * against precise counts instead of a rough valid count range.
> + */
> +static inline void __precise_count_loop(u64 cntrs)
>  {
>  	unsigned long tmp, tmp2, tmp3;
> +	unsigned int global_ctl = pmu.msr_global_ctl;
> +	u32 eax = cntrs & (BIT_ULL(32) - 1);
> +	u32 edx = cntrs >> 32;
>  
> -	asm volatile("1: mov (%1), %2; add $64, %1; nop; nop; nop; nop; nop; nop; nop; loop 1b"
> -			: "=c"(tmp), "=r"(tmp2), "=r"(tmp3): "0"(N), "1"(buf));
> +	asm volatile(PRECISE_LOOP_ASM
> +		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
> +		     : "a"(eax), "d"(edx), "c"(global_ctl),
> +		       "0"(N), "1"(buf)
> +		     : "edi");
> +}
>  
> +static inline void loop(u64 cntrs)
> +{
> +	if (!this_cpu_has_perf_global_ctrl())
> +		__loop();
> +	else
> +		__precise_count_loop(cntrs);
>  }
>  
>  volatile uint64_t irq_received;
> @@ -159,18 +203,17 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
>  	    ctrl = (ctrl & ~(0xf << shift)) | (usrospmi << shift);
>  	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
>      }
> -    global_enable(evt);
>      apic_write(APIC_LVTPC, PMI_VECTOR);
>  }
>  
>  static void start_event(pmu_counter_t *evt)
>  {
>  	__start_event(evt, 0);
> +	global_enable(evt);
>  }
>  
> -static void stop_event(pmu_counter_t *evt)
> +static void __stop_event(pmu_counter_t *evt)
>  {
> -	global_disable(evt);
>  	if (is_gp(evt)) {
>  		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
>  		      evt->config & ~EVNTSEL_EN);
> @@ -182,14 +225,24 @@ static void stop_event(pmu_counter_t *evt)
>  	evt->count = rdmsr(evt->ctr);
>  }
>  
> +static void stop_event(pmu_counter_t *evt)
> +{
> +	global_disable(evt);
> +	__stop_event(evt);
> +}
> +
>  static noinline void measure_many(pmu_counter_t *evt, int count)
>  {
>  	int i;
> +	u64 cntrs = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		__start_event(&evt[i], 0);
> +		cntrs |= BIT_ULL(event_to_global_idx(&evt[i]));
> +	}
> +	loop(cntrs);
>  	for (i = 0; i < count; i++)
> -		start_event(&evt[i]);
> -	loop();
> -	for (i = 0; i < count; i++)
> -		stop_event(&evt[i]);
> +		__stop_event(&evt[i]);
>  }
>  
>  static void measure_one(pmu_counter_t *evt)
> @@ -199,9 +252,11 @@ static void measure_one(pmu_counter_t *evt)
>  
>  static noinline void __measure(pmu_counter_t *evt, uint64_t count)
>  {
> +	u64 cntrs = BIT_ULL(event_to_global_idx(evt));
> +
>  	__start_event(evt, count);
> -	loop();
> -	stop_event(evt);
> +	loop(cntrs);
> +	__stop_event(evt);
>  }
>  
>  static bool verify_event(uint64_t count, struct pmu_event *e)
> @@ -451,7 +506,7 @@ static void check_running_counter_wrmsr(void)
>  	report_prefix_push("running counter wrmsr");
>  
>  	start_event(&evt);
> -	loop();
> +	__loop();
>  	wrmsr(MSR_GP_COUNTERx(0), 0);
>  	stop_event(&evt);
>  	report(evt.count < gp_events[0].min, "cntr");
> @@ -468,7 +523,7 @@ static void check_running_counter_wrmsr(void)
>  
>  	wrmsr(MSR_GP_COUNTERx(0), count);
>  
> -	loop();
> +	__loop();
>  	stop_event(&evt);
>  
>  	if (this_cpu_has_perf_global_status()) {
> -- 
> 2.34.1
> 

