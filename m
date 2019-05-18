Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4862B2258A
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfERXWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:22:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37099 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbfERXWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:22:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id g3so5413956pfi.4
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VQsEJ7wfzzufKKEATtYwc18ov4pdRn18iIzHWM6iIc8=;
        b=GZrM4JuMdUP+5LO274WzhNdtaXgrt5WSUNToYiUX0H+03ZUb7jX6cVzfzCuJpafcVu
         aB6zUEmGPzx65drAKAeDCBRCveEAc+rum5SN6W886Hgr+APTGGVPSYEjA3Jrad/uS8PX
         RfbSZWUIR9me17jpakBugXaiJtwtWSXs+jSqTO5nVlevRMsjbEX9P0WtugwaHXkueQOJ
         BjWEfO/71RKYrR+s9PtTuOIommZYTMOK9wa67PafUvt+7vswcJwW7qn6SnnxjYB01wKD
         GEfiE4HH0eZhAEnSvGA2/ywbhjVFGygWTdC5s1ayNHjyImDDECWv8IJISwr6uY43XUxh
         z2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VQsEJ7wfzzufKKEATtYwc18ov4pdRn18iIzHWM6iIc8=;
        b=VrWzBxUwRzFUjo/YytEOTQYtacrSZlKyMfFxyJf3neZ3x/baPNMVmGt7mgE9cpOrVR
         i4L0kcfZNJALwdr7DdaemVH8e2tFkxoaHqL7AYoxFz4i11fBEjXboXTCxnd7bAyMhgdk
         0ylnCaCnULcPxKGeoaXiLq+4aIqplJBmBsyMRXLNqq7ApanLl3mIt9QVv7wsoqBT+f6h
         aZtY1onATSdcjZ0lq5U1myrMrb7m528NSrW8WINCBBMnGNET+8yfEijC9Y1vdt6yyZ8k
         XlDyunHK/VusxmILjpACl/n+1sKQKpWvBMClic9/iJV5m7EhAHntMJ/imZHDxtOK6RYu
         lM5A==
X-Gm-Message-State: APjAAAUUxO2cmRyg0iwhlFln5gGZtY0tY4UHyTng4DXeBQhN/cHlflsn
        VYz58AoWfg3FD6hPPISP6EE=
X-Google-Smtp-Source: APXvYqwfI7KfeyawAJp6y1neCi4NyMNu1zKDyT/sMsWjTFvS+aRkPVuY0xg2kjSj9gtE8DZZ9eEXUA==
X-Received: by 2002:a62:d244:: with SMTP id c65mr32599784pfg.173.1558221751038;
        Sat, 18 May 2019 16:22:31 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x17sm20496352pgh.47.2019.05.18.16.22.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:22:29 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH v2 1/2] x86: nVMX: Use #DB in nmi- and intr-window tests
Date:   Sat, 18 May 2019 09:02:30 -0700
Message-Id: <20190518160231.4063-2-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190518160231.4063-1-nadav.amit@gmail.com>
References: <20190518160231.4063-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to Intel SDM 26.3.1.5 "Checks on Guest Non-Register State", if
the activity state is HLT, the only events that can be injected are NMI,
MTF and "Those with interruption type hardware exception and vector 1
(debug exception) or vector 18 (machine-check exception)."

Theverify_nmi_window_exit() and verify_intr_window_exit() tests try
to do something that real hardware disallows (i.e., fail the VM-entry)
by injecting #UD in HLT-state.  Inject #DB instead as the injection
should succeed in these tests.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
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

