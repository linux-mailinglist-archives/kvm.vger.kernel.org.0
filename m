Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0404CC792
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbiCCVFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbiCCVFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:05:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D40533E0B;
        Thu,  3 Mar 2022 13:04:33 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KVbQs002043;
        Thu, 3 Mar 2022 21:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Lc48QTlYLHqbrHJF44l5RCli08mGGu069fZ+31k/Ibo=;
 b=NUeYY/HXhUFRGhDbv6uBABzQPth15PmKlCOoKnovbyMglROPxeO3DcAePCTw7G1LYHoM
 mxykrRZqMOP034cTuPg82NZkgk3YSesTdRLH93NPngibaK3khWUgY12t2eGwW1TEEn2Y
 2u/ZSMXyrwbc25XvjyJ02gTqIt7jEKO0QHAv+A11yX0L4AanlM+vB46c2iWp2iH0A/en
 Wb2BgVYgr3sjHvhNoIb/EJc9xuDRbweGj1hMAVz6JF/LXKtIdkx1otV4vaABhj5K2UE3
 B24g0DK8Bp5TwFqI08jDSAZAtegmcQfMAZAqP9RlRIkjlzs7wtltL8XnQTMSeFOqAaf1 SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4ss8h5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223KcSUf003677;
        Thu, 3 Mar 2022 21:04:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4ss8h53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223L2wJA011800;
        Thu, 3 Mar 2022 21:04:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3ek4k4g235-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223L4Qsh56426780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 21:04:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEFCA5204F;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id BCBAC52051;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 82A38E03FA; Thu,  3 Mar 2022 22:04:26 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v1 3/6] s390x: smp: Fix checks for SIGP STOP STORE STATUS
Date:   Thu,  3 Mar 2022 22:04:22 +0100
Message-Id: <20220303210425.1693486-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303210425.1693486-1-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CMWIsP4mvnqSK9tU4tSpEc-kkXLKS139
X-Proofpoint-GUID: RGeEnErDVsyHAwP8dGIb-_PLvM9Ahepv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=785 phishscore=0
 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203030095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the routine test_stop_store_status(), the "running" part of
the test checks a few of the fields in lowcore (to verify the
"STORE STATUS" part of the SIGP order), and then ensures that
the CPU has stopped. But this is backwards, and leads to false
errors.

According to the Principles of Operation:
  The addressed CPU performs the stop function, fol-
  lowed by the store-status operation (see “Store Sta-
  tus” on page 4-82).

By checking the results how they are today, the contents of
the lowcore fields are unreliable until the CPU is stopped.
Thus, check that the CPU is stopped first, before ensuring
that the STORE STATUS was performed correctly.

While here, add the same check to the second part of the test,
even though the CPU is explicitly stopped prior to the SIGP.

Fixes: fc67b07a4 ("s390x: smp: Test stop and store status on a running and stopped cpu")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 s390x/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 2f4af820..50811bd0 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -98,9 +98,9 @@ static void test_stop_store_status(void)
 	lc->grs_sa[15] = 0;
 	smp_cpu_stop_store_status(1);
 	mb();
+	report(smp_cpu_stopped(1), "cpu stopped");
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
-	report(smp_cpu_stopped(1), "cpu stopped");
 	report_prefix_pop();
 
 	report_prefix_push("stopped");
@@ -108,6 +108,7 @@ static void test_stop_store_status(void)
 	lc->grs_sa[15] = 0;
 	smp_cpu_stop_store_status(1);
 	mb();
+	report(smp_cpu_stopped(1), "cpu stopped");
 	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
 	report(lc->grs_sa[15], "stack");
 	report_prefix_pop();
-- 
2.32.0

