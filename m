Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A672259875D
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbiHRPV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245599AbiHRPVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:21:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A5F6A4A2
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:21:22 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IFE3vL014437
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 15:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=F8dHGOivibUCNcx1oYtENQ1Aa7I91iE6Tn+cxUG3WNs=;
 b=UfQ2AYTqIbea1hqDqxjKyHxE1vtmVUkJs6IZVkI9hGiep1rltNru4AuHpu4MW4nlYBG2
 wf6nUgHB7jPyCuTflUp9ANJkErdc06a3fZ6hI2IiIdkzCP5zrcC2ewOtLJRUlPJhywh1
 VNBk1iFr8slW1RvXL7e2KoW5uSEKzmo4I3V6/cL47gifOntKDkLo45gzyqqqKKxfHweb
 un4H0irRshilrG0xm9hltfiBiEtgPxIqmaIzxCZUG54WHNnNl7L3XDNRKLajdGgzw9m3
 3rVpVsCFZMawF1BOP5tdP1gtgaNhK7Gu0ulzV3jstxqD1Hm+DoRYpTe31pMlXY5znq0U OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1qvr8827-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 15:21:21 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27IFEutR017495
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 15:21:20 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1qvr881a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 15:21:20 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IFLIxQ003157;
        Thu, 18 Aug 2022 15:21:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3hx37j4knk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 15:21:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IFIRhY32571688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 15:18:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62799AE04D;
        Thu, 18 Aug 2022 15:21:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 118A7AE045;
        Thu, 18 Aug 2022 15:21:15 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.166])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 15:21:14 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/1] lib/s390x: fix SMP setup bug
Date:   Thu, 18 Aug 2022 17:21:14 +0200
Message-Id: <20220818152114.213135-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OUXS0wGuC9sMDSv_B9hpFvywshSCItZh
X-Proofpoint-GUID: ZNXy-ufCf5qVWG_bGo4CYjDaHHpLuW9B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_12,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 mlxlogscore=636 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lowcore pointer pointing to the current CPU (THIS_CPU) was not
initialized for the boot CPU. The pointer is needed for correct
interrupt handling, which is needed in the setup process before the
struct cpu array is allocated.

The bug went unnoticed because some environments (like qemu/KVM) clear
all memory and don't write anything in the lowcore area before starting
the payload. The pointer thus pointed to 0, an area of memory also not
used. Other environments will write to memory before starting the
payload, causing the unit tests to crash at the first interrupt.

Fix by assigning a temporary struct cpu before the rest of the setup
process, and assigning the pointer to the correct allocated struct
during smp initialization.

Fixes: 4e5dd758 ("lib: s390x: better smp interrupt checks")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/io.c  | 9 +++++++++
 lib/s390x/smp.c | 1 +
 2 files changed, 10 insertions(+)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index a4f1b113..fb7b7dda 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -33,6 +33,15 @@ void puts(const char *s)
 
 void setup(void)
 {
+	struct cpu this_cpu_tmp = { 0 };
+
+	/*
+	 * Set a temporary empty struct cpu for the boot CPU, needed for
+	 * correct interrupt handling in the setup process.
+	 * smp_setup will allocate and set the permanent one.
+	 */
+	THIS_CPU = &this_cpu_tmp;
+
 	setup_args_progname(ipl_args);
 	setup_facilities();
 	sclp_read_info();
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 0d98c17d..03d6d2a4 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -353,6 +353,7 @@ void smp_setup(void)
 			cpus[0].stack = stackptr;
 			cpus[0].lowcore = (void *)0;
 			cpus[0].active = true;
+			THIS_CPU = &cpus[0];
 		}
 	}
 	spin_unlock(&lock);
-- 
2.37.2

