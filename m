Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4BD183D4D
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgCLX1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:14954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgCLX1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705939"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 5/8] nVMX: Expose __enter_guest() and consolidate guest state test code
Date:   Thu, 12 Mar 2020 16:27:42 -0700
Message-Id: <20200312232745.884-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose __enter_guest() outside of vmx.c and use it in a new wrapper for
testing guest state.  Handling both success and failure paths in a
common helper eliminates a lot of boilerplate code in the tests
themselves.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c       |  12 +----
 x86/vmx.h       |   5 ++-
 x86/vmx_tests.c | 115 +++++++++++++++---------------------------------
 3 files changed, 40 insertions(+), 92 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index d92350d..1c837f0 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1840,14 +1840,11 @@ static void check_for_guest_termination(void)
 	}
 }
 
-#define        ABORT_ON_EARLY_VMENTRY_FAIL     0x1
-#define        ABORT_ON_INVALID_GUEST_STATE    0x2
-
 /*
  * Enters the guest (or launches it for the first time). Error to call once the
  * guest has returned (i.e., run past the end of its guest() function).
  */
-static void __enter_guest(u8 abort_flag, struct vmentry_result *result)
+void __enter_guest(u8 abort_flag, struct vmentry_result *result)
 {
 	TEST_ASSERT_MSG(v2_guest_main,
 			"Never called test_set_guest_func!");
@@ -1905,13 +1902,6 @@ void enter_guest(void)
 		      ABORT_ON_INVALID_GUEST_STATE, &result);
 }
 
-void enter_guest_with_invalid_guest_state(void)
-{
-	struct vmentry_result result;
-
-	__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL, &result);
-}
-
 extern struct vmx_test vmx_tests[];
 
 static bool
diff --git a/x86/vmx.h b/x86/vmx.h
index c4a0fb4..73979f7 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -855,9 +855,12 @@ bool ept_huge_pages_supported(int level);
 bool ept_execute_only_supported(void);
 bool ept_ad_bits_supported(void);
 
+#define        ABORT_ON_EARLY_VMENTRY_FAIL     0x1
+#define        ABORT_ON_INVALID_GUEST_STATE    0x2
+
+void __enter_guest(u8 abort_flag, struct vmentry_result *result);
 void enter_guest(void);
 void enter_guest_with_bad_controls(void);
-void enter_guest_with_invalid_guest_state(void);
 
 typedef void (*test_guest_func)(void);
 typedef void (*test_teardown_func)(void *data);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ac02b9d..5befcd3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5239,23 +5239,25 @@ static void guest_state_test_main(void)
 	asm volatile("fnop");
 }
 
-static void advance_guest_state_test(void)
+static void test_guest_state(const char *test, bool xfail, u64 field,
+			     const char * field_name)
 {
-	u32 reason = vmcs_read(EXI_REASON);
-	if (! (reason & 0x80000000)) {
-		u64 guest_rip = vmcs_read(GUEST_RIP);
-		u32 insn_len = vmcs_read(EXI_INST_LEN);
-		vmcs_write(GUEST_RIP, guest_rip + insn_len);
-	}
-}
+	struct vmentry_result result;
+	u8 abort_flags;
 
-static void report_guest_state_test(const char *test, u32 xreason,
-				    u64 field, const char * field_name)
-{
-	u32 reason = vmcs_read(EXI_REASON);
+	abort_flags = ABORT_ON_EARLY_VMENTRY_FAIL;
+	if (!xfail)
+		abort_flags = ABORT_ON_INVALID_GUEST_STATE;
+
+	__enter_guest(abort_flags, &result);
+
+	report(result.exit_reason.failed_vmentry == xfail &&
+	       ((xfail && result.exit_reason.basic == VMX_FAIL_STATE) ||
+	        (!xfail && result.exit_reason.basic == VMX_VMCALL)),
+	        "%s, %s %lx", test, field_name, field);
 
-	report(reason == xreason, "%s, %s %lx", test, field_name, field);
-	advance_guest_state_test();
+	if (!result.exit_reason.failed_vmentry)
+		skip_exit_insn();
 }
 
 /*
@@ -6911,16 +6913,7 @@ static void test_efer_vmlaunch(u32 fld, bool ok)
 		else
 			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	} else {
-		if (ok) {
-			enter_guest();
-			report(vmcs_read(EXI_REASON) == VMX_VMCALL,
-			       "vmlaunch succeeds");
-		} else {
-			enter_guest_with_invalid_guest_state();
-			report(vmcs_read(EXI_REASON) == (VMX_ENTRY_FAILURE | VMX_FAIL_STATE),
-			       "vmlaunch fails");
-		}
-		advance_guest_state_test();
+		test_guest_state("EFER test", !ok, GUEST_EFER, "GUEST_EFER");
 	}
 }
 
@@ -7124,10 +7117,8 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 				report_prefix_pop();
 
 			} else {	// GUEST_PAT
-				enter_guest();
-				report_guest_state_test("ENT_LOAD_PAT enabled",
-							VMX_VMCALL, val,
-							"GUEST_PAT");
+				test_guest_state("ENT_LOAD_PAT enabled", false,
+						 val, "GUEST_PAT");
 			}
 		}
 	}
@@ -7151,21 +7142,9 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 				report_prefix_pop();
 
 			} else {	// GUEST_PAT
-				if (i == 0x2 || i == 0x3 || i >= 0x8) {
-					enter_guest_with_invalid_guest_state();
-					report_guest_state_test("ENT_LOAD_PAT "
-							        "enabled",
-							        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
-							        val,
-							        "GUEST_PAT");
-				} else {
-					enter_guest();
-					report_guest_state_test("ENT_LOAD_PAT "
-							        "enabled",
-							        VMX_VMCALL,
-							        val,
-							        "GUEST_PAT");
-				}
+				error = (i == 0x2 || i == 0x3 || i >= 0x8);
+				test_guest_state("ENT_LOAD_PAT enabled", !!error,
+						 val, "GUEST_PAT");
 			}
 
 		}
@@ -7254,14 +7233,9 @@ static void test_pgc_vmlaunch(u32 xerror, u32 xreason, bool xfail, bool host)
 			report(success != xfail, "vmlaunch succeeded");
 		}
 	} else {
-		if (xfail) {
-			enter_guest_with_invalid_guest_state();
-		} else {
-			enter_guest();
-		}
-		report_guest_state_test("load GUEST_PERF_GLOBAL_CTRL",
-					xreason, GUEST_PERF_GLOBAL_CTRL,
-					"GUEST_PERF_GLOBAL_CTRL");
+		test_guest_state("load GUEST_PERF_GLOBAL_CTRL", xfail,
+				 GUEST_PERF_GLOBAL_CTRL,
+				 "GUEST_PERF_GLOBAL_CTRL");
 	}
 }
 
@@ -7422,10 +7396,8 @@ static void test_canonical(u64 field, const char * field_name, bool host)
 			test_vmx_vmlaunch(0);
 			report_prefix_pop();
 		} else {
-			enter_guest();
-			report_guest_state_test("Test canonical address",
-						VMX_VMCALL, addr_saved,
-						field_name);
+			test_guest_state("Test canonical address", false,
+					 addr_saved, field_name);
 		}
 	}
 
@@ -7436,10 +7408,8 @@ static void test_canonical(u64 field, const char * field_name, bool host)
 		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 		report_prefix_pop();
 	} else {
-		enter_guest_with_invalid_guest_state();
-		report_guest_state_test("Test non-canonical address",
-					VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
-					NONCANONICAL, field_name);
+		test_guest_state("Test non-canonical address", true,
+				 NONCANONICAL, field_name);
 	}
 
 	vmcs_write(field, addr_saved);
@@ -7626,9 +7596,8 @@ static void test_guest_dr7(void)
 		for (i = 0; i < 64; i++) {
 			val = 1ull << i;
 			vmcs_write(GUEST_DR7, val);
-			enter_guest();
-			report_guest_state_test("ENT_LOAD_DBGCTLS disabled",
-						VMX_VMCALL, val, "GUEST_DR7");
+			test_guest_state("ENT_LOAD_DBGCTLS disabled", false,
+					 val, "GUEST_DR7");
 		}
 	}
 	if (ctrl_enter_rev.clr & ENT_LOAD_DBGCTLS) {
@@ -7636,15 +7605,8 @@ static void test_guest_dr7(void)
 		for (i = 0; i < 64; i++) {
 			val = 1ull << i;
 			vmcs_write(GUEST_DR7, val);
-			if (i < 32)
-				enter_guest();
-			else
-				enter_guest_with_invalid_guest_state();
-			report_guest_state_test("ENT_LOAD_DBGCTLS enabled",
-						i < 32 ? VMX_VMCALL :
-						VMX_ENTRY_FAILURE |
-						VMX_FAIL_STATE,
-						val, "GUEST_DR7");
+			test_guest_state("ENT_LOAD_DBGCTLS enabled", i >= 32,
+					 val, "GUEST_DR7");
 		}
 	}
 	vmcs_write(GUEST_DR7, dr7_saved);
@@ -9516,17 +9478,10 @@ static void atomic_switch_msrs_test(int count)
 		assert_exit_reason(VMX_VMCALL);
 		skip_exit_vmcall();
 	} else {
-		u32 exit_reason;
-		u32 exit_reason_want;
 		u32 exit_qual;
 
-		enter_guest_with_invalid_guest_state();
-
-		exit_reason = vmcs_read(EXI_REASON);
-		exit_reason_want = VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
-		report(exit_reason == exit_reason_want,
-		       "exit_reason, %u, is %u.", exit_reason,
-		       exit_reason_want);
+		test_guest_state("Invalid MSR Load Count", true, count,
+				 "ENT_MSR_LD_CNT");
 
 		exit_qual = vmcs_read(EXI_QUALIFICATION);
 		report(exit_qual == max_allowed + 1, "exit_qual, %u, is %u.",
-- 
2.24.1

