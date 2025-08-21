Return-Path: <kvm+bounces-55288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54DF7B2FAC2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E73C41CE441B
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5DEA34F49B;
	Thu, 21 Aug 2025 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MnoMuMhC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7E034AAEC;
	Thu, 21 Aug 2025 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783129; cv=none; b=AVLGyEHfY+UZOJIQeuzOQ1Fg+R80F/n8MTl4Kw0BiTbde0RaJI5TeTXr4z1sHO6ZT0atbnq6rwyZv5v9/vvvyrncZr40dHLIzhYBpLdwW4/N7VHx6tWeJfpSryaetdWZ9H3Nb6OgnlSLIGPMNYgovuFn6HrUyY6/cwg389oKMSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783129; c=relaxed/simple;
	bh=CKTAR2clkFwYFpvFmyMSOch/X88zLnViNPj0Kl9uqXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3tBmKU1ydiKHdgXabfe+at85l2GkVkXyz5qnA3AezuZR9YlsYec5nrCAMTi9X4cx8ckK3QBVNgk0HETaQMglFcv0sYqNqz3ONIPyYM2oBe7fsb5hirUFrCGuCeYyVvO9zA24S3rBXj/zHPY57GJNX+iGWgym/0co+b53AXPnig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MnoMuMhC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783128; x=1787319128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CKTAR2clkFwYFpvFmyMSOch/X88zLnViNPj0Kl9uqXs=;
  b=MnoMuMhCKMwSdQvBzspwE7sFTVFjdEwCWwjjcYYljPsbZ0jw8tqhiog0
   s1lP78VLTaF1xu/wUt0i4gU1t2fUbFrXl+8puae5lakiVQugqeJ8Rb2Qo
   z7q4sGEKy4Sue56liuz7qdCnmYfu2M20/uOhK24q0fIeaNIacHvKg8uFj
   HWpxoHPPA2qVJjKfUVh+gsw8aiM6ublDlauYuzm+eojhzrD+JJ23RY+v2
   LM20Vrj9Q/JVgK8e4yVu1B0yeYjguV6quhFTzVBapvQ1kX6ypBzo/sO6T
   oXUnHfVoOh3Tos/I61WpaiKwUdPW++Gy21QEPEqnh5xrY4cUXVLST8lOy
   Q==;
X-CSE-ConnectionGUID: A013Nkz2RHSJzaNv1Kh+QA==
X-CSE-MsgGUID: lcVv3SVkQEC2caHQkrJMkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446169"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446169"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: Zm6qfaw7QUaRGKEmexhFiQ==
X-CSE-MsgGUID: +m+rUBxHTIukiZUooWFr9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285402"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:44 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 07/21] KVM: x86: Report KVM supported CET MSRs as to-be-saved
Date: Thu, 21 Aug 2025 06:30:41 -0700
Message-ID: <20250821133132.72322-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
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
index c363f7df279f..61e008be172d 100644
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
@@ -7520,6 +7524,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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


