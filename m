Return-Path: <kvm+bounces-49387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCC0AD838C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D483F17B570
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459BD25A645;
	Fri, 13 Jun 2025 07:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="wHz4K9b+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDD11EE7C6;
	Fri, 13 Jun 2025 07:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749798155; cv=none; b=owE4/roc+05pXD9fQ7HIvThAzuQSQ1cb4eF3/sG+AobYLe52PJAjvNrh86DUsctDiIbWAndeX5HADXll7sbtbo/NtJdhoRE+ukiWKnEDYTMZ8QjTGliMjZf5TvjfpBklQX7sIDvGJAWFpp5Ea2SRPSAaQFqriSgGr0c0zYu5ONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749798155; c=relaxed/simple;
	bh=O7NEYvcqRsP442zVP1RJUi7y9UU+zLo1x88Gofl02Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upf0KCwHpggqEP0qlvirvh5J1CLQ1gztYrYss7W/KcWq0toYtqb6cJF+nIwvSsAJEVrZPtBTeYYcPXcMvI1p7x0PsCkNo+zl2LtWZXkzxj/jgLUsz8GFJFQVzTlvZIZCOJs7HxyG2hQgRHxwcQ54hpwvtCh5OLA3vpcwnBgkSRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=wHz4K9b+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55D71IfL3694425
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 13 Jun 2025 00:01:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55D71IfL3694425
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749798089;
	bh=vx4pQfjchlO1UPDPBXp/cPMaht6jv4yxEaB53+uFqBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHz4K9b+z1X+h35UIPWb1bW2pcjOw89yj3tVk7zNuP+N/ADTzzrQsKCXAp3Bpo1mU
	 fB5MsxxazzC/Abh5o2O4xstevdFPTCtbo0RrOngkCNT7TPmw2D0rpLnHfuW51Tobzj
	 UT3sltdd/jsOvHd/NdSsJ9QfyCUpLkuqJmODVw4MQtfycQcJ/hCP+IcKre+H7ZkmXS
	 h0f86IzgEwBSoUaZ2j5lTMB/OugXTMRpuK2vTvcEinnRvm1ef4Nl4YYRg/p9XO94No
	 yo3JQFWwEJ1z4xYbzFX0wG+CXZf2tk7SSNVnxJBXpdK290jKdPNMfo2u5eaDda7n8G
	 sC/ThFBOpo1xA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: [PATCH v1 2/3] x86/traps: Initialize DR7 by writing its architectural reset value
Date: Fri, 13 Jun 2025 00:01:16 -0700
Message-ID: <20250613070118.3694407-3-xin@zytor.com>
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

Initialize DR7 by writing its architectural reset value to ensure
compliance with the specification.

Since clear_all_debug_regs() no longer zeros all debug registers,
rename it to initialize_debug_regs() to better reflect its current
behavior.

While at it, replace the hardcoded debug register number 7 with the
existing DR_CONTROL macro for clarity.

Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/debugreg.h | 12 ++++++------
 arch/x86/kernel/cpu/common.c    | 17 +++++++----------
 arch/x86/kernel/hw_breakpoint.c |  6 +++---
 arch/x86/kernel/kgdb.c          |  4 ++--
 arch/x86/kernel/process_32.c    |  4 ++--
 arch/x86/kernel/process_64.c    |  4 ++--
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              |  4 ++--
 8 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 363110e6b2e3..bfa8cfcb9732 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -100,8 +100,8 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
 
 static inline void hw_breakpoint_disable(void)
 {
-	/* Zero the control register for HW Breakpoint */
-	set_debugreg(0UL, 7);
+	/* Reset the control register for HW Breakpoint */
+	set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
 
 	/* Zero-out the individual HW breakpoint address registers */
 	set_debugreg(0UL, 0);
@@ -124,10 +124,10 @@ static __always_inline unsigned long local_db_save(void)
 	if (static_cpu_has(X86_FEATURE_HYPERVISOR) && !hw_breakpoint_active())
 		return 0;
 
-	get_debugreg(dr7, 7);
-	dr7 &= ~0x400; /* architecturally set bit */
+	get_debugreg(dr7, DR_CONTROL);
+	dr7 &= ~DR7_RESET_VALUE; /* architecturally set bit */
 	if (dr7)
-		set_debugreg(0, 7);
+		set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
 	/*
 	 * Ensure the compiler doesn't lower the above statements into
 	 * the critical section; disabling breakpoints late would not
@@ -147,7 +147,7 @@ static __always_inline void local_db_restore(unsigned long dr7)
 	 */
 	barrier();
 	if (dr7)
-		set_debugreg(dr7, 7);
+		set_debugreg(dr7, DR_CONTROL);
 }
 
 #ifdef CONFIG_CPU_SUP_AMD
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8feb8fd2957a..628aa43acb41 100644
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
+	set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
+	set_debugreg(0, DR_STATUS);
 
+	/* Ignore db4, db5 */
+	for (i = DR_FIRSTADDR; i <= DR_LASTADDR; i++)
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
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..29f4473817a1 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -125,7 +125,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	 */
 	barrier();
 
-	set_debugreg(*dr7, 7);
+	set_debugreg(*dr7, DR_CONTROL);
 	if (info->mask)
 		amd_set_dr_addr_mask(info->mask, i);
 
@@ -164,7 +164,7 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	dr7 = this_cpu_read(cpu_dr7);
 	dr7 &= ~__encode_dr7(i, info->len, info->type);
 
-	set_debugreg(dr7, 7);
+	set_debugreg(dr7, DR_CONTROL);
 	if (info->mask)
 		amd_set_dr_addr_mask(0, i);
 
@@ -487,7 +487,7 @@ void hw_breakpoint_restore(void)
 	set_debugreg(__this_cpu_read(cpu_debugreg[2]), 2);
 	set_debugreg(__this_cpu_read(cpu_debugreg[3]), 3);
 	set_debugreg(DR6_RESERVED, 6);
-	set_debugreg(__this_cpu_read(cpu_dr7), 7);
+	set_debugreg(__this_cpu_read(cpu_dr7), DR_CONTROL);
 }
 EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 102641fd2172..1b7a63f18c6d 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -202,7 +202,7 @@ static void kgdb_correct_hw_break(void)
 			early_dr7 |= encode_dr7(breakno,
 						breakinfo[breakno].len,
 						breakinfo[breakno].type);
-			set_debugreg(early_dr7, 7);
+			set_debugreg(early_dr7, DR_CONTROL);
 			continue;
 		}
 		bp = *per_cpu_ptr(breakinfo[breakno].pev, cpu);
@@ -385,7 +385,7 @@ static void kgdb_disable_hw_debug(struct pt_regs *regs)
 	struct perf_event *bp;
 
 	/* Disable hardware debugging while we are in kgdb: */
-	set_debugreg(0UL, 7);
+	set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
 	for (i = 0; i < HBP_NUM; i++) {
 		if (!breakinfo[i].enabled)
 			continue;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a10e180cbf23..f5f28a8fa44c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -89,11 +89,11 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
 	get_debugreg(d6, 6);
-	get_debugreg(d7, 7);
+	get_debugreg(d7, DR_CONTROL);
 
 	/* Only print out debug registers if they are in their non-default state. */
 	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
-	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+	    (d6 == DR6_RESERVED) && (d7 == DR7_RESET_VALUE))
 		return;
 
 	printk("%sDR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 8d6cf25127aa..1eb1ac948878 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -129,11 +129,11 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
 	get_debugreg(d6, 6);
-	get_debugreg(d7, 7);
+	get_debugreg(d7, DR_CONTROL);
 
 	/* Only print out debug registers if they are in their non-default state. */
 	if (!((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
-	    (d6 == DR6_RESERVED) && (d7 == 0x400))) {
+	    (d6 == DR6_RESERVED) && (d7 == DR7_RESET_VALUE))) {
 		printk("%sDR0: %016lx DR1: %016lx DR2: %016lx\n",
 		       log_lvl, d0, d1, d2);
 		printk("%sDR3: %016lx DR6: %016lx DR7: %016lx\n",
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7211c71d4241..6bad44db2168 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3270,7 +3270,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	 * VMExit clears RFLAGS.IF and DR7, even on a consistency check.
 	 */
 	if (hw_breakpoint_active())
-		set_debugreg(__this_cpu_read(cpu_dr7), 7);
+		set_debugreg(__this_cpu_read(cpu_dr7), DR_CONTROL);
 	local_irq_enable();
 	preempt_enable();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722d..20fa9733aed1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11035,7 +11035,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (unlikely(vcpu->arch.switch_db_regs &&
 		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
-		set_debugreg(0, 7);
+		set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
 		set_debugreg(vcpu->arch.eff_db[2], 2);
@@ -11044,7 +11044,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
 			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
 	} else if (unlikely(hw_breakpoint_active())) {
-		set_debugreg(0, 7);
+		set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
 	}
 
 	vcpu->arch.host_debugctl = get_debugctlmsr();
-- 
2.49.0


