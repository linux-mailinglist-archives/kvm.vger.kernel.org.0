Return-Path: <kvm+bounces-46617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2264BAB7AB6
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38DC18C420D
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4707261A;
	Thu, 15 May 2025 00:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="obcs8GVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE701DDE9
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747270166; cv=none; b=DToLC97fuM+Vj9IyPoa5KKW+fASo/x/hrc6Y5izDc5W7brzCpyPjt78ROmaE9DIKyjZ1z2+3RGWtxPP1idYQwFeuj/Zoaf33PRFTRS22yL0bOn6a5OtRv48SuuNuFLuPkSHzbHlKtxO1TwQFztBxxmku/olqPMY4e9XcyJJDmx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747270166; c=relaxed/simple;
	bh=jPnzg6PNsN6lUzHoKMbxdMvPtIe0LNuhdxU8f6d8XHM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vglqjl7WabD5RH84WU8zQOovSXMOlJI5qwtsGYMMaeKSegyAaneL0MEwPoYouQIMShbwgOc1pPHTHdeTW2ti6GrPSkBF3BcqJRpXJggpBy2JC6z3QM5dK5b01elAJNP4dR3zRAGxHHUzyEsGkbF7fYw17Nph9luiFpb4UMjw86Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=obcs8GVN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1fdf8f67e6so172083a12.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 17:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747270164; x=1747874964; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hMfietv3cfwdDUfJJ6Vu0q3GZ0OBruwHSCB3xq9gft0=;
        b=obcs8GVNe6j8T8Ck0DEPBVHuNs5kfkVvmPdQjAX/POma6uMLdaKQDNhIPdTaBz4E5R
         pHNut+1MSlI4muJ9zQFato4ySFqBU8/c7AbxiOGuSO5/nEhlh3eKXBGCO2IxtQnO2hec
         J3/97txx7W1+gfWHWXOtj3CPIdra4mT9sFOoOv9lZvtYvvKz88Y7jfpbdB6eHebuLZrS
         g1yIra/n6G1r7reDrpvFL2NLqaSKksHxP9W0vPtbKaRl0vIQtGLZOlAfcODktPCKCFaj
         1m0euXS8SXN/wbpZA25gvjktpgwoKxjLM3UNhadZqqzOLbaZaxmH4pMcFDQWYX44cIUp
         2SWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747270164; x=1747874964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMfietv3cfwdDUfJJ6Vu0q3GZ0OBruwHSCB3xq9gft0=;
        b=kird9NJKxP6c7oRNck0hvp4nyn9ncbFPZFm45UuvYY1VNRYacewtP57I6tBhOhBFZz
         Pu4GsEYVKgwomAu4fzL2/FPe2KSpwp8nMoLNRpSEdpuGOYggmhDyMejvAEt6iZpcm1oA
         LmyPWSLn5/mO6ll/XRrFZqHwU2/IiCyXnaCq5YTQJIaATytA6+Xmw1AiJHdWjSVvw9r9
         Wx/+32wAxsrm3j9OobXuMOIWcNQfpacMh0CrpoIWLa/SdbpIlAoPH85MPnZKNikkM9FS
         40xd3LrACrkvUOnXwDF0o1J8JN8vpqUTUrWh4FiG1QpqAnX6mN/ZVSM9Eh0QKefCcooa
         bv1g==
X-Forwarded-Encrypted: i=1; AJvYcCUT1uYrwf6XqQYU0zs42lKGeNab8zxGfLRDVq6FsC+6qB2bak0n7qfhxLjwkfO9+hW327o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3bJw3GkNevbxZHhP+SixfBQagmFDigwYAvFJdQojAVyNtUZcR
	/pMp/wY8zkdegiHyWDt9WvOF+ajLYPuj2XiNHvu8EdFDL7jypXza2N60E+QmhM4XEiNFz3xLMn7
	73w==
X-Google-Smtp-Source: AGHT+IEkFXVGxtOuqdcAPO0vpFEVYeUwvYJWz2kVDDpTt9pJsdBPXKA7ndT83tbNuCGk6UN2X+RRAvKJR+4=
X-Received: from pjc14.prod.google.com ([2002:a17:90b:2f4e:b0:2fc:1356:bcc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c8:b0:2ff:5a9d:937f
 with SMTP id 98e67ed59e1d1-30e2e65affamr8466341a91.24.1747270163943; Wed, 14
 May 2025 17:49:23 -0700 (PDT)
Date: Wed, 14 May 2025 17:49:22 -0700
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
Message-ID: <aCU6EjbXzPct9v7B@google.com>
Subject: Re: [PATCH v4 00/38] Mediated vPMU 4.0 for x86
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Sandipan Das <sandipan.das@amd.com>, Zide Chen <zide.chen@intel.com>, 
	Eranian Stephane <eranian@google.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Mingwei Zhang wrote:
> Dapeng Mi (18):
>   KVM: x86/pmu: Introduce enable_mediated_pmu global parameter
>   KVM: x86/pmu: Check PMU cpuid configuration from user space
>   KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
>   KVM: x86/pmu: Add perf_capabilities field in struct kvm_host_values{}
>   KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
>   KVM: VMX: Add macros to wrap around
>     {secondary,tertiary}_exec_controls_changebit()
>   KVM: x86/pmu: Check if mediated vPMU can intercept rdpmc
>   KVM: x86/pmu/vmx: Save/load guest IA32_PERF_GLOBAL_CTRL with
>     vm_exit/entry_ctrl
>   KVM: x86/pmu: Optimize intel/amd_pmu_refresh() helpers
>   KVM: x86/pmu: Setup PMU MSRs' interception mode
>   KVM: x86/pmu: Handle PMU MSRs interception and event filtering
>   KVM: x86/pmu: Switch host/guest PMU context at vm-exit/vm-entry
>   KVM: x86/pmu: Handle emulated instruction for mediated vPMU
>   KVM: nVMX: Add macros to simplify nested MSR interception setting
>   KVM: selftests: Add mediated vPMU supported for pmu tests
>   KVM: Selftests: Support mediated vPMU for vmx_pmu_caps_test
>   KVM: Selftests: Fix pmu_counters_test error for mediated vPMU
>   KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space
> 
> Kan Liang (8):
>   perf: Support get/put mediated PMU interfaces
>   perf: Skip pmu_ctx based on event_type
>   perf: Clean up perf ctx time
>   perf: Add a EVENT_GUEST flag
>   perf: Add generic exclude_guest support
>   perf: Add switch_guest_ctx() interface
>   perf/x86: Support switch_guest_ctx interface
>   perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU
> 
> Mingwei Zhang (5):
>   perf/x86: Forbid PMI handler when guest own PMU
>   perf/x86/core: Plumb mediated PMU capability from x86_pmu to
>     x86_pmu_cap
>   KVM: x86/pmu: Exclude PMU MSRs in vmx_get_passthrough_msr_slot()
>   KVM: x86/pmu: introduce eventsel_hw to prepare for pmu event filtering
>   KVM: nVMX: Add nested virtualization support for mediated PMU
> 
> Sandipan Das (4):
>   perf/x86/core: Do not set bit width for unavailable counters
>   KVM: x86/pmu: Add AMD PMU registers to direct access list
>   KVM: x86/pmu/svm: Set GuestOnly bit and clear HostOnly bit when guest
>     write to event selectors
>   perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for AMD host
> 
> Xiong Zhang (3):
>   x86/irq: Factor out common code for installing kvm irq handler
>   perf: core/x86: Register a new vector for KVM GUEST PMI
>   KVM: x86/pmu: Register KVM_GUEST_PMI_VECTOR handler

I ran out of time today and didn't get emails send for all patches.  I'm planning
on getting that done tomorrow.

I already have most of the proposed changes implemented:

  https://github.com/sean-jc/linux.git x86/mediated_pmu

It compiles and doesn't explode, but it's not fully functional (PMU tests fail).
I'll poke at it over the next few days, but if someone is itching to figure out
what I broke, then by all means.

Given that I've already made many modifications (I have a hard time reviewing a
series this big without editing as I go), unless someone objects, I'll post v5
(and v6+ as needed), though that'll like be days/weeks as I need to get it working,
and want to do more passes over the code, shortlogs, and changelogs. 

