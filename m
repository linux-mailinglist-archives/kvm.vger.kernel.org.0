Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E844EEC34
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345439AbiDALSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345510AbiDALSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E63184629
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:35 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2318lMna005235
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=WW8UMT7vAAqzcROcLwVNLM7p08Bt1a52Mqw6rsI5Tv4=;
 b=piw7TNZ7PVKxBDAdEgOFjtm+BYcLEVT3md2ZOak1Mw6W50Vi6FAkgLvRlvJbJ8IMdsl+
 XLWx/H7hnh9jAh8I+CBolY6a+ClFEWRcyWjdyPHg1fgvmKEiAudHBfbmDorwGed22aka
 jVZqGk033P2DCqcwut39BZKvdiyMUyGNTp1MaYLk4J2Y9x3mvZ5thBic95OD/YMRxM0S
 XtHfACJfQW1PlvycQguo/B3v4QN27R55VUlSXUJ7UuenWKwT6HNqyYBdXxNbXz68FNQm
 GCKMFI1rTkI3GuKKGLoILoSkbYJ/86qZloKo4uPTmY02VQ4f331oaiD/+0WiIIHlIGhW Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5x6gaup7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:34 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231At4lI031519
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:34 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5x6gaung-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:34 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B8uZn020867;
        Fri, 1 Apr 2022 11:16:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3j2xv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGSDJ41877768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C3AC4C064;
        Fri,  1 Apr 2022 11:16:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 445324C059;
        Fri,  1 Apr 2022 11:16:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 07/27] s390x: Add more tests for MSCH
Date:   Fri,  1 Apr 2022 13:16:00 +0200
Message-Id: <20220401111620.366435-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OjKVFjyPr7faUus4s2wzTVS7b0zEbvzT
X-Proofpoint-GUID: xQSZFxR9QH97OlR8TZawjBnorS2aLC7j
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

We already have some coverage for MSCH, but there are more cases to test
for:

- invalid SCHIB structure. We cover that by setting reserved bits 0, 1,
  6 and 7 in the flags of the PMCW.
  Older QEMU versions require this bit to always be zero on msch,
  which is why this test may fail. A fix is available in QEMU master
  commit 2df59b73e086 ("s390x/css: fix PMCW invalid mask").
- a pointer to an unaligned SCHIB. We cover misalignment by 1
  and 2 bytes. Using pointer to valid memory avoids messing up
  random memory in case of test failures.

Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/css.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 881206ba..396007ed 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -27,6 +27,8 @@ static int test_device_sid;
 static struct senseid *senseid;
 struct ccw1 *ccw;
 
+char alignment_test_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
 static void test_enumerate(void)
 {
 	test_device_sid = css_enumerate();
@@ -331,6 +333,61 @@ static void test_schm_fmt1(void)
 	free_io_mem(mb1, sizeof(struct measurement_block_format1));
 }
 
+static void test_msch(void)
+{
+	int invalid_pmcw_flags[] = {0, 1, 6, 7};
+	struct schib test_schib;
+	uint16_t old_pmcw_flags;
+	const int align_to = 4;
+	int invalid_flag;
+	int cc;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	cc = stsch(test_device_sid, &schib);
+	if (cc) {
+		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
+		return;
+	}
+
+	report_prefix_push("Unaligned");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+
+		expect_pgm_int();
+		msch(test_device_sid, (struct schib *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid SCHIB");
+	old_pmcw_flags = schib.pmcw.flags;
+	for (int i = 0; i < ARRAY_SIZE(invalid_pmcw_flags); i++) {
+		invalid_flag = invalid_pmcw_flags[i];
+
+		report_prefix_pushf("PMCW flag bit %d set", invalid_flag);
+
+		schib.pmcw.flags = old_pmcw_flags | BIT(15 - invalid_flag);
+		expect_pgm_int();
+		msch(test_device_sid, &schib);
+		check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+		cc = stsch(test_device_sid, &test_schib);
+		report(!cc, "STSCH succeeded");
+		report(!(test_schib.pmcw.flags & BIT(15 - invalid_flag)), "Clear on STSCH");
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	schib.pmcw.flags = old_pmcw_flags;
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -343,6 +400,7 @@ static struct {
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
 	{ "measurement block format1", test_schm_fmt1 },
+	{ "msch", test_msch },
 	{ NULL, NULL }
 };
 
-- 
2.34.1

