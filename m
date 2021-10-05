Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99C94221CC
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhJEJLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:11:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233472AbhJEJLb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 05:11:31 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19597ExB003343;
        Tue, 5 Oct 2021 05:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w5Y0wVjYSrLvA2XxU2QvTZhLG1/EauXOzEaDwnja2ls=;
 b=OamwENKj5c/KG1kBJZ67aCM7Lw/nEj8Oi1/7dRb5u6cC2xeqybhXzdeK1v9YOCa/89yv
 CYci3oY1txFc/cJKW/jeuPdRLEADE9bNcLsZqqyoTWuVY3vSENwrqkMRb9eG8kLNDfF3
 7mThKKMC1OlbZvKKg3s9QPX6o36/gz6y7Xrw4mpdaJd7CApT6Dzxhl1FxaeRhAPoFsjJ
 2fHw8+6vQpD8PADaPtRN045T4skPGur2alBNRUH2+EwxOsWbyb2/ZF2u8lcpiONWWfpv
 4HH8NH168oGeJOAgIOPur00LLA3rDpULZk4yJ9LSaZo7Yh55IE23MrHzelKNxPkeF96+ ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgjys0urv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:09:39 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19597EIL003337;
        Tue, 5 Oct 2021 05:09:39 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgjys0uqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:09:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19596aBx007012;
        Tue, 5 Oct 2021 09:09:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3bef29p5gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:09:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19594CMA56099260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 09:04:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9CA511C06E;
        Tue,  5 Oct 2021 09:09:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECBFE11C05C;
        Tue,  5 Oct 2021 09:09:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 09:09:30 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 4/5] Use report_fail(...) instead of report(0/false, ...)
Date:   Tue,  5 Oct 2021 11:09:20 +0200
Message-Id: <20211005090921.1816373-5-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005090921.1816373-1-scgl@linux.ibm.com>
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J4uabRQShy1LTZwerxoDp_x_Dt5ZMNHT
X-Proofpoint-ORIG-GUID: Y91S3D3tmOzum7RRjv5xM5r_92i3LVwP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 spamscore=0 clxscore=1011 malwarescore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whitespace is kept consistent with the rest of the file.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/css_lib.c |  30 ++++----
 x86/vmx.h           |  25 ++++---
 arm/psci.c          |   2 +-
 arm/timer.c         |   2 +-
 s390x/css.c         |  18 ++---
 s390x/spec_ex.c     |   7 +-
 x86/asyncpf.c       |   4 +-
 x86/hyperv_stimer.c |   6 +-
 x86/hyperv_synic.c  |   2 +-
 x86/svm_tests.c     | 163 ++++++++++++++++++++++----------------------
 x86/vmx.c           |  17 +++--
 x86/vmx_tests.c     | 136 ++++++++++++++++++------------------
 12 files changed, 200 insertions(+), 212 deletions(-)

diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index efc7057..80e9e07 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -360,9 +360,8 @@ void css_irq_io(void)
 	sid = lowcore_ptr->subsys_id_word;
 	/* Lowlevel set the SID as interrupt parameter. */
 	if (lowcore_ptr->io_int_param != sid) {
-		report(0,
-		       "io_int_param: %x differs from subsys_id_word: %x",
-		       lowcore_ptr->io_int_param, sid);
+		report_fail("io_int_param: %x differs from subsys_id_word: %x",
+			    lowcore_ptr->io_int_param, sid);
 		goto pop;
 	}
 	report_prefix_pop();
@@ -373,15 +372,14 @@ void css_irq_io(void)
 	case 1:
 		dump_irb(&irb);
 		flags = dump_scsw_flags(irb.scsw.ctrl);
-		report(0,
-		       "I/O interrupt, but tsch returns CC 1 for subchannel %08x. SCSW flags: %s",
-		       sid, flags);
+		report_fail("I/O interrupt, but tsch returns CC 1 for subchannel %08x.SCSW flags: %s",
+			    sid, flags);
 		break;
 	case 2:
-		report(0, "tsch returns unexpected CC 2");
+		report_fail("tsch returns unexpected CC 2");
 		break;
 	case 3:
-		report(0, "tsch reporting sch %08x as not operational", sid);
+		report_fail("tsch reporting sch %08x as not operational", sid);
 		break;
 	case 0:
 		/* Stay humble on success */
@@ -435,30 +433,30 @@ int wait_and_check_io_completion(int schid)
 	report_prefix_push("check I/O completion");
 
 	if (lowcore_ptr->io_int_param != schid) {
-		report(0, "interrupt parameter: expected %08x got %08x",
-		       schid, lowcore_ptr->io_int_param);
+		report_fail("interrupt parameter: expected %08x got %08x",
+			    schid, lowcore_ptr->io_int_param);
 		ret = -1;
 		goto end;
 	}
 
 	/* Verify that device status is valid */
 	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
-		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
-		       irb.scsw.ctrl);
+		report_fail("No status pending after interrupt. Subch Ctrl: %08x",
+			    irb.scsw.ctrl);
 		ret = -1;
 		goto end;
 	}
 
 	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
-		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
-		       irb.scsw.ctrl);
+		report_fail("Primary or secondary status missing. Subch Ctrl: %08x",
+			    irb.scsw.ctrl);
 		ret = -1;
 		goto end;
 	}
 
 	if (!(irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
-		report(0, "No device end or sch end. Dev. status: %02x",
-		       irb.scsw.dev_stat);
+		report_fail("No device end or sch end. Dev. status: %02x",
+			    irb.scsw.dev_stat);
 		ret = -1;
 		goto end;
 	}
diff --git a/x86/vmx.h b/x86/vmx.h
index fd0174a..dd869c2 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -923,8 +923,8 @@ void __abort_test(void);
 #define TEST_ASSERT(cond) \
 do { \
 	if (!(cond)) { \
-		report(0, "%s:%d: Assertion failed: %s", \
-		       __FILE__, __LINE__, #cond); \
+		report_fail("%s:%d: Assertion failed: %s", \
+			    __FILE__, __LINE__, #cond); \
 		dump_stack(); \
 		__abort_test(); \
 	} \
@@ -934,8 +934,8 @@ do { \
 #define TEST_ASSERT_MSG(cond, fmt, args...) \
 do { \
 	if (!(cond)) { \
-		report(0, "%s:%d: Assertion failed: %s\n" fmt, \
-		       __FILE__, __LINE__, #cond, ##args); \
+		report_fail("%s:%d: Assertion failed: %s\n" fmt, \
+			    __FILE__, __LINE__, #cond, ##args); \
 		dump_stack(); \
 		__abort_test(); \
 	} \
@@ -951,15 +951,14 @@ do { \
 		char _bin_b[BINSTR_SZ]; \
 		binstr(_a, _bin_a); \
 		binstr(_b, _bin_b); \
-		report(0, \
-		       "%s:%d: %s failed: (%s) == (%s)\n" \
-		       "\tLHS: %#018lx - %s - %lu\n" \
-		       "\tRHS: %#018lx - %s - %lu%s" fmt, \
-		       __FILE__, __LINE__, \
-		       assertion ? "Assertion" : "Expectation", a_str, b_str, \
-		       (unsigned long) _a, _bin_a, (unsigned long) _a, \
-		       (unsigned long) _b, _bin_b, (unsigned long) _b, \
-		       fmt[0] == '\0' ? "" : "\n", ## args); \
+		report_fail("%s:%d: %s failed: (%s) == (%s)\n" \
+			    "\tLHS: %#018lx - %s - %lu\n" \
+			    "\tRHS: %#018lx - %s - %lu%s" fmt, \
+			    __FILE__, __LINE__, \
+			    assertion ? "Assertion" : "Expectation", a_str, b_str, \
+			    (unsigned long) _a, _bin_a, (unsigned long) _a, \
+			    (unsigned long) _b, _bin_b, (unsigned long) _b, \
+			    fmt[0] == '\0' ? "" : "\n", ## args); \
 		dump_stack(); \
 		if (assertion) \
 			__abort_test(); \
diff --git a/arm/psci.c b/arm/psci.c
index ffc09a2..efa0722 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -156,7 +156,7 @@ done:
 #if 0
 	report_summary();
 	psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
-	report(false, "system-off");
+	report_fail("system-off");
 	return 1; /* only reaches here if system-off fails */
 #else
 	return report_summary();
diff --git a/arm/timer.c b/arm/timer.c
index 09e3f8f..27e2e61 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -311,7 +311,7 @@ static void test_init(void)
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
 		report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a85=y to enable.");
 	} else if (ptimer_unsupported) {
-		report(false, "ptimer: read CNTP_CTL_EL0");
+		report_fail("ptimer: read CNTP_CTL_EL0");
 		report_info("ptimer: skipping remaining tests");
 	}
 
diff --git a/s390x/css.c b/s390x/css.c
index c340c53..dcb4d70 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -34,7 +34,7 @@ static void test_enumerate(void)
 		report(1, "Schid of first I/O device: 0x%08x", test_device_sid);
 		return;
 	}
-	report(0, "No I/O device found");
+	report_fail("No I/O device found");
 }
 
 static void test_enable(void)
@@ -69,8 +69,8 @@ static void test_sense(void)
 
 	ret = css_enable(test_device_sid, IO_SCH_ISC);
 	if (ret) {
-		report(0, "Could not enable the subchannel: %08x",
-		       test_device_sid);
+		report_fail("Could not enable the subchannel: %08x",
+			    test_device_sid);
 		return;
 	}
 
@@ -78,19 +78,19 @@ static void test_sense(void)
 
 	senseid = alloc_io_mem(sizeof(*senseid), 0);
 	if (!senseid) {
-		report(0, "Allocation of senseid");
+		report_fail("Allocation of senseid");
 		return;
 	}
 
 	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
 	if (!ccw) {
-		report(0, "Allocation of CCW");
+		report_fail("Allocation of CCW");
 		goto error_ccw;
 	}
 
 	ret = start_ccw1_chain(test_device_sid, ccw);
 	if (ret) {
-		report(0, "Starting CCW chain");
+		report_fail("Starting CCW chain");
 		goto error;
 	}
 
@@ -107,14 +107,14 @@ static void test_sense(void)
 	} else if (ret != 0) {
 		len = sizeof(*senseid) - ret;
 		if (ret && len < CSS_SENSEID_COMMON_LEN) {
-			report(0, "transferred a too short length: %d", ret);
+			report_fail("transferred a too short length: %d", ret);
 			goto error;
 		} else if (ret && len)
 			report_info("transferred a shorter length: %d", len);
 	}
 
 	if (senseid->reserved != 0xff) {
-		report(0, "transferred garbage: 0x%02x", senseid->reserved);
+		report_fail("transferred garbage: 0x%02x", senseid->reserved);
 		goto error;
 	}
 
@@ -265,7 +265,7 @@ static void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb)
 	/* Read the SCHIB for this subchannel */
 	cc = stsch(schid, &schib);
 	if (cc) {
-		report(0, "stsch: sch %08x failed with cc=%d", schid, cc);
+		report_fail("stsch: sch %08x failed with cc=%d", schid, cc);
 		return;
 	}
 
diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index eaf48f4..dacdfdb 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -129,10 +129,9 @@ static void test_spec_ex(struct args *args,
 		register_pgm_cleanup_func(NULL);
 		pgm = clear_pgm_int();
 		if (pgm != expected_pgm) {
-			report(0,
-			       "Program interrupt: expected(%d) == received(%d)",
-			       expected_pgm,
-			       pgm);
+			report_fail("Program interrupt: expected(%d) == received(%d)",
+				    expected_pgm,
+				    pgm);
 			return;
 		}
 	}
diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index 8239e16..180395e 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -55,7 +55,7 @@ static void pf_isr(struct ex_regs *r)
 
 	switch (reason) {
 		case 0:
-			report(false, "unexpected #PF at %#lx", read_cr2());
+			report_fail("unexpected #PF at %#lx", read_cr2());
 			break;
 		case KVM_PV_REASON_PAGE_NOT_PRESENT:
 			phys = virt_to_pte_phys(phys_to_virt(read_cr3()), virt);
@@ -78,7 +78,7 @@ static void pf_isr(struct ex_regs *r)
 			phys = 0;
 			break;
 		default:
-			report(false, "unexpected async pf reason %" PRId32, reason);
+			report_fail("unexpected async pf reason %" PRId32, reason);
 			break;
 	}
 }
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index 75a69a1..874a393 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -96,7 +96,7 @@ static void process_stimer_msg(struct svcpu *svcpu,
 
     if (msg->header.message_type != HVMSG_TIMER_EXPIRED &&
         msg->header.message_type != HVMSG_NONE) {
-        report(false, "invalid Hyper-V SynIC msg type");
+        report_fail("invalid Hyper-V SynIC msg type");
         report_summary();
         abort();
     }
@@ -106,7 +106,7 @@ static void process_stimer_msg(struct svcpu *svcpu,
     }
 
     if (msg->header.payload_size < sizeof(*payload)) {
-        report(false, "invalid Hyper-V SynIC msg payload size");
+        report_fail("invalid Hyper-V SynIC msg payload size");
         report_summary();
         abort();
     }
@@ -114,7 +114,7 @@ static void process_stimer_msg(struct svcpu *svcpu,
     /* Now process timer expiration message */
 
     if (payload->timer_index >= ARRAY_SIZE(svcpu->timer)) {
-        report(false, "invalid Hyper-V SynIC timer index");
+        report_fail("invalid Hyper-V SynIC timer index");
         report_summary();
         abort();
     }
diff --git a/x86/hyperv_synic.c b/x86/hyperv_synic.c
index 25121ca..5ca593c 100644
--- a/x86/hyperv_synic.c
+++ b/x86/hyperv_synic.c
@@ -90,7 +90,7 @@ static void synic_test_prepare(void *ctx)
     }
     r = rdmsr(HV_X64_MSR_EOM);
     if (r != 0) {
-        report(false, "Hyper-V SynIC test, EOM read %#" PRIx64, r);
+        report_fail("Hyper-V SynIC test, EOM read %#" PRIx64, r);
         return;
     }
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 547994d..02910db 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -90,8 +90,8 @@ static bool finished_rsm_intercept(struct svm_test *test)
     switch (get_test_stage(test)) {
     case 0:
         if (vmcb->control.exit_code != SVM_EXIT_RSM) {
-            report(false, "VMEXIT not due to rsm. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to rsm. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
@@ -100,8 +100,8 @@ static bool finished_rsm_intercept(struct svm_test *test)
 
     case 1:
         if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
-            report(false, "VMEXIT not due to #UD. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to #UD. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->save.rip += 2;
@@ -210,7 +210,7 @@ static void test_dr_intercept(struct svm_test *test)
         }
 
         if (test->scratch != i) {
-            report(false, "dr%u read intercept", i);
+            report_fail("dr%u read intercept", i);
             failcnt++;
         }
     }
@@ -246,7 +246,7 @@ static void test_dr_intercept(struct svm_test *test)
         }
 
         if (test->scratch != i) {
-            report(false, "dr%u write intercept", i);
+            report_fail("dr%u write intercept", i);
             failcnt++;
         }
     }
@@ -346,7 +346,7 @@ static void test_msr_intercept(struct svm_test *test)
 
         /* Check that a read intercept occurred for MSR at msr_index */
         if (test->scratch != msr_index)
-            report(false, "MSR 0x%lx read intercept", msr_index);
+            report_fail("MSR 0x%lx read intercept", msr_index);
 
         /*
          * Poor man approach to generate a value that
@@ -358,7 +358,7 @@ static void test_msr_intercept(struct svm_test *test)
 
         /* Check that a write intercept occurred for MSR with msr_value */
         if (test->scratch != msr_value)
-            report(false, "MSR 0x%lx write intercept", msr_index);
+            report_fail("MSR 0x%lx write intercept", msr_index);
     }
 
     test->scratch = -2;
@@ -615,7 +615,7 @@ static void test_ioio(struct svm_test *test)
     return;
 
 fail:
-    report(false, "stage %d", get_test_stage(test));
+    report_fail("stage %d", get_test_stage(test));
     test->scratch = -1;
 }
 
@@ -689,7 +689,7 @@ static void sel_cr0_bug_test(struct svm_test *test)
      * are not in guest-mode anymore so we can't trigger an intercept.
      * Trigger a tripple-fault for now.
      */
-    report(false, "sel_cr0 test. Can not recover from this - exiting");
+    report_fail("sel_cr0 test. Can not recover from this - exiting");
     exit(report_summary());
 }
 
@@ -1101,8 +1101,8 @@ static bool pending_event_finished(struct svm_test *test)
     switch (get_test_stage(test)) {
     case 0:
         if (vmcb->control.exit_code != SVM_EXIT_INTR) {
-            report(false, "VMEXIT not due to pending interrupt. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
 
@@ -1110,7 +1110,7 @@ static bool pending_event_finished(struct svm_test *test)
         vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
         if (pending_event_guest_run) {
-            report(false, "Guest ran before host received IPI\n");
+            report_fail("Guest ran before host received IPI\n");
             return true;
         }
 
@@ -1119,14 +1119,14 @@ static bool pending_event_finished(struct svm_test *test)
         irq_disable();
 
         if (!pending_event_ipi_fired) {
-            report(false, "Pending interrupt not dispatched after IRQ enabled\n");
+            report_fail("Pending interrupt not dispatched after IRQ enabled\n");
             return true;
         }
         break;
 
     case 1:
         if (!pending_event_guest_run) {
-            report(false, "Guest did not resume when no interrupt\n");
+            report_fail("Guest did not resume when no interrupt\n");
             return true;
         }
         break;
@@ -1165,7 +1165,7 @@ static void pending_event_cli_test(struct svm_test *test)
 {
     if (pending_event_ipi_fired == true) {
         set_test_stage(test, -1);
-        report(false, "Interrupt preceeded guest");
+        report_fail("Interrupt preceeded guest");
         vmmcall();
     }
 
@@ -1176,7 +1176,7 @@ static void pending_event_cli_test(struct svm_test *test)
 
     if (pending_event_ipi_fired != true) {
         set_test_stage(test, -1);
-        report(false, "Interrupt not triggered by guest");
+        report_fail("Interrupt not triggered by guest");
     }
 
     vmmcall();
@@ -1194,8 +1194,8 @@ static void pending_event_cli_test(struct svm_test *test)
 static bool pending_event_cli_finished(struct svm_test *test)
 {
     if ( vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-        report(false, "VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
-               vmcb->control.exit_code);
+        report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
+                    vmcb->control.exit_code);
         return true;
     }
 
@@ -1215,7 +1215,7 @@ static bool pending_event_cli_finished(struct svm_test *test)
 
     case 1:
         if (pending_event_ipi_fired == true) {
-            report(false, "Interrupt triggered by guest");
+            report_fail("Interrupt triggered by guest");
             return true;
         }
 
@@ -1224,7 +1224,7 @@ static bool pending_event_cli_finished(struct svm_test *test)
         irq_disable();
 
         if (pending_event_ipi_fired != true) {
-            report(false, "Interrupt not triggered by host");
+            report_fail("Interrupt not triggered by host");
             return true;
         }
 
@@ -1339,8 +1339,8 @@ static bool interrupt_finished(struct svm_test *test)
     case 0:
     case 2:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->save.rip += 3;
@@ -1352,8 +1352,8 @@ static bool interrupt_finished(struct svm_test *test)
     case 1:
     case 3:
         if (vmcb->control.exit_code != SVM_EXIT_INTR) {
-            report(false, "VMEXIT not due to intr intercept. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to intr intercept. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
 
@@ -1425,8 +1425,8 @@ static bool nmi_finished(struct svm_test *test)
     switch (get_test_stage(test)) {
     case 0:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->save.rip += 3;
@@ -1436,8 +1436,8 @@ static bool nmi_finished(struct svm_test *test)
 
     case 1:
         if (vmcb->control.exit_code != SVM_EXIT_NMI) {
-            report(false, "VMEXIT not due to NMI intercept. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
 
@@ -1527,8 +1527,8 @@ static bool nmi_hlt_finished(struct svm_test *test)
     switch (get_test_stage(test)) {
     case 1:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->save.rip += 3;
@@ -1538,8 +1538,8 @@ static bool nmi_hlt_finished(struct svm_test *test)
 
     case 2:
         if (vmcb->control.exit_code != SVM_EXIT_NMI) {
-            report(false, "VMEXIT not due to NMI intercept. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
 
@@ -1586,8 +1586,8 @@ static bool exc_inject_finished(struct svm_test *test)
     switch (get_test_stage(test)) {
     case 0:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->save.rip += 3;
@@ -1596,8 +1596,8 @@ static bool exc_inject_finished(struct svm_test *test)
 
     case 1:
         if (vmcb->control.exit_code != SVM_EXIT_ERR) {
-            report(false, "VMEXIT not due to error. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to error. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         report(count_exc == 0, "exception with vector 2 not injected");
@@ -1606,8 +1606,8 @@ static bool exc_inject_finished(struct svm_test *test)
 
     case 2:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->save.rip += 3;
@@ -1650,7 +1650,7 @@ static void virq_inject_prepare(struct svm_test *test)
 static void virq_inject_test(struct svm_test *test)
 {
     if (virq_fired) {
-        report(false, "virtual interrupt fired before L2 sti");
+        report_fail("virtual interrupt fired before L2 sti");
         set_test_stage(test, -1);
         vmmcall();
     }
@@ -1660,14 +1660,14 @@ static void virq_inject_test(struct svm_test *test)
     irq_disable();
 
     if (!virq_fired) {
-        report(false, "virtual interrupt not fired after L2 sti");
+        report_fail("virtual interrupt not fired after L2 sti");
         set_test_stage(test, -1);
     }
 
     vmmcall();
 
     if (virq_fired) {
-        report(false, "virtual interrupt fired before L2 sti after VINTR intercept");
+        report_fail("virtual interrupt fired before L2 sti after VINTR intercept");
         set_test_stage(test, -1);
         vmmcall();
     }
@@ -1677,7 +1677,7 @@ static void virq_inject_test(struct svm_test *test)
     irq_disable();
 
     if (!virq_fired) {
-        report(false, "virtual interrupt not fired after return from VINTR intercept");
+        report_fail("virtual interrupt not fired after return from VINTR intercept");
         set_test_stage(test, -1);
     }
 
@@ -1688,7 +1688,7 @@ static void virq_inject_test(struct svm_test *test)
     irq_disable();
 
     if (virq_fired) {
-        report(false, "virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
+        report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
         set_test_stage(test, -1);
     }
 
@@ -1703,12 +1703,12 @@ static bool virq_inject_finished(struct svm_test *test)
     switch (get_test_stage(test)) {
     case 0:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         if (vmcb->control.int_ctl & V_IRQ_MASK) {
-            report(false, "V_IRQ not cleared on VMEXIT after firing");
+            report_fail("V_IRQ not cleared on VMEXIT after firing");
             return true;
         }
         virq_fired = false;
@@ -1719,12 +1719,12 @@ static bool virq_inject_finished(struct svm_test *test)
 
     case 1:
         if (vmcb->control.exit_code != SVM_EXIT_VINTR) {
-            report(false, "VMEXIT not due to vintr. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vintr. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         if (virq_fired) {
-            report(false, "V_IRQ fired before SVM_EXIT_VINTR");
+            report_fail("V_IRQ fired before SVM_EXIT_VINTR");
             return true;
         }
         vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
@@ -1732,8 +1732,8 @@ static bool virq_inject_finished(struct svm_test *test)
 
     case 2:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         virq_fired = false;
@@ -1746,8 +1746,8 @@ static bool virq_inject_finished(struct svm_test *test)
 
     case 3:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
@@ -1756,8 +1756,8 @@ static bool virq_inject_finished(struct svm_test *test)
     case 4:
         // INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-                   vmcb->control.exit_code);
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
             return true;
         }
         break;
@@ -1860,9 +1860,8 @@ static bool reg_corruption_finished(struct svm_test *test)
         irq_disable();
 
         if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
-            report(false,
-                   "RIP corruption detected after %d timer interrupts",
-                   isr_cnt);
+            report_fail("RIP corruption detected after %d timer interrupts",
+                        isr_cnt);
             return true;
         }
 
@@ -1943,8 +1942,8 @@ static bool init_intercept_finished(struct svm_test *test)
     vmcb->save.rip += 3;
 
     if (vmcb->control.exit_code != SVM_EXIT_INIT) {
-        report(false, "VMEXIT not due to init intercept. Exit reason 0x%x",
-               vmcb->control.exit_code);
+        report_fail("VMEXIT not due to init intercept. Exit reason 0x%x",
+                    vmcb->control.exit_code);
 
         return true;
         }
@@ -2045,8 +2044,8 @@ static bool host_rflags_finished(struct svm_test *test)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
-			    vmcb->control.exit_code);
+			report_fail("Unexpected VMEXIT. Exit reason 0x%x",
+				    vmcb->control.exit_code);
 			return true;
 		}
 		vmcb->save.rip += 3;
@@ -2059,9 +2058,9 @@ static bool host_rflags_finished(struct svm_test *test)
 	case 1:
 		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
 		    host_rflags_guest_main_flag != 1) {
-			report(false, "Unexpected VMEXIT or #DB handler"
-			    " invoked before guest main. Exit reason 0x%x",
-			    vmcb->control.exit_code);
+			report_fail("Unexpected VMEXIT or #DB handler"
+				    " invoked before guest main. Exit reason 0x%x",
+				    vmcb->control.exit_code);
 			return true;
 		}
 		vmcb->save.rip += 3;
@@ -2075,10 +2074,10 @@ static bool host_rflags_finished(struct svm_test *test)
 	case 2:
 		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
 		    rip_detected != (u64)&vmrun_rip + 3) {
-			report(false, "Unexpected VMEXIT or RIP mismatch."
-			    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
-			    "%lx", vmcb->control.exit_code,
-			    (u64)&vmrun_rip + 3, rip_detected);
+			report_fail("Unexpected VMEXIT or RIP mismatch."
+				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
+				    "%lx", vmcb->control.exit_code,
+				    (u64)&vmrun_rip + 3, rip_detected);
 			return true;
 		}
 		host_rflags_set_rf = true;
@@ -2092,11 +2091,11 @@ static bool host_rflags_finished(struct svm_test *test)
 		    host_rflags_guest_main_flag != 1 ||
 		    host_rflags_db_handler_flag > 1 ||
 		    read_rflags() & X86_EFLAGS_RF) {
-			report(false, "Unexpected VMEXIT or RIP mismatch or "
-			    "EFLAGS.RF not cleared."
-			    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
-			    "%lx", vmcb->control.exit_code,
-			    (u64)&vmrun_rip, rip_detected);
+			report_fail("Unexpected VMEXIT or RIP mismatch or "
+				    "EFLAGS.RF not cleared."
+				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
+				    "%lx", vmcb->control.exit_code,
+				    (u64)&vmrun_rip, rip_detected);
 			return true;
 		}
 		host_rflags_set_tf = false;
@@ -2828,8 +2827,8 @@ static void svm_vmrun_errata_test(void)
         );
 
         if (svm_errata_reproduced) {
-            report(false, "Got #GP exception - svm errata reproduced at 0x%lx",
-                   physical);
+            report_fail("Got #GP exception - svm errata reproduced at 0x%lx",
+                        physical);
             break;
         }
 
@@ -2924,7 +2923,7 @@ static bool vgif_finished(struct svm_test *test)
     {
     case 0:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall.");
+            report_fail("VMEXIT not due to vmmcall.");
             return true;
         }
         vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
@@ -2933,11 +2932,11 @@ static bool vgif_finished(struct svm_test *test)
         break;
     case 1:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall.");
+            report_fail("VMEXIT not due to vmmcall.");
             return true;
         }
         if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
-            report(false, "Failed to set VGIF when executing STGI.");
+            report_fail("Failed to set VGIF when executing STGI.");
             vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
             return true;
         }
@@ -2947,11 +2946,11 @@ static bool vgif_finished(struct svm_test *test)
         break;
     case 2:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-            report(false, "VMEXIT not due to vmmcall.");
+            report_fail("VMEXIT not due to vmmcall.");
             return true;
         }
         if (vmcb->control.int_ctl & V_GIF_MASK) {
-            report(false, "Failed to clear VGIF when executing CLGI.");
+            report_fail("Failed to clear VGIF when executing CLGI.");
             vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
             return true;
         }
diff --git a/x86/vmx.c b/x86/vmx.c
index 2a32aa2..247de23 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1112,11 +1112,10 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 		if (!bad_pt_ad) {
 			bad_pt_ad |= (ept_pte & (EPT_ACCESS_FLAG|EPT_DIRTY_FLAG)) != expected_pt_ad;
 			if (bad_pt_ad)
-				report(false,
-				       "EPT - guest level %d page table A=%d/D=%d",
-				       l,
-				       !!(expected_pt_ad & EPT_ACCESS_FLAG),
-				       !!(expected_pt_ad & EPT_DIRTY_FLAG));
+				report_fail("EPT - guest level %d page table A=%d/D=%d",
+					    l,
+					    !!(expected_pt_ad & EPT_ACCESS_FLAG),
+					    !!(expected_pt_ad & EPT_DIRTY_FLAG));
 		}
 
 		pte = pt[offset];
@@ -1137,7 +1136,7 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 	gpa = (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_page);
 
 	if (!get_ept_pte(pml4, gpa, 1, &ept_pte)) {
-		report(false, "EPT - guest physical address is not mapped");
+		report_fail("EPT - guest physical address is not mapped");
 		return;
 	}
 	report((ept_pte & (EPT_ACCESS_FLAG | EPT_DIRTY_FLAG)) == expected_gpa_ad,
@@ -1883,7 +1882,7 @@ static int test_run(struct vmx_test *test)
 		int ret = 0;
 		if (test->init || test->guest_main || test->exit_handler ||
 		    test->syscall_handler) {
-			report(0, "V2 test cannot specify V1 callbacks.");
+			report_fail("V2 test cannot specify V1 callbacks.");
 			ret = 1;
 		}
 		if (ret)
@@ -1928,7 +1927,7 @@ static int test_run(struct vmx_test *test)
 		run_teardown_step(&teardown_steps[--teardown_count]);
 
 	if (launched && !guest_finished)
-		report(0, "Guest didn't run to completion.");
+		report_fail("Guest didn't run to completion.");
 
 out:
 	if (vmx_off()) {
@@ -2123,7 +2122,7 @@ int main(int argc, const char *argv[])
 			goto exit;
 	} else {
 		if (vmx_on()) {
-			report(0, "vmxon");
+			report_fail("vmxon");
 			goto exit;
 		}
 	}
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4f712eb..872586a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -58,7 +58,7 @@ static void basic_guest_main(void)
 
 static int basic_exit_handler(union exit_reason exit_reason)
 {
-	report(0, "Basic VMX test");
+	report_fail("Basic VMX test");
 	print_vmexit_info(exit_reason);
 	return VMX_TEST_EXIT;
 }
@@ -88,14 +88,14 @@ static int vmenter_exit_handler(union exit_reason exit_reason)
 	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		if (regs.rax != 0xABCD) {
-			report(0, "test vmresume");
+			report_fail("test vmresume");
 			return VMX_TEST_VMEXIT;
 		}
 		regs.rax = 0xFFFF;
 		vmcs_write(GUEST_RIP, guest_rip + 3);
 		return VMX_TEST_RESUME;
 	default:
-		report(0, "test vmresume");
+		report_fail("test vmresume");
 		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
@@ -184,7 +184,7 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			       "preemption timer with 0 value");
 			break;
 		default:
-			report(false, "Invalid stage.");
+			report_fail("Invalid stage.");
 			print_vmexit_info(exit_reason);
 			break;
 		}
@@ -206,12 +206,12 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			       "Save preemption value");
 			return VMX_TEST_RESUME;
 		case 2:
-			report(0, "busy-wait for preemption timer");
+			report_fail("busy-wait for preemption timer");
 			vmx_set_test_stage(3);
 			vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
 			return VMX_TEST_RESUME;
 		case 3:
-			report(0, "preemption timer during hlt");
+			report_fail("preemption timer during hlt");
 			vmx_set_test_stage(4);
 			/* fall through */
 		case 4:
@@ -221,19 +221,18 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			saved_rip = guest_rip + insn_len;
 			return VMX_TEST_RESUME;
 		case 5:
-			report(0,
-			       "preemption timer with 0 value (vmcall stage 5)");
+			report_fail("preemption timer with 0 value (vmcall stage 5)");
 			break;
 		default:
 			// Should not reach here
-			report(false, "unexpected stage, %d",
-			       vmx_get_test_stage());
+			report_fail("unexpected stage, %d",
+				    vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		break;
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_PREEMPT);
@@ -317,7 +316,7 @@ static void test_ctrl_pat_main(void)
 		printf("\tENT_LOAD_PAT is not supported.\n");
 	else {
 		if (guest_ia32_pat != 0) {
-			report(0, "Entry load PAT");
+			report_fail("Entry load PAT");
 			return;
 		}
 	}
@@ -383,7 +382,7 @@ static void test_ctrl_efer_main(void)
 		printf("\tENT_LOAD_EFER is not supported.\n");
 	else {
 		if (guest_ia32_efer != (ia32_efer ^ EFER_NX)) {
-			report(0, "Entry load EFER");
+			report_fail("Entry load EFER");
 			return;
 		}
 	}
@@ -436,13 +435,13 @@ static void cr_shadowing_main(void)
 	vmx_set_test_stage(0);
 	guest_cr0 = read_cr0();
 	if (vmx_get_test_stage() == 1)
-		report(0, "Read through CR0");
+		report_fail("Read through CR0");
 	else
 		vmcall();
 	vmx_set_test_stage(1);
 	guest_cr4 = read_cr4();
 	if (vmx_get_test_stage() == 2)
-		report(0, "Read through CR4");
+		report_fail("Read through CR4");
 	else
 		vmcall();
 	// Test write through
@@ -451,13 +450,13 @@ static void cr_shadowing_main(void)
 	vmx_set_test_stage(2);
 	write_cr0(guest_cr0);
 	if (vmx_get_test_stage() == 3)
-		report(0, "Write throuth CR0");
+		report_fail("Write throuth CR0");
 	else
 		vmcall();
 	vmx_set_test_stage(3);
 	write_cr4(guest_cr4);
 	if (vmx_get_test_stage() == 4)
-		report(0, "Write through CR4");
+		report_fail("Write through CR4");
 	else
 		vmcall();
 	// Test read shadow
@@ -474,13 +473,13 @@ static void cr_shadowing_main(void)
 	vmx_set_test_stage(6);
 	write_cr0(guest_cr0);
 	if (vmx_get_test_stage() == 7)
-		report(0, "Write shadowing CR0 (same value with shadow)");
+		report_fail("Write shadowing CR0 (same value with shadow)");
 	else
 		vmcall();
 	vmx_set_test_stage(7);
 	write_cr4(guest_cr4);
 	if (vmx_get_test_stage() == 8)
-		report(0, "Write shadowing CR4 (same value with shadow)");
+		report_fail("Write shadowing CR4 (same value with shadow)");
 	else
 		vmcall();
 	// Test write shadow (different value)
@@ -564,8 +563,8 @@ static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 			break;
 		default:
 			// Should not reach here
-			report(false, "unexpected stage, %d",
-			       vmx_get_test_stage());
+			report_fail("unexpected stage, %d",
+				    vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
@@ -574,19 +573,19 @@ static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 	case VMX_CR:
 		switch (vmx_get_test_stage()) {
 		case 4:
-			report(0, "Read shadowing CR0");
+			report_fail("Read shadowing CR0");
 			vmx_inc_test_stage();
 			break;
 		case 5:
-			report(0, "Read shadowing CR4");
+			report_fail("Read shadowing CR4");
 			vmx_inc_test_stage();
 			break;
 		case 6:
-			report(0, "Write shadowing CR0 (same value)");
+			report_fail("Write shadowing CR0 (same value)");
 			vmx_inc_test_stage();
 			break;
 		case 7:
-			report(0, "Write shadowing CR4 (same value)");
+			report_fail("Write shadowing CR4 (same value)");
 			vmx_inc_test_stage();
 			break;
 		case 8:
@@ -603,15 +602,15 @@ static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 			break;
 		default:
 			// Should not reach here
-			report(false, "unexpected stage, %d",
-			       vmx_get_test_stage());
+			report_fail("unexpected stage, %d",
+				    vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
@@ -740,8 +739,8 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 			break;
 		default:
 			// Should not reach here
-			report(false, "unexpected stage, %d",
-			       vmx_get_test_stage());
+			report_fail("unexpected stage, %d",
+				    vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
@@ -761,8 +760,8 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 			break;
 		default:
 			// Should not reach here
-			report(false, "unexpected stage, %d",
-			       vmx_get_test_stage());
+			report_fail("unexpected stage, %d",
+				    vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
@@ -1178,7 +1177,7 @@ static void ept_common(void)
 	vmx_set_test_stage(0);
 	if (*((u32 *)data_page2) != MAGIC_VAL_1 ||
 			*((u32 *)data_page1) != MAGIC_VAL_1)
-		report(0, "EPT basic framework - read");
+		report_fail("EPT basic framework - read");
 	else {
 		*((u32 *)data_page2) = MAGIC_VAL_3;
 		vmcall();
@@ -1195,7 +1194,7 @@ static void ept_common(void)
 	vmcall();
 	*((u32 *)data_page1) = MAGIC_VAL_1;
 	if (vmx_get_test_stage() != 2) {
-		report(0, "EPT misconfigurations");
+		report_fail("EPT misconfigurations");
 		goto t1;
 	}
 	vmx_set_test_stage(2);
@@ -1283,7 +1282,7 @@ static int pml_exit_handler(union exit_reason exit_reason)
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page2);
 			break;
 		default:
-			report(false, "unexpected stage, %d.",
+			report_fail("unexpected stage, %d.",
 			       vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
@@ -1295,7 +1294,7 @@ static int pml_exit_handler(union exit_reason exit_reason)
 		vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
@@ -1338,7 +1337,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 						(unsigned long)data_page2,
 						EPT_RA | EPT_WA | EPT_EA);
 			} else
-				report(0, "EPT basic framework - write");
+				report_fail("EPT basic framework - write");
 			break;
 		case 1:
 			install_ept(pml4, (unsigned long)data_page1,
@@ -1380,7 +1379,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			break;
 		// Should not reach here
 		default:
-			report(false, "ERROR - unexpected stage, %d.",
+			report_fail("ERROR - unexpected stage, %d.",
 			       vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
@@ -1399,7 +1398,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			break;
 		// Should not reach here
 		default:
-			report(false, "ERROR - unexpected stage, %d.",
+			report_fail("ERROR - unexpected stage, %d.",
 			       vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
@@ -1455,14 +1454,14 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			break;
 		default:
 			// Should not reach here
-			report(false, "ERROR : unexpected stage, %d",
+			report_fail("ERROR : unexpected stage, %d",
 			       vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
 		}
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
@@ -1612,7 +1611,7 @@ static int vpid_exit_handler(union exit_reason exit_reason)
 				vmx_inc_test_stage();
 			break;
 		default:
-			report(false, "ERROR: unexpected stage, %d",
+			report_fail("ERROR: unexpected stage, %d",
 					vmx_get_test_stage());
 			print_vmexit_info(exit_reason);
 			return VMX_TEST_VMEXIT;
@@ -1620,7 +1619,7 @@ static int vpid_exit_handler(union exit_reason exit_reason)
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
@@ -1791,7 +1790,7 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 
@@ -1878,8 +1877,8 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
     switch (vmx_get_test_stage()) {
     case 1:
         if (exit_reason.basic != VMX_VMCALL) {
-            report(false, "VMEXIT not due to vmcall. Exit reason 0x%x",
-                   exit_reason.full);
+            report_fail("VMEXIT not due to vmcall. Exit reason 0x%x",
+                        exit_reason.full);
             print_vmexit_info(exit_reason);
             return VMX_TEST_VMEXIT;
         }
@@ -1893,8 +1892,8 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
 
     case 2:
         if (exit_reason.basic != VMX_EXC_NMI) {
-            report(false, "VMEXIT not due to NMI intercept. Exit reason 0x%x",
-                   exit_reason.full);
+            report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+                        exit_reason.full);
             print_vmexit_info(exit_reason);
             return VMX_TEST_VMEXIT;
         }
@@ -2022,7 +2021,7 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, %d", exit_reason.full);
+		report_fail("Unknown exit reason, %d", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
@@ -2118,7 +2117,7 @@ static void vmmcall_main(void)
 		"vmmcall\n\t"
 		::: "rax");
 
-	report(0, "VMMCALL");
+	report_fail("VMMCALL");
 }
 
 static int vmmcall_exit_handler(union exit_reason exit_reason)
@@ -2126,14 +2125,14 @@ static int vmmcall_exit_handler(union exit_reason exit_reason)
 	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		printf("here\n");
-		report(0, "VMMCALL triggers #UD");
+		report_fail("VMMCALL triggers #UD");
 		break;
 	case VMX_EXC_NMI:
 		report((vmcs_read(EXI_INTR_INFO) & 0xff) == UD_VECTOR,
 		       "VMMCALL triggers #UD");
 		break;
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 
@@ -2191,7 +2190,7 @@ static int disable_rdtscp_exit_handler(union exit_reason exit_reason)
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
-			report(false, "RDTSCP triggers #UD");
+			report_fail("RDTSCP triggers #UD");
 			vmx_inc_test_stage();
 			/* fallthrough */
 		case 1:
@@ -2199,13 +2198,13 @@ static int disable_rdtscp_exit_handler(union exit_reason exit_reason)
 			vmcs_write(GUEST_RIP, vmcs_read(GUEST_RIP) + 3);
 			return VMX_TEST_RESUME;
 		case 2:
-			report(false, "RDPID triggers #UD");
+			report_fail("RDPID triggers #UD");
 			break;
 		}
 		break;
 
 	default:
-		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
+		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
 	return VMX_TEST_VMEXIT;
@@ -2295,7 +2294,7 @@ static void exit_monitor_from_l2_main(void)
 
 static int exit_monitor_from_l2_handler(union exit_reason exit_reason)
 {
-	report(false, "The guest should have killed the VMM");
+	report_fail("The guest should have killed the VMM");
 	return VMX_TEST_EXIT;
 }
 
@@ -6070,8 +6069,7 @@ static void test_xapic_rd(
 		/* Reenter guest so it can consume/check rcx and exit again. */
 		enter_guest();
 	} else if (exit_reason_want != VMX_VMCALL) {
-		report(false, "Oops, bad exit expectation: %u.",
-		       exit_reason_want);
+		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
 	}
 
 	skip_exit_vmcall();
@@ -6134,8 +6132,7 @@ static void test_xapic_wr(
 		/* Reenter guest so it can consume/check rcx and exit again. */
 		enter_guest();
 	} else if (exit_reason_want != VMX_VMCALL) {
-		report(false, "Oops, bad exit expectation: %u.",
-		       exit_reason_want);
+		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
 	}
 
 	assert_exit_reason(VMX_VMCALL);
@@ -6153,8 +6150,7 @@ static void test_xapic_wr(
 		       "non-virtualized write; val is 0x%x, want 0x%x", got,
 		       val);
 	} else if (!expectation->virtualize_apic_accesses && checked) {
-		report(false,
-		       "Non-virtualized write was prematurely checked!");
+		report_fail("Non-virtualized write was prematurely checked!");
 	}
 
 	skip_exit_vmcall();
@@ -6313,7 +6309,7 @@ static void apic_reg_virt_test(void)
 			ok = apic_reg_virt_exit_expectation(
 				reg, apic_reg_virt_config, &expectation);
 			if (!ok) {
-				report(false, "Malformed test.");
+				report_fail("Malformed test.");
 				break;
 			}
 
@@ -6862,8 +6858,7 @@ static void test_x2apic_rd(
 	enter_guest();
 
 	if (exit_reason_want != VMX_VMCALL) {
-		report(false, "Oops, bad exit expectation: %u.",
-		       exit_reason_want);
+		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
 	}
 
 	skip_exit_vmcall();
@@ -6933,8 +6928,7 @@ static void test_x2apic_wr(
 		/* Reenter guest so it can consume/check rcx and exit again. */
 		enter_guest();
 	} else if (exit_reason_want != VMX_VMCALL) {
-		report(false, "Oops, bad exit expectation: %u.",
-		       exit_reason_want);
+		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
 	}
 
 	assert_exit_reason(VMX_VMCALL);
@@ -9901,7 +9895,7 @@ static void vmx_init_signal_test(void)
 	 */
 	delay(INIT_SIGNAL_TEST_DELAY);
 	if (vmx_get_test_stage() != 5) {
-		report(false, "Pending INIT signal didn't result in VMX exit");
+		report_fail("Pending INIT signal didn't result in VMX exit");
 		return;
 	}
 	report(init_signal_test_exit_reason == VMX_INIT,
@@ -10035,7 +10029,7 @@ static void sipi_test_ap_thread(void *data)
 		vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 		vmx_set_test_stage(2);
 	} else {
-		report(0, "AP: Unexpected VMExit, reason=%ld", vmcs_read(EXI_REASON));
+		report_fail("AP: Unexpected VMExit, reason=%ld", vmcs_read(EXI_REASON));
 		vmx_off();
 		return;
 	}
@@ -10522,12 +10516,12 @@ static int invalid_msr_init(struct vmcs *vmcs)
 
 static void invalid_msr_main(void)
 {
-	report(0, "Invalid MSR load");
+	report_fail("Invalid MSR load");
 }
 
 static int invalid_msr_exit_handler(union exit_reason exit_reason)
 {
-	report(0, "Invalid MSR load");
+	report_fail("Invalid MSR load");
 	print_vmexit_info(exit_reason);
 	return VMX_TEST_EXIT;
 }
-- 
2.31.1

