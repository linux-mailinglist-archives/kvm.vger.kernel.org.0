Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0654A99B3
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344641AbiBDNJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 08:09:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43204 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235167AbiBDNJD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 08:09:03 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214ChJii007048
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G6MUxAE93v3vdyjC8QwrqNPuBqpJgQJFV4BdOjis5Qk=;
 b=lOJyaTO1I/zUoVA081l8ACmE5lc6iVLa5eEhDsVoI3rn9P0iK+q6QCIsZuhoGXi/Ubk4
 OCLHXF+5Plgi6cpEIrMfmhk1VzrF8ueO/CYuiEftnWb9yQSZulAK040aCcZXKSdtyU+V
 h5VOKn8Bqrzpjl9XqDZHIBkKzpu0Plb7m3Rm+LzMKsZU2l4q+/rlTSuLDc1rX+cXjUJL
 qMgPtAyLj4WH3wN+LN7sm7Ro3K3OMAjTmsPPcaB5ZVdAZiqJlccCYwMB2ayEI7SKCpTL
 ECJUXyrigfL357g0YJh4uQSDBnWJsa2q5+rsXyxGRJyxOV6TFwAjiIQNtfZGRahxsY2B Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0rj5mk9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:09:02 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214CjPSf025718
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:02 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0rj5mk97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:02 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214D7VDC019530;
        Fri, 4 Feb 2022 13:09:00 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10d0t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214D8v9140632666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 13:08:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 686B44C075;
        Fri,  4 Feb 2022 13:08:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02B0D4C040;
        Fri,  4 Feb 2022 13:08:57 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 13:08:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/6] lib: s390x: smp: guarantee that boot CPU has index 0
Date:   Fri,  4 Feb 2022 14:08:50 +0100
Message-Id: <20220204130855.39520-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204130855.39520-1-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oyayI_4OfnV1fdhzFVzgRPNBT4w6rUyn
X-Proofpoint-GUID: xH3-SdLgEmfHd1b6_gYjMYpSdKWvKVWj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guarantee that the boot CPU has index 0. This simplifies the
implementation of tests that require multiple CPUs.

Also fix a small bug in the allocation of the cpus array.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: f77c0515 ("s390x: Add initial smp code")
Fixes: 52076a63 ("s390x: Consolidate sclp read info")
---
 lib/s390x/smp.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index b753eab5..eae742d2 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -25,7 +25,6 @@
 #include "sclp.h"
 
 static struct cpu *cpus;
-static struct cpu *cpu0;
 static struct spinlock lock;
 
 extern void smp_cpu_setup_state(void);
@@ -69,7 +68,7 @@ static int smp_cpu_stop_nolock(uint16_t addr, bool store)
 	uint8_t order = store ? SIGP_STOP_AND_STORE_STATUS : SIGP_STOP;
 
 	cpu = smp_cpu_from_addr(addr);
-	if (!cpu || cpu == cpu0)
+	if (!cpu || addr == cpus[0].addr)
 		return -1;
 
 	if (sigp_retry(addr, order, 0, NULL))
@@ -193,7 +192,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
 
 	/* Copy all exception psws. */
-	memcpy(lc, cpu0->lowcore, 512);
+	memcpy(lc, cpus[0].lowcore, 512);
 
 	/* Setup stack */
 	cpu->stack = (uint64_t *)alloc_pages(2);
@@ -251,15 +250,27 @@ void smp_setup(void)
 	if (num > 1)
 		printf("SMP: Initializing, found %d cpus\n", num);
 
-	cpus = calloc(num, sizeof(cpus));
+	cpus = calloc(num, sizeof(*cpus));
 	for (i = 0; i < num; i++) {
 		cpus[i].addr = entry[i].address;
 		cpus[i].active = false;
+		/*
+		 * Fill in the boot CPU. If the boot CPU is not at index 0,
+		 * swap it with the one at index 0. This guarantees that the
+		 * boot CPU will always have index 0. If the boot CPU was
+		 * already at index 0, a few extra useless assignments are
+		 * performed, but everything will work ok.
+		 * Notice that there is no guarantee that the list of CPUs
+		 * returned by the Read SCP Info command is in any
+		 * particular order, or that its order will stay consistent
+		 * across multiple invocations.
+		 */
 		if (entry[i].address == cpu0_addr) {
-			cpu0 = &cpus[i];
-			cpu0->stack = stackptr;
-			cpu0->lowcore = (void *)0;
-			cpu0->active = true;
+			cpus[i].addr = cpus[0].addr;
+			cpus[0].addr = cpu0_addr;
+			cpus[0].stack = stackptr;
+			cpus[0].lowcore = (void *)0;
+			cpus[0].active = true;
 		}
 	}
 	spin_unlock(&lock);
-- 
2.34.1

