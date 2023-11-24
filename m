Return-Path: <kvm+bounces-2403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B7E7F6D69
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05E131C20E96
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C0D15AC5;
	Fri, 24 Nov 2023 07:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ak4Ldskp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AA610C8;
	Thu, 23 Nov 2023 23:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812723; x=1732348723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1vwvfuaBTc7h5kz+PPAFiMP1RdwSkDr6j//+KudefV4=;
  b=Ak4Ldskpm9w5KOqmB3eQTagizetRVcHNTf7wKyMhhXPrjbizl1G3+CfQ
   PyboXnzwUbVhcj+Au5vjrYacYIKuocSGvqRj9EVK0MffU/IBr0BX10ZSg
   ZF0AUmNXKQMA7l+c9npO6UNvIgWllqTAB67eCpVdt1/Mp+IN2aFfpaYxr
   HIdAT+1Xv1mJ7whZcHeqTCe6Rw7aERDDJePMkmcTH9ZV9ljhpVtJxQRYB
   cZAGvGR7NvvpC83BFPdHnNd06I8XtUekkFhUgu0uHmdygtJUUmudY7yKB
   3OETi3XuqXvc7wPhMBSAP/J4Xdh42SQRutzyInvDy20EKQnhtXsZPvvou
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872298"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872298"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629807"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629807"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:36 -0800
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
Subject: [PATCH v7 06/26] x86/fpu/xstate: Create guest fpstate with guest specific config
Date: Fri, 24 Nov 2023 00:53:10 -0500
Message-Id: <20231124055330.138870-7-weijiang.yang@intel.com>
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

Use fpu_guest_cfg to calculate guest fpstate settings, open code for
__fpstate_reset() to avoid using kernel FPU config.

Below configuration steps are currently enforced to get guest fpstate:
1) Kernel sets up guest FPU settings in fpu__init_system_xstate().
2) User space sets vCPU thread group xstate permits via arch_prctl().
3) User space creates guest fpstate via __fpu_alloc_init_guest_fpstate()
   for vcpu thread.
4) User space enables guest dynamic xfeatures and re-allocate guest
   fpstate.

By adding kernel dynamic xfeatures in above #1 and #2, guest xstate area
size is expanded to hold (fpu_kernel_cfg.default_features | kernel dynamic
xfeatures | user dynamic xfeatures), then host xsaves/xrstors can operate
for all guest xfeatures.

The user_* fields remain unchanged for compatibility with KVM uAPIs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/core.c   | 48 ++++++++++++++++++++++++++++--------
 arch/x86/kernel/fpu/xstate.c |  2 +-
 arch/x86/kernel/fpu/xstate.h |  1 +
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 516af626bf6a..985eaf8b55e0 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -194,8 +194,6 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
-
 static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 {
 	struct fpu_state_perm *fpuperm;
@@ -216,25 +214,55 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
 }
 
-bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
+static struct fpstate *__fpu_alloc_init_guest_fpstate(struct fpu_guest *gfpu)
 {
+	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
+	unsigned int gfpstate_size, size;
 	struct fpstate *fpstate;
-	unsigned int size;
 
-	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	/*
+	 * fpu_guest_cfg.default_features includes all enabled xfeatures
+	 * except the user dynamic xfeatures. If the user dynamic xfeatures
+	 * are enabled, the guest fpstate will be re-allocated to hold all
+	 * guest enabled xfeatures, so omit user dynamic xfeatures here.
+	 */
+	gfpstate_size = xstate_calculate_size(fpu_guest_cfg.default_features,
+					      compacted);
+
+	size = gfpstate_size + ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
-		return false;
+		return NULL;
+	/*
+	 * Initialize sizes and feature masks, use fpu_user_cfg.*
+	 * for user_* settings for compatibility of exiting uAPIs.
+	 */
+	fpstate->size		= gfpstate_size;
+	fpstate->xfeatures	= fpu_guest_cfg.default_features;
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
-	gfpu->perm		= fpu_user_cfg.default_features;
+	gfpu->xfeatures		= fpu_guest_cfg.default_features;
+	gfpu->perm		= fpu_guest_cfg.default_features;
+
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
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index aa8f8595cd41..253944cb2298 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -559,7 +559,7 @@ static bool __init check_xstate_against_struct(int nr)
 	return true;
 }
 
-static unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
+unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
 {
 	unsigned int topmost = fls64(xfeatures) -  1;
 	unsigned int offset = xstate_offsets[topmost];
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 3518fb26d06b..c032acb56306 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -55,6 +55,7 @@ extern void fpu__init_cpu_xstate(void);
 extern void fpu__init_system_xstate(unsigned int legacy_size);
 
 extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
+extern unsigned int xstate_calculate_size(u64 xfeatures, bool compacted);
 
 static inline u64 xfeatures_mask_supervisor(void)
 {
-- 
2.27.0


