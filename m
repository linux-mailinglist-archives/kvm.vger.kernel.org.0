Return-Path: <kvm+bounces-6137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DB382BCC6
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 10:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06B921C241B7
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 09:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A3755C2C;
	Fri, 12 Jan 2024 09:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NB29RUKb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2775755C00;
	Fri, 12 Jan 2024 09:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705051043; x=1736587043;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jrQBu045tUNN/WugD7J1TvCVL3IEFRj8WSed83Rkgpo=;
  b=NB29RUKbFDUtMsly42Hasn0duOaskyoO1TEs2FQx6gnUOMZjXrMBMqA6
   3PEGMUrFiVPopwNXSD8k1SG5MKabMX0Fw6Bj7F0Yg2YHRQkCEimK4yD7N
   gWW9ZOVE4KwkoYe1W7jOz9bXmeOHMptLXotk1P8y5HOHAw9/WQnIyeb6t
   nuoTv7vF9ysUjxE1KQulcfG5/4Wdh4CXAKVmEu13d+heBbXmVnXI2V6fQ
   v6LCu9b379KCBjUpeIaF0oyd6xMzgt6k7UWJjFIivTlhQnhOLEjnSSFlQ
   i49w8mfUfesOCPvJ+6sqZ/wHtqiFIxQ+N63jvaqXqn8XTJpcLrIb2Oybz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="6492592"
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="6492592"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2024 01:17:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="24945522"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.98]) ([10.93.5.98])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2024 01:17:19 -0800
Message-ID: <07bae927-150e-4a81-a3c7-6617a73bba27@linux.intel.com>
Date: Fri, 12 Jan 2024 17:17:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/29] KVM: x86/pmu: selftests: Fixes and new tests
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20240109230250.424295-1-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/10/2024 7:02 AM, Sean Christopherson wrote:
> Knock wood, _this_ is the final of fixes and tests for PMU counters.  New
> in v10 is a small refactor to treat FIXED as a value, not a flag, when
> emulating RDPMC.  Everything else is the same as v9 (although rebased, but
> there were no conflicts).
>
> v10:
>   - Collect review. [Dapeng]
>   - Treat the FIXED type in RDPMC's ECX as a value, not a flag. [Jim]
>
> v9:
>   - https://lore.kernel.org/all/20231202000417.922113-1-seanjc@google.com
>   - Collect reviews. [Dapeng, Kan]
>   - Fix a 63:31 => 63:32 typo in a changelog. [Dapeng]
>   - Actually check that forced emulation is enabled before trying to force
>     emulation on RDPMC. [Jinrong]
>   - Fix the aformentioned priority inversion issue.
>   - Completely drop "support" for fast RDPMC, in quotes because KVM doesn't
>     actually support RDPMC for non-architectural PMUs.  I had left the code
>     in v8 because I didn't fully grok what the early emulator check was
>     doing, i.e. wasn't 100% confident it was dead code.
>
> v8:
>   - https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com
>   - Collect reviews. [Jim, Dapeng, Kan]
>   - Tweak names for the RDPMC flags in the selftests #defines.
>   - Get the event selectors used to virtualize fixed straight from perf
>     instead of hardcoding the (wrong) selectors in KVM. [Kan]
>   - Rename an "eventsel" field to "event" for a patch that gets blasted
>     away in the end anyways. [Jim]
>   - Add patches to fix RDPMC emulation and to test the behavior on Intel.
>     I spot tested on AMD and spent ~30 minutes trying to squeeze in the
>     bare minimum AMD support, but the PMU implementations between Intel
>     and AMD are juuuust different enough to make adding AMD support non-
>     trivial, and this series is already way too big.
>   
> v7:
>   - https://lore.kernel.org/all/20231108003135.546002-1-seanjc@google.com
>   - Drop patches that unnecessarily sanitized supported CPUID. [Jim]
>   - Purge the array of architectural event encodings. [Jim, Dapeng]
>   - Clean up pmu.h to remove useless macros, and make it easier to use the
>     new macros. [Jim]
>   - Port more of pmu_event_filter_test.c to pmu.h macros. [Jim, Jinrong]
>   - Clean up test comments and error messages. [Jim]
>   - Sanity check the value provided to vcpu_set_cpuid_property(). [Jim]
>
> v6:
>   - https://lore.kernel.org/all/20231104000239.367005-1-seanjc@google.com
>   - Test LLC references/misses with CFLUSH{OPT}. [Jim]
>   - Make the tests play nice without PERF_CAPABILITIES. [Mingwei]
>   - Don't squash eventsels that happen to match an unsupported arch event. [Kan]
>   - Test PMC counters with forced emulation (don't ask how long it took me to
>     figure out how to read integer module params).
>
> v5: https://lore.kernel.org/all/20231024002633.2540714-1-seanjc@google.com
> v4: https://lore.kernel.org/all/20230911114347.85882-1-cloudliang@tencent.com
> v3: https://lore.kernel.org/kvm/20230814115108.45741-1-cloudliang@tencent.com
>
> Jinrong Liang (7):
>    KVM: selftests: Add vcpu_set_cpuid_property() to set properties
>    KVM: selftests: Add pmu.h and lib/pmu.c for common PMU assets
>    KVM: selftests: Test Intel PMU architectural events on gp counters
>    KVM: selftests: Test Intel PMU architectural events on fixed counters
>    KVM: selftests: Test consistency of CPUID with num of gp counters
>    KVM: selftests: Test consistency of CPUID with num of fixed counters
>    KVM: selftests: Add functional test for Intel's fixed PMU counters
>
> Sean Christopherson (22):
>    KVM: x86/pmu: Always treat Fixed counters as available when supported
>    KVM: x86/pmu: Allow programming events that match unsupported arch
>      events
>    KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural
>      encodings
>    KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
>    KVM: x86/pmu: Get eventsel for fixed counters from perf
>    KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC index on AMD
>    KVM: x86/pmu: Prioritize VMX interception over #GP on RDPMC due to bad
>      index
>    KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
>    KVM: x86/pmu: Disallow "fast" RDPMC for architectural Intel PMUs
>    KVM: x86/pmu: Treat "fixed" PMU type in RDPMC as index as a value, not
>      flag
>    KVM: x86/pmu: Explicitly check for RDPMC of unsupported Intel PMC
>      types
>    KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
>    KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
>    KVM: selftests: Expand PMU counters test to verify LLC events
>    KVM: selftests: Add a helper to query if the PMU module param is
>      enabled
>    KVM: selftests: Add helpers to read integer module params
>    KVM: selftests: Query module param to detect FEP in MSR filtering test
>    KVM: selftests: Move KVM_FEP macro into common library header
>    KVM: selftests: Test PMC virtualization with forced emulation
>    KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
>    KVM: selftests: Add helpers for safe and safe+forced RDMSR, RDPMC, and
>      XGETBV
>    KVM: selftests: Extend PMU counters test to validate RDPMC after WRMSR
>
>   arch/x86/include/asm/kvm-x86-pmu-ops.h        |   3 +-
>   arch/x86/kvm/emulate.c                        |   2 +-
>   arch/x86/kvm/kvm_emulate.h                    |   2 +-
>   arch/x86/kvm/pmu.c                            |  20 +-
>   arch/x86/kvm/pmu.h                            |   5 +-
>   arch/x86/kvm/svm/pmu.c                        |  17 +-
>   arch/x86/kvm/vmx/pmu_intel.c                  | 178 +++--
>   arch/x86/kvm/x86.c                            |   9 +-
>   tools/testing/selftests/kvm/Makefile          |   2 +
>   .../selftests/kvm/include/kvm_util_base.h     |   4 +
>   tools/testing/selftests/kvm/include/pmu.h     |  97 +++
>   .../selftests/kvm/include/x86_64/processor.h  | 148 ++++-
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +-
>   tools/testing/selftests/kvm/lib/pmu.c         |  31 +
>   .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 617 ++++++++++++++++++
>   .../kvm/x86_64/pmu_event_filter_test.c        | 143 ++--
>   .../smaller_maxphyaddr_emulation_test.c       |   2 +-
>   .../kvm/x86_64/userspace_msr_exit_test.c      |  29 +-
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   2 +-
>   20 files changed, 1097 insertions(+), 291 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/pmu.h
>   create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
>
>
> base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15

pmu_counters_test passes on Intel Sapphire Rapids platform.

Tested-by:  Dapeng Mi <dapeng1.mi@linux.intel.com>


