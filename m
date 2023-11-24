Return-Path: <kvm+bounces-2395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F67E7F6D55
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 436B61C20DCA
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8384BB673;
	Fri, 24 Nov 2023 07:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJZIRBVU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA7F1709;
	Thu, 23 Nov 2023 23:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812718; x=1732348718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdZD38yweQWB0vjlPzQLn4oLXiqKkJKeoiDZAwo7txU=;
  b=HJZIRBVUmhkgaFHdfjlmjnDn15iwL82UY2p1inbICSWsT1uZ8a3+cixG
   N1NplYqUeNux60Zsdv8Zbub8BbmSxQD7qax/WUxyBhA5U9KnPyjWAOymO
   9XFXyrEy3e875eU+/MIs0f7VdImJOEHZxhEdPPDi//wvYQWwXm4cw5qHe
   +x2ypX9roMSnTcYd/FEQGsFhFUs3n/055qrEvWu6v91WVLSK4V/tU8WGU
   QaV4aaoBRKLsONo3pB93TqcJx40+VETkWd21z+potpEORtdH0Hp4FGyef
   G7QMxftIj3gX5lwOzcyOjakDn1gCrfKPAQasgemJ857fILbRGmnm35kpv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872275"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872275"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629795"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629795"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:35 -0800
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
Subject: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit enabling
Date: Fri, 24 Nov 2023 00:53:06 -0500
Message-Id: <20231124055330.138870-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
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
settings,in real world the case is rare. In other words, the exitings
dependency check is correct when only user mode SHSTK is available.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 73f6bc00d178..6e50a4251e2b 100644
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
2.27.0


