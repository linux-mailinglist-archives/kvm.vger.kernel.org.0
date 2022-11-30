Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E90A63D802
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiK3OXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiK3OXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:23:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1D912D2E
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:23:01 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUE5X0E005190;
        Wed, 30 Nov 2022 14:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wzpoGDafi0okupBMlUbNNOCWDtawE0AesLmsYXJ4pc4=;
 b=CilTQUAvaiOB8E4MFoXoYFidEgEZYbXIOn1+AsFYEbgaIpZ3cDbIm5pyKn3V/iPdLAy9
 iL8NPWGHx+QKZCigQ9VULOauHm5I21ndOQv5RdZUltY9zRVTcKFpZLUYbre9JEsOuX68
 d51EUu8jyzCbGVh4uTEsd3a1mPtP1Ts5717sGSfaPWLHFB0/DU3mEBGBjgthoYqLSBs5
 gk2t9/kuhmIPrr5nbC3H6y5AUGV8RjxUov3EwKe1xrE3FH3jW/cVVximpB/9lei03Zal
 1NClWH41Md7G4+qbRg6OY+qi+JtKIiwN2c/+QclfgsfGze2vlV9VO5Curs8v0QxaRN62 NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m68ms0djr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUE6GWc007562;
        Wed, 30 Nov 2022 14:22:56 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m68ms0dj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:55 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUEKkt6018134;
        Wed, 30 Nov 2022 14:22:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hv943-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUEMpYM54460682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:22:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BEFFAE056;
        Wed, 30 Nov 2022 14:22:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A85C6AE045;
        Wed, 30 Nov 2022 14:22:50 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 14:22:50 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/4] powerpc: use migrate_once() in migration tests
Date:   Wed, 30 Nov 2022 15:22:47 +0100
Message-Id: <20221130142249.3558647-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221130142249.3558647-1-nrb@linux.ibm.com>
References: <20221130142249.3558647-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eGNPun9jdh6klVhqiY24at0PH5oOgYAZ
X-Proofpoint-GUID: 845wA4WoeSP7s0Q7K034BDktN5Q-ULrG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=786 spamscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 powerpc/Makefile.common | 1 +
 powerpc/sprs.c          | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 12c280c15fff..8ce00340b6be 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -36,6 +36,7 @@ cflatobjs += lib/getchar.o
 cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/migrate.o
 cflatobjs += lib/powerpc/io.o
 cflatobjs += lib/powerpc/hcall.o
 cflatobjs += lib/powerpc/setup.o
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index d3c8780e8376..5cc1cd16cfda 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -21,6 +21,7 @@
  */
 #include <libcflat.h>
 #include <util.h>
+#include <migrate.h>
 #include <alloc.h>
 #include <asm/handlers.h>
 #include <asm/hcall.h>
@@ -285,8 +286,7 @@ int main(int argc, char **argv)
 	get_sprs(before);
 
 	if (pause) {
-		puts("Now migrate the VM, then press a key to continue...\n");
-		(void) getchar();
+		migrate_once();
 	} else {
 		puts("Sleeping...\n");
 		handle_exception(0x900, &dec_except_handler, &decr);
-- 
2.36.1

