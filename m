Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CBF4EEC2D
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345397AbiDALSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345494AbiDALSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E1518179A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:34 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2318lOcL005268
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UK6vtJOY+vgwnxNapX6cnwFqud7CAyA0P11mjVkBMu0=;
 b=quKJOPVHFAZ5uT2JIw7JLvTKXan/s64XirmrPfmLuqSjoV7afh7a3DBsXANaAORV2jfH
 VSRvNMY1pm9xZ0NuZKVRRT4LXJ+VC/qoYgtb15x2P+brUaGYC7oOzfDDhVdjmzGldXOh
 R3nUzniUgLlCmel56Kp+o8Z55WvF/qh1M2nppaXbXRy15y7utMcAWdgs6tyGD1w1CJ8E
 XH+SLOsAJVb48sqz+QuMvD0jV2028SbWlm/xsYYJVqqnpAMtFw25Uo2xnfyLWmVAfHMI
 cNNRol+Lh8PqabZyLim2XHt5FaOXxECTSm8pOLYIY0cyCLtxnupxhuKfRlBG3lsxUVJf Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5x6gauns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:33 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BBENM009104
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5x6gaumx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:33 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B908T023393;
        Fri, 1 Apr 2022 11:16:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8tvrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGRhU24510834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0774C059;
        Fri,  1 Apr 2022 11:16:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74D264C066;
        Fri,  1 Apr 2022 11:16:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 03/27] s390x: smp: Fix checks for SIGP STOP STORE STATUS
Date:   Fri,  1 Apr 2022 13:15:56 +0200
Message-Id: <20220401111620.366435-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ce10IeXswsDw6Vl94kIolq27hnFwhXzj
X-Proofpoint-GUID: c96olr7vvSA8B0l3pQYeVM9wc9fKP7Kh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=743
 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

In the routine test_stop_store_status(), the "running" part of
the test checks a few of the fields in lowcore (to verify the
"STORE STATUS" part of the SIGP order), and then ensures that
the CPU has stopped. But this is backwards, according to the
Principles of Operation:
  The addressed CPU performs the stop function, fol-
  lowed by the store-status operation (see “Store Sta-
  tus” on page 4-82).

If the CPU were not yet stopped, the contents of the lowcore
fields would be unpredictable. It works today because the
library functions wait on the stop function, so the CPU is
stopped by the time it comes back. Let's first check that the
CPU is stopped first, just to be clear.

While here, add the same check to the second part of the test,
even though the CPU is explicitly stopped prior to the SIGP.

Fixes: fc67b07a4 ("s390x: smp: Test stop and store status on a running and stopped cpu")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.34.1

