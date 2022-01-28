Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38824A007E
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350725AbiA1SzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 13:55:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344428AbiA1Sy7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 13:54:59 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20SI94hl028721
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MmdyLm6rXn33C0pvWqpMEaXEfi3rxXcbXk7aY2y3fn8=;
 b=nA7P+g8rkJL91kL8yq1dXCoLXrGqe60ABU2ecEzLe+WfQqGPDbPBK5i56TPNKmIKJSYD
 X2E8fbiV2TdsWJcabU25zVvlj0l7C9GtrPD5qgJ7ZIvYEVkTy0WiYikmEiStb6X+/Y2J
 kj5cOx8/dr2crLopRYo3Yu+Y9vJlL3CVesSmCJFD5QQsCCiVUnJ1hS9U9LPfh+w5Wp+t
 RwhwsqhgrPPaYe94QZ2Cx1FQiTT6b7dc2VLG/O0fSxTOTixgsBFQI0S4jVenQuL4HsKT
 ndPi8Sku9Zldta3x6JtKzvQDcRbaCWIz9fVf8zMwe171RdkFV3wuG5yJiJnDuRJGESNn zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dvgqj77b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:58 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20SIhQBI020273
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dvgqj77ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20SIqOqn030490;
        Fri, 28 Jan 2022 18:54:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3dr9ja9hs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20SIsq7j40501660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 18:54:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5EADA405C;
        Fri, 28 Jan 2022 18:54:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D986A4068;
        Fri, 28 Jan 2022 18:54:52 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.7.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 18:54:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 5/5] s390x: skrf: avoid hardcoded CPU addresses
Date:   Fri, 28 Jan 2022 19:54:49 +0100
Message-Id: <20220128185449.64936-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128185449.64936-1-imbrenda@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ayn7oP-tLtMHovjw9nprOFbhrO6fTsJA
X-Proofpoint-ORIG-GUID: pAWIUB9dIeL04_pzen-4bF-i-TC70ZAH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_05,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015 adultscore=0
 suspectscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced smp_cpu_addr_from_idx to discover the
addresses of the CPUs to use in the test, instead of using hardcoded
values. This makes the test more portable.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/skrf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/s390x/skrf.c b/s390x/skrf.c
index ca4efbf1..bd0abba0 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -164,6 +164,7 @@ static void test_exception_ext_new(void)
 		.mask = extract_psw_mask(),
 		.addr = (unsigned long)ecall_setup
 	};
+	uint16_t cpu1;
 
 	report_prefix_push("exception external new");
 	if (smp_query_num_cpus() < 2) {
@@ -171,14 +172,15 @@ static void test_exception_ext_new(void)
 		report_prefix_pop();
 		return;
 	}
+	cpu1 = smp_cpu_addr_from_idx(1);
 
-	smp_cpu_setup(1, psw);
+	smp_cpu_setup(cpu1, psw);
 	wait_for_flag();
 	set_flag(0);
 
-	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
+	sigp(cpu1, SIGP_EXTERNAL_CALL, 0, NULL);
 	wait_for_flag();
-	smp_cpu_stop(1);
+	smp_cpu_stop(cpu1);
 	report_prefix_pop();
 }
 
-- 
2.34.1

