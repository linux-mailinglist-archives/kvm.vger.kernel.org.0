Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F818739874
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 09:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjFVHwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 03:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjFVHwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 03:52:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC2A1992;
        Thu, 22 Jun 2023 00:52:07 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35M7gkxY004662;
        Thu, 22 Jun 2023 07:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jYGxl9Um/0soSMNZzHBRIG0Oy3ZMQxQLmNVwwDVvjD0=;
 b=AIJelJh6zBv3v0SeSgRBrx8cmSudQML1xpvkQHy71/6p2fF78cYT44qOy9P2jiWd6n3U
 7rGzyUvMc0UXvSRd4ffdTi9Gs5GyzcvsfWstNR8kOrur+ICkqQP40+SzSxQL+KjWQhqB
 cijkjwj6QqlipIoMsQ2P6Z9xxaPmgY3WAV0HgU8i8H+8joYOfR+78bG/MottPlOb5VRb
 bCdqErmFDQ3350QSzXt3mZA7t9q+reHtyxWp5e4rKZAl7tXGTnawIInv4P8P0QFOi5BV
 AEEGvJ3sghyMlREdgk3+laNpd+Dk2Ioa9kzEZpk9rybLHkCTo4XPKYt34nKI8za7J8UV fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rchut8k97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:06 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M7h4aE006417;
        Thu, 22 Jun 2023 07:52:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rchut8k8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35M11EsS002070;
        Thu, 22 Jun 2023 07:52:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r94f5baqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35M7q0Za41812588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 07:52:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB51C2004D;
        Thu, 22 Jun 2023 07:52:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E159520040;
        Thu, 22 Jun 2023 07:51:59 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jun 2023 07:51:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 1/8] s390x: uv-host: Fix UV init test memory allocation
Date:   Thu, 22 Jun 2023 07:50:47 +0000
Message-Id: <20230622075054.3190-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622075054.3190-1-frankja@linux.ibm.com>
References: <20230622075054.3190-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T1GiuDse219HoOX-PVTbmx-_UMOp-zy4
X-Proofpoint-ORIG-GUID: Q0hrelsfrYJ8He6NC945Cs2xRXDe5btG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_04,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The init memory has to be above 2G and 1M aligned but we're currently
aligning on 2G which means the allocations need a lot of unused
memory.

Also the second block of memory was never actually used for the double
init test since its address is never put into the uvcb.

Let's fix that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 33e6eec6..9dfaebd7 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -500,14 +500,17 @@ static void test_config_create(void)
 static void test_init(void)
 {
 	int rc;
-	uint64_t mem;
+	uint64_t tmp;
 
-	/* Donated storage needs to be over 2GB */
-	mem = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
+	/*
+	 * Donated storage needs to be over 2GB, AREA_NORMAL does that
+	 * on s390x.
+	 */
+	tmp = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
 
 	uvcb_init.header.len = sizeof(uvcb_init);
 	uvcb_init.header.cmd = UVC_CMD_INIT_UV;
-	uvcb_init.stor_origin = mem;
+	uvcb_init.stor_origin = tmp;
 	uvcb_init.stor_len = uvcb_qui.uv_base_stor_len;
 
 	report_prefix_push("init");
@@ -528,14 +531,14 @@ static void test_init(void)
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 1 && (uvcb_init.header.rc == 0x104 || uvcb_init.header.rc == 0x105),
 	       "storage origin invalid");
-	uvcb_init.stor_origin = mem;
+	uvcb_init.stor_origin = tmp;
 
 	if (uvcb_init.stor_len >= HPAGE_SIZE) {
 		uvcb_init.stor_origin = get_max_ram_size() - HPAGE_SIZE;
 		rc = uv_call(0, (uint64_t)&uvcb_init);
 		report(rc == 1 && uvcb_init.header.rc == 0x105,
 		       "storage + length invalid");
-		uvcb_init.stor_origin = mem;
+		uvcb_init.stor_origin = tmp;
 	} else {
 		report_skip("storage + length invalid, stor_len < HPAGE_SIZE");
 	}
@@ -544,7 +547,7 @@ static void test_init(void)
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 1 && uvcb_init.header.rc == 0x108,
 	       "storage below 2GB");
-	uvcb_init.stor_origin = mem;
+	uvcb_init.stor_origin = tmp;
 
 	smp_cpu_setup(1, PSW_WITH_CUR_MASK(cpu_loop));
 	rc = uv_call(0, (uint64_t)&uvcb_init);
@@ -555,10 +558,12 @@ static void test_init(void)
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 0 && uvcb_init.header.rc == UVC_RC_EXECUTED, "successful");
 
-	mem = (uint64_t)memalign(1UL << 31, uvcb_qui.uv_base_stor_len);
+	tmp = uvcb_init.stor_origin;
+	uvcb_init.stor_origin =	(uint64_t)memalign_pages_flags(HPAGE_SIZE, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 1 && uvcb_init.header.rc == 0x101, "double init");
-	free((void *)mem);
+	free((void *)uvcb_init.stor_origin);
+	uvcb_init.stor_origin = tmp;
 
 	report_prefix_pop();
 }
-- 
2.34.1

