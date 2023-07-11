Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4AC74F182
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbjGKOQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjGKOQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4DA198C
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:30 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BECdac014734;
        Tue, 11 Jul 2023 14:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=HrwgG9DB8fsgzucjL1d7q0x2YU8y3KIuAO6r2nFPTw0=;
 b=H0ZK3Jul4STm8Best+5GmnUni6aZyqW7Fit/HGRwZVmrq8JeUOcxzvWWap2rjP6V4NSB
 87DLH0YO0vCWkuA9igqwnzngmGfXDIP877EJQWZ8gYVPRWF0ksm5WZ6JRntwOR2MQyPA
 Z6egK0ng6PY6L5ao/1BmXsiaD7m0mopkAG8DyU+FVXyXU3/ZImcYy/bKCnk3baVVMg1T
 eDvMa/CKHfBr7SBoH4q26qMySABSgpY2cy3K8Z3J+YLURd4ipHv9Vvz7ni7uG/uGvkbu
 xSCJo3jzmjKFVWsN1v7vGtlYzryemWAX6Sb025DHfDecOcj9zoe5YJyX/uWRziJ4a06U Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my05uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:20 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEEVTV024351;
        Tue, 11 Jul 2023 14:16:19 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my05ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:19 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B6wun0021820;
        Tue, 11 Jul 2023 14:16:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3rpye5hcj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:16 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGDPP21955242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 127482004D;
        Tue, 11 Jul 2023 14:16:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9378420043;
        Tue, 11 Jul 2023 14:16:12 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:12 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 05/22] lib: s390x: uv: Add intercept data check library function
Date:   Tue, 11 Jul 2023 16:15:38 +0200
Message-ID: <20230711141607.40742-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I_jVd0-_WEX7laVlXym4xyjCo5AcjEeK
X-Proofpoint-ORIG-GUID: fk3w80NRT4na2CO1qm2xwIeiEwQFm4BD
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

When working with guests it's essential to check the SIE intercept
data for the correct values. Fortunately on PV guests these values are
constants so we can create check functions which test for the
constants.

While we're at it let's make pv-diags.c use this new function.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230619083329.22680-4-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/pv_icptdata.h | 42 +++++++++++++++++++++++++++++++++++++++++
 s390x/pv-diags.c        | 14 ++++++--------
 2 files changed, 48 insertions(+), 8 deletions(-)
 create mode 100644 lib/s390x/pv_icptdata.h

diff --git a/lib/s390x/pv_icptdata.h b/lib/s390x/pv_icptdata.h
new file mode 100644
index 0000000..4746117
--- /dev/null
+++ b/lib/s390x/pv_icptdata.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Commonly used checks for PV SIE intercept data
+ *
+ * Copyright IBM Corp. 2023
+ * Author: Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#ifndef _S390X_PV_ICPTDATA_H_
+#define _S390X_PV_ICPTDATA_H_
+
+#include <sie.h>
+
+/*
+ * Checks the diagnose instruction intercept data for consistency with
+ * the constants defined by the PV SIE architecture
+ *
+ * Supports: 0x44, 0x9c, 0x288, 0x308, 0x500
+ */
+static bool pv_icptdata_check_diag(struct vm *vm, int diag)
+{
+	int icptcode;
+
+	switch (diag) {
+	case 0x44:
+	case 0x9c:
+	case 0x288:
+	case 0x308:
+		icptcode = ICPT_PV_NOTIFY;
+		break;
+	case 0x500:
+		icptcode = ICPT_PV_INSTR;
+		break;
+	default:
+		/* If a new diag is introduced add it to the cases above! */
+		assert(0);
+	}
+
+	return vm->sblk->icptcode == icptcode && vm->sblk->ipa == 0x8302 &&
+	       vm->sblk->ipb == 0x50000000 && vm->save_area.guest.grs[5] == diag;
+}
+#endif
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 5165937..096ac61 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -9,6 +9,7 @@
  */
 #include <libcflat.h>
 #include <snippet.h>
+#include <pv_icptdata.h>
 #include <sie.h>
 #include <sclp.h>
 #include <asm/facility.h>
@@ -31,8 +32,7 @@ static void test_diag_500(void)
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
-	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
-	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x500,
+	report(pv_icptdata_check_diag(&vm, 0x500),
 	       "intercept values");
 	report(vm.save_area.guest.grs[1] == 1 &&
 	       vm.save_area.guest.grs[2] == 2 &&
@@ -45,9 +45,8 @@ static void test_diag_500(void)
 	 */
 	vm.sblk->iictl = IICTL_CODE_OPERAND;
 	sie(&vm);
-	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
-	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c
-	       && vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
+	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	       vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
 	       "operand exception");
 
 	/*
@@ -58,9 +57,8 @@ static void test_diag_500(void)
 	vm.sblk->iictl = IICTL_CODE_SPECIFICATION;
 	/* Inject PGM, next exit should be 9c */
 	sie(&vm);
-	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
-	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c
-	       && vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
+	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	       vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
 	       "specification exception");
 
 	/* No need for cleanup, just tear down the VM */
-- 
2.41.0

