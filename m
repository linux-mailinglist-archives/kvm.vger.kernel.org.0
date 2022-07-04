Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D29656549F
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiGDMNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiGDMNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:13:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B83DC2A;
        Mon,  4 Jul 2022 05:13:36 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264A6sx8003652;
        Mon, 4 Jul 2022 12:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Y0s2c2cC2YUxaYrFpTibMG5rQhdHzFoh5Y5Fu+yrnYI=;
 b=fZREMt5o61YIJ1yKL/w13HkqN7+pqsxqdSsuq35PgwmVuypbM0dKwQWxq3OCRDbUExBE
 kmymsHYXt8mD7RVKqHavrHbJsgUJUqbPIuvRrSIxqacECqRMCE9ZsMGcCWouoEdbXrlP
 y21zicGd6UQ1laY8qV6pdcIcfZLg963nREZv14SB+jP2oSkCW3gfWerFl4ia/2D5jUxw
 CO8SaF+12SsKkQci8U5cdlJYySNSgVsYkwPOMeKbLr2h0BXQAJtWk3jd7llhr0EDRoCn
 m1S75Fc+IwQLDi/nUZzqilrmOi+4a63utvUSlCd2S6Ej2IGX22LbdORszzyoCDl8nDsE lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3w0dchce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264BjZkr022768;
        Mon, 4 Jul 2022 12:13:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3w0dchbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264C6RaH008385;
        Mon, 4 Jul 2022 12:13:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3h2dn8j05u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264CDT9h23658908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 12:13:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BAFC5204F;
        Mon,  4 Jul 2022 12:13:29 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 37F6C52057;
        Mon,  4 Jul 2022 12:13:29 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/4] s390x: add extint loop test
Date:   Mon,  4 Jul 2022 14:13:27 +0200
Message-Id: <20220704121328.721841-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704121328.721841-1-nrb@linux.ibm.com>
References: <20220704121328.721841-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: USR3UNlstCWP1QU-NbtNKP_JZf5YO5Ts
X-Proofpoint-GUID: 4jH7ai7LSC-J7CULNgs-LHqC9Hvj-toR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=984 priorityscore=1501 suspectscore=0
 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040052
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
index 000000000000..b1d9cf3565af
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
+	cpu_timer_set(1);
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
index 8e52f560bb1e..53aeb94f382c 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -184,3 +184,9 @@ groups = migration
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

