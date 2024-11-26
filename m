Return-Path: <kvm+bounces-32510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76AAA9D9559
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:19:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DBDE284AFC
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634B31CF5EE;
	Tue, 26 Nov 2024 10:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KOapzJUX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1489C1CFEDB;
	Tue, 26 Nov 2024 10:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616316; cv=none; b=Uam5cOhqiMCyF5EuxxaAwDMEbvvqjbmeEz7dUCdxf6TBg1FXgCmEZITdW2FyHWMujo1WLqq2lYlokhXdEVV7g4CdJnmLOvxPE0SG4rrj9RIrq6Iob103e8zFrnFPW869cL5pzsyyVNptiAy64T1wHxMHw2GskJyntd6IdHSDnIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616316; c=relaxed/simple;
	bh=cNhDjERPkjsZnBRvBJefmJUkxw1pIJ8YGdH90KKnQF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/gaooyWohFkD9xn8RzujZ2S6P7Ge1An4Yol++x5UlmUHlzdsDtNO1p/i0T4jBwoYsoQ6qltcxZOEnxP3ZquQROt8oQCIPV/Ffnk3+9yIkezFGbjB0YJu62B1T8+0FOY7Rka+GwItyrcm0TQKzbutyn5DUijiEan6VOO976BSLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KOapzJUX; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732616315; x=1764152315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cNhDjERPkjsZnBRvBJefmJUkxw1pIJ8YGdH90KKnQF0=;
  b=KOapzJUXL1Mk8ZtNeP8E/OeoMC43SujgtqSir3z01/btdYLEMFfJOnG0
   LgOgrWPTwF7ajFPRWNRw588w3B9A7P09EgRz+pnOCof6rns08AqZ2uKKv
   7X4v3yw3q5Eo7buRSnidd3tKj3+T1Xy4vxbr8dPWoLbZISBUPj6GUpkp1
   ezIDGEKZ8F0gVEMibh+0mgipfzQjNb/0nk1xNY8Gt+MiOniJ2qtnhe1KV
   77Bax8S2zvLlIL/0xD4r0gc0JECkxPL2p9mwOLjEz2WfKWgvgkO2LKD/L
   FC8xUFHojWn8VL08KJI1SOzL2TXUyGZxsmflyGe4yKmaRJW1BL9TGU3QS
   A==;
X-CSE-ConnectionGUID: q8tuJQH8TWeOOJyVLchVgg==
X-CSE-MsgGUID: B088g4prSoKDZ6V3ZdxlBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32139894"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="32139894"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:35 -0800
X-CSE-ConnectionGUID: v0dhmJuMRDWPmLM9qdBFGA==
X-CSE-MsgGUID: o9CL/LsfQ2KJ4QEe82ZoGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="96631851"
Received: from spr.sh.intel.com ([10.239.53.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:31 -0800
From: Chao Gao <chao.gao@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v2 5/6] x86/fpu/xstate: Create guest fpstate with guest specific config
Date: Tue, 26 Nov 2024 18:17:09 +0800
Message-ID: <20241126101710.62492-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241126101710.62492-1-chao.gao@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

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
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/core.c | 39 +++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 9e2e5c46cf28..00d7dcf45b34 100644
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
@@ -216,25 +214,48 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
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
+	size = fpu_guest_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
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
+	if (!__fpu_alloc_init_guest_fpstate(gfpu))
+		return false;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
-- 
2.46.1


