Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70136525F7D
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379205AbiEMJvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379190AbiEMJvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:51:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A095E5838F;
        Fri, 13 May 2022 02:51:50 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D8BcxP028356;
        Fri, 13 May 2022 09:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7zAyM2ZRtBrSHzKiQ797Zm03ztOww4v7EOWmF622auo=;
 b=ZuXjk9d+wZEnqJe059QmjHrKLCMgRFp7F5QhMTVLVwqwxpp+ZXkJugYYR1TWEG4+YaWv
 Nagvn/AERM65wv3Cs5cojgG1l/XT7e6x/kwncEu7TsnJIijXlix4Nt7fUi3xc0cf8knX
 cvZOimrX4j4C410y8yRv5SZCjh2xR/koISbAL8JyWrbfjPpab0SfMXEpqzMB3iw2/lry
 MkVwih8pr4cfgGYV25ecnGX2MwLnNrDduWswJBqHh6b1FCHUI5mJtzanJq7W65bsVq5n
 xpPqIzmH3Zz3rDQTPzZ69e3GQSVxdt2S4UzmhgMw28/vLQ9EPGVsRnAzW5N0kh4bmuVL lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1ket1xvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:50 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24D9XWQN002680;
        Fri, 13 May 2022 09:51:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1ket1xvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D9RY51029729;
        Fri, 13 May 2022 09:51:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd90c8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D9c3TB47317378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 09:38:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 017FB4C044;
        Fri, 13 May 2022 09:51:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D1754C046;
        Fri, 13 May 2022 09:51:43 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 09:51:43 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/6] s390x: uv-host: Add access exception test
Date:   Fri, 13 May 2022 09:50:15 +0000
Message-Id: <20220513095017.16301-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220513095017.16301-1-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XIwFjc1ELiumUgXgHj1Kvf5lBvXZtXQZ
X-Proofpoint-GUID: qtDL989YwIpFpskRAqLvfoRh0zFVvF6Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check that we get access exceptions if the UVCB is on an invalid
page or starts at a valid page and crosses into an invalid one.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index fcb82d24..153a94e1 100644
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
 
@@ -123,6 +125,54 @@ static void test_uv_uninitialized(void)
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

