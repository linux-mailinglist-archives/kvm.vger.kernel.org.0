Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823144221CA
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhJEJLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:11:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233071AbhJEJL3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 05:11:29 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19596nhO013751;
        Tue, 5 Oct 2021 05:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8OM3t5As0pbfLDWS1K8HBXJPg17nIsEGhkFkNbY7ISE=;
 b=FAMIGzAvzm6uRoMfQdDD03pn2tdu4qEAmTWlZztMPq06Q40/PO0QP3DPRYN1Tp5zEbpV
 90i+GyXdXzDVxpQX8t/u4AmBXlDD5dh4PDo3F+PmSrObz3ZhwWKwMAGwgwfGtUs5POBs
 oPBkHqQpp7DqXoOKbRI+lYWYEJNgJVq3P9o//uGLRYrlZo4z5rGNdyvSrKvirnPhc6Zd
 Yib0knjrr6uEIxB+bY22RZaiR/r57AedvjhC2ogDYdl/T/vRscM3NQvuEdQBlLcXXegx
 ZSqUIrsSodWGBNgmodp49hPcDR2JYTr0ZtOPEym+EbBacnjKC+ziO+baZ7CKbTkMhbcA mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bggbcvbx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:09:38 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19598kk2022333;
        Tue, 5 Oct 2021 05:09:38 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bggbcvbwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:09:38 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19597Brl023945;
        Tue, 5 Oct 2021 09:09:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2a0826-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:09:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19594GNm51249572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 09:04:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5451711C05E;
        Tue,  5 Oct 2021 09:09:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7C5511C05B;
        Tue,  5 Oct 2021 09:09:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 09:09:31 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 5/5] Use report_pass(...) instead of report(1/true, ...)
Date:   Tue,  5 Oct 2021 11:09:21 +0200
Message-Id: <20211005090921.1816373-6-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005090921.1816373-1-scgl@linux.ibm.com>
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VwMbFGhSjxPzatx10XHoLEXGa_ES4G_-
X-Proofpoint-ORIG-GUID: nFnD0GcVy0PnDccQ6pqRal3TKjSIAE2k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whitespace is kept consistent with the rest of the file.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/css.c         |  4 ++--
 s390x/diag288.c     |  2 +-
 s390x/selftest.c    |  2 +-
 s390x/smp.c         | 16 ++++++++--------
 s390x/spec_ex.c     |  7 +++----
 x86/asyncpf.c       |  7 +++----
 x86/emulator.c      |  2 +-
 x86/hyperv_stimer.c | 18 ++++++++----------
 x86/svm_tests.c     | 17 ++++++++---------
 x86/syscall.c       |  2 +-
 x86/taskswitch2.c   |  2 +-
 x86/tsc_adjust.c    |  2 +-
 x86/vmx.c           |  6 +++---
 x86/vmx_tests.c     | 36 ++++++++++++++++++------------------
 14 files changed, 59 insertions(+), 64 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index dcb4d70..881206b 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -31,7 +31,7 @@ static void test_enumerate(void)
 {
 	test_device_sid = css_enumerate();
 	if (test_device_sid & SCHID_ONE) {
-		report(1, "Schid of first I/O device: 0x%08x", test_device_sid);
+		report_pass("Schid of first I/O device: 0x%08x", test_device_sid);
 		return;
 	}
 	report_fail("No I/O device found");
@@ -178,7 +178,7 @@ static void test_schm(void)
 	/* Normal operation */
 	report_prefix_push("Normal operation");
 	schm(NULL, SCHM_MBU);
-	report(1, "SCHM call without address");
+	report_pass("SCHM call without address");
 	report_prefix_pop();
 }
 
diff --git a/s390x/diag288.c b/s390x/diag288.c
index 82b6ec1..072c04a 100644
--- a/s390x/diag288.c
+++ b/s390x/diag288.c
@@ -99,7 +99,7 @@ static void test_bite(void)
 		     "0:	nop\n"
 		     "		j	0b\n"
 		     "1:");
-	report(true, "restart");
+	report_pass("restart");
 }
 
 int main(void)
diff --git a/s390x/selftest.c b/s390x/selftest.c
index 0f099ca..239bc5e 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -78,7 +78,7 @@ int main(int argc, char**argv)
 {
 	report_prefix_push("selftest");
 
-	report(true, "true");
+	report_pass("true");
 	report(argc == 3, "argc == 3");
 	report(!strcmp(argv[0], "s390x/selftest.elf"), "argv[0] == PROGNAME");
 	report(!strcmp(argv[1], "test"), "argv[1] == test");
diff --git a/s390x/smp.c b/s390x/smp.c
index f25ec76..329ca92 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -47,7 +47,7 @@ static void test_start(void)
 	set_flag(0);
 	smp_cpu_start(1, psw);
 	wait_for_flag();
-	report(1, "start");
+	report_pass("start");
 }
 
 /*
@@ -75,7 +75,7 @@ static void test_restart(void)
 	set_flag(0);
 	smp_cpu_restart(1);
 	wait_for_flag();
-	report(1, "restart while running");
+	report_pass("restart while running");
 }
 
 static void test_stop(void)
@@ -87,7 +87,7 @@ static void test_stop(void)
 	 * implementation
 	 */
 	while (!smp_cpu_stopped(1)) {}
-	report(1, "stop");
+	report_pass("stop");
 }
 
 static void test_stop_store_status(void)
@@ -140,7 +140,7 @@ static void test_store_status(void)
 	smp_cpu_stop(1);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 	while (!status->prefix) { mb(); }
-	report(1, "status written");
+	report_pass("status written");
 	free_pages(status);
 	report_prefix_pop();
 	smp_cpu_stop(1);
@@ -160,7 +160,7 @@ static void ecall(void)
 	load_psw_mask(mask);
 	set_flag(1);
 	while (lc->ext_int_code != 0x1202) { mb(); }
-	report(1, "received");
+	report_pass("received");
 	set_flag(1);
 }
 
@@ -194,7 +194,7 @@ static void emcall(void)
 	load_psw_mask(mask);
 	set_flag(1);
 	while (lc->ext_int_code != 0x1201) { mb(); }
-	report(1, "received");
+	report_pass("received");
 	set_flag(1);
 }
 
@@ -225,7 +225,7 @@ static void test_sense_running(void)
 	smp_cpu_stop(1);
 	/* Make sure to have at least one time with a not running indication */
 	while(smp_sense_running_status(1));
-	report(true, "CPU1 sense claims not running");
+	report_pass("CPU1 sense claims not running");
 	report_prefix_pop();
 }
 
@@ -310,7 +310,7 @@ static void test_reset(void)
 	psw.addr = (unsigned long)test_local_ints;
 	smp_cpu_start(1, psw);
 	wait_for_flag();
-	report(true, "local interrupts cleared");
+	report_pass("local interrupts cleared");
 	report_prefix_pop();
 }
 
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index dacdfdb..bc62e02 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -135,10 +135,9 @@ static void test_spec_ex(struct args *args,
 			return;
 		}
 	}
-	report(1,
-	       "Program interrupt: always expected(%d) == received(%d)",
-	       expected_pgm,
-	       expected_pgm);
+	report_pass("Program interrupt: always expected(%d) == received(%d)",
+		    expected_pgm,
+		    expected_pgm);
 }
 
 #define TRANSACTION_COMPLETED 4
diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index 180395e..9366c29 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -61,16 +61,15 @@ static void pf_isr(struct ex_regs *r)
 			phys = virt_to_pte_phys(phys_to_virt(read_cr3()), virt);
 			install_pte(phys_to_virt(read_cr3()), 1, virt, phys, 0);
 			write_cr3(read_cr3());
-			report(true,
-			       "Got not present #PF token %lx virt addr %p phys addr %#" PRIx64,
-			       read_cr2(), virt, phys);
+			report_pass("Got not present #PF token %lx virt addr %p phys addr %#" PRIx64,
+				    read_cr2(), virt, phys);
 			while(phys) {
 				safe_halt(); /* enables irq */
 				irq_disable();
 			}
 			break;
 		case KVM_PV_REASON_PAGE_READY:
-			report(true, "Got present #PF token %lx", read_cr2());
+			report_pass("Got present #PF token %lx", read_cr2());
 			if ((uint32_t)read_cr2() == ~0)
 				break;
 			install_pte(phys_to_virt(read_cr3()), 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK, 0);
diff --git a/x86/emulator.c b/x86/emulator.c
index 9fda1a0..c5f584a 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -268,7 +268,7 @@ static void test_pop(void *mem)
 		     "1: mov %[tmp], %%rsp"
 		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
 		     : "memory");
-	report(1, "ret");
+	report_pass("ret");
 
 	stack_top[-1] = 0x778899;
 	asm volatile("mov %[stack_top], %%r8 \n\t"
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 874a393..7b7c985 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -234,7 +234,7 @@ static void stimer_test_periodic(int vcpu, struct stimer *timer1,
            (atomic_read(&timer2->fire_count) < 1000)) {
         pause();
     }
-    report(true, "Hyper-V SynIC periodic timers test vcpu %d", vcpu);
+    report_pass("Hyper-V SynIC periodic timers test vcpu %d", vcpu);
     stimer_shutdown(timer1);
     stimer_shutdown(timer2);
 }
@@ -246,7 +246,7 @@ static void stimer_test_one_shot(int vcpu, struct stimer *timer)
     while (atomic_read(&timer->fire_count) < 1) {
         pause();
     }
-    report(true, "Hyper-V SynIC one-shot test vcpu %d", vcpu);
+    report_pass("Hyper-V SynIC one-shot test vcpu %d", vcpu);
     stimer_shutdown(timer);
 }
 
@@ -257,8 +257,7 @@ static void stimer_test_auto_enable_one_shot(int vcpu, struct stimer *timer)
     while (atomic_read(&timer->fire_count) < 1) {
         pause();
     }
-    report(true, "Hyper-V SynIC auto-enable one-shot timer test vcpu %d",
-           vcpu);
+    report_pass("Hyper-V SynIC auto-enable one-shot timer test vcpu %d", vcpu);
     stimer_shutdown(timer);
 }
 
@@ -269,8 +268,7 @@ static void stimer_test_auto_enable_periodic(int vcpu, struct stimer *timer)
     while (atomic_read(&timer->fire_count) < 1000) {
         pause();
     }
-    report(true, "Hyper-V SynIC auto-enable periodic timer test vcpu %d",
-           vcpu);
+    report_pass("Hyper-V SynIC auto-enable periodic timer test vcpu %d", vcpu);
     stimer_shutdown(timer);
 }
 
@@ -298,7 +296,7 @@ static void stimer_test_one_shot_busy(int vcpu, struct stimer *timer)
     while (atomic_read(&timer->fire_count) < 1) {
         pause();
     }
-    report(true, "timer resumed when msg slot released: vcpu %d", vcpu);
+    report_pass("timer resumed when msg slot released: vcpu %d", vcpu);
 
     stimer_shutdown(timer);
 }
@@ -355,17 +353,17 @@ int main(int ac, char **av)
 {
 
     if (!synic_supported()) {
-        report(true, "Hyper-V SynIC is not supported");
+        report_pass("Hyper-V SynIC is not supported");
         goto done;
     }
 
     if (!stimer_supported()) {
-        report(true, "Hyper-V SynIC timers are not supported");
+        report_pass("Hyper-V SynIC timers are not supported");
         goto done;
     }
 
     if (!hv_time_ref_counter_supported()) {
-        report(true, "Hyper-V time reference counter is not supported");
+        report_pass("Hyper-V time reference counter is not supported");
         goto done;
     }
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 02910db..3344e28 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1441,7 +1441,7 @@ static bool nmi_finished(struct svm_test *test)
             return true;
         }
 
-        report(true, "NMI intercept while running guest");
+        report_pass("NMI intercept while running guest");
         break;
 
     case 2:
@@ -1543,7 +1543,7 @@ static bool nmi_hlt_finished(struct svm_test *test)
             return true;
         }
 
-        report(true, "NMI intercept while running guest");
+        report_pass("NMI intercept while running guest");
         break;
 
     case 3:
@@ -1844,9 +1844,8 @@ static void reg_corruption_test(struct svm_test *test)
 static bool reg_corruption_finished(struct svm_test *test)
 {
     if (isr_cnt == 10000) {
-        report(true,
-               "No RIP corruption detected after %d timer interrupts",
-               isr_cnt);
+        report_pass("No RIP corruption detected after %d timer interrupts",
+                    isr_cnt);
         set_test_stage(test, 1);
         return true;
     }
@@ -1950,7 +1949,7 @@ static bool init_intercept_finished(struct svm_test *test)
 
     init_intercept = true;
 
-    report(true, "INIT to vcpu intercepted");
+    report_pass("INIT to vcpu intercepted");
 
     return true;
 }
@@ -2811,7 +2810,7 @@ static void svm_vmrun_errata_test(void)
         unsigned long *page = alloc_pages(1);
 
         if (!page) {
-            report(true, "All guest memory tested, no bug found");;
+            report_pass("All guest memory tested, no bug found");
             break;
         }
 
@@ -2940,7 +2939,7 @@ static bool vgif_finished(struct svm_test *test)
             vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
             return true;
         }
-        report(true, "STGI set VGIF bit.");
+        report_pass("STGI set VGIF bit.");
         vmcb->save.rip += 3;
         inc_test_stage(test);
         break;
@@ -2954,7 +2953,7 @@ static bool vgif_finished(struct svm_test *test)
             vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
             return true;
         }
-        report(true, "CLGI cleared VGIF bit.");
+        report_pass("CLGI cleared VGIF bit.");
         vmcb->save.rip += 3;
         inc_test_stage(test);
         vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
diff --git a/x86/syscall.c b/x86/syscall.c
index a8045cb..49e9f13 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -18,7 +18,7 @@ static void test_syscall_lazy_load(void)
     asm volatile("pushf; syscall; syscall_target: popf" : "=c"(tmp) : : "r11");
     write_ss(ss);
     // will crash horribly if broken
-    report(true, "MSR_*STAR eager loading");
+    report_pass("MSR_*STAR eager loading");
 }
 
 /*
diff --git a/x86/taskswitch2.c b/x86/taskswitch2.c
index ed3f99a..3c9af4c 100644
--- a/x86/taskswitch2.c
+++ b/x86/taskswitch2.c
@@ -260,7 +260,7 @@ static void test_vm86_switch(void)
         "popf\n"
         "iret\n"
     );
-    report(1, "VM86");
+    report_pass("VM86");
 }
 
 #define IOPL_SHIFT 12
diff --git a/x86/tsc_adjust.c b/x86/tsc_adjust.c
index 1f26b7a..3636b5e 100644
--- a/x86/tsc_adjust.c
+++ b/x86/tsc_adjust.c
@@ -34,7 +34,7 @@ int main(void)
 		       "MSR_IA32_TSC_ADJUST msr adjustment on tsc write");
 	}
 	else {
-		report(true, "MSR_IA32_TSC_ADJUST feature not enabled");
+		report_pass("MSR_IA32_TSC_ADJUST feature not enabled");
 	}
 	return report_summary();
 }
diff --git a/x86/vmx.c b/x86/vmx.c
index 247de23..20dc677 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1127,9 +1127,9 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 	}
 
 	if (!bad_pt_ad)
-		report(true, "EPT - guest page table structures A=%d/D=%d",
-		       !!(expected_pt_ad & EPT_ACCESS_FLAG),
-		       !!(expected_pt_ad & EPT_DIRTY_FLAG));
+		report_pass("EPT - guest page table structures A=%d/D=%d",
+			    !!(expected_pt_ad & EPT_ACCESS_FLAG),
+			    !!(expected_pt_ad & EPT_DIRTY_FLAG));
 
 	offset = (guest_addr >> EPT_LEVEL_SHIFT(l)) & EPT_PGDIR_MASK;
 	offset_in_page = guest_addr & ((1 << EPT_LEVEL_SHIFT(l)) - 1);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 872586a..3b97cfa 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -53,7 +53,7 @@ static inline void vmcall(void)
 
 static void basic_guest_main(void)
 {
-	report(1, "Basic VMX test");
+	report_pass("Basic VMX test");
 }
 
 static int basic_exit_handler(union exit_reason exit_reason)
@@ -68,7 +68,7 @@ static void vmenter_main(void)
 	u64 rax;
 	u64 rsp, resume_rsp;
 
-	report(1, "test vmlaunch");
+	report_pass("test vmlaunch");
 
 	asm volatile(
 		"mov %%rsp, %0\n\t"
@@ -1184,9 +1184,9 @@ static void ept_common(void)
 		if (vmx_get_test_stage() == 1) {
 			if (*((u32 *)data_page1) == MAGIC_VAL_3 &&
 					*((u32 *)data_page2) == MAGIC_VAL_2)
-				report(1, "EPT basic framework");
+				report_pass("EPT basic framework");
 			else
-				report(1, "EPT basic framework - remap");
+				report_pass("EPT basic framework - remap");
 		}
 	}
 	// Test EPT Misconfigurations
@@ -1897,7 +1897,7 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
             print_vmexit_info(exit_reason);
             return VMX_TEST_VMEXIT;
         }
-        report(true, "NMI intercept while running guest");
+        report_pass("NMI intercept while running guest");
         vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
         break;
 
@@ -2156,12 +2156,12 @@ static void disable_rdtscp_ud_handler(struct ex_regs *regs)
 {
 	switch (vmx_get_test_stage()) {
 	case 0:
-		report(true, "RDTSCP triggers #UD");
+		report_pass("RDTSCP triggers #UD");
 		vmx_inc_test_stage();
 		regs->rip += 3;
 		break;
 	case 2:
-		report(true, "RDPID triggers #UD");
+		report_pass("RDPID triggers #UD");
 		vmx_inc_test_stage();
 		regs->rip += 4;
 		break;
@@ -2328,7 +2328,7 @@ static void v2_null_test(void)
 {
 	test_set_guest(v2_null_test_guest);
 	enter_guest();
-	report(1, __func__);
+	report_pass(__func__);
 }
 
 static void v2_multiple_entries_test_guest(void)
@@ -2346,7 +2346,7 @@ static void v2_multiple_entries_test(void)
 	skip_exit_vmcall();
 	enter_guest();
 	TEST_ASSERT_EQ(vmx_get_test_stage(), 2);
-	report(1, __func__);
+	report_pass(__func__);
 }
 
 static int fixture_test_data = 1;
@@ -2377,7 +2377,7 @@ static void fixture_test_case1(void)
 	TEST_ASSERT_EQ(2, fixture_test_data);
 	enter_guest();
 	TEST_ASSERT_EQ(3, fixture_test_data);
-	report(1, __func__);
+	report_pass(__func__);
 }
 
 static void fixture_test_case2(void)
@@ -2386,7 +2386,7 @@ static void fixture_test_case2(void)
 	TEST_ASSERT_EQ(2, fixture_test_data);
 	enter_guest();
 	TEST_ASSERT_EQ(3, fixture_test_data);
-	report(1, __func__);
+	report_pass(__func__);
 }
 
 enum ept_access_op {
@@ -6971,7 +6971,7 @@ static void test_x2apic_wr(
 			       got, val);
 			apic_write(reg, restore_val);
 		} else {
-			report(true, "non-virtualized and write-only OK");
+			report_pass("non-virtualized and write-only OK");
 		}
 	}
 	skip_exit_insn();
@@ -9581,7 +9581,7 @@ static void vmx_eoi_bitmap_ioapic_scan_test(void)
 
 	/* Let L2 finish */
 	enter_guest();
-	report(1, __func__);
+	report_pass(__func__);
 }
 
 #define HLT_WITH_RVI_VECTOR		(0xf1)
@@ -9709,7 +9709,7 @@ static void vmx_apic_passthrough(bool set_irq_line_from_thread)
 
 	/* Let L2 finish */
 	enter_guest();
-	report(1, __func__);
+	report_pass(__func__);
 }
 
 static void vmx_apic_passthrough_test(void)
@@ -9761,7 +9761,7 @@ static void vmx_apic_passthrough_tpr_threshold_test(void)
 	asm volatile ("nop");
 	report(vmx_apic_passthrough_tpr_threshold_ipi_isr_fired, "self-IPI fired");
 
-	report(1, __func__);
+	report_pass(__func__);
 }
 
 static u64 init_signal_test_exit_reason;
@@ -9958,7 +9958,7 @@ static void vmx_sipi_test_guest(void)
 
 		/* First SIPI signal */
 		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
-		report(1, "BSP(L2): Send first SIPI to cpu[%d]", id_map[1]);
+		report_pass("BSP(L2): Send first SIPI to cpu[%d]", id_map[1]);
 
 		/* wait AP enter guest */
 		while (vmx_get_test_stage() != 2)
@@ -9967,7 +9967,7 @@ static void vmx_sipi_test_guest(void)
 
 		/* Second SIPI signal should be ignored since AP is not in WAIT_SIPI state */
 		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
-		report(1, "BSP(L2): Send second SIPI to cpu[%d]", id_map[1]);
+		report_pass("BSP(L2): Send second SIPI to cpu[%d]", id_map[1]);
 
 		/* Delay a while to check whether second SIPI would cause VMExit */
 		delay(SIPI_SIGNAL_TEST_DELAY);
@@ -10025,7 +10025,7 @@ static void sipi_test_ap_thread(void *data)
 	enter_guest();
 
 	if (vmcs_read(EXI_REASON) == VMX_SIPI) {
-		report(1, "AP: Handle SIPI VMExit");
+		report_pass("AP: Handle SIPI VMExit");
 		vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 		vmx_set_test_stage(2);
 	} else {
-- 
2.31.1

