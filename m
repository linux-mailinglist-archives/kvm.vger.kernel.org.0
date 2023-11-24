Return-Path: <kvm+bounces-2401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05CB07F6D61
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62B34B21163
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4BE11737;
	Fri, 24 Nov 2023 07:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mm0QiHiz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426061719;
	Thu, 23 Nov 2023 23:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812721; x=1732348721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ri6Un4b+Ug+q4iHhsNMvjaggwXQxRjHXcUUIj5tdoAM=;
  b=Mm0QiHiz7Jw2x4YIvxGrZs3dbJv5rNjJVxMWUm1I75RsGCsxDqCITWqs
   8HMTe7CF3YpHZph50BRnQ5hBKLK4YScWwl73irWQB5YDsVDqndxqIAh1R
   nVnfn7EfdPmIG0UXND6T7Rzrr3jKe0PD6+lbGG29/DR624GnSqcuwEoDZ
   8MgdacGLPf5CfHAHNDJZz6RfDm0yPd1vHyWiDbJy75hsRTMOpsAe6pVQv
   BNoSgtY2GiAKopSl63Evi2QbZz1jTEExDv5Ml/KuM+s/ozgmNmRvQQXEq
   IPHk+Gf7zMnF90DkqwMyRLpFO8ks98x7F2IeimvxvJLru83VKt+penb+R
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872286"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872286"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629801"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629801"
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
Subject: [PATCH v7 04/26] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Date: Fri, 24 Nov 2023 00:53:08 -0500
Message-Id: <20231124055330.138870-5-weijiang.yang@intel.com>
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

Define new XFEATURE_MASK_KERNEL_DYNAMIC set including the features can be
optionally enabled by kernel components, i.e., the features are required by
specific kernel components. Currently it's used by KVM to configure guest
dedicated fpstate for calculating the xfeature and fpstate storage size etc.

The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which is
supported by host as they're enabled in xsaves/xrstors operating xfeature set
(XCR0 | XSS), but the relevant CPU feature, i.e., supervisor shadow stack, is
not enabled in host kernel so it can be omitted for normal fpstate by default.

Remove the kernel dynamic feature from fpu_kernel_cfg.default_features so that
the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors can be
optimized by HW for normal fpstate.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/fpu/xstate.h | 5 ++++-
 arch/x86/kernel/fpu/xstate.c      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 3b4a038d3c57..a212d3851429 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -46,9 +46,12 @@
 #define XFEATURE_MASK_USER_RESTORE	\
 	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
 
-/* Features which are dynamically enabled for a process on request */
+/* Features which are dynamically enabled per userspace request */
 #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
 
+/* Features which are dynamically enabled per kernel side request */
+#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
+
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
 					    XFEATURE_MASK_CET_USER | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index b57d909facca..ba4172172afd 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -824,6 +824,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	/* Clean out dynamic features from default */
 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
 
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-- 
2.27.0


