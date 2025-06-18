Return-Path: <kvm+bounces-49890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86AA8ADF3C0
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 19:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9CB8189F81D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 17:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F852F49E5;
	Wed, 18 Jun 2025 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="XJXpuFqU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8415C2EFDA6;
	Wed, 18 Jun 2025 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750267717; cv=none; b=oWUBfy4vw1hkOEefaQ5OJL2YDkzBKtovE81czltbJoGRdH8xc2vqdZO119MLrh4i5r3WhzAuW20yKpddr+d3XOKgZxA3KWXCc0qfHM5/FU51xJquy9Gfv8ucE9auAVrXDaVscj/ODqwbUUh2nJInPGBLjzYkLxJ159MIeCsk8+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750267717; c=relaxed/simple;
	bh=gU5oALbPhAHxT/FEkd9MpwuLT5crLhduOGGdQUyf7v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5xERCiFA6KlLJ+55Nxcnp3etgX7pKdptHLC7ZKBlIyt2yrOF2n8328MnoUSznUXjDGlvhjyJ+T9gkK9ITAZzU1MNbABzyy7M1RzE1PMUMpqj6ougzHOiUA6FH0BwEhLO/qZV4LKE4YezhyNjUWXjGCUOYowcaglLSjx+UvyloU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=XJXpuFqU; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55IHRNLJ1651479
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 18 Jun 2025 10:27:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55IHRNLJ1651479
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750267648;
	bh=aJG7IdDGnJ2q7w5OD75ffVkhOBkxJEJi/vLpbC2cvs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJXpuFqU3XKy+VjXTogeuDQ+rO2gWPp+LeL17xZ/UZXxpkIFnNMhtPh3RLEDDeZuR
	 vNkF0j2Co+UECLZkzO31Rv+4sYOrx9iZgdOyAB3uJPyCk/WCLH+xLzx0uUIvYlOJ5H
	 Q4wKFYsDfULi9XkkZIUFTxFoBSdWqmXSgWSQ3o+EDNizBVy+6AjtO+COw4896ZwbrX
	 6UtkAxNSeD5gZeGIK2XgicdY30A2DxcIc/zw7dDt2uErXq2+anVLMQ/z5+/LM+P+CO
	 LgE9EmQTJH2h4+v09YTzeBe6ytanZ/bgSJFK7uR9YOW7b6T5epcJRdgwjVen96oG51
	 AfAm4GT65UWoQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
Subject: [PATCH v3 1/2] x86/traps: Initialize DR6 by writing its architectural reset value
Date: Wed, 18 Jun 2025 10:27:22 -0700
Message-ID: <20250618172723.1651465-2-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618172723.1651465-1-xin@zytor.com>
References: <20250618172723.1651465-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialize DR6 by writing its architectural reset value to avoid
incorrectly zeroing DR6 to clear DR6.BLD at boot time, which leads
to a false bus lock detected warning.

The Intel SDM says:

  1) Certain debug exceptions may clear bits 0-3 of DR6.

  2) BLD induced #DB clears DR6.BLD and any other debug exception
     doesn't modify DR6.BLD.

  3) RTM induced #DB clears DR6.RTM and any other debug exception
     sets DR6.RTM.

  To avoid confusion in identifying debug exceptions, debug handlers
  should set DR6.BLD and DR6.RTM, and clear other DR6 bits before
  returning.

The DR6 architectural reset value 0xFFFF0FF0, already defined as
macro DR6_RESERVED, satisfies these requirements, so just use it to
reinitialize DR6 whenever needed.

Since clear_all_debug_regs() no longer zeros all debug registers,
rename it to initialize_debug_regs() to better reflect its current
behavior.

Since debug_read_clear_dr6() no longer clears DR6, rename it to
debug_read_reset_dr6() to better reflect its current behavior.

Reported-by: Sohil Mehta <sohil.mehta@intel.com>
Link: https://lore.kernel.org/lkml/06e68373-a92b-472e-8fd9-ba548119770c@intel.com/
Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Sohil Mehta <sohil.mehta@intel.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Cc: stable@vger.kernel.org
---

Changes in v3:
*) Polish initialize_debug_regs() (PeterZ).
*) Rewrite the comment for DR6_RESERVED definition (Sohil and Sean).
*) Collect TB, RB, AB (PeterZ and Sohil).

Changes in v2:
*) Use debug register index 6 rather than DR_STATUS (PeterZ and Sean).
*) Move this patch the first of the patch set to ease backporting.
---
 arch/x86/include/uapi/asm/debugreg.h | 21 ++++++++++++++++-
 arch/x86/kernel/cpu/common.c         | 24 ++++++++------------
 arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
 3 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
index 0007ba077c0c..41da492dfb01 100644
--- a/arch/x86/include/uapi/asm/debugreg.h
+++ b/arch/x86/include/uapi/asm/debugreg.h
@@ -15,7 +15,26 @@
    which debugging register was responsible for the trap.  The other bits
    are either reserved or not of interest to us. */
 
-/* Define reserved bits in DR6 which are always set to 1 */
+/*
+ * Define bits in DR6 which are set to 1 by default.
+ *
+ * This is also the DR6 architectural value following Power-up, Reset or INIT.
+ *
+ * Note, with the introduction of Bus Lock Detection (BLD) and Restricted
+ * Transactional Memory (RTM), the DR6 register has been modified:
+ *
+ * 1) BLD flag (bit 11) is no longer reserved to 1 if the CPU supports
+ *    Bus Lock Detection.  The assertion of a bus lock could clear it.
+ *
+ * 2) RTM flag (bit 16) is no longer reserved to 1 if the CPU supports
+ *    restricted transactional memory.  #DB occurred inside an RTM region
+ *    could clear it.
+ *
+ * Apparently, DR6.BLD and DR6.RTM are active low bits.
+ *
+ * As a result, DR6_RESERVED is an incorrect name now, but it is kept for
+ * compatibility.
+ */
 #define DR6_RESERVED	(0xFFFF0FF0)
 
 #define DR_TRAP0	(0x1)		/* db0 */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8feb8fd2957a..0f6c280a94f0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2243,20 +2243,16 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
 #endif
 #endif
 
-/*
- * Clear all 6 debug registers:
- */
-static void clear_all_debug_regs(void)
+static void initialize_debug_regs(void)
 {
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		/* Ignore db4, db5 */
-		if ((i == 4) || (i == 5))
-			continue;
-
-		set_debugreg(0, i);
-	}
+	/* Control register first -- to make sure everything is disabled. */
+	set_debugreg(0, 7);
+	set_debugreg(DR6_RESERVED, 6);
+	/* dr5 and dr4 don't exist */
+	set_debugreg(0, 3);
+	set_debugreg(0, 2);
+	set_debugreg(0, 1);
+	set_debugreg(0, 0);
 }
 
 #ifdef CONFIG_KGDB
@@ -2417,7 +2413,7 @@ void cpu_init(void)
 
 	load_mm_ldt(&init_mm);
 
-	clear_all_debug_regs();
+	initialize_debug_regs();
 	dbg_restore_debug_regs();
 
 	doublefault_init_cpu_tss();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c5c897a86418..36354b470590 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1022,24 +1022,32 @@ static bool is_sysenter_singlestep(struct pt_regs *regs)
 #endif
 }
 
-static __always_inline unsigned long debug_read_clear_dr6(void)
+static __always_inline unsigned long debug_read_reset_dr6(void)
 {
 	unsigned long dr6;
 
+	get_debugreg(dr6, 6);
+	dr6 ^= DR6_RESERVED; /* Flip to positive polarity */
+
 	/*
 	 * The Intel SDM says:
 	 *
-	 *   Certain debug exceptions may clear bits 0-3. The remaining
-	 *   contents of the DR6 register are never cleared by the
-	 *   processor. To avoid confusion in identifying debug
-	 *   exceptions, debug handlers should clear the register before
-	 *   returning to the interrupted task.
+	 *   Certain debug exceptions may clear bits 0-3 of DR6.
+	 *
+	 *   BLD induced #DB clears DR6.BLD and any other debug
+	 *   exception doesn't modify DR6.BLD.
 	 *
-	 * Keep it simple: clear DR6 immediately.
+	 *   RTM induced #DB clears DR6.RTM and any other debug
+	 *   exception sets DR6.RTM.
+	 *
+	 *   To avoid confusion in identifying debug exceptions,
+	 *   debug handlers should set DR6.BLD and DR6.RTM, and
+	 *   clear other DR6 bits before returning.
+	 *
+	 * Keep it simple: write DR6 with its architectural reset
+	 * value 0xFFFF0FF0, defined as DR6_RESERVED, immediately.
 	 */
-	get_debugreg(dr6, 6);
 	set_debugreg(DR6_RESERVED, 6);
-	dr6 ^= DR6_RESERVED; /* Flip to positive polarity */
 
 	return dr6;
 }
@@ -1239,13 +1247,13 @@ static noinstr void exc_debug_user(struct pt_regs *regs, unsigned long dr6)
 /* IST stack entry */
 DEFINE_IDTENTRY_DEBUG(exc_debug)
 {
-	exc_debug_kernel(regs, debug_read_clear_dr6());
+	exc_debug_kernel(regs, debug_read_reset_dr6());
 }
 
 /* User entry, runs on regular task stack */
 DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
 {
-	exc_debug_user(regs, debug_read_clear_dr6());
+	exc_debug_user(regs, debug_read_reset_dr6());
 }
 
 #ifdef CONFIG_X86_FRED
@@ -1264,7 +1272,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
 {
 	/*
 	 * FRED #DB stores DR6 on the stack in the format which
-	 * debug_read_clear_dr6() returns for the IDT entry points.
+	 * debug_read_reset_dr6() returns for the IDT entry points.
 	 */
 	unsigned long dr6 = fred_event_data(regs);
 
@@ -1279,7 +1287,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
 /* 32 bit does not have separate entry points. */
 DEFINE_IDTENTRY_RAW(exc_debug)
 {
-	unsigned long dr6 = debug_read_clear_dr6();
+	unsigned long dr6 = debug_read_reset_dr6();
 
 	if (user_mode(regs))
 		exc_debug_user(regs, dr6);
-- 
2.49.0


