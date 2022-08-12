Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C41590BE9
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 08:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbiHLGWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 02:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbiHLGWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 02:22:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9BF98587
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 23:22:00 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27C6DFEq005785
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 06:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=on8UtrhAUpkH5rn1pZ9jHzZ+yxRG+cATiLi0/oGpZdU=;
 b=OCJmklAJ09lOl68c0e3H+L23s5FJzBAoyg8u93IBY6GDxspJ8r0G1bxKVZ106MsuytM2
 yPqS3DEPYjZMzva8CsNGwko0utsTBBYq7z8/vHgWA0lssoI9twttRePFwu7sszZbtJYv
 MXIOoMWcwsakBNNT80WkG41YSPkXlwv8NU0AJVMH3Rfe63xhNRFBQ7DG/WtRqqRfCSRb
 R2PGSQfbQev8Tli666DiqXDgelRdw58VIUXeZb2kwnt3BYJ9VvUdFuQFuNiyjfkr7y44
 p63jaynIlQvQ3X9ods4AwJGe2CElxrXyn8YVWeYIv1pyEAwp4BUoCPKpbbri4I1nFVnj NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwhd8r6f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 06:21:59 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27C6FMf4016512
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 06:21:59 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwhd8r6em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 06:21:59 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27C68moe007019;
        Fri, 12 Aug 2022 06:21:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3hvdjusf5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 06:21:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27C6LrTM31064456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 06:21:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07EE84203F;
        Fri, 12 Aug 2022 06:21:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C95B342041;
        Fri, 12 Aug 2022 06:21:52 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 06:21:52 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 4/4] s390x: add pgm spec interrupt loop test
Date:   Fri, 12 Aug 2022 08:21:51 +0200
Message-Id: <20220812062151.1980937-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220812062151.1980937-1-nrb@linux.ibm.com>
References: <20220812062151.1980937-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CO8lwb0PBvip5eE0r-fcaYn1w4-HuEyX
X-Proofpoint-GUID: pBus9FDYAFvcXsxbpkeg4zza-sCCnPuQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_04,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 malwarescore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 mlxlogscore=782 adultscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120016
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
---
 s390x/Makefile         |  1 +
 s390x/panic-loop-pgm.c | 39 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  6 ++++++
 3 files changed, 46 insertions(+)
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
index 000000000000..f3b23d67159c
--- /dev/null
+++ b/s390x/panic-loop-pgm.c
@@ -0,0 +1,39 @@
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

