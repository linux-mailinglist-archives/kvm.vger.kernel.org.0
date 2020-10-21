Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777F8294A30
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390638AbgJUJKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:58972 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388839AbgJUJKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:30 -0400
IronPort-SDR: aNvq4QnAN9zZo+KD8WvxulS+QzC3xjqREVTJfRM1v5PLdU4m4qu53/Bv/HGTd+incCLTER+wis
 RG9ijp4KSHqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231530444"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="231530444"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:27 -0700
IronPort-SDR: PjtenZENvMSlNmZeRxBq/+kTsWE6pwO0C4rNTqwsnS5RuKGFRONI+f/WCd7+sYiArbjLLgl+91
 Uv34oyVPiOFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682406"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:23 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 0/7] Split kvm_update_cpuid_runtime()
Date:   Wed, 21 Oct 2020 17:10:03 +0800
Message-Id: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_update_cpuid_runtime() is currently called by various functions for the
purpose of updating vCPU's cpuid entries, due to specific runtime changes, e.g.
CR4 bits changes, XCR0 bits changes, etc. Each of them actually just needs to
update 1 ~ 2 CPUID entries. But current kvm_update_cpuid_runtime() packages all.
Given finding a target CPUID entry need to go through all CPUID entries, calling
kvm_update_cpuid_runtime() is a waste for each cause.

This patch set splits kvm_update_cpuid_runtime() into pieces according to
different updating causes.
Then let various callers call their specific necessary kvm_xxx_update_cpuid().
This patch set also refactors kvm_vcpu_after_set_cpuid().

This not only significantly saves each caller's time, but also eliminates
unnecessary couplings.

---
Change Log
v2:
Reorders patch set, let each extracted function with its caller in a patch.
Also, added a helper function guest_cpuid_change(), which is the extraction
of the common code.

Robert Hoo (7):
  kvm: x86: Extract kvm_apic_base_update_cpuid() from
    kvm_update_cpuid_runtime()
  kvm: x86: Extract kvm_xcr0_update_cpuid() from
    kvm_update_cpuid_runtime()
  kvm: x86: Extract kvm_osxsave_update_cpuid() and    
    kvm_pke_update_cpuid() from kvm_update_cpuid_runtime()
  kvm: x86: Extract kvm_mwait_update_cpuid() from
    kvm_update_cpuid_runtime()
  [Trivial] kvm: x86: cpuid_query_maxphyaddr(): Use a simple 'e' instead
    of     misleading 'best', as the variable name
  kvm: x86: Refactor kvm_vcpu_after_set_cpuid()
  kvm: x86: Remove kvm_update_cpuid_runtime()

 arch/x86/kvm/cpuid.c | 148 ++++++++++++++++++++++++++++++---------------------
 arch/x86/kvm/cpuid.h |   7 ++-
 arch/x86/kvm/lapic.c |   2 +-
 arch/x86/kvm/x86.c   |  29 ++++++----
 4 files changed, 113 insertions(+), 73 deletions(-)

-- 
1.8.3.1

