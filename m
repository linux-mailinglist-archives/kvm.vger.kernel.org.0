Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8A97A006B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbjINJix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbjINJia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A761FD8;
        Thu, 14 Sep 2023 02:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684303; x=1726220303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Fcn/JsDDhKgNCQIEeFUvEKU2jF55FyYBOBg3kc7yEI=;
  b=QDwor15hm0/MuaSP+8JnrRhIdpXo6dFgoHBO5h6ERNmZEF0MNt+C20Lh
   hM6owtQOE8SXcu3UdsszsLlcfduhFB24EqcpOkkD8dxnvbdvzEHO0hFq7
   L9OABgrkyAE8ClQAfL/ziNMDP9prScwI+BoyJrcHAKg+SubuIySVQbN8i
   3Z5LJvFr8GDPaV4Kwepb00c5rBxZHL7pmhVirC5aJwKmdzMYo4+bjXW2X
   5+ly0GusX8she9A9PwlwjVQC+ScIOZetHYfhZ0z0wPY7jtFGL6mRmKtUh
   VD2R1/j6NOt7umX+4xzvg1ncja/tec0Wk3UGjDO2lR3iNt66gDG1GSBLf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857426"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857426"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656292"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656292"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:23 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 21/25] KVM: VMX: Set up interception for CET MSRs
Date:   Thu, 14 Sep 2023 02:33:21 -0400
Message-Id: <20230914063325.85503-22-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable/disable CET MSRs interception per associated feature configuration.
Shadow Stack feature requires all CET MSRs passed through to guest to make
it supported in user and supervisor mode while IBT feature only depends on
MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.

Note, this MSR design introduced an architectual limitation of SHSTK and
IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
to guest from architectual perspective since IBT relies on subset of SHSTK
relevant MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9f4b56337251..30373258573d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -699,6 +699,10 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		return true;
 	}
 
 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
@@ -7769,6 +7773,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
+{
+	bool incpt;
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
+					  MSR_TYPE_RW, incpt);
+		if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+			vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
+						  MSR_TYPE_RW, incpt);
+		if (!incpt)
+			return;
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
+					  MSR_TYPE_RW, incpt);
+	}
+}
+
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7846,6 +7886,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static u64 vmx_get_perf_capabilities(void)
-- 
2.27.0

