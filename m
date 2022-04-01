Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBD64EEC24
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345426AbiDALS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345509AbiDALSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF9F18462B
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:35 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319j1Xt007294
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J08RTSthDlzbecxQQNYvs4aY7cSJUh2Aa5Q21E7FtwQ=;
 b=Htl4hfaUc4evcoA0Fra+ZOfMCV16n+QSGG1tJpeKL6hIOMpAXN10JqjIIRQeChEaeJor
 +0U9TRF1l9Ltapw3pUtsO7qgmKTTMdLiHyGqRapw2Zq8sGDFpTDsaHbcs/Z7k4YTZ1yk
 mm5NQ6vw/L7j1rxcbZIhP9uSd8indl5Dv4+echHKOA8oVoDWhKKxq+9LfOd8UUfN6G0d
 RJ80a5mTBnhWTwIWYYotkkXGr+I+2e5jc6Pg2gm7lYp+nc+ouVL+OVZJkTJsai5o9uDj
 8v1J+IwOVnAmhl1/SbD22lF8DVSjH1a9WCcHv0kUfISoW0zp4CYZM/CGUTCNqaTfmJbQ iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9tts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BEPQK005068
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:34 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9tt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B8dGC027953;
        Fri, 1 Apr 2022 11:16:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf94v69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGTe213631854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 132664C040;
        Fri,  1 Apr 2022 11:16:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B19514C05C;
        Fri,  1 Apr 2022 11:16:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 08/27] s390x: Add test for PFMF low-address protection
Date:   Fri,  1 Apr 2022 13:16:01 +0200
Message-Id: <20220401111620.366435-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TMNu4zmod0bQWSEwJur5-ACcJqnYE8zp
X-Proofpoint-GUID: OYfKhwjhtDNHVcz0xkzynnd45i_0G3C0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 mlxlogscore=652 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

PFMF should respect the low-address protection when clearing pages, hence
add some tests for it.

When low-address protection fails, clearing frame 0 is a destructive
operation. It messes up interrupts and thus printing test results won't
work properly. Hence, we first attempt to clear frame 1 which is not as
destructive.

Doing it this way around increases the chances for the user to see a
proper failure message instead of QEMU randomly quitting in the middle
of the test run.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/pfmf.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 2f3cb110..aa130529 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -113,6 +113,34 @@ static void test_1m_clear(void)
 	report_prefix_pop();
 }
 
+static void test_low_addr_prot(void)
+{
+	union pfmf_r1 r1 = {
+		.reg.cf = 1,
+		.reg.fsc = PFMF_FSC_4K
+	};
+
+	report_prefix_push("low-address protection");
+
+	report_prefix_push("0x1000");
+	expect_pgm_int();
+	low_prot_enable();
+	pfmf(r1.val, (void *)0x1000);
+	low_prot_disable();
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_pop();
+
+	report_prefix_push("0x0");
+	expect_pgm_int();
+	low_prot_enable();
+	pfmf(r1.val, 0);
+	low_prot_disable();
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	bool has_edat = test_facility(8);
@@ -124,6 +152,7 @@ int main(void)
 	}
 
 	test_priv();
+	test_low_addr_prot();
 	/* Force the buffer pages in */
 	memset(pagebuf, 0, PAGE_SIZE * 256);
 
-- 
2.34.1

