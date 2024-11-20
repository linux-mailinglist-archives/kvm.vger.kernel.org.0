Return-Path: <kvm+bounces-32214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D43BD9D42EE
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 21:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E5B91F23108
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 20:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812231BD03C;
	Wed, 20 Nov 2024 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mC5lihYU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BFC13BAF1
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 20:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732133958; cv=none; b=N4WonzPjqvqOeDbdeGtt3hvc6rxQKMTsOLyu95AWgzH2L8TPAhjnfwH/hdLz0Z+wfYJxPP4YjYuennoe5jRWwwmejIY4vvVRn+XNDYQabm/hTRgTJenCPDtbbpcNFWyGU1Uk3YTKIMWUzaLavSyz9CgolZGE+IY2B5PfyTmrJdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732133958; c=relaxed/simple;
	bh=RW6cRbNEdrg0SPftGP8wi2ade4Dg3TNXphUodG0Bzac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DtKNnlRHf2K8uEhpCp62g3C/HcVchDiIiw2iOPLv4r2H9FMA7J5qiZ8NCt7bQJ25p2CHFEr7ZKpFsO8LxKLDMKxsHAMtjTzL5AKq4sAIrhk8a9zmuVz/cmnj8+lqnCvArp1dM3vFlOsvI+hDmpJqmB9AbmXNtFpUB4cfcTVNpPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mC5lihYU; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eeb5ee73f0so1170197b3.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 12:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732133956; x=1732738756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eRn8aW/pTC4u7+ActWI6S+WTDz59CmhJuTqm5/JelFE=;
        b=mC5lihYUxTf/egafzLXNL2KfAZNiM1nswa68GVDcAEHKiGSpHRZVPQoUMeBOzuKKrR
         9PKXy4vFzjIMltXr2yz/mI1roRQsOZFlAlDyovWQx1K7q5DDjquhpjwQb8QHSGpVBVVO
         iI8eY/51DvMqNsYsakKfB96BFnzeZV0nxcQS5sPyeFaonLhZ9yxJH1I2VaEpNaLU1RPq
         N4T2ehHc8vu0qzCABoNR7ybF71bKgcnpSaEM88v08WY3DZGmHlPNuXkROAV9ZGvKl+X+
         almd/xtK85ZREMNetO1ppD8QCFMu28oca+Vf703JT+IuEHipTp4KcuOHpJbgDNX/bw8h
         A3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732133956; x=1732738756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eRn8aW/pTC4u7+ActWI6S+WTDz59CmhJuTqm5/JelFE=;
        b=GQvTnhLWYTkRHpI4Bzfk3nbXI3HXWudspoqCuqi7t6r01d3WlmrMX0tAihpAGDgCdF
         mfwKewA+obO7CuDsTrU1SYjj0FYWlnv5fPRn3a19ugIxzXBC9vGGx05KmhIb+zcoQ0lo
         uvF6EQwEaqzpjdQY6DSpauXLhKz9/ZUTFAJqxFVslcShwWqjf8FDAl2qakVf45iL8TZe
         hUn6Kc0mZP4Ae6guThmpznaT2x5TgdGMfnsa+7tIWmCcKPAtKDikjPM7hZnIVCPP0aoH
         TGjcdASbjWwclvdofLB8b/RCZX7heOiu/XBYrD81k4UHmzho0secDLqAR3LHTNZo8ehM
         eXng==
X-Forwarded-Encrypted: i=1; AJvYcCVRoFNSvJN+yyXxSh32Zk0EXQpemhEu94W/7sBt5kluAhi7wVTwbogHrjwvEl+JbgZ2JKc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy9wtBrfCe2hX7aIZgbgGTZz43AERJNUFjeZHbAaxzXjS007DE
	6TdLXpyZtIaN7wJrFrHASGiwdfARsWL1uCi6mKWdE6FJo6E8JrLttxdIEqcgpp3J9OFx8OoVEVC
	uxg==
X-Google-Smtp-Source: AGHT+IHyKkDsOH289g9JEPjioa6sUrtiikUvwZ1LdN0K0CGPqNd+A2Wh1qIRG8fRkcn8LZbVXSQr+1cpfNI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2a82:b0:6e9:f188:8638 with SMTP id
 00721157ae682-6eebd2f4943mr19377b3.7.1732133956383; Wed, 20 Nov 2024 12:19:16
 -0800 (PST)
Date: Wed, 20 Nov 2024 12:19:14 -0800
In-Reply-To: <20240801045907.4010984-46-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-46-mizhang@google.com>
Message-ID: <Zz5EQt16V7z-1xCZ@google.com>
Subject: Re: [RFC PATCH v3 45/58] KVM: x86/pmu: Update pmc_{read,write}_counter()
 to disconnect perf API
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> Update pmc_{read,write}_counter() to disconnect perf API because
> passthrough PMU does not use host PMU on backend. Because of that
> pmc->counter contains directly the actual value of the guest VM when set by
> the host (VMM) side.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/pmu.c | 5 +++++
>  arch/x86/kvm/pmu.h | 4 ++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 41057d0122bd..3604cf467b34 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -322,6 +322,11 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
>  
>  void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
>  {
> +	if (pmc_to_pmu(pmc)->passthrough) {
> +		pmc->counter = val;

This needs to mask the value with pmc_bitmask(pmc), otherwise emulated events
will operate on a bad value, and loading the PMU state into hardware will #GP
if the PMC is written through the sign-extended MSRs, i.e. if val = -1 and the
CPU supports full-width writes.

> +		return;
> +	}
> +
>  	/*
>  	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
>  	 * read-modify-write.  Adjust the counter value so that its value is
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 78a7f0c5f3ba..7e006cb61296 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -116,6 +116,10 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
>  {
>  	u64 counter, enabled, running;
>  
> +	counter = pmc->counter;

Using a local variable is pointless, the perf-based path immediately clobbers it.

> +	if (pmc_to_pmu(pmc)->passthrough)
> +		return counter & pmc_bitmask(pmc);

And then this can simply return pmc->counter.  We _could_ add a WARN on pmc->counter
overlapping with pmc_bitmask(), but IMO that's unnecessary.  If anything, WARN and
mask pmc->counter when loading state into hardware.

> +
>  	counter = pmc->counter + pmc->emulated_counter;
>  
>  	if (pmc->perf_event && !pmc->is_paused)
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

