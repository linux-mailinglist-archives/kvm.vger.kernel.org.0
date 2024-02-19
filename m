Return-Path: <kvm+bounces-9018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1FB859D7C
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:51:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 456731F20FAB
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D892C6B8;
	Mon, 19 Feb 2024 07:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EDshXo79"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C8423750;
	Mon, 19 Feb 2024 07:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328869; cv=none; b=POkMNes07+nB9SWkWl+DHLIww5MU+z5dLeggB+Z8kjLY/+/gqpAyHyPKaS/IxEopZIcv3Weo4ZC2ZCv0OwKAhcjYENGXIa9qgSy2l8sjo/VOS+rjt4kJH87wTCGYawmT+tPPoUmobXiIVFbAoOAQAFvF9XmfsyLKXvRc4AGTFbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328869; c=relaxed/simple;
	bh=SkFizbcLL2iXx+O1d7csJZlnwkmoUAktnTokiB88u0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUC+M4iNwmh7qQ5Y0eHRPhPU3uwQS0hiUvOAsrPQpwV2W72i0XjnrFM+WgtmNQbPgmOHI/vIwiY9IE3nD4u831kRDIfcmLZ7GhHOBYYXTRT8WmktSI0jJhwTwXepYmts2PTp+YA/DaHHee9nCnWdzuK6ndTXhL3+AjUp0qwuJzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EDshXo79; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328867; x=1739864867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SkFizbcLL2iXx+O1d7csJZlnwkmoUAktnTokiB88u0A=;
  b=EDshXo79qBqb2BX379ViBSeqcpYGrd9Qw2rozun5JpurTF2naqiNdfjP
   dDtGSj2p2tJhbupXUzEnJxIwoe2DHHPE28+79uduAc6rCnqgH6/ylRfEW
   ISZ6sQDD5fnaG2hAsVmuna1jxS76XgrUQG0EbIIJ1ELCadAwXV7OyXE9T
   gvOF9lJBCfIA1loFWOl/lMzKCnh6YQXomYC1Ll2O7xDN7FHgOA2/XDeJw
   DP5NACTFdQx0psmZVfDvfZ2VfYAYwSCzFuvp9oHk7JuZtbO7J++6wZPD9
   tQaSvlE5yZHsSXTVcfB7zCT+9i4SkoC4PmOONi7m4JFPIC6rN6cZCXVZ4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535045"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535045"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966075"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966075"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 06/27] x86/fpu/xstate: Create guest fpstate with guest specific config
Date: Sun, 18 Feb 2024 23:47:12 -0800
Message-ID: <20240219074733.122080-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
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
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/core.c | 39 +++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index e8205e261a24..dc2d2641fda7 100644
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
2.43.0


