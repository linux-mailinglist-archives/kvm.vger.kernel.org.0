Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B25C59E4C1
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 15:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbiHWN5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 09:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241246AbiHWN5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 09:57:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A1122D07A
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 04:03:25 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NAUkeU006633
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i9Qft+jKEvNj+wZkEwNQlreZiejqO02PDN+lrQ/miuQ=;
 b=Ydv/psmHLykC3t4QvRnySyEs8ckM8rErPec5yr2cisNa1oL0eVZ+ZHClAFSK0Oc0uhcz
 1qHGCQvLVUQZV29FoVnzZ2hD8+ZPNtmkI1fimGMtD/Y/whQhqvkYSTnlaAJEdTEQXzeD
 2PjWAVjKt8KXvKD1QqNcDHtTb8MlhyZTNMapOZys/q+3+0MiK5Ou6kSdjHZb5iFD8icV
 SjcPbE9ssS42VeYsRRre6H3sCKbfuixEVKJCnexS6iW0ia1QJ3cr7L2QFl6EZt3OoAuG
 10CTQjXNBoFviocgrg9iIivT7MFxg2Ql2uWRpgllz01tn3lblENd1YQv+8nuKq8uoXIo UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4w7508wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:40 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NAVAZg008080
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:40 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4w7508v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 10:38:40 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NAKkGP015660;
        Tue, 23 Aug 2022 10:38:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3j2q88tnd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 10:38:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NAcYP828049828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 10:38:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F6F342041;
        Tue, 23 Aug 2022 10:38:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C72442052;
        Tue, 23 Aug 2022 10:38:34 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 10:38:34 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v6 4/4] s390x: add pgm spec interrupt loop test
Date:   Tue, 23 Aug 2022 12:38:33 +0200
Message-Id: <20220823103833.156942-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220823103833.156942-1-nrb@linux.ibm.com>
References: <20220823103833.156942-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y5ktHg1wWV8_Q-l7GcYKr_i3ykEmFlsT
X-Proofpoint-GUID: SG-DvArvczBr4d2YHR5N7sjnYXCmXCZs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=919 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An invalid PSW causes a program interrupt. When an invalid PSW is
introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
program interrupt is caused.

QEMU should detect that and panic the guest, hence add a test for it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@de.ibm.com>
---
 s390x/Makefile         |  1 +
 s390x/panic-loop-pgm.c | 38 ++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  6 ++++++
 3 files changed, 45 insertions(+)
 create mode 100644 s390x/panic-loop-pgm.c

diff --git a/s390x/Makefile b/s390x/Makefile
index e4649da50d9d..66415d0b588d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -35,6 +35,7 @@ tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
 tests += $(TEST_DIR)/panic-loop-extint.elf
+tests += $(TEST_DIR)/panic-loop-pgm.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/panic-loop-pgm.c b/s390x/panic-loop-pgm.c
new file mode 100644
index 000000000000..23e973477f68
--- /dev/null
+++ b/s390x/panic-loop-pgm.c
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Program interrupt loop test
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <bitops.h>
+#include <asm/interrupt.h>
+#include <asm/barrier.h>
+#include <hardware.h>
+
+int main(void)
+{
+	report_prefix_push("panic-loop-pgm");
+
+	if (!host_is_qemu() || host_is_tcg()) {
+		report_skip("QEMU-KVM-only test");
+		goto out;
+	}
+
+	expect_pgm_int();
+	/* bit 12 set is invalid */
+	lowcore.pgm_new_psw.mask = extract_psw_mask() | BIT(63 - 12);
+	mb();
+
+	/* cause a pgm int */
+	psw_mask_set_bits(BIT(63 - 12));
+
+	report_fail("survived pgm int loop");
+
+out:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b1b25f118ff6..f9f102abfa89 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -191,3 +191,9 @@ file = panic-loop-extint.elf
 groups = panic
 accel = kvm
 timeout = 5
+
+[panic-loop-pgm]
+file = panic-loop-pgm.elf
+groups = panic
+accel = kvm
+timeout = 5
-- 
2.36.1

