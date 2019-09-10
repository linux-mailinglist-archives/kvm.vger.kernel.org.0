Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02626AF141
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 20:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfIJSt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 14:49:26 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:43711 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfIJStZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 14:49:25 -0400
Received: by mail-pf1-f201.google.com with SMTP id i187so13740884pfc.10
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 11:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Dr8xkXNDT/zhoODue2+DxNalzbXghdJqV9hoE9dV0dQ=;
        b=HLdv739iJi72Bbw4VZjEbb6HN0lGBKBsYMHrm5uNyp92uGIxc+L4nA7WZDX9+A9GoA
         EwZJ/KdPxhh9GIVBAS/PEexxuJ0Td3BTGjrEbPhjzlPnB6SsWi0/3rqTtOcYxxYO7Wwj
         CPHJbHwTtgv9nY1kdEMs5hTBg5Am5BtJZciv535rJSUlMRnMvBvJa7vN4I8HhkoQQQla
         hTdvwf7ul0MfyE8Bv41Gj59ADN/JVq65lbQl05h2Fdc1Gg0A7zp/m0+pMYuHBUvQ5ns6
         RsJklb0NJz5uQ+LQLL4GRHLJwNt/MRmwMAZOFvtH/OvA0H+4EvBjOutkLqg84TZHX8LB
         GHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Dr8xkXNDT/zhoODue2+DxNalzbXghdJqV9hoE9dV0dQ=;
        b=dmh3raXbElwgP0HrxIICAnCsJ5NVbAU551CMNPfGl39BpBTa92E5Wgdh5G6V7116q3
         mppKFG7WldEGSenY1g2fnsh4wMP39R2RjIYr1UV/uBDikuf3SlNPzMy2mS5C755IJvD1
         Y9jPKzbxlwLuiIzC2D04PMYqe9oD7DA74cDzEzeZhr4kY8J6TlBgEtvhiqd/vQBWC7Z2
         Fvjs3Vf1geX7TiG69QllNhw5dpnmoS1yo4l6OVK31VqL8rqANdo2/U0ZxcczTTrLbA2o
         UJL2Jc7PcmvBL7CqtZ5ZvOE/RLuiGH4fNUqgdID8lG9Q1oFQyHcgluFI/uW6DKMs7dPH
         dYrg==
X-Gm-Message-State: APjAAAVnNJFcf+T/vlECaaGqzDU0xNRraM5e3MlnTwAK13Sq7+WBSwoz
        5C5IXpgoZu4d07GxcNJa2/9ELay/Oii6stgs5gDJWo1xRZZ+Hyqp90ZIlpjBkLaDqW/2hqsqi8R
        xbyVnq7qnnuO20pQYKapq9sP+PkAnvhgabWteXcIPjz4zVX5nt4NKnqhIOapK2SU=
X-Google-Smtp-Source: APXvYqzZy7aTHOKdremR4+DykF0jAQqVDQZKx7PZTLTXhw70bqJHzhk5ssMirNgG/cDsI+K7Neyr6BTaiG/yFQ==
X-Received: by 2002:a63:7b16:: with SMTP id w22mr2977941pgc.328.1568141363775;
 Tue, 10 Sep 2019 11:49:23 -0700 (PDT)
Date:   Tue, 10 Sep 2019 11:49:16 -0700
Message-Id: <20190910184916.50282-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
Subject: [kvm-unit-tests PATCH] x86: Skip APIC-access address tests beyond
 mapped RAM
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We no longer have any tests in vmx_tests.c that use
xfail_beyond_mapped_ram. However, an upcoming change to kvm will exit
to userspace with a kvm internal error whenever launching a nested VM
with the vmcs12 APIC-access address set to a non-cacheable address in
L1. Reuse the xfail_beyond_mapped_ram plumbing to support
skip_beyond_mapped_ram, and skip any APIC-access address tests that
use addresses beyond mapped RAM, so that the test won't induce a kvm
internal error.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx_tests.c | 289 +++++++++++++++++++++++-------------------------
 1 file changed, 139 insertions(+), 150 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f035f24..5633823 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3351,13 +3351,13 @@ success:
 /*
  * Try to launch the current VMCS.
  */
-static void test_vmx_vmlaunch(u32 xerror, bool xfail)
+static void test_vmx_vmlaunch(u32 xerror)
 {
 	bool success = vmlaunch_succeeds();
 	u32 vmx_inst_err;
 
-	report_xfail("vmlaunch %s", xfail, success == !xerror,
-		     !xerror ? "succeeds" : "fails");
+	report("vmlaunch %s", success == !xerror,
+	       !xerror ? "succeeds" : "fails");
 	if (!success && xerror) {
 		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
 		report("VMX inst error is %d (actual %d)",
@@ -3365,14 +3365,14 @@ static void test_vmx_vmlaunch(u32 xerror, bool xfail)
 	}
 }
 
-static void test_vmx_invalid_controls(bool xfail)
+static void test_vmx_invalid_controls(void)
 {
-	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_CONTROL_FIELD, xfail);
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 }
 
-static void test_vmx_valid_controls(bool xfail)
+static void test_vmx_valid_controls(void)
 {
-	test_vmx_vmlaunch(0, xfail);
+	test_vmx_vmlaunch(0);
 }
 
 /*
@@ -3410,9 +3410,9 @@ static void test_rsvd_ctl_bit_value(const char *name, union vmx_ctrl_msr msr,
 		expected = !(msr.set & mask);
 	}
 	if (expected)
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 	else
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	vmcs_write(encoding, controls);
 	report_prefix_pop();
 }
@@ -3509,9 +3509,9 @@ static void try_cr3_target_count(unsigned i, unsigned max)
 	report_prefix_pushf("CR3 target count 0x%x", i);
 	vmcs_write(CR3_TARGET_COUNT, i);
 	if (i <= max)
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 	else
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	report_prefix_pop();
 }
 
@@ -3546,23 +3546,21 @@ static void test_vmcs_addr(const char *name,
 			   enum Encoding encoding,
 			   u64 align,
 			   bool ignored,
-			   bool xfail_beyond_mapped_ram,
+			   bool skip_beyond_mapped_ram,
 			   u64 addr)
 {
-	bool xfail =
-		(xfail_beyond_mapped_ram &&
-		 addr > fwcfg_get_u64(FW_CFG_RAM_SIZE) - align &&
-		 addr < (1ul << cpuid_maxphyaddr()));
-
 	report_prefix_pushf("%s = %lx", name, addr);
 	vmcs_write(encoding, addr);
-	if (ignored || (IS_ALIGNED(addr, align) &&
+	if (skip_beyond_mapped_ram &&
+	    addr > fwcfg_get_u64(FW_CFG_RAM_SIZE) - align &&
+	    addr < (1ul << cpuid_maxphyaddr()))
+		printf("Skipping physical address beyond mapped RAM\n");
+	else if (ignored || (IS_ALIGNED(addr, align) &&
 	    addr < (1ul << cpuid_maxphyaddr())))
-		test_vmx_valid_controls(xfail);
+		test_vmx_valid_controls();
 	else
-		test_vmx_invalid_controls(xfail);
+		test_vmx_invalid_controls();
 	report_prefix_pop();
-	xfail = false;
 }
 
 /*
@@ -3572,7 +3570,7 @@ static void test_vmcs_addr_values(const char *name,
 				  enum Encoding encoding,
 				  u64 align,
 				  bool ignored,
-				  bool xfail_beyond_mapped_ram,
+				  bool skip_beyond_mapped_ram,
 				  u32 bit_start, u32 bit_end)
 {
 	unsigned i;
@@ -3580,17 +3578,17 @@ static void test_vmcs_addr_values(const char *name,
 
 	for (i = bit_start; i <= bit_end; i++)
 		test_vmcs_addr(name, encoding, align, ignored,
-			       xfail_beyond_mapped_ram, 1ul << i);
+			       skip_beyond_mapped_ram, 1ul << i);
 
 	test_vmcs_addr(name, encoding, align, ignored,
-		       xfail_beyond_mapped_ram, PAGE_SIZE - 1);
+		       skip_beyond_mapped_ram, PAGE_SIZE - 1);
 	test_vmcs_addr(name, encoding, align, ignored,
-		       xfail_beyond_mapped_ram, PAGE_SIZE);
+		       skip_beyond_mapped_ram, PAGE_SIZE);
 	test_vmcs_addr(name, encoding, align, ignored,
-		       xfail_beyond_mapped_ram,
+		       skip_beyond_mapped_ram,
 		      (1ul << cpuid_maxphyaddr()) - PAGE_SIZE);
 	test_vmcs_addr(name, encoding, align, ignored,
-		       xfail_beyond_mapped_ram, -1ul);
+		       skip_beyond_mapped_ram, -1ul);
 
 	vmcs_write(encoding, orig_val);
 }
@@ -3602,7 +3600,7 @@ static void test_vmcs_addr_values(const char *name,
 static void test_vmcs_addr_reference(u32 control_bit, enum Encoding field,
 				     const char *field_name,
 				     const char *control_name, u64 align,
-				     bool xfail_beyond_mapped_ram,
+				     bool skip_beyond_mapped_ram,
 				     bool control_primary)
 {
 	u32 primary = vmcs_read(CPU_EXEC_CTRL0);
@@ -3628,7 +3626,7 @@ static void test_vmcs_addr_reference(u32 control_bit, enum Encoding field,
 	}
 
 	test_vmcs_addr_values(field_name, field, align, false,
-			      xfail_beyond_mapped_ram, 0, 63);
+			      skip_beyond_mapped_ram, 0, 63);
 	report_prefix_pop();
 
 	report_prefix_pushf("%s disabled", control_name);
@@ -3716,7 +3714,7 @@ static void test_apic_access_addr(void)
 	test_vmcs_addr_reference(CPU_VIRT_APIC_ACCESSES, APIC_ACCS_ADDR,
 				 "APIC-access address",
 				 "virtualize APIC-accesses", PAGE_SIZE,
-				 false, false);
+				 true, false);
 }
 
 static bool set_bit_pattern(u8 mask, u32 *secondary)
@@ -3789,9 +3787,9 @@ static void test_apic_virtual_ctls(void)
 			report_prefix_pushf("Use TPR shadow %s, virtualize x2APIC mode %s, APIC-register virtualization %s, virtual-interrupt delivery %s",
 				str, (secondary & CPU_VIRT_X2APIC) ? "enabled" : "disabled", (secondary & CPU_APIC_REG_VIRT) ? "enabled" : "disabled", (secondary & CPU_VINTD) ? "enabled" : "disabled");
 			if (ctrl)
-				test_vmx_valid_controls(false);
+				test_vmx_valid_controls();
 			else
-				test_vmx_invalid_controls(false);
+				test_vmx_invalid_controls();
 			report_prefix_pop();
 		}
 
@@ -3818,22 +3816,22 @@ static void test_apic_virtual_ctls(void)
 	secondary &= ~CPU_VIRT_APIC_ACCESSES;
 	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VIRT_X2APIC);
 	report_prefix_pushf("Virtualize x2APIC mode disabled; virtualize APIC access disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VIRT_APIC_ACCESSES);
 	report_prefix_pushf("Virtualize x2APIC mode disabled; virtualize APIC access enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VIRT_X2APIC);
 	report_prefix_pushf("Virtualize x2APIC mode enabled; virtualize APIC access enabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VIRT_APIC_ACCESSES);
 	report_prefix_pushf("Virtualize x2APIC mode enabled; virtualize APIC access disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL0, saved_primary);
@@ -3862,22 +3860,22 @@ static void test_virtual_intr_ctls(void)
 	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VINTD);
 	vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
 	report_prefix_pushf("Virtualize interrupt-delivery disabled; external-interrupt exiting disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VINTD);
 	report_prefix_pushf("Virtualize interrupt-delivery enabled; external-interrupt exiting disabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, pin | PIN_EXTINT);
 	report_prefix_pushf("Virtualize interrupt-delivery enabled; external-interrupt exiting enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
 	report_prefix_pushf("Virtualize interrupt-delivery enabled; external-interrupt exiting disabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL0, saved_primary);
@@ -3890,9 +3888,9 @@ static void test_pi_desc_addr(u64 addr, bool ctrl)
 	vmcs_write(POSTED_INTR_DESC_ADDR, addr);
 	report_prefix_pushf("Process-posted-interrupts enabled; posted-interrupt-descriptor-address 0x%lx", addr);
 	if (ctrl)
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 	else
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	report_prefix_pop();
 }
 
@@ -3937,37 +3935,37 @@ static void test_posted_intr(void)
 	secondary &= ~CPU_VINTD;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery disabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	secondary |= CPU_VINTD;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	exit_ctl &= ~EXI_INTA;
 	vmcs_write(EXI_CONTROLS, exit_ctl);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled; acknowledge-interrupt-on-exit disabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	exit_ctl |= EXI_INTA;
 	vmcs_write(EXI_CONTROLS, exit_ctl);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled; acknowledge-interrupt-on-exit enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	secondary &= ~CPU_VINTD;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery disabled; acknowledge-interrupt-on-exit enabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	secondary |= CPU_VINTD;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled; acknowledge-interrupt-on-exit enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	/*
@@ -3977,21 +3975,21 @@ static void test_posted_intr(void)
 		vec = (1ul << i);
 		vmcs_write(PINV, vec);
 		report_prefix_pushf("Process-posted-interrupts enabled; posted-interrupt-notification-vector %u", vec);
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 		report_prefix_pop();
 	}
 	for (i = 8; i < 16; i++) {
 		vec = (1ul << i);
 		vmcs_write(PINV, vec);
 		report_prefix_pushf("Process-posted-interrupts enabled; posted-interrupt-notification-vector %u", vec);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 
 	vec &= ~(0xff << 8);
 	vmcs_write(PINV, vec);
 	report_prefix_pushf("Process-posted-interrupts enabled; posted-interrupt-notification-vector %u", vec);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	/*
@@ -4048,19 +4046,19 @@ static void test_vpid(void)
 	vmcs_write(CPU_EXEC_CTRL1, saved_secondary & ~CPU_VPID);
 	vmcs_write(VPID, vpid);
 	report_prefix_pushf("VPID disabled; VPID value %x", vpid);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL1, saved_secondary | CPU_VPID);
 	report_prefix_pushf("VPID enabled; VPID value %x", vpid);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	for (i = 0; i < 16; i++) {
 		vpid = (short)1 << i;;
 		vmcs_write(VPID, vpid);
 		report_prefix_pushf("VPID enabled; VPID value %x", vpid);
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 		report_prefix_pop();
 	}
 
@@ -4088,9 +4086,9 @@ static void try_tpr_threshold_and_vtpr(unsigned threshold, unsigned vtpr)
 	report_prefix_pushf("TPR threshold 0x%x, VTPR.class 0x%x",
 	    threshold, (vtpr >> 4) & 0xf);
 	if (valid)
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 	else
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	report_prefix_pop();
 }
 
@@ -4117,7 +4115,7 @@ static void test_invalid_event_injection(void)
 			    "RESERVED interruption type invalid [-]",
 			    ent_intr_info);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	ent_intr_info = ent_intr_info_base | INTR_TYPE_EXT_INTR |
@@ -4126,7 +4124,7 @@ static void test_invalid_event_injection(void)
 			    "RESERVED interruption type invalid [+]",
 			    ent_intr_info);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	/* If the interruption type is other event, the vector is 0. */
@@ -4135,7 +4133,7 @@ static void test_invalid_event_injection(void)
 			    "(OTHER EVENT && vector != 0) invalid [-]",
 			    ent_intr_info);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	/* If the interruption type is NMI, the vector is 2 (negative case). */
@@ -4143,7 +4141,7 @@ static void test_invalid_event_injection(void)
 	report_prefix_pushf("%s, VM-entry intr info=0x%x",
 			    "(NMI && vector != 2) invalid [-]", ent_intr_info);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	/* If the interruption type is NMI, the vector is 2 (positive case). */
@@ -4151,7 +4149,7 @@ static void test_invalid_event_injection(void)
 	report_prefix_pushf("%s, VM-entry intr info=0x%x",
 			    "(NMI && vector == 2) valid [+]", ent_intr_info);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	/*
@@ -4163,7 +4161,7 @@ static void test_invalid_event_injection(void)
 			    "(HW exception && vector > 31) invalid [-]",
 			    ent_intr_info);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	/*
@@ -4183,7 +4181,7 @@ static void test_invalid_event_injection(void)
 			    ent_intr_info);
 	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	ent_intr_info = ent_intr_info_base | INTR_INFO_DELIVER_CODE_MASK |
@@ -4193,7 +4191,7 @@ static void test_invalid_event_injection(void)
 			    ent_intr_info);
 	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	if (enable_unrestricted_guest())
@@ -4206,7 +4204,7 @@ static void test_invalid_event_injection(void)
 			    ent_intr_info);
 	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	ent_intr_info = ent_intr_info_base | INTR_TYPE_HARD_EXCEPTION |
@@ -4216,7 +4214,7 @@ static void test_invalid_event_injection(void)
 			    ent_intr_info);
 	vmcs_write(GUEST_CR0, guest_cr0_save | X86_CR0_PE);
 	vmcs_write(ENT_INTR_INFO, ent_intr_info);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary_save);
@@ -4238,7 +4236,7 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr info=0x%x [-]",
 				    ent_intr_info);
 		vmcs_write(ENT_INTR_INFO, ent_intr_info);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 	report_prefix_pop();
@@ -4272,7 +4270,7 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr info=0x%x [-]",
 				    ent_intr_info);
 		vmcs_write(ENT_INTR_INFO, ent_intr_info);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 
 		/* Positive case */
@@ -4284,7 +4282,7 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr info=0x%x [+]",
 				    ent_intr_info);
 		vmcs_write(ENT_INTR_INFO, ent_intr_info);
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 		report_prefix_pop();
 	}
 	report_prefix_pop();
@@ -4299,7 +4297,7 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr info=0x%x [-]",
 				    ent_intr_info);
 		vmcs_write(ENT_INTR_INFO, ent_intr_info);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 	report_prefix_pop();
@@ -4319,7 +4317,7 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr error=0x%x [-]",
 				    ent_intr_err);
 		vmcs_write(ENT_INTR_ERROR, ent_intr_err);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 	vmcs_write(ENT_INTR_ERROR, 0x00000000);
@@ -4356,7 +4354,7 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr length = 0x%x [-]",
 				    ent_intr_len);
 		vmcs_write(ENT_INST_LEN, ent_intr_len);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 
 		/* Instruction length set to 16 should fail */
@@ -4364,7 +4362,7 @@ skip_unrestricted_guest:
 		report_prefix_pushf("VM-entry intr length = 0x%x [-]",
 				    ent_intr_len);
 		vmcs_write(ENT_INST_LEN, 0x00000010);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 
 		report_prefix_pop();
@@ -4405,9 +4403,9 @@ static void try_tpr_threshold(unsigned threshold)
 	vmcs_write(TPR_THRESHOLD, threshold);
 	report_prefix_pushf("TPR threshold 0x%x, VTPR.class 0xf", threshold);
 	if (valid)
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 	else
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	if (valid)
@@ -4557,22 +4555,22 @@ static void test_nmi_ctrls(void)
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls);
 	report_prefix_pushf("NMI-exiting disabled, virtual-NMIs disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_VIRT_NMI);
 	report_prefix_pushf("NMI-exiting disabled, virtual-NMIs enabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
 	report_prefix_pushf("NMI-exiting enabled, virtual-NMIs enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_NMI);
 	report_prefix_pushf("NMI-exiting enabled, virtual-NMIs disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_NMI_WINDOW)) {
@@ -4583,25 +4581,25 @@ static void test_nmi_ctrls(void)
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls);
 	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 | CPU_NMI_WINDOW);
 	report_prefix_pushf("Virtual-NMIs disabled, NMI-window-exiting enabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls);
 	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0);
 	report_prefix_pushf("Virtual-NMIs disabled, NMI-window-exiting disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
 	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 | CPU_NMI_WINDOW);
 	report_prefix_pushf("Virtual-NMIs enabled, NMI-window-exiting enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
 	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0);
 	report_prefix_pushf("Virtual-NMIs enabled, NMI-window-exiting disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	/* Restore the controls to their original values */
@@ -4616,9 +4614,9 @@ static void test_eptp_ad_bit(u64 eptp, bool ctrl)
 	report_prefix_pushf("Enable-EPT enabled; EPT accessed and dirty flag %s",
 	    (eptp & EPTP_AD_FLAG) ? "1": "0");
 	if (ctrl)
-		test_vmx_valid_controls(false);
+		test_vmx_valid_controls();
 	else
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	report_prefix_pop();
 
 }
@@ -4702,9 +4700,9 @@ static void test_ept_eptp(void)
 		report_prefix_pushf("Enable-EPT enabled; EPT memory type %lu",
 		    eptp & EPT_MEM_TYPE_MASK);
 		if (ctrl)
-			test_vmx_valid_controls(false);
+			test_vmx_valid_controls();
 		else
-			test_vmx_invalid_controls(false);
+			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 
@@ -4725,9 +4723,9 @@ static void test_ept_eptp(void)
 		report_prefix_pushf("Enable-EPT enabled; EPT page walk length %lu",
 		    eptp & EPTP_PG_WALK_LEN_MASK);
 		if (ctrl)
-			test_vmx_valid_controls(false);
+			test_vmx_valid_controls();
 		else
-			test_vmx_invalid_controls(false);
+			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 
@@ -4765,9 +4763,9 @@ static void test_ept_eptp(void)
 		    (eptp >> EPTP_RESERV_BITS_SHIFT) &
 		    EPTP_RESERV_BITS_MASK);
 		if (i == 0)
-			test_vmx_valid_controls(false);
+			test_vmx_valid_controls();
 		else
-			test_vmx_invalid_controls(false);
+			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 
@@ -4785,16 +4783,16 @@ static void test_ept_eptp(void)
 		report_prefix_pushf("Enable-EPT enabled; reserved bits [63:N] %lu",
 		    (eptp >> maxphysaddr) & resv_bits_mask);
 		if (j < maxphysaddr)
-			test_vmx_valid_controls(false);
+			test_vmx_valid_controls();
 		else
-			test_vmx_invalid_controls(false);
+			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 
 	secondary &= ~(CPU_EPT | CPU_URG);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT disabled, unrestricted-guest disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	if (!(ctrl_cpu_rev[1].clr & CPU_URG))
@@ -4803,20 +4801,20 @@ static void test_ept_eptp(void)
 	secondary |= CPU_URG;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT disabled, unrestricted-guest enabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	secondary |= CPU_EPT;
 	setup_dummy_ept();
 	report_prefix_pushf("Enable-EPT enabled, unrestricted-guest enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 skip_unrestricted_guest:
 	secondary &= ~CPU_URG;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT enabled, unrestricted-guest disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(CPU_EXEC_CTRL0, primary_saved);
@@ -4853,25 +4851,25 @@ static void test_pml(void)
 	secondary &= ~(CPU_PML | CPU_EPT);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("enable-PML disabled, enable-EPT disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	secondary |= CPU_PML;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("enable-PML enabled, enable-EPT disabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	secondary |= CPU_EPT;
 	setup_dummy_ept();
 	report_prefix_pushf("enable-PML enabled, enable-EPT enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	secondary &= ~CPU_PML;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("enable-PML disabled, enable EPT enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	test_vmcs_addr_reference(CPU_PML, PMLADDR, "PML address", "PML",
@@ -4905,25 +4903,25 @@ static void test_vmx_preemption_timer(void)
 	exit &= ~EXI_SAVE_PREEMPT;
 	vmcs_write(EXI_CONTROLS, exit);
 	report_prefix_pushf("enable-VMX-preemption-timer enabled, save-VMX-preemption-timer disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	exit |= EXI_SAVE_PREEMPT;
 	vmcs_write(EXI_CONTROLS, exit);
 	report_prefix_pushf("enable-VMX-preemption-timer enabled, save-VMX-preemption-timer enabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	pin &= ~PIN_PREEMPT;
 	vmcs_write(PIN_CONTROLS, pin);
 	report_prefix_pushf("enable-VMX-preemption-timer disabled, save-VMX-preemption-timer enabled");
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	report_prefix_pop();
 
 	exit &= ~EXI_SAVE_PREEMPT;
 	vmcs_write(EXI_CONTROLS, exit);
 	report_prefix_pushf("enable-VMX-preemption-timer disabled, save-VMX-preemption-timer disabled");
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, saved_pin);
@@ -4983,7 +4981,7 @@ static void test_entry_msr_load(void)
 		vmcs_write(ENTER_MSR_LD_ADDR, tmp);
 		report_prefix_pushf("VM-entry MSR-load addr [4:0] %lx",
 				    tmp & 0xf);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 
@@ -5005,16 +5003,16 @@ static void test_entry_msr_load(void)
 			1ul << i;
 		vmcs_write(ENTER_MSR_LD_ADDR,
 			   tmp - (entry_msr_ld_cnt * 16 - 1));
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	}
 
 	vmcs_write(ENT_MSR_LD_CNT, 2);
 	vmcs_write(ENTER_MSR_LD_ADDR, (1ULL << cpuid_maxphyaddr()) - 16);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	vmcs_write(ENTER_MSR_LD_ADDR, (1ULL << cpuid_maxphyaddr()) - 32);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	vmcs_write(ENTER_MSR_LD_ADDR, (1ULL << cpuid_maxphyaddr()) - 48);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 }
 
 static void guest_state_test_main(void)
@@ -5088,7 +5086,7 @@ static void test_exit_msr_store(void)
 		vmcs_write(EXIT_MSR_ST_ADDR, tmp);
 		report_prefix_pushf("VM-exit MSR-store addr [4:0] %lx",
 				    tmp & 0xf);
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
 
@@ -5110,16 +5108,16 @@ static void test_exit_msr_store(void)
 			1ul << i;
 		vmcs_write(EXIT_MSR_ST_ADDR,
 			   tmp - (exit_msr_st_cnt * 16 - 1));
-		test_vmx_invalid_controls(false);
+		test_vmx_invalid_controls();
 	}
 
 	vmcs_write(EXI_MSR_ST_CNT, 2);
 	vmcs_write(EXIT_MSR_ST_ADDR, (1ULL << cpuid_maxphyaddr()) - 16);
-	test_vmx_invalid_controls(false);
+	test_vmx_invalid_controls();
 	vmcs_write(EXIT_MSR_ST_ADDR, (1ULL << cpuid_maxphyaddr()) - 32);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 	vmcs_write(EXIT_MSR_ST_ADDR, (1ULL << cpuid_maxphyaddr()) - 48);
-	test_vmx_valid_controls(false);
+	test_vmx_valid_controls();
 }
 
 /*
@@ -6616,12 +6614,12 @@ static void test_sysenter_field(u32 field, const char *name)
 
 	vmcs_write(field, NONCANONICAL);
 	report_prefix_pushf("%s non-canonical", name);
-	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	report_prefix_pop();
 
 	vmcs_write(field, 0xffffffff);
 	report_prefix_pushf("%s canonical", name);
-	test_vmx_vmlaunch(0, false);
+	test_vmx_vmlaunch(0);
 	report_prefix_pop();
 
 	vmcs_write(field, addr_saved);
@@ -6640,10 +6638,9 @@ static void test_ctl_reg(const char *cr_name, u64 cr, u64 fixed0, u64 fixed1)
 		vmcs_write(cr, val);
 	report_prefix_pushf("%s %lx", cr_name, val);
 	if (val == fixed0)
-		test_vmx_vmlaunch(0, false);
+		test_vmx_vmlaunch(0);
 	else
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	report_prefix_pop();
 
 	for (i = 0; i < 64; i++) {
@@ -6658,8 +6655,7 @@ static void test_ctl_reg(const char *cr_name, u64 cr, u64 fixed0, u64 fixed1)
 			report_prefix_pushf("%s %llx", cr_name,
 						cr_saved | (1ull << i));
 			test_vmx_vmlaunch(
-					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-					false);
+				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 			report_prefix_pop();
 		}
 
@@ -6669,8 +6665,7 @@ static void test_ctl_reg(const char *cr_name, u64 cr, u64 fixed0, u64 fixed1)
 			report_prefix_pushf("%s %llx", cr_name,
 						cr_saved & ~(1ull << i));
 			test_vmx_vmlaunch(
-					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-					false);
+				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 			report_prefix_pop();
 		}
 	}
@@ -6711,8 +6706,7 @@ static void test_host_ctl_regs(void)
 		cr3 = cr3_saved | (1ul << i);
 		vmcs_write(HOST_CR3, cr3);
 		report_prefix_pushf("HOST_CR3 %lx", cr3);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 		report_prefix_pop();
 	}
 
@@ -6733,14 +6727,14 @@ static void test_efer_bit(u32 fld, const char * fld_name, u32 ctrl_fld,
 	vmcs_write(fld, efer);
 	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
 			    fld_name, efer);
-	test_vmx_vmlaunch(0, false);
+	test_vmx_vmlaunch(0);
 	report_prefix_pop();
 
 	efer = efer_saved | efer_bit;
 	vmcs_write(fld, efer);
 	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
 			    fld_name, efer);
-	test_vmx_vmlaunch(0, false);
+	test_vmx_vmlaunch(0);
 	report_prefix_pop();
 
 	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
@@ -6749,10 +6743,9 @@ static void test_efer_bit(u32 fld, const char * fld_name, u32 ctrl_fld,
 	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
 			    fld_name, efer);
 	if (host_addr_size)
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	else
-		test_vmx_vmlaunch(0, false);
+		test_vmx_vmlaunch(0);
 	report_prefix_pop();
 
 	efer = efer_saved | efer_bit;
@@ -6760,10 +6753,9 @@ static void test_efer_bit(u32 fld, const char * fld_name, u32 ctrl_fld,
 	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
 			    fld_name, efer);
 	if (host_addr_size)
-		test_vmx_vmlaunch(0, false);
+		test_vmx_vmlaunch(0);
 	else
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	report_prefix_pop();
 
 	vmcs_write(ctrl_fld, ctrl_saved);
@@ -6791,7 +6783,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 			efer = efer_saved | (1ull << i);
 			vmcs_write(fld, efer);
 			report_prefix_pushf("%s %lx", fld_name, efer);
-			test_vmx_vmlaunch(0, false);
+			test_vmx_vmlaunch(0);
 			report_prefix_pop();
 		}
 	}
@@ -6803,8 +6795,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 			vmcs_write(fld, efer);
 			report_prefix_pushf("%s %lx", fld_name, efer);
 			test_vmx_vmlaunch(
-				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				false);
+				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 			report_prefix_pop();
 		}
 	}
@@ -6868,7 +6859,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 			vmcs_write(field, val);
 			if (field == HOST_PAT) {
 				report_prefix_pushf("%s %lx", field_name, val);
-				test_vmx_vmlaunch(0, false);
+				test_vmx_vmlaunch(0);
 				report_prefix_pop();
 
 			} else {	// GUEST_PAT
@@ -6895,7 +6886,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 				else
 					error = 0;
 
-				test_vmx_vmlaunch(error, false);
+				test_vmx_vmlaunch(error);
 				report_prefix_pop();
 
 			} else {	// GUEST_PAT
@@ -6981,9 +6972,9 @@ static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
 	vmcs_write(field, tmp);
 	report_prefix_pushf("%s %lx", field_name, tmp);
 	if (valid_val)
-		test_vmx_vmlaunch(0, false);
+		test_vmx_vmlaunch(0);
 	else
-		test_vmx_vmlaunch(error, false);
+		test_vmx_vmlaunch(error);
 	report_prefix_pop();
 
 	for (i = bit_start; i <= bit_end; i = i + 2) {
@@ -6995,9 +6986,9 @@ static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
 		vmcs_write(field, tmp);
 		report_prefix_pushf("%s %lx", field_name, tmp);
 		if (valid_val)
-			test_vmx_vmlaunch(error, false);
+			test_vmx_vmlaunch(error);
 		else
-			test_vmx_vmlaunch(0, false);
+			test_vmx_vmlaunch(0);
 		report_prefix_pop();
 	}
 
@@ -7011,19 +7002,17 @@ static void test_canonical(u64 field, const char * field_name)
 
 	report_prefix_pushf("%s %lx", field_name, addr);
 	if (is_canonical(addr)) {
-		test_vmx_vmlaunch(0, false);
+		test_vmx_vmlaunch(0);
 		report_prefix_pop();
 
 		addr = make_non_canonical(addr);
 		vmcs_write(field, addr);
 		report_prefix_pushf("%s %lx", field_name, addr);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 
 		vmcs_write(field, addr_saved);
 	} else {
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	}
 	report_prefix_pop();
 }
@@ -7076,14 +7065,14 @@ static void test_host_segment_regs(void)
 	vmcs_write(HOST_SEL_SS, 0);
 	if (exit_ctrl_saved & EXI_HOST_64) {
 		report_prefix_pushf("HOST_SEL_SS 0");
-		test_vmx_vmlaunch(0, false);
+		test_vmx_vmlaunch(0);
 		report_prefix_pop();
 
 		vmcs_write(EXI_CONTROLS, exit_ctrl_saved & ~EXI_HOST_64);
 	}
 
 	report_prefix_pushf("HOST_SEL_SS 0");
-	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	report_prefix_pop();
 
 	vmcs_write(HOST_SEL_SS, selector_saved);
-- 
2.23.0.162.g0b9fbb3734-goog

