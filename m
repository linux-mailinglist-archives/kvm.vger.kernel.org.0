Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5614EEC33
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbiDALSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345504AbiDALSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDAF184614
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:34 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231ABpVD003366
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yRY4+CHouMOU7fTDUqftfj0e7++cWzg5RHwO9Q0kL8g=;
 b=YnSgKXlMvNdplNrLULZS+GqDBK8M/2U9Q3aT3AkjuRm6WtXUi2rLyynQt29Eg70phdzV
 RoPEVWcOofFyijB02eqd1/0OOB1Y3fYvAW2I3hS+BmXwvaMv0WDGTG45p4pcTVSKcWWy
 piLtAuFos6tNd8YTDIj+GaASYL9ROju46ckHJRdbkSHCma6u+OW5brzmMmgqGGNOOrSR
 C1fGyNJgMnVwYJPUqbeas6oCQqfUsGtLy9oAB4BvvudR7b6TnrgwMG8G6FkTwIHTk8fK
 Q0Aq2QRsWjcWgYkNaXDZOkjpnOIPQROd5BceiophJlAMueSk97geq91WA+WalCIGrKKM dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5ye617as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:33 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BGXYw025876
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5ye617a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7kp9019698;
        Fri, 1 Apr 2022 11:16:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3qumu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGSxC21758292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3073F4C062;
        Fri,  1 Apr 2022 11:16:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE8724C06F;
        Fri,  1 Apr 2022 11:16:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:27 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 06/27] lib: s390x: smp: Remove smp_sigp_retry
Date:   Fri,  1 Apr 2022 13:15:59 +0200
Message-Id: <20220401111620.366435-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2hACPH3frWZAUPmshX7STc6umcoKgpED
X-Proofpoint-GUID: Lg05tM5PlscvopZLx3V_prvx0kX_zcKQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

The SIGP instruction presents a CC0 when an order is accepted,
though the work for the order may be performed asynchronously.
While any such work is outstanding, nearly any other SIGP order
sent to the same CPU will be returned with a CC2.

Currently, there are two library functions that perform a SIGP,
one which retries a SIGP that gets a CC2, and one which doesn't.
In practice, the users of this functionality want the CC2 to be
handled by the library itself, rather than determine whether it
needs to retry the request or not.

To avoid confusion, let's convert the smp_sigp() routine to
perform the sigp_retry() logic, and then convert any users of
smp_sigp_retry() to smp_sigp(). This of course means that the
external _retry() interface can be removed for simplicity.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/smp.h |  1 -
 lib/s390x/smp.c | 14 ++++----------
 s390x/smp.c     |  4 ++--
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index 24a0e2e0..df184cb8 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -52,6 +52,5 @@ int smp_cpu_setup(uint16_t idx, struct psw psw);
 void smp_teardown(void);
 void smp_setup(void);
 int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status);
-int smp_sigp_retry(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status);
 
 #endif
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 5be29d36..a0495cd9 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -40,12 +40,6 @@ int smp_query_num_cpus(void)
 }
 
 int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
-{
-	check_idx(idx);
-	return sigp(cpus[idx].addr, order, parm, status);
-}
-
-int smp_sigp_retry(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
 {
 	check_idx(idx);
 	return sigp_retry(cpus[idx].addr, order, parm, status);
@@ -78,7 +72,7 @@ bool smp_cpu_stopped(uint16_t idx)
 {
 	uint32_t status;
 
-	if (smp_sigp_retry(idx, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
+	if (smp_sigp(idx, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
 		return false;
 	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
 }
@@ -99,7 +93,7 @@ static int smp_cpu_stop_nolock(uint16_t idx, bool store)
 	if (idx == 0)
 		return -1;
 
-	if (smp_sigp_retry(idx, order, 0, NULL))
+	if (smp_sigp(idx, order, 0, NULL))
 		return -1;
 
 	while (!smp_cpu_stopped(idx))
@@ -251,11 +245,11 @@ static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
 	if (cpus[idx].active)
 		return -1;
 
-	smp_sigp_retry(idx, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	smp_sigp(idx, SIGP_INITIAL_CPU_RESET, 0, NULL);
 
 	lc = alloc_pages_flags(1, AREA_DMA31);
 	cpus[idx].lowcore = lc;
-	smp_sigp_retry(idx, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
+	smp_sigp(idx, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
 
 	/* Copy all exception psws. */
 	memcpy(lc, cpus[0].lowcore, 512);
diff --git a/s390x/smp.c b/s390x/smp.c
index 913da155..81e02195 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -266,7 +266,7 @@ static void test_reset_initial(void)
 	smp_cpu_start(1, psw);
 	wait_for_flag();
 
-	smp_sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
+	smp_sigp(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
 	smp_sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
 
 	report_prefix_push("clear");
@@ -316,7 +316,7 @@ static void test_reset(void)
 	smp_sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
 	smp_cpu_start(1, psw);
 
-	smp_sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
+	smp_sigp(1, SIGP_CPU_RESET, 0, NULL);
 	report(smp_cpu_stopped(1), "cpu stopped");
 
 	set_flag(0);
-- 
2.34.1

