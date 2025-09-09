Return-Path: <kvm+bounces-57072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4756B4A87F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 827AA18869B2
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B858E304BA8;
	Tue,  9 Sep 2025 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwjiBy/N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3762D3EEB;
	Tue,  9 Sep 2025 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410802; cv=none; b=o6fjmgCrNHPIsD5oTkyWCbalzMT06VTI0pY98wwgBKuSGn0r2qaQRo3pqzeZv95bG4nNLd6dkpvy0w6Kh0lkZVpUbT2UeS+6EmsMs3kA8AMVZ9Hl6GaPF5sEfI3rwfbrbLnbTdlhDenwNL5n51RoCB0CWKRi5CuTFyGv3mS+0Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410802; c=relaxed/simple;
	bh=rmk6W9XXngb5UEH5KiN95T6Plvs7qxwSQtmxVgI0jj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMIL792PRvwtgYU4s98zHCZ92cF7lZePHORAcpIz7ezgbHLd/iRNyz4UYYtu4g/da46V4NvothqxIAVNQeqzIDeiAP9RHxADtrhcuDaa79XtuMxQLOdQ/4bwxN6d2MSSjO3pI2Yz3/hsQE4MytiUO1uc7EY/C6M/Kp/v2nZst/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EwjiBy/N; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410801; x=1788946801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmk6W9XXngb5UEH5KiN95T6Plvs7qxwSQtmxVgI0jj8=;
  b=EwjiBy/NGjgrCNlYqCS/Hgq/X6OEUmsI+HiBJjew4jYWMh21yZdkW1Ml
   oyKxavcyiBFMgtpMJv2RNccGK9ZrsYHmr7EoM5BHsOSpjyNTJjQPw2YFS
   IhwZVnSq2KDmG615w+9RvfnfaGVnimMCXBVAtxxNT+hE0DegHyAdo0Ib8
   tj5Ll96e3lbiWxDaWIjwF/yAOelYp/cd7GrWHcnRuRs4pKOm0hFxkka61
   WeSdY2FU3WbYkrshX/TKzIqZ88/jc4Bk9c87KsBwB+53ploabzp0j7dcO
   qWVhMhWAYZXaI4b4ftQJ7dd7b4sywKRqooxMBfsOyKFDqTb921ZGJK7IW
   g==;
X-CSE-ConnectionGUID: DYaeCcLhRPWJXtzmYS7HMA==
X-CSE-MsgGUID: /x9FJz+ESMa7lmOhXk7ExQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307244"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307244"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:55 -0700
X-CSE-ConnectionGUID: Fl2QWL+ZQE6nscQjdkKehQ==
X-CSE-MsgGUID: MJGgP/IZRq6mog7rql6a9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207409"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:55 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 08/22] KVM: x86: Report KVM supported CET MSRs as to-be-saved
Date: Tue,  9 Sep 2025 02:39:39 -0700
Message-ID: <20250909093953.202028-9-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Add CET MSRs to the list of MSRs reported to userspace if the feature,
i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50c192c99a7e..691f8e68046f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -341,6 +341,10 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR, MSR_IA32_XSS,
+
+	MSR_IA32_U_CET, MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -7517,6 +7521,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!kvm_caps.supported_xss)
 			return;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+			return;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cpu_cap_has(X86_FEATURE_LM))
+			return;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3


