Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B37A0056
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbjINJii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbjINJiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A671283;
        Thu, 14 Sep 2023 02:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684298; x=1726220298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qn5wUWy4Vkg3CghO5UGfFtXHTUkaS9WcgUAH/F4Vglo=;
  b=BbCng3w8S/y86ljpQZbVzEfEltJG3Qwgv4wtOQIqDktnowRq3eCkem6Q
   8zaMjN4DBDELD+nFyIG3qyCZ8oBEwltOYJjg9upHoZE0RqZQeNQ2VO+FT
   FLzsvUb3SEV/jvODZDhAh8iby2Dv5YJO9SD4j7Bmm32uyTJfGwYXDfuKh
   5ZSFk3Ya2dY7y5DvdAXKLBAYP8cHRAa7ad7A7Njr7pLdoHYaUxpXqzak3
   IfGNbc+EP1l1bv7CfttxviEh8MFXFzkZCOiJc8aLUX5DftSUCBpOkofZ6
   fhsogzrwFJTMco8F9HcYNzb7Qb0VsmHf7urQZmp7Wb8HSGrq9Po/gP8qB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857341"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857341"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656232"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656232"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 07/25] x86/fpu/xstate: Tweak guest fpstate to support kernel dynamic xfeatures
Date:   Thu, 14 Sep 2023 02:33:07 -0400
Message-Id: <20230914063325.85503-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest fpstate is sized with fpu_kernel_cfg.default_size (by preceding
fix) and the kernel dynamic xfeatures are not taken into account, so add
the support and tweak fpstate xfeatures and size accordingly.

Below configuration steps are currently enforced to get guest fpstate:
1) User space sets thread group xstate permits via arch_prctl().
2) User space creates vcpu thread.
3) User space enables guest dynamic xfeatures.

In #1, guest fpstate size (i.e., __state_size [1]) is induced from
(fpu_kernel_cfg.default_features | user dynamic xfeatures) [2].
In #2, guest fpstate size is calculated with fpu_kernel_cfg.default_size
and fpstate->size is set to the same. fpstate->xfeatures is set to
fpu_kernel_cfg.default_features.
In #3, guest fpstate is re-allocated as [1] and fpstate->xfeatures is
set to [2].

By adding kernel dynamic xfeatures in above #1 and #2, guest xstate area
size is expanded to hold (fpu_kernel_cfg.default_features | kernel dynamic
_xfeatures | user dynamic xfeatures)[3], and guest fpstate->xfeatures is
set to [3]. Then host xsaves/xrstors can act on all guest xfeatures.

The user_* fields remain unchanged for compatibility of non-compacted KVM
uAPIs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/core.c   | 56 +++++++++++++++++++++++++++++-------
 arch/x86/kernel/fpu/xstate.c |  2 +-
 arch/x86/kernel/fpu/xstate.h |  2 ++
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a42d8ad26ce6..e5819b38545a 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -33,6 +33,8 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
 DEFINE_PER_CPU(u64, xfd_state);
 #endif
 
+extern unsigned int xstate_calculate_size(u64 xfeatures, bool compacted);
+
 /* The FPU state configuration data for kernel and user space */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
 struct fpu_state_config fpu_user_cfg __ro_after_init;
@@ -193,8 +195,6 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
-
 static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 {
 	struct fpu_state_perm *fpuperm;
@@ -215,28 +215,64 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
 }
 
-bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
+static struct fpstate *__fpu_alloc_init_guest_fpstate(struct fpu_guest *gfpu)
 {
+	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
+	unsigned int gfpstate_size, size;
 	struct fpstate *fpstate;
-	unsigned int size;
+	u64 xfeatures;
+
+	/*
+	 * fpu_kernel_cfg.default_features includes all enabled xfeatures
+	 * except those dynamic xfeatures. Compared with user dynamic
+	 * xfeatures, the kernel dynamic ones are enabled for guest by
+	 * default, so add the kernel dynamic xfeatures back when calculate
+	 * guest fpstate size.
+	 *
+	 * If the user dynamic xfeatures are enabled, the guest fpstate will
+	 * be re-allocated to hold all guest enabled xfeatures, so omit user
+	 * dynamic xfeatures here.
+	 */
+	xfeatures = fpu_kernel_cfg.default_features |
+		    fpu_kernel_dynamic_xfeatures;
+
+	gfpstate_size = xstate_calculate_size(xfeatures, compacted);
 
-	size = fpu_kernel_cfg.default_size +
-	       ALIGN(offsetof(struct fpstate, regs), 64);
+	size = gfpstate_size + ALIGN(offsetof(struct fpstate, regs), 64);
 
 	fpstate = vzalloc(size);
 	if (!fpstate)
-		return false;
+		return NULL;
+	/*
+	 * Initialize sizes and feature masks, use fpu_user_cfg.*
+	 * for user_* settings for compatibility of exiting uAPIs.
+	 */
+	fpstate->size		= gfpstate_size;
+	fpstate->xfeatures	= xfeatures;
+	fpstate->user_size	= fpu_user_cfg.default_size;
+	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
+	fpstate->xfd		= 0;
 
-	/* Leave xfd to 0 (the reset value defined by spec) */
-	__fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_user_cfg.default_features;
+	gfpu->xfeatures		= xfeatures;
 	gfpu->perm		= fpu_user_cfg.default_features;
 
+	return fpstate;
+}
+
+bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
+{
+	struct fpstate *fpstate;
+
+	fpstate = __fpu_alloc_init_guest_fpstate(gfpu);
+
+	if (!fpstate)
+		return false;
+
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
 	 * to userspace, even when XSAVE is unsupported, so that restoring FPU
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c5d903b4df4d..87149aba6f11 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -561,7 +561,7 @@ static bool __init check_xstate_against_struct(int nr)
 	return true;
 }
 
-static unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
+unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
 {
 	unsigned int topmost = fls64(xfeatures) -  1;
 	unsigned int offset = xstate_offsets[topmost];
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index a4ecb04d8d64..9c6e3ca05c5c 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -10,6 +10,8 @@
 DECLARE_PER_CPU(u64, xfd_state);
 #endif
 
+extern u64 fpu_kernel_dynamic_xfeatures;
+
 static inline void xstate_init_xcomp_bv(struct xregs_state *xsave, u64 mask)
 {
 	/*
-- 
2.27.0

