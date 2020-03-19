Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F2418ACD0
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgCSGfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:35:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:51299 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgCSGfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:35:30 -0400
IronPort-SDR: jAqTvka35ViE+GAudoZ/cQaT25DXIoZPuRaNUSHWRYZTDSlA31jziqYiK0+UCW/ux9Vw/SzvCI
 P7O59klnAFsQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:35:30 -0700
IronPort-SDR: JjJIFAbFGye2coKeGQkBdUKDRzZ8ruE0DyVb+H5EoqBg/iQ1rysMNE1vEQvWG+R1YVs0y+Ffo6
 MZGgRTdhYMnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="248439070"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 23:35:24 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v2 0/5] PEBS virtualization enabling via Intel PT
Date:   Thu, 19 Mar 2020 22:33:45 +0800
Message-Id: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel new hardware(Atom processors based on the Tremont
microarchitecture) introduces some Processor Event-Based Sampling(PEBS)
extensions that output the PEBS record to Intel PT stream instead of DS
area. The PEBS record will be packaged in a specific format when
outputting to Intel PT.

This patch set will enable PEBS functionality in KVM Guest by PEBS output
to Intel PT, base on PEBS virtualization enabling via DS patch set[1].

Compared to the v1, the common code of PEBS virtualization enabling(PEBS
via DS and PEBS via Intel PT) has been moved to PEBS via DS patch set.
This patch set only includes the PEBS via PT specific changes.

Patch 1 is an extension to get fixed function counter by reload MSRs;
Patch 2,3 implement the CPUID and MSRs emulation;
Patch 4 will add the counter reload MSRs to MSR list during VM-entry/exit;
Patch 5 will swith the PEBS records to Intel PT buffer if PEBS via PT is
        enabled in KVM guest.

[1]: https://lore.kernel.org/kvm/1583431025-19802-1-git-send-email-luwei.kang@intel.com/

Luwei Kang (5):
  KVM: x86/pmu: Add base address parameter for get_fixed_pmc function
  KVM: x86/pmu: Expose PDCM feature when PEBS output to PT
  KVM: x86/pmu: PEBS output Intel PT MSRs emulation
  KVM: x86/pmu: Add counter reload register to MSR list
  KVM: VMX: Switch PEBS records output to Intel PT buffer

 arch/x86/events/perf_event.h     |   5 --
 arch/x86/include/asm/kvm_host.h  |   2 +
 arch/x86/include/asm/msr-index.h |   6 +++
 arch/x86/kvm/pmu.h               |   6 +--
 arch/x86/kvm/vmx/capabilities.h  |   9 +++-
 arch/x86/kvm/vmx/pmu_intel.c     | 112 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c           |   3 ++
 arch/x86/kvm/vmx/vmx.h           |   2 +-
 arch/x86/kvm/x86.c               |  32 +++++++++++
 9 files changed, 154 insertions(+), 23 deletions(-)

-- 
1.8.3.1

