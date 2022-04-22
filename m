Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3350B5B4
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446943AbiDVK6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446934AbiDVK55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:57:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD64AE47;
        Fri, 22 Apr 2022 03:55:03 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MAP3RG025833;
        Fri, 22 Apr 2022 10:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Kxj0+j/Jg812IAocnjjXaPzLWYZknfmR/54PX7P2lkY=;
 b=FmpAzItVpEIW5xxa58QMj18bGOMEUMHCm/vP9h5mE095tIWLwTwDxqQyyUf0VmmyeuyT
 P/9rq+Yu+ITRa8ZV8ZhXER/lLj3wMfyF2QJFddIDkEXl+EJpyZzvov43vKCaZ3B590pg
 4yRwgZICjhxYe8na0+aUnQe9BabfPW5epVjqj/+1Y4RiXN8uJY6VCne+nruKgb2RS65w
 7wbteFkfEwdgCm6KWdKzTA13SXhllMecr7I+5C3ttRmZEM3n/Qy/xjrmNriunjI3FvWu
 eZZ2p5Id4uSTXnVY14x4a6qoqtqfJqQdRSbCWQJZ9Vnni1AHi8ZGDkChXb7f5dukd6sc aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkm5pyfn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:03 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MAqtIu016924;
        Fri, 22 Apr 2022 10:55:02 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkm5pyfmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:02 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MAsBDn010198;
        Fri, 22 Apr 2022 10:55:00 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8ybfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MAg49L54133038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 10:42:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D96B6AE059;
        Fri, 22 Apr 2022 10:54:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F85CAE05A;
        Fri, 22 Apr 2022 10:54:56 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 10:54:56 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 4/4] s390x: add basic migration test
Date:   Fri, 22 Apr 2022 12:54:53 +0200
Message-Id: <20220422105453.2153299-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220422105453.2153299-1-nrb@linux.ibm.com>
References: <20220422105453.2153299-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -jozRLVZhHEYIZeBH3bTx8u11DPrwY6p
X-Proofpoint-GUID: 7HV3qJzQBWqF8RfhEJS8q0Im4WztY_ku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204220046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a basic migration test for s390x. This tests the guarded-storage registers
and vector registers are preserved on migration.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/migration.c   | 172 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   5 ++
 3 files changed, 178 insertions(+)
 create mode 100644 s390x/migration.c

diff --git a/s390x/Makefile b/s390x/Makefile
index f38f442b9cb1..5336ed8ae0b4 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -30,6 +30,7 @@ tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
 tests += $(TEST_DIR)/epsw.elf
 tests += $(TEST_DIR)/adtl-status.elf
+tests += $(TEST_DIR)/migration.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration.c b/s390x/migration.c
new file mode 100644
index 000000000000..2f31fc53bf68
--- /dev/null
+++ b/s390x/migration.c
@@ -0,0 +1,172 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Migration Test for s390x
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <asm/arch_def.h>
+#include <asm/vector.h>
+#include <asm/barrier.h>
+#include <gs.h>
+#include <bitops.h>
+#include <smp.h>
+
+static struct gs_cb gs_cb;
+static struct gs_epl gs_epl;
+
+/* set by CPU1 to signal it has completed */
+static int flag_thread_complete;
+/* set by CPU0 to signal migration has completed */
+static int flag_migration_complete;
+
+static void write_gs_regs(void)
+{
+	const unsigned long gs_area = 0x2000000;
+	const unsigned long gsc = 25; /* align = 32 M, section size = 512K */
+
+	gs_cb.gsd = gs_area | gsc;
+	gs_cb.gssm = 0xfeedc0ffe;
+	gs_cb.gs_epl_a = (uint64_t) &gs_epl;
+
+	load_gs_cb(&gs_cb);
+}
+
+static void check_gs_regs(void)
+{
+	struct gs_cb gs_cb_after_migration;
+
+	store_gs_cb(&gs_cb_after_migration);
+
+	report_prefix_push("guarded-storage registers");
+
+	report(gs_cb_after_migration.gsd == gs_cb.gsd, "gsd matches");
+	report(gs_cb_after_migration.gssm == gs_cb.gssm, "gssm matches");
+	report(gs_cb_after_migration.gs_epl_a == gs_cb.gs_epl_a, "gs_epl_a matches");
+
+	report_prefix_pop();
+}
+
+static void test_func(void)
+{
+	uint8_t expected_vec_contents[VEC_REGISTER_NUM][VEC_REGISTER_SIZE];
+	uint8_t actual_vec_contents[VEC_REGISTER_NUM][VEC_REGISTER_SIZE];
+	uint8_t *vec_reg;
+	int i;
+	int vec_result = 0;
+
+	for (i = 0; i < VEC_REGISTER_NUM; i++) {
+		vec_reg = &expected_vec_contents[i][0];
+		/* i+1 to avoid zero content */
+		memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
+	}
+
+	ctl_set_bit(0, CTL0_VECTOR);
+	ctl_set_bit(2, CTL2_GUARDED_STORAGE);
+
+	write_gs_regs();
+
+	/*
+	 * It is important loading the vector/floating point registers and
+	 * comparing their contents occurs in the same inline assembly block.
+	 * Otherwise, the compiler is allowed to re-use the registers for
+	 * something else in between.
+	 * For this very reason, this also runs on a second CPU, so all the
+	 * complex console stuff can be done in C on the first CPU and here we
+	 * just need to wait for it to set the flag.
+	 */
+	asm inline(
+		"	.machine z13\n"
+		/* load vector registers: vlm handles at most 16 registers at a time */
+		"	vlm 0,15, 0(%[expected_vec_reg])\n"
+		"	vlm 16,31, 256(%[expected_vec_reg])\n"
+		/* inform CPU0 we are done, it will request migration */
+		"	mvhi %[flag_thread_complete], 1\n"
+		/* wait for migration to finish */
+		"0:	clfhsi %[flag_migration_complete], 1\n"
+		"	jnz 0b\n"
+		/*
+		 * store vector register contents in actual_vec_reg: vstm
+		 * handles at most 16 registers at a time
+		 */
+		"	vstm 0,15, 0(%[actual_vec_reg])\n"
+		"	vstm 16,31, 256(%[actual_vec_reg])\n"
+		/*
+		 * compare the contents in expected_vec_reg with actual_vec_reg:
+		 * clc handles at most 256 bytes at a time
+		 */
+		"	clc 0(256, %[expected_vec_reg]), 0(%[actual_vec_reg])\n"
+		"	jnz 1f\n"
+		"	clc 256(256, %[expected_vec_reg]), 256(%[actual_vec_reg])\n"
+		"	jnz 1f\n"
+		/* success */
+		"	mvhi %[vec_result], 1\n"
+		"1:"
+		:
+		: [expected_vec_reg] "a"(expected_vec_contents),
+		  [actual_vec_reg] "a"(actual_vec_contents),
+		  [flag_thread_complete] "Q"(flag_thread_complete),
+		  [flag_migration_complete] "Q"(flag_migration_complete),
+		  [vec_result] "Q"(vec_result)
+		: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
+		  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
+		  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
+		  "v28", "v29", "v30", "v31", "cc", "memory"
+	);
+
+	report(vec_result, "vector contents match");
+
+	check_gs_regs();
+
+	report(stctg(0) & BIT(CTL0_VECTOR), "ctl0 vector bit set");
+	report(stctg(2) & BIT(CTL2_GUARDED_STORAGE), "ctl2 guarded-storage bit set");
+
+	ctl_clear_bit(0, CTL0_VECTOR);
+	ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
+
+	flag_thread_complete = 1;
+}
+
+int main(void)
+{
+	struct psw psw;
+
+	/* don't say migrate here otherwise we will migrate right away */
+	report_prefix_push("migration");
+
+	if (smp_query_num_cpus() == 1) {
+		report_skip("need at least 2 cpus for this test");
+		goto done;
+	}
+
+	/* Second CPU does the actual tests */
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+	smp_cpu_setup(1, psw);
+
+	/* wait for thread setup */
+	while(!flag_thread_complete)
+		mb();
+	flag_thread_complete = 0;
+
+	/* ask migrate_cmd to migrate (it listens for 'migrate') */
+	puts("Please migrate me, then press return\n");
+
+	/* wait for migration to finish, we will read a newline */
+	(void)getchar();
+
+	flag_migration_complete = 1;
+
+	/* wait for thread to complete assertions */
+	while(!flag_thread_complete)
+		mb();
+
+	smp_cpu_destroy(1);
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 256c71691adc..b456b2881448 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -171,3 +171,8 @@ file = adtl-status.elf
 smp = 2
 accel = tcg
 extra_params = -cpu qemu,gs=off,vx=off
+
+[migration]
+file = migration.elf
+groups = migration
+smp = 2
-- 
2.31.1

