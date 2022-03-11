Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C24D67BF
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350818AbiCKRjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350804AbiCKRjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:39:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA0A1AF8C9;
        Fri, 11 Mar 2022 09:38:33 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BEb6uq008677;
        Fri, 11 Mar 2022 17:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IKF+1+IEg9stVteehdAlJ00eQzKLSk0xwV6U0xe3fjU=;
 b=iscoYmTfajuZ1rm5Lg4Gl+RcN9HMMl9ZgDBfbOWN6sPcCDUz3RyQZrRVI05eKnX3h9bk
 Cw4LbQE6K89R0zsJf0M7zSAbAe6UMW/8ahRZSKTPBY63UYiTJQewvpNaOY8mOi6Pxmp1
 LEg0qT69ZLoJESJIarhSMiqWQfUeB83dt5CiG5g3QqEoHn0Z37YhS9BKQsaNrQGKI3uq
 zskNGeLeCX7eI6FF52ZSMcPWHVr86sVdvvPhK9cPYiK1kJKIwrIvPYHA2K19wYbxEzdV
 T//+5yR5KfZpqTH5JnpITcvq5d9bC9RLtfNBvyIRgQAx19F58k7Z6tRmKDWAv6SHub0I QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqmx69nbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BH7wXm029659;
        Fri, 11 Mar 2022 17:38:32 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqmx69nar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:32 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHXsmk017988;
        Fri, 11 Mar 2022 17:38:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3enpk30tc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHcQ8L54788552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:38:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2927411C050;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 171FA11C04C;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id CAC84E1358; Fri, 11 Mar 2022 18:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v2 4/6] s390x: smp: Create and use a non-waiting CPU stop
Date:   Fri, 11 Mar 2022 18:38:20 +0100
Message-Id: <20220311173822.1234617-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220311173822.1234617-1-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EseEyF77aohJLclX4f0_DtCQmLDMrD9D
X-Proofpoint-ORIG-GUID: f18SpSy9kJcrdw8OgRBFUcx7dckakyLF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 malwarescore=0 phishscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 lib/s390x/smp.c | 27 +++++++++++++++++++++++++++
 lib/s390x/smp.h |  1 +
 s390x/smp.c     | 17 +++++++++--------
 3 files changed, 37 insertions(+), 8 deletions(-)

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
2.32.0

