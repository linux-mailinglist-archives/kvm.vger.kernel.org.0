Return-Path: <kvm+bounces-14363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF9A8A222D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 01:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FC531F23B88
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5309147F64;
	Thu, 11 Apr 2024 23:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h/QwSUcT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E547A6A
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 23:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712877518; cv=none; b=gxm9DL2t9Wh+DspNbYRWcdDAwSw/PMZJ5CFr9XiiuDtK3ip2CqI1iMMFlQ0OZ641fbe3bpL1g9igqWpNlWlnA6W9GpwHVfAukZVsE3uguAgdgbqTAXOGcMmEGEbB71rb3deYmEv69yVahNN46cjVTwBz40fp1SGEe9ww1/QwCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712877518; c=relaxed/simple;
	bh=ChViTqgL4O0iExSvoXkrz8rlXUh1To7gRM7Ht5KUpHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=doIZTMKnRT/d6ppiCmYdNS4UdPFmcjUOBODItjy44t1YJaiEOwH8DIeSGPe7oL9PT+uA4gy05ZbB4T7KEcwIK4k+YfABY4aBCPA79dJV72yn4EuaBYvaICfq5rguGJ9FyA5Ww4W2KAYtT7p2vCA5QbCLHlTZFKC27SwHyNFkelY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h/QwSUcT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ecfa420e9cso268053b3a.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712877517; x=1713482317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=saPqzjSurmxMimUcoDIYz/TWWrwnNJQ5t2nRzRoA9jA=;
        b=h/QwSUcTAknLsH0caevy7UKRPMtWKy6/z7ghO5vniGVd3mm3HU6XDtnhVf2db15dfT
         F0VN/DcHUNszYK1VXwKavgO0HnsJMqRa9geE66u1BClVgQWZAalgxxaB1xS2Wz6413dA
         BgXqdTsTY5MUhGAFwAF3jFnOzkr89SuXllbKF+026xVY78ElHvshqPNa+wjQEhvbJizb
         I8+xHXxydnOZC686bzB6g0bBria+OFKJm7pk26UGAzqJzqikJm6wkH88wZrmZ5/3BH3J
         pRwvy2Nttd9uhWH10rTJD4037xLONIWW6jdcfLtbfRuOp5QzUQY7CqWzxl/yyFsubVhH
         9ipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712877517; x=1713482317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=saPqzjSurmxMimUcoDIYz/TWWrwnNJQ5t2nRzRoA9jA=;
        b=J0hK+8sQ36YhaEzqesW0tHMj8bV/giuxE4XcYGv515J9Z/DOm6EAnwqDtybZG8Y0i5
         FfIgZlzWZDq/jflWup1tfApw6ZyZvIlw3LTo2yjezj+OmLldAk5ftNPZthjWwoJ6WClu
         c9VCHvP7bP5WgOAYlTN0ff3TOx62fVZmZT3/aUmC+yR1E9Tik9l8QcnouEP8NHcxutaO
         oPCBcUDmaFm98EeWMnS1xrH+xbj1P3/XRAHJk7rOxDjBJ2ZDiMmqbzFbWIxPwGmSOxtE
         4mLwv5BhqUqHIgMrGQqAhq4x8xX10hg+Bwp+fr1y/F2MpxgQCH+EwHgkpx+2gWexbebZ
         1bng==
X-Forwarded-Encrypted: i=1; AJvYcCUTXz8cT1x6VGIu1EUH/kis/mJ8L6bDK5dSnDgEa0j/1JognV3YkOkbNSif0UnNNOy825we5ImaeS8w98qtdJDBWkFa
X-Gm-Message-State: AOJu0Ywbg9YxvAoN4febb1cShdJy4mzU0Hyg5uyO0mHXSRrQaT2SB5lu
	BK6XDt7COLU5CVOkYCdykGObGi0TyKfg4Hw/+bIRWc+2ggWtDflQT627NbwRrAi/GgiXRck8CIy
	FzQ==
X-Google-Smtp-Source: AGHT+IG8Zh+SkroWzAkIZMDgaZKlj32yE60tkT4BNAP8+QtCUFi+5DUdxxp9vGpRq/V5umwS9iv9z7OxYOM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d17:b0:6ea:c2e5:3fc6 with SMTP id
 fa23-20020a056a002d1700b006eac2e53fc6mr40035pfb.4.1712877516535; Thu, 11 Apr
 2024 16:18:36 -0700 (PDT)
Date: Thu, 11 Apr 2024 16:18:34 -0700
In-Reply-To: <20240126085444.324918-41-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-41-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhvyhdvF-1LZNlu@google.com>
Subject: Re: [RFC PATCH 40/41] KVM: x86/pmu: Separate passthrough PMU logic in
 set/get_msr() from non-passthrough vPMU
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
> From: Mingwei Zhang <mizhang@google.com>
> 
> Separate passthrough PMU logic from non-passthrough vPMU code. There are
> two places in passthrough vPMU when set/get_msr() may call into the
> existing non-passthrough vPMU code: 1) set/get counters; 2) set global_ctrl
> MSR.
> 
> In the former case, non-passthrough vPMU will call into
> pmc_{read,write}_counter() which wires to the perf API. Update these
> functions to avoid the perf API invocation.
> 
> The 2nd case is where global_ctrl MSR writes invokes reprogram_counters()
> which will invokes the non-passthrough PMU logic. So use pmu->passthrough
> flag to wrap out the call.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/pmu.c |  4 +++-
>  arch/x86/kvm/pmu.h | 10 +++++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 9e62e96fe48a..de653a67ba93 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -652,7 +652,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (pmu->global_ctrl != data) {
>  			diff = pmu->global_ctrl ^ data;
>  			pmu->global_ctrl = data;
> -			reprogram_counters(pmu, diff);
> +			/* Passthrough vPMU never reprogram counters. */
> +			if (!pmu->passthrough)

This should probably be handled in reprogram_counters(), otherwise we'll be
playing whack-a-mole, e.g. this misses MSR_IA32_PEBS_ENABLE, which benign, but
only because PEBS isn't yet supported.

> +				reprogram_counters(pmu, diff);
>  		}
>  		break;
>  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 0fc37a06fe48..ab8d4a8e58a8 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -70,6 +70,9 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
>  	u64 counter, enabled, running;
>  
>  	counter = pmc->counter;
> +	if (pmc_to_pmu(pmc)->passthrough)
> +		return counter & pmc_bitmask(pmc);

Won't perf_event always be NULL for mediated counters?  I.e. this can be dropped,
I think.

