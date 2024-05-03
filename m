Return-Path: <kvm+bounces-16517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C678BAEFC
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 16:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0441F1F21B48
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFA1154C18;
	Fri,  3 May 2024 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fGYJU+jX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142AE152193;
	Fri,  3 May 2024 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714746472; cv=none; b=hXxXjvgZUjFnur09iU10k4/pBWhgK3w/meBAVHVCeCA8x7VzNSlLO47NOagqxfgiUJDaJmnMqP7dtzroTr1pDfdhAjykweHgYQs19O7bbZGnJQyguFgMvkU5StpCgxUboN8JcRoKuPHMmollEDvZCVTriijKsSk3+I6taLjNo+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714746472; c=relaxed/simple;
	bh=DrBGLgX8Lrjw7dwGYbKIReB5FXtCr5ZSrbTwUaBz7Xg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u3psqTRWijvp3+lgX6dQLYreGMW46DDn6KWelAk0JEeFbdBaa+LG5r1HGz5W/9rve/AqCHg+pou55zPCqRgo/v7pVZOdi4DuKAL2rlzwT7xS2mmHAZ2HgGh/pJfy/Ku1i3waHnqfnR6blZS5ai4CKUQK0iw9IM8cWaJZMOi3hhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fGYJU+jX; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714746471; x=1746282471;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DrBGLgX8Lrjw7dwGYbKIReB5FXtCr5ZSrbTwUaBz7Xg=;
  b=fGYJU+jXcQYXyHStZtKCMnpH73tEmvdbzTOmKvYHVUAiBtrYyFbrJTzC
   a8isyt+L2Fvv+kHkNxezx2FxewGIRyyV9vqvwgbJqrgFRUAtoIG7L9P4H
   U++zfIGS/Bk9HCju/uL40ydfJgNK216yoGxBvUuslPjffpqWyqGBLKemb
   qX/YgjmhB5GM6kTsy9e3/mrcaO9mVTjuR2XoZ6+IbH5PPSVfxep5OL/fe
   G/OcJEraFf/zHcs5P4cAQZ2RFU518G1fXwspi9rm/2GWyw4FOn+TzRktR
   gjO7yETlVZjshy+/X6VOZ9RkuAR0TLwkRPIAcUkZFnpkTCXDeVuDOx8ER
   Q==;
X-CSE-ConnectionGUID: HSrbAGk/QUyjKQRr9BYDHQ==
X-CSE-MsgGUID: F5bHBC9CSHuspS5aZhEtSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="10680766"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="10680766"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 07:25:55 -0700
X-CSE-ConnectionGUID: UB+JpBRVSh+jzT1Od1MP2g==
X-CSE-MsgGUID: zisVq0q/R1+YvZZzSPoPoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="28055180"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orviesa008.jf.intel.com with ESMTP; 03 May 2024 07:25:50 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1] KVM: x86: 0-initialize kvm_caps.supported_xss on definition
Date: Fri,  3 May 2024 22:25:48 +0800
Message-Id: <20240503142548.194585-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

0-initialize kvm_caps.supported_xss on definition, so that it doesn't
need to be explicitly zero-ed either in the common x86 or VMX/SVM
initialization paths. This simplifies the code and reduces LOCs.

No functional changes intended.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 arch/x86/kvm/vmx/vmx.c | 2 --
 arch/x86/kvm/x86.c     | 4 +---
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9aaf83c8d57d..8105e5383b62 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5092,7 +5092,6 @@ static __init void svm_set_cpu_caps(void)
 	kvm_set_cpu_caps();
 
 	kvm_caps.supported_perf_cap = 0;
-	kvm_caps.supported_xss = 0;
 
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
 	if (nested) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 22411f4aff53..495125723c15 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7952,8 +7952,6 @@ static __init void vmx_set_cpu_caps(void)
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
-	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91478b769af0..6a97592950ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -94,6 +94,7 @@
 
 struct kvm_caps kvm_caps __read_mostly = {
 	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
+	.supported_xss = 0,
 };
 EXPORT_SYMBOL_GPL(kvm_caps);
 
@@ -9795,9 +9796,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
 
-	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-		kvm_caps.supported_xss = 0;
-
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has

base-commit: 16c20208b9c2fff73015ad4e609072feafbf81ad
-- 
2.27.0


