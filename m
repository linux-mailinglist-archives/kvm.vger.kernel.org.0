Return-Path: <kvm+bounces-49681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3BCADC36F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7208162F8E
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 07:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AD92900A3;
	Tue, 17 Jun 2025 07:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iCMGcPJW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775783C2F;
	Tue, 17 Jun 2025 07:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750145629; cv=none; b=sd0CLevUo3GOs3NB8xxtOuTPgEqZ+dHbuVpqzfY6jQJiZxe4TXnI8K5SW6fDWbzBo5eCOxKaIsa2QoXxGSsO3aFcoBxjAGQFRHsepkRMZWtTbrZsY14BlgYWAfxVmoR6aaEuHu/KJUna89QdXlTPt4ioy9fyEzmtJQ65GD8Uc2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750145629; c=relaxed/simple;
	bh=r2hXSsjEbQxu0mOvM191VLjPAl5LgTFDXv+l4XfTIJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvCiJMGbiO4MyX6lln30vvRS4oC8Lmhj9Ao3oMz4xFoRfXI2xSaX0Wfq1+ru4PDzLK187WRA6qH9moBMeVHlebz7rnyx8t+JI5uoLzPtLSSbmunsrTwnTl5hJWYURCQjRzx7VGz0B7nPhF3YoFsHVcKKxbKn9qqk61MHamL/NqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iCMGcPJW; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55H7WY8x1020658
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 17 Jun 2025 00:32:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55H7WY8x1020658
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750145559;
	bh=M0DKhA38fEw6Bm/3Z+zol8C78ucdC08/MmuvHH4gP5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCMGcPJWNrjKttAGX2SFY0d7+3klYcr5d/LKLeAAoPd4ZvIOMSke8zdJqd/BHnl46
	 x5rbdYIXpQaC4fdTQFDUFqLoHU0wnvzLixKayRGJOoxHCCEfzXzwgnFADxIBPeTcIy
	 p0mMfJCtFhWOPVHXYdMAlBhxvuRHlYOIY0J1hjO0+0t4qTY0IgAsgstjRGSlgzXAhe
	 r1jzoCnAIxycfQqb06iqNFhz8jbzyPUuL5NdtU95ur+v3E24eu4kOO+jgTxZ8OemdZ
	 /Peu/ItwJWejYVDcFp8kbRFXJtdlPhpLlsa4C+9vVTkUcuBoDKeXdCKlq6jRiHAK+5
	 q/MrFIg8uUb9w==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
Subject: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its architectural reset value
Date: Tue, 17 Jun 2025 00:32:33 -0700
Message-ID: <20250617073234.1020644-2-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617073234.1020644-1-xin@zytor.com>
References: <20250617073234.1020644-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialize DR6 by writing its architectural reset value to ensure
compliance with the specification.  This avoids incorrectly zeroing
DR6 to clear DR6.BLD at boot time, which leads to a false bus lock
detected warning.

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
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Cc: stable@vger.kernel.org
---

Changes in v2:
*) Use debug register index 6 rather than DR_STATUS (PeterZ and Sean).
*) Move this patch the first of the patch set to ease backporting.
---
 arch/x86/include/uapi/asm/debugreg.h |  7 +++++-
 arch/x86/kernel/cpu/common.c         | 17 ++++++--------
 arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
 3 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
index 0007ba077c0c..8f335b9fa892 100644
--- a/arch/x86/include/uapi/asm/debugreg.h
+++ b/arch/x86/include/uapi/asm/debugreg.h
@@ -15,7 +15,12 @@
    which debugging register was responsible for the trap.  The other bits
    are either reserved or not of interest to us. */
 
-/* Define reserved bits in DR6 which are always set to 1 */
+/*
+ * Define reserved bits in DR6 which are set to 1 by default.
+ *
+ * This is also the DR6 architectural value following Power-up, Reset or INIT.
+ * Some of these reserved bits can be set to 0 by hardware or software.
+ */
 #define DR6_RESERVED	(0xFFFF0FF0)
 
 #define DR_TRAP0	(0x1)		/* db0 */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8feb8fd2957a..3bd7c9ac7576 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2243,20 +2243,17 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
 #endif
 #endif
 
-/*
- * Clear all 6 debug registers:
- */
-static void clear_all_debug_regs(void)
+static void initialize_debug_regs(void)
 {
 	int i;
 
-	for (i = 0; i < 8; i++) {
-		/* Ignore db4, db5 */
-		if ((i == 4) || (i == 5))
-			continue;
+	/* Control register first */
+	set_debugreg(0, 7);
+	set_debugreg(DR6_RESERVED, 6);
 
+	/* Ignore db4, db5 */
+	for (i = 0; i < 4; i++)
 		set_debugreg(0, i);
-	}
 }
 
 #ifdef CONFIG_KGDB
@@ -2417,7 +2414,7 @@ void cpu_init(void)
 
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


