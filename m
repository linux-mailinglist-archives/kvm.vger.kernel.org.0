Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD7C4BA313
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiBQOfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:35:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241916AbiBQOff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:35 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694302B1671
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:21 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HCbDCu024479
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tVzgnu0EO5plArQi+iY/t0/4mta2VDSmZVDpRCNMwCE=;
 b=N+b/BnEIdC3dwbXtfkcUebniN6zKIcxdPc5X5pbYzcUgwFYMWy77qS749xM0II0Vss/o
 NSOVDswx16B4UXGWDSDLUhGnYSEoXWdQ2tupKjgeEiJh5qoV54dd9cgeY0ca3cB2NjzT
 CnFDM5i0FK6YfMuyehe/HgMvJix7ZsVxnv29Rk2TPR7S2kCA4ciD95S4ktOAh0Z/l1li
 hXiq11MjbxZqvoo2GfKhGP0lSpbqJeJrueSSOg0EzBFurfsMp4/oijr64oTE0/wMqjk3
 k8+3+N98E+CST92elr5+m0ozm/h34YDv1PccsbN3dUBSOglvBORQDJP4lek6QZ38Tr// aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9m1ypay0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:20 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HDEHOW035228
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9m1ypax2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEXQH4006417;
        Thu, 17 Feb 2022 14:35:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645kbdrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZFl945678878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF50D42047;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F8264204D;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 4/9] lib: s390x: smp: guarantee that boot CPU has index 0
Date:   Thu, 17 Feb 2022 15:34:59 +0100
Message-Id: <20220217143504.232688-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XW5czm3a-3_PuguRmrQyqmskCjdn6UK5
X-Proofpoint-ORIG-GUID: Cdni1qFd1yrRFFF41M6anagCXtMAqdZo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guarantee that the boot CPU has index 0. This simplifies the
implementation of tests that require multiple CPUs.

Also fix a small bug in the allocation of the cpus array.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: f77c0515 ("s390x: Add initial smp code")
Fixes: 52076a63 ("s390x: Consolidate sclp read info")
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
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

