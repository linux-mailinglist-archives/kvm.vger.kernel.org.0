Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B26259D93A
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 12:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243394AbiHWJ5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 05:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242468AbiHWJyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 05:54:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EF06E2CC
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 01:46:26 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N8VR7B007070
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c+MhKz20DPOUu+7pvTYTF2nN6bEoGpY3p+5x14Yggs4=;
 b=AWxjOn5lO7rHPoWNtlW+AWM0+qXwr2zvW2WV2EU03HThyTSqy10ckEnwVMmyLQMQESL7
 dLhXmLMxe3l0XMMiE5oowmPXwFivydnL9w3WrrAzkHHYq/tqiHeSSp2q56xXmUOMdebt
 JpXna/dTYFeQc0K56Vds5YLvpS9CDgrYgX0QgfThrvlLRCb89d02g6QChKXK9Jp38A3m
 hTeNJ8U1hgKyR6blj5CW0By0kCTuBFkOm97IRnEoGDjBRlywqsOek2P4x+lcZIXolWej
 gCETCwL0Q97ZcyRz10z81QwiF0MaEW6GbCrg3cnH61YgD3UFPxwOpAB7evAUJgTVIkr1 oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4uf78ctk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:32 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N8WMWc011627
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:45:32 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4uf78csm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 08:45:31 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N8LtZO031745;
        Tue, 23 Aug 2022 08:45:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3j2q88tjbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 08:45:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N8gSeM28574142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 08:42:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D7BEAE04D;
        Tue, 23 Aug 2022 08:45:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EA16AE058;
        Tue, 23 Aug 2022 08:45:26 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 08:45:26 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 3/4] s390x: add extint loop test
Date:   Tue, 23 Aug 2022 10:45:24 +0200
Message-Id: <20220823084525.52365-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220823084525.52365-1-nrb@linux.ibm.com>
References: <20220823084525.52365-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M4LKghP4mjd7HPKCa6Eta6gZa0egzmxd
X-Proofpoint-ORIG-GUID: _iBjiJfb3joipfNcaqmM5tAtUUcmC6JA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=850
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 s390x/panic-loop-extint.c | 59 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg       |  6 ++++
 3 files changed, 66 insertions(+)
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
index 000000000000..07325147dc17
--- /dev/null
+++ b/s390x/panic-loop-extint.c
@@ -0,0 +1,59 @@
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
+#include <bitops.h>
+
+static void ext_int_cleanup(struct stack_frame_int *stack)
+{
+	/*
+	 * Since we form a loop of ext interrupts, this code should never be
+	 * executed. In case it is executed, something went wrong and we want to
+	 * print a failure.
+	 *
+	 * Because the CPU timer subclass mask is still enabled, the CPU timer
+	 * interrupt will fire every time we enable external interrupts,
+	 * preventing us from printing the failure on the console. To avoid
+	 * this, clear the CPU timer subclass mask here.
+	 */
+	stack->crs[0] &= ~BIT(CTL0_CPU_TIMER);
+}
+
+int main(void)
+{
+	report_prefix_push("panic-loop-extint");
+
+	if (!host_is_qemu() || host_is_tcg()) {
+		report_skip("QEMU-KVM-only test");
+		goto out;
+	}
+
+	expect_ext_int();
+	lowcore.ext_new_psw.mask |= PSW_MASK_EXT;
+
+	psw_mask_set_bits(PSW_MASK_EXT);
+
+	register_ext_cleanup_func(ext_int_cleanup);
+
+	cpu_timer_set_ms(10);
+	ctl_set_bit(0, CTL0_CPU_TIMER);
+	mdelay(2000);
+
+	register_ext_cleanup_func(NULL);
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

