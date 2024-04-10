Return-Path: <kvm+bounces-14132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F348A89FA0F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 939F91F28562
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB18717554D;
	Wed, 10 Apr 2024 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmFiC3Tc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AD716E866;
	Wed, 10 Apr 2024 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759760; cv=none; b=laMTsSDdgIsh6jAU8ORn9uh3RagirLGxOdfv+zDQ0uyolOeYnnu5MwYWxepRTEvstNRtoKlEViJFkxys7IbysuyuWN72UoAjF0nfS7lEr4AKRkB6aYyJrnqDuUJPoob1VgtspJNcXJt8ieCgeLb/IVISvF9GKF02hM/GdExG8xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759760; c=relaxed/simple;
	bh=jdPSsyHlYjQqP3LARjfkhXrm0nOtLrLPubyWHx7h94Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RNnhfhnqamQL+aqhnly/8BOLEqZ/dlQT7w/PhfdYSEPcR13gfSOlfTK7ivhDAWqfMIoeaII65MW3ROsZw3/EpaieUpW7JpMcWyE4hk2vZq3z6QEAp+ZN5Vo8yirbvCDQ261X8RE2dFmc72ILvs+Z9a04XlzNffQlsYrc9EfLa0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XmFiC3Tc; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759759; x=1744295759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jdPSsyHlYjQqP3LARjfkhXrm0nOtLrLPubyWHx7h94Y=;
  b=XmFiC3TcBibFRjA9UD6g45iNiggWM8qBMJ2i8A8jwe7L7daZ0af2c2Aa
   hwltAeeOif4/LAQ1rmCgM2SggJUN9E1P8oFfbkh3fALypTOPwx3NK5Zsa
   eBr2IQL1Z23+QG/ItT++9lkBgrkzAULcQ4FZOFQQXXtWEaywrD885jV7f
   3wGhEYQSZvdct/EAtn3Fto8dujMMwnFwfvj250OYJMO/7LAC11c3/fOib
   tlYjmewzcrqEXCGNUuP4PldRxroDxpvCcAIXKM7Fnh/irtEh94apE23X8
   gHzn9wBb/4OdUAj27mR/KATebbM5ZBm76YV2aVd/6sTfpTR7JOFOs3uRZ
   w==;
X-CSE-ConnectionGUID: T3km9xF1QYezFYtReetSkw==
X-CSE-MsgGUID: QcDcbAA+RdS6tik/kdnAeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837881"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837881"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:58 -0700
X-CSE-ConnectionGUID: aRgrC8THQLWC3UotmZwHqQ==
X-CSE-MsgGUID: ip7l6a3QS3mvJd0R5CfSmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095588"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:55 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Zhang Chen <chen.zhang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH v3 10/10] KVM: VMX: Advertise MITI_ENUM_RETPOLINE_S_SUPPORT
Date: Wed, 10 Apr 2024 22:34:38 +0800
Message-Id: <20240410143446.797262-11-chao.gao@intel.com>
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

Allow guest to report if retpoline is used in supervisor mode.

KVM will deploy RRSBA_DIS_S for guest if guest is using retpoline and
the processor enumerates RRSBA.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c5ceaebd954b..235cb6ad69c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1956,8 +1956,10 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 }
 
 #define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
-#define MITI_ENUM_VALID_BITS		MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT
-#define MITI_CTRL_VALID_BITS		MITI_CTRL_BHB_CLEAR_SEQ_S_USED
+#define MITI_ENUM_VALID_BITS		(MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT | \
+					 MITI_ENUM_RETPOLINE_S_SUPPORT)
+#define MITI_CTRL_VALID_BITS		(MITI_CTRL_BHB_CLEAR_SEQ_S_USED | \
+					 MITI_CTRL_RETPOLINE_S_USED)
 
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
@@ -2508,6 +2510,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~MITI_CTRL_VALID_BITS)
 			return 1;
 
+		if (data & MITI_CTRL_RETPOLINE_S_USED &&
+		    kvm_cpu_cap_has(X86_FEATURE_RRSBA_CTRL) &&
+		    host_arch_capabilities & ARCH_CAP_RRSBA)
+			spec_ctrl_mask |= SPEC_CTRL_RRSBA_DIS_S;
+
 		if (data & MITI_CTRL_BHB_CLEAR_SEQ_S_USED &&
 		    kvm_cpu_cap_has(X86_FEATURE_BHI_CTRL) &&
 		    !(host_arch_capabilities & ARCH_CAP_BHI_NO))
-- 
2.39.3


