Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A06D649D6B
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 12:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiLLLSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 06:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiLLLRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 06:17:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8DE256
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 03:17:42 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCBD3YB017097;
        Mon, 12 Dec 2022 11:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zpXxV8LyELDBq08sgH7VA9srihlW4RPOY+uAr4pNY48=;
 b=BN5kDyfpuBojrC5IJc8Glu61bjv9OdG0Ps9gSkc+Ag+m6WJsuNjPgfrI5QSyeXotIbyF
 +aQOoHF0wG3o3PgzdArLpeGyhh44Sw/Wk46kp40m04VXmqt9k6r+93OLzsCVu6fIQT7z
 C85oN8EJDE4Rb4+WF/PJD8O3xF/K+tcK/EEVey2C8010x3S3DreaU8r6znBtaHsQkzgD
 CPstBeatztmnfwSgksXFzehxnNHnUTyUQQpcMBjA73JZY8a7HH+8AR2IYp3VQu956Olz
 u8U8/ldlPqfJ8DYBVphqZW9H3ttfS4APgAQZjzKUaEdrGJX413Gpa6G0wMY8a62gEIdI iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3jhqq1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:39 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCBHdgh008683;
        Mon, 12 Dec 2022 11:17:39 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3jhqq0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:39 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCAi6Gw024547;
        Mon, 12 Dec 2022 11:17:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3mchr5sth9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 11:17:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCBHXeC43974930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 11:17:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CD472004E;
        Mon, 12 Dec 2022 11:17:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFC512005A;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 11:17:32 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v3 4/4] arm: use migrate_once() in migration tests
Date:   Mon, 12 Dec 2022 12:17:31 +0100
Message-Id: <20221212111731.292942-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111731.292942-1-nrb@linux.ibm.com>
References: <20221212111731.292942-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c8T6N8EHWH-NqFj6-Ar16roJnCj1_LAx
X-Proofpoint-GUID: U8kglyfOOtEHX6YalALV2zQRZvyncYXG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests already shipped with their own do_migrate() function, remove
it and instead use the new migrate_once() function. The control flow in
the gic tests can be simplified due to migrate_once().

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/Makefile.common |  1 +
 arm/debug.c         | 17 +++++-----------
 arm/gic.c           | 49 +++++++++++++--------------------------------
 3 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 38385e0c558e..1bbec64f2342 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -38,6 +38,7 @@ cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/migrate.o
 cflatobjs += lib/pci.o
 cflatobjs += lib/pci-host-generic.o
 cflatobjs += lib/pci-testdev.o
diff --git a/arm/debug.c b/arm/debug.c
index e9f805632db7..b3e9749c598f 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -1,4 +1,5 @@
 #include <libcflat.h>
+#include <migrate.h>
 #include <errata.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
@@ -257,13 +258,6 @@ static void reset_debug_state(void)
 	isb();
 }
 
-static void do_migrate(void)
-{
-	puts("Now migrate the VM, then press a key to continue...\n");
-	(void)getchar();
-	report_info("Migration complete");
-}
-
 static noinline void test_hw_bp(bool migrate)
 {
 	extern unsigned char hw_bp0;
@@ -291,7 +285,7 @@ static noinline void test_hw_bp(bool migrate)
 	isb();
 
 	if (migrate) {
-		do_migrate();
+		migrate_once();
 		report(num_bp == get_num_hw_bp(), "brps match after migrate");
 	}
 
@@ -335,7 +329,7 @@ static noinline void test_wp(bool migrate)
 	isb();
 
 	if (migrate) {
-		do_migrate();
+		migrate_once();
 		report(num_wp == get_num_wp(), "wrps match after migrate");
 	}
 
@@ -368,9 +362,8 @@ static noinline void test_ss(bool migrate)
 	write_sysreg(mdscr, mdscr_el1);
 	isb();
 
-	if (migrate) {
-		do_migrate();
-	}
+	if (migrate)
+		migrate_once();
 
 	asm volatile("msr daifclr, #8");
 
diff --git a/arm/gic.c b/arm/gic.c
index 60457e29e73a..c950b0d1597c 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -12,6 +12,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <migrate.h>
 #include <errata.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
@@ -779,23 +780,15 @@ static void test_its_trigger(void)
 static void test_its_migration(void)
 {
 	struct its_device *dev2, *dev7;
-	bool test_skipped = false;
 	cpumask_t mask;
 
-	if (its_setup1()) {
-		test_skipped = true;
-		goto do_migrate;
-	}
+	if (its_setup1())
+		return;
 
 	dev2 = its_get_device(2);
 	dev7 = its_get_device(7);
 
-do_migrate:
-	puts("Now migrate the VM, then press a key to continue...\n");
-	(void)getchar();
-	report_info("Migration complete");
-	if (test_skipped)
-		return;
+	migrate_once();
 
 	stats_reset();
 	cpumask_clear(&mask);
@@ -822,21 +815,17 @@ static void test_migrate_unmapped_collection(void)
 {
 	struct its_collection *col = NULL;
 	struct its_device *dev2 = NULL, *dev7 = NULL;
-	bool test_skipped = false;
 	cpumask_t mask;
 	int pe0 = 0;
 	u8 config;
 
-	if (its_setup1()) {
-		test_skipped = true;
-		goto do_migrate;
-	}
+	if (its_setup1())
+		return;
 
 	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
 		report_skip("Skipping test, as this test hangs without the fix. "
 			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
-		test_skipped = true;
-		goto do_migrate;
+		return;
 	}
 
 	col = its_create_collection(pe0, pe0);
@@ -847,12 +836,7 @@ static void test_migrate_unmapped_collection(void)
 	its_send_mapti(dev2, 8192, 0, col);
 	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
 
-do_migrate:
-	puts("Now migrate the VM, then press a key to continue...\n");
-	(void)getchar();
-	report_info("Migration complete");
-	if (test_skipped)
-		return;
+	migrate_once();
 
 	/* on the destination, map the collection */
 	its_send_mapc(col, true);
@@ -887,15 +871,12 @@ static void test_its_pending_migration(void)
 	struct its_collection *collection[2];
 	int *expected = calloc(nr_cpus, sizeof(int));
 	int pe0 = nr_cpus - 1, pe1 = nr_cpus - 2;
-	bool test_skipped = false;
 	u64 pendbaser;
 	void *ptr;
 	int i;
 
-	if (its_prerequisites(4)) {
-		test_skipped = true;
-		goto do_migrate;
-	}
+	if (its_prerequisites(4))
+		return;
 
 	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
 	its_send_mapd(dev, true);
@@ -942,12 +923,7 @@ static void test_its_pending_migration(void)
 	gicv3_lpi_rdist_enable(pe0);
 	gicv3_lpi_rdist_enable(pe1);
 
-do_migrate:
-	puts("Now migrate the VM, then press a key to continue...\n");
-	(void)getchar();
-	report_info("Migration complete");
-	if (test_skipped)
-		return;
+	migrate_once();
 
 	/* let's wait for the 256 LPIs to be handled */
 	mdelay(1000);
@@ -994,14 +970,17 @@ int main(int argc, char **argv)
 	} else if (!strcmp(argv[1], "its-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_migration();
+		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-pending-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_pending_migration();
+		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
 		report_prefix_push(argv[1]);
 		test_migrate_unmapped_collection();
+		migrate_once();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") == 0) {
 		report_prefix_push(argv[1]);
-- 
2.36.1

