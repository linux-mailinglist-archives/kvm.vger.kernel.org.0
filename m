Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11403C72B1
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhGMPAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 11:00:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236763AbhGMPAK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 11:00:10 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DEiC5T152191;
        Tue, 13 Jul 2021 10:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8InjtTwK2Gj19YVq5E6P4bRkKFdPWik/iF+YPgDio0U=;
 b=HHQR9UuGF5xf8ylWqELyyzqPcu5dL6h2Xam6Egps0NrlFYUDhsiCd3ZTHkHdD4xf81KC
 VQWMu2bfStJUpLDA5niEwMUDZk/hyavUWrOZJMbtpvTzsWJEkd1Y84A5G2C4ezsA3eff
 1IVbkHKI49IJunsQuXfzlTXN9e78HvYgIQzNLa5kuThJ6npxpHJVhrWQuzFeM9gKzxOy
 lSmIQQ8qzZ2LCWURuWGt1V9K7hde/mffe2SZnIXDqq8dYSgKRnXRq5bMkibKEADNl9Ir
 vO0iy/OcjTKEP4eGU+x7b943zSyWh5qhjsEPwytbupfmksYflFRtp38+SeYrv4vn5Vov IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qs2w8h2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 10:57:20 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16DEik4I157416;
        Tue, 13 Jul 2021 10:57:19 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qs2w8h1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 10:57:19 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16DEs4vd019810;
        Tue, 13 Jul 2021 14:57:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 39q3689bhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Jul 2021 14:57:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16DEvDfo31916390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 14:57:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A432CA4066;
        Tue, 13 Jul 2021 14:57:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FC8BA4062;
        Tue, 13 Jul 2021 14:57:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Jul 2021 14:57:13 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: generate kvm hypercall functions
Date:   Tue, 13 Jul 2021 16:57:13 +0200
Message-Id: <20210713145713.2815167-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ij-scCgbljwk-ub35cFr7Hq0qk7SuQt4
X-Proofpoint-GUID: UtY0O9LieVMLPVZWjCfixofLmt-gDcDJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_07:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generate kvm hypercall functions with a macro instead of duplicating
the more or less identical code seven times. This also reduces number
of lines of code.
However the main purpose is to get rid of as many as possible open
coded error prone register asm constructs in s390 architecture code.

For the only user of kvm_hypercall identical code is created
before/after this patch (drivers/s390/virtio/virtio_ccw.c).

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/kvm_para.h | 229 ++++++++++---------------------
 1 file changed, 73 insertions(+), 156 deletions(-)

diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
index cbc7c3a68e4d..df73a052760c 100644
--- a/arch/s390/include/asm/kvm_para.h
+++ b/arch/s390/include/asm/kvm_para.h
@@ -24,162 +24,79 @@
 #include <uapi/asm/kvm_para.h>
 #include <asm/diag.h>
 
-static inline long __kvm_hypercall0(unsigned long nr)
-{
-	register unsigned long __nr asm("1") = nr;
-	register long __rc asm("2");
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr): "memory", "cc");
-	return __rc;
-}
-
-static inline long kvm_hypercall0(unsigned long nr)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __kvm_hypercall0(nr);
-}
-
-static inline long __kvm_hypercall1(unsigned long nr, unsigned long p1)
-{
-	register unsigned long __nr asm("1") = nr;
-	register unsigned long __p1 asm("2") = p1;
-	register long __rc asm("2");
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr), "0" (__p1) : "memory", "cc");
-	return __rc;
-}
-
-static inline long kvm_hypercall1(unsigned long nr, unsigned long p1)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __kvm_hypercall1(nr, p1);
-}
-
-static inline long __kvm_hypercall2(unsigned long nr, unsigned long p1,
-			       unsigned long p2)
-{
-	register unsigned long __nr asm("1") = nr;
-	register unsigned long __p1 asm("2") = p1;
-	register unsigned long __p2 asm("3") = p2;
-	register long __rc asm("2");
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2)
-		      : "memory", "cc");
-	return __rc;
-}
-
-static inline long kvm_hypercall2(unsigned long nr, unsigned long p1,
-			       unsigned long p2)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __kvm_hypercall2(nr, p1, p2);
-}
-
-static inline long __kvm_hypercall3(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3)
-{
-	register unsigned long __nr asm("1") = nr;
-	register unsigned long __p1 asm("2") = p1;
-	register unsigned long __p2 asm("3") = p2;
-	register unsigned long __p3 asm("4") = p3;
-	register long __rc asm("2");
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
-			"d" (__p3) : "memory", "cc");
-	return __rc;
-}
-
-static inline long kvm_hypercall3(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __kvm_hypercall3(nr, p1, p2, p3);
-}
-
-static inline long __kvm_hypercall4(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3,
-			       unsigned long p4)
-{
-	register unsigned long __nr asm("1") = nr;
-	register unsigned long __p1 asm("2") = p1;
-	register unsigned long __p2 asm("3") = p2;
-	register unsigned long __p3 asm("4") = p3;
-	register unsigned long __p4 asm("5") = p4;
-	register long __rc asm("2");
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
-			"d" (__p3), "d" (__p4) : "memory", "cc");
-	return __rc;
-}
-
-static inline long kvm_hypercall4(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3,
-			       unsigned long p4)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __kvm_hypercall4(nr, p1, p2, p3, p4);
-}
-
-static inline long __kvm_hypercall5(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3,
-			       unsigned long p4, unsigned long p5)
-{
-	register unsigned long __nr asm("1") = nr;
-	register unsigned long __p1 asm("2") = p1;
-	register unsigned long __p2 asm("3") = p2;
-	register unsigned long __p3 asm("4") = p3;
-	register unsigned long __p4 asm("5") = p4;
-	register unsigned long __p5 asm("6") = p5;
-	register long __rc asm("2");
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
-			"d" (__p3), "d" (__p4), "d" (__p5)  : "memory", "cc");
-	return __rc;
-}
-
-static inline long kvm_hypercall5(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3,
-			       unsigned long p4, unsigned long p5)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __kvm_hypercall5(nr, p1, p2, p3, p4, p5);
-}
-
-static inline long __kvm_hypercall6(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3,
-			       unsigned long p4, unsigned long p5,
-			       unsigned long p6)
-{
-	register unsigned long __nr asm("1") = nr;
-	register unsigned long __p1 asm("2") = p1;
-	register unsigned long __p2 asm("3") = p2;
-	register unsigned long __p3 asm("4") = p3;
-	register unsigned long __p4 asm("5") = p4;
-	register unsigned long __p5 asm("6") = p5;
-	register unsigned long __p6 asm("7") = p6;
-	register long __rc asm("2");
-
-	asm volatile ("diag 2,4,0x500\n"
-		      : "=d" (__rc) : "d" (__nr), "0" (__p1), "d" (__p2),
-			"d" (__p3), "d" (__p4), "d" (__p5), "d" (__p6)
-		      : "memory", "cc");
-	return __rc;
-}
-
-static inline long kvm_hypercall6(unsigned long nr, unsigned long p1,
-			       unsigned long p2, unsigned long p3,
-			       unsigned long p4, unsigned long p5,
-			       unsigned long p6)
-{
-	diag_stat_inc(DIAG_STAT_X500);
-	return __kvm_hypercall6(nr, p1, p2, p3, p4, p5, p6);
-}
+#define HYPERCALL_FMT_0
+#define HYPERCALL_FMT_1 , "0" (r2)
+#define HYPERCALL_FMT_2 , "d" (r3) HYPERCALL_FMT_1
+#define HYPERCALL_FMT_3 , "d" (r4) HYPERCALL_FMT_2
+#define HYPERCALL_FMT_4 , "d" (r5) HYPERCALL_FMT_3
+#define HYPERCALL_FMT_5 , "d" (r6) HYPERCALL_FMT_4
+#define HYPERCALL_FMT_6 , "d" (r7) HYPERCALL_FMT_5
+
+#define HYPERCALL_PARM_0
+#define HYPERCALL_PARM_1 , unsigned long arg1
+#define HYPERCALL_PARM_2 HYPERCALL_PARM_1, unsigned long arg2
+#define HYPERCALL_PARM_3 HYPERCALL_PARM_2, unsigned long arg3
+#define HYPERCALL_PARM_4 HYPERCALL_PARM_3, unsigned long arg4
+#define HYPERCALL_PARM_5 HYPERCALL_PARM_4, unsigned long arg5
+#define HYPERCALL_PARM_6 HYPERCALL_PARM_5, unsigned long arg6
+
+#define HYPERCALL_REGS_0
+#define HYPERCALL_REGS_1						\
+	register unsigned long r2 asm("2") = arg1
+#define HYPERCALL_REGS_2						\
+	HYPERCALL_REGS_1;						\
+	register unsigned long r3 asm("3") = arg2
+#define HYPERCALL_REGS_3						\
+	HYPERCALL_REGS_2;						\
+	register unsigned long r4 asm("4") = arg3
+#define HYPERCALL_REGS_4						\
+	HYPERCALL_REGS_3;						\
+	register unsigned long r5 asm("5") = arg4
+#define HYPERCALL_REGS_5						\
+	HYPERCALL_REGS_4;						\
+	register unsigned long r6 asm("6") = arg5
+#define HYPERCALL_REGS_6						\
+	HYPERCALL_REGS_5;						\
+	register unsigned long r7 asm("7") = arg6
+
+#define HYPERCALL_ARGS_0
+#define HYPERCALL_ARGS_1 , arg1
+#define HYPERCALL_ARGS_2 HYPERCALL_ARGS_1, arg2
+#define HYPERCALL_ARGS_3 HYPERCALL_ARGS_2, arg3
+#define HYPERCALL_ARGS_4 HYPERCALL_ARGS_3, arg4
+#define HYPERCALL_ARGS_5 HYPERCALL_ARGS_4, arg5
+#define HYPERCALL_ARGS_6 HYPERCALL_ARGS_5, arg6
+
+#define GENERATE_KVM_HYPERCALL_FUNC(args)				\
+static inline								\
+long __kvm_hypercall##args(unsigned long nr HYPERCALL_PARM_##args)	\
+{									\
+	register unsigned long __nr asm("1") = nr;			\
+	register long __rc asm("2");					\
+	HYPERCALL_REGS_##args;						\
+									\
+	asm volatile (							\
+		"	diag	2,4,0x500\n"				\
+		: "=d" (__rc)						\
+		: "d" (__nr) HYPERCALL_FMT_##args			\
+		: "memory", "cc");					\
+	return __rc;							\
+}									\
+									\
+static inline								\
+long kvm_hypercall##args(unsigned long nr HYPERCALL_PARM_##args)	\
+{									\
+	diag_stat_inc(DIAG_STAT_X500);					\
+	return __kvm_hypercall##args(nr HYPERCALL_ARGS_##args);		\
+}
+
+GENERATE_KVM_HYPERCALL_FUNC(0)
+GENERATE_KVM_HYPERCALL_FUNC(1)
+GENERATE_KVM_HYPERCALL_FUNC(2)
+GENERATE_KVM_HYPERCALL_FUNC(3)
+GENERATE_KVM_HYPERCALL_FUNC(4)
+GENERATE_KVM_HYPERCALL_FUNC(5)
+GENERATE_KVM_HYPERCALL_FUNC(6)
 
 /* kvm on s390 is always paravirtualization enabled */
 static inline int kvm_para_available(void)
-- 
2.25.1

