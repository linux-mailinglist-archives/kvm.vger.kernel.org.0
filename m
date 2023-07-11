Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121C974F1A6
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjGKOT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjGKOTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:19:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E045F1BD1
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:18:49 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BECdn3016914;
        Tue, 11 Jul 2023 14:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Dsd59hDva96Ve5BaiGn+8bOUaBdGtxOqifFqjX1yotk=;
 b=QnZziDgHNOfJftxma7pJMj+Op8MgBtHXLt/noBwzEmzfkXzgYpvY4PMY0s7QtML2VnNn
 Wt2xySGZFomdfSdzoOeeZp0dfzu0MaiykDxAuN+0ub/msq/KuZYPQZZuxADLnAhJB3Mo
 3TfDqWeDcG9XqX6pAyjdCJzHmRhmlFu5clsvGtmB82ppePf06nU9CmLkiaRb1Gt6mCjN
 rFj83Dq+eyztdBysERyhrPMRK9VaT5WhTcr0/Rm9l6piU1t3/300ZJK7rSxrUB1TRmTq
 fLxS/mD2dgbQ7QobxURciKR7kqrXTShInTISPCGdnbuLJCgA2PmA77nNeU7HrePvViuS JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my8983-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:18:45 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BECnrh017818;
        Tue, 11 Jul 2023 14:18:43 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my894t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:18:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B3PA15002283;
        Tue, 11 Jul 2023 14:16:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye59tu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGGMP54919460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A152C20049;
        Tue, 11 Jul 2023 14:16:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2876820043;
        Tue, 11 Jul 2023 14:16:16 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:16 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 11/22] s390x: uv-host: Fix UV init test memory allocation
Date:   Tue, 11 Jul 2023 16:15:44 +0200
Message-ID: <20230711141607.40742-12-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: shoxfBpVFjLTpu-OPWp6DCZeq2X0m7DI
X-Proofpoint-ORIG-GUID: voXuMe9dgOkCYss_bkOnb4oYCqjOhDKu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The init memory has to be above 2G and 1M aligned but we're currently
aligning on 2G which means the allocations need a lot of unused
memory.

Also the second block of memory was never actually used for the double
init test since its address is never put into the uvcb.

Let's fix that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230622075054.3190-2-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 33e6eec..9dfaebd 100644
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
2.41.0

