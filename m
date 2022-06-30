Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E1F561931
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiF3LbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiF3LbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:31:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF48851B2A;
        Thu, 30 Jun 2022 04:31:06 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UAoOEm023339;
        Thu, 30 Jun 2022 11:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pcFwXFlN+GDQRC3bWiGg7hjU57KgfWkw3ni/5sSCplY=;
 b=jmJq4Up/97GLaj3kdwgeqMzWOb8YS8RDXLTcYsNn4TOYnGVWEUPyqfSKVwZwHQzLKUtU
 AQY25cqjFhZcaneim3VEKuwEZEJ8NSv31ooxaYiDI1IsTpXKsCKbMGUxDliWGWaMqsQd
 hLo4vg0VwC5+xCsRi/5uyqUXBQTRY5dsDTNub8QnMal8m0caSs3Wuk8TFuP91NSmt12s
 ckhCJiEUA8Mm3zz7j4ncNoze3XR0d2mIIYCP4pAMFfH4liayA0CWqRqN9HIM06L4ABQL
 c5q4Svvm+pcJD2gPuVqsQfE5/S1/1wMIn+DQCw8j8viIBP8iuJuufxgF5WHertjmZ1kF 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ae2h1np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:05 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UAtpCW014706;
        Thu, 30 Jun 2022 11:31:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ae2h1mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UBLMBl013466;
        Thu, 30 Jun 2022 11:31:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj821a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:03 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UBV05u17236474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 11:31:00 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31093A405B;
        Thu, 30 Jun 2022 11:31:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB37BA405F;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/3] s390x: add extint loop test
Date:   Thu, 30 Jun 2022 13:30:58 +0200
Message-Id: <20220630113059.229221-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630113059.229221-1-nrb@linux.ibm.com>
References: <20220630113059.229221-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TtZZS62Qy6Rd4XU8V2xNjVE5mVwtDZ1G
X-Proofpoint-ORIG-GUID: ND9ZHDXpm1hg_5VP0yxjLLq8tzzET48A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=841 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206300043
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
---
 s390x/Makefile      |  1 +
 s390x/extint-loop.c | 64 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  4 +++
 3 files changed, 69 insertions(+)
 create mode 100644 s390x/extint-loop.c

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c13102..92a020234c9f 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
+tests += $(TEST_DIR)/extint-loop.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/extint-loop.c b/s390x/extint-loop.c
new file mode 100644
index 000000000000..5276d86a156f
--- /dev/null
+++ b/s390x/extint-loop.c
@@ -0,0 +1,64 @@
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
+static void start_cpu_timer(int64_t timeout_ms)
+{
+#define CPU_TIMER_US_SHIFT 12
+	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_US_SHIFT;
+	asm volatile (
+		"spt %[timer_value]\n"
+		:
+		: [timer_value] "Q" (timer_value)
+	);
+}
+
+int main(void)
+{
+	struct psw ext_new_psw_orig;
+
+	report_prefix_push("extint-loop");
+
+	ext_new_psw_orig = lowcore.ext_new_psw;
+	lowcore.ext_new_psw.addr = (uint64_t)ext_int_handler;
+	lowcore.ext_new_psw.mask |= PSW_MASK_EXT;
+
+	load_psw_mask(extract_psw_mask() | PSW_MASK_EXT);
+	ctl_set_bit(0, CTL0_CLOCK_COMPARATOR);
+
+	start_cpu_timer(1);
+
+	mdelay(2000);
+
+	/* restore previous ext_new_psw so QEMU can properly terminate */
+	lowcore.ext_new_psw = ext_new_psw_orig;
+
+	report_fail("survived extint loop");
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 8e52f560bb1e..7d408f2d5310 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -184,3 +184,7 @@ groups = migration
 [migration-skey]
 file = migration-skey.elf
 groups = migration
+
+[extint-loop]
+file = extint-loop.elf
+groups = panic
-- 
2.36.1

