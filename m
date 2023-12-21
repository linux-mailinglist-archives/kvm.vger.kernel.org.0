Return-Path: <kvm+bounces-4992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CADAD81B1CE
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 583F11F24BE5
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60AF853E2D;
	Thu, 21 Dec 2023 09:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ck1ZKy95"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37FC4CDE0;
	Thu, 21 Dec 2023 09:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149427; x=1734685427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N6bKvF/wjxHav2Jw8JLBlRUTjnJbutaCfY+j5c1XrYo=;
  b=ck1ZKy95V7YjYuEz9fFjkMsQFGUauiX7hqrTb3TVHoZoDGhbQYuHh0nn
   uS3sXjlEkoRtYdssjfpzJ/sCme7qvctyyVwpzRHR33HeXi3o1grWxXMfQ
   +3CpgSRtm77dCyrcUrbHfD+wl0qJcS/QBgmY4PovcVqU4ur5slGPdyQ60
   IW/HougPV26F0TXZ9oaCILIEfuvebc3HLj3tCg2qJ/k7XSqk9mfroZEON
   94VCy/kTm11RedWLo2wmh4aKDCO9xcBx21DKuwXet3GmBrikxupbZD7uJ
   KmAjBajbsYYyA5l9LZq8pCDi665jvpvZdnX/PU3jw1+H1TuuF3T+9YIgP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729618"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729618"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028578"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028578"
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
Subject: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with guest specific config
Date: Thu, 21 Dec 2023 09:02:19 -0500
Message-Id: <20231221140239.4349-7-weijiang.yang@intel.com>
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
 arch/x86/kernel/fpu/core.c | 47 ++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 976f519721e2..0e0bf151418f 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -250,8 +250,6 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
-
 static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 {
 	struct fpu_state_perm *fpuperm;
@@ -272,25 +270,54 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
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
+	 * fpu_guest_cfg.default_size is initialized to hold all enabled
+	 * xfeatures except the user dynamic xfeatures. If the user dynamic
+	 * xfeatures are enabled, the guest fpstate will be re-allocated to
+	 * hold all guest enabled xfeatures, so omit user dynamic xfeatures
+	 * here.
+	 */
+	size = fpu_guest_cfg.default_size +
+	       ALIGN(offsetof(struct fpstate, regs), 64);
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
-- 
2.39.3


