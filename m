Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2513460CB22
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiJYLoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiJYLn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08739175379
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:55 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB7tQP030425
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I00cO2SD4zQxeQ0lN5Qm+MFrfW7sMi+fD3Q42xpkD/M=;
 b=cwCd+mXF1oqmQrZKidX2RkFuVQW5volRN8cdvDo7IbnseNLKFCJO7HPdwYNotnx2yOTE
 UeKw/7Cd56O2o7rW60A1dsX2P8cjR5sfehh4MJfOgpMuIEPChegqRtgjDyR99aMDy5ez
 ilLXxjgSqMokhsPT4gNCs0i8UKEs5Yo2DN7p1w0RxFGWaE3thIH/aXG8mxJ853uoac8q
 O71JtZ3+YKjxj8yvuP+LVJGiIeUUo8E+3xBRL344ccs+M/If28gbtxJ1EAnz+nH79bgO
 l53XlYVLaFXTQWRoGL3zrOrW0YxYw+zTabBA7wJAA8O7+0VFbwNkaiSLtIyHxryu82KN FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kedu32u2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBNXIH006970
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kedu32u1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:53 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBdGlr011453;
        Tue, 25 Oct 2022 11:43:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3kc8593yv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBcZ8e41484576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:38:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52170AE045;
        Tue, 25 Oct 2022 11:43:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18D65AE053;
        Tue, 25 Oct 2022 11:43:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:48 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 10/22] s390x: uv-host: Add access exception test
Date:   Tue, 25 Oct 2022 13:43:33 +0200
Message-Id: <20221025114345.28003-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3HTACBoYvSuNRCj3j9-ViZlMDKm4abVg
X-Proofpoint-ORIG-GUID: FY70dGD7g_KRGO9TLNRpsQ0kXej9FCa3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=931 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's check that we get access exceptions if the UVCB is on an invalid
page or starts at a valid page and crosses into an invalid one.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Message-Id: <20221017093925.2038-5-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.37.3

