Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35331600B13
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiJQJkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiJQJkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999CF17E0E
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:40:03 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H9JemO035747
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SOBBVNPiP0GZPZcEKK6UnOQdRuXe/B0g5k50Z6QzGrw=;
 b=SmW0WN3uAhdTE954fqkYIh+HCc6UN9vRgrKESwzr5e3RXLh/ZbrdB1C3nBvMLf+LRfWn
 skT8MvRWG89x/3yaSQhtkDkFaQOP8eq6cV9uqj0iq9FLUK1gTk3D3Ib41IWJ7bqd2jjs
 hajOVFO4ra43pviZVQyN2L4Zfa/SURmewXUt/51nIrxiLB0rQ2o16egUKPaRW9bIdGry
 5Bz6KTuvnNnpF28xrATEKU1aWnQk2XNu0eBrmODlKMD3eF73VhYSmCovBj0zBspRbyDe
 8OGp3zcAHGBIF+dyvJNjdllj6jQScKdq9UmCWFEP7u39kOttHm6fi5fYsA+mbHT5+j8p 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86ugbemq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:02 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H9LN9F018885
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:02 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86ugbejg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:02 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9Z4jM009834;
        Mon, 17 Oct 2022 09:39:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg92qmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:39:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9dtXl57278772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:39:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0C4CA405B;
        Mon, 17 Oct 2022 09:39:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D77DA4054;
        Mon, 17 Oct 2022 09:39:55 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 4/8] s390x: uv-host: Add access exception test
Date:   Mon, 17 Oct 2022 09:39:21 +0000
Message-Id: <20221017093925.2038-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aR2wmZW8z4u0FFOHeVo7X2L0oa5ycXIm
X-Proofpoint-ORIG-GUID: MIMRThIrkrzuvO4FuLiXuUg9UK8DRcxg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=944 phishscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210170055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check that we get access exceptions if the UVCB is on an invalid
page or starts at a valid page and crosses into an invalid one.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index e401fa5d..305b490f 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -15,12 +15,14 @@
 #include <sclp.h>
 #include <smp.h>
 #include <uv.h>
+#include <mmu.h>
 #include <asm/page.h>
 #include <asm/sigp.h>
 #include <asm/pgtable.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/facility.h>
+#include <asm/pgtable.h>
 #include <asm/uv.h>
 #include <asm-generic/barrier.h>
 
@@ -150,6 +152,54 @@ static void test_uv_uninitialized(void)
 	report_prefix_pop();
 }
 
+static void test_access(void)
+{
+	struct uv_cb_header *uvcb;
+	void *pages =  alloc_pages(1);
+	uint16_t pgm;
+	int i;
+
+	/* Put UVCB on second page which we will protect later */
+	uvcb = pages + PAGE_SIZE;
+
+	report_prefix_push("access");
+
+	report_prefix_push("non-crossing");
+	protect_page(uvcb, PAGE_ENTRY_I);
+	for (i = 0; cmds[i].name; i++) {
+		expect_pgm_int();
+		mb();
+		uv_call_once(0, (uint64_t)uvcb);
+		pgm = clear_pgm_int();
+		report(pgm == PGM_INT_CODE_PAGE_TRANSLATION, "%s", cmds[i].name);
+	}
+	report_prefix_pop();
+
+	report_prefix_push("crossing");
+	/*
+	 * Put the header into the readable page 1, everything after
+	 * the header will be on the second, invalid page.
+	 */
+	uvcb -= 1;
+	for (i = 0; cmds[i].name; i++) {
+		uvcb->cmd = cmds[i].cmd;
+		uvcb->len = cmds[i].len;
+
+		expect_pgm_int();
+		mb();
+		uv_call_once(0, (uint64_t)uvcb);
+		pgm = clear_pgm_int();
+		report(pgm == PGM_INT_CODE_PAGE_TRANSLATION, "%s", cmds[i].name);
+	}
+	report_prefix_pop();
+
+	uvcb += 1;
+	unprotect_page(uvcb, PAGE_ENTRY_I);
+
+	free_pages(pages);
+	report_prefix_pop();
+}
+
 static void test_config_destroy(void)
 {
 	int rc;
@@ -615,6 +665,8 @@ int main(void)
 	test_init();
 
 	setup_vmem();
+	test_access();
+
 	test_config_create();
 	test_cpu_create();
 	test_cpu_destroy();
-- 
2.34.1

