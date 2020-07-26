Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D889C22E0C5
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgGZPfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:35:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgGZPfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:07 -0400
IronPort-SDR: uyKBXohLEyv+7InQII9j3Kpaq0f3x5AKEfLZ/cOyWNwtQwMgK/DqIVSHHUSCeLpGiqKevrrBTY
 Yr+GsH0GfZEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890992"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890992"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:35:07 -0700
IronPort-SDR: Z8CnUrrSVY8gtpW3lPiqMRbUxCMUL0thMvOJ9Y8U2fRLIYbK0jtQhWB5ObL4ak3Oynj1cyoABQ
 gYXqofWx7kmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177635"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:35:05 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v13 09/10] KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES
Date:   Sun, 26 Jul 2020 23:32:28 +0800
Message-Id: <20200726153229.27149-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace could enable guest LBR feature when the exactly supported
LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES
and the LBR is also compatible with vPMU version and host cpu model.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  9 ++++++++-
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f17ab6cf152e..5829f4e9a7e0 100644
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
index b72fbbef56fa..6d8b1d98ae1d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2251,6 +2251,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if ((data >> 32) != 0)
 			return 1;
 		goto find_shared_msr;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (data & PMU_CAP_LBR_FMT) {
+			if ((data & PMU_CAP_LBR_FMT) !=
+			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
+				return 1;
+			if (!intel_pmu_lbr_is_compatible(vcpu))
+				return 1;
+		}
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		break;
 
 	default:
 	find_shared_msr:
-- 
2.21.3

