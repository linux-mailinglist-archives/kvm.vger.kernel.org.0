Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4733F4A007B
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 19:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350710AbiA1SzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 13:55:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343655AbiA1Sy6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 13:54:58 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20SIC18p013415
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ytYdt8JSQZ6igAZXiSg3pm0ngS8+p3zFK/Fy+IuNoT8=;
 b=UhRjU68Fhc1nGyTeNoEds5gm7hPhE2pSXYyTYdZXBoaCvf4rob/Pbdq9Qxjneh9uUENb
 I0Sblm+Zd75bI1yFdBQVOsBqZ00Kaqn32jvksgc+2xlNHKuLjs1MzSaQMXvHKmLeaJcI
 ZoIvF1SdWO5talTdDRDiKSbLSdPNCzcxD6i1RyXeFr1K4lB8PzgoqXj7zy4aDKlmvi8u
 ZShJ4k5K1xUuhf9iAsbgBDijtmu9aXMK9rLyDwRV3LNvTVPKyic0fiT9wY5Iyn4O4OgV
 m07jy1Rnx/BAsgHALRUFm2cgf41/g9gBpDjoILajS+gpD9VaJDM9g2RfVH22NboFTc5w og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvgqwqbmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20SIdiQu008113
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvgqwqbm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20SIrJWc013645;
        Fri, 28 Jan 2022 18:54:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9ja9grd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20SIspS042598690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 18:54:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31BD7A4068;
        Fri, 28 Jan 2022 18:54:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9016A405C;
        Fri, 28 Jan 2022 18:54:50 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.7.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 18:54:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 2/5] lib: s390x: smp: guarantee that boot CPU has index 0
Date:   Fri, 28 Jan 2022 19:54:46 +0100
Message-Id: <20220128185449.64936-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128185449.64936-1-imbrenda@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q_om0z0ybW7LA-s9PYMK6pCtGpvIS9cn
X-Proofpoint-GUID: tMc0Ag8nLrxyYKt_rrdp46RQqHlgv3Nw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_05,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201280108
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
 lib/s390x/smp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 64c647ec..01f513f0 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -25,7 +25,6 @@
 #include "sclp.h"
 
 static struct cpu *cpus;
-static struct cpu *cpu0;
 static struct spinlock lock;
 
 extern void smp_cpu_setup_state(void);
@@ -81,7 +80,7 @@ static int smp_cpu_stop_nolock(uint16_t addr, bool store)
 	uint8_t order = store ? SIGP_STOP_AND_STORE_STATUS : SIGP_STOP;
 
 	cpu = smp_cpu_from_addr(addr);
-	if (!cpu || cpu == cpu0)
+	if (!cpu || addr == cpus[0].addr)
 		return -1;
 
 	if (sigp_retry(addr, order, 0, NULL))
@@ -205,7 +204,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
 
 	/* Copy all exception psws. */
-	memcpy(lc, cpu0->lowcore, 512);
+	memcpy(lc, cpus[0].lowcore, 512);
 
 	/* Setup stack */
 	cpu->stack = (uint64_t *)alloc_pages(2);
@@ -263,15 +262,16 @@ void smp_setup(void)
 	if (num > 1)
 		printf("SMP: Initializing, found %d cpus\n", num);
 
-	cpus = calloc(num, sizeof(cpus));
+	cpus = calloc(num, sizeof(*cpus));
 	for (i = 0; i < num; i++) {
 		cpus[i].addr = entry[i].address;
 		cpus[i].active = false;
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

