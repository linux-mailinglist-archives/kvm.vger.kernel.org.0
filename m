Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9216357D9E8
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 08:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiGVGA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 02:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbiGVGAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 02:00:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFA959253
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 23:00:51 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M4gM6m029772
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D7Bkh6bGHW7CMF3pqCftO5hvr3pZU/Xqw3YowyclYqc=;
 b=dWXVr9bX44Ur8eDQIYasUmQ5BbZjm/BApfu+MIotw9L/GxhCifT1BA3nngZTXGOyX6Hu
 8QFnrHw4YCEv+EVsABElcwScpdv0sBYAbc3V3SSCTaBKyEDeURAGHORj8OrG1hLIYvn4
 Vlaf29874r9blBxwomyroklmWbneJje5N4nUDcpb8HeEEaE+/OE5NaUexwu2sG+YYX28
 yW/1Pick1wm1nzq2Ludwc3xwGFiYMkEofGff13fXFUt0GozS2dyl6TLUd4liSqwUgbaR
 45Fudx1/HnCElqq6eRfWJsTnTIMbEgVRvOYgbgdLTmKOz0gxjmkpKLYvUolZD9R+TGQm zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfn3hsp5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:51 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M5s9AZ006121
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:51 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfn3hsp49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:50 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M5pw6v027049;
        Fri, 22 Jul 2022 06:00:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8ny6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M60i4t19464560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 06:00:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD5295204E;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A9FCA52051;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/4] s390x: add extint loop test
Date:   Fri, 22 Jul 2022 08:00:42 +0200
Message-Id: <20220722060043.733796-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722060043.733796-1-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EhyQzYxurOSsV2sVeMKeKtm_cNdzf1mN
X-Proofpoint-GUID: WbpgWlvy6bYAqxgXB1JNSeV5zJYEPWyW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 bulkscore=0 mlxlogscore=917
 clxscore=1015 spamscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220021
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The CPU timer interrupt stays pending as long as the CPU timer value is
negative. This can lead to interruption loops when the ext_new_psw mask
has external interrupts enabled.

QEMU is able to detect this situation and panic the guest, so add a test
for it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile            |  1 +
 s390x/panic-loop-extint.c | 60 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg       |  6 ++++
 3 files changed, 67 insertions(+)
 create mode 100644 s390x/panic-loop-extint.c

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c13102..e4649da50d9d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
+tests += $(TEST_DIR)/panic-loop-extint.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
new file mode 100644
index 000000000000..d3a3f06d9a34
--- /dev/null
+++ b/s390x/panic-loop-extint.c
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * External interrupt loop test
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <asm/interrupt.h>
+#include <asm/barrier.h>
+#include <asm/time.h>
+#include <hardware.h>
+
+static void ext_int_handler(void)
+{
+	/*
+	 * return to ext_old_psw. This gives us the chance to print the return_fail
+	 * in case something goes wrong.
+	 */
+	asm volatile (
+		"lpswe %[ext_old_psw]\n"
+		:
+		: [ext_old_psw] "Q"(lowcore.ext_old_psw)
+		: "memory"
+	);
+}
+
+int main(void)
+{
+	struct psw ext_new_psw_orig;
+
+	report_prefix_push("panic-loop-extint");
+
+	if (!host_is_qemu() || host_is_tcg()) {
+		report_skip("QEMU-KVM-only test");
+		goto out;
+	}
+
+	ext_new_psw_orig = lowcore.ext_new_psw;
+	lowcore.ext_new_psw.addr = (uint64_t)ext_int_handler;
+	lowcore.ext_new_psw.mask |= PSW_MASK_EXT;
+
+	load_psw_mask(extract_psw_mask() | PSW_MASK_EXT);
+	ctl_set_bit(0, CTL0_CLOCK_COMPARATOR);
+
+	cpu_timer_set_ms(1);
+
+	mdelay(2000);
+
+	/* restore previous ext_new_psw so QEMU can properly terminate */
+	lowcore.ext_new_psw = ext_new_psw_orig;
+
+	report_fail("survived extint loop");
+
+out:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f7b1fc3dbca1..b1b25f118ff6 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -185,3 +185,9 @@ groups = migration
 [migration-skey]
 file = migration-skey.elf
 groups = migration
+
+[panic-loop-extint]
+file = panic-loop-extint.elf
+groups = panic
+accel = kvm
+timeout = 5
-- 
2.36.1

