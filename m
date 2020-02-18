Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2759163760
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbgBRXkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:40:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:39205 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgBRXkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:40:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:40:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436033038"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 15:40:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86: Snapshot MSR index in a local variable when processing lists
Date:   Tue, 18 Feb 2020 15:40:12 -0800
Message-Id: <20200218234012.7110-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218234012.7110-1-sean.j.christopherson@intel.com>
References: <20200218234012.7110-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d3aa4e5f7bb..0475dfb337c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5223,7 +5223,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 static void kvm_init_msr_list(void)
 {
 	struct x86_pmu_capability x86_pmu;
-	u32 dummy[2];
+	u32 dummy[2], msr_index;
 	unsigned i;
 
 	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
@@ -5236,14 +5236,16 @@ static void kvm_init_msr_list(void)
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
@@ -5271,17 +5273,17 @@ static void kvm_init_msr_list(void)
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
@@ -5289,14 +5291,16 @@ static void kvm_init_msr_list(void)
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

