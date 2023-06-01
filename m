Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2789C7193DA
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 09:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjFAHCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 03:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjFAHCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 03:02:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3909198;
        Thu,  1 Jun 2023 00:02:10 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3516pINP017345;
        Thu, 1 Jun 2023 07:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FtKRHxHTmvDZe4DmZFPWFJOx6yz24l5NyxQv5vE6qFE=;
 b=nCC+Ss0/ehatUnFUbunUi5vGq3xdOwbt8W2oJuwW0uilJ8vol43oKbs8zLELn4dIpw2W
 X8eaV7GtRzLBS7JBC1pdtFPW4gplP27j2oKRkTQ9fFZWQ8tEox41CB0DLaIVC9ZuVhP9
 F1GWW69lqysIWQTBbeGPgJK8NJJjwVT/Mq6HquE20vvCNVZojK98uMd+ZNpDrQMHnDNy
 HPXSnbLwXyOrjM0DEI2F9j96AaoKTkZP+JfDz11aX9aayrX9RZ5t2zlo0/SOrV2hO1Uj
 6YNRu9KIpe6a8C7tUZPun3Jiokolb+I3TUzQZQce0eSmocsbRxAl4CX6Wk5qt/6BYUpn ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpe98ac8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:09 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3516rS5E025029;
        Thu, 1 Jun 2023 07:02:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxpe98ab8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3514t4xZ010933;
        Thu, 1 Jun 2023 07:02:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qu94e2cc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 07:02:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351723CS17892030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 07:02:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEA3320040;
        Thu,  1 Jun 2023 07:02:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5ED720043;
        Thu,  1 Jun 2023 07:02:03 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 07:02:03 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 5/6] s390x: lib: sie: don't reenter SIE on pgm int
Date:   Thu,  1 Jun 2023 09:02:01 +0200
Message-Id: <20230601070202.152094-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230601070202.152094-1-nrb@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TA4xvMmkMDwCEVTrlwH7jJ-s3mm7X8eT
X-Proofpoint-ORIG-GUID: sbHdrP2b-uJeVVnX-hHaZmCOPFNGRTS-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_04,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=13 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=13 lowpriorityscore=0
 mlxlogscore=83 priorityscore=1501 clxscore=1015 phishscore=0
 impostorscore=0 spamscore=13 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2306010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, when a PGM int occurs while in SIE, we will just reenter
SIE after the interrupt handler was called.

This is because sie() has a loop which checks icptcode and re-enters SIE
if it is zero.

However, this behaviour is quite undesirable for SIE tests, since it
doesn't give the host the chance to assert on the PGM int. Instead, we
will just re-enter SIE, on nullifing conditions even causing the
exception again.

In sie(), check whether a pgm int code is set in lowcore. If it has,
exit the loop so the test can react to the interrupt. Add a new function
read_pgm_int_code() to obtain the interrupt code.

Note that this introduces a slight oddity with sie and pgm int in
certain cases: If a PGM int occurs between a expect_pgm_int() and sie(),
we will now never enter SIE until the pgm_int_code is cleared by e.g.
clear_pgm_int().

Also add missing include of facility.h to mem.h.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 14 ++++++++++++++
 lib/s390x/asm/mem.h       |  1 +
 lib/s390x/sie.c           |  4 +++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 55759002dce2..fb4283a40a1b 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -99,4 +99,18 @@ static inline void low_prot_disable(void)
 	ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
 }
 
+/**
+ * read_pgm_int_code - Get the program interruption code of the last pgm int
+ * on the current CPU.
+ *
+ * This is similar to clear_pgm_int(), except that it doesn't clear the
+ * interruption information from lowcore.
+ *
+ * Returns 0 when none occured.
+ */
+static inline uint16_t read_pgm_int_code(void)
+{
+	return lowcore.pgm_int_code;
+}
+
 #endif
diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 64ef59b546a4..94d58c34f53f 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -8,6 +8,7 @@
 #ifndef _ASMS390X_MEM_H_
 #define _ASMS390X_MEM_H_
 #include <asm/arch_def.h>
+#include <asm/facility.h>
 
 /* create pointer while avoiding compiler warnings */
 #define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index ffa8ec91a423..632740edd431 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <sie.h>
 #include <asm/page.h>
+#include <asm/interrupt.h>
 #include <libcflat.h>
 #include <alloc_page.h>
 
@@ -65,7 +66,8 @@ void sie(struct vm *vm)
 	/* also handle all interruptions in home space while in SIE */
 	irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
 
-	while (vm->sblk->icptcode == 0) {
+	/* leave SIE when we have an intercept or an interrupt so the test can react to it */
+	while (vm->sblk->icptcode == 0 && !read_pgm_int_code()) {
 		sie64a(vm->sblk, &vm->save_area);
 		sie_handle_validity(vm);
 	}
-- 
2.39.1

