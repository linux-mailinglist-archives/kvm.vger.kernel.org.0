Return-Path: <kvm+bounces-6754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFD2839F5C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFE4F1C225FC
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AEA16429;
	Wed, 24 Jan 2024 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N9y/JW2v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF67CC8D2;
	Wed, 24 Jan 2024 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064157; cv=none; b=N0d41SQwTboMOUz/6qBLZ7k5KZJtZrpFgiI6fzvTCKc8k7caahT69iZFAExy5f0SdmyLBZi7DBUem1fLwMlSU6ltiIPTNjTo8ImMFF5LxOV7CvOvgrfgMziLGJly2SEQeL6buAx9GCUI9+4/myD8FDreFB+6uW9AltmA+2TLHkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064157; c=relaxed/simple;
	bh=LcUwY8V1632alJGE8IcrVFp1L0/aYLAVGYcE+EcRKn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lztu7vsJhJgHzj44r97PgP40ZAsx5dbW7NVMzrd7NbxcnSiex+bpSaVJjrbEF1B8+TDaw1k5FEXRrFXpz0PM3WdoH7yWbUY1+foh5577peaxH3bQycxt93B1n5LCDUswl5Fgv8MH1SZY9mrDnb49IPClYn7TYDlZiUzPOFsuGyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N9y/JW2v; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064155; x=1737600155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LcUwY8V1632alJGE8IcrVFp1L0/aYLAVGYcE+EcRKn4=;
  b=N9y/JW2vZyIMObBfAO6qEzKZGEZExj0aGO08Bj/gV17og8vFX52iKPiY
   Re8KQNH/la6NiUB9TbpOpbx9p8Xc+w2dDSyVtMfYeJkqc6AwizI1vI/u6
   Sx6T5VkLuDnvtydSKZ8lTSMVoUP8hCm+w2OPcxLHjC6qsW/LhoiRIxwRi
   Dfy0jsB6Ih1YS2G6TKV9WmbBXsMCKBXJSlzYiYRoxxS9OY/4DQS+1VLac
   eQkdBEWoBG1hk4BP5UAV1biNa0dX0lUBhVeb/OQgGFodpR0VIGwOpLb83
   edcdVWOwFiS7pcaevslZp+knJcP0de34M8DnTLckw4o4yJhe4UvDfuplP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586452"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586452"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825843"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:33 -0800
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
Subject: [PATCH v9 06/27] x86/fpu/xstate: Create guest fpstate with guest specific config
Date: Tue, 23 Jan 2024 18:41:39 -0800
Message-Id: <20240124024200.102792-7-weijiang.yang@intel.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kernel/fpu/core.c | 44 ++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 516af626bf6a..6048352e1cc7 100644
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
@@ -216,25 +214,53 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
 }
 
-bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
+static struct fpstate *__fpu_alloc_init_guest_fpstate(struct fpu_guest *gfpu)
 {
 	struct fpstate *fpstate;
 	unsigned int size;
 
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
+	fpstate->size		= fpu_guest_cfg.default_size;
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


