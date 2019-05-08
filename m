Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A08217F52
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfEHRrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:47:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37497 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfEHRrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:47:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id p15so3075812pll.4
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 10:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qcb8Pfe5TE8KQ6Ha5Mgb540bwqn3binwEeBVI7QQ1nc=;
        b=bOgUJkLrxEH2gX/iHRGUds79YLn6u4o9O4Or41Whj4PrSM21eq85C3bfHOwrCGX5o0
         SsgpZtgsZcT4GK/pPp8DPndMHiHhI8EcqcxOCzU+fZKlFxCuKeueERU+4Jfb0EuhzOsQ
         igQ17F2eKDGOP/ou/lsaUQEFEO9DanLCxoi21Att4PoUr5tcNPplUaxzXscXzixZW5S0
         dsX1XUvyAzsQpvB5jUzl+k8/JZG8Y8Zo2aTqChikKvpAOCpM6uhXJwkh3j1mmZj38Q4P
         zBFFkfmDO4RF/Uintaoy1u4XIkSyUsgqUn8XxDsjFZodXBNB/Qm6zrZT2ZWKsgM0sbzN
         rS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qcb8Pfe5TE8KQ6Ha5Mgb540bwqn3binwEeBVI7QQ1nc=;
        b=tv2Edx97t2wgwPhDeGhQA4Dtt1Pw7dWh0lMV5rk8vGYiICvHJYQnyjCIS5quR+Diwv
         RNGXjHnMzzs6lra8O97LY/V2EhjJjsbhDsFfw8JLQH1SjVcwCLJWnUK7UmtFpNFvJWGx
         K11eZpKqP/u10AmI3ZK1WLRRq7FLIGyJ/VGJ75S1UvI82D/3Ctr9/+emrKuOnBG4xsV0
         SThf+QWTcoLTD6EWOb/na7Nh1ZZFsi97jOXMs+IDPLldiI4yJWbwnPSsMtl4EX+cMy11
         1LIbINIPxCuFNUkoFbL4Lv5mtMuurHsZgGO9gZJ2XLKXN6IwIB7EzyP1cUXIyYQqur9n
         EeGw==
X-Gm-Message-State: APjAAAVze00As+w/aNEtmwkHBSFnOZ9IuO5VJVx8hJHxKluEPzGPzkYF
        oHMdQBM6Mvheeo7bhprR1NyKP9aBMrQ=
X-Google-Smtp-Source: APXvYqzuGtWsnOUIJ0o6Q4+JRhLBBFwaytyS4OVLRRp5heDDjBrY9PwJ6jsFhAru4LffdlvHLEwZvw==
X-Received: by 2002:a17:902:9898:: with SMTP id s24mr36651275plp.166.1557337659849;
        Wed, 08 May 2019 10:47:39 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id q14sm10097189pgg.10.2019.05.08.10.47.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 10:47:38 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: nVMX: Use #DB in nmi and intr tests
Date:   Wed,  8 May 2019 03:27:14 -0700
Message-Id: <20190508102715.685-2-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508102715.685-1-namit@vmware.com>
References: <20190508102715.685-1-namit@vmware.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

According to Intel SDM 26.3.1.5 "Checks on Guest Non-Register State", if
the activity state is HLT, the only events that can be injected are NMI,
MTF and "Those with interruption type hardware exception and vector 1
(debug exception) or vector 18 (machine-check exception)."

Two tests, verify_nmi_window_exit() and verify_intr_window_exit(), try
to do something that real hardware disallows (i.e., fail the VM-entry)
by injecting #UD in HLT-state.  Inject #DB instead as the injection
should succeed in these tests.

Cc: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 72 ++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index d0ce1af..f921286 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7035,21 +7035,21 @@ static void vmx_pending_event_hlt_test(void)
 	vmx_pending_event_test_core(true);
 }
 
-static int vmx_window_test_ud_count;
+static int vmx_window_test_db_count;
 
-static void vmx_window_test_ud_handler(struct ex_regs *regs)
+static void vmx_window_test_db_handler(struct ex_regs *regs)
 {
-	vmx_window_test_ud_count++;
+	vmx_window_test_db_count++;
 }
 
 static void vmx_nmi_window_test_guest(void)
 {
-	handle_exception(UD_VECTOR, vmx_window_test_ud_handler);
+	handle_exception(DB_VECTOR, vmx_window_test_db_handler);
 
 	asm volatile("vmcall\n\t"
 		     "nop\n\t");
 
-	handle_exception(UD_VECTOR, NULL);
+	handle_exception(DB_VECTOR, NULL);
 }
 
 static void verify_nmi_window_exit(u64 rip)
@@ -7068,7 +7068,7 @@ static void verify_nmi_window_exit(u64 rip)
 static void vmx_nmi_window_test(void)
 {
 	u64 nop_addr;
-	void *ud_fault_addr = get_idt_addr(&boot_idt[UD_VECTOR]);
+	void *db_fault_addr = get_idt_addr(&boot_idt[DB_VECTOR]);
 
 	if (!(ctrl_pin_rev.clr & PIN_VIRT_NMI)) {
 		report_skip("CPU does not support the \"Virtual NMIs\" VM-execution control.");
@@ -7080,7 +7080,7 @@ static void vmx_nmi_window_test(void)
 		return;
 	}
 
-	vmx_window_test_ud_count = 0;
+	vmx_window_test_db_count = 0;
 
 	report_prefix_push("NMI-window");
 	test_set_guest(vmx_nmi_window_test_guest);
@@ -7113,27 +7113,27 @@ static void vmx_nmi_window_test(void)
 	/*
 	 * Ask for "NMI-window exiting" (with event injection), and
 	 * expect a VM-exit after the event is injected. (RIP should
-	 * be at the address specified in the IDT entry for #UD.)
+	 * be at the address specified in the IDT entry for #DB.)
 	 */
-	report_prefix_push("active, no blocking, injecting #UD");
+	report_prefix_push("active, no blocking, injecting #DB");
 	vmcs_write(ENT_INTR_INFO,
-		   INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION | UD_VECTOR);
+		   INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION | DB_VECTOR);
 	enter_guest();
-	verify_nmi_window_exit((u64)ud_fault_addr);
+	verify_nmi_window_exit((u64)db_fault_addr);
 	report_prefix_pop();
 
 	/*
 	 * Ask for "NMI-window exiting" with NMI blocking, and expect
-	 * a VM-exit after the next IRET (i.e. after the #UD handler
+	 * a VM-exit after the next IRET (i.e. after the #DB handler
 	 * returns). So, RIP should be back at one byte past the nop.
 	 */
 	report_prefix_push("active, blocking by NMI");
 	vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_NMI);
 	enter_guest();
 	verify_nmi_window_exit(nop_addr + 1);
-	report("#UD handler executed once (actual %d times)",
-	       vmx_window_test_ud_count == 1,
-	       vmx_window_test_ud_count);
+	report("#DB handler executed once (actual %d times)",
+	       vmx_window_test_db_count == 1,
+	       vmx_window_test_db_count);
 	report_prefix_pop();
 
 	if (!(rdmsr(MSR_IA32_VMX_MISC) & (1 << 6))) {
@@ -7154,15 +7154,15 @@ static void vmx_nmi_window_test(void)
 		 * Ask for "NMI-window exiting" when entering activity
 		 * state HLT (with event injection), and expect a
 		 * VM-exit after the event is injected. (RIP should be
-		 * at the address specified in the IDT entry for #UD.)
+		 * at the address specified in the IDT entry for #DB.)
 		 */
-		report_prefix_push("halted, no blocking, injecting #UD");
+		report_prefix_push("halted, no blocking, injecting #DB");
 		vmcs_write(GUEST_ACTV_STATE, ACTV_HLT);
 		vmcs_write(ENT_INTR_INFO,
 			   INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION |
-			   UD_VECTOR);
+			   DB_VECTOR);
 		enter_guest();
-		verify_nmi_window_exit((u64)ud_fault_addr);
+		verify_nmi_window_exit((u64)db_fault_addr);
 		report_prefix_pop();
 	}
 
@@ -7173,7 +7173,7 @@ static void vmx_nmi_window_test(void)
 
 static void vmx_intr_window_test_guest(void)
 {
-	handle_exception(UD_VECTOR, vmx_window_test_ud_handler);
+	handle_exception(DB_VECTOR, vmx_window_test_db_handler);
 
 	/*
 	 * The two consecutive STIs are to ensure that only the first
@@ -7185,7 +7185,7 @@ static void vmx_intr_window_test_guest(void)
 		     "sti\n\t"
 		     "sti\n\t");
 
-	handle_exception(UD_VECTOR, NULL);
+	handle_exception(DB_VECTOR, NULL);
 }
 
 static void verify_intr_window_exit(u64 rip)
@@ -7205,8 +7205,8 @@ static void vmx_intr_window_test(void)
 {
 	u64 vmcall_addr;
 	u64 nop_addr;
-	unsigned int orig_ud_gate_type;
-	void *ud_fault_addr = get_idt_addr(&boot_idt[UD_VECTOR]);
+	unsigned int orig_db_gate_type;
+	void *db_fault_addr = get_idt_addr(&boot_idt[DB_VECTOR]);
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_INTR_WINDOW)) {
 		report_skip("CPU does not support the \"interrupt-window exiting\" VM-execution control.");
@@ -7214,12 +7214,12 @@ static void vmx_intr_window_test(void)
 	}
 
 	/*
-	 * Change the IDT entry for #UD from interrupt gate to trap gate,
+	 * Change the IDT entry for #DB from interrupt gate to trap gate,
 	 * so that it won't clear RFLAGS.IF. We don't want interrupts to
-	 * be disabled after vectoring a #UD.
+	 * be disabled after vectoring a #DB.
 	 */
-	orig_ud_gate_type = boot_idt[UD_VECTOR].type;
-	boot_idt[UD_VECTOR].type = 15;
+	orig_db_gate_type = boot_idt[DB_VECTOR].type;
+	boot_idt[DB_VECTOR].type = 15;
 
 	report_prefix_push("interrupt-window");
 	test_set_guest(vmx_intr_window_test_guest);
@@ -7244,14 +7244,14 @@ static void vmx_intr_window_test(void)
 	 * Ask for "interrupt-window exiting" (with event injection)
 	 * with RFLAGS.IF set and no blocking; expect a VM-exit after
 	 * the event is injected. That is, RIP should should be at the
-	 * address specified in the IDT entry for #UD.
+	 * address specified in the IDT entry for #DB.
 	 */
-	report_prefix_push("active, no blocking, RFLAGS.IF=1, injecting #UD");
+	report_prefix_push("active, no blocking, RFLAGS.IF=1, injecting #DB");
 	vmcs_write(ENT_INTR_INFO,
-		   INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION | UD_VECTOR);
+		   INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION | DB_VECTOR);
 	vmcall_addr = vmcs_read(GUEST_RIP);
 	enter_guest();
-	verify_intr_window_exit((u64)ud_fault_addr);
+	verify_intr_window_exit((u64)db_fault_addr);
 	report_prefix_pop();
 
 	/*
@@ -7323,19 +7323,19 @@ static void vmx_intr_window_test(void)
 		 * activity state HLT (with event injection), and
 		 * expect a VM-exit after the event is injected. That
 		 * is, RIP should should be at the address specified
-		 * in the IDT entry for #UD.
+		 * in the IDT entry for #DB.
 		 */
-		report_prefix_push("halted, no blocking, injecting #UD");
+		report_prefix_push("halted, no blocking, injecting #DB");
 		vmcs_write(GUEST_ACTV_STATE, ACTV_HLT);
 		vmcs_write(ENT_INTR_INFO,
 			   INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION |
-			   UD_VECTOR);
+			   DB_VECTOR);
 		enter_guest();
-		verify_intr_window_exit((u64)ud_fault_addr);
+		verify_intr_window_exit((u64)db_fault_addr);
 		report_prefix_pop();
 	}
 
-	boot_idt[UD_VECTOR].type = orig_ud_gate_type;
+	boot_idt[DB_VECTOR].type = orig_db_gate_type;
 	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_INTR_WINDOW);
 	enter_guest();
 	report_prefix_pop();
-- 
2.17.1

