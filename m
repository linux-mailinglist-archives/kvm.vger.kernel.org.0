Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0341574E81A
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 09:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjGKHff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 03:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjGKHfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 03:35:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E676133;
        Tue, 11 Jul 2023 00:35:32 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B7IBX7002230;
        Tue, 11 Jul 2023 07:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3fcbSdbmi46rvejGXu7hDdhkVklBvx95m1jfAUxoIdc=;
 b=HbWWdwRI9vB/hUtFgpMOk188skJN3mWAmR373vgo/CIWbW+ksdmhwQhR1VB7YSanVYli
 5DHcaCcYSra0ZNw2a3ksxsvgyhfqz/U25R2+njxBlSL/eiNCTZfoCKgEuaRVf5fmja1b
 W5Td75dg2fTbLhD8HJfpc9+ruzAE+41OZA47xWh7pdkob+Vt/E869r1DLeOT4WVUh2Y5
 VL97uPQd1MCma3LQ9jZa5Ur2DpcSaJYZpY9wqgSv8h+U9JU6XgSMpzi49Db3iowDs+8A
 dhzUHErvDbksT+XU8M3okWScHfoFFuQ2dJ7XnmArkXOmwJIlKGgLT+oeinWjsh7iTFsa wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs28ugvu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:31 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36B7C1cd012352;
        Tue, 11 Jul 2023 07:35:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs28ugvke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B4pQMW003945;
        Tue, 11 Jul 2023 07:35:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rpye59nhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 07:35:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36B7ZGPf24969892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 07:35:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F0862005A;
        Tue, 11 Jul 2023 07:35:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03DCE2004B;
        Tue, 11 Jul 2023 07:35:16 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 07:35:15 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 5/6] s390x: lib: sie: don't reenter SIE on pgm int
Date:   Tue, 11 Jul 2023 09:35:13 +0200
Message-Id: <20230711073514.413364-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230711073514.413364-1-nrb@linux.ibm.com>
References: <20230711073514.413364-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TXLayjXJNcTnh1llFCgRf_E_lQNz-CcD
X-Proofpoint-ORIG-GUID: 13kx_SMXbUyktpkBbrW-_KLI-NI4SaT2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_04,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=23 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 spamscore=23 lowpriorityscore=0
 mlxscore=23 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=54 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110066
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
index 55759002dce2..9e509d2f4f1e 100644
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
+ * Returns 0 when none occurred.
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

