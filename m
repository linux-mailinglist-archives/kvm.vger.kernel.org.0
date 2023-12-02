Return-Path: <kvm+bounces-3184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C08E80186D
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8150BB210AB
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403E6EC3;
	Sat,  2 Dec 2023 00:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hy+thUjV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373009A
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:21 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c65e666609so143717a12.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475460; x=1702080260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFYOzjq2VL9ltumoNAO/cRr/UGIDvUYIMH6fYtB6gdQ=;
        b=Hy+thUjVRKSTg3tc70DKHBoGaKYcACx/c9r/7NDTFNbpqWtphGdiR52PYcbjJexq8S
         HIrkJ79leMKLZ55bGZfXIgsd8tN2Aw+KaGtFB5NSyy1yvPhExXObSzzke28dWHym75N/
         qXaVbo+4I4hODOumncfM/WsuwllzOVRv5DC07Jm8TTtK/Vahgd+E4PB+UbNaMyMfRjZ5
         15K7BpZYu3l/0KopgpWjWdxvd29oCOyTnDuiOV5d/Fi4ecXb/0ADksC2p9pg41gwXPcf
         iifMPCoibJ3ULYlUBmsoJ998kMMAVnGQEFQSd9qeS6w2n9NBYGoWvFAdix+vIzl/UV15
         l4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475460; x=1702080260;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LFYOzjq2VL9ltumoNAO/cRr/UGIDvUYIMH6fYtB6gdQ=;
        b=HG2MheHu/AWE58U5cuR8KAdADbwtkLjXF/B0FxMnxY1j4bMwIrh1BIEhDJNN/er1ix
         Q101k2k054XwKq3IH3LwpHNq0NiZheVVAh/+QipkPw75XEfZb2jMYrckKuqwVjMIyjJB
         nxzDR2Xz4kkmVPMeJCZiDCkkovTmnbvufDZVcdUBaghuB618P8KtfeVj3wH9kNiYHwDF
         KVYbyIhMYZ0BAbX8WAALL8C1qgvX1xjF2xtIJ8YICrhL7ig8xrDDv+YYazWAq+YjUVMY
         +W/4Njigs9C5ff9gueMlUP0YJav/RMTnwUxc68n192/zFLj9MTfZzispclloQ3uqugbc
         hzZQ==
X-Gm-Message-State: AOJu0YzV7t1IzjvPYJuEICw8dyH9oEcE5UmELpKvft+6+TnUBlkvRnee
	SAptEuUaYJ2aj+/1ZLLPLz6t2Od+cz0=
X-Google-Smtp-Source: AGHT+IHc9rKg8F3PB3igngLCLbvOxvpTOSdedUDtn6wa2GgKO3w6jaVX/2dX5QkWuYkB2xevlwsm7dRHZFI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:154c:0:b0:5c1:589d:b3dc with SMTP id
 12-20020a63154c000000b005c1589db3dcmr4375541pgv.1.1701475460655; Fri, 01 Dec
 2023 16:04:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:03:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-1-seanjc@google.com>
Subject: [PATCH v9 00/28] KVM: x86/pmu: selftests: Fixes and new tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Yet another version of fixes and tests for PMU counters.  New in v9 is a
fix for priority inversion of #GP vs. VM-Exit on Intel when KVM fully
emulates a RDPMC with a "bad" index.  For all intents and purposes, this
priority inversion triggered the WARN in v8[*], which is why I included
the fix in this series (and because the fix would conflict horribly).

Dapeng, I dropped one of your reviews (patch "Disallow "fast" RDPMC for
architectural Intel PMUs) as the patch ended up being quite different after
eliminating the early RDPMC index check.

[*] https://lore.kernel.org/all/ZU69h65HwvnpjhjX@google.com

v9:
 - Collect reviews. [Dapeng, Kan]
 - Fix a 63:31 => 63:32 typo in a changelog. [Dapeng]
 - Actually check that forced emulation is enabled before trying to force
   emulation on RDPMC. [Jinrong]
 - Fix the aformentioned priority inversion issue.
 - Completely drop "support" for fast RDPMC, in quotes because KVM doesn't
   actually support RDPMC for non-architectural PMUs.  I had left the code
   in v8 because I didn't fully grok what the early emulator check was
   doing, i.e. wasn't 100% confident it was dead code.

v8:
 - https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com
 - Collect reviews. [Jim, Dapeng, Kan]
 - Tweak names for the RDPMC flags in the selftests #defines.
 - Get the event selectors used to virtualize fixed straight from perf
   instead of hardcoding the (wrong) selectors in KVM. [Kan]
 - Rename an "eventsel" field to "event" for a patch that gets blasted
   away in the end anyways. [Jim]
 - Add patches to fix RDPMC emulation and to test the behavior on Intel.
   I spot tested on AMD and spent ~30 minutes trying to squeeze in the
   bare minimum AMD support, but the PMU implementations between Intel
   and AMD are juuuust different enough to make adding AMD support non-
   trivial, and this series is already way too big.
 
v7:
 - https://lore.kernel.org/all/20231108003135.546002-1-seanjc@google.com
 - Drop patches that unnecessarily sanitized supported CPUID. [Jim]
 - Purge the array of architectural event encodings. [Jim, Dapeng]
 - Clean up pmu.h to remove useless macros, and make it easier to use the
   new macros. [Jim]
 - Port more of pmu_event_filter_test.c to pmu.h macros. [Jim, Jinrong]
 - Clean up test comments and error messages. [Jim]
 - Sanity check the value provided to vcpu_set_cpuid_property(). [Jim]

v6:
 - https://lore.kernel.org/all/20231104000239.367005-1-seanjc@google.com
 - Test LLC references/misses with CFLUSH{OPT}. [Jim]
 - Make the tests play nice without PERF_CAPABILITIES. [Mingwei]
 - Don't squash eventsels that happen to match an unsupported arch event. [Kan]
 - Test PMC counters with forced emulation (don't ask how long it took me to
   figure out how to read integer module params).

v5: https://lore.kernel.org/all/20231024002633.2540714-1-seanjc@google.com
v4: https://lore.kernel.org/all/20230911114347.85882-1-cloudliang@tencent.com
v3: https://lore.kernel.org/kvm/20230814115108.45741-1-cloudliang@tencent.com

Jinrong Liang (7):
  KVM: selftests: Add vcpu_set_cpuid_property() to set properties
  KVM: selftests: Add pmu.h and lib/pmu.c for common PMU assets
  KVM: selftests: Test Intel PMU architectural events on gp counters
  KVM: selftests: Test Intel PMU architectural events on fixed counters
  KVM: selftests: Test consistency of CPUID with num of gp counters
  KVM: selftests: Test consistency of CPUID with num of fixed counters
  KVM: selftests: Add functional test for Intel's fixed PMU counters

Sean Christopherson (21):
  KVM: x86/pmu: Always treat Fixed counters as available when supported
  KVM: x86/pmu: Allow programming events that match unsupported arch
    events
  KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural
    encodings
  KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
  KVM: x86/pmu: Get eventsel for fixed counters from perf
  KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC index on AMD
  KVM: x86/pmu: Prioritize VMX interception over #GP on RDPMC due to bad
    index
  KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
  KVM: x86/pmu: Disallow "fast" RDPMC for architectural Intel PMUs
  KVM: x86/pmu: Explicitly check for RDPMC of unsupported Intel PMC
    types
  KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
  KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
  KVM: selftests: Expand PMU counters test to verify LLC events
  KVM: selftests: Add a helper to query if the PMU module param is
    enabled
  KVM: selftests: Add helpers to read integer module params
  KVM: selftests: Query module param to detect FEP in MSR filtering test
  KVM: selftests: Move KVM_FEP macro into common library header
  KVM: selftests: Test PMC virtualization with forced emulation
  KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
  KVM: selftests: Add helpers for safe and safe+forced RDMSR, RDPMC, and
    XGETBV
  KVM: selftests: Extend PMU counters test to validate RDPMC after WRMSR

 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   3 +-
 arch/x86/kvm/emulate.c                        |   2 +-
 arch/x86/kvm/kvm_emulate.h                    |   2 +-
 arch/x86/kvm/pmu.c                            |  20 +-
 arch/x86/kvm/pmu.h                            |   5 +-
 arch/x86/kvm/svm/pmu.c                        |  17 +-
 arch/x86/kvm/vmx/pmu_intel.c                  | 157 ++---
 arch/x86/kvm/x86.c                            |   9 +-
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     |   4 +
 tools/testing/selftests/kvm/include/pmu.h     |  97 +++
 .../selftests/kvm/include/x86_64/processor.h  | 148 ++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 +-
 tools/testing/selftests/kvm/lib/pmu.c         |  31 +
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 617 ++++++++++++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        | 143 ++--
 .../smaller_maxphyaddr_emulation_test.c       |   2 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  29 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   2 +-
 20 files changed, 1079 insertions(+), 288 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c


base-commit: 9f018b692c0114a484cea4faf9758a224774866a
-- 
2.43.0.rc2.451.g8631bc7472-goog


