Return-Path: <kvm+bounces-6751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9AC839F56
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FAFC28E1E9
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928A9E563;
	Wed, 24 Jan 2024 02:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R2d4WT9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA2C63AA;
	Wed, 24 Jan 2024 02:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064155; cv=none; b=Cntl0zVV7b24EdpO63ekpzm4fkDix2UfnG27lPU+/4ANJ+ep3SNoMIQzACZRffujqsmOgVkNlevOqQOqsUHuTyVsmsmm1uZmfHG7Fv6GA4/3CHA05lBDWPz/eOTTTTzjdnDDdqohSqgSRNEzUX1wlulfY7XRCwyuTYxfhf+MF3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064155; c=relaxed/simple;
	bh=O+In4X9Kp5bd1+hICvCOfi4/QLtmFNAek1QhOW3ItLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TxvXNz5QW40sb2f3z4wTDyAfKjSbf6dNJvzMAxCR9mndOaaS3WQ/eV4rr0V7arbEbP3SGMUmMElScFavzYb55a/6Qldlekp9fwii3bIankAa6LD3tagrf0/dsJj7FFzkgaUDYko3gVV2upDZ64243NkGwbiAFhFDS02Q48ms/GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R2d4WT9Q; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064153; x=1737600153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O+In4X9Kp5bd1+hICvCOfi4/QLtmFNAek1QhOW3ItLM=;
  b=R2d4WT9QSXucDnqCFX6yTgxDpy48S/wywNI+GxfG69mu3j2fP4SWLtwH
   U9jfJR4/tA1qGruS9GatrKHUOGd3fTjxYTWk/8gbhehFuXH8149pK33t3
   2xuAEEgWa2YGQGl/DTAabfSzgAz3d77GAdSckQTyp989xRpSG5Cl9eCPs
   C4fwGanQCgfQrUNeJZUFTCFB7DehrmPMC7G4O7/l8exUEpaSap5Z/cAiK
   l9GjiParh3WaeXS92sdnzd2n5p/F3NX7NboNXAgitl0jWcs7HLnFzJZ8I
   QwvEpIv5lrbaNUh2E6mEa0h72I+oPr8YHOV4E382kYAvfY6kLGVrvNl8D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586424"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586424"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825815"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:30 -0800
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
Subject: [PATCH v9 02/27] x86/fpu/xstate: Refine CET user xstate bit enabling
Date: Tue, 23 Jan 2024 18:41:35 -0800
Message-Id: <20240124024200.102792-3-weijiang.yang@intel.com>
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

Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
reflect true dependency between CET features and the user xstate bit.
Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
available.

Both user mode shadow stack and indirect branch tracking features depend
on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.

Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
from CET KVM series which synthesizes guest CPUIDs based on userspace
settings,in real world the case is rare. In other words, the existing
dependency check is correct when only user mode SHSTK is available.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 07911532b108..f6b98693da59 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
 	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
 	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
 	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
-	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
 	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
 	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
 };
@@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
 	}
 
+	/*
+	 * CET user mode xstate bit has been cleared by above sanity check.
+	 * Now pick it up if either SHSTK or IBT is available. Either feature
+	 * depends on the xstate bit to save/restore user mode states.
+	 */
+	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
+		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
+
 	if (!cpu_feature_enabled(X86_FEATURE_XFD))
 		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 
-- 
2.39.3


