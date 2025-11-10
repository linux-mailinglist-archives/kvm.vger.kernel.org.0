Return-Path: <kvm+bounces-62554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8253DC488CE
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:28:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 846281888309
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347EC32B9B3;
	Mon, 10 Nov 2025 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qqd9c6P3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDF133030E;
	Mon, 10 Nov 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799081; cv=none; b=jGpqc9DhTtMSwpC2fbxgcgnibbtc/u1tmAqD1gPBZMFIWhrXl/0COnAmnnbL5i0Ccw2cIIugITDXr2FKPrimHJ2J9XCNjLEs2f0wsC2gjOEn826mzKb6NgtVtE0PPFvh6HDkhqJEAXApCYenZudAwECPoSh/Jry+9BY4WgXDS+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799081; c=relaxed/simple;
	bh=fjLFINRg3/6z0R1dBo+yQCUsxeF40Dkx+1fVSpT0dC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HeI7HNrpwwqA+VZkLyx7WPovwlgGRJF8WyiRlYknbszFU/gtjXXZxFZTubbyw9Uq4xAHCHUKM3JM+wCWizMTkklpmNi6GTFlenaUtW5PvtX2yH/X7aeEqbY3aaRK5eUmhYGrtOQX172SHnl3oozfDwmKXoJUrj2NmrZu4T8e3U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qqd9c6P3; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799080; x=1794335080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fjLFINRg3/6z0R1dBo+yQCUsxeF40Dkx+1fVSpT0dC8=;
  b=Qqd9c6P3uCqln1UVXNAG/i6o279qN1niEQJYIRx+gm9QJjJ3eOSP4IcP
   blpkXhjqevTLGH71xS2BJ692JyK+ekPJI3N1BbDaBbSXtAtX78mQuP8fK
   /8G0bvC8Xq1Z1K713LUN/DesFMj2KEGGtSjfJMcPPeku3lHCQrQ0Ck1bA
   26B4kNvm8GzrKkETjvoWPBivU8r5UImOr3AzdohKvaiFYRgkjsBuuGQU5
   oOYAnw78IbPj2D99Yg6i1hXp4isH2/e0RIlBnLYh5o+bagl/+jLL8Kx9g
   s+EdW3vbfET0A8RH4uLkIsJpcsjyYrIoqYwTDnzx0OdNXbp+xuwKxntK1
   Q==;
X-CSE-ConnectionGUID: qNz2oky5Rb2eLuKM1W12Xg==
X-CSE-MsgGUID: k+XIwtcLR/SnT52/RkkVdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305486"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305486"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:40 -0800
X-CSE-ConnectionGUID: IEzSgS/MSiKbfjVP7N8umw==
X-CSE-MsgGUID: GqXqhK1HQSOZv9GaxwatSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396076"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:40 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 03/20] KVM: x86: Implement accessors for extended GPRs
Date: Mon, 10 Nov 2025 18:01:14 +0000
Message-ID: <20251110180131.28264-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add helpers to directly read and write EGPRs (R16–R31).

Unlike legacy GPRs, EGPRs are not cached in vcpu->arch.regs[]. Their
contents remain live in hardware. If preempted, the EGPR state is
preserved in the guest XSAVE buffer.

The Advanced Performance Extentions (APX) feature introduces EGPRs as an
XSAVE-managed state component. The new helpers access the registers
directly between kvm_fpu_get() and kvm_fpu_put().

Callers should ensure that EGPRs are enabled before using these helpers.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
RFC note:
There may be alternative options for EGPR access. If the EGPR state is
saved in the guest fpstate, KVM could read or write it there instead.
However, since EGPR-related VM exits are expected to be rare, adding
extra complexity and overhead at this stage doesn’t seem worthwhile.
---
 arch/x86/kvm/fpu.h | 80 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
index 159239b3a651..aa35bdf1a073 100644
--- a/arch/x86/kvm/fpu.h
+++ b/arch/x86/kvm/fpu.h
@@ -96,6 +96,61 @@ static inline void _kvm_write_mmx_reg(int reg, const u64 *data)
 	}
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * Accessors for extended general-purpose registers. binutils >= 2.43 can
+ * recognize those register symbols.
+ */
+
+static inline void _kvm_read_egpr(int reg, unsigned long *data)
+{
+	/* mov %r16..%r31, %rax */
+	switch (reg) {
+	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x48, 0x89, 0xc0" : "=a"(*data)); break;
+	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x48, 0x89, 0xc8" : "=a"(*data)); break;
+	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x48, 0x89, 0xd0" : "=a"(*data)); break;
+	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x48, 0x89, 0xd8" : "=a"(*data)); break;
+	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x48, 0x89, 0xe0" : "=a"(*data)); break;
+	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x48, 0x89, 0xe8" : "=a"(*data)); break;
+	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x48, 0x89, 0xf0" : "=a"(*data)); break;
+	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x48, 0x89, 0xf8" : "=a"(*data)); break;
+	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x4c, 0x89, 0xc0" : "=a"(*data)); break;
+	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x4c, 0x89, 0xc8" : "=a"(*data)); break;
+	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x4c, 0x89, 0xd0" : "=a"(*data)); break;
+	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x4c, 0x89, 0xd8" : "=a"(*data)); break;
+	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x4c, 0x89, 0xe0" : "=a"(*data)); break;
+	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x4c, 0x89, 0xe8" : "=a"(*data)); break;
+	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x4c, 0x89, 0xf0" : "=a"(*data)); break;
+	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x4c, 0x89, 0xf8" : "=a"(*data)); break;
+	default: BUG();
+	}
+}
+
+static inline void _kvm_write_egpr(int reg, unsigned long *data)
+{
+	/* mov %rax, %r16...%r31*/
+	switch (reg) {
+	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x18, 0x89, 0xc0" : : "a"(*data)); break;
+	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x18, 0x89, 0xc1" : : "a"(*data)); break;
+	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x18, 0x89, 0xc2" : : "a"(*data)); break;
+	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x18, 0x89, 0xc3" : : "a"(*data)); break;
+	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x18, 0x89, 0xc4" : : "a"(*data)); break;
+	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x18, 0x89, 0xc5" : : "a"(*data)); break;
+	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x18, 0x89, 0xc6" : : "a"(*data)); break;
+	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x18, 0x89, 0xc7" : : "a"(*data)); break;
+	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x19, 0x89, 0xc0" : : "a"(*data)); break;
+	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x19, 0x89, 0xc1" : : "a"(*data)); break;
+	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x19, 0x89, 0xc2" : : "a"(*data)); break;
+	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x19, 0x89, 0xc3" : : "a"(*data)); break;
+	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x19, 0x89, 0xc4" : : "a"(*data)); break;
+	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x19, 0x89, 0xc5" : : "a"(*data)); break;
+	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x19, 0x89, 0xc6" : : "a"(*data)); break;
+	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x19, 0x89, 0xc7" : : "a"(*data)); break;
+	default: BUG();
+	}
+}
+#endif
+
 static inline void kvm_fpu_get(void)
 {
 	fpregs_lock();
@@ -139,8 +194,29 @@ static inline void kvm_write_mmx_reg(int reg, const u64 *data)
 }
 
 #ifdef CONFIG_X86_64
-static inline unsigned long kvm_read_egpr(int reg) { return 0; }
-static inline void kvm_write_egpr(int reg, unsigned long data) { }
+static inline unsigned long kvm_read_egpr(int reg)
+{
+	unsigned long data;
+
+	if (WARN_ON_ONCE(!cpu_has_xfeatures(XFEATURE_MASK_APX, NULL)))
+		return 0;
+
+	kvm_fpu_get();
+	_kvm_read_egpr(reg, &data);
+	kvm_fpu_put();
+
+	return data;
+}
+
+static inline void kvm_write_egpr(int reg, unsigned long data)
+{
+	if (WARN_ON_ONCE(!cpu_has_xfeatures(XFEATURE_MASK_APX, NULL)))
+		return;
+
+	kvm_fpu_get();
+	_kvm_write_egpr(reg, &data);
+	kvm_fpu_put();
+}
 #endif
 
 #endif
-- 
2.51.0


