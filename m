Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F7A649D69
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 12:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiLLLS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 06:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiLLLR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 06:17:56 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E261C7E
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 03:17:41 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCBCvNI029803;
        Mon, 12 Dec 2022 11:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0llOsZEZl9+m/Kol1xvtDBjGCGTso1v8oAv9ZQv4OCE=;
 b=r3dktJob/I2/JWLNnEhvFXoYIs3sTS95ii3xFdSYFyqHEZrZ6wIe/Qe9LWLTLWmoLjdT
 L2qt4oOTzfO50Mz7LtWvm6Y9IQygI9vtroXiB0bUJ0d07k2Z4BiEfz13LMAZVk8LDQ34
 475mcYP/JLnnsOAvs8w+tO+hvVcHesNySKYtk108112vEFVXWJnH6V9tpzyX4iwLHgom
 D4RAu9BqxJ8EjufjnXS05pJJUkIOO5wwKS9K9ln0STTL991xRv+ZbOyrOmsIycvX6nCW
 gIHbUHAFrDHFr5EbZ1fvqrdKNUV6oqihr5xJqF2Ffos3iOmRV7Y+0b3oMR4NPwfcEq0G MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3sjpf1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:38 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCBG6oP010908;
        Mon, 12 Dec 2022 11:17:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3sjpf13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BBNRNDO007817;
        Mon, 12 Dec 2022 11:17:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mchcf2hsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCBHXtY46465340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 11:17:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A442004F;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6BA32004E;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/4] s390x: use migrate_once() in migration tests
Date:   Mon, 12 Dec 2022 12:17:30 +0100
Message-Id: <20221212111731.292942-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111731.292942-1-nrb@linux.ibm.com>
References: <20221212111731.292942-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nNRAS1tPu7iQM9-gjCXBW-dGEDHEfNBz
X-Proofpoint-ORIG-GUID: dDbviQl7XxjmMURXevgMvhNMv_XBMyqS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 phishscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

migrate_once() can simplify the control flow in migration-skey and
migration-cmm.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile         |  1 +
 s390x/migration-cmm.c  | 24 +++++++-----------------
 s390x/migration-sck.c  |  4 ++--
 s390x/migration-skey.c | 20 +++++++-------------
 s390x/migration.c      |  7 ++-----
 5 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index bf1504f9d58c..52a9d821974e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -85,6 +85,7 @@ cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/getchar.o
+cflatobjs += lib/migrate.o
 cflatobjs += lib/s390x/io.o
 cflatobjs += lib/s390x/stack.o
 cflatobjs += lib/s390x/sclp.o
diff --git a/s390x/migration-cmm.c b/s390x/migration-cmm.c
index aa7910ca76bf..43673f18e45a 100644
--- a/s390x/migration-cmm.c
+++ b/s390x/migration-cmm.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <migrate.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
 #include <asm/cmm.h>
@@ -39,8 +40,7 @@ static void test_migration(void)
 		essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i + 3]);
 	}
 
-	puts("Please migrate me, then press return\n");
-	(void)getchar();
+	migrate_once();
 
 	for (i = 0; i < NUM_PAGES; i++) {
 		actual_state = essa(ESSA_GET_STATE, (unsigned long)pagebuf[i]);
@@ -53,25 +53,15 @@ static void test_migration(void)
 
 int main(void)
 {
-	bool has_essa = check_essa_available();
-
 	report_prefix_push("migration-cmm");
-	if (!has_essa) {
-		report_skip("ESSA is not available");
 
-		/*
-		 * If we just exit and don't ask migrate_cmd to migrate us, it
-		 * will just hang forever. Hence, also ask for migration when we
-		 * skip this test alltogether.
-		 */
-		puts("Please migrate me, then press return\n");
-		(void)getchar();
+	if (!check_essa_available())
+		report_skip("ESSA is not available");
+	else
+		test_migration();
 
-		goto done;
-	}
+	migrate_once();
 
-	test_migration();
-done:
 	report_prefix_pop();
 	return report_summary();
 }
diff --git a/s390x/migration-sck.c b/s390x/migration-sck.c
index 2d9a195ab4c4..2a9c87071643 100644
--- a/s390x/migration-sck.c
+++ b/s390x/migration-sck.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <migrate.h>
 #include <asm/time.h>
 
 static void test_sck_migration(void)
@@ -30,8 +31,7 @@ static void test_sck_migration(void)
 	report(!cc, "clock running after set");
 	report(now_after_set >= time_to_set, "TOD clock value is larger than what has been set");
 
-	puts("Please migrate me, then press return\n");
-	(void)getchar();
+	migrate_once();
 
 	cc = stckf(&now_after_migration);
 	report(!cc, "clock still set");
diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
index b7bd82581abe..a91eb6b5a63e 100644
--- a/s390x/migration-skey.c
+++ b/s390x/migration-skey.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <migrate.h>
 #include <asm/facility.h>
 #include <asm/page.h>
 #include <asm/mem.h>
@@ -35,8 +36,7 @@ static void test_migration(void)
 		set_storage_key(pagebuf[i], key_to_set, 1);
 	}
 
-	puts("Please migrate me, then press return\n");
-	(void)getchar();
+	migrate_once();
 
 	for (i = 0; i < NUM_PAGES; i++) {
 		actual_key.val = get_storage_key(pagebuf[i]);
@@ -64,19 +64,13 @@ static void test_migration(void)
 int main(void)
 {
 	report_prefix_push("migration-skey");
-	if (test_facility(169)) {
-		report_skip("storage key removal facility is active");
 
-		/*
-		 * If we just exit and don't ask migrate_cmd to migrate us, it
-		 * will just hang forever. Hence, also ask for migration when we
-		 * skip this test altogether.
-		 */
-		puts("Please migrate me, then press return\n");
-		(void)getchar();
-	} else {
+	if (test_facility(169))
+		report_skip("storage key removal facility is active");
+	else
 		test_migration();
-	}
+
+	migrate_once();
 
 	report_prefix_pop();
 	return report_summary();
diff --git a/s390x/migration.c b/s390x/migration.c
index a45296374cd8..fe6ea8369edb 100644
--- a/s390x/migration.c
+++ b/s390x/migration.c
@@ -8,6 +8,7 @@
  *  Nico Boehr <nrb@linux.ibm.com>
  */
 #include <libcflat.h>
+#include <migrate.h>
 #include <asm/arch_def.h>
 #include <asm/vector.h>
 #include <asm/barrier.h>
@@ -178,11 +179,7 @@ int main(void)
 		mb();
 	flag_thread_complete = 0;
 
-	/* ask migrate_cmd to migrate (it listens for 'migrate') */
-	puts("Please migrate me, then press return\n");
-
-	/* wait for migration to finish, we will read a newline */
-	(void)getchar();
+	migrate_once();
 
 	flag_migration_complete = 1;
 
-- 
2.36.1

