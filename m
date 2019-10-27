Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38407E621C
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 12:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfJ0LMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 07:12:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:12491 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfJ0LMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 07:12:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282690135"
Received: from unknown (HELO snr.jf.intel.com) ([10.54.39.141])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:12:28 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        peterz@infradead.org, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 0/8] PEBS enabling in KVM guest
Date:   Sun, 27 Oct 2019 19:11:09 -0400
Message-Id: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel new hardware introduces some Precise Event-Based Sampling(PEBS)
extensions that output the PEBS record to Intel PT stream instead of
DS area. The PEBS record will be packaged in a specific format when
outputting to Intel PT. This patch set will enable PEBS functionality
in KVM Guest by PEBS output to Intel PT.

The patch 1 introduce a MSRs "base" parameter that use for get the
kvm_pmc structure by New MSR_RELOAD_FIXED_CTRx like get_gp_pmc()
function. The patch 2 implement the PEBS MSRs read/write emulation.
Patch 5/6/7 expose some capabilities(CPUID, MSRs) to KVM guest which
relate with PEBS feature. Patch 3 introduces "pebs" parameter to
allocate a perf event counter from host perf event framework.
The counter using for PEBS event should be disabled before VM-entry
in the previous platform, patch 4 skip this operation when PEBS is
enabled in KVM guest. Patch 8 has some code changes in native that to
make the aux_event only be needed for a non-kernel event(the couner
allocate by KVM is kernel event).

Luwei Kang (8):
  KVM: x86: Add base address parameter for get_fixed_pmc function
  KVM: x86: PEBS output to Intel PT MSRs emulation
  KVM: x86: Allocate performance counter for PEBS event
  KVM: x86: Aviod clear the PEBS counter when PEBS enabled in guest
  KVM: X86: Expose PDCM cpuid to guest
  KVM: X86: MSR_IA32_PERF_CAPABILITIES MSR emulation
  KVM: x86: Expose PEBS feature to guest
  perf/x86: Add event owner check when PEBS output to Intel PT

 arch/x86/events/core.c            |  3 +-
 arch/x86/events/intel/core.c      | 19 ++++++----
 arch/x86/events/perf_event.h      |  2 +-
 arch/x86/include/asm/kvm_host.h   |  7 ++++
 arch/x86/include/asm/msr-index.h  |  9 +++++
 arch/x86/include/asm/perf_event.h |  5 ++-
 arch/x86/kvm/cpuid.c              |  3 +-
 arch/x86/kvm/pmu.c                | 23 ++++++++----
 arch/x86/kvm/pmu.h                | 10 ++---
 arch/x86/kvm/pmu_amd.c            |  2 +-
 arch/x86/kvm/svm.c                | 12 ++++++
 arch/x86/kvm/vmx/capabilities.h   | 25 +++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c      | 79 +++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c            | 19 +++++++++-
 arch/x86/kvm/x86.c                | 22 ++++++++---
 include/linux/perf_event.h        |  1 +
 kernel/events/core.c              |  2 +-
 17 files changed, 201 insertions(+), 42 deletions(-)

-- 
1.8.3.1

