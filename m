Return-Path: <kvm+bounces-55285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6604B2FAB5
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 363A41885F61
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C030834DCCF;
	Thu, 21 Aug 2025 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gKXeLLUj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA045341AA1;
	Thu, 21 Aug 2025 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783127; cv=none; b=rTXbzvUxzrctGVTSfZIvHpvVuctYN8Xdlir5kaXvm521OXX5SkYbW5U2abth53gvkD2dWEctZzsa9Rp7xra+7QzLBg6bpXtptEfzvJf1bQEC8HXahQHZONsSXBtMEORDFPDor8D014TsfDqhiOmtauiH5P9TJV8ITl3TwcTz0Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783127; c=relaxed/simple;
	bh=NgDlHX6YGPfndZFmT5UD4GgLVAqChAiuVRLgxnAziTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJCSfOx1of43MahDc/nLOVnfcKJNcBTVgbT45L2wGzjatdZnneG4pAYvtKm4ETnwU/n8n0d/UNcn8ClyJZB8FSDGrG+g4wN16NYamJXeuUGaSxPewN2T04kd/txQkDDv9r8tL1cg1retOJ405rHoW4tH6KdkWiMeqgjXCheluQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gKXeLLUj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783126; x=1787319126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NgDlHX6YGPfndZFmT5UD4GgLVAqChAiuVRLgxnAziTk=;
  b=gKXeLLUjakRj/aFxAker0cRIGhujIzTGwlSud7Dfw66jmyg0hBQcACpb
   XmXzHeeNrBt172ouNGauYN/P9cJAS9PWZC1wrrCtXeGszAfeBZn5AOWJo
   Fq82NYQJqT7Kz/fIVbRUOtPmTNdFz15WLjMFgW2kqU1pE7S9aHe79JW3q
   1ezXCO4Jq/rxf3ih602kmNol1iQabXbLT34sjgZJzZqbOhLdln9yQ12U7
   7pDOUGwF4ISO8MSUAdWicaeILa6Pt8113Uw0g1tBtOxf9Z0nWk6Px0CKQ
   J189382W/5O4HORJrNP2GD6HAa/Z5m+tjCWnTQGKJUe6uPUsiAtchpRRd
   g==;
X-CSE-ConnectionGUID: Xz2Tm6piSqOuEpXoRNZkrg==
X-CSE-MsgGUID: 57pQE3d9SGWooYor4wfxTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446140"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446140"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: OJ2gAoVyR52k3AStmoVKeA==
X-CSE-MsgGUID: 5EVLsU1kTCy0P7imxpAo3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285420"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:49 -0700
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
Subject: [PATCH v13 12/21] KVM: VMX: Set up interception for CET MSRs
Date: Thu, 21 Aug 2025 06:30:46 -0700
Message-ID: <20250821133132.72322-13-chao.gao@intel.com>
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

Enable/disable CET MSRs interception per associated feature configuration.

Pass through CET MSRs that are managed by XSAVE, as they cannot be
intercepted without also intercepting XSAVE. However, intercepting XSAVE
would likely cause unacceptable performance overhead.
MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.

Note, this MSR design introduced an architectural limitation of SHSTK and
IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
to guest from architectural perspective since IBT relies on subset of SHSTK
relevant MSRs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v13
- document the real reason why MSRs are pass-thru'd
- Rename the local variable that indicates whether interception is
  needed.
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4fc1dbba2eb0..adf5af30e537 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4101,6 +4101,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
+	bool intercept;
+
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
@@ -4146,6 +4148,23 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, intercept);
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
+			    !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, intercept);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
+	}
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.47.3


