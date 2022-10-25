Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBAB60CB29
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiJYLoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiJYLn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAD017536E
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:56 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB7vDV006340
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Oh+orQqoWd9tY0JbhI7tgzChpyC/W1hknh15aIO3IME=;
 b=oYrCKfjRMHjVNaUC6FjKyKk7Gyfjuru9m0fw+OPeGY7U9YaxUorLTI9I5AWXXvJ8UyZt
 +hvzAgaWzjefnBl8WDcJBDINnRpApTaQspUBhbyfvQX5mJFpmSo0DeaNUS52oCPNqmhW
 rIJgVb6Yerq8G9FrIbaW+nIXmbvZkGbp01W8rt1B8b7gqL/0Sla5kbgPi5g4tWkZOxOc
 79Pcb4m4Kmr1nkCx5qlT3rc41JK7MPiRfyv5jPUk1AkjYmqT3KmcAnlCLu2JHDUP0bCC
 6S9IIhl9IH40XvSRxjk/Xo417JAlNbwdcUPqVVMu6Gc84CnX/nuWcmXBN3DakGythaFa 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvfbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PB8F64007833
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvfa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:55 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBc6nq013894;
        Tue, 25 Oct 2022 11:43:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3kc8594ddn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhnw21573448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64A6DAE045;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33719AE04D;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 14/22] s390x: uv-host: Fix init storage origin and length check
Date:   Tue, 25 Oct 2022 13:43:37 +0200
Message-Id: <20221025114345.28003-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1V-MkOt139rprsQk8v712DF2D9EWkSFM
X-Proofpoint-ORIG-GUID: HBWS-VFXiWG1KQqSQOSd5wOPLPNhWjqW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=992 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The origin and length are masked with the HPAGE_MASK and PAGE_MASK
respectively so adding a few bytes doesn't matter at all.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Message-Id: <20221017093925.2038-9-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-host.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a33389b9..191e8b3f 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -524,17 +524,22 @@ static void test_init(void)
 	       "storage invalid length");
 	uvcb_init.stor_len += 8;
 
-	uvcb_init.stor_origin =  get_max_ram_size() + 8;
+	/* Storage origin is 1MB aligned, the length is 4KB aligned */
+	uvcb_init.stor_origin = get_max_ram_size();
 	rc = uv_call(0, (uint64_t)&uvcb_init);
-	report(rc == 1 && uvcb_init.header.rc == 0x104,
+	report(rc == 1 && (uvcb_init.header.rc == 0x104 || uvcb_init.header.rc == 0x105),
 	       "storage origin invalid");
 	uvcb_init.stor_origin = mem;
 
-	uvcb_init.stor_origin = get_max_ram_size() - 8;
-	rc = uv_call(0, (uint64_t)&uvcb_init);
-	report(rc == 1 && uvcb_init.header.rc == 0x105,
-	       "storage + length invalid");
-	uvcb_init.stor_origin = mem;
+	if (uvcb_init.stor_len >= HPAGE_SIZE) {
+		uvcb_init.stor_origin = get_max_ram_size() - HPAGE_SIZE;
+		rc = uv_call(0, (uint64_t)&uvcb_init);
+		report(rc == 1 && uvcb_init.header.rc == 0x105,
+		       "storage + length invalid");
+		uvcb_init.stor_origin = mem;
+	} else {
+		report_skip("storage + length invalid, stor_len < HPAGE_SIZE");
+	}
 
 	uvcb_init.stor_origin = 1UL << 30;
 	rc = uv_call(0, (uint64_t)&uvcb_init);
-- 
2.37.3

