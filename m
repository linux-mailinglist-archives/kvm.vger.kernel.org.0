Return-Path: <kvm+bounces-14347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0618A211D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:50:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96C532854F8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D103CF79;
	Thu, 11 Apr 2024 21:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GKEzWTFn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A720381B1
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712872233; cv=none; b=OB89gf2zuOG8YCaQb28ifAm6hrpck+A/MKzB96MKW/JQlcImtVX0mz1PefVPyN7YvJgv8bMLAuXQ4g8ui9HvrL8tv8+K8DlzsDHoc9+Df4JQwreUkqM/nYozt4/1yWpojnZt2nAmQuiu/y5ydwWhN7mdvXqvxQWZgWI0DxUWmBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712872233; c=relaxed/simple;
	bh=PQIRuDalA81RPfew+1oM3M1PbSo25ZD+Ob2cgUdhwRI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZkeoYVq/Rv+NlnVLs+l55ZCuBmevOtlQAP2+4C2Wqg6j0b+GrP0NpjTteqE0P2J9QkjZXqih56eeePA4UZmIDHnSycTKt942ccTqgNKBqK3DQh+SsKOdu370EGfM/+T6dA4d5L3NJXZPHmTl8aNNdBf+lqUdXCOSIFWMygJcdsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GKEzWTFn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a300d6a299so205592a91.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712872230; x=1713477030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iaCjUmmDdIOzJKGmZpSSyoXs6qkh/GpGaJ06mDLpr1M=;
        b=GKEzWTFnf5sVuP0IUxt9A8GWbiHHX2Mhwox/3lpnLdb2vU1bICHLAOfcG/J2ZFYjil
         s09kZ5UdRAIiktwxg/vbbtLbEAA0GH9FaK+yKfZGXP15hQUlr1gooptkXJpAy7PDawaq
         45e3lpgP8bPE13sKW+G5oM1K2wLyppneMZO2cxpDJFX6VYuDZlnjKhDf6GqdSeSs5IOc
         XUKLlc5abihqtOUywwM88GIirK9qiqmC/ST3fINtcCIrCd3FOLxlU6R4MnYoTKX/a2L+
         xD9w0LUQWLUL/v3zL9GudEMtKl3nRZYD6P8jUtLFieblMj8EeVhg69CsHxKxzwfYdme5
         x6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872230; x=1713477030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iaCjUmmDdIOzJKGmZpSSyoXs6qkh/GpGaJ06mDLpr1M=;
        b=D3jxUzF2kwteg9Q4IqRQgA/5d7zF+MSQX/GeBz1V4GqgQW0iv8bKjpBZF81XCLEMuo
         VFPvefNBurGi5HVA1Jl7CWyc9ELtLrsCrjUvPxP0vWkdRS49lgrj5dQPWRQgHcCqEgFo
         a23kGOUElivf3cjlqC07CFGBIIEiBzby23sR1OIQv/4SeLy04X6YA7E6gApodPU9VSsd
         1BGIn++QtNMgfHX0wzcyqvJaJYtsD54SZFGCoqRYzKZhpjC9X89ZEzZmJWmcn6Z1PRCg
         erPtHcABYUj7tnFdk3mJhcwGJ+ol5wYDpWKoceSj7KUnaXj+1gSQMTdMXVsOkJM2OBvu
         9CRw==
X-Forwarded-Encrypted: i=1; AJvYcCUeewUbrv8WEhXIdu1fyzz/PFu/h5NH8Uuxy/tAeieUnS4SFYW9qfsdGZWWHD7wDNBN7BG07Y70LVjxNn00ID7oiuCa
X-Gm-Message-State: AOJu0YxDtAycKcPGZWg5YUw4QA1mu0T6BaKxMr3rTQe0SqMFAd1YtA19
	LSbuKGyIqKT1d6RVCh2HIWu5V72v/T6gAf8sgK9Dk/l98jObya2Xxnyboxb7BvN3YHheRoQeBpz
	x4w==
X-Google-Smtp-Source: AGHT+IHoU3vWBVtinqVLN1A8TwfMLrhsEG6lZ6A6/VWf1bt/DoqDl+FQZvyCl4pbADg3UfMsA+vwmkWh0kw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:128f:b0:2a4:8940:41c7 with SMTP id
 fw15-20020a17090b128f00b002a4894041c7mr2248pjb.4.1712872230439; Thu, 11 Apr
 2024 14:50:30 -0700 (PDT)
Date: Thu, 11 Apr 2024 14:50:28 -0700
In-Reply-To: <20240126085444.324918-28-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-28-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhbJCGcJ6Rshkfk@google.com>
Subject: Re: [RFC PATCH 27/41] KVM: x86/pmu: Clear PERF_METRICS MSR for guest
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 
> Since perf topdown metrics feature is not supported yet, clear
> PERF_METRICS MSR for guest.

Please rewrite with --verbose, I have no idea what MSR_PERF_METRICS, and thus no
clue why it needs to be zeroed when loading guest context, e.g. it's not passed
through, so why does it matter?

> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 4b4da7f17895..ad0434646a29 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -916,6 +916,10 @@ static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
>  	 */
>  	for (i = pmu->nr_arch_fixed_counters; i < kvm_pmu_cap.num_counters_fixed; i++)
>  		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> +
> +	/* Clear PERF_METRICS MSR since guest topdown metrics is not supported yet. */
> +	if (kvm_caps.host_perf_cap & PMU_CAP_PERF_METRICS)
> +		wrmsrl(MSR_PERF_METRICS, 0);
>  }
>  
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
> -- 
> 2.34.1
> 

