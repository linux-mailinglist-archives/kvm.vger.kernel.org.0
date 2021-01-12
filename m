Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8DE2F317B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbhALNV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:21:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729886AbhALNV4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:21:56 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CDD7ws134359;
        Tue, 12 Jan 2021 08:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2LJYac0SJdUeudi8lVHchq42sr3/3XaeFkP2reo3xbA=;
 b=XO7kxwQ3jmStR2sU3a3PshyDeM6APBMTGs5ES7x+oJ+7ft6gJTQGaYTNTg+7A7BgEssM
 oIrDohtaB6+BshmwxN/AlSy37OLshiV6QMKLZX/1MltH+nC2owdxyyYqsvAVOaRH4FOW
 dJq0Vdjy52tJWWam5C62U/I1BV45h+wnYelU2+sDrnx7ZBYFpEzp7yyXcc/sBCS0vVrY
 yk5jpl1aON4ZwFsSHoBnolGTgGSh+JBlfQPvJz6RDfNeR0tk8mt1ebhEJV9oZ2e2rO1B
 xSEs++MahlHflvzMFt9CJv8ZfP6yHwZzsRq25iCnZ/6Kgc/FcMaeQj9ejorHo0F60LLL YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361cey08m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:16 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CDEtF5142227;
        Tue, 12 Jan 2021 08:21:15 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361cey08k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:15 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDGirl000649;
        Tue, 12 Jan 2021 13:21:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 35y3rh9vuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDLA9745154640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36AD54C04A;
        Tue, 12 Jan 2021 13:21:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EBBE4C04E;
        Tue, 12 Jan 2021 13:21:09 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 1/9] s390x: Add test_bit to library
Date:   Tue, 12 Jan 2021 08:20:46 -0500
Message-Id: <20210112132054.49756-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 phishscore=0 impostorscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Query/feature bits are commonly tested via MSB bit numbers on
s390. Let's add test bit functions, so we don't need to copy code to
test query bits.

The test_bit code has been taken from the kernel since most s390x KVM unit
test developers are used to them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/bitops.h   | 26 ++++++++++++++++++++++++++
 lib/s390x/asm/facility.h |  3 ++-
 s390x/uv-guest.c         |  6 +++---
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
index e7cdda9..792881e 100644
--- a/lib/s390x/asm/bitops.h
+++ b/lib/s390x/asm/bitops.h
@@ -1,3 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *    Bitops taken from the kernel as most developers are already used
+ *    to them.
+ *
+ *    Copyright IBM Corp. 1999,2013
+ *
+ *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
+ *
+ */
 #ifndef _ASMS390X_BITOPS_H_
 #define _ASMS390X_BITOPS_H_
 
@@ -7,4 +17,20 @@
 
 #define BITS_PER_LONG	64
 
+static inline bool test_bit(unsigned long nr,
+			    const volatile unsigned long *ptr)
+{
+	const volatile unsigned char *addr;
+
+	addr = ((const volatile unsigned char *)ptr);
+	addr += (nr ^ (BITS_PER_LONG - 8)) >> 3;
+	return (*addr >> (nr & 7)) & 1;
+}
+
+static inline bool test_bit_inv(unsigned long nr,
+				const volatile unsigned long *ptr)
+{
+	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
+}
+
 #endif
diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index 7828cf8..95d4a15 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -11,13 +11,14 @@
 #include <libcflat.h>
 #include <asm/facility.h>
 #include <asm/arch_def.h>
+#include <bitops.h>
 
 #define NB_STFL_DOUBLEWORDS 32
 extern uint64_t stfl_doublewords[];
 
 static inline bool test_facility(int nr)
 {
-	return stfl_doublewords[nr / 64] & (0x8000000000000000UL >> (nr % 64));
+	return test_bit_inv(nr, stfl_doublewords);
 }
 
 static inline void stfl(void)
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index bc947ab..e51b85e 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -75,11 +75,11 @@ static void test_query(void)
 	 * Ultravisor version and are expected to always be available
 	 * because they are basic building blocks.
 	 */
-	report(uvcb.inst_calls_list[0] & (1UL << (63 - BIT_UVC_CMD_QUI)),
+	report(test_bit_inv(BIT_UVC_CMD_QUI, &uvcb.inst_calls_list[0]),
 	       "query indicated");
-	report(uvcb.inst_calls_list[0] & (1UL << (63 - BIT_UVC_CMD_SET_SHARED_ACCESS)),
+	report(test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
 	       "share indicated");
-	report(uvcb.inst_calls_list[0] & (1UL << (63 - BIT_UVC_CMD_REMOVE_SHARED_ACCESS)),
+	report(test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
 	       "unshare indicated");
 	report_prefix_pop();
 }
-- 
2.25.1

