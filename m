Return-Path: <kvm+bounces-14131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE0F89FA0D
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 165AC285821
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DEA174ED8;
	Wed, 10 Apr 2024 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPddA6Np"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FD1172BCE;
	Wed, 10 Apr 2024 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759756; cv=none; b=CgyB48gMke24GJHz33ZLHUmmosWrfGkITv+NXTD3rQk+KXLVeOykFheLuFf2RW0WJjwbbYX3rnfeRUy13GTbMUbJkSFSWaEHaXcAJ3VPrFtaOyVOdEN1GQWxHEkbHw6FIB61kzhgtX80CKJIKWDs1TFB92fCxQ1+07e70S2xyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759756; c=relaxed/simple;
	bh=HgvR740LxRCUJlie9YdeYMqkDa7fqKR6D+8llY0+tM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f9ItiHSffhbmZ9/g8iuITCpCmWkem0kY1TBvOHznhehAZfPUvWHfCEK60KeqkwFnLWnjayt3mSrkNd+mtrVj0BqeHJc4KyrTsk3rYbCbYz7In4EPlhEdmo+LmATtHivUBoaVmLKDJlMjwna94L3ddVeSgiMS2U0SCQPCyhUCLio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPddA6Np; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759755; x=1744295755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HgvR740LxRCUJlie9YdeYMqkDa7fqKR6D+8llY0+tM0=;
  b=IPddA6Np+SnL+0F33+DzVl7Sm88buQQN8rW/d0DzqPo6NM2M1m52UhDh
   nO3drCNUfvD1BECC+J39adKRY62AztmX4TdboKZ3NPriod+Pt+DrJ3YZ9
   Tgjia91pKLaJhyC+tzxVMq/af/llhYFTd9JM8IBGf3GsAI2zDIjQU0ifv
   5y71wqMvBaUfj/J7dXjY7+DuKhYytSbYzESZVcHosO8x3+cXl2yHoD5Kh
   uYsVJOVUIe5pYDtH6L9qCZFTvx9nn+4svk5am0qNtZr7qJVKuHttuoaH2
   8eyKo0V13p8szTqjms1eNg+mt+atKgTsjvVqB8dTDunidPWsWhA6sT27t
   w==;
X-CSE-ConnectionGUID: JEw0mznOQS+vLEhqa+RWMA==
X-CSE-MsgGUID: eLCmGC8TT5+90CsveZ/OEA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837860"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837860"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:55 -0700
X-CSE-ConnectionGUID: TaxPF401TvehjmbDKiCEZw==
X-CSE-MsgGUID: mdyfOuIcRpibXS+34hvRXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095564"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:51 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Zhang Chen <chen.zhang@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
Date: Wed, 10 Apr 2024 22:34:37 +0800
Message-Id: <20240410143446.797262-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240410143446.797262-1-chao.gao@intel.com>
References: <20240410143446.797262-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Chen <chen.zhang@intel.com>

Allow guest to report if the short BHB-clearing sequence is in use.

KVM will deploy BHI_DIS_S for the guest if the short BHB-clearing
sequence is in use and the processor doesn't enumerate BHI_NO.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc260b14f8df..c5ceaebd954b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1956,8 +1956,8 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 }
 
 #define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
-#define MITI_ENUM_VALID_BITS		0ULL
-#define MITI_CTRL_VALID_BITS		0ULL
+#define MITI_ENUM_VALID_BITS		MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT
+#define MITI_CTRL_VALID_BITS		MITI_CTRL_BHB_CLEAR_SEQ_S_USED
 
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
@@ -2204,7 +2204,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct vmx_uret_msr *msr;
 	int ret = 0;
 	u32 msr_index = msr_info->index;
-	u64 data = msr_info->data;
+	u64 data = msr_info->data, spec_ctrl_mask = 0;
 	u32 index;
 
 	switch (msr_index) {
@@ -2508,6 +2508,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~MITI_CTRL_VALID_BITS)
 			return 1;
 
+		if (data & MITI_CTRL_BHB_CLEAR_SEQ_S_USED &&
+		    kvm_cpu_cap_has(X86_FEATURE_BHI_CTRL) &&
+		    !(host_arch_capabilities & ARCH_CAP_BHI_NO))
+			spec_ctrl_mask |= SPEC_CTRL_BHI_DIS_S;
+
+		/*
+		 * Intercept IA32_SPEC_CTRL to disallow guest from changing
+		 * certain bits if "virtualize IA32_SPEC_CTRL" isn't supported
+		 * e.g., in nested case.
+		 */
+		if (spec_ctrl_mask && !cpu_has_spec_ctrl_shadow())
+			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
+
+		/*
+		 * KVM_CAP_FORCE_SPEC_CTRL takes precedence over
+		 * MSR_VIRTUAL_MITIGATION_CTRL.
+		 */
+		spec_ctrl_mask &= ~vmx->vcpu.kvm->arch.force_spec_ctrl_mask;
+
+		vmx->force_spec_ctrl_mask = vmx->vcpu.kvm->arch.force_spec_ctrl_mask |
+					    spec_ctrl_mask;
+		vmx->force_spec_ctrl_value = vmx->vcpu.kvm->arch.force_spec_ctrl_value |
+					    spec_ctrl_mask;
+		vmx_set_spec_ctrl(&vmx->vcpu, vmx->spec_ctrl_shadow);
+
 		vmx->msr_virtual_mitigation_ctrl = data;
 		break;
 	default:
-- 
2.39.3


