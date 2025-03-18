Return-Path: <kvm+bounces-41390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F23A677DF
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38BC93B9800
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B4620FABC;
	Tue, 18 Mar 2025 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AFT4ES1O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F8C20B1E1;
	Tue, 18 Mar 2025 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311860; cv=none; b=SBHaEH6ViJLODQD0mUD2ESAy+huXkfAV5cg01zpokwS+wC9wlnJmKsoAcReiZB4/1ZECt7pAcmOX+XJpHHig9FBUrmDYwn3QzVY7yHD8Bp5gMof0Cmk/4KpTA1cr+ifWUf0w9Xxcnmw3S5xS8pFIxiP9tdZA9QnlUMGsSLvirzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311860; c=relaxed/simple;
	bh=HW3jnHDj7a24/dMKV/EiSkN7soAtag6a5upSBSAMtbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGy3++FC7wOYP/90c8MRw9S+ItpbeXR9Jww1te8YeaXxGuxXUTCdsUSNDp9SO7fH67bIL9355tbaD0PEyHfvxlm5K3vEpH8peydootEgIpen9WsMDUDmqlr6yQSnxrBTpwScZJETzUT88E0EGc+qFne0Aa4jHfBmpjayLmtTVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AFT4ES1O; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311855; x=1773847855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HW3jnHDj7a24/dMKV/EiSkN7soAtag6a5upSBSAMtbA=;
  b=AFT4ES1OE69SzPoFnoq2mo7nWoUL1rAHeGq/eeGcmCz5FOnDwcyaGMdb
   4LkQHqALhcftz83C/V/MC3hejj7iSdtwO0X/14Fc/Vf/H/GRxSLAex/Q0
   SqIAFjgGo3mQYQKHI4Y9m50KDXcGpzzWjsh+8Skpy4dTjAqkRMwHS8LPk
   TLJQeyRyHJ4b+NSeeIxL2wb/P5tRorz7xlZxM2hjb8gLiQpk2lg9CPD3i
   +PPBudX5wY93NU7TFi6AFEmfxCqZgEQToDcap+rV8lPrOtV1tREWTjCRr
   6aHbX08dgDyvoJfLJf7cBIthLQTAdsqenZGu9XibrS2As3YRRtnUsWaSQ
   g==;
X-CSE-ConnectionGUID: pWDccBn2TCKHlzuKfuIXuw==
X-CSE-MsgGUID: K7hPfCsET2u5Wt9rTlrL9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="46224212"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="46224212"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:54 -0700
X-CSE-ConnectionGUID: B+9LgOjJT5WkfO19WtMcYg==
X-CSE-MsgGUID: kjlX3rQyT56ArpVXuYX2vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122121880"
Received: from spr.sh.intel.com ([10.239.53.19])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:48 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Subject: [PATCH v4 4/8] x86/fpu/xstate: Differentiate default features for host and guest FPUs
Date: Tue, 18 Mar 2025 23:31:54 +0800
Message-ID: <20250318153316.1970147-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250318153316.1970147-1-chao.gao@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, guest and host FPUs share the same default features. However,
the CET supervisor xstate is the first feature that needs to be enabled
exclusively for guest FPUs. Enabling it for host FPUs leads to a waste of
24 bytes in the XSAVE buffer.

To support "guest-only" features, introduce two new members,
guest_default_features and guest_default_size, in fpu_kernel_cfg to clearly
differentiate the default features for host and guest FPUs.

An alternative approach is adding a guest_only_xfeatures member to
fpu_kernel_cfg and adding two helper functions to calculate the guest
default xfeatures and size. However, calculating these defaults at runtime
would introduce unnecessary overhead.

Note that, for now, the default features for guest and host FPUs remain the
same. This will change in a follow-up patch once guest permissions, default
xfeatures, and fpstate size are all converted to use the guest defaults.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/fpu/types.h | 20 ++++++++++++++++++++
 arch/x86/kernel/fpu/xstate.c     | 16 +++++++++++-----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index d555f89db42f..80647c060b32 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -573,6 +573,16 @@ struct fpu_state_config {
 	 */
 	unsigned int		default_size;
 
+	/*
+	 * @guest_default_size:
+	 *
+	 * The default size of the register state buffer in guest FPUs.
+	 * Includes all supported features except independent managed
+	 * features and features which have to be requested by user space
+	 * before usage.
+	 */
+	unsigned int		guest_default_size;
+
 	/*
 	 * @max_features:
 	 *
@@ -589,6 +599,16 @@ struct fpu_state_config {
 	 * be requested by user space before usage.
 	 */
 	u64 default_features;
+
+	/*
+	 * @guest_default_features:
+	 *
+	 * The default supported features bitmap in guest FPUs. Does not
+	 * include independent managed features and features which have
+	 * to be requested by user space before usage.
+	 */
+	u64 guest_default_features;
+
 	/*
 	 * @legacy_features:
 	 *
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 14c3a8285f50..1dd6ddba8723 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -673,7 +673,7 @@ static unsigned int __init get_xsave_size_user(void)
 static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
-	unsigned int user_size, kernel_size, kernel_default_size;
+	unsigned int user_size, kernel_size;
 	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
 
 	/* Uncompacted user space size */
@@ -692,18 +692,20 @@ static int __init init_xstate_size(void)
 	else
 		kernel_size = user_size;
 
-	kernel_default_size =
-		xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);
-
 	if (!paranoid_xstate_size_valid(kernel_size))
 		return -EINVAL;
 
 	fpu_kernel_cfg.max_size = kernel_size;
 	fpu_user_cfg.max_size = user_size;
 
-	fpu_kernel_cfg.default_size = kernel_default_size;
+	fpu_kernel_cfg.default_size =
+		xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);
+	fpu_kernel_cfg.guest_default_size =
+		xstate_calculate_size(fpu_kernel_cfg.guest_default_features, compacted);
 	fpu_user_cfg.default_size =
 		xstate_calculate_size(fpu_user_cfg.default_features, false);
+	fpu_user_cfg.guest_default_size =
+		xstate_calculate_size(fpu_user_cfg.guest_default_features, false);
 
 	return 0;
 }
@@ -721,8 +723,10 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 	/* Restore the legacy size.*/
 	fpu_kernel_cfg.max_size = legacy_size;
 	fpu_kernel_cfg.default_size = legacy_size;
+	fpu_kernel_cfg.guest_default_size = legacy_size;
 	fpu_user_cfg.max_size = legacy_size;
 	fpu_user_cfg.default_size = legacy_size;
+	fpu_user_cfg.guest_default_size = legacy_size;
 
 	/*
 	 * Prevent enabling the static branch which enables writes to the
@@ -807,9 +811,11 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	/* Clean out dynamic features from default */
 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	fpu_kernel_cfg.guest_default_features = fpu_kernel_cfg.default_features;
 
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	fpu_user_cfg.guest_default_features = fpu_user_cfg.default_features;
 
 	/* Store it for paranoia check at the end */
 	xfeatures = fpu_kernel_cfg.max_features;
-- 
2.46.1


