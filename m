Return-Path: <kvm+bounces-46025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBC1AB0CEB
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD3D1B2181D
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14590278173;
	Fri,  9 May 2025 08:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fL5Cg0dD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAA423F295;
	Fri,  9 May 2025 08:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746778582; cv=none; b=t8pyuiryo4Sh7U+gQsUpHaiV2r1KTvP6Az77PuXEcYkTp6ldW7s/cemEzf5hHTlf1bFRLbPQ9hocAERYbNIcpw8Qkm+AqVGnhh3qhq7aAjxPcMG0EUX+/ZjuB6fh+WKtgsDO5AyImRyrKFLV/g45J27so061LXKWYJiztEt1C8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746778582; c=relaxed/simple;
	bh=dZyVNNyJgGmclzDqEhXsy2Vraut8p1shQ6hBt3hOS4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlrD0eyYxWv7abEmrT94PZw81BdFXNFT6/FjuJQjnBL3j6QMXfSzGVyJY7QgnvBRggCy789O3+KT+TLbpd93apjE8t9vnasteHlNFJ6cCWoExnWeZ1ZIoStz+Hnxj7w+gRgJMRUUFsIb9mhJg1qHzbBg2lB1RfWIKLHLMtuglIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fL5Cg0dD; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746778581; x=1778314581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dZyVNNyJgGmclzDqEhXsy2Vraut8p1shQ6hBt3hOS4I=;
  b=fL5Cg0dDusjZ0VG7yUts8zIUOBLW6VdXXZK+/wJLVnc3GMw/2EcaYYC3
   Bgz8srlZ96v4r82cdGbAJHM+GKGjiaXRhpOg5B0V6+KDtpYzqZzqUaBp3
   +TfzAx6vtr2G8wBlzt9hEmoqy+/8J8xK66J4FmRB2yxJ/KLWTAmCUQhq7
   LjfJ8MreZNs/UzK8ypE0bOTaePKJgFPoNNGYzac///tGFNErEs6Klvxs3
   OlBrY3rTq9AGBwCD6xxK27w4ENs1AIhREasRNmVxeZdFCQlSue6QTR8BR
   FLtRXLmsgmsZBx1BJPM+c9LdhR6U1f711iz/QiPUIY1YwQS2jgJ7FzK38
   A==;
X-CSE-ConnectionGUID: 2FCBcBt3T3yGvy1P7v5nVA==
X-CSE-MsgGUID: JNfVXGfRSUemh2nTvrq8lA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73977338"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="73977338"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 01:16:20 -0700
X-CSE-ConnectionGUID: EbSW/sgcQ+aEJGLTEYgkVw==
X-CSE-MsgGUID: EbBx3UJJQ9+9C9vC/UX6yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136565726"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 01:16:19 -0700
From: Chao Gao <chao.gao@intel.com>
To: chao.gao@intel.com
Cc: bp@alien8.de,
	chang.seok.bae@intel.com,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ebiggers@google.com,
	hpa@zytor.com,
	john.allen@amd.com,
	kees@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	oleg@redhat.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	stanspas@amazon.de,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin3.li@intel.com
Subject: [PATCH v6a 6/8] x86/fpu: Remove xfd argument from __fpstate_reset()
Date: Fri,  9 May 2025 01:16:15 -0700
Message-ID: <20250509081615.248896-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250506093740.2864458-6-chao.gao@intel.com>
References: <20250506093740.2864458-6-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The initial values for fpstate::xfd differ between guest and host fpstates.
Currently, the initial values are passed as an argument to
__fpstate_reset(). But, __fpstate_reset() already assigns different default
features and sizes based on the type of fpstates (i.e., guest or host). So,
handle fpstate::xfd in a similar way to highlight the differences in the
initial xfd value between guest and host fpstates

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/all/aBuf7wiiDT0Wflhk@google.com/
---
v6a: new.

Note: this quick revision is just intended to ensure that the feedback
has been properly addressed.

 arch/x86/kernel/fpu/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 0d501bd25d79..a3cafed350e0 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -211,7 +211,7 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
+static void __fpstate_reset(struct fpstate *fpstate);
 
 static void fpu_lock_guest_permissions(void)
 {
@@ -246,8 +246,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
 
-	/* Leave xfd to 0 (the reset value defined by spec) */
-	__fpstate_reset(fpstate, 0);
+	__fpstate_reset(fpstate);
 	fpstate_init_user(fpstate);
 
 	gfpu->fpstate		= fpstate;
@@ -536,7 +535,7 @@ void fpstate_init_user(struct fpstate *fpstate)
 		fpstate_init_fstate(fpstate);
 }
 
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
+static void __fpstate_reset(struct fpstate *fpstate)
 {
 	/*
 	 * Initialize sizes and feature masks. Supervisor features and
@@ -546,21 +545,23 @@ static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 	if (fpstate->is_guest) {
 		fpstate->size		= guest_default_cfg.size;
 		fpstate->xfeatures	= guest_default_cfg.features;
+		/* Leave xfd to 0 (the reset value defined by spec) */
+		fpstate->xfd		= 0;
 	} else {
 		fpstate->size		= fpu_kernel_cfg.default_size;
 		fpstate->xfeatures	= fpu_kernel_cfg.default_features;
+		fpstate->xfd		= init_fpstate.xfd;
 	}
 
 	fpstate->user_size	= fpu_user_cfg.default_size;
 	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
-	fpstate->xfd		= xfd;
 }
 
 void fpstate_reset(struct fpu *fpu)
 {
 	/* Set the fpstate pointer to the default fpstate */
 	fpu->fpstate = &fpu->__fpstate;
-	__fpstate_reset(fpu->fpstate, init_fpstate.xfd);
+	__fpstate_reset(fpu->fpstate);
 
 	/* Initialize the permission related info in fpu */
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
-- 
2.47.1


