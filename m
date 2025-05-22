Return-Path: <kvm+bounces-47386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C311BAC0F94
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 142E13AE7F6
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07322290D94;
	Thu, 22 May 2025 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HWqfMNkF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60178290084;
	Thu, 22 May 2025 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926645; cv=none; b=Xd3nYD8nol4FvBPDQe1PmClChOR17XcQYoPtgJti8Cj7cFRRq9xS78y3RDam4lv+y6SJhwW05XG7U3rpn+2/ypXipPNLPooIfz5dPE/T1lrV4xxzd50UXYFor2/MrX2VP39NyE69MoIcHpHT5vr4/YQRS4dkKIW82KwN84XB/N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926645; c=relaxed/simple;
	bh=eG+KJqqkLw9r1X37MDRI4p4ccnsKsfZJelX5Mvc6CJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiMMsETNRCMFQajDatIRczS/0o2vygRHBNiKoVQSXW/sNiguCiLAhq/HPa77SCFZP1nTyUxWnjpeCehnSs5zQIpscDJfux3a/DoWObgr08aNudekqFcGYjQDkQmBxrR6VbpVJi6T49h0hbx/y3WV5eNHjhG/k9IOhf4teaVsYW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HWqfMNkF; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747926644; x=1779462644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eG+KJqqkLw9r1X37MDRI4p4ccnsKsfZJelX5Mvc6CJI=;
  b=HWqfMNkFfEYZ0KrGKBhwLbtSOw35d74jxAdeBwe3Xdua6fewRneoBWvl
   B/OzQhjEJwvEE+RB+XlCDKTMf3BqUYv4RmBuL4+3Sm/+kPCG+o+kS7n4I
   sp32UeosPH8dhqBVINvqOs4jaaNvvwSeS/AqrzsCH+2UFqk1wa6gnKkRL
   EnCr4gB1cw7G2xFVDTWYiC3YPbXM40V95lm2W+SXjA6BrzZ2GVpmnyhWB
   ZWhImHi/bSfh3XztBXhfGN9cVLoXls71F/X+zwq2bmR3EGUqEfNTkfKTF
   j8nGgzXuagmMCv1cO630MGWloAeZaMtBE77G+vpIEqQm4wPkf5wOMRgH1
   A==;
X-CSE-ConnectionGUID: ZVDRRqNWQGKXtZ67LsoOGw==
X-CSE-MsgGUID: SwhzMhmNRN6Pot9CheY1AA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61006695"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="61006695"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:43 -0700
X-CSE-ConnectionGUID: CbuX69k5Qdiwq41+eLo90Q==
X-CSE-MsgGUID: 2izaZVaOTuWNkr22pvtU+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171627622"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:42 -0700
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
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v8 4/6] x86/fpu: Remove xfd argument from __fpstate_reset()
Date: Thu, 22 May 2025 08:10:07 -0700
Message-ID: <20250522151031.426788-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250522151031.426788-1-chao.gao@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
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
v8: tweak comment in __fpstate_reset() (Sean)
v7: new
---
 arch/x86/kernel/fpu/core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a5a9c55fcf83..4fafb27e9416 100644
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
 	 * Supervisor features (and thus sizes) may diverge between guest
@@ -544,25 +543,29 @@ static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 	 * for guests despite not being utilized by the host. User
 	 * features and sizes are always identical, which allows for
 	 * common guest and userspace ABI.
+	 *
+	 * For the host, set XFD to the kernel's desired initialization
+	 * value. For guests, set XFD to its architectural RESET value.
 	 */
 	if (fpstate->is_guest) {
 		fpstate->size		= guest_default_cfg.size;
 		fpstate->xfeatures	= guest_default_cfg.features;
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


