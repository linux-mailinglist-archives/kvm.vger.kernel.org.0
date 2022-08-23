Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463C159D943
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 12:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243275AbiHWJ5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 05:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243093AbiHWJya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 05:54:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5608F9FAB3
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 01:46:37 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N7IEou019571
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gMRqhsoBUU97vssOCtgd9gVfHhDCiei9PfaEJSq6tuU=;
 b=fIc4GK0UIsIFbN2yK9+RFcXX2QRm+QgUL8i4GWynOLK2PCU/BKg8bzRgzhcTuwpDpYIy
 9PrBTMe97Fb6Yz9ZAkCVsoTJGiY078MIB22fG+wj+MzjoevhkAHzbfQWlXSQnTBuroNV
 eAq0SWOW8YUaMHu+LX5Iy4iJvrmIQP+0oOe29ajErGufIv69iNeV50tgkK/NURzI9CX0
 MI64U+/bwR0zd1bB8NbXB+43um0XyPDto+Dy7DNmM0UYaD/eKuTfwOu/ZnmqPQAsaFm3
 z/6uFUzNu9P2bH+LtLAYsgmyIGYEMA3r4GngKzEfQUiivUHtmqp7fiGrl42LH4JeVbpY YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4tctapmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:32 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N8SDPp027955
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4tctapm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 08:45:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N8MfxI011436;
        Tue, 23 Aug 2022 08:45:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88ugca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 08:45:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N8gSKe28574144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 08:42:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7FDAAE04D;
        Tue, 23 Aug 2022 08:45:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88870AE051;
        Tue, 23 Aug 2022 08:45:26 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 08:45:26 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 4/4] s390x: add pgm spec interrupt loop test
Date:   Tue, 23 Aug 2022 10:45:25 +0200
Message-Id: <20220823084525.52365-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220823084525.52365-1-nrb@linux.ibm.com>
References: <20220823084525.52365-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4YnKNLCjkMxwslmpBQeuCGVMsyPHmySR
X-Proofpoint-ORIG-GUID: nE62qGk1uSTJ4CFSAetlm2BOVTz3F0-d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 clxscore=1015 mlxscore=0 spamscore=0 mlxlogscore=930
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230032
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

