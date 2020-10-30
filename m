Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6703629FC69
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 04:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgJ3D5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 23:57:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:4255 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgJ3D5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 23:57:03 -0400
IronPort-SDR: gO6yAgym8qJ/lDK3otQ2gwJYWzlzSg8O74/Ztil6pMFPb9Dtig1lwp9rsAiIQRlZT9A4VUr/Pk
 m5ckPeam+VFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168685758"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="168685758"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 20:57:03 -0700
IronPort-SDR: KfPz8EPIhu1XwpxivV5XlC1JBF1QiGzbTVf1tTeLXFIkl3pwIh9eXmk2fyQifZklwq/tBp8w35
 ZO19Ofvbf+Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525770468"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 20:56:59 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v13 09/10] KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES
Date:   Fri, 30 Oct 2020 11:52:19 +0800
Message-Id: <20201030035220.102403-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201030035220.102403-1-like.xu@linux.intel.com>
References: <20201030035220.102403-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace could enable guest LBR feature when the exactly supported
LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES
and the LBR is also compatible with vPMU version and host cpu model.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 9 ++++++++-
 arch/x86/kvm/vmx/vmx.c          | 7 +++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 57b940c613ab..a9a7c4d1b634 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -378,7 +378,14 @@ static inline u64 vmx_get_perf_capabilities(void)
 	 * Since counters are virtualized, KVM would support full
 	 * width counting unconditionally, even if the host lacks it.
 	 */
-	return PMU_CAP_FW_WRITES;
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	perf_cap |= perf_cap & PMU_CAP_LBR_FMT;
+
+	return perf_cap;
 }
 
 static inline u64 vmx_supported_debugctl(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2da96ec410a3..4fe1e9605ff4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2230,6 +2230,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
+		if (data & PMU_CAP_LBR_FMT) {
+			if ((data & PMU_CAP_LBR_FMT) !=
+			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
+				return 1;
+			if (!intel_pmu_lbr_is_compatible(vcpu))
+				return 1;
+		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
 
-- 
2.21.3

