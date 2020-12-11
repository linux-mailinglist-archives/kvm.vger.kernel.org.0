Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE972D7352
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 11:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405730AbgLKKDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 05:03:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394098AbgLKKCV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 05:02:21 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BBA1X7P024715;
        Fri, 11 Dec 2020 05:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2LJYac0SJdUeudi8lVHchq42sr3/3XaeFkP2reo3xbA=;
 b=BaMkkw+i51nyJ84gGS+9eTP3wxun3BELxQj9hNX3COXd77hyJNE08Co9ARFq8fT8lAkg
 s3ztilcisTzyzv9fbui7LT90k1XddMNJWSAyxN0nQHL512czaJXIz3LPXYZ2c9TW8Oat
 IJ7oq+MPRJSEkDD/088lqXTSP+bA7bW0bgl8kBWm3Ox2z1f2YT+P6T1+A4Sakra50XJT
 05zvXGYKe4pPhIBVDI9FPH26JDK7f+ISxkpYGIeT7XHA+iCaWjQEi7QwJC189kaIannu
 y1kOPTt5e6ayxFtEapH7b4ezVPH6b+AEc128ICfnO72GNzVUMo+tHWWM+pbEWjs3eWQy DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6ka82c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:36 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BBA1ZFv024898;
        Fri, 11 Dec 2020 05:01:35 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6ka82ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:35 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BB9romo022873;
        Fri, 11 Dec 2020 10:01:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u86unh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 10:01:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBA1UZd6291886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 10:01:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA90FA405E;
        Fri, 11 Dec 2020 10:01:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23404A404D;
        Fri, 11 Dec 2020 10:01:29 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 10:01:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/8] s390x: Add test_bit to library
Date:   Fri, 11 Dec 2020 05:00:32 -0500
Message-Id: <20201211100039.63597-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211100039.63597-1-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110059
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

