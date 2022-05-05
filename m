Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35751BD27
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 12:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355567AbiEEKay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 06:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355512AbiEEKax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 06:30:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD43633B;
        Thu,  5 May 2022 03:27:13 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2458x4cT005795;
        Thu, 5 May 2022 10:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FwHgYbRpHyE6GaZvQVpu67aIgfnnV41QTB8SxzjHU4s=;
 b=mBvbA6LJBzxhfKZgnAyomEYRfcK2Gv/cNRWgkK7/nG1OqRxyv926q6oN1gaUlMvnC5dd
 qx5QKaEbvkGsYoWWyLvIkWvZmUI9q0On2ztnRP6ZvrgsXQ9rjJJTKul3X67CdQJ6pKi3
 EqwVxlu31AflT8zLfRFfiIsHVS8k74+OwzWIv9hTLz9JSAawjv6+Eijb7iUyf5yVKS85
 QulUpzxJnQAxHfr7nYsAdklP2LHStx+KsrsEhQFJjoPWMJNr0dT6yPsxOJ0oVSIWXZSF
 NOXxeu4GdWFOSAySF9GoShP02+J4/yObOLrVzxKTlmdTQg48o5eEWy1/vFf45518gACC mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvbj31h2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 10:27:12 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245AE9ca006789;
        Thu, 5 May 2022 10:27:11 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvbj31h2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 10:27:11 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245AMZkY026852;
        Thu, 5 May 2022 10:27:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3frvr8nnbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 10:27:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245AR5Tv46203366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 10:27:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D412111C04C;
        Thu,  5 May 2022 10:27:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 988EF11C052;
        Thu,  5 May 2022 10:27:05 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 10:27:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1] s390x: migration: don't run tests when facilities are not there
Date:   Thu,  5 May 2022 12:27:05 +0200
Message-Id: <20220505102705.3621584-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pS3USI_lLjIonznE8OwaJNsdUqMMZgK2
X-Proofpoint-GUID: Yj1_QENTJRZJwlU_0osFV23v_5caguD2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_04,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1011 bulkscore=0
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the new migration tests, there was no check whether guarded-storage and
vector facilities are there. This may lead to crashes, especially under TCG
where guarded-storage is not supported.

Add checks for the respective facilities. Since it is possible neither
guarded-storage nor vector are there, add an additional report_pass() such that
least one PASS is reported.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/migration.c | 154 +++++++++++++++++++++++++++-------------------
 1 file changed, 90 insertions(+), 64 deletions(-)

diff --git a/s390x/migration.c b/s390x/migration.c
index 2f31fc53bf68..a45296374cd8 100644
--- a/s390x/migration.c
+++ b/s390x/migration.c
@@ -11,6 +11,7 @@
 #include <asm/arch_def.h>
 #include <asm/vector.h>
 #include <asm/barrier.h>
+#include <asm/facility.h>
 #include <gs.h>
 #include <bitops.h>
 #include <smp.h>
@@ -50,6 +51,16 @@ static void check_gs_regs(void)
 	report_prefix_pop();
 }
 
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
 static void test_func(void)
 {
 	uint8_t expected_vec_contents[VEC_REGISTER_NUM][VEC_REGISTER_SIZE];
@@ -58,74 +69,89 @@ static void test_func(void)
 	int i;
 	int vec_result = 0;
 
-	for (i = 0; i < VEC_REGISTER_NUM; i++) {
-		vec_reg = &expected_vec_contents[i][0];
-		/* i+1 to avoid zero content */
-		memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
+	if (have_guarded_storage_facility()) {
+		ctl_set_bit(2, CTL2_GUARDED_STORAGE);
+
+		write_gs_regs();
 	}
 
-	ctl_set_bit(0, CTL0_VECTOR);
-	ctl_set_bit(2, CTL2_GUARDED_STORAGE);
-
-	write_gs_regs();
-
-	/*
-	 * It is important loading the vector/floating point registers and
-	 * comparing their contents occurs in the same inline assembly block.
-	 * Otherwise, the compiler is allowed to re-use the registers for
-	 * something else in between.
-	 * For this very reason, this also runs on a second CPU, so all the
-	 * complex console stuff can be done in C on the first CPU and here we
-	 * just need to wait for it to set the flag.
-	 */
-	asm inline(
-		"	.machine z13\n"
-		/* load vector registers: vlm handles at most 16 registers at a time */
-		"	vlm 0,15, 0(%[expected_vec_reg])\n"
-		"	vlm 16,31, 256(%[expected_vec_reg])\n"
-		/* inform CPU0 we are done, it will request migration */
-		"	mvhi %[flag_thread_complete], 1\n"
-		/* wait for migration to finish */
-		"0:	clfhsi %[flag_migration_complete], 1\n"
-		"	jnz 0b\n"
-		/*
-		 * store vector register contents in actual_vec_reg: vstm
-		 * handles at most 16 registers at a time
-		 */
-		"	vstm 0,15, 0(%[actual_vec_reg])\n"
-		"	vstm 16,31, 256(%[actual_vec_reg])\n"
+	if (have_vector_facility()) {
+		for (i = 0; i < VEC_REGISTER_NUM; i++) {
+			vec_reg = &expected_vec_contents[i][0];
+			/* i+1 to avoid zero content */
+			memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
+		}
+
+		ctl_set_bit(0, CTL0_VECTOR);
+
 		/*
-		 * compare the contents in expected_vec_reg with actual_vec_reg:
-		 * clc handles at most 256 bytes at a time
+		 * It is important loading the vector/floating point registers and
+		 * comparing their contents occurs in the same inline assembly block.
+		 * Otherwise, the compiler is allowed to re-use the registers for
+		 * something else in between.
+		 * For this very reason, this also runs on a second CPU, so all the
+		 * complex console stuff can be done in C on the first CPU and here we
+		 * just need to wait for it to set the flag.
 		 */
-		"	clc 0(256, %[expected_vec_reg]), 0(%[actual_vec_reg])\n"
-		"	jnz 1f\n"
-		"	clc 256(256, %[expected_vec_reg]), 256(%[actual_vec_reg])\n"
-		"	jnz 1f\n"
-		/* success */
-		"	mvhi %[vec_result], 1\n"
-		"1:"
-		:
-		: [expected_vec_reg] "a"(expected_vec_contents),
-		  [actual_vec_reg] "a"(actual_vec_contents),
-		  [flag_thread_complete] "Q"(flag_thread_complete),
-		  [flag_migration_complete] "Q"(flag_migration_complete),
-		  [vec_result] "Q"(vec_result)
-		: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
-		  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
-		  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
-		  "v28", "v29", "v30", "v31", "cc", "memory"
-	);
-
-	report(vec_result, "vector contents match");
-
-	check_gs_regs();
-
-	report(stctg(0) & BIT(CTL0_VECTOR), "ctl0 vector bit set");
-	report(stctg(2) & BIT(CTL2_GUARDED_STORAGE), "ctl2 guarded-storage bit set");
-
-	ctl_clear_bit(0, CTL0_VECTOR);
-	ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
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
 
 	flag_thread_complete = 1;
 }
-- 
2.31.1

