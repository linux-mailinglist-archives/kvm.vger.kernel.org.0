Return-Path: <kvm+bounces-45574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 821B7AABFA6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 662D83A997B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87FE2701B4;
	Tue,  6 May 2025 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e6C5mmMU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3713C26E142;
	Tue,  6 May 2025 09:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746523982; cv=none; b=jof4f7wC9EgGvhpN4+GxxQrIPhqSVCH+vA9lkxi0z1AxUJXnsDGkKeBsTMGlYinp/yn1sa8OfCCR6c3mFqU4v2smhGeX9e3SfYMb6A4brbObn8UxwplNnvtq61HvcMdbiEmrPC4UU4YO4HD19BWzhebPEpOq/FyOWe4KlQnpcWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746523982; c=relaxed/simple;
	bh=v97KT5/j2pfpiWLx/oLtXHSYW8lxzUooMXnpzGxiFEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdujxcIOjnjlZdK4Rmmehsz5+YqBWPXVwRcb01HZbKAq2cCsFslpzD4L9QbBHehzoLQdIvzyURrBWZ7AB6QHvP4ezklr3aJQ25k46/P7PS/ZdNmdqbgo6fpeaN62zBSyL+Oz0c1Ao635pwA/ebKTRlXrIux3+XkAKtzZgQeAs7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e6C5mmMU; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746523976; x=1778059976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v97KT5/j2pfpiWLx/oLtXHSYW8lxzUooMXnpzGxiFEk=;
  b=e6C5mmMUXMq1LhzVX1O/I9GaAIiCRC6luuz6RHkYP4zO8u06C2d7cnL6
   O91XDcgU4mBCmA6NVkfQhtv5q3hwSVveT/2pPZcG18PA7tgHdrgbNLu2H
   kL7qkzi7Fv7SF8N1A8xgt1W885m+NWZdS0SGBXuXbALkBEvyvb6DETBHL
   RxsRBuPBYM4U8Xna8vOZl6vjCh9dQr2Zw/H9XoHBXRWLIHY4jXjUOgIyj
   pu0naVCzl3oMesjndSXg1uMFW77rj7VeP7cOTfTtPAvuUkQAXVSzzNmKb
   y/VAc84GmFMWQn/AJFDG4Hz9PD663ktx5vVhyf+jKqMmkriWi3JL4Rc3o
   g==;
X-CSE-ConnectionGUID: AzshAeOMSjaXVPlbzQw79w==
X-CSE-MsgGUID: JXwHt2i6TAGvCS/O5Kyv9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="35800355"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="35800355"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:32:55 -0700
X-CSE-ConnectionGUID: CPcbPA53R9m9DjhM9G/Caw==
X-CSE-MsgGUID: CsbqdWq9QHem4RmlzjLYKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135446809"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 02:32:50 -0700
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
	Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Kees Cook <kees@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH v6 2/7] x86/fpu: Drop @perm from guest pseudo FPU container
Date: Tue,  6 May 2025 17:36:07 +0800
Message-ID: <20250506093740.2864458-3-chao.gao@intel.com>
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

Remove @perm from the guest pseudo FPU container. The field is
initialized during allocation and never used later.

Rename fpu_init_guest_permissions() to show that its sole purpose is to
lock down guest permissions.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>
Link: https://lore.kernel.org/kvm/af972fe5981b9e7101b64de43c7be0a8cc165323.camel@redhat.com/
---
v6: add Chang's Reviewed-by
v5: drop the useless fpu_guest argument (Chang)
---
 arch/x86/include/asm/fpu/types.h | 7 -------
 arch/x86/kernel/fpu/core.c       | 7 ++-----
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index e64db0eb9d27..1c94121acd3d 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -535,13 +535,6 @@ struct fpu_guest {
 	 */
 	u64				xfeatures;
 
-	/*
-	 * @perm:			xfeature bitmap of features which are
-	 *				permitted to be enabled for the guest
-	 *				vCPU.
-	 */
-	u64				perm;
-
 	/*
 	 * @xfd_err:			Save the guest value.
 	 */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 105b1b80d88d..1cda5b78540b 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -212,7 +212,7 @@ void fpu_reset_from_exception_fixup(void)
 #if IS_ENABLED(CONFIG_KVM)
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
 
-static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
+static void fpu_lock_guest_permissions(void)
 {
 	struct fpu_state_perm *fpuperm;
 	u64 perm;
@@ -228,8 +228,6 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 	WRITE_ONCE(fpuperm->__state_perm, perm | FPU_GUEST_PERM_LOCKED);
 
 	spin_unlock_irq(&current->sighand->siglock);
-
-	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
 }
 
 bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
@@ -250,7 +248,6 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
-	gfpu->perm		= fpu_kernel_cfg.default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -265,7 +262,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
 		gfpu->uabi_size = fpu_user_cfg.default_size;
 
-	fpu_init_guest_permissions(gfpu);
+	fpu_lock_guest_permissions();
 
 	return true;
 }
-- 
2.47.1


