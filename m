Return-Path: <kvm+bounces-32965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D5D9E2FBC
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 00:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 012ED283080
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 23:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2AD20ADCE;
	Tue,  3 Dec 2024 23:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WNw9x4KO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F68460
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 23:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733267967; cv=none; b=OSmN20Aq3fXTL32ssM//VnRKDq7MA2rim05RtA282QkjwYTbIgpjiPEYUmm3UZe+4kPB2ccVS479QNPdej6P78Xp0axT8SuUrvQkuSmbdSxhuKGlU3fQS8qZFZfZnxIoK0HxT8NJ1GYcGp4hUehcaa1WGYeCG/gEXDiD3cuhUZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733267967; c=relaxed/simple;
	bh=6LoedgRoxKbLS6I0Jr2Y+fFTtC2cwrXs4o1BOPkflQE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pLLAXtKjx1x/1xn+9pthjVD+9tntQQTExgHqcdE505eHtdqcmxXMNiEHrUBSx8tyaLZzKykkWhq7oiE0YhDdk1bB6h92fR1iSNGF4MFhzlmtZFmZP11L0J6VlEUMpICmLvMg3OKfHhYVickeRx2kO6wCB6kE+kBhCYHRG/RmRcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WNw9x4KO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee948b77c9so4587554a91.3
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 15:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733267965; x=1733872765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OHr8G/o42AeDVOD1/MrSjm2WXYW40d8E8bqJA870ZHc=;
        b=WNw9x4KOOKLlbM1w+liabvzdQfaQY88QLYql3Oji8v5UTyQmTS0OK2K2VRwJtvrxix
         NtxRVYHOGiVGwcrjwXWucBGX/GJASS6uGVU677/64bPUDEhMu7Jsfo/wH5Oqd4788SQ7
         xaOxfMgWXRZDRdln/ALDU1EWfAvhDPdyamoigFggd/OG7QM+o9MEBbBXrfS1DE+EJcBu
         PYlvOZ20lqaE+thQSu2cqvkr37fpx3iNrOLRt7J0JtV0ZRvu5C3xayFF4518wdkwqf4m
         /2tnGe7aQ8Lij7NwqLE84cBCzLZPcCN4/jbZwAMO53A8mtAgBFnlUUmZVXng62bLIr5t
         a9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733267965; x=1733872765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OHr8G/o42AeDVOD1/MrSjm2WXYW40d8E8bqJA870ZHc=;
        b=QANt7puTONg5CRgSlHhqm2Xl+dRnKHu7D7oqD78qoQUF3U1QRZMUXA2Obg+TpRKKPH
         RCTUUrUKa+uLHEVc63uKnrUEmvTu9kSOr7+X6i3JD67ddEdi0FqC5xMgUXaJ180Y/9ff
         dyxRPLZNsTVTCTdreOqbVsPTKDWZ9IP46J+5/+VI6iKlKSwmXhkTmINGROQaf1z0ZbZR
         tkmmSFVOOPJhQ8tysZy+WtCuDgmCfiD10aRtddkx3iOMx7gkinlLMe56isJyh6g8bn1f
         /RGnrPDuhlHvdkTiVEi8mOxHI/DEwST4GudLXq3Imh5+B2IuJEgIDsTCLgA5sxQ/Ghyy
         rA/w==
X-Forwarded-Encrypted: i=1; AJvYcCVXm5KjhgeId9XgS9OThbuhhcdfeX41jat/fqP7EoXFj0R2bwxFuBToN5O6h7AybJ5qbYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKKC1tgJvjrUo14uZb9sIx6aHnQlbvTEwIMgH16+I81dH8rzcE
	DIZkup+YFhK7hHkvxdCQICrMVnSPJgKtwFNb+uDx1bSBMFDMjTl36zB8HfrI+dLrgWKCPmNTy8t
	nwg==
X-Google-Smtp-Source: AGHT+IEWC65x0FRBHA/jPbLxpwMAa/0mA0vx1CB4p5bkmbcIagVt0ag62+9DkfkKAECyWflC0sTE+7wlNR0=
X-Received: from pjyd15.prod.google.com ([2002:a17:90a:dfcf:b0:2ea:5dea:eafa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:224a:b0:2ee:fdf3:38ea
 with SMTP id 98e67ed59e1d1-2ef0125b2a3mr5714195a91.23.1733267964831; Tue, 03
 Dec 2024 15:19:24 -0800 (PST)
Date: Tue, 3 Dec 2024 15:19:23 -0800
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
Message-ID: <Z0-R-_GPWu-iVAYM@google.com>
Subject: Re: [RFC PATCH 00/22] KVM: x86: Virtualize IA32_APERF and IA32_MPERF MSRs
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huang Rui <ray.huang@amd.com>, 
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 21, 2024, Mingwei Zhang wrote:
> Linux guests read IA32_APERF and IA32_MPERF on every scheduler tick
> (250 Hz by default) to measure their effective CPU frequency. To avoid
> the overhead of intercepting these frequent MSR reads, allow the guest
> to read them directly by loading guest values into the hardware MSRs.
> 
> These MSRs are continuously running counters whose values must be
> carefully tracked during all vCPU state transitions:
> - Guest IA32_APERF advances only during guest execution

That's not what this series does though.  Guest APERF advances while the vCPU is
loaded by KVM_RUN, which is *very* different than letting APERF run freely only
while the vCPU is actively executing in the guest.

E.g. a vCPU that is memory oversubscribed via zswap will account a significant
amount of CPU time in APERF when faulting in swapped memory, whereas traditional
file-backed swap will not due to the task being scheduled out while waiting on I/O.

In general, the "why" of this series is missing.  What are the use cases you are
targeting?  What are the exact semantics you want to define?  *Why* did are you
proposed those exact semantics?

E.g. emulated I/O that is handled in KVM will be accounted to APERF, but I/O that
requires userspace exits will not.  It's not necessarily wrong for heavy userspace
I/O to cause observed frequency to drop, but it's not obviously correct either.

The use cases matter a lot for APERF/MPERF, because trying to reason about what's
desirable for an oversubscribed setup requires a lot more work than defining
semantics for setups where all vCPUs are hard pinned 1:1 and memory is more or
less just partitioned.  Not to mention the complexity for trying to support all
potential use cases is likely quite a bit higher.

And if the use case is specifically for slice-of-hardware, hard pinned/partitioned
VMs, does it matter if the host's view of APERF/MPERF is not accurately captured
at all times?  Outside of maybe a few CPUs running bookkeeping tasks, the only
workloads running on CPUs should be vCPUs.  It's not clear to me that observing
the guest utilization is outright wrong in that case.

One idea for supporting APERF/MPERF in KVM would be to add a kernel param to
disable/hide APERF/MPERF from the host, and then let KVM virtualize/passthrough
APERF/MPERF if and only if the feature is supported in hardware, but hidden from
the kernel.  I.e. let the system admin gift APERF/MPERF to KVM.

> - Guest IA32_MPERF advances at the TSC frequency whenever the vCPU is
>   in C0 state, even when not actively running
> - Host kernel access is redirected through get_host_[am]perf() which
>   adds per-CPU offsets to the hardware MSR values
> - Remote MSR reads through /dev/cpu/*/msr also account for these
>   offsets
> 
> Guest values persist in hardware while the vCPU is loaded and
> running. Host MSR values are restored on vcpu_put (either at KVM_RUN
> completion or when preempted) and when transitioning to halt state.
> 
> Note that guest TSC scaling via KVM_SET_TSC_KHZ is not supported, as
> it would require either intercepting MPERF reads on Intel (where MPERF
> ticks at host rate regardless of guest TSC scaling) or significantly
> complicating the cycle accounting on AMD.
> 
> The host must have both CONSTANT_TSC and NONSTOP_TSC capabilities
> since these ensure stable TSC frequency across C-states and P-states,
> which is required for accurate background MPERF accounting.

...

>  arch/x86/include/asm/kvm_host.h  |  11 ++
>  arch/x86/include/asm/topology.h  |  10 ++
>  arch/x86/kernel/cpu/aperfmperf.c |  65 +++++++++++-
>  arch/x86/kvm/cpuid.c             |  12 ++-
>  arch/x86/kvm/governed_features.h |   1 +
>  arch/x86/kvm/lapic.c             |   5 +-
>  arch/x86/kvm/reverse_cpuid.h     |   6 ++
>  arch/x86/kvm/svm/nested.c        |   2 +-
>  arch/x86/kvm/svm/svm.c           |   7 ++
>  arch/x86/kvm/svm/svm.h           |   2 +-
>  arch/x86/kvm/vmx/nested.c        |   2 +-
>  arch/x86/kvm/vmx/vmx.c           |   7 ++
>  arch/x86/kvm/vmx/vmx.h           |   2 +-
>  arch/x86/kvm/x86.c               | 171 ++++++++++++++++++++++++++++---
>  arch/x86/lib/msr-smp.c           |  11 ++
>  drivers/cpufreq/amd-pstate.c     |   4 +-
>  drivers/cpufreq/intel_pstate.c   |   5 +-
>  17 files changed, 295 insertions(+), 28 deletions(-)
> 
> 
> base-commit: 0a9b9d17f3a781dea03baca01c835deaa07f7cc3
> -- 
> 2.47.0.371.ga323438b13-goog
> 

