Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0274944A6
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357801AbiATA3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357817AbiATA3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:35 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D08C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x11-20020aa7918b000000b004bd70cde509so2572789pfa.9
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RHhNx8AW5eEssCc3X9AikVAelStrwEI+C97w4CA6zu4=;
        b=GhpvtdJuunmC4RcLFJPEfdl3heHjOlefYmGgFjZqvJDKmFxh8osN8tioOL5TJbfrcT
         FTBWlLwSB8Dv5jlwdgv7IP1+AZSuWhXVZqdYobO6LCFQFNUkW/wfzz5GeIkMF1U5kmw8
         MHvzHzSyr5ou7/inuWi0lwS+zckpNKxqXQxnuW43sofCrph0GSiZk8ZcBMhqrtV87j5R
         FpZ8fNREieRZPdihujBF8KRZOFbIo8VHC9cc88pi+DYuNNLyLUhwAzUM515cfb6HR9Ek
         BuNPCIAVfQqstfGrskI/4tfOpDQC8gCYbRqwg+t+ZRAILacr9uZ2kTOT8Mxk8xUj2mM9
         hhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RHhNx8AW5eEssCc3X9AikVAelStrwEI+C97w4CA6zu4=;
        b=ntGekC63cj/FplgeKuhE2ysoUekSS30oKRARbFIlJX2NlGlpHVPvacmCzlY8H5hNt+
         WRxqnNxsB9xUi8ew9VIwbrMzqyxcMaeRyg0n8DS5R4y5Rk5m5rmIbsuNU0AyWW2+kfyJ
         bvc+iF7nKcud+9S53xEMwBXrvhVvS+yf7USSSJx5QVSMKYCs4V2D1XPE38/iBrBMyx+3
         YE343JenfqL/iO0WuMB7zXsS6xt0H2xKxkxok85Zz2gkmPByoHu8NaKZI6p70geYCSZo
         HT0K8oz8Yzn3LG/QZuaytBbz/zJ03e17xVkBhiOyhq5xHdHgjuWWBtPpvyrWP5rf3smF
         1oUg==
X-Gm-Message-State: AOAM5325/FcuXjGT5v/mjiYrLGIMOq+2ZzkN/MdBq6pCF//jI0D8HhIS
        HcYTRSfxvgIyhoYYQ5U+nENzryfisEk=
X-Google-Smtp-Source: ABdhPJz1fd+P7DqzlpUOvgS616xsarpzcEWL9cIOWwBNAkKE8Mc8sF2rfjnIVtSgxsgX3MMNT5kssCzbbss=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1693:b0:44c:64a3:d318 with SMTP id
 k19-20020a056a00169300b0044c64a3d318mr33278308pfc.81.1642638574292; Wed, 19
 Jan 2022 16:29:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:21 +0000
In-Reply-To: <20220120002923.668708-1-seanjc@google.com>
Message-Id: <20220120002923.668708-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 5/7] x86: Overhaul definitions for DR6 and DR7 bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up the mess that is debugreg.h to follow the nomenclature used by
the SDM and the kernel (as best as possible).  Use the "new" defines in
various tests.  Opportunistically add a define for VMX's extra flag in
vmcs.GUEST_PENDING_DBG_EXCEPTIONS that is set if any DR0-3 trap matched
and was enabled.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/asm/debugreg.h | 125 ++++++++++++++++++-----------------------
 x86/debug.c            |  28 +++++----
 x86/emulator.c         |  14 +++--
 x86/vmx_tests.c        |  27 +++++----
 4 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/lib/x86/asm/debugreg.h b/lib/x86/asm/debugreg.h
index e86f5a62..a30f9493 100644
--- a/lib/x86/asm/debugreg.h
+++ b/lib/x86/asm/debugreg.h
@@ -2,80 +2,63 @@
 #ifndef _ASMX86_DEBUGREG_H_
 #define _ASMX86_DEBUGREG_H_
 
+#include <bitops.h>
 
-/* Indicate the register numbers for a number of the specific
-   debug registers.  Registers 0-3 contain the addresses we wish to trap on */
-#define DR_FIRSTADDR 0        /* u_debugreg[DR_FIRSTADDR] */
-#define DR_LASTADDR 3         /* u_debugreg[DR_LASTADDR]  */
-
-#define DR_STATUS 6           /* u_debugreg[DR_STATUS]     */
-#define DR_CONTROL 7          /* u_debugreg[DR_CONTROL] */
-
-/* Define a few things for the status register.  We can use this to determine
-   which debugging register was responsible for the trap.  The other bits
-   are either reserved or not of interest to us. */
-
-/* Define reserved bits in DR6 which are always set to 1 */
-#define DR6_RESERVED	(0xFFFF0FF0)
-
-#define DR_TRAP0	(0x1)		/* db0 */
-#define DR_TRAP1	(0x2)		/* db1 */
-#define DR_TRAP2	(0x4)		/* db2 */
-#define DR_TRAP3	(0x8)		/* db3 */
-#define DR_TRAP_BITS	(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)
-
-#define DR_STEP		(0x4000)	/* single-step */
-#define DR_SWITCH	(0x8000)	/* task switch */
-
-/* Now define a bunch of things for manipulating the control register.
-   The top two bytes of the control register consist of 4 fields of 4
-   bits - each field corresponds to one of the four debug registers,
-   and indicates what types of access we trap on, and how large the data
-   field is that we are looking at */
-
-#define DR_CONTROL_SHIFT 16 /* Skip this many bits in ctl register */
-#define DR_CONTROL_SIZE 4   /* 4 control bits per register */
-
-#define DR_RW_EXECUTE (0x0)   /* Settings for the access types to trap on */
-#define DR_RW_WRITE (0x1)
-#define DR_RW_READ (0x3)
-
-#define DR_LEN_1 (0x0) /* Settings for data length to trap on */
-#define DR_LEN_2 (0x4)
-#define DR_LEN_4 (0xC)
-#define DR_LEN_8 (0x8)
-
-/* The low byte to the control register determine which registers are
-   enabled.  There are 4 fields of two bits.  One bit is "local", meaning
-   that the processor will reset the bit after a task switch and the other
-   is global meaning that we have to explicitly reset the bit.  With linux,
-   you can use either one, since we explicitly zero the register when we enter
-   kernel mode. */
-
-#define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
-#define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
-#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
-#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
-#define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
-
-#define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
-#define DR_GLOBAL_ENABLE_MASK (0xAA) /* Set global bits for all 4 regs */
-
-/* The second byte to the control register has a few special things.
-   We can slow the instruction pipeline for instructions coming via the
-   gdt or the ldt if we want to.  I am not sure why this is an advantage */
-
-#ifdef __i386__
-#define DR_CONTROL_RESERVED (0xFC00) /* Reserved by Intel */
-#else
-#define DR_CONTROL_RESERVED (0xFFFFFFFF0000FC00UL) /* Reserved */
-#endif
-
-#define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
-#define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
+/*
+ * DR6_ACTIVE_LOW combines fixed-1 and active-low bits (e.g. RTM), and is also
+ * the init/reset value for DR6.
+ */
+#define DR6_ACTIVE_LOW	0xffff0ff0
+#define DR6_VOLATILE	0x0001e80f
+#define DR6_FIXED_1	(DR6_ACTIVE_LOW & ~DR6_VOLATILE)
+
+#define DR6_TRAP0	BIT(0)		/* DR0 matched */
+#define DR6_TRAP1	BIT(1)		/* DR1 matched */
+#define DR6_TRAP2	BIT(2)		/* DR2 matched */
+#define DR6_TRAP3	BIT(3)		/* DR3 matched */
+#define DR6_TRAP_BITS	(DR6_TRAP0|DR6_TRAP1|DR6_TRAP2|DR6_TRAP3)
+
+#define DR6_BUS_LOCK	BIT(11)		/* Bus lock	    0x800 */
+#define DR6_BD		BIT(13)		/* General Detect  0x2000 */
+#define DR6_BS		BIT(14)		/* Single-Step	   0x4000 */
+#define DR6_BT		BIT(15)		/* Task Switch	   0x8000 */
+#define DR6_RTM		BIT(16)		/* RTM / TSX	  0x10000 */
+
+#define DR7_FIXED_1	0x00000400	/* init/reset value, too */
+#define DR7_VOLATILE	0xffff2bff
+#define DR7_BP_EN_MASK	0x000000ff
+#define DR7_LE		BIT(8)		/* Local Exact	    0x100 */
+#define DR7_GE		BIT(9)		/* Global Exact     0x200 */
+#define DR7_RTM		BIT(11)		/* RTM / TSX	    0x800 */
+#define DR7_GD		BIT(13)		/* General Detect  0x2000 */
 
 /*
- * HW breakpoint additions
+ * Enable bits for DR0-D3.  Bits 0, 2, 4, and 6 are local enable bits (cleared
+ * by the CPU on task switch), bits 1, 3, 5, and 7 are global enable bits
+ * (never cleared by the CPU).
  */
+#define DR7_LOCAL_ENABLE_DRx(x)		(BIT(0) << (x))
+#define DR7_GLOBAL_ENABLE_DRx(x)	(BIT(1) << (x))
+#define DR7_ENABLE_DRx(x) \
+	(DR7_LOCAL_ENABLE_DRx(x) | DR7_GLOBAL_ENABLE_DRx(x))
+
+#define DR7_GLOBAL_ENABLE_DR0	DR7_GLOBAL_ENABLE_DRx(0)
+#define DR7_GLOBAL_ENABLE_DR1	DR7_GLOBAL_ENABLE_DRx(1)
+#define DR7_GLOBAL_ENABLE_DR2	DR7_GLOBAL_ENABLE_DRx(2)
+#define DR7_GLOBAL_ENABLE_DR3	DR7_GLOBAL_ENABLE_DRx(3)
+
+/* Condition/type of the breakpoint for DR0-3. */
+#define DR7_RW_TYPE_DRx(x, rw)	((rw) << (((x) * 4) + 16))
+#define DR7_EXECUTE_DRx(x)	DR7_RW_TYPE_DRx(x, 0)
+#define DR7_WRITE_DRx(x)	DR7_RW_TYPE_DRx(x, 1)
+#define DR7_PORT_IO_DRx(x)	DR7_RW_TYPE_DRx(x, 2)
+#define DR7_DATA_IO_DRx(x)	DR7_RW_TYPE_DRx(x, 3)	/* Read or Write */
+
+/* Length of the breakpoint for DR0-3. */
+#define DR7_LEN_DRx(x, enc)	((enc) << (((x) * 4) + 18))
+#define DR7_LEN_1_DRx(x)	DR7_LEN_DRx(x, 0)
+#define DR7_LEN_2_DRx(x)	DR7_LEN_DRx(x, 1)
+#define DR7_LEN_4_DRx(x)	DR7_LEN_DRx(x, 3)
+#define DR7_LEN_8_DRx(x)	DR7_LEN_DRx(x, 2) /* Out of sequence, undefined for 32-bit CPUs. */
 
 #endif /* _ASMX86_DEBUGREG_H_ */
diff --git a/x86/debug.c b/x86/debug.c
index 21f1da0b..5835a064 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -8,6 +8,7 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
+#include <asm/debugreg.h>
 
 #include "libcflat.h"
 #include "processor.h"
@@ -47,12 +48,12 @@ static void handle_db(struct ex_regs *regs)
 
 static inline bool is_single_step_db(unsigned long dr6_val)
 {
-	return dr6_val == 0xffff4ff0;
+	return dr6_val == (DR6_ACTIVE_LOW | DR6_BS);
 }
 
 static inline bool is_icebp_db(unsigned long dr6_val)
 {
-	return dr6_val == 0xffff0ff0;
+	return dr6_val == DR6_ACTIVE_LOW;
 }
 
 extern unsigned char handle_db_save_rip;
@@ -193,8 +194,9 @@ int main(int ac, char **av)
 	cr4 = read_cr4();
 	write_cr4(cr4 & ~X86_CR4_DE);
 	write_dr4(0);
-	write_dr6(0xffff4ff2);
-	report(read_dr4() == 0xffff4ff2 && !got_ud, "reading DR4 with CR4.DE == 0");
+	write_dr6(DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP1);
+	report(read_dr4() == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP1) && !got_ud,
+	       "DR4==DR6 with CR4.DE == 0");
 
 	cr4 = read_cr4();
 	write_cr4(cr4 | X86_CR4_DE);
@@ -217,19 +219,21 @@ int main(int ac, char **av)
 	n = 0;
 	extern unsigned char hw_bp1;
 	write_dr0(&hw_bp1);
-	write_dr7(0x00000402);
+	write_dr7(DR7_FIXED_1 | DR7_GLOBAL_ENABLE_DR0);
 	asm volatile("hw_bp1: nop");
 	report(n == 1 &&
-	       db_addr[0] == ((unsigned long)&hw_bp1) && dr6[0] == 0xffff0ff1,
+	       db_addr[0] == ((unsigned long)&hw_bp1) &&
+	       dr6[0] == (DR6_ACTIVE_LOW | DR6_TRAP0),
 	       "hw breakpoint (test that dr6.BS is not set)");
 
 	n = 0;
 	extern unsigned char hw_bp2;
 	write_dr0(&hw_bp2);
-	write_dr6(0x00004002);
+	write_dr6(DR6_BS | DR6_TRAP1);
 	asm volatile("hw_bp2: nop");
 	report(n == 1 &&
-	       db_addr[0] == ((unsigned long)&hw_bp2) && dr6[0] == 0xffff4ff1,
+	       db_addr[0] == ((unsigned long)&hw_bp2) &&
+	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP0),
 	       "hw breakpoint (test that dr6.BS is not cleared)");
 
 	run_ss_db_test(singlestep_basic);
@@ -245,7 +249,8 @@ int main(int ac, char **av)
 		"mov %%rax,%0\n\t; hw_wp1:"
 		: "=m" (value) : : "rax");
 	report(n == 1 &&
-	       db_addr[0] == ((unsigned long)&hw_wp1) && dr6[0] == 0xffff4ff2,
+	       db_addr[0] == ((unsigned long)&hw_wp1) &&
+	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP1),
 	       "hw watchpoint (test that dr6.BS is not cleared)");
 
 	n = 0;
@@ -257,7 +262,8 @@ int main(int ac, char **av)
 		"mov %%rax,%0\n\t; hw_wp2:"
 		: "=m" (value) : : "rax");
 	report(n == 1 &&
-	       db_addr[0] == ((unsigned long)&hw_wp2) && dr6[0] == 0xffff0ff2,
+	       db_addr[0] == ((unsigned long)&hw_wp2) &&
+	       dr6[0] == (DR6_ACTIVE_LOW | DR6_TRAP1),
 	       "hw watchpoint (test that dr6.BS is not set)");
 
 	n = 0;
@@ -265,7 +271,7 @@ int main(int ac, char **av)
 	extern unsigned char sw_icebp;
 	asm volatile(".byte 0xf1; sw_icebp:");
 	report(n == 1 &&
-	       db_addr[0] == (unsigned long)&sw_icebp && dr6[0] == 0xffff0ff0,
+	       db_addr[0] == (unsigned long)&sw_icebp && dr6[0] == DR6_ACTIVE_LOW,
 	       "icebp");
 
 	write_dr7(0x400);
diff --git a/x86/emulator.c b/x86/emulator.c
index 22a518f4..cd78e3cb 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -1,3 +1,5 @@
+#include <asm/debugreg.h>
+
 #include "ioram.h"
 #include "vm.h"
 #include "libcflat.h"
@@ -883,12 +885,14 @@ static void test_nop(uint64_t *mem)
 static void test_mov_dr(uint64_t *mem)
 {
 	unsigned long rax;
-	const unsigned long in_rax = 0;
-	bool rtm_support = this_cpu_has(X86_FEATURE_RTM);
-	unsigned long dr6_fixed_1 = rtm_support ? 0xfffe0ff0ul : 0xffff0ff0ul;
+
 	asm(KVM_FEP "movq %0, %%dr6\n\t"
-	    KVM_FEP "movq %%dr6, %0\n\t" : "=a" (rax) : "a" (in_rax));
-	report(rax == dr6_fixed_1, "mov_dr6");
+	    KVM_FEP "movq %%dr6, %0\n\t" : "=a" (rax) : "a" (0));
+
+	if (this_cpu_has(X86_FEATURE_RTM))
+		report(rax == (DR6_ACTIVE_LOW & ~DR6_RTM), "mov_dr6");
+	else
+		report(rax == DR6_ACTIVE_LOW, "mov_dr6");
 }
 
 static void test_push16(uint64_t *mem)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6c..e67eaea4 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -22,6 +22,13 @@
 #include "delay.h"
 #include "access.h"
 
+/*
+ * vmcs.GUEST_PENDING_DEBUG has the same format as DR6, although some bits that
+ * are legal in DR6 are reserved in vmcs.GUEST_PENDING_DEBUG.  And if any data
+ * or I/O breakpoint matches *and* was enabled, bit 12 is also set.
+ */
+#define PENDING_DBG_TRAP	BIT(12)
+
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
 
 u64 ia32_pat;
@@ -5080,9 +5087,9 @@ static void vmx_mtf_test(void)
 	enter_guest();
 	report_mtf("OUT", (unsigned long) &test_mtf2);
 	pending_dbg = vmcs_read(GUEST_PENDING_DEBUG);
-	report(pending_dbg & DR_STEP,
+	report(pending_dbg & DR6_BS,
 	       "'pending debug exceptions' field after MTF VM-exit: 0x%lx (expected 0x%lx)",
-	       pending_dbg, (unsigned long) DR_STEP);
+	       pending_dbg, (unsigned long) DR6_BS);
 
 	disable_mtf();
 	disable_tf();
@@ -8931,7 +8938,7 @@ static void vmx_preemption_timer_zero_inject_db(bool intercept_db)
 static void vmx_preemption_timer_zero_set_pending_dbg(u32 exception_bitmap)
 {
 	vmx_preemption_timer_zero_activate_preemption_timer();
-	vmcs_write(GUEST_PENDING_DEBUG, BIT(12) | DR_TRAP1);
+	vmcs_write(GUEST_PENDING_DEBUG, PENDING_DBG_TRAP | DR6_TRAP1);
 	vmcs_write(EXC_BITMAP, exception_bitmap);
 	enter_guest();
 }
@@ -9315,7 +9322,7 @@ static void vmx_db_test(void)
 	 * (b) stale bits in DR6 (DR6.BD, in particular) don't leak into
          *     the exit qualification field for a subsequent #DB exception.
 	 */
-	const u64 starting_dr6 = DR6_RESERVED | BIT(13) | DR_TRAP3 | DR_TRAP1;
+	const u64 starting_dr6 = DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP3 | DR6_TRAP1;
 	extern char post_nop asm(".Lpost_nop");
 	extern char post_movss_nop asm(".Lpost_movss_nop");
 	extern char post_wbinvd asm(".Lpost_wbinvd");
@@ -9339,7 +9346,7 @@ static void vmx_db_test(void)
 	 * standard that L0 has to follow for emulated instructions.
 	 */
 	single_step_guest("Hardware delivered single-step", starting_dr6, 0);
-	check_db_exit(false, false, false, &post_nop, DR_STEP, starting_dr6);
+	check_db_exit(false, false, false, &post_nop, DR6_BS, starting_dr6);
 
 	/*
 	 * Hardware-delivered #DB trap for single-step in MOVSS shadow
@@ -9349,8 +9356,8 @@ static void vmx_db_test(void)
 	 * data breakpoint as well as the single-step trap.
 	 */
 	single_step_guest("Hardware delivered single-step in MOVSS shadow",
-			  starting_dr6, BIT(12) | DR_STEP | DR_TRAP0 );
-	check_db_exit(false, false, false, &post_movss_nop, DR_STEP | DR_TRAP0,
+			  starting_dr6, DR6_BS | PENDING_DBG_TRAP | DR6_TRAP0);
+	check_db_exit(false, false, false, &post_movss_nop, DR6_BS | DR6_TRAP0,
 		      starting_dr6);
 
 	/*
@@ -9360,7 +9367,7 @@ static void vmx_db_test(void)
 	 * modified DR6, but fails miserably.
 	 */
 	single_step_guest("Software synthesized single-step", starting_dr6, 0);
-	check_db_exit(false, false, false, &post_wbinvd, DR_STEP, starting_dr6);
+	check_db_exit(false, false, false, &post_wbinvd, DR6_BS, starting_dr6);
 
 	/*
 	 * L0 synthesized #DB trap for single-step in MOVSS shadow is
@@ -9369,8 +9376,8 @@ static void vmx_db_test(void)
 	 * the exit qualification field for the #DB exception.
 	 */
 	single_step_guest("Software synthesized single-step in MOVSS shadow",
-			  starting_dr6, BIT(12) | DR_STEP | DR_TRAP0);
-	check_db_exit(true, false, true, &post_movss_wbinvd, DR_STEP | DR_TRAP0,
+			  starting_dr6, DR6_BS | PENDING_DBG_TRAP | DR6_TRAP0);
+	check_db_exit(true, false, true, &post_movss_wbinvd, DR6_BS | DR6_TRAP0,
 		      starting_dr6);
 
 	/*
-- 
2.34.1.703.g22d0c6ccf7-goog

