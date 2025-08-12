Return-Path: <kvm+bounces-54484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B12EB21B1A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 05:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66BFF684520
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F7B2E7BD0;
	Tue, 12 Aug 2025 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c3dbvqPz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F229C2E62BB;
	Tue, 12 Aug 2025 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967396; cv=none; b=bhKxW1tDGzgVLmGflu+XK+DcMmblkLQXnO6fo+GK7rrmcY5q/4sg0iqFLoeym7rI3ACVUf8iqP0eTiCZUlGgEvCg7y+H13aw06Z3hIXniDwC7t4IXRxTFAorYHnsuT10Z9/VyREqi1YGvOQ0GfmjmEiffMlOtmIbI4MVnfEI3Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967396; c=relaxed/simple;
	bh=MpGUFCMJ91Ij3rW0ZCW1FCN8YsfJ3Roxt36gb8FH7A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=telKxcblB6ljnIU9FFpTql8PNc664SePUqzNT5bzfWSJq65MmJRUw7nUlGPN9xB2FUZU5gZDo0jMvaDGCUK2ejTC+FuHoWwwmqS+NNdxBsUDm0+NJQGtZl7tErwC/UmSct1xXjXBO0y2Jo4JeEIlaRwqhFwqg1GiDpp3bmJAaTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c3dbvqPz; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967395; x=1786503395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MpGUFCMJ91Ij3rW0ZCW1FCN8YsfJ3Roxt36gb8FH7A8=;
  b=c3dbvqPzOasYAFV9noYHAvL+fynCk0Y0mla6VLkLo+HYfR1Sptnth9dM
   32R77qERBM8J+JlwHiYd/lHvG553+BE34Olorst3CXsZ5Wob5z+U1WvQO
   jyyt4lfoyGvAGPdKAzDJ7s6iA+dCneJg8a6nrpm2iP9u/DR1DmkEKADzk
   /chlbHMj4KI4Kvk3NLWyIV12AtqQGKBKoZ2D1zobPzEq9YZYkHNAkdAY/
   VLDDrcipA3jNKR4s0QJHxsa558mUezHbYIz5reqXGVEAasIrA7SlAxZNQ
   tHLWMGCw3ZF5eaOdsce8c+X3qPXjTJ0fxX+NNpdDOPJl5vFfVHABpMS1u
   Q==;
X-CSE-ConnectionGUID: ZrFK0yLNQr+amAHQy+LYPA==
X-CSE-MsgGUID: xfdOx8JzRy2/XVNIvr0ZKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100542"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100542"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:31 -0700
X-CSE-ConnectionGUID: nc/eP1EhRwu2iB7zbB0MkQ==
X-CSE-MsgGUID: vXH1hqgtQfia22S5wE6k1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321292"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:31 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 12/24] KVM: x86: Report KVM supported CET MSRs as to-be-saved
Date: Mon, 11 Aug 2025 19:55:20 -0700
Message-ID: <20250812025606.74625-13-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
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
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cca05908f989..7134f428b9f7 100644
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
@@ -7490,6 +7494,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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
2.47.1


