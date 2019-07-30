Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668287B5A2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 00:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfG3WVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 18:21:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbfG3WVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 18:21:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UMJ4PY121393;
        Tue, 30 Jul 2019 22:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=dGGj2EsKijQvH8mUVQSbVTNRUV9aRsBouKPtSmujtS8=;
 b=M7Dpi8NhnMib1/YdB482diHaIkPvp26rGH0QRAEw2Rz+Mxy536WvZnSoKHH5mMvYbiV/
 mZ9Fkq6TIlg7XKybJAhERNAhNRtfXsVdnwJJYGaMthodrbmu+X39DvoYWjrQvdseEvPP
 OJ0FPMs4woDDywYEpT/KiuKkstFEG4y1DhriHBYcNBmmfUX+CVksiQG+ZaFaVvpUpjRr
 swODyuCCEcCf8Zm+Gknz1XEt6HHo3RzV9XdBFQVXu2lEW/VOw7sjs44WeFsi31T7uG6s
 +RfWcdmhwA8MTaVv8/Rf55/mszSBwKv1pR7nr9CKJ5bYKR1KSyPPhj55LtRIbkkc0Vws QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u0f8r17yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 22:20:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UMIJmV186583;
        Tue, 30 Jul 2019 22:20:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u2exaqk80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 22:20:43 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6UMKgPf004283;
        Tue, 30 Jul 2019 22:20:43 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jul 2019 15:20:42 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/2] kvm-unit-test: x86: Replace cpuid/cpuid_indexed calls with this_cpu_has()
Date:   Tue, 30 Jul 2019 17:52:56 -0400
Message-Id: <20190730215256.26695-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190730215256.26695-1-krish.sadhukhan@oracle.com>
References: <20190730215256.26695-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300223
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 lib/x86/processor.h       |  4 ++--
 x86/access.c              | 13 ++++---------
 x86/apic.c                |  8 ++++----
 x86/emulator.c            |  4 ++--
 x86/memory.c              | 16 ++++++----------
 x86/pcid.c                | 10 ++--------
 x86/pku.c                 |  3 +--
 x86/smap.c                |  4 +---
 x86/svm.c                 |  6 +++---
 x86/tsc.c                 | 16 ++--------------
 x86/tsc_adjust.c          |  2 +-
 x86/tscdeadline_latency.c |  2 +-
 x86/umip.c                |  6 +-----
 x86/vmexit.c              |  6 +++---
 x86/vmx.c                 |  2 +-
 x86/vmx_tests.c           | 11 ++++-------
 x86/xsave.c               | 15 ++++-----------
 17 files changed, 42 insertions(+), 86 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9b87dd5..b1c579b 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -573,12 +573,12 @@ static inline void flush_tlb(void)
 
 static inline int has_spec_ctrl(void)
 {
-    return !!(cpuid_indexed(7,0).d & (1 << 26));
+    return !!(this_cpu_has(X86_FEATURE_SPEC_CTRL));
 }
 
 static inline int cpu_has_efer_nx(void)
 {
-	return !!(cpuid(0x80000001).d & (1 << 20));
+	return !!(this_cpu_has(X86_FEATURE_NX));
 }
 
 #endif
diff --git a/x86/access.c b/x86/access.c
index f0d1879..8618154 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -13,8 +13,6 @@
 static _Bool verbose = false;
 
 typedef unsigned long pt_element_t;
-static int cpuid_7_ebx;
-static int cpuid_7_ecx;
 static int invalid_mask;
 static int page_table_levels;
 
@@ -861,7 +859,7 @@ static int check_smep_andnot_wp(ac_pool_t *pool)
 	ac_test_t at1;
 	int err_prepare_andnot_wp, err_smep_andnot_wp;
 
-	if (!(cpuid_7_ebx & (1 << 7))) {
+	if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
 	    return 1;
 	}
 
@@ -936,7 +934,7 @@ static int ac_test_run(void)
     printf("run\n");
     tests = successes = 0;
 
-    if (cpuid_7_ecx & (1 << 3)) {
+    if (this_cpu_has(X86_FEATURE_PKU)) {
         set_cr4_pke(1);
         set_cr4_pke(0);
         /* Now PKRU = 0xFFFFFFFF.  */
@@ -956,7 +954,7 @@ static int ac_test_run(void)
 	}
     }
 
-    if (!(cpuid_7_ebx & (1 << 7))) {
+    if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
 	tests++;
 	if (set_cr4_smep(1) == GP_VECTOR) {
             successes++;
@@ -991,14 +989,11 @@ int main(void)
 
     setup_idt();
 
-    cpuid_7_ebx = cpuid(7).b;
-    cpuid_7_ecx = cpuid(7).c;
-
     printf("starting test\n\n");
     page_table_levels = 4;
     r = ac_test_run();
 
-    if (cpuid_7_ecx & (1 << 16)) {
+    if (this_cpu_has(X86_FEATURE_LA57)) {
         page_table_levels = 5;
         setup_5level_page_table();
         printf("starting 5-level paging test.\n\n");
diff --git a/x86/apic.c b/x86/apic.c
index 7617351..e5e9b83 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -44,7 +44,7 @@ static int enable_tsc_deadline_timer(void)
 {
     uint32_t lvtt;
 
-    if (cpuid(1).c & (1 << 24)) {
+    if (this_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
         lvtt = APIC_LVT_TIMER_TSCDEADLINE | TSC_DEADLINE_TIMER_VECTOR;
         apic_write(APIC_LVTT, lvtt);
         return 1;
@@ -144,13 +144,13 @@ static void test_apic_disable(void)
 
     disable_apic();
     report("Local apic disabled", !(rdmsr(MSR_IA32_APICBASE) & APIC_EN));
-    report("CPUID.1H:EDX.APIC[bit 9] is clear", !(cpuid(1).d & (1 << 9)));
+    report("CPUID.1H:EDX.APIC[bit 9] is clear", !this_cpu_has(X86_FEATURE_APIC));
     verify_disabled_apic_mmio();
 
     reset_apic();
     report("Local apic enabled in xAPIC mode",
 	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN);
-    report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << 9));
+    report("CPUID.1H:EDX.APIC[bit 9] is set", this_cpu_has(X86_FEATURE_APIC));
     report("*0xfee00030: %x", *lvr == apic_version, *lvr);
     report("*0xfee00080: %x", *tpr == cr8, *tpr);
     write_cr8(cr8 ^ MAX_TPR);
@@ -162,7 +162,7 @@ static void test_apic_disable(void)
 	report("Local apic enabled in x2APIC mode",
 	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) ==
 	   (APIC_EN | APIC_EXTD));
-	report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << 9));
+	report("CPUID.1H:EDX.APIC[bit 9] is set", this_cpu_has(X86_FEATURE_APIC));
 	verify_disabled_apic_mmio();
 	if (!(orig_apicbase & APIC_EXTD))
 	    reset_apic();
diff --git a/x86/emulator.c b/x86/emulator.c
index c856db4..b132b90 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -815,7 +815,7 @@ static void test_mov_dr(uint64_t *mem)
 {
 	unsigned long rax;
 	const unsigned long in_rax = 0;
-	bool rtm_support = cpuid(7).b & (1 << 11);
+	bool rtm_support = this_cpu_has(X86_FEATURE_RTM);
 	unsigned long dr6_fixed_1 = rtm_support ? 0xfffe0ff0ul : 0xffff0ff0ul;
 	asm(KVM_FEP "movq %0, %%dr6\n\t"
 	    KVM_FEP "movq %%dr6, %0\n\t" : "=a" (rax) : "a" (in_rax));
@@ -996,7 +996,7 @@ static void illegal_movbe_handler(struct ex_regs *regs)
 
 static void test_illegal_movbe(void)
 {
-	if (!(cpuid(1).c & (1 << 22))) {
+	if (!this_cpu_has(X86_FEATURE_MOVBE)) {
 		report_skip("illegal movbe");
 		return;
 	}
diff --git a/x86/memory.c b/x86/memory.c
index d842841..4f8949b 100644
--- a/x86/memory.c
+++ b/x86/memory.c
@@ -25,29 +25,25 @@ static void handle_ud(struct ex_regs *regs)
 
 int main(int ac, char **av)
 {
-	struct cpuid cpuid7, cpuid1;
 	int expected;
 
 	setup_idt();
 	handle_exception(UD_VECTOR, handle_ud);
 
-	cpuid1 = cpuid(1);
-	cpuid7 = cpuid_indexed(7, 0);
-
 	/* 3-byte instructions: */
 	isize = 3;
 
-	expected = !(cpuid1.d & (1U << 19)); /* CLFLUSH */
+	expected = !this_cpu_has(X86_FEATURE_CLFLUSH); /* CLFLUSH */
 	ud = 0;
 	asm volatile("clflush (%0)" : : "b" (&target));
 	report("clflush (%s)", ud == expected, expected ? "ABSENT" : "present");
 
-	expected = !(cpuid1.d & (1U << 25)); /* SSE */
+	expected = !this_cpu_has(X86_FEATURE_XMM); /* SSE */
 	ud = 0;
 	asm volatile("sfence");
 	report("sfence (%s)", ud == expected, expected ? "ABSENT" : "present");
 
-	expected = !(cpuid1.d & (1U << 26)); /* SSE2 */
+	expected = !this_cpu_has(X86_FEATURE_XMM2); /* SSE2 */
 	ud = 0;
 	asm volatile("lfence");
 	report("lfence (%s)", ud == expected, expected ? "ABSENT" : "present");
@@ -59,13 +55,13 @@ int main(int ac, char **av)
 	/* 4-byte instructions: */
 	isize = 4;
 
-	expected = !(cpuid7.b & (1U << 23)); /* CLFLUSHOPT */
+	expected = !this_cpu_has(X86_FEATURE_CLFLUSHOPT); /* CLFLUSHOPT */
 	ud = 0;
 	/* clflushopt (%rbx): */
 	asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (&target));
 	report("clflushopt (%s)", ud == expected, expected ? "ABSENT" : "present");
 
-	expected = !(cpuid7.b & (1U << 24)); /* CLWB */
+	expected = !this_cpu_has(X86_FEATURE_CLWB); /* CLWB */
 	ud = 0;
 	/* clwb (%rbx): */
 	asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
@@ -78,7 +74,7 @@ int main(int ac, char **av)
 	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf0");
 	report("invalid clwb", ud);
 
-	expected = !(cpuid7.b & (1U << 22)); /* PCOMMIT */
+	expected = !this_cpu_has(X86_FEATURE_PCOMMIT); /* PCOMMIT */
 	ud = 0;
 	/* pcommit: */
 	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf8");
diff --git a/x86/pcid.c b/x86/pcid.c
index dfabe0e..273e96b 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -4,9 +4,6 @@
 #include "processor.h"
 #include "desc.h"
 
-#define X86_FEATURE_PCID       (1 << 17)
-#define X86_FEATURE_INVPCID    (1 << 10)
-
 struct invpcid_desc {
     unsigned long pcid : 12;
     unsigned long rsv  : 52;
@@ -131,16 +128,13 @@ report:
 
 int main(int ac, char **av)
 {
-    struct cpuid _cpuid;
     int pcid_enabled = 0, invpcid_enabled = 0;
 
     setup_idt();
 
-    _cpuid = cpuid(1);
-    if (_cpuid.c & X86_FEATURE_PCID)
+    if (this_cpu_has(X86_FEATURE_PCID))
         pcid_enabled = 1;
-    _cpuid = cpuid_indexed(7, 0);
-    if (_cpuid.b & X86_FEATURE_INVPCID)
+    if (this_cpu_has(X86_FEATURE_INVPCID))
         invpcid_enabled = 1;
 
     test_cpuid_consistency(pcid_enabled, invpcid_enabled);
diff --git a/x86/pku.c b/x86/pku.c
index 3d7c5cd..62fb261 100644
--- a/x86/pku.c
+++ b/x86/pku.c
@@ -4,7 +4,6 @@
 #include "x86/vm.h"
 #include "x86/msr.h"
 
-#define X86_FEATURE_PKU  3
 #define CR0_WP_MASK      (1UL << 16)
 #define PTE_PKEY_BIT     59
 #define USER_BASE        (1 << 24)
@@ -67,7 +66,7 @@ int main(int ac, char **av)
     unsigned int pkru_ad = 0x10;
     unsigned int pkru_wd = 0x20;
 
-    if (!(cpuid_indexed(7, 0).c & (1 << X86_FEATURE_PKU))) {
+    if (!this_cpu_has(X86_FEATURE_PKU)) {
         printf("PKU not enabled\n");
         return report_summary();
     }
diff --git a/x86/smap.c b/x86/smap.c
index afa3644..c0376e3 100644
--- a/x86/smap.c
+++ b/x86/smap.c
@@ -3,8 +3,6 @@
 #include "x86/processor.h"
 #include "x86/vm.h"
 
-#define X86_FEATURE_SMAP	20
-
 volatile int pf_count = 0;
 volatile int save;
 volatile unsigned test;
@@ -92,7 +90,7 @@ int main(int ac, char **av)
 {
 	unsigned long i;
 
-	if (!(cpuid_indexed(7, 0).b & (1 << X86_FEATURE_SMAP))) {
+	if (!this_cpu_has(X86_FEATURE_SMAP)) {
 		printf("SMAP not enabled\n");
 		return report_summary();
 	}
diff --git a/x86/svm.c b/x86/svm.c
index bc74e7c..130e640 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -49,7 +49,7 @@ u8 msr_bitmap_area[MSR_BITMAP_SIZE + PAGE_SIZE];
 
 static bool npt_supported(void)
 {
-   return cpuid(0x8000000A).d & 1;
+	return this_cpu_has(X86_FEATURE_NPT);
 }
 
 static void setup_svm(void)
@@ -508,7 +508,7 @@ static bool check_dr_intercept(struct test *test)
 
 static bool next_rip_supported(void)
 {
-    return (cpuid(SVM_CPUID_FUNC).d & 8);
+    return this_cpu_has(X86_FEATURE_NRIPS);
 }
 
 static void prepare_next_rip(struct test *test)
@@ -1352,7 +1352,7 @@ int main(int ac, char **av)
     setup_vm();
     smp_init();
 
-    if (!(cpuid(0x80000001).c & 4)) {
+    if (!this_cpu_has(X86_FEATURE_SVM)) {
         printf("SVM not availble\n");
         return report_summary();
     }
diff --git a/x86/tsc.c b/x86/tsc.c
index 6480a9c..b56d578 100644
--- a/x86/tsc.c
+++ b/x86/tsc.c
@@ -1,18 +1,6 @@
 #include "libcflat.h"
 #include "processor.h"
 
-#define CPUID_80000001_EDX_RDTSCP	    (1 << 27)
-static int check_cpuid_80000001_edx(unsigned int bit)
-{
-	return (cpuid(0x80000001).d & bit) != 0;
-}
-
-#define CPUID_7_0_ECX_RDPID		    (1 << 22)
-static int check_cpuid_7_0_ecx(unsigned int bit)
-{
-    return (cpuid_indexed(7, 0).c & bit) != 0;
-}
-
 static void test_wrtsc(u64 t1)
 {
 	u64 t2;
@@ -51,14 +39,14 @@ int main(void)
 	test_wrtsc(0);
 	test_wrtsc(100000000000ull);
 
-	if (check_cpuid_80000001_edx(CPUID_80000001_EDX_RDTSCP)) {
+	if (this_cpu_has(X86_FEATURE_RDTSCP)) {
 		test_rdtscp(0);
 		test_rdtscp(10);
 		test_rdtscp(0x100);
 	} else
 		printf("rdtscp not supported\n");
 
-	if (check_cpuid_7_0_ecx(CPUID_7_0_ECX_RDPID)) {
+	if (this_cpu_has(X86_FEATURE_RDPID)) {
 		test_rdpid(0);
 		test_rdpid(10);
 		test_rdpid(0x100);
diff --git a/x86/tsc_adjust.c b/x86/tsc_adjust.c
index 0f32d8a..76cb5ee 100644
--- a/x86/tsc_adjust.c
+++ b/x86/tsc_adjust.c
@@ -6,7 +6,7 @@ int main(void)
 	u64 t1, t2, t3, t4, t5;
 	u64 est_delta_time;
 
-	if (cpuid(7).b & (1 << 1)) { // MSR_IA32_TSC_ADJUST Feature is enabled?
+	if (this_cpu_has(X86_FEATURE_TSC_ADJUST)) { // MSR_IA32_TSC_ADJUST Feature is enabled?
 		report("MSR_IA32_TSC_ADJUST msr initialization",
 				rdmsr(MSR_IA32_TSC_ADJUST) == 0x0);
 		t3 = 100000000000ull;
diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index 4ee5917..b320252 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -80,7 +80,7 @@ static int enable_tsc_deadline_timer(void)
 {
     uint32_t lvtt;
 
-    if (cpuid(1).c & (1 << 24)) {
+    if (this_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
         lvtt = APIC_LVT_TIMER_TSCDEADLINE | TSC_DEADLINE_TIMER_VECTOR;
         apic_write(APIC_LVTT, lvtt);
         start_tsc_deadline_timer();
diff --git a/x86/umip.c b/x86/umip.c
index 5da6793..06ee633 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -3,9 +3,6 @@
 #include "desc.h"
 #include "processor.h"
 
-#define CPUID_7_ECX_UMIP (1 << 2)
-static int cpuid_7_ecx;
-
 
 /* GP handler to skip over faulting instructions */
 
@@ -183,8 +180,7 @@ int main(void)
     test_umip_nogp("UMIP=0, CPL=0\n");
     do_ring3(test_umip_nogp, "UMIP=0, CPL=3\n");
 
-    cpuid_7_ecx = cpuid(7).c;
-    if (!(cpuid_7_ecx & CPUID_7_ECX_UMIP)) {
+    if (!this_cpu_has(X86_FEATURE_UMIP)) {
         printf("UMIP not available\n");
         return report_summary();
     }
diff --git a/x86/vmexit.c b/x86/vmexit.c
index f55c993..fa72be7 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -395,7 +395,7 @@ static int has_tscdeadline(void)
 {
     uint32_t lvtt;
 
-    if (cpuid(1).c & (1 << 24)) {
+    if (this_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
         lvtt = APIC_LVT_TIMER_TSCDEADLINE | IPI_TEST_VECTOR;
         apic_write(APIC_LVTT, lvtt);
         return 1;
@@ -425,7 +425,7 @@ static void wr_ibrs_msr(void)
 
 static int has_ibpb(void)
 {
-    return has_spec_ctrl() || !!(cpuid(0x80000008).b & (1 << 12));
+    return has_spec_ctrl() || !!(this_cpu_has(X86_FEATURE_AMD_IBPB));
 }
 
 static void wr_ibpb_msr(void)
@@ -521,7 +521,7 @@ static bool do_test(struct test *test)
 
 static void enable_nx(void *junk)
 {
-	if (cpu_has_efer_nx())
+	if (this_cpu_has(X86_FEATURE_NX))
 		wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX_MASK);
 }
 
diff --git a/x86/vmx.c b/x86/vmx.c
index 872ba11..6079420 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1922,7 +1922,7 @@ int main(int argc, const char *argv[])
 	argv++;
 	argc--;
 
-	if (!(cpuid(1).c & (1 << 5))) {
+	if (!this_cpu_has(X86_FEATURE_VMX)) {
 		printf("WARNING: vmx not supported, add '-cpu host'\n");
 		goto exit;
 	}
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8ad2674..0af86dc 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -843,14 +843,12 @@ u32 cur_insn;
 u64 cr3;
 
 #define X86_FEATURE_MONITOR	(1 << 3)
-#define X86_FEATURE_MCE		(1 << 7)
-#define X86_FEATURE_PCID	(1 << 17)
 
 typedef bool (*supported_fn)(void);
 
 static bool monitor_supported(void)
 {
-	return cpuid(1).c & X86_FEATURE_MONITOR;
+	return this_cpu_has(X86_FEATURE_MWAIT);
 }
 
 struct insn_table {
@@ -7261,16 +7259,15 @@ static void vmentry_movss_shadow_test(void)
 static void vmx_cr_load_test(void)
 {
 	unsigned long cr3, cr4, orig_cr3, orig_cr4;
-	struct cpuid _cpuid = cpuid(1);
 
 	orig_cr4 = read_cr4();
 	orig_cr3 = read_cr3();
 
-	if (!(_cpuid.c & X86_FEATURE_PCID)) {
+	if (!this_cpu_has(X86_FEATURE_PCID)) {
 		report_skip("PCID not detected");
 		return;
 	}
-	if (!(_cpuid.d & X86_FEATURE_MCE)) {
+	if (!this_cpu_has(X86_FEATURE_MCE)) {
 		report_skip("MCE not detected");
 		return;
 	}
@@ -7964,7 +7961,7 @@ static void vmx_db_test(void)
 	 * exception (#BP) occurs inside an RTM region while advanced
 	 * debugging of RTM transactional regions is enabled.
 	 */
-	if (cpuid(7).b & BIT(11)) {
+	if (this_cpu_has(X86_FEATURE_RTM)) {
 		vmcs_write(ENT_CONTROLS,
 			   vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
 		/*
diff --git a/x86/xsave.c b/x86/xsave.c
index ca41bbf..f243c80 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -33,13 +33,6 @@ static int xsetbv_checking(u32 index, u64 value)
     return exception_vector();
 }
 
-#define CPUID_1_ECX_XSAVE	    (1 << 26)
-#define CPUID_1_ECX_OSXSAVE	    (1 << 27)
-static int check_cpuid_1_ecx(unsigned int bit)
-{
-    return (cpuid(1).c & bit) != 0;
-}
-
 static uint64_t get_supported_xcr0(void)
 {
     struct cpuid r;
@@ -76,7 +69,7 @@ static void test_xsave(void)
     cr4 = read_cr4();
     report("Set CR4 OSXSAVE", write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == 0);
     report("Check CPUID.1.ECX.OSXSAVE - expect 1",
-		    check_cpuid_1_ecx(CPUID_1_ECX_OSXSAVE));
+		    this_cpu_has(X86_FEATURE_OSXSAVE));
 
     printf("\tLegal tests\n");
     test_bits = XSTATE_FP;
@@ -119,7 +112,7 @@ static void test_xsave(void)
     cr4 &= ~X86_CR4_OSXSAVE;
     report("Unset CR4 OSXSAVE", write_cr4_checking(cr4) == 0);
     report("Check CPUID.1.ECX.OSXSAVE - expect 0",
-	check_cpuid_1_ecx(CPUID_1_ECX_OSXSAVE) == 0);
+	this_cpu_has(X86_FEATURE_OSXSAVE) == 0);
 
     printf("\tIllegal tests:\n");
     test_bits = XSTATE_FP;
@@ -141,7 +134,7 @@ static void test_no_xsave(void)
     u64 xcr0;
 
     report("Check CPUID.1.ECX.OSXSAVE - expect 0",
-	check_cpuid_1_ecx(CPUID_1_ECX_OSXSAVE) == 0);
+	this_cpu_has(X86_FEATURE_OSXSAVE) == 0);
 
     printf("Illegal instruction testing:\n");
 
@@ -159,7 +152,7 @@ static void test_no_xsave(void)
 int main(void)
 {
     setup_idt();
-    if (check_cpuid_1_ecx(CPUID_1_ECX_XSAVE)) {
+    if (this_cpu_has(X86_FEATURE_XSAVE)) {
         printf("CPU has XSAVE feature\n");
         test_xsave();
     } else {
-- 
2.20.1

