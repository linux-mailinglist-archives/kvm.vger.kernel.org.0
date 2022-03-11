Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439EA4D67B4
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350801AbiCKRjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349966AbiCKRjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:39:39 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAF31AEED6;
        Fri, 11 Mar 2022 09:38:32 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BGsGfL036707;
        Fri, 11 Mar 2022 17:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RmvsHlrSbWmMzkAo4uoT0ON7Vo7tU5zQpftq26s97GI=;
 b=IvLhHs166oq9QtDngECNkn05NKZb9fSEkf6AhIqnrVBlvJtHtetizgvQ9gJKVKKGBTVe
 X0QzsEQAuzCy3UB26hmoziK32Ly6PtYO0PFLppnROMaMCjqkES7ht83fc7N7tEK9wxJV
 Dk+dO5TOBD14dUWtZa+5wCzw0oqrBaiuCHRsp4N5Easbrz/2NmI9TTpme42crzdQduUS
 Dqr6zFikhQZnphl79JbPWgfxFWikZYZWIdxrV7Izw3cc+YdbUl6cPqbho8+D9A2S69mb
 AxBlw8Ezs1Snmlzkjbigpnoy5Asi6dvLro2yI+VlciunvyAlo29w3+wQ6FMxad2pZfiK eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqg9ssk5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:31 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BFtOs4032208;
        Fri, 11 Mar 2022 17:38:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqg9ssk4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHY6lb027261;
        Fri, 11 Mar 2022 17:38:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3eqqf0a5h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHcQM434669026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:38:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F48EAE053;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D8CBAE051;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id CFAA6E13C1; Fri, 11 Mar 2022 18:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v2 6/6] lib: s390x: smp: Remove smp_sigp_retry
Date:   Fri, 11 Mar 2022 18:38:22 +0100
Message-Id: <20220311173822.1234617-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220311173822.1234617-1-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CXtSemz4c5W0LCTtez_OhpIUF9j9KE3G
X-Proofpoint-ORIG-GUID: 2-kW8utXVlUgeF2XE7dAMnkIcMdnbM5H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 lib/s390x/smp.c | 14 ++++----------
 lib/s390x/smp.h |  1 -
 s390x/smp.c     |  4 ++--
 3 files changed, 6 insertions(+), 13 deletions(-)

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
2.32.0

