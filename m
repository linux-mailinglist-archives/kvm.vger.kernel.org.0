Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9516F44EE
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbjEBNWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEBNWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:22:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2645FC2;
        Tue,  2 May 2023 06:22:44 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342DJfSG013512;
        Tue, 2 May 2023 13:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GPj7esa3htFjLmzvuBdpb5S4onKRLFu5wCFEevGTd0A=;
 b=NPTUNrDSmIEqWtBjBAiu6fhdlny/nS20vsdwwU2h8apUn3v/NFMw0aLaPVvW+xcdOsvd
 E7L30eB8d63E7/5UXGa0HqTij9mzHzx3eGVC1mrO8O4fYd3PRbXMmFmwbznlpg4avphb
 m6l6okDWKyd1A1siY4cr9GI4ch0kphlkA/caZq1rmSRiksZRk7BfUrnYUzpy2kTZ66Zt
 YBBYF5Mrb2Ni9IHk/En73+/YVUuHBibXbrLRSJNGXX485hyyceMHXP9FAkNydjIK1Ql/
 zZFhfIoyRpUfSUQYr+4co41FhK6yF6/BdLnH4Si8dXvh1dIt1Lih60UYsyYcmHiEemAS zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2ge1wwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:22:42 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342DJoYC014335;
        Tue, 2 May 2023 13:22:03 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2ge1vvf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:22:03 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3427bGlO024730;
        Tue, 2 May 2023 13:09:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6hatn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:22 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9JHv58851762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 419862004D;
        Tue,  2 May 2023 13:09:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71F6D20040;
        Tue,  2 May 2023 13:09:18 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/9] s390x: uv-host: Fix UV init test memory allocation
Date:   Tue,  2 May 2023 13:07:24 +0000
Message-Id: <20230502130732.147210-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Gi210xGjbPHUgpGwgc7XPk_ziicMLjtP
X-Proofpoint-ORIG-GUID: CRSPEuYmyYS2c69laUW7YQmgflcnUSIN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

