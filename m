Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAE23E7D69
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 18:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhHJQW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 12:22:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231688AbhHJQWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 12:22:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17AG3oUX095145;
        Tue, 10 Aug 2021 12:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+hl3e9EtRm6l6GseU01zM7y+nkCBfXd4LcfuZwQcDBY=;
 b=jMJ2WLe2dqes5SxBlDxqShDP85I2l2qI8Rk0u+S/TuDrD/Tm0QJ7Rcf22OpkaLHr+cs3
 Rbtyga7ZAFxXxGqy5HKYHnESuHGid2ZmVNK1GneG/fiNdVRsm1fqLzWgjJF+id5U2+y/
 Kj3/tf+EpaloL7ZANx+NQfU2wY+mW17nXqvRkRP2362SmYxrFJGa4VoI9kpUU/7ptAyj
 kzHVUmBIsBhdkBbm2TodpuIdFiAdKAvnDoF6yStiOQnhPhQ4dGTThpzAwJmBYUnkpFm5
 8vRdpnCJUECujYJt323YDp2hHBFrokhNsUi22F6dRoBvyKQ7Ch7BjCQSvqcG1CUVCw2o IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abg7kv847-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:32 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17AG3vBn095603;
        Tue, 10 Aug 2021 12:22:31 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3abg7kv83c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:31 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17AGGmUG026710;
        Tue, 10 Aug 2021 16:22:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3abtdng969-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 16:22:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17AGMQ9v48693614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 16:22:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FE67AE055;
        Tue, 10 Aug 2021 16:22:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38DFEAE045;
        Tue, 10 Aug 2021 16:22:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.176.19])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Aug 2021 16:22:26 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Simplify stsi_get_fc and move it to library
Date:   Tue, 10 Aug 2021 18:22:22 +0200
Message-Id: <1628612544-25130-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fe_VShxVJ3KnPJm1onhMdkruxjcgRnuR
X-Proofpoint-ORIG-GUID: VGmLjVsBVVW37S-jr1AwLjVKANiLRbD9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_07:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

stsi_get_fc is now needed in multiple tests.

As it does not need to store information but only returns
the machine level, suppress the address parameter.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
 s390x/stsi.c             | 20 ++------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 15cf7d48..2f70d840 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -328,6 +328,22 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
 	return cc;
 }
 
+static inline unsigned long stsi_get_fc(void)
+{
+	register unsigned long r0 asm("0") = 0;
+	register unsigned long r1 asm("1") = 0;
+	int cc;
+
+	asm volatile("stsi	0\n"
+		     "ipm	%[cc]\n"
+		     "srl	%[cc],28\n"
+		     : "+d" (r0), [cc] "=d" (cc)
+		     : "d" (r1)
+		     : "cc", "memory");
+	assert(!cc);
+	return r0 >> 28;
+}
+
 static inline int servc(uint32_t command, unsigned long sccb)
 {
 	int cc;
diff --git a/s390x/stsi.c b/s390x/stsi.c
index 87d48047..391f8849 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -71,28 +71,12 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
-static inline unsigned long stsi_get_fc(void *addr)
-{
-	register unsigned long r0 asm("0") = 0;
-	register unsigned long r1 asm("1") = 0;
-	int cc;
-
-	asm volatile("stsi	0(%[addr])\n"
-		     "ipm	%[cc]\n"
-		     "srl	%[cc],28\n"
-		     : "+d" (r0), [cc] "=d" (cc)
-		     : "d" (r1), [addr] "a" (addr)
-		     : "cc", "memory");
-	assert(!cc);
-	return r0 >> 28;
-}
-
 static void test_fc(void)
 {
 	report(stsi(pagebuf, 7, 0, 0) == 3, "invalid fc");
 	report(stsi(pagebuf, 1, 0, 1) == 3, "invalid selector 1");
 	report(stsi(pagebuf, 1, 1, 0) == 3, "invalid selector 2");
-	report(stsi_get_fc(pagebuf) >= 2, "query fc >= 2");
+	report(stsi_get_fc() >= 2, "query fc >= 2");
 }
 
 static void test_3_2_2(void)
@@ -112,7 +96,7 @@ static void test_3_2_2(void)
 	report_prefix_push("3.2.2");
 
 	/* Is the function code available at all? */
-	if (stsi_get_fc(pagebuf) < 3) {
+	if (stsi_get_fc() < 3) {
 		report_skip("Running under lpar, no level 3 to test.");
 		goto out;
 	}
-- 
2.25.1

