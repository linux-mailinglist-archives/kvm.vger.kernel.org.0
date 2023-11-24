Return-Path: <kvm+bounces-2415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 863AA7F6D7F
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE09281EE4
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3E618C07;
	Fri, 24 Nov 2023 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UJuqdZuX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317221701;
	Thu, 23 Nov 2023 23:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812729; x=1732348729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZMY42zgIRweQyMfjMH09Kkfx/LB5Hk+BgP/exHBfq/0=;
  b=UJuqdZuX9JqOnJ++QzWJTz0q7Q07KZPYEvMbT+1c20jk+ak0HsK3C6c6
   +yBY34VKX2Cs8s+5V58irPxSr/mbMIIOU/bmcrrK+HyPOCnbqmaC4ho41
   PwjrgM/Z4i3x9cEptFB2Nb+U0bCEciXUyKXjckllFvPsAkiFORFNoXcTM
   RfGc+nbmH17rsr2iJkZ7gcW9LM+lz6n4TCT+DC+QAW1vzDTtzJnV9WagK
   XQ/bsnnr6GaVDr/DSCEH8R5oMRWRAhPVva5Tu85lHMh1Fill0dBQt5d3P
   wO0dnAvY3Je60FFI1M5HUc47IzZDv/wgrqooe2E3XjuqPK5auIquGi3Z0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872401"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872401"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629859"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629859"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:42 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v7 22/26] KVM: VMX: Set up interception for CET MSRs
Date: Fri, 24 Nov 2023 00:53:26 -0500
Message-Id: <20231124055330.138870-23-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable/disable CET MSRs interception per associated feature configuration.
Shadow Stack feature requires all CET MSRs passed through to guest to make
it supported in user and supervisor mode while IBT feature only depends on
MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.

Note, this MSR design introduced an architectural limitation of SHSTK and
IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
to guest from architectual perspective since IBT relies on subset of SHSTK
relevant MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 554f665e59c3..e484333eddb0 100644
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
@@ -7766,6 +7770,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
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
@@ -7843,6 +7883,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static u64 vmx_get_perf_capabilities(void)
-- 
2.27.0


