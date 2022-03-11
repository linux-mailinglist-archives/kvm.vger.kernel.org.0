Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAAC4D67BE
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350816AbiCKRjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350803AbiCKRjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:39:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2781AF8C7;
        Fri, 11 Mar 2022 09:38:33 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BFdQ1i008271;
        Fri, 11 Mar 2022 17:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8v+KujepHv3lkJwZaFpuYv7Ozo2SU03Bt3I8DkzZ7Vs=;
 b=l5gXcj4IUvmV+BL4YgZwrpGVhaZhkJ3NnRTH08uEMqRwNM9fpgnFw6v6jHd1uqt4t2QV
 AupjLEeRvcyjQVvEN441XrvFYIFisPT0V0AXOFT5f4fV2ap6iJrFDE0KhL5LSKJGY0lp
 dS9QFM3bUV4+jFkMrb4I/amevkeM7ndiRB3YTllEt+oZaAkNDbAFGb/2UZ1AMJNfBVwC
 T7ORCHBQBxwBbIPREQ+hlhCNh1YtT9taus7YWALQY/dCqhzix57jl2p58gXCrJFEf8ax
 119lMTT2R0/CbjT4EDMd01r/hpLkG+C52aJov1zzwQrHKJKQ/72CT8p1CwVspfGu6HFX bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eqrre474w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:32 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BH6Awx013081;
        Fri, 11 Mar 2022 17:38:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eqrre4741-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHYAkD019749;
        Fri, 11 Mar 2022 17:38:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3epyswc6p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHcQ3u47055142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:38:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AF4A42049;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 185CD42045;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C84B5E12AA; Fri, 11 Mar 2022 18:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v2 3/6] s390x: smp: Fix checks for SIGP STOP STORE STATUS
Date:   Fri, 11 Mar 2022 18:38:19 +0100
Message-Id: <20220311173822.1234617-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220311173822.1234617-1-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U7P60W1QasC2Rhmow2WzauMARMJdPQlM
X-Proofpoint-GUID: 562SxiEjLpselv4qJrlxtYqJsL6s6ps_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=875 adultscore=0 impostorscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110086
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

