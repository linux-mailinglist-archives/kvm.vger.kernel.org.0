Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5501214D3CE
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgA2Xqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:46:47 -0500
Received: from mga06.intel.com ([134.134.136.31]:46690 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbgA2Xqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551716"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/26] KVM: x86: Move RTIT (Intel PT) MSR existence checks into vendor code
Date:   Wed, 29 Jan 2020 15:46:22 -0800
Message-Id: <20200129234640.8147-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the Processor Trace MSR checks into VMX to help pave the way toward
removing ->pt_supported().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     |  6 ++++++
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++++
 arch/x86/kvm/x86.c     | 23 -----------------------
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 504118c49f46..df4d0b6f31c8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5991,6 +5991,12 @@ static bool svm_has_virtualized_msr(u32 index)
 	case MSR_TSC_AUX:
 		return boot_cpu_has(X86_FEATURE_RDTSCP);
 	case MSR_IA32_BNDCFGS:
+	case MSR_IA32_RTIT_CTL:
+	case MSR_IA32_RTIT_STATUS:
+	case MSR_IA32_RTIT_CR3_MATCH:
+	case MSR_IA32_RTIT_OUTPUT_BASE:
+	case MSR_IA32_RTIT_OUTPUT_MASK:
+	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		return false;
 	default:
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index de62ce6fd3b9..ed63219ca52e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6281,8 +6281,24 @@ static bool vmx_has_virtualized_msr(u32 index)
 		return cpu_has_vmx_rdtscp();
 	case MSR_IA32_BNDCFGS:
 		return kvm_mpx_supported();
+	case MSR_IA32_RTIT_CTL:
+	case MSR_IA32_RTIT_STATUS:
+		return vmx_pt_mode_is_host_guest();
+	case MSR_IA32_RTIT_CR3_MATCH:
+		return vmx_pt_mode_is_host_guest() &&
+		       intel_pt_validate_hw_cap(PT_CAP_cr3_filtering);
+	case MSR_IA32_RTIT_OUTPUT_BASE:
+	case MSR_IA32_RTIT_OUTPUT_MASK:
+		return vmx_pt_mode_is_host_guest() &&
+		       (intel_pt_validate_hw_cap(PT_CAP_topa_output) ||
+			intel_pt_validate_hw_cap(PT_CAP_single_range_output));
+	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
+		return vmx_pt_mode_is_host_guest() &&
+		       (index - MSR_IA32_RTIT_ADDR0_A <
+			intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2);
 	default:
 		break;
+
 	}
 
 	return true;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70cbb9164088..adbdbe785f05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5237,29 +5237,6 @@ static void kvm_init_msr_list(void)
 		 * to the guests in some cases.
 		 */
 		switch (msr_index) {
-		case MSR_IA32_RTIT_CTL:
-		case MSR_IA32_RTIT_STATUS:
-			if (!kvm_x86_ops->pt_supported())
-				continue;
-			break;
-		case MSR_IA32_RTIT_CR3_MATCH:
-			if (!kvm_x86_ops->pt_supported() ||
-			    !intel_pt_validate_hw_cap(PT_CAP_cr3_filtering))
-				continue;
-			break;
-		case MSR_IA32_RTIT_OUTPUT_BASE:
-		case MSR_IA32_RTIT_OUTPUT_MASK:
-			if (!kvm_x86_ops->pt_supported() ||
-				(!intel_pt_validate_hw_cap(PT_CAP_topa_output) &&
-				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
-				continue;
-			break;
-		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
-			if (!kvm_x86_ops->pt_supported() ||
-				msr_index - MSR_IA32_RTIT_ADDR0_A >=
-				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
-				continue;
-			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
 			if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
-- 
2.24.1

