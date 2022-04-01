Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B374EEC23
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345419AbiDALS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345501AbiDALSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207D31834DF
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:34 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319CfX1016888
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uEsUI9hLlb7FWv7px1Ld0V8EmdRqzllBHKBonC6u39c=;
 b=Rb6iUkBSbAbjCHCR8OIHystV1ajxhhMc7Px7QSkB6Qdg1AN7afppZ9o/4pQieYb+Ueck
 43M7pSs6DjDhpcz7xnxA+DXWddgOVaWco4idOFGiPHVhOMS/ACxcsV1g5I1GW6YHklCL
 2nhEc31Ig5x/wuOZToleeyLFidi6ZAAEa6T1wIHF/1nihz4e4T5yzcxplpvQl/iacjuE
 SpLq9TIRoLnp0emnW6hUUwpxmT+y1TvYOwXt/jFsqmnByCIJId0qqWuHBHKi8jW+Vxyh
 s0bHCHGz5I7ugPsyT65q6CxtgtFr3oLbD3LwQjP3dbVy3r4YnSiAsNheKVeKVJ21Opo/ qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f57tpq1jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:33 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231Avak6011092
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:32 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f57tpq1ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7P0H015859;
        Fri, 1 Apr 2022 11:16:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3f1tf92w96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGRcg51118338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 404914C06A;
        Fri,  1 Apr 2022 11:16:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E208B4C064;
        Fri,  1 Apr 2022 11:16:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 04/27] s390x: smp: Create and use a non-waiting CPU stop
Date:   Fri,  1 Apr 2022 13:15:57 +0200
Message-Id: <20220401111620.366435-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bgMsSCJ_3goULiD0lxAPk_xWkoEf40yI
X-Proofpoint-ORIG-GUID: Yfr6Bbf8SXqvJShGJkA8zBsBTTTglkyH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

When stopping a CPU, kvm-unit-tests serializes/waits for everything
to finish, in order to get a consistent result whenever those
functions are used.

But to test the SIGP STOP itself, these additional measures could
mask other problems. For example, did the STOP work, or is the CPU
still operating?

Let's create a non-waiting SIGP STOP and use it here, to ensure that
the CPU is correctly stopped. A smp_cpu_stopped() call will still
be used to see that the SIGP STOP has been processed, and the state
of the CPU can be used to determine whether the test passes/fails.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/smp.h |  1 +
 lib/s390x/smp.c | 27 +++++++++++++++++++++++++++
 s390x/smp.c     | 17 +++++++++--------
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index 1e69a7de..bae03dfd 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -44,6 +44,7 @@ bool smp_sense_running_status(uint16_t idx);
 int smp_cpu_restart(uint16_t idx);
 int smp_cpu_start(uint16_t idx, struct psw psw);
 int smp_cpu_stop(uint16_t idx);
+int smp_cpu_stop_nowait(uint16_t idx);
 int smp_cpu_stop_store_status(uint16_t idx);
 int smp_cpu_destroy(uint16_t idx);
 int smp_cpu_setup(uint16_t idx, struct psw psw);
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 368d6add..b69c0e09 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -119,6 +119,33 @@ int smp_cpu_stop(uint16_t idx)
 	return rc;
 }
 
+/*
+ * Functionally equivalent to smp_cpu_stop(), but without the
+ * elements that wait/serialize matters itself.
+ * Used to see if KVM itself is serialized correctly.
+ */
+int smp_cpu_stop_nowait(uint16_t idx)
+{
+	check_idx(idx);
+
+	/* refuse to work on the boot CPU */
+	if (idx == 0)
+		return -1;
+
+	spin_lock(&lock);
+
+	/* Don't suppress a CC2 with sigp_retry() */
+	if (sigp(cpus[idx].addr, SIGP_STOP, 0, NULL)) {
+		spin_unlock(&lock);
+		return -1;
+	}
+
+	cpus[idx].active = false;
+	spin_unlock(&lock);
+
+	return 0;
+}
+
 int smp_cpu_stop_store_status(uint16_t idx)
 {
 	int rc;
diff --git a/s390x/smp.c b/s390x/smp.c
index 50811bd0..f70a9c54 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -76,14 +76,15 @@ static void test_restart(void)
 
 static void test_stop(void)
 {
-	smp_cpu_stop(1);
-	/*
-	 * The smp library waits for the CPU to shut down, but let's
-	 * also do it here, so we don't rely on the library
-	 * implementation
-	 */
-	while (!smp_cpu_stopped(1)) {}
-	report_pass("stop");
+	int rc;
+
+	report_prefix_push("stop");
+
+	rc = smp_cpu_stop_nowait(1);
+	report(!rc, "return code");
+	report(smp_cpu_stopped(1), "cpu stopped");
+
+	report_prefix_pop();
 }
 
 static void test_stop_store_status(void)
-- 
2.34.1

