Return-Path: <kvm+bounces-45577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF862AABFA7
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 081FB1C2095E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC91827814F;
	Tue,  6 May 2025 09:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N/0jsDJc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EA02749F0;
	Tue,  6 May 2025 09:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524005; cv=none; b=FOAY9ZBHN/RYlwSHayBM8lhkSGCB81cJgq3b4URQSRfaBHPsVSszf+MaK4ampJ/EtmxvaIcE4pQv6pNsbuZc77UyhGc7oKI420nJ8s+EnWSmg18Asg0SUSTEdU7zkhUeVBIOkgfqe8VUcginASzE1wwR6v1SxOKliKmHwTGBWGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524005; c=relaxed/simple;
	bh=BPrGGwjOrkImv/qMfv3zpJkzr5Dwg04/sd+pRnWHH68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkybRA0XPeRAVuATzGNRwfKRJ4RuEc7hG4IxESauXYBjB3BwdU8RHeIidPLa/H03n/tFYgseyIDKCVuuldvPzdxi5H+dr8BmJ+dv/jjUbU5Rv/38EyVj9Trk6pHWM6W7gxL/S014TXpxxVOuCx3jKUyoTi8J8FRQJftcFs3PAFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N/0jsDJc; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746524004; x=1778060004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BPrGGwjOrkImv/qMfv3zpJkzr5Dwg04/sd+pRnWHH68=;
  b=N/0jsDJcujhml9cLue6fAoo3HJ0RyZZUXwkiI+PIJ2/9H51YzRUSN6bq
   WXIXnGu/o04pzAEwrWoKxiNf6qsQPAleWiR7tt4STUIvXu6jlLr2X+mWv
   CbmkK3rSQ/YQtGUPWhbyhis4qjgb0hROxNYCmZnOOKwl54Q07h72CnZ32
   n3aOmoPD8wjloSi6rsxukGUV+HaBb1SSmac9K78rW7XfXAamzk0qOip1b
   f4awAIJv0FdoeRIoOgpoZIzbIw6kTevrxbcPadoN3gRZZ0dkxEpCHRNAQ
   ttmNiXI2l23ZaEpXvXv/EPEVxNpkVT70Yyfp2s864N8TQsDX96UQEaQi7
   A==;
X-CSE-ConnectionGUID: lQPjCVDeQHWbyHXnFC1RkQ==
X-CSE-MsgGUID: SSzA7qj9T2ebFQ8a1kQalw==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="35800425"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="35800425"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:23 -0700
X-CSE-ConnectionGUID: FGUguBdnRWegKEMUuTANVg==
X-CSE-MsgGUID: /uhV684KSCaVMHWGkV3uiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135446957"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:33:19 -0700
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
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v6 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo container from guest defaults
Date: Tue,  6 May 2025 17:36:10 +0800
Message-ID: <20250506093740.2864458-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250506093740.2864458-1-chao.gao@intel.com>
References: <20250506093740.2864458-1-chao.gao@intel.com>
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
v6: Drop vcpu_fpu_config.user_* (Rick)
v5: init is_valloc/is_guest in the guest-specific reset function (Chang)
---
 arch/x86/kernel/fpu/core.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 444e517a8648..78a9c809dfad 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -211,7 +211,24 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
+static void __guest_fpstate_reset(struct fpstate *fpstate, u64 xfd)
+{
+	/*
+	 * Initialize sizes and feature masks. Supervisor features and
+	 * sizes may diverge between guest FPUs and host FPUs, whereas
+	 * user features and sizes remain the same.
+	 */
+	fpstate->size		= guest_default_cfg.size;
+	fpstate->xfeatures	= guest_default_cfg.features;
+	fpstate->user_size	= fpu_user_cfg.default_size;
+	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
+	fpstate->xfd		= xfd;
+
+	/* Initialize indicators to reflect properties of the fpstate */
+	fpstate->is_valloc	= true;
+	fpstate->is_guest	= true;
+}
+
 
 static void fpu_lock_guest_permissions(void)
 {
@@ -236,19 +253,18 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
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
-- 
2.47.1


