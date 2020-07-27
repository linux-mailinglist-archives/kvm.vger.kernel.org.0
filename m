Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B7222E9FF
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 12:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgG0K0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 06:26:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgG0K0v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 06:26:51 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RA2X0V179822
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 06:26:49 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32hrnkqbcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 06:26:49 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06RA2gc4180568
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 06:26:49 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32hrnkqbc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 06:26:49 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06RAQCLd016343;
        Mon, 27 Jul 2020 10:26:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 32gcqgj3kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 10:26:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06RAQicx50528330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 10:26:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96ECF11C05E;
        Mon, 27 Jul 2020 10:26:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3979A11C04A;
        Mon, 27 Jul 2020 10:26:44 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.171])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jul 2020 10:26:44 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, david@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/1] s390x: fix inline asm on gcc10
Date:   Mon, 27 Jul 2020 12:26:43 +0200
Message-Id: <20200727102643.15439-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_06:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=888 adultscore=0 clxscore=1015 impostorscore=0 phishscore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix compilation issues on 390x with gcc 10.

Simply mark the inline functions that lead to a .insn with a variable
opcode as __always_inline, to make gcc 10 happy.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/cpacf.h |  5 +++--
 s390x/emulator.c      | 25 +++++++++++++------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index ae2ec53..2146a01 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -11,6 +11,7 @@
 #define _ASM_S390_CPACF_H
 
 #include <asm/facility.h>
+#include <linux/compiler.h>
 
 /*
  * Instruction opcodes for the CPACF instructions
@@ -145,7 +146,7 @@ typedef struct { unsigned char bytes[16]; } cpacf_mask_t;
  *
  * Returns 1 if @func is available for @opcode, 0 otherwise
  */
-static inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
+static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
 {
 	register unsigned long r0 asm("0") = 0;	/* query function */
 	register unsigned long r1 asm("1") = (unsigned long) mask;
@@ -183,7 +184,7 @@ static inline int __cpacf_check_opcode(unsigned int opcode)
 	}
 }
 
-static inline int cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
+static __always_inline int cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
 {
 	if (__cpacf_check_opcode(opcode)) {
 		__cpacf_query(opcode, mask);
diff --git a/s390x/emulator.c b/s390x/emulator.c
index 1ee0df5..70ef51a 100644
--- a/s390x/emulator.c
+++ b/s390x/emulator.c
@@ -14,6 +14,7 @@
 #include <asm/cpacf.h>
 #include <asm/interrupt.h>
 #include <asm/float.h>
+#include <linux/compiler.h>
 
 struct lowcore *lc = NULL;
 
@@ -46,7 +47,7 @@ static void test_spm_ipm(void)
 	__test_spm_ipm(0, 0);
 }
 
-static inline void __test_cpacf(unsigned int opcode, unsigned long func,
+static __always_inline void __test_cpacf(unsigned int opcode, unsigned long func,
 				unsigned int r1, unsigned int r2,
 				unsigned int r3)
 {
@@ -59,7 +60,7 @@ static inline void __test_cpacf(unsigned int opcode, unsigned long func,
 		         [r1] "i" (r1), [r2] "i" (r2), [r3] "i" (r3));
 }
 
-static inline void __test_cpacf_r1_odd(unsigned int opcode)
+static __always_inline void __test_cpacf_r1_odd(unsigned int opcode)
 {
 	report_prefix_push("r1 odd");
 	expect_pgm_int();
@@ -68,7 +69,7 @@ static inline void __test_cpacf_r1_odd(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r1_null(unsigned int opcode)
+static __always_inline void __test_cpacf_r1_null(unsigned int opcode)
 {
 	report_prefix_push("r1 null");
 	expect_pgm_int();
@@ -77,7 +78,7 @@ static inline void __test_cpacf_r1_null(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r2_odd(unsigned int opcode)
+static __always_inline void __test_cpacf_r2_odd(unsigned int opcode)
 {
 	report_prefix_push("r2 odd");
 	expect_pgm_int();
@@ -86,7 +87,7 @@ static inline void __test_cpacf_r2_odd(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r2_null(unsigned int opcode)
+static __always_inline void __test_cpacf_r2_null(unsigned int opcode)
 {
 	report_prefix_push("r2 null");
 	expect_pgm_int();
@@ -95,7 +96,7 @@ static inline void __test_cpacf_r2_null(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r3_odd(unsigned int opcode)
+static __always_inline void __test_cpacf_r3_odd(unsigned int opcode)
 {
 	report_prefix_push("r3 odd");
 	expect_pgm_int();
@@ -104,7 +105,7 @@ static inline void __test_cpacf_r3_odd(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r3_null(unsigned int opcode)
+static __always_inline void __test_cpacf_r3_null(unsigned int opcode)
 {
 	report_prefix_push("r3 null");
 	expect_pgm_int();
@@ -113,7 +114,7 @@ static inline void __test_cpacf_r3_null(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_mod_bit(unsigned int opcode)
+static __always_inline void __test_cpacf_mod_bit(unsigned int opcode)
 {
 	report_prefix_push("mod bit");
 	expect_pgm_int();
@@ -122,7 +123,7 @@ static inline void __test_cpacf_mod_bit(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_invalid_func(unsigned int opcode)
+static __always_inline void __test_cpacf_invalid_func(unsigned int opcode)
 {
 	report_prefix_push("invalid subfunction");
 	expect_pgm_int();
@@ -137,7 +138,7 @@ static inline void __test_cpacf_invalid_func(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_invalid_parm(unsigned int opcode)
+static __always_inline void __test_cpacf_invalid_parm(unsigned int opcode)
 {
 	report_prefix_push("invalid parm address");
 	expect_pgm_int();
@@ -146,7 +147,7 @@ static inline void __test_cpacf_invalid_parm(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_protected_parm(unsigned int opcode)
+static __always_inline void __test_cpacf_protected_parm(unsigned int opcode)
 {
 	report_prefix_push("protected parm address");
 	expect_pgm_int();
@@ -157,7 +158,7 @@ static inline void __test_cpacf_protected_parm(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_basic_cpacf_opcode(unsigned int opcode)
+static __always_inline void __test_basic_cpacf_opcode(unsigned int opcode)
 {
 	bool mod_bit_allowed = false;
 
-- 
2.26.2

