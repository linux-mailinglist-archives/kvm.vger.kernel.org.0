Return-Path: <kvm+bounces-66451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E628DCD3BA0
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D36453012CF0
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF69A224B04;
	Sun, 21 Dec 2025 04:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y9hDCVJh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B242B225779;
	Sun, 21 Dec 2025 04:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291505; cv=none; b=d3PIyvk76Z6r1fl8wiA323xIDFgEOCbZ+NAwNUsdSWptxY38z7HlbOFkr3CDhVCmR+bsgATK5piA0mqhcHSpTablur0wOlg4+8ocpKu5+x/nKJzhbUQc4jlfQLrUwix9f/aU73GgBcnXS/dmzM4D0kV8dn6wfaXKheoTKEZ2c4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291505; c=relaxed/simple;
	bh=zkoXqskiBbDIfaa1XN7EYMIqCDWEv3YgveEwuaplNM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS5bQG2NvWfvx7yjlUAsKxqBGZ0lThyEX26yvHrXX5bJy/WOyxUKjwBhB4q50S8hTHzSdwtf9KjTftHCQmZrFZznsbZS7L1EUQKyptGN9lAMZSxztcCOCBX9AAceXo9ImrhccemP+OABzYqURE/v7wBVWYDUer0G0KSCEUYYLn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y9hDCVJh; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291503; x=1797827503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zkoXqskiBbDIfaa1XN7EYMIqCDWEv3YgveEwuaplNM0=;
  b=Y9hDCVJhstpzDB9IrN6gq8igq01dIMotPFOhO2YfYzdtaiireigRBzzr
   Z6c1Ld5EdlNh9caUoiBmrnvgKIUMmB5SL1OyowtBA6nF5SCV4KjGRb01B
   CEiDuvLzYtddDFbNNMS8CQ6xGsWxe7YrHILaf7b8bo0poDhv2mRu5XF+E
   f7B36Kg50eBf/lwav/XXf4Y9Osfl/TE0Du/QY0l+BSL2sjzxc4dFI7Bs6
   zHGOniO/6w6+uIIJTWRaFwzy7nA2rw6A6vwKkY7wAw+4+8pGGvVUscdE9
   Uoh+MNpdCBAKPY0AE8vefKFON7UiyBprBA7Sy89N1l9WZj9hwRH0+lm4B
   A==;
X-CSE-ConnectionGUID: kTJWFfMWRCm9b/xKSasTUA==
X-CSE-MsgGUID: 9whfn61wSgCr0n04ACya3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132412"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132412"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:43 -0800
X-CSE-ConnectionGUID: iqL5rOvJSt2wn3gJE5Q5cA==
X-CSE-MsgGUID: 2IWu/6pxQWeOYxN1+/XrLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885010"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:43 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 09/16] KVM: emulate: Support EGPR accessing and tracking
Date: Sun, 21 Dec 2025 04:07:35 +0000
Message-ID: <20251221040742.29749-10-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
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
No change since last version
---
 arch/x86/kvm/kvm_emulate.h | 10 +++++-----
 arch/x86/kvm/x86.c         |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index fb3dab4b5a53..16b35a796a7f 100644
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
@@ -314,7 +314,7 @@ typedef void (*fastop_t)(struct fastop *);
  * a ModRM or SIB byte.
  */
 #ifdef CONFIG_X86_64
-#define NR_EMULATOR_GPRS	16
+#define NR_EMULATOR_GPRS	32
 #else
 #define NR_EMULATOR_GPRS	8
 #endif
@@ -373,9 +373,9 @@ struct x86_emulate_ctxt {
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
index 819986edb79c..abbc9b8736e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8817,12 +8817,12 @@ static bool emulator_guest_cpuid_is_intel_compatible(struct x86_emulate_ctxt *ct
 
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
-	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
+	return kvm_gpr_read_raw(emul_to_vcpu(ctxt), reg);
 }
 
 static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulong val)
 {
-	kvm_register_write_raw(emul_to_vcpu(ctxt), reg, val);
+	kvm_gpr_write_raw(emul_to_vcpu(ctxt), reg, val);
 }
 
 static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
-- 
2.51.0


