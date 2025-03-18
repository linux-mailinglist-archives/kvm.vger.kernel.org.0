Return-Path: <kvm+bounces-41392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBBCA677E7
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59DA73AAD33
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269F2211707;
	Tue, 18 Mar 2025 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XYJ3fmnc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B520E704;
	Tue, 18 Mar 2025 15:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311868; cv=none; b=YrKtNZzdQJjCn4sjJnZU6r4uYLX1SAgrObaPb7ZJwBxNGSuRzfdHtL9IMeMwwlgb7h/nhkuwH6VIelBzhWqPVf50/qpd9H4LgqGCEz7GwdA+OcG17EXkrhWO0anHjOXGXh51zl90A11qEr7DSp5ykUwPss8Lz4O+sSfAT66Lar4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311868; c=relaxed/simple;
	bh=Ys76oYNT/q1qSOn1LbY6YJ/3JhQN83P+tzFUg1WTGLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETe1fBCQtZVnpSPL5ErmZahh75FcR5Hz64ag9UISbzLnvjkeEABV9XD0xTtsR2pL0n9bGDvJlLoZUD+Tc1IGWU2QEjrlWzQ5m0UFIMMjAW4mmDZ5fIbN/Gcy0ik8BOpLZpT3Sbc6KhpnMoVlmiBoKp9zzSh/wMDoKRoT8F5OkAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XYJ3fmnc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311867; x=1773847867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ys76oYNT/q1qSOn1LbY6YJ/3JhQN83P+tzFUg1WTGLI=;
  b=XYJ3fmncz/ZkEgg6MbBXqxFkAsna3Gg9Dx7wHjM65VuSHoYONTYcZD0x
   bStkfkh0ktz7ezpIa7xqq2aTf1Jrn85iP3LF3oDm23EVhoB6ttuJc1qTE
   nXz0qM5SbrT/U0sB+dJdnSDDWyY7HQhTuwMAnZkPJJ6/oSKRv0VhvEUch
   EOkTGR2xyPAC74fpMFoMOwDCxZlJsP6/0CPp/eb/vU71z6WV6lwyXNzJ8
   h+mxYCy0R1NjVJmbymV8scnFGVdp8fUJeLl8GIu7ro/j+MA2mQBRQVJAi
   lkKKwcuids4bopmPM1nttq/X+L1rfS9D1v94YKG7F1K0Ej/FpJXlfH6HP
   g==;
X-CSE-ConnectionGUID: bpG67gqxQgqtGtcMyhDWlg==
X-CSE-MsgGUID: /29rdWasRG6WCv9qF5mxsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="46224260"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="46224260"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:31:06 -0700
X-CSE-ConnectionGUID: qXYctK0TSrOwbbQVxOlu1Q==
X-CSE-MsgGUID: o3w8wac3R+afEoDgXV9CNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122121991"
Received: from spr.sh.intel.com ([10.239.53.19])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:31:01 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH v4 6/8] x86/fpu: Initialize guest fpstate and FPU pseudo container from guest defaults
Date: Tue, 18 Mar 2025 23:31:56 +0800
Message-ID: <20250318153316.1970147-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250318153316.1970147-1-chao.gao@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fpu_alloc_guest_fpstate() currently uses host defaults to initialize guest
fpstate and pseudo containers. Guest defaults were introduced to
differentiate the features and sizes of host and guest FPUs. Update the
function to use guest defaults instead.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 52df97a8a61b..b00e4032d75f 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -200,7 +200,16 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
+static void __guest_fpstate_reset(struct fpstate *fpstate, u64 xfd)
+{
+	/* Initialize sizes and feature masks */
+	fpstate->size		= fpu_kernel_cfg.guest_default_size;
+	fpstate->user_size	= fpu_user_cfg.guest_default_size;
+	fpstate->xfeatures	= fpu_kernel_cfg.guest_default_features;
+	fpstate->user_xfeatures	= fpu_user_cfg.guest_default_features;
+	fpstate->xfd		= xfd;
+}
+
 
 static void fpu_lock_guest_permissions(struct fpu_guest *gfpu)
 {
@@ -225,19 +234,21 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = fpu_kernel_cfg.guest_default_size +
+	       ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
 
 	/* Leave xfd to 0 (the reset value defined by spec) */
-	__fpstate_reset(fpstate, 0);
+	__guest_fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
+	gfpu->xfeatures		= fpu_kernel_cfg.guest_default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -249,8 +260,8 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	 * all features that can expand the uABI size must be opt-in.
 	 */
 	gfpu->uabi_size		= sizeof(struct kvm_xsave);
-	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
-		gfpu->uabi_size = fpu_user_cfg.default_size;
+	if (WARN_ON_ONCE(fpu_user_cfg.guest_default_size > gfpu->uabi_size))
+		gfpu->uabi_size = fpu_user_cfg.guest_default_size;
 
 	fpu_lock_guest_permissions(gfpu);
 
-- 
2.46.1


