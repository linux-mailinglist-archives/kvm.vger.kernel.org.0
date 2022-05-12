Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE216524923
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352137AbiELJgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352089AbiELJfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8D620F7F
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:43 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9Q1uc003590
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UOAUyO6Fp+ud5jJs5iSlFWhAzLz+nk2drL57xkZK6CE=;
 b=NK4TaLNepHcuPtr6JoDGgXTr04PcAg0kmBSiEd7P94I1va77g8Ut1qoKCCKOBl7+F/2C
 RmZQ4hfl62CTnG2bJofDGximNQ54P83EisrPBdU/FBl8XWcAkkAD82vFXSyMhEaL9Lbk
 gEiP4vcLyTFDF2eGiWt8kR6ddiRyhCl36YnpCakSBLqXoyyETq+GNxr8LUcBUPScNKCl
 G9cAHVR48eMWqtuQ5JKfvJooipsLzQcPrxIwO26QeAnLMz2Jfqperm79ZPgRoEd87XtC
 ORKAJmCsPz9UXY/x9SNFEJCuJi8ZEp57loVxESnJE2sqpp9VFdlUdYXVvXS2oC7W2LiE Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9RuvJ011345
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XluQ010058;
        Thu, 12 May 2022 09:35:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3g0ma1gm36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZamQ50266550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDD4B11C052;
        Thu, 12 May 2022 09:35:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0F6911C04C;
        Thu, 12 May 2022 09:35:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 19/28] s390x: add basic migration test
Date:   Thu, 12 May 2022 11:35:14 +0200
Message-Id: <20220512093523.36132-20-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E_leKoe7CocQPWPBdVqzjKZDnO8_Ul-Y
X-Proofpoint-GUID: 5UITgBdITlJK25YwTLXObir7p9hS8hvD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Add a basic migration test for s390x. This tests the guarded-storage
registers and vector registers are preserved on migration.

Check for the respective facilities. Since it is possible neither
guarded-storage nor vector are there, add an additional report_pass()
such that least one PASS is reported.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/migration.c   | 198 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   5 ++
 3 files changed, 204 insertions(+)
 create mode 100644 s390x/migration.c

diff --git a/s390x/Makefile b/s390x/Makefile
index f38f442b..5336ed8a 100644
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
index 00000000..a4529637
--- /dev/null
+++ b/s390x/migration.c
@@ -0,0 +1,198 @@
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
+#include <asm/facility.h>
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
+static bool have_vector_facility(void)
+{
+	return test_facility(129);
+}
+
+static bool have_guarded_storage_facility(void)
+{
+	return test_facility(133);
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
+	if (have_guarded_storage_facility()) {
+		ctl_set_bit(2, CTL2_GUARDED_STORAGE);
+
+		write_gs_regs();
+	}
+
+	if (have_vector_facility()) {
+		for (i = 0; i < VEC_REGISTER_NUM; i++) {
+			vec_reg = &expected_vec_contents[i][0];
+			/* i+1 to avoid zero content */
+			memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
+		}
+
+		ctl_set_bit(0, CTL0_VECTOR);
+
+		/*
+		 * It is important loading the vector/floating point registers and
+		 * comparing their contents occurs in the same inline assembly block.
+		 * Otherwise, the compiler is allowed to re-use the registers for
+		 * something else in between.
+		 * For this very reason, this also runs on a second CPU, so all the
+		 * complex console stuff can be done in C on the first CPU and here we
+		 * just need to wait for it to set the flag.
+		 */
+		asm inline(
+			"	.machine z13\n"
+			/* load vector registers: vlm handles at most 16 registers at a time */
+			"	vlm 0,15, 0(%[expected_vec_reg])\n"
+			"	vlm 16,31, 256(%[expected_vec_reg])\n"
+			/* inform CPU0 we are done, it will request migration */
+			"	mvhi %[flag_thread_complete], 1\n"
+			/* wait for migration to finish */
+			"0:	clfhsi %[flag_migration_complete], 1\n"
+			"	jnz 0b\n"
+			/*
+			 * store vector register contents in actual_vec_reg: vstm
+			 * handles at most 16 registers at a time
+			 */
+			"	vstm 0,15, 0(%[actual_vec_reg])\n"
+			"	vstm 16,31, 256(%[actual_vec_reg])\n"
+			/*
+			 * compare the contents in expected_vec_reg with actual_vec_reg:
+			 * clc handles at most 256 bytes at a time
+			 */
+			"	clc 0(256, %[expected_vec_reg]), 0(%[actual_vec_reg])\n"
+			"	jnz 1f\n"
+			"	clc 256(256, %[expected_vec_reg]), 256(%[actual_vec_reg])\n"
+			"	jnz 1f\n"
+			/* success */
+			"	mvhi %[vec_result], 1\n"
+			"1:"
+			:
+			: [expected_vec_reg] "a"(expected_vec_contents),
+			  [actual_vec_reg] "a"(actual_vec_contents),
+			  [flag_thread_complete] "Q"(flag_thread_complete),
+			  [flag_migration_complete] "Q"(flag_migration_complete),
+			  [vec_result] "Q"(vec_result)
+			: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
+			  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
+			  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
+			  "v28", "v29", "v30", "v31", "cc", "memory"
+		);
+
+		report(vec_result, "vector contents match");
+
+		report(stctg(0) & BIT(CTL0_VECTOR), "ctl0 vector bit set");
+
+		ctl_clear_bit(0, CTL0_VECTOR);
+	} else {
+		flag_thread_complete = 1;
+		while(!flag_migration_complete)
+			mb();
+	}
+
+	report_pass("Migrated");
+
+	if (have_guarded_storage_facility()) {
+		check_gs_regs();
+
+		report(stctg(2) & BIT(CTL2_GUARDED_STORAGE), "ctl2 guarded-storage bit set");
+
+		ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
+	}
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
index 256c7169..b456b288 100644
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
2.36.1

