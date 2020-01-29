Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D584714D3ED
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgA2Xsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:48:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:46690 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgA2Xqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551700"
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
Subject: [PATCH 03/26] KVM: x86: Snapshot MSR index in a local variable when processing lists
Date:   Wed, 29 Jan 2020 15:46:17 -0800
Message-Id: <20200129234640.8147-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snapshot the MSR index when processing the virtualized and emulated MSR
lists in kvm_init_msr_list() to improve code readability, particularly
in the RTIT and PerfMon MSR checks.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 24597526b5de..3d4a5326d84e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5214,7 +5214,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 static void kvm_init_msr_list(void)
 {
 	struct x86_pmu_capability x86_pmu;
-	u32 dummy[2];
+	u32 dummy[2], msr_index;
 	unsigned i;
 
 	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
@@ -5227,14 +5227,16 @@ static void kvm_init_msr_list(void)
 	num_msr_based_features = 0;
 
 	for (i = 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
-		if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
+		msr_index = msrs_to_save_all[i];
+
+		if (rdmsr_safe(msr_index, &dummy[0], &dummy[1]) < 0)
 			continue;
 
 		/*
 		 * Even MSRs that are valid in the host may not be exposed
 		 * to the guests in some cases.
 		 */
-		switch (msrs_to_save_all[i]) {
+		switch (msr_index) {
 		case MSR_IA32_BNDCFGS:
 			if (!kvm_mpx_supported())
 				continue;
@@ -5262,17 +5264,17 @@ static void kvm_init_msr_list(void)
 			break;
 		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 			if (!kvm_x86_ops->pt_supported() ||
-				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
+				msr_index - MSR_IA32_RTIT_ADDR0_A >=
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
+			if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
+			if (msr_index - MSR_ARCH_PERFMON_EVENTSEL0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 			break;
@@ -5280,14 +5282,16 @@ static void kvm_init_msr_list(void)
 			break;
 		}
 
-		msrs_to_save[num_msrs_to_save++] = msrs_to_save_all[i];
+		msrs_to_save[num_msrs_to_save++] = msr_index;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
+		msr_index = emulated_msrs_all[i];
+
+		if (!kvm_x86_ops->has_emulated_msr(msr_index))
 			continue;
 
-		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
+		emulated_msrs[num_emulated_msrs++] = msr_index;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
-- 
2.24.1

