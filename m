Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519C348E80F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240250AbiANKEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:04:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60158 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240239AbiANKEE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:04:04 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20E8qLPV002834;
        Fri, 14 Jan 2022 10:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zYo+n772IBm0JUFBiPFEN5wB+66n3z5NICJza+uUIvc=;
 b=f4KeS7HVoabyyHACqjQswO8BR8xYc2nmgfOEc+IJY7TrYJHBvAg7ceoMseVyEwWYOKzK
 qie6jyMhmmzTrODZbMqPvI+ytOT9KW5z6/xnT/QqINOKYc7FSGrievIPEsgrCR65DPL+
 YGW1BzxdGiKADKlAbqJwhiV5KnSLPMXqfiVpnojKmy8m+kSyZrNNfrpHwtGjD//N6xmp
 EGPhE4Fq76KLaAW/NlIAmAy8iXZnSRdZD7q3MA0LYR4iQW8UmnAELbDoHynxVbGCTrRo
 LQVRiBukMXXDT6CpRO06Qx29wamiXubUcS6aWfUCzmssRHnnMdQIqjMqr3O7NVtrRNwj pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk620h7hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:03 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EA0A99022891;
        Fri, 14 Jan 2022 10:04:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk620h7hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20E9urvM028818;
        Fri, 14 Jan 2022 10:04:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhjweb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 10:04:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EA3wX148628212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 10:03:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 756C911C058;
        Fri, 14 Jan 2022 10:03:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9340F11C050;
        Fri, 14 Jan 2022 10:03:57 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 10:03:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/5] s390x: diag308: Only test subcode 2 under QEMU
Date:   Fri, 14 Jan 2022 10:02:43 +0000
Message-Id: <20220114100245.8643-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220114100245.8643-1-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z_kHFWqDpOLswI4G9gcNGe3wxJ-oC5_5
X-Proofpoint-GUID: 2R-GF16uiKDi_nQBo4k_hyzsw3kumrXE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=927 impostorscore=0
 clxscore=1015 phishscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Other hypervisors might implement it and therefore not send a
specification exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/diag308.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/s390x/diag308.c b/s390x/diag308.c
index c9d6c499..414dbdf4 100644
--- a/s390x/diag308.c
+++ b/s390x/diag308.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
+#include <vm.h>
 
 /* The diagnose calls should be blocked in problem state */
 static void test_priv(void)
@@ -75,7 +76,7 @@ static void test_subcode6(void)
 /* Unsupported subcodes should generate a specification exception */
 static void test_unsupported_subcode(void)
 {
-	int subcodes[] = { 2, 0x101, 0xffff, 0x10001, -1 };
+	int subcodes[] = { 0x101, 0xffff, 0x10001, -1 };
 	int idx;
 
 	for (idx = 0; idx < ARRAY_SIZE(subcodes); idx++) {
@@ -85,6 +86,18 @@ static void test_unsupported_subcode(void)
 		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 		report_prefix_pop();
 	}
+
+	/*
+	 * Subcode 2 is not available under QEMU but might be on other
+	 * hypervisors.
+	 */
+	if (vm_is_tcg() || vm_is_kvm()) {
+		report_prefix_pushf("0x%04x", 2);
+		expect_pgm_int();
+		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+		report_prefix_pop();
+	}
 }
 
 static struct {
-- 
2.32.0

