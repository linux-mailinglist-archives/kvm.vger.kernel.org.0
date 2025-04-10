Return-Path: <kvm+bounces-43063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF97A83AFE
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37BC7465B07
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6CE216392;
	Thu, 10 Apr 2025 07:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KY5VuvDM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E042520B819;
	Thu, 10 Apr 2025 07:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269773; cv=none; b=G4OycQkm9LEu6FSWD4Xfape2zLjURvrBjcw7U/Modxj6SIuSroAxZ386WST4vKVjLfxbEQ2G2zZo4Z4C8bN1+2ViwWN0ES6xRDJZ/GG57pc4DMFsNIHB3j7GoQM0QOCKu91J6l8L3osWPeADpLzTs1lfoNvOrKBhCWrDQJfJga4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269773; c=relaxed/simple;
	bh=p034v+1t9zJ9E2nJhCRWSagSV/SOx27HYDYAI/C9kig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdCh9DWZ3Fagd25Jt2ATxSxV1dCO/kZ4bufnRKUE6WGWOl25/aOE6htUsPwETKmCdtDT3NDzStqqhnFCl3QcKmvAncSoyR79WvyAb2W06G1t7vFx58H+NPa+QjL7NUE7yuwJd3MgdC9vtMeQOddq0Lh0KWHBWjb1lQv8SJ4mcH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KY5VuvDM; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269772; x=1775805772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p034v+1t9zJ9E2nJhCRWSagSV/SOx27HYDYAI/C9kig=;
  b=KY5VuvDM9v+MSlYfNVAIpvRvV+0t1RgnddsbEBHK051KHYmAudpaZtz0
   N5VPvS53+SrhQV01iQjYVXB8QSVKf70sMVH5KfNY/97M/CO0ttP3VzFX7
   WfTM0dP2G8mf9YXYskX3AhhzI/SCDL1S7lh9FuzDplmobfrYThLzx4YKt
   HCZ7qGQgoANcT6NYqSQremEpOzckC+kSKuvOsVQkyffD4Nx6NPJHwugrr
   DZhYSg2Qw51Sq46Mxoby4vEkcqQrEKvRMVBJyXtXsIOS3ElPG65ZqnPbn
   cQilBHnsfP1+wlM0ofsQNeW3X2QcrvS4U6VWLNUjihO6qiAAsg9juVjj4
   w==;
X-CSE-ConnectionGUID: 68rVIDbuSyGye04BLlXz2A==
X-CSE-MsgGUID: e5mpBPSNSOmIVzsaQ891Qw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56439375"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56439375"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:51 -0700
X-CSE-ConnectionGUID: 6HaV4cmbSLqskdeR6/Bshw==
X-CSE-MsgGUID: bzhfP9EGSIaZkl/QetYqvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128778193"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:47 -0700
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
	Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>
Subject: [PATCH v5 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo container from guest defaults
Date: Thu, 10 Apr 2025 15:24:45 +0800
Message-ID: <20250410072605.2358393-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250410072605.2358393-1-chao.gao@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fpu_alloc_guest_fpstate() currently uses host defaults to initialize guest
fpstate and pseudo containers. Guest defaults were introduced to
differentiate the features and sizes of host and guest FPUs. Switch to
using guest defaults instead.

Additionally, incorporate the initialization of indicators (is_valloc and
is_guest) into the newly added guest-specific reset function to centralize
the resetting of guest fpstate.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v5: init is_valloc/is_guest in the guest-specific reset function (Chang)
---
 arch/x86/kernel/fpu/core.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index e23e435b85c4..f5593f6009a4 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -201,7 +201,20 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
+static void __guest_fpstate_reset(struct fpstate *fpstate, u64 xfd)
+{
+	/* Initialize sizes and feature masks */
+	fpstate->size		= guest_default_cfg.size;
+	fpstate->user_size	= guest_default_cfg.user_size;
+	fpstate->xfeatures	= guest_default_cfg.features;
+	fpstate->user_xfeatures	= guest_default_cfg.user_features;
+	fpstate->xfd		= xfd;
+
+	/* Initialize indicators to reflect properties of the fpstate */
+	fpstate->is_valloc	= true;
+	fpstate->is_guest	= true;
+}
+
 
 static void fpu_lock_guest_permissions(void)
 {
@@ -226,19 +239,18 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = guest_default_cfg.size + ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
 
 	/* Leave xfd to 0 (the reset value defined by spec) */
-	__fpstate_reset(fpstate, 0);
+	__guest_fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
-	fpstate->is_valloc	= true;
-	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
+	gfpu->xfeatures		= guest_default_cfg.features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -250,8 +262,8 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	 * all features that can expand the uABI size must be opt-in.
 	 */
 	gfpu->uabi_size		= sizeof(struct kvm_xsave);
-	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
-		gfpu->uabi_size = fpu_user_cfg.default_size;
+	if (WARN_ON_ONCE(guest_default_cfg.user_size > gfpu->uabi_size))
+		gfpu->uabi_size = guest_default_cfg.user_size;
 
 	fpu_lock_guest_permissions();
 
-- 
2.46.1


