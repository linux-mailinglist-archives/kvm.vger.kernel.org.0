Return-Path: <kvm+bounces-55278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8854EB2FAC4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB567AA0A24
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA37133CE88;
	Thu, 21 Aug 2025 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jeGe6gLQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D63338F4B;
	Thu, 21 Aug 2025 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783122; cv=none; b=uHNtZgaCXTm/8dk7aou9jxwUOZNVDqUzPmHKzeGHKgXTm/pX+gEskd+ldo4t/TjMsOfTEFZ57te97cMubuhup3uYNXXfntWT8mkG74OmsTG1K2kvfa1zd5DcG/k3GSYqnq1C/8cnW3fzo0jD6DvMKsVHOFz4hAwIyi4g3mwuuzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783122; c=relaxed/simple;
	bh=B/v5Cc3N2K/wIRD7t6ir+M5QbF/9EnD7MIE5tKyx95o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JytYEaZoVrwLEzoJKoOWfL0wEApzpsDXd+5AcW2c0ZojO2w5yQ7ivkO2lfypa0aLLluZb6/b19V7C9KZszn6o9CCv8CufS058+1/wfkeCrvYkMmnyxmyNcoFvVk2Kv4WQYRbX/iouNKzClkPs0TqeeD1+3wZseAaz/1JkzxK06Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jeGe6gLQ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783121; x=1787319121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B/v5Cc3N2K/wIRD7t6ir+M5QbF/9EnD7MIE5tKyx95o=;
  b=jeGe6gLQItCB7xPitdi40xKxZqBRD+mYbudj1gJjSsR5U7cggYMZ1og/
   +QzHUvfff20F7skQUopFynsJ8H+k+DntruDoGRdnd+yd5v2T19V2Bsauu
   amx1WdUDVMmDtLjosbpfyKsUjTzvw3R4MMm6/k+/aQwUQS6QlgQTTAmeC
   XNvJkxHI9Uv+cLqU+xxFyn+K5G1zOwAYZ/uBJDlM/30W/Gj8SVfNv/Mn+
   DDxCOjy+vLQkpubwCutd4cH3QSINSjJV7kOhvFPQtaGMDKhtzNDLvwFUj
   vA7rLIrpwkfZz8Q6FmRsvBFhDB/8gdoOYaaSL913WaBumUsPNUXQHzyCY
   g==;
X-CSE-ConnectionGUID: viISV3ABRGeEMuX6+PjFVw==
X-CSE-MsgGUID: 7kSO4cvgSXG16ip/lYEBPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446074"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446074"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:00 -0700
X-CSE-ConnectionGUID: 6wqmnJCdR6ulMvvI4jJJ7g==
X-CSE-MsgGUID: yYssWxydScyzrnMkWEErFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285394"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:41 -0700
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
Subject: [PATCH v13 04/21] KVM: x86: Initialize kvm_caps.supported_xss
Date: Thu, 21 Aug 2025 06:30:38 -0700
Message-ID: <20250821133132.72322-5-chao.gao@intel.com>
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

Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
XSAVES is supported. host_xss contains the host supported xstate feature
bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
enabled XSS feature bits, the resulting value represents the supervisor
xstates that are available to guest and are backed by host FPU framework
for swapping {guest,host} XSAVE-managed registers/MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75b7a29721bb..6b01c6e9330e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -220,6 +220,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
@@ -9793,14 +9795,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
+		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
+	}
+
 	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
 	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrq_safe(MSR_EFER, &kvm_host.efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
-
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-- 
2.47.3


