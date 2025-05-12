Return-Path: <kvm+bounces-46149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91463AB3289
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2691A7ABCCB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 08:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DB7265CCD;
	Mon, 12 May 2025 08:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lvf6rR2/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2DE25C828;
	Mon, 12 May 2025 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747040268; cv=none; b=Xsk831mssOtSw5w29kHccfAbQjljKGxt4QNhdSSqNqkdv6KyJ9YR7d48ZbWTYT4UjGjrmyhOrgiUWOz2io9P2/Lxvbi2GdSbd+59NnhnZRqPjHhjLK4DDBEMOH8AFVh3nSP9Vh7ntnc0f+cVB2tXvvh1j2gi8wYhxbMDNtQyd6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747040268; c=relaxed/simple;
	bh=jc52Pr0csP5dB1yXbUo7PLFxgai0G9NfQ4qQyHUvsJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqnZCCTR1iACsmq9wYagXF687G3ZHHdRaLmaV5EqbSx+YcEZfoy5kv/7wLCz6MQBiSPqnbB929v2VxSwMmP6oORSL/8JRDHx9kYSFxwmNss7uZn49FhmOsG1uIoWdtTH+3Dc9nzkAPeabsqsvOxg74mUPzIAuG8Fl2kVl4fGGMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lvf6rR2/; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747040266; x=1778576266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jc52Pr0csP5dB1yXbUo7PLFxgai0G9NfQ4qQyHUvsJ4=;
  b=Lvf6rR2/GTtBWVJFlT1kRvq4CbDHyHycmJ9tc0L47GFSnY40hWICohV6
   IMNj9X98QC20hr7tcvoeNCgvu9xaVdBHhuuos9v2wrEAaGhtq5g78WUiS
   lmkmNGY3oXBrrlueRBMEAZ62uMRHbA5z0HLZ9nqewdtbXxDE25E+/2wNk
   b8PObBIzObIB1SHQhfDGgTUUWBcmG66V8Kom6YE8QUwDO5Hs/bIxbS8cV
   5Ib7+n1IhKjPgdkBxBvdX0EcWoAjULLTfZN7BzIbJJSgFC+jWf55rUGW9
   IRp0ITMRgA30gHL5UKrSSa/epYgKZaGhUpZeNxolVBVkCmwzuHGomh556
   Q==;
X-CSE-ConnectionGUID: vn3yYv/vTKOSWwM4m5sK3g==
X-CSE-MsgGUID: JpW3umWYSYehHxzdrLuJFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="59488717"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="59488717"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:45 -0700
X-CSE-ConnectionGUID: XUcQzhT0QUKmxAWsNN/1eQ==
X-CSE-MsgGUID: ix0kynOpSdeg1l9tzuqNNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="138235782"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:45 -0700
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
	Kees Cook <kees@kernel.org>
Subject: [PATCH v7 3/6] x86/fpu: Initialize guest fpstate and FPU pseudo container from guest defaults
Date: Mon, 12 May 2025 01:57:06 -0700
Message-ID: <20250512085735.564475-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250512085735.564475-1-chao.gao@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
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

Adjust __fpstate_reset() to handle different defaults for host and guest
FPUs. And to distinguish between the types of FPUs, move the initialization
of indicators (is_guest and is_valloc) before the reset.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v7: tweak __fpstate_reset() instead of adding a guest-specific reset
    function (Sean/Dave)
v6: Drop vcpu_fpu_config.user_* (Rick)
v5: init is_valloc/is_guest in the guest-specific reset function
(Chang)

 arch/x86/kernel/fpu/core.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 444e517a8648..0d501bd25d79 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -236,19 +236,22 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = guest_default_cfg.size + ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
 
+	/* Initialize indicators to reflect properties of the fpstate */
+	fpstate->is_valloc	= true;
+	fpstate->is_guest	= true;
+
 	/* Leave xfd to 0 (the reset value defined by spec) */
 	__fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
-	fpstate->is_valloc	= true;
-	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
+	gfpu->xfeatures		= guest_default_cfg.features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -535,10 +538,20 @@ void fpstate_init_user(struct fpstate *fpstate)
 
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 {
-	/* Initialize sizes and feature masks */
-	fpstate->size		= fpu_kernel_cfg.default_size;
+	/*
+	 * Initialize sizes and feature masks. Supervisor features and
+	 * sizes may diverge between guest FPUs and host FPUs, whereas
+	 * user features and sizes are always identical the same.
+	 */
+	if (fpstate->is_guest) {
+		fpstate->size		= guest_default_cfg.size;
+		fpstate->xfeatures	= guest_default_cfg.features;
+	} else {
+		fpstate->size		= fpu_kernel_cfg.default_size;
+		fpstate->xfeatures	= fpu_kernel_cfg.default_features;
+	}
+
 	fpstate->user_size	= fpu_user_cfg.default_size;
-	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
 	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
 	fpstate->xfd		= xfd;
 }
-- 
2.47.1


