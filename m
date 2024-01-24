Return-Path: <kvm+bounces-6771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BB0839F81
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86FC51F2B674
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962E02BAF0;
	Wed, 24 Jan 2024 02:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQOESCbq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C5B18E2E;
	Wed, 24 Jan 2024 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064169; cv=none; b=D/g2It0/SQptT0d6ws0iLOoo8m76UHjrQzrcxl42Kw02RLpLicCCGLGRvj8T7vW0IWq1ALdSSvgxA7JjuoKI3k+Bt4LRdLFsohS3CP7twh597WO9suwcOl9/+3NsRDiL+UfL119RL0II7rqSEt9cY3c9qHgoXWlwONmM723OkoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064169; c=relaxed/simple;
	bh=aUDtDd9ZiQ5V5sav0MsmNz0UbTbFO26UdWqqrMbfWFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NHUcwfqjoUyhjuYxdl5IRc3eOXgBEymTknIUjbzNDXGdwav25EOyUnqtCAMX4sBh1I7FQCVoexmyoR0CH8DBD8vLvm2pJZfOytYiD52cKQ4Ad1nbYpsZG7YobwUivHMqD/TAb66W1VaAxKZdkt2w+Nu1OpZXExlHu/wu3ixGnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQOESCbq; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064167; x=1737600167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aUDtDd9ZiQ5V5sav0MsmNz0UbTbFO26UdWqqrMbfWFc=;
  b=AQOESCbqqW3TKW+tqFAsZVYe+3kjX5lpFFHTFJoqha3umZOjWFfwOsqH
   cHFQ9vtoqg1K+lebeGPbdbW/7tIkm0pY/YirBuCOq7Zxnu05UYZXSrM65
   0c1kaKLzmwnKccmff84bt7B4AXeLlBw794qH902rrEsnE+cwxCSOGH/1M
   dJf6kqUh5qS/u4ESRy1YPNiwu6YeTKIGd7U84CoOceKjr1TZXJUtJtOui
   ARLMGTbKwJcL+itDsDdtX6qUTuVRRhE04vzdzATJH4Cua4fhwFLa3uCQM
   24JANC5MjYNA5iSl2Wi/47/l8+194Nqd4z4xwMGhdH5AgPbH6COjo7lQG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586563"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586563"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825914"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:42 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 22/27] KVM: VMX: Set up interception for CET MSRs
Date: Tue, 23 Jan 2024 18:41:55 -0800
Message-Id: <20240124024200.102792-23-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 064a5fe87948..34e91dbbffed 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -692,6 +692,10 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		return true;
 	}
 
 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
@@ -7767,6 +7771,41 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
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
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
+					  MSR_TYPE_RW, incpt);
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
@@ -7845,6 +7884,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static u64 vmx_get_perf_capabilities(void)
-- 
2.39.3


