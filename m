Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F59234063
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgGaHqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:46:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:55461 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731644AbgGaHqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:46:10 -0400
IronPort-SDR: Z5dev1k7U1NMNtjsAmpUMnuXJaFUCsL3Pn4cU2Ba3oOIbxs5BZAiPeGRmKblr1NQ2EkX0bEkMV
 Jk9wys9d2DVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149570524"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149570524"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:46:10 -0700
IronPort-SDR: msUrVnsDtmIKJt5oocn+KSxrZnkGpctPtKLu2OOmm/eqISy1c5F1uVJl06a7WUCpbSgDkec2lz
 M/V7k0Z8Z5fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="323160577"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 00:46:08 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH 1/6] KVM: vmx/pmu: Add VMCS field check before exposing LBR_FMT
Date:   Fri, 31 Jul 2020 15:43:57 +0800
Message-Id: <20200731074402.8879-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200731074402.8879-1-like.xu@linux.intel.com>
References: <20200731074402.8879-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest LBR_FMT is exposed on KVM, KVM needs to have guest state
field GUEST_IA32_DEBUGCTL and MSR_IA32_DEBUGCTLMSR vmx switch support.

Fixes: f93d622139de ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 5829f4e9a7e0..f5f0586f4cd7 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -372,6 +372,12 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+static inline bool cpu_has_vmx_lbr(void)
+{
+	return (vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_DEBUG_CONTROLS) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_DEBUG_CONTROLS);
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	/*
@@ -383,7 +389,8 @@ static inline u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
-	perf_cap |= perf_cap & PMU_CAP_LBR_FMT;
+	if (cpu_has_vmx_lbr())
+		perf_cap |= perf_cap & PMU_CAP_LBR_FMT;
 
 	return perf_cap;
 }
-- 
2.21.3

