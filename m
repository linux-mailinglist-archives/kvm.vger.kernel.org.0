Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF274CC793
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbiCCVF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbiCCVFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:05:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E9033E0B;
        Thu,  3 Mar 2022 13:04:35 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KVY72006253;
        Thu, 3 Mar 2022 21:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qphB4V6ghH5ihf8YcpjejWUEfx+dmaU3LhwyYmKOpwU=;
 b=ekoPhZb6fY8/+blXp095rI4UR+ss1wgyLPAZwSbPHJeNSoN/NJN/VdYegnkZXjCwlmj6
 rOmOKsp0VtgyBLxCOaPAviMTQ7L/lJyjoAkvM57CWZ/yTmWXikc/ePmVzdSryJp+gQJW
 t4dQ82lAKkJOc55vsPq5u4YRk5ep+DWUB5MASV0iImOrJjbnFWPl6bvkT4yi4vzdjNsM
 McbPHoWCw3gozfUywB/uqjdJNDGJwg9bRt7MSzEqqTZAy03S/CLw8Nvu+Y67mzS8HvbP
 ca6BvXiy77XU6RjFu5TUIzEWbmx3wuhMhVvMdblgCrB8pWbVQmRrgIL8Eqvskf13ZFbo Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4srrjha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:35 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223KVjG5011045;
        Thu, 3 Mar 2022 21:04:35 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4srrjgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:34 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223L3CNS008174;
        Thu, 3 Mar 2022 21:04:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3ek4k40234-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223L4Qam33030650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 21:04:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D443CAE056;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C347FAE051;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Mar 2022 21:04:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 85157E0411; Thu,  3 Mar 2022 22:04:26 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a non-waiting CPU stop
Date:   Thu,  3 Mar 2022 22:04:23 +0100
Message-Id: <20220303210425.1693486-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303210425.1693486-1-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N9z-U5wgNJrSCyrlx_SrvbYNnrPJS68I
X-Proofpoint-GUID: zr4SejfKZ2ExF0lxPB0Pv6wkBP7IqotB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203030095
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
---
 lib/s390x/smp.c | 25 +++++++++++++++++++++++++
 lib/s390x/smp.h |  1 +
 s390x/smp.c     | 10 ++--------
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 368d6add..84e536e8 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -119,6 +119,31 @@ int smp_cpu_stop(uint16_t idx)
 	return rc;
 }
 
+/*
+ * Functionally equivalent to smp_cpu_stop(), but without the
+ * elements that wait/serialize matters itself.
+ * Used to see if KVM itself is serialized correctly.
+ */
+int smp_cpu_stop_nowait(uint16_t idx)
+{
+	/* refuse to work on the boot CPU */
+	if (idx == 0)
+		return -1;
+
+	spin_lock(&lock);
+
+	/* Don't suppress a CC2 with sigp_retry() */
+	if (smp_sigp(idx, SIGP_STOP, 0, NULL)) {
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
index 50811bd0..11c2c673 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -76,14 +76,8 @@ static void test_restart(void)
 
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
+	smp_cpu_stop_nowait(1);
+	report(smp_cpu_stopped(1), "stop");
 }
 
 static void test_stop_store_status(void)
-- 
2.32.0

