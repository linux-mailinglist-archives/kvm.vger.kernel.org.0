Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0648B6C7DE4
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjCXMSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjCXMS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C238A55
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:15 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OBLLJH026438
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GPj7esa3htFjLmzvuBdpb5S4onKRLFu5wCFEevGTd0A=;
 b=EA1OGiQYT69bm8G48qYChY/1rOyuihmv8VFo3FTXiT6V9CErv8E20acLis93kYNKR5cj
 q9i5189lOdPVGAz8lS4MvIXcJ9JA8IgJHQa14vFf16qCLHNjd0Xxc+VP7fls6LrTF6ZA
 JGSotbPL/scjqYGfyBbul4KLQQ6KH1hCynjgjO7OAqrjgqMfGPudqHDv9rd0aU9LVP7D
 Xn68tHEQxq3+1T3JkC9ebYpm/P/cYD/b65c5zpC0faRncaPCV8pD56U/3ywZIYV/mqRu
 iWfyNIb8Hx6DLRd9N+y0yanN06FOJQKoSdTUY7U1PjepoQxoRU1bYr5A901kLHBhUnXf rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3phawuh9m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:14 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBQUE6009808
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:14 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3phawuh9kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NM7AND000464;
        Fri, 24 Mar 2023 12:18:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pgy9cgng3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:12 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCI8ri5046990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D456C2004E;
        Fri, 24 Mar 2023 12:18:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48A1320063;
        Fri, 24 Mar 2023 12:18:08 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/9] s390x: uv-host: Fix UV init test memory allocation
Date:   Fri, 24 Mar 2023 12:17:16 +0000
Message-Id: <20230324121724.1627-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wxxBw-Bx_4X4zbSxcoA_4e6mrCtaFK4J
X-Proofpoint-GUID: RG82qdfrVOG9ewd874Yo9KcZyy0vQE8E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

