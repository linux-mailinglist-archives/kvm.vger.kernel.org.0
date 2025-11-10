Return-Path: <kvm+bounces-62560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA9FC488F6
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8DA33A5E74
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE4732B980;
	Mon, 10 Nov 2025 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxE3HAFE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF72A333753;
	Mon, 10 Nov 2025 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799093; cv=none; b=E4VXrOs9/DMsgzJlz2ENR0inruBSNAFjNGax+d7t+JHmBxzyJHqmIaoRM7aqk3EZS8rtndr+ZGXqdqxgwLnPia2hxnf+PROc0V7B5HXKz2EuBFMwwlgtZAybGJTsW+GsXDqcGW6vFzpyoIqjkXe76N1dp0LSuyNLFRyPehiw3E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799093; c=relaxed/simple;
	bh=HiQEVHuWFzVpNQ0uf8gl/Zy8oB0Q8AomnhA0WkRcPck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVGFHhjaVN4VX+UVOjd42fbNgPqOMem/MJ5m6elo0dUPIaMdTFD3nHRYhb5Nrx+HFmT3PHQLV6tnnuTwgY5kJOLFUC2htQypnmpIQ1dDgiKN4Lv7kpvYiiVrcOIil60zKoYSkkWp73VetJqcSghyVi9WsoGD6urTzz1xkRF38yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxE3HAFE; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799092; x=1794335092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HiQEVHuWFzVpNQ0uf8gl/Zy8oB0Q8AomnhA0WkRcPck=;
  b=NxE3HAFEmos54iI08O6jqktVOyKwr7mKrUrp70MKpH9y2MEZIzSm92nm
   BC3qYogQ1YwNcnM+mtA0hsdLZWcpksDu5a9TJiagHF5IKgt/Vs7wxUQ+X
   uouSIyZr0V+0vCuwnLopHuke7quCRNiEPFMbTWFYW9nnbjgZcwm9auuGm
   W4/LVkiQ+at5TAgPbk7UEkAMDDqQknFTpz75dE6Ckh9nyJh1jObcuzzUX
   zBIbddxl0J6SFxVE1y0yxhebPWMhp89ariuc0M5+v8k4hINcG1mRHLE0x
   Jy3MPfVO24q7PWFjskclNh5gxmdB57OR80op4IT5On49LwSmRqMn9x8bv
   g==;
X-CSE-ConnectionGUID: MDjPeIv3S7eePEYBiqjcTQ==
X-CSE-MsgGUID: HvJzp6GyRn6KwR4DDwu5bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305506"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305506"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:51 -0800
X-CSE-ConnectionGUID: p82M8Sg3S5mI+3F3fWp6LQ==
X-CSE-MsgGUID: zVPpoz4IQs2N98b4zF4JCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396156"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:52 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 09/20] KVM: x86: Support EGPR accessing and tracking for instruction emulation
Date: Mon, 10 Nov 2025 18:01:20 +0000
Message-ID: <20251110180131.28264-10-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the emulator context and GPR accessors to handle EGPRs before
adding support for REX2-prefixed instructions.

Now the KVM GPR accessors can handle EGPRs. Then, the emulator can
uniformly cache and track all GPRs without requiring separate handling.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/kvm_emulate.h | 10 +++++-----
 arch/x86/kvm/x86.c         |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 7b5ddb787a25..153c70ea5561 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -105,13 +105,13 @@ struct x86_instruction_info {
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
 	/*
-	 * read_gpr: read a general purpose register (rax - r15)
+	 * read_gpr: read a general purpose register (rax - r31)
 	 *
 	 * @reg: gpr number.
 	 */
 	ulong (*read_gpr)(struct x86_emulate_ctxt *ctxt, unsigned reg);
 	/*
-	 * write_gpr: write a general purpose register (rax - r15)
+	 * write_gpr: write a general purpose register (rax - r31)
 	 *
 	 * @reg: gpr number.
 	 * @val: value to write.
@@ -312,7 +312,7 @@ typedef void (*fastop_t)(struct fastop *);
  * a ModRM or SIB byte.
  */
 #ifdef CONFIG_X86_64
-#define NR_EMULATOR_GPRS	16
+#define NR_EMULATOR_GPRS	32
 #else
 #define NR_EMULATOR_GPRS	8
 #endif
@@ -361,9 +361,9 @@ struct x86_emulate_ctxt {
 	u8 lock_prefix;
 	u8 rep_prefix;
 	/* bitmaps of registers in _regs[] that can be read */
-	u16 regs_valid;
+	u32 regs_valid;
 	/* bitmaps of registers in _regs[] that have been written */
-	u16 regs_dirty;
+	u32 regs_dirty;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 603057ea7421..338986a5a3ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8812,12 +8812,12 @@ static bool emulator_guest_cpuid_is_intel_compatible(struct x86_emulate_ctxt *ct
 
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
-	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
+	return _kvm_gpr_read(emul_to_vcpu(ctxt), reg);
 }
 
 static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulong val)
 {
-	kvm_register_write_raw(emul_to_vcpu(ctxt), reg, val);
+	_kvm_gpr_write(emul_to_vcpu(ctxt), reg, val);
 }
 
 static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
-- 
2.51.0


