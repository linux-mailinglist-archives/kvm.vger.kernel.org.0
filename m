Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB11752491A
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352026AbiELJgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352035AbiELJfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD1669CCD
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:38 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9QH22003855
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=x7UAgnubq7udDhgozSkpHFzno3S31UUOupMm1qxBOno=;
 b=md84tON4+od+aeysPKA0vldr4opc/nHpAj+No3QjUwzZGH1eZ5QvAk22wRjX6dNVQeLY
 7v5F2PfT27OR9GArQ1bjPWHv3ZFb+/oMi1dZ9Sa5jl0bviD/5Gvav7ROH1GoV/gT+SNP
 H+c5m4/7WPIfj/nHyVr6KFe+bulBnuT2s36VTAvcY3RO1Dr/0tjEwRTsFNuWKSjs+BBr
 Rj7nLwlkIbdYerd2o5Pwf4R723Mog0fU8b60gx1cxgtd6emVwiX8x7+afk7RZGGsWKdI
 0ojm7vl8ze+t/xqWrj/tBWQut/j1rh1i2SU+idlVyDCI3BhzAXSrzJM8J16KaC61iMbK mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:37 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9QEps003786
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XYDs023821;
        Thu, 12 May 2022 09:35:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8xrxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZVlJ49676784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1A3711C04A;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7969611C04C;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 08/28] s390x: diag308: Only test subcode 2 under QEMU
Date:   Thu, 12 May 2022 11:35:03 +0200
Message-Id: <20220512093523.36132-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yTRtEPXgAn6cruWau4ICNZIY2xARJ0HB
X-Proofpoint-GUID: r6R5dOILVnkolVz5gPmMecbz-31LFdxA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Other hypervisors might implement it and therefore not send a
specification exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/diag308.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/s390x/diag308.c b/s390x/diag308.c
index c9d6c499..ea41b455 100644
--- a/s390x/diag308.c
+++ b/s390x/diag308.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
+#include <hardware.h>
 
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
@@ -85,6 +86,21 @@ static void test_unsupported_subcode(void)
 		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 		report_prefix_pop();
 	}
+
+	/*
+	 * Subcode 2 is not available under QEMU but might be on other
+	 * hypervisors so we only check for the specification
+	 * exception on QEMU.
+	 */
+	report_prefix_pushf("0x%04x", 2);
+	if (host_is_qemu()) {
+		expect_pgm_int();
+		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	} else {
+		report_skip("subcode is supported");
+	}
+	report_prefix_pop();
 }
 
 static struct {
-- 
2.36.1

