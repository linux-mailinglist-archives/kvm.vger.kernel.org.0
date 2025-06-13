Return-Path: <kvm+bounces-49389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3B9AD8397
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EB3F7A28D8
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E789925C81C;
	Fri, 13 Jun 2025 07:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="CIfInV0Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF1C1F152D;
	Fri, 13 Jun 2025 07:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749798157; cv=none; b=QamHlgp3wDhKw8Sv17ymlV7xYMVl6Z5HY5dAP90Nba6YEfXIIoHgfQTIk2xReYW693BoN8BOFG3wA7jk+NRyKKdmC5mCQe63mrXx2PHOPpXZ+llpDfFRgHkBHzRqStPCwrLVPn93IQ+uvZhLVFsVLc2TOb5FPkUpGMDWc0mZmZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749798157; c=relaxed/simple;
	bh=2gbOykEfw8b0Skg7GZ9gS0aQ1S4WiRzL4kpoKT73o6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L20ZFarzPcwLgHct3jqHaZRHjmAem3sOretSrpxceQLcQ/DsucOtwDecGjiMfhAM750sJvmWCjdpyIZ+6q5P6mx4VcYb9YzSYQOwk/M1LikVOo0ItcDzzEjFvHl6RDhryvSxQqaC/GCZOzMqVn6nENpRN1EVqiv63ZgsK+Ve6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=CIfInV0Q; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55D71IfM3694425
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 13 Jun 2025 00:01:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55D71IfM3694425
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749798090;
	bh=c56T8D2ZCMU1wWU13jvv/tk+j/ZEJRy0cc12msrPZsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIfInV0QoUeYeKzmCKxbzua4kNlZuLua3q2+GExDA4HRqVSxokRIogfzkxxf2sC4J
	 OpS87qxTsMsDwblt/dfEcDv115SsmCPFp4vXLHt9dz6GA2foZnlZ0pBImYaUBc8xCf
	 ZzTxPo0SuNSBUuSo+DRZ6veTXogmj2iQdjy1JnyFH6ryYN2HoqmJuFR2MBJHmotEka
	 A7SV8GYE0Wcs/JW1W5YlqWvSdbRSqfupwn0ZyNOXIbzwU/pCiNi7xotovbJaDIBlw0
	 +TQ0jfArTDw7MXwUXVi1RO3J1d62Q3ssnQM4YnBSze3jAcHI+kjorie2dedGBi07ba
	 TFXSfvVUirpFg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: [PATCH v1 3/3] x86/traps: Initialize DR6 by writing its architectural reset value
Date: Fri, 13 Jun 2025 00:01:17 -0700
Message-ID: <20250613070118.3694407-4-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613070118.3694407-1-xin@zytor.com>
References: <20250613070118.3694407-1-xin@zytor.com>
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

Since debug_read_clear_dr6() no longer clears DR6, rename it to
debug_read_reset_dr6() to better reflect its current behavior.

While at it, replace the hardcoded debug register number 6 with the
existing DR_STATUS macro for clarity.

Reported-by: Sohil Mehta <sohil.mehta@intel.com>
Link: https://lore.kernel.org/lkml/06e68373-a92b-472e-8fd9-ba548119770c@intel.com/
Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Cc: stable@vger.kernel.org
---
 arch/x86/include/uapi/asm/debugreg.h |  7 +++++-
 arch/x86/kernel/cpu/common.c         |  2 +-
 arch/x86/kernel/hw_breakpoint.c      |  2 +-
 arch/x86/kernel/process_32.c         |  2 +-
 arch/x86/kernel/process_64.c         |  2 +-
 arch/x86/kernel/traps.c              | 36 +++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c               |  6 ++---
 7 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
index d16f53c3a9df..e407d84133a9 100644
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
index 628aa43acb41..459faad8dccc 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2249,7 +2249,7 @@ static void initialize_debug_regs(void)
 
 	/* Control register first */
 	set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
-	set_debugreg(0, DR_STATUS);
+	set_debugreg(DR6_RESERVED, DR_STATUS);
 
 	/* Ignore db4, db5 */
 	for (i = DR_FIRSTADDR; i <= DR_LASTADDR; i++)
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 29f4473817a1..05f333286eb8 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -486,7 +486,7 @@ void hw_breakpoint_restore(void)
 	set_debugreg(__this_cpu_read(cpu_debugreg[1]), 1);
 	set_debugreg(__this_cpu_read(cpu_debugreg[2]), 2);
 	set_debugreg(__this_cpu_read(cpu_debugreg[3]), 3);
-	set_debugreg(DR6_RESERVED, 6);
+	set_debugreg(DR6_RESERVED, DR_STATUS);
 	set_debugreg(__this_cpu_read(cpu_dr7), DR_CONTROL);
 }
 EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f5f28a8fa44c..62d6e2def021 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -88,7 +88,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
-	get_debugreg(d6, 6);
+	get_debugreg(d6, DR_STATUS);
 	get_debugreg(d7, DR_CONTROL);
 
 	/* Only print out debug registers if they are in their non-default state. */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 1eb1ac948878..f8465bf8be0d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -128,7 +128,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
-	get_debugreg(d6, 6);
+	get_debugreg(d6, DR_STATUS);
 	get_debugreg(d7, DR_CONTROL);
 
 	/* Only print out debug registers if they are in their non-default state. */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c5c897a86418..371a80ed97f8 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1022,24 +1022,32 @@ static bool is_sysenter_singlestep(struct pt_regs *regs)
 #endif
 }
 
-static __always_inline unsigned long debug_read_clear_dr6(void)
+static __always_inline unsigned long debug_read_reset_dr6(void)
 {
 	unsigned long dr6;
 
+	get_debugreg(dr6, DR_STATUS);
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
-	set_debugreg(DR6_RESERVED, 6);
-	dr6 ^= DR6_RESERVED; /* Flip to positive polarity */
+	set_debugreg(DR6_RESERVED, DR_STATUS);
 
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4953846cb30d..3d187995a174 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5593,7 +5593,7 @@ void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
 	get_debugreg(vcpu->arch.db[3], 3);
-	get_debugreg(vcpu->arch.dr6, 6);
+	get_debugreg(vcpu->arch.dr6, DR_STATUS);
 	vcpu->arch.dr7 = vmcs_readl(GUEST_DR7);
 
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
@@ -5603,13 +5603,13 @@ void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	 * exc_debug expects dr6 to be cleared after it runs, avoid that it sees
 	 * a stale dr6 from the guest.
 	 */
-	set_debugreg(DR6_RESERVED, 6);
+	set_debugreg(DR6_RESERVED, DR_STATUS);
 }
 
 void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	lockdep_assert_irqs_disabled();
-	set_debugreg(vcpu->arch.dr6, 6);
+	set_debugreg(vcpu->arch.dr6, DR_STATUS);
 }
 
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
-- 
2.49.0


