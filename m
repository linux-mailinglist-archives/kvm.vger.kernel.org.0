Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899AF4A007D
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350723AbiA1SzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 13:55:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39774 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344153AbiA1Sy6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 13:54:58 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20SIF2Ng024039
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8LRcpaYWnh+vblcnE4s5y8pNDiJL0x77e8LLl/2dly0=;
 b=cfM7vHEq9vM34KmcjmTXspcKekaJa7Wre+I/JZFwfHYDzMm2B9Bud/SvWGx8tdE1JUNy
 NYpjhOSsQYWMZRkDLwOQyVoZbDa9RYMH19l55LJ+by6qctkF3rmvemoKOGbCywBumAVQ
 7CMhK37W6PzEI4Y2nE9PdfE9tUvJdigw/4y02ae4Lknu1wtrGGF2A1eYsoJjLUZ7tp99
 iJ5txV6N8pOB7/cioz5RE1KJMvZAGN/wxHfx7uzI8Zzo/MPrr9yZIF7PEyiKTCyLfkIH
 nUuxh/oN9dyxuVmhbxR+41tXrnQkk2zNGhWNajVlwnDGb9QrIZ7UXEeKyIRQ9SYnJOeq 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvn4n97p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20SIs9qu006330
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvn4n97nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20SIrIAK013543;
        Fri, 28 Jan 2022 18:54:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9ja9grf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20SIsqK743516214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 18:54:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49E51A4065;
        Fri, 28 Jan 2022 18:54:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDEC8A4066;
        Fri, 28 Jan 2022 18:54:51 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.7.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 18:54:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 4/5] s390x: firq: avoid hardcoded CPU addresses
Date:   Fri, 28 Jan 2022 19:54:48 +0100
Message-Id: <20220128185449.64936-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128185449.64936-1-imbrenda@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VAKIUKekm6vTA4rZQt_krNMiQxapek3h
X-Proofpoint-ORIG-GUID: 2euCgerECIsfDuwm2A9dB32kln_hRNTY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_06,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=959 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced smp_cpu_addr_from_idx to discover the
addresses of the CPUs to use in the test, instead of using hardcoded
values. This makes the test more portable.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/firq.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/s390x/firq.c b/s390x/firq.c
index fb9a2906..14d0d102 100644
--- a/s390x/firq.c
+++ b/s390x/firq.c
@@ -33,6 +33,7 @@ static void wait_for_sclp_int(void)
  */
 static void test_wait_state_delivery(void)
 {
+	uint16_t cpu1, cpu2;
 	struct psw psw;
 	SCCBHeader *h;
 	int ret;
@@ -44,16 +45,14 @@ static void test_wait_state_delivery(void)
 		goto out;
 	}
 
-	if (stap()) {
-		report_skip("need to start on CPU #0");
-		goto out;
-	}
+	cpu1 = smp_cpu_addr_from_idx(1);
+	cpu2 = smp_cpu_addr_from_idx(2);
 
 	/*
 	 * We want CPU #2 to be stopped. This should be the case at this
 	 * point, however, we want to sense if it even exists as well.
 	 */
-	ret = smp_cpu_stop(2);
+	ret = smp_cpu_stop(cpu2);
 	if (ret) {
 		report_skip("CPU #2 not found");
 		goto out;
@@ -68,10 +67,10 @@ static void test_wait_state_delivery(void)
 	/* Start CPU #1 and let it wait for the interrupt. */
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)wait_for_sclp_int;
-	ret = smp_cpu_setup(1, psw);
+	ret = smp_cpu_setup(cpu1, psw);
 	if (ret) {
 		sclp_clear_busy();
-		report_skip("cpu #1 not found");
+		report_skip("CPU #1 not found");
 		goto out;
 	}
 
@@ -85,7 +84,7 @@ static void test_wait_state_delivery(void)
 	 * will take some time as well and smp_cpu_setup() returns when we're
 	 * either already in wait_for_sclp_int() or just about to execute it.
 	 */
-	while(smp_sense_running_status(1));
+	while(smp_sense_running_status(cpu1));
 
 	h = alloc_pages_flags(0, AREA_DMA31);
 	h->length = 4096;
@@ -106,7 +105,7 @@ static void test_wait_state_delivery(void)
 
 out_destroy:
 	free_page(h);
-	smp_cpu_destroy(1);
+	smp_cpu_destroy(cpu1);
 out:
 	report_prefix_pop();
 }
-- 
2.34.1

