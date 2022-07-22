Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11E957D9E6
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 08:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiGVGAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 02:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiGVGAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 02:00:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B17654661
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 23:00:51 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M5bmep027376
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sV1P2ghKA+GDHTMVuJKtpJpli9k8wheqGzOL9pg9QVQ=;
 b=AC6UmJV8MATVNyXzPRAWq0Os28weExRzf12eaTzdGAqxQgGqKpG35Lrh0sOWPoPeDqzU
 GNLpYVxJjhQvrQuZYPbYnXaGbeFDAAFXgBy1U+TR4JEurQgBB4GrBmF2EDxUVvjg08Px
 mR6RfwNz+VFTZGfFUW9vSlFjT4T9AMeqUKt/VmR/BsdUDeNafBHMogwDYnwkkPU8O+qt
 1sN89Ohp0uvLvHrmEvrjyh3r5vBJpMl9m3vXdEFZgPQXRSyzLNIjVRbm54zdRLt6cLHi
 h+WuxxiTzETlwv5UOyHn5qtYZDBl//BH8QFbCJcy3CMaZFgUS1Clz23ItVhlH6DHy548 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfnkg8v9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M5tOqN018296
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfnkg8v8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M5p5ur012549;
        Fri, 22 Jul 2022 06:00:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3hbmy8ny7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M60jPY25100658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 06:00:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C9495204E;
        Fri, 22 Jul 2022 06:00:45 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DE3D952050;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 4/4] s390x: add pgm spec interrupt loop test
Date:   Fri, 22 Jul 2022 08:00:43 +0200
Message-Id: <20220722060043.733796-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722060043.733796-1-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P8hc7TLI6G1B3b-t-KsxnUPQT5VDTfaQ
X-Proofpoint-GUID: Rc5LfxNRXP5h_-dVVtnNuQ1PVLs2QUjI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 mlxlogscore=832
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220021
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 s390x/Makefile         |  1 +
 s390x/panic-loop-pgm.c | 53 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  6 +++++
 3 files changed, 60 insertions(+)
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
index 000000000000..68934057a251
--- /dev/null
+++ b/s390x/panic-loop-pgm.c
@@ -0,0 +1,53 @@
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
+static void pgm_int_handler(void)
+{
+	/*
+	 * return to pgm_old_psw. This gives us the chance to print the return_fail
+	 * in case something goes wrong.
+	 */
+	asm volatile (
+		"lpswe %[pgm_old_psw]\n"
+		:
+		: [pgm_old_psw] "Q"(lowcore.pgm_old_psw)
+		: "memory"
+	);
+}
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
+	lowcore.pgm_new_psw.addr = (uint64_t) pgm_int_handler;
+	/* bit 12 set is invalid */
+	lowcore.pgm_new_psw.mask = extract_psw_mask() | BIT(63 - 12);
+	mb();
+
+	/* cause a pgm int */
+	*((int *)-4) = 0x42;
+	mb();
+
+	report_fail("survived pgmint loop");
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

