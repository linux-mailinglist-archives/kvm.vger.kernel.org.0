Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3971FA10EC
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfH2Fio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:38:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:2355 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfH2Fio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:38:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:38:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="210416043"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 22:38:40 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [RFC v1 0/9] PEBS enabling in KVM guest
Date:   Thu, 29 Aug 2019 13:34:00 +0800
Message-Id: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel new hardware introduces some Precise Event-Based Sampling (PEBS)
extensions that output the PEBS record to Intel PT stream instead of
DS area. The PEBS record will be packaged in a specific format when
outputing to Intel PT.

This patch set will enable PEBS functionality in KVM Guest by PEBS
output to Intel PT. The native driver as [1] (still under review).

[1] https://www.spinics.net/lists/kernel/msg3215354.html

Luwei Kang (9):
  KVM: x86: Add base address parameter for get_fixed_pmc function
  KVM: x86: PEBS via Intel PT HW feature detection
  KVM: x86: Implement MSR_IA32_PEBS_ENABLE read/write emulation
  KVM: x86: Implement counter reload MSRs read/write emulation
  KVM: x86: Allocate performance counter for PEBS event
  KVM: x86: Add shadow value of PEBS status
  KVM: X86: Expose PDCM cpuid to guest
  KVM: X86: MSR_IA32_PERF_CAPABILITIES MSR emulation
  KVM: x86: Expose PEBS feature to guest

 arch/x86/include/asm/kvm_host.h  |  8 ++++
 arch/x86/include/asm/msr-index.h | 12 ++++++
 arch/x86/kvm/cpuid.c             |  3 +-
 arch/x86/kvm/pmu.c               | 57 ++++++++++++++++++++++----
 arch/x86/kvm/pmu.h               | 11 ++---
 arch/x86/kvm/pmu_amd.c           |  2 +-
 arch/x86/kvm/svm.c               | 12 ++++++
 arch/x86/kvm/vmx/capabilities.h  | 21 ++++++++++
 arch/x86/kvm/vmx/pmu_intel.c     | 88 +++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c           | 24 ++++++++++-
 arch/x86/kvm/x86.c               | 22 +++++++---
 11 files changed, 229 insertions(+), 31 deletions(-)

-- 
1.8.3.1

