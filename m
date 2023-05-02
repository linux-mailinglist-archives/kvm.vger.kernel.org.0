Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876046F44BF
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbjEBNKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbjEBNJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:09:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8A64C2B;
        Tue,  2 May 2023 06:09:51 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D8WCZ011697;
        Tue, 2 May 2023 13:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1OUmKs5VL52vbRfptALljcen1bdUL/RIBJZUc2nU2pM=;
 b=sqjSX0g7lF7uo92RITnJOR2xWgCz/mz7lYNACkd3zC6j5578nkYCuHVHt6VXbm1QqUO6
 aVLWc5gB4GBiEVGkAUOhRzsolpiOHnS8SQwnBmyiskhjZOUg3GRg2BZI8zQA+ssNcc7c
 5QTZp6UOlj5tub7lcoVnrLRr1/NFKE/g9kBcCS4TQkhpc3MzQc7SnllirxUsxLb+6Gzb
 U2+pmOxgWTHvf22h8/otQNr6svTF9tJ4R3iT4xck7NbVnzTwQ33t6biZTADX49qr+pQC
 7BiytoV5ZnFXRyBA0pVubmSsmUxiFH4J3B3pWgWgyNQqu3ANjemDdn9nV9s5p4rZJJx5 Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s38vh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:50 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D8mlH013144;
        Tue, 2 May 2023 13:09:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2s38uyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3424iEl6021182;
        Tue, 2 May 2023 13:09:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q8tgg1m22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9NoX31916518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E53B20040;
        Tue,  2 May 2023 13:09:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8491F2004B;
        Tue,  2 May 2023 13:09:22 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 5/9] s390x: uv-host: Fix create guest variable storage prefix check
Date:   Tue,  2 May 2023 13:07:28 +0000
Message-Id: <20230502130732.147210-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9gqARtqhZZ2pC3UM7a6o0AuA9oRzZv6l
X-Proofpoint-GUID: nX03fXNQC_kTccWBvIATnkodLLLjsYPP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want more than one cpu and the rc is 10B, not 109.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index ed13bc26..0048a19f 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -435,11 +435,15 @@ static void test_config_create(void)
 	       "base storage origin contains lowcore");
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
-	if (smp_query_num_cpus() == 1) {
+	/*
+	 * Let's not make it too easy and use a second cpu to set a
+	 * non-zero prefix.
+	 */
+	if (smp_query_num_cpus() > 1) {
 		sigp_retry(1, SIGP_SET_PREFIX,
 			   uvcb_cgc.conf_var_stor_origin + PAGE_SIZE, NULL);
 		rc = uv_call(0, (uint64_t)&uvcb_cgc);
-		report(uvcb_cgc.header.rc == 0x10e && rc == 1 &&
+		report(uvcb_cgc.header.rc == 0x10b && rc == 1 &&
 		       !uvcb_cgc.guest_handle, "variable storage area contains lowcore");
 		sigp_retry(1, SIGP_SET_PREFIX, 0x0, NULL);
 	}
-- 
2.34.1

