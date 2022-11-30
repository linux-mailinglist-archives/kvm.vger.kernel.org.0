Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B2A63D7FF
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiK3OXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiK3OXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:23:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B8EF59B
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:22:59 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUEIlkA026089;
        Wed, 30 Nov 2022 14:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dEFN9QSljfhHLmR+suAn+4bXAUscDgZ1V80hCb7Y71I=;
 b=LKRjeh/s+QpTkrK9X7WIn2UL78JHNLSC7qACqw0/svReNGp9iry38ngdRKAxLB1P0i9l
 GLcrytaePEqvmMuvaL8RWGQZabMhqpPN3lyp3K+cSr5/u7ijfTkzdatgosrIx26hvx70
 N8P1TLP7T8tAYcgDA4BOS/HacBWd1vmLNihXcjOuHNCxQt3MaeyDY0wYt9xM7tE03QXy
 /kkDEmnDFG/v9I5tj+VWPFllmt75EnS5vcccgY1uZDExNAFQyxYrA85aeEPwr3Wpqv6B
 KPTYo6QKRNqOI66YAok1r/CYelzmNRFXMG63dAFDphspVymfNk+9+fdg28OYxR921ydD YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m68ms0djw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUE5WCL005165;
        Wed, 30 Nov 2022 14:22:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m68ms0dj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUEKESS011860;
        Wed, 30 Nov 2022 14:22:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2hwxst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUEMpFK6422936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:22:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C71DAE051;
        Wed, 30 Nov 2022 14:22:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17DFFAE057;
        Wed, 30 Nov 2022 14:22:51 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 14:22:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v1 3/4] s390x: use migrate_once() in migration tests
Date:   Wed, 30 Nov 2022 15:22:48 +0100
Message-Id: <20221130142249.3558647-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221130142249.3558647-1-nrb@linux.ibm.com>
References: <20221130142249.3558647-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e4eNzX42ZBIgjm2FR9m6Pc9sBxXKddfE
X-Proofpoint-GUID: -qqsJQ1FIi5Av8ipoO5bh2t0SdAO4Vww
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211300099
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
 s390x/migration-cmm.c  | 27 +++++++++------------------
 s390x/migration-sck.c  |  4 ++--
 s390x/migration-skey.c | 23 +++++++++--------------
 s390x/migration.c      |  7 ++-----
 5 files changed, 23 insertions(+), 39 deletions(-)

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
index aa7910ca76bf..64adc6ed9e14 100644
--- a/s390x/migration-cmm.c
+++ b/s390x/migration-cmm.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <migrate.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
 #include <asm/cmm.h>
@@ -31,6 +32,11 @@ static void test_migration(void)
 		BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
 	};
 
+	if (!check_essa_available()) {
+		report_skip("ESSA is not available");
+		return;
+	}
+
 	assert(NUM_PAGES % 4 == 0);
 	for (i = 0; i < NUM_PAGES; i += 4) {
 		essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
@@ -39,8 +45,7 @@ static void test_migration(void)
 		essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i + 3]);
 	}
 
-	puts("Please migrate me, then press return\n");
-	(void)getchar();
+	migrate_once();
 
 	for (i = 0; i < NUM_PAGES; i++) {
 		actual_state = essa(ESSA_GET_STATE, (unsigned long)pagebuf[i]);
@@ -53,25 +58,11 @@ static void test_migration(void)
 
 int main(void)
 {
-	bool has_essa = check_essa_available();
-
 	report_prefix_push("migration-cmm");
-	if (!has_essa) {
-		report_skip("ESSA is not available");
-
-		/*
-		 * If we just exit and don't ask migrate_cmd to migrate us, it
-		 * will just hang forever. Hence, also ask for migration when we
-		 * skip this test alltogether.
-		 */
-		puts("Please migrate me, then press return\n");
-		(void)getchar();
-
-		goto done;
-	}
 
 	test_migration();
-done:
+	migrate_once();
+
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
index b7bd82581abe..a655d30e8312 100644
--- a/s390x/migration-skey.c
+++ b/s390x/migration-skey.c
@@ -9,6 +9,7 @@
  */
 
 #include <libcflat.h>
+#include <migrate.h>
 #include <asm/facility.h>
 #include <asm/page.h>
 #include <asm/mem.h>
@@ -23,6 +24,11 @@ static void test_migration(void)
 	union skey expected_key, actual_key;
 	int i, key_to_set, key_mismatches = 0;
 
+	if (test_facility(169)) {
+		report_skip("storage key removal facility is active");
+		return;
+	}
+
 	for (i = 0; i < NUM_PAGES; i++) {
 		/*
 		 * Storage keys are 7 bit, lowest bit is always returned as zero
@@ -35,8 +41,7 @@ static void test_migration(void)
 		set_storage_key(pagebuf[i], key_to_set, 1);
 	}
 
-	puts("Please migrate me, then press return\n");
-	(void)getchar();
+	migrate_once();
 
 	for (i = 0; i < NUM_PAGES; i++) {
 		actual_key.val = get_storage_key(pagebuf[i]);
@@ -64,19 +69,9 @@ static void test_migration(void)
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
-		test_migration();
-	}
+	test_migration();
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

