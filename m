Return-Path: <kvm+bounces-12885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7F588EC14
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88AEC1C2DB84
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90B314E2C1;
	Wed, 27 Mar 2024 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QvRy0vpo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471F314D6F1
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559178; cv=none; b=ZMKf1ikgM5cywaRKwVuCPtrPuX2cYWuUx1KtFuEYhkmQfTtElTE76BWcbRpsFhDJUixZv0UQQFEfeaYW1CWALIymhnBEtpYAjBgJnpCp6pzXVdIR27uiICKsxMM7S/3QUjNlfehNgwvm/5fGD2a0UYbtAVHXXTME+M8XvGt2wkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559178; c=relaxed/simple;
	bh=bBSoVZNXnImm2xWp7WBBSOxsMP+tK9xNwxw0jIzelj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYp/M75WsiJS502bXM5tNYpV+hCjYsFcYCb3Tf3i1u3v4a5npF5T/T4T/sSCn8qWcrVgA3pjA93wMEWWsswMM7KdZoaAmhjBgXfd1TLngey75wT3/ytbK5hRNueqfm7HpHr2ClKZTWUt7VX45c/rtbm/73Ff/VFdjbySQRKUbKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QvRy0vpo; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5e8470c1cb7so4914216a12.2
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 10:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711559176; x=1712163976; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=db/vsjswu3WccKaVuM1UJ18xAjQJ5GOJeNQDmiP8KtE=;
        b=QvRy0vpoObxxokVPCzygu7Z3oBYR4h7IFFwrbTO5w3OyiTukCrHMLvcx4h6BdPxayW
         x8hxr6YMuHog6o21l85jP462fcrVw9lCrl8xIALRfxICX96ClTd+PnWPRdRV771eBxcm
         DF6KETS/1OU09jBZ9kXFfko9Dy7mlX2S/H6EV1yZBNZFl5pRXJS2vuhBFFuquRj0oWv4
         4GL6GfU+Fzyw0MQLCxe744Jod05Q6WUt4bmpGIlbWrYbaazW/4Ly60R7u3+1PfB9JfoP
         2xSFGJO2o5EnxwKQP/Ek6mluMPO0ErxHSdGgnQ7W62VJs7//Q9GG86U5F9rUk1i/hEOI
         d8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711559176; x=1712163976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=db/vsjswu3WccKaVuM1UJ18xAjQJ5GOJeNQDmiP8KtE=;
        b=AG1HZmWhHKcXltvdx7sjbqC+wnuAMqUITCN+m7YlLtm/Z3Q/UpGScPw8FnSCh0Hq2r
         DgU9kbyWl+vd51cErvnkWnmbZqQWnvAjgfHdysUHFWPCFhvH3pFVUodnZKNBjyt+LSQC
         NSqsGVSYUN8lMBt9DYFxCIgtk+tfSIwq1AFgXgAeug9+VQS2MZAmiaFaGcsVmlkdEcnl
         zp5/3s6fPk/VxrjW/YDlNPD8MO3AuIGXNiRxZ1wcGb4eT2JoFZmsnfPBPRSfKcotfQ01
         tF1VLpRmXs0shi6bObk4XPl3xyIHvG04r6fOWMgW7W7mbPBVGGPQz7CN/iG3amxjJMEV
         aucg==
X-Forwarded-Encrypted: i=1; AJvYcCXA0t10+zhj9bAHQOPBwBYw23RoCb4RxXyWw/K/zup4aem0icE7l600NXE8ye9U6aRyXtDKAlaaTipYjs3UvTm625yu
X-Gm-Message-State: AOJu0YzH6Gx5EgLyc2D0LU782+HR651eIwD9BaBwBR0bZrqojXYSMXNz
	4WTNPRvfCQ7ECrOQegRIUzZ9pNIBz/tzpy1z9JUkuh/Mn9rJwOvJcEvHrm1HppYjX2GG0k9QVVS
	BaA==
X-Google-Smtp-Source: AGHT+IE5JKYyE33YBvhxG3VFanPvZJOgSZ9poeectC8JcZ8V58yv85X5bfMLffVlzQyxlyIZzHatLg==
X-Received: by 2002:a17:90a:c78f:b0:29b:33eb:1070 with SMTP id gn15-20020a17090ac78f00b0029b33eb1070mr236752pjb.14.1711559176238;
        Wed, 27 Mar 2024 10:06:16 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id pw13-20020a17090b278d00b002a055d4d2fesm1970561pjb.56.2024.03.27.10.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 10:06:15 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:06:12 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
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
Message-ID: <ZgRSBITQNIRIgu8N@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-5-dapeng1.mi@linux.intel.com>
 <ZgOwVvTVlvk3iN3x@google.com>
 <c838c85e-c448-4f83-a79f-deb20c6aaf90@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c838c85e-c448-4f83-a79f-deb20c6aaf90@linux.intel.com>

On Wed, Mar 27, 2024, Mi, Dapeng wrote:
> 
> On 3/27/2024 1:36 PM, Mingwei Zhang wrote:
> > On Wed, Jan 03, 2024, Dapeng Mi wrote:
> > > When running pmu test on SPR, sometimes the following failure is
> > > reported.
> > > 
> > > PMU version:         2
> > > GP counters:         8
> > > GP counter width:    48
> > > Mask length:         8
> > > Fixed counters:      3
> > > Fixed counter width: 48
> > > 1000000 <= 55109398 <= 50000000
> > > FAIL: Intel: core cycles-0
> > > 1000000 <= 18279571 <= 50000000
> > > PASS: Intel: core cycles-1
> > > 1000000 <= 12238092 <= 50000000
> > > PASS: Intel: core cycles-2
> > > 1000000 <= 7981727 <= 50000000
> > > PASS: Intel: core cycles-3
> > > 1000000 <= 6984711 <= 50000000
> > > PASS: Intel: core cycles-4
> > > 1000000 <= 6773673 <= 50000000
> > > PASS: Intel: core cycles-5
> > > 1000000 <= 6697842 <= 50000000
> > > PASS: Intel: core cycles-6
> > > 1000000 <= 6747947 <= 50000000
> > > PASS: Intel: core cycles-7
> > > 
> > > The count of the "core cycles" on first counter would exceed the upper
> > > boundary and leads to a failure, and then the "core cycles" count would
> > > drop gradually and reach a stable state.
> > > 
> > > That looks reasonable. The "core cycles" event is defined as the 1st
> > > event in xxx_gp_events[] array and it is always verified at first.
> > > when the program loop() is executed at the first time it needs to warm
> > > up the pipeline and cache, such as it has to wait for cache is filled.
> > > All these warm-up work leads to a quite large core cycles count which
> > > may exceeds the verification range.
> > > 
> > > The event "instructions" instead of "core cycles" is a good choice as
> > > the warm-up event since it would always return a fixed count. Thus
> > > switch instructions and core cycles events sequence in the
> > > xxx_gp_events[] array.
> > The observation is great. However, it is hard to agree that we fix the
> > problem by switching the order. Maybe directly tweaking the N from 50 to
> > a larger value makes more sense.
> > 
> > Thanks.
> > -Mingwei
> 
> yeah, a larger upper boundary can fix the fault as well, but the question is
> how large it would be enough. For different CPU model, the needed cycles
> could be different for warming up. So we may have to set a quite large upper
> boundary but a large boundary would decrease credibility of this validation.
> Not sure which one is better. Any inputs from other ones?
> 

Just checked with an expert from our side, so "core cycles" (0x003c)
is affected the current CPU state/frequency, ie., its counting value
could vary largely. In that sense, "warming" up seems reasonable.
However, switching the order would be a terrible idea for maintanence
since people will forget it and the problem will come back.

From another perspective, "warming" up seems just a best effort. Nobody
knows how warm is really warm. Besides, some systems might turn off some
C-State and may set a cap on max turbo frequency. All of these will
directly affect the warm-up process and the counting result of 0x003c.

So, while adding a warm-up blob is reasonable, tweaking the heuristics
seems to be same for me. Regarding the value, I think I will rely on
your experiments and observation.

Thanks.
-Mingwei
> 
> > > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > > ---
> > >   x86/pmu.c | 16 ++++++++--------
> > >   1 file changed, 8 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/x86/pmu.c b/x86/pmu.c
> > > index a42fff8d8b36..67ebfbe55b49 100644
> > > --- a/x86/pmu.c
> > > +++ b/x86/pmu.c
> > > @@ -31,16 +31,16 @@ struct pmu_event {
> > >   	int min;
> > >   	int max;
> > >   } intel_gp_events[] = {
> > > -	{"core cycles", 0x003c, 1*N, 50*N},
> > >   	{"instructions", 0x00c0, 10*N, 10.2*N},
> > > +	{"core cycles", 0x003c, 1*N, 50*N},
> > >   	{"ref cycles", 0x013c, 1*N, 30*N},
> > >   	{"llc references", 0x4f2e, 1, 2*N},
> > >   	{"llc misses", 0x412e, 1, 1*N},
> > >   	{"branches", 0x00c4, 1*N, 1.1*N},
> > >   	{"branch misses", 0x00c5, 0, 0.1*N},
> > >   }, amd_gp_events[] = {
> > > -	{"core cycles", 0x0076, 1*N, 50*N},
> > >   	{"instructions", 0x00c0, 10*N, 10.2*N},
> > > +	{"core cycles", 0x0076, 1*N, 50*N},
> > >   	{"branches", 0x00c2, 1*N, 1.1*N},
> > >   	{"branch misses", 0x00c3, 0, 0.1*N},
> > >   }, fixed_events[] = {
> > > @@ -307,7 +307,7 @@ static void check_counter_overflow(void)
> > >   	int i;
> > >   	pmu_counter_t cnt = {
> > >   		.ctr = MSR_GP_COUNTERx(0),
> > > -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
> > > +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
> > >   	};
> > >   	overflow_preset = measure_for_overflow(&cnt);
> > > @@ -365,11 +365,11 @@ static void check_gp_counter_cmask(void)
> > >   {
> > >   	pmu_counter_t cnt = {
> > >   		.ctr = MSR_GP_COUNTERx(0),
> > > -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
> > > +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
> > >   	};
> > >   	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
> > >   	measure_one(&cnt);
> > > -	report(cnt.count < gp_events[1].min, "cmask");
> > > +	report(cnt.count < gp_events[0].min, "cmask");
> > >   }
> > >   static void do_rdpmc_fast(void *ptr)
> > > @@ -446,7 +446,7 @@ static void check_running_counter_wrmsr(void)
> > >   	uint64_t count;
> > >   	pmu_counter_t evt = {
> > >   		.ctr = MSR_GP_COUNTERx(0),
> > > -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
> > > +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
> > >   	};
> > >   	report_prefix_push("running counter wrmsr");
> > > @@ -455,7 +455,7 @@ static void check_running_counter_wrmsr(void)
> > >   	loop();
> > >   	wrmsr(MSR_GP_COUNTERx(0), 0);
> > >   	stop_event(&evt);
> > > -	report(evt.count < gp_events[1].min, "cntr");
> > > +	report(evt.count < gp_events[0].min, "cntr");
> > >   	/* clear status before overflow test */
> > >   	if (this_cpu_has_perf_global_status())
> > > @@ -493,7 +493,7 @@ static void check_emulated_instr(void)
> > >   	pmu_counter_t instr_cnt = {
> > >   		.ctr = MSR_GP_COUNTERx(1),
> > >   		/* instructions */
> > > -		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
> > > +		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
> > >   	};
> > >   	report_prefix_push("emulated instruction");
> > > -- 
> > > 2.34.1
> > > 

