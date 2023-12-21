Return-Path: <kvm+bounces-4987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B4081B1C2
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9839B25D32
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035414D11C;
	Thu, 21 Dec 2023 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CcQThKvh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67C4C63D;
	Thu, 21 Dec 2023 09:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149425; x=1734685425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O+In4X9Kp5bd1+hICvCOfi4/QLtmFNAek1QhOW3ItLM=;
  b=CcQThKvhCRj/PRkKCY7SMPWg1CdKG/6/sjVd5yYCXlQxAM11fkKBxE8d
   aaem5ioZrtVImG8hJEK4QASCN+ijNSPs9sx+I5IAzcZ1U1LZePtEHbPJJ
   8seLaxUm7cBLghz74mt8d+1JKA5diSU5At8mhKB6hq5K9dHyP4KCizT3a
   +hSGhwQ+zymrZmvvNh6rAxqKjvP15bwQqT1vO1LlPiImR2d+TrDi8wOLM
   ydhRTu+XDfDuyZ9LC6WZZ5VsJ42Cm0CXa6tO85xrb96O/vjZVNU0Hhyl5
   1aXxtq8WAwNc9suC+Wx5AjHFsIXGhV13YJFn8znmcp2Mr42ULfg/o6iG4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729602"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729602"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028567"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028567"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:10 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 02/26] x86/fpu/xstate: Refine CET user xstate bit enabling
Date: Thu, 21 Dec 2023 09:02:15 -0500
Message-Id: <20231221140239.4349-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
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


