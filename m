Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EAB5BDE3F
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiITHcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiITHcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:32:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA2C5727D;
        Tue, 20 Sep 2022 00:32:13 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7Bx1I005791;
        Tue, 20 Sep 2022 07:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=bAHhLZtUowHFMN52SbTEI5xHh+QJ2+pR39YAxJjXst8=;
 b=OkzBIWti9If85ivNDacWvZ/EKcPYmi0RRjNqtk0PAZQ+abiUBdkMb6+ULixXOt1Vj8wn
 4nT+uKF29Gh+u3uwr7cs2uy/9LBZ/448cu+7vLUIBvZOOuOWrgCGN7vkkMuK2JzDC+Uk
 ut3Nu5Q2EOYOoOHg/YsRWFnSAwMxbMxvAU9vW8LAF6umgRhoPHDLftPUQUSJoSjchTV7
 /7LCadGX85pUdM/KLYG8JDWaL2yetB91piSUSdCDEj9zxrmXK2Dl02uu/NhVOAogXQrF
 uoMCSqKipEbk/rnZ6mmo4ZSfsiEuy9/VfUDfKgFp6TT0buJ0bCq8F55JvZCbG8Ng8/Ws BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu8hxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:13 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7FSEp021363;
        Tue, 20 Sep 2022 07:32:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu8hwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7L1Lf029298;
        Tue, 20 Sep 2022 07:32:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3jn5v8kgba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7S9BJ17236362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:28:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 432E111C04C;
        Tue, 20 Sep 2022 07:32:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47E9D11C04A;
        Tue, 20 Sep 2022 07:32:06 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:32:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 07/11] s390x: add extint loop test
Date:   Tue, 20 Sep 2022 07:30:31 +0000
Message-Id: <20220920073035.29201-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 924NXMrXU3yWLPbr210iA6T5Xuh3vDaM
X-Proofpoint-GUID: 1Vbsm155IX25g8XcFyqms3lUHZcuREdf
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

The CPU timer interrupt stays pending as long as the CPU timer value is
negative. This can lead to interruption loops when the ext_new_psw mask
has external interrupts enabled and the CPU timer subclass in CR0 is
enabled.

QEMU is able to detect this situation and panic the guest, so add a test
for it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220823103833.156942-4-nrb@linux.ibm.com
Message-Id: <20220823103833.156942-4-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile            |  1 +
 s390x/panic-loop-extint.c | 59 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg       |  6 ++++
 3 files changed, 66 insertions(+)
 create mode 100644 s390x/panic-loop-extint.c

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c1..e4649da5 100644
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
index 00000000..07325147
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
index f7b1fc3d..b1b25f11 100644
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
2.34.1

