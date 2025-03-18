Return-Path: <kvm+bounces-41388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1693A677D6
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:31:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D493F17E18D
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2EB20FAB1;
	Tue, 18 Mar 2025 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UDk/OqQG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF020E6E4;
	Tue, 18 Mar 2025 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311837; cv=none; b=UOdZkMvx6c6FkLUZhISYtBFi/Q4IkYDMLBUOv8I9d/8MQlZHfJdmEoSxpeQJJoo/He6Ltkz983i00tJLDh/KEl1QXFxyvPeUwbQQbcj+4Mdul+BBEVpF2xNgH6nnrO9JHmM+FQ6Z3wbBTxWKgO6ybNFdKboMD1j3h+VpVuciJC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311837; c=relaxed/simple;
	bh=9HeHdk992vPt0k3jgDoyiyk9O7G3efAu3/tJ/3loWmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvrqaci3ldrBhsf7Sd4VKVVpQ1dSL7BnXyQywbnJhnot5IUeKkkNSyp05x3vvg4Sbi3FZ70dEpfKrAYmrUN0EO24tUbjPWzfnTkn7fjDwo6xReJJNmoYixXBHDNU2EZ/jPOGjbHSvcN2luUfCPpDYqjPBbejYjo/oZCMPPdyqsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UDk/OqQG; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311835; x=1773847835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9HeHdk992vPt0k3jgDoyiyk9O7G3efAu3/tJ/3loWmI=;
  b=UDk/OqQGbQylWbtS5XbooU+jsbeEA7j+/k067vDoGodGMysIkJDQ98EX
   MdDYiGRG1GG13O9bUM5F2zUcWGtPcJsIa4wColfRwnQGLgLeYJPcyXGCl
   ewTchLtSEcUA/Crv31G7bHUFZTVU79N2y7/Uael+OI4opn12p7Xvk8Vce
   K1l8TIPFKmX3bodLkrfma5XTQMXE2OB9v4nOcPS/316hycW298Wf2ekCq
   RQvdRJBjtAtS4Uvd/we10ySnpMHSWRv6TGqx8IP+E8l7Ck64NIUH1cXHc
   eQbY+ltOs+KSvLqP+RSw67ZBVZ7e5FzNBaJcBP+fnPXKkyQrJKKx+x4X0
   w==;
X-CSE-ConnectionGUID: ceq/4xl3RKeeQbhyOEWqlg==
X-CSE-MsgGUID: gwCKpnMySZuuZSQ6+pPBcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="46224150"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="46224150"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:35 -0700
X-CSE-ConnectionGUID: +5Kq97WORG2SE9ho5vANSQ==
X-CSE-MsgGUID: DWmk5wYIRxOI/2Ctcjxgtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122121838"
Received: from spr.sh.intel.com ([10.239.53.19])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:29 -0700
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
	Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>,
	Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v4 2/8] x86/fpu: Drop @perm from guest pseudo FPU container
Date: Tue, 18 Mar 2025 23:31:52 +0800
Message-ID: <20250318153316.1970147-3-chao.gao@intel.com>
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

Remove @perm from the guest pseudo FPU container. The field is
initialized during allocation and never used later.

Rename fpu_init_guest_permissions() to show that its sole purpose is to
lock down guest permissions.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/fpu/types.h | 7 -------
 arch/x86/kernel/fpu/core.c       | 7 ++-----
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 46cc263f9f4f..9f9ed406b179 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -526,13 +526,6 @@ struct fpu_guest {
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
index 1b734a9ff088..0b695c23bbfb 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -202,7 +202,7 @@ void fpu_reset_from_exception_fixup(void)
 #if IS_ENABLED(CONFIG_KVM)
 static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
 
-static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
+static void fpu_lock_guest_permissions(struct fpu_guest *gfpu)
 {
 	struct fpu_state_perm *fpuperm;
 	u64 perm;
@@ -218,8 +218,6 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 	WRITE_ONCE(fpuperm->__state_perm, perm | FPU_GUEST_PERM_LOCKED);
 
 	spin_unlock_irq(&current->sighand->siglock);
-
-	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
 }
 
 bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
@@ -240,7 +238,6 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
-	gfpu->perm		= fpu_kernel_cfg.default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
@@ -255,7 +252,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
 		gfpu->uabi_size = fpu_user_cfg.default_size;
 
-	fpu_init_guest_permissions(gfpu);
+	fpu_lock_guest_permissions(gfpu);
 
 	return true;
 }
-- 
2.46.1


