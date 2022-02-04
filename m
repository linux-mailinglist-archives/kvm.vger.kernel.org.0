Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB74A99B6
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 14:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349187AbiBDNJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 08:09:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244412AbiBDNJF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 08:09:05 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214Aq7XD005893
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AfCcHh2cM+nbQMxVPJYHjkRjkI4BxauQ9hhre2bDi8U=;
 b=Ib2YL0jOc6ms/tL1RQfGjqwD6OYwMPuTFtC2sj4JdXTvfZQ91MOVf9OLrNliBhlwa8pO
 1DlYYPCPWhKsZbeYtNmI64Sgua1acXyBpBG23Ty+4ebdF5U8dlRTFdBpJL2ei7mEHkk/
 j5EnEpT2FzhS2JbcKsjM+7pcy14vRV26d0xzRj/n16rlkplW5HOxtO/7LGGz1T3Tkio4
 qt1/lV+H6kF1NtxvS4NTIt43HOujASNng1HWSy0QOVV45AbLKj+TtCrfn/P2ehQdd400
 7s/Ap5LeOSh0u5FeFBiYrew2gxmpif3oGal5MoXHhCuL2WpdN6LcBIcYWUU2tZqKqQZh iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx453a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:09:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214CT5tu031486
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 13:09:04 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx4539r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:04 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214D7dKL009103;
        Fri, 4 Feb 2022 13:09:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3e0r11mree-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 13:09:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214D8x9743516308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 13:08:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DC0C4C063;
        Fri,  4 Feb 2022 13:08:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A79BB4C04A;
        Fri,  4 Feb 2022 13:08:58 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 13:08:58 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/6] s390x: firq: use CPU indexes instead of addresses
Date:   Fri,  4 Feb 2022 14:08:53 +0100
Message-Id: <20220204130855.39520-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204130855.39520-1-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KryYjSIoseq2ZI_kh-Vj04vW0WBYcB_9
X-Proofpoint-ORIG-GUID: Bnbw1SGvO46Fg0a6BvHHiJRdE5IepLjb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=831 malwarescore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adapt the test to the new semantics of the smp_* functions, and use CPU
indexes instead of addresses.

replace the checks with asserts, the 3 CPUs are guaranteed to be there.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/firq.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/s390x/firq.c b/s390x/firq.c
index fb9a2906..b4b3542e 100644
--- a/s390x/firq.c
+++ b/s390x/firq.c
@@ -44,24 +44,13 @@ static void test_wait_state_delivery(void)
 		goto out;
 	}
 
-	if (stap()) {
-		report_skip("need to start on CPU #0");
-		goto out;
-	}
-
-	/*
-	 * We want CPU #2 to be stopped. This should be the case at this
-	 * point, however, we want to sense if it even exists as well.
-	 */
+	/* Stop CPU #2. It must succeed because we have at least 3 CPUs */
 	ret = smp_cpu_stop(2);
-	if (ret) {
-		report_skip("CPU #2 not found");
-		goto out;
-	}
+	assert(!ret);
 
 	/*
-	 * We're going to perform an SCLP service call but expect
-	 * the interrupt on CPU #1 while it is in the wait state.
+	 * We're going to perform an SCLP service call but expect the
+	 * interrupt on CPU #1 while it is in the wait state.
 	 */
 	sclp_mark_busy();
 
@@ -69,11 +58,8 @@ static void test_wait_state_delivery(void)
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)wait_for_sclp_int;
 	ret = smp_cpu_setup(1, psw);
-	if (ret) {
-		sclp_clear_busy();
-		report_skip("cpu #1 not found");
-		goto out;
-	}
+	/* This must not fail because we have at least 3 CPUs */
+	assert(!ret);
 
 	/*
 	 * We'd have to jump trough some hoops to sense e.g., via SIGP
-- 
2.34.1

