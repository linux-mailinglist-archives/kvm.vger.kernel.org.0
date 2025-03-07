Return-Path: <kvm+bounces-40357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B386A56E08
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:41:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65B7E16FA78
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEDA242937;
	Fri,  7 Mar 2025 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJtcXpnw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C26818BB9C;
	Fri,  7 Mar 2025 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365559; cv=none; b=IUweV7CiGNSjeitPx1C1JxIwCU8Q4I8wi/4NOxMVAkv2J1jtP+wcyGJLcVWsX569+W3twCzHEzQ0dlOfjiwQdw9t39pZqzPk6Kyuyo5OOzg5kaCb4YJdx78kJxybGgWNf7evx/OWV5xvtR/0NjgcQekMVR0SMY9MNSuJq6CXA58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365559; c=relaxed/simple;
	bh=JMJwJmvvDb2gSkAc1Vt7kalSklLNxXgohGfolGvkY+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfSaS5UiT7wfkV1Pduk35IRo5P4wj8zcXt49vDGuOodH4I8mHWH1zc/Qu/7SLyT2QARRYYOTgOOaLAj8J/8uxe8TvgCOdivfotVli4sql/C1svUf1sSiipf82WIqdkNa9qczrixUeVXZZHj0dbMjrBnWwwFB7uEP7Zs/mh2Ba/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJtcXpnw; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741365557; x=1772901557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JMJwJmvvDb2gSkAc1Vt7kalSklLNxXgohGfolGvkY+A=;
  b=aJtcXpnw3cMpVoalaZeVKMFn+Pe155xyxYrAV17VsghxAJ6rixyqunve
   lxRi5FUt+JBapAvCXw5EPk0ZODu/hvKFmx5Q/Mem7ZG3UDlt+zKliEE6c
   ERWdr1HP9U60OtPXa4Fo3wLfl8zHpZbhDoA8ZMnq+PlRSUCk/GyY9oadj
   MqtI1fuTrvFv3nprN9mmGgMI+i2ySeeN00mzjhgTeQZU36h0tZxmS8193
   YF7gg6aPpXqvxZYk3BrOpFOj020aewg5v/oHPCS6BfIlOmf0dql51dTNM
   GtNw1VxekPFLs5WH5vA9djtsWsl0F6mDA1amjSbhT7IOGdDNnkeasXbhQ
   w==;
X-CSE-ConnectionGUID: lrqum1phRSKJDxm/RfRwsg==
X-CSE-MsgGUID: 7P6+aEtcTGqLBmR6lfZc+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46344452"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="46344452"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:17 -0800
X-CSE-ConnectionGUID: VRrK0471SkWl1obg/F7eCw==
X-CSE-MsgGUID: MtO4oQ/CT+qI993fd3DPtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124397986"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 08:39:14 -0800
From: Chao Gao <chao.gao@intel.com>
To: chao.gao@intel.com,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 07/10] x86/fpu/xstate: Initialize guest fpstate with fpu_guest_config
Date: Sat,  8 Mar 2025 00:41:20 +0800
Message-ID: <20250307164123.1613414-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250307164123.1613414-1-chao.gao@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Use fpu_guest_cfg to initialize the guest fpstate and the guest FPU pseduo
container.

The user_* fields remain unchanged for compatibility with KVM uAPIs.

Inline the logic of __fpstate_reset() to directly utilize fpu_guest_cfg.

Note fpu_guest_cfg and fpu_kernel_cfg remain the same for now. So there
is no functional change.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index d7ae684adbad..9cb800918b6d 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -194,8 +194,6 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
-
 static void fpu_lock_guest_permissions(struct fpu_guest *gfpu)
 {
 	struct fpu_state_perm *fpuperm;
@@ -219,19 +217,22 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = fpu_guest_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
 
-	/* Leave xfd to 0 (the reset value defined by spec) */
-	__fpstate_reset(fpstate, 0);
+	fpstate->size		= fpu_guest_cfg.default_size;
+	fpstate->xfeatures	= fpu_guest_cfg.default_features;
+	fpstate->user_size	= fpu_user_cfg.default_size;
+	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
 	fpstate_init_user(fpstate);
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
+	gfpu->xfeatures		= fpu_guest_cfg.default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
-- 
2.46.1


