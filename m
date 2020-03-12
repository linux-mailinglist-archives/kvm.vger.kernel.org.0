Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686D6183D4E
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCLX1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:14954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgCLX1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705947"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 8/8] nVMX: Pass exit reason enum to print_vmexit_info()
Date:   Thu, 12 Mar 2020 16:27:45 -0700
Message-Id: <20200312232745.884-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take the exit reason as a parameter when printing VM-Exit info instead
of rereading it from the VMCS.  Opportunistically clean up the related
printing.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c       |  9 ++++-----
 x86/vmx.h       |  2 +-
 x86/vmx_tests.c | 46 +++++++++++++++++++++++-----------------------
 3 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f7f9665..4c47eec 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -585,17 +585,16 @@ const char *exit_reason_description(u64 reason)
 	return exit_reason_descriptions[reason] ? : "(unused)";
 }
 
-void print_vmexit_info()
+void print_vmexit_info(union exit_reason exit_reason)
 {
 	u64 guest_rip, guest_rsp;
-	ulong reason = vmcs_read(EXI_REASON) & 0xff;
 	ulong exit_qual = vmcs_read(EXI_QUALIFICATION);
 	guest_rip = vmcs_read(GUEST_RIP);
 	guest_rsp = vmcs_read(GUEST_RSP);
 	printf("VMEXIT info:\n");
-	printf("\tvmexit reason = %ld\n", reason);
+	printf("\tvmexit reason = %u\n", exit_reason.basic);
+	printf("\tfailed vmentry = %u\n", !!exit_reason.failed_vmentry);
 	printf("\texit qualification = %#lx\n", exit_qual);
-	printf("\tBit 31 of reason = %lx\n", (vmcs_read(EXI_REASON) >> 31) & 1);
 	printf("\tguest_rip = %#lx\n", guest_rip);
 	printf("\tRAX=%#lx    RBX=%#lx    RCX=%#lx    RDX=%#lx\n",
 		regs.rax, regs.rbx, regs.rcx, regs.rdx);
@@ -1708,7 +1707,7 @@ static int vmx_run(void)
 		}
 
 		if (result.entered)
-			print_vmexit_info();
+			print_vmexit_info(result.exit_reason);
 		else
 			print_vmentry_failure_info(&result);
 		abort();
diff --git a/x86/vmx.h b/x86/vmx.h
index b79cbc1..e6ee776 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -826,7 +826,7 @@ void enable_vmx(void);
 void init_vmx(u64 *vmxon_region);
 
 const char *exit_reason_description(u64 reason);
-void print_vmexit_info(void);
+void print_vmexit_info(union exit_reason exit_reason);
 void print_vmentry_failure_info(struct vmentry_result *result);
 void ept_sync(int type, u64 eptp);
 void vpid_sync(int type, u16 vpid);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f46a0b9..2b8ce03 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -61,7 +61,7 @@ static void basic_guest_main(void)
 static int basic_exit_handler(union exit_reason exit_reason)
 {
 	report(0, "Basic VMX test");
-	print_vmexit_info();
+	print_vmexit_info(exit_reason);
 	return VMX_TEST_EXIT;
 }
 
@@ -98,7 +98,7 @@ static int vmenter_exit_handler(union exit_reason exit_reason)
 		return VMX_TEST_RESUME;
 	default:
 		report(0, "test vmresume");
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
 }
@@ -187,7 +187,7 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			break;
 		default:
 			report(false, "Invalid stage.");
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			break;
 		}
 		break;
@@ -230,13 +230,13 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			// Should not reach here
 			report(false, "unexpected stage, %d",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		break;
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_PREEMPT);
 	return VMX_TEST_VMEXIT;
@@ -568,7 +568,7 @@ static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 			// Should not reach here
 			report(false, "unexpected stage, %d",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
@@ -607,14 +607,14 @@ static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 			// Should not reach here
 			report(false, "unexpected stage, %d",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
 }
@@ -744,7 +744,7 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 			// Should not reach here
 			report(false, "unexpected stage, %d",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
@@ -765,7 +765,7 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 			// Should not reach here
 			report(false, "unexpected stage, %d",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
@@ -1290,7 +1290,7 @@ static int pml_exit_handler(union exit_reason exit_reason)
 		default:
 			report(false, "unexpected stage, %d.",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
@@ -1301,7 +1301,7 @@ static int pml_exit_handler(union exit_reason exit_reason)
 		return VMX_TEST_RESUME;
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
 }
@@ -1386,7 +1386,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		default:
 			report(false, "ERROR - unexpected stage, %d.",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
@@ -1405,7 +1405,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		default:
 			report(false, "ERROR - unexpected stage, %d.",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		return VMX_TEST_RESUME;
@@ -1461,13 +1461,13 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			// Should not reach here
 			report(false, "ERROR : unexpected stage, %d",
 			       vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		return VMX_TEST_RESUME;
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
 }
@@ -1618,14 +1618,14 @@ static int vpid_exit_handler(union exit_reason exit_reason)
 		default:
 			report(false, "ERROR: unexpected stage, %d",
 					vmx_get_test_stage());
-			print_vmexit_info();
+			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
 }
@@ -1796,7 +1796,7 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 		return VMX_TEST_RESUME;
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 
 	return VMX_TEST_VMEXIT;
@@ -1909,7 +1909,7 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
 		return VMX_TEST_RESUME;
 	default:
 		report(false, "Unknown exit reason, %d", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
 }
@@ -2020,7 +2020,7 @@ static int vmmcall_exit_handler(union exit_reason exit_reason)
 		break;
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 
 	return VMX_TEST_VMEXIT;
@@ -2092,7 +2092,7 @@ static int disable_rdtscp_exit_handler(union exit_reason exit_reason)
 
 	default:
 		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info();
+		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
 }
@@ -9349,7 +9349,7 @@ static void invalid_msr_main(void)
 static int invalid_msr_exit_handler(union exit_reason exit_reason)
 {
 	report(0, "Invalid MSR load");
-	print_vmexit_info();
+	print_vmexit_info(exit_reason);
 	return VMX_TEST_EXIT;
 }
 
-- 
2.24.1

