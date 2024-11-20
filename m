Return-Path: <kvm+bounces-32204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D009D4212
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 660F9282697
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1881BD4F8;
	Wed, 20 Nov 2024 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yZM3ErQx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A681B85C1
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732127562; cv=none; b=nmuhHZ/pv+1WIPCy0dJUMNN8ylo2fR6YqI8X/3ATL07pqvxyHHOT3A0w5RUsPIsGhAHdMvkSYvo+MeB9uvcX0GiL9bPguTWKOj8v+x66wIbDPvKr7NJyxuERYSU5tbmZngad8tqTJgx5M4FezbrryCDPV6JvaMHuVJsXLEypu6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732127562; c=relaxed/simple;
	bh=VwJjkubkHDIoV/PS9SZTOQZlbw49t9+3GHSQEL6b5w0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=umwB0TQbfTr6A4L+GnBWvusppQlttTN43gpS2kAPWBbkNFL295LH9hACGs8kjskDgwPtXq+S+XsifijxF3HVYCS7+MaDFOT5r8iTzvMGa+B+qTeROy0HLJDLVlKQU8xyTtc8xSmr9R9sRdrnPdqoXwq0RFczGlBQjeF/mc9xCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yZM3ErQx; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eebd4e7cc5so610697b3.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 10:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732127560; x=1732732360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9u128fHaxTBEIQSTD7iYlkQ+Vq37JApl5B1pQcBgC74=;
        b=yZM3ErQxlgbnLVpdnCWEOh7blIyA6tm7J8wglg3hYQOpmxdg5zGFpxqXVBWA2pdBqJ
         D64T+wV+tjK+gG8FctHpteRNrU5dBHpotWzS/iNxjdf9ifAU54yx+rmLpgux0Fjn5s6S
         bOZrAqbTLK0Cvlc2z5tBqj9ZfFlCzF09o9W0sRWq7g6lLEprFZ0aRG+b+SVl0S0FDWyz
         GAkX8GZaeaucYI00gQI9/JiZ+r+h2+iV23Qmy8x9/gpSZEXYcEOh3zKgbv928rwBeKJH
         10aXX6fQXqSGO/kqdqX8dHbAP+3i3QcBKTTpBjmosIOjXppJ2P5UXYEHxydPRSTZ/Vh0
         N/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732127560; x=1732732360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9u128fHaxTBEIQSTD7iYlkQ+Vq37JApl5B1pQcBgC74=;
        b=b6S+QA4CUU/G4ReHDdxNfhnCMXrXkChUpIFT0WwUycUGljzlfFiiyBgcw2qlcCFGej
         4u7oWx5/Q+BWcxz0rFTiK4mg8z5wKp7JDhXhQdKRbYIOlA85XxIATrIZHYWgNCM7f51k
         xSXttwwfMPjQVRU9I8MZa7eBqoCtEZjby7F5Bo7p4r18yfJ88JF1SazYeXH8ssIGKKx1
         Y12FceIJfAUzYJeTB1sNwUlORqLcaQRBgQtscGtH/NSNbE5amJxcoigQ4on7RiMzIcEh
         dytKej/3JwolkkZvee9jVG+UtT3Cncxh3OZRJflPZAs/XuDZ2M+cz0XXR3mpqm179br1
         fsmA==
X-Forwarded-Encrypted: i=1; AJvYcCWGKLwbSW+fffJnVcrmUfN8faP2kxjtYQHAvkV20VT78YOp3MTDpkjnjMVMIELfuW0erAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwettkY+5BewbeNBWcPuwC27yBPIG1FJi4EWDMU8wg2FIPiRpIT
	Ca6yU33Nb0/2Ur52PBvFNVyoqXnAMG1TLwfAz47G2mpy7UFTy39RomBWx5G9eu8DKtyvONBwMYG
	yHA==
X-Google-Smtp-Source: AGHT+IG2KRTDVbxTtjyliF8d8kQoavYibFy65daI/RR5ZCi5PcdupGkOPRKNJ569wi+RIoyN0Nhf6nfki54=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2b0f:b0:68e:8de6:617c with SMTP id
 00721157ae682-6eecd349dccmr34737b3.5.1732127560373; Wed, 20 Nov 2024 10:32:40
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:32:38 -0800
In-Reply-To: <787182e1-75af-43dc-b7dd-179664022170@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-29-mizhang@google.com>
 <ZzzX0g0LtF_qHggI@google.com> <787182e1-75af-43dc-b7dd-179664022170@linux.intel.com>
Message-ID: <Zz4rRtg0Kfnl1798@google.com>
Subject: Re: [RFC PATCH v3 28/58] KVM: x86/pmu: Add intel_passthrough_pmu_msrs()
 to pass-through PMU MSRs
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 20, 2024, Dapeng Mi wrote:
> On 11/20/2024 2:24 AM, Sean Christopherson wrote:
> >> +	    pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
> >> +	    pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed)
> >> +		msr_intercept = false;
> >> +	else
> >> +		msr_intercept = true;
> > This reinforces that checking PERF_CAPABILITIES for PERF_METRICS is likely doomed
> > to fail, because doesn't PERF_GLOBAL_CTRL need to be intercepted, strictly speaking,
> > to prevent setting EN_PERF_METRICS?
> 
> Sean, do you mean we need to check if guest supports PERF_METRICS here? If
> not, we need to set global MSRs to interception and then avoid guest tries
> to enable guest PERF_METRICS, right?

Yep, exactly.  And that the "nr_arch_fixed_counter == num_counters_fixed" takes
care of things here as well.

