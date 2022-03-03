Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C68E4CC795
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbiCCVF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbiCCVFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:05:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4E21E3C9;
        Thu,  3 Mar 2022 13:04:36 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KVeZI007486;
        Thu, 3 Mar 2022 21:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8Qnp+7u/RoRqnZq6DkTcz52CR0pJ0rkXttTIoufRqBw=;
 b=QHtLbtC+J27oLDc0Uf6VsFa++81nuHa9T+QneNeP5AN7kBjiJ8Lbsh4+kjapK+wBxlz5
 cGceklWD84rzN/V43dyqTRnHQUJJLYxIGvyeJijva2oI2qF6t2Is7YNp0UTFv8OLEVfh
 GvWoSFa16TDfWmQ7J3jyQ9yUDlKfvaq2HyQP6Hus4DFyKEC2EhOXPeQfMrx5ppSjJLZk
 AUCVX9O2jf/Lo5gU3/jZQRgaWerFmBfkPd/D7OOaLY0csy4XJZInHgvZkV3eadsHCfAW
 weTg6+DxKRWgIDg++08yLxHQbJl9hF4rJwEmqMM9JJplciXzHxCaEHpRoYsjr7/ukboA Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4ssrhvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:36 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223Kh30X023192;
        Thu, 3 Mar 2022 21:04:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ek4ssrhv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223L3OE2011629;
        Thu, 3 Mar 2022 21:04:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ek4ka8248-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 21:04:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223L4RZF42598812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 21:04:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 258AB11C064;
        Thu,  3 Mar 2022 21:04:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1418311C054;
        Thu,  3 Mar 2022 21:04:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  3 Mar 2022 21:04:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 87785E041D; Thu,  3 Mar 2022 22:04:26 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v1 5/6] s390x: smp: Create and use a non-waiting CPU restart
Date:   Thu,  3 Mar 2022 22:04:24 +0100
Message-Id: <20220303210425.1693486-6-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303210425.1693486-1-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: giwdTDTW5Pz5lGtP_RhZU28Vb-NATvni
X-Proofpoint-GUID: LPowO8qmZTxO18F2a8lB8DoJbZRvIoG_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0
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

The kvm-unit-tests infrastructure for a CPU restart waits for the
SIGP RESTART to complete. In order to test the restart itself,
create a variation that does not wait, and test the state of the
CPU directly.

While here, add some better report prefixes/messages, to clarify
which condition is being examined (similar to test_stop_store_status()).

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 lib/s390x/smp.c | 22 ++++++++++++++++++++++
 lib/s390x/smp.h |  1 +
 s390x/smp.c     | 18 +++++++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 84e536e8..85b046a5 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -192,6 +192,28 @@ int smp_cpu_restart(uint16_t idx)
 	return rc;
 }
 
+/*
+ * Functionally equivalent to smp_cpu_restart(), but without the
+ * elements that wait/serialize matters here in the test.
+ * Used to see if KVM itself is serialized correctly.
+ */
+int smp_cpu_restart_nowait(uint16_t idx)
+{
+	spin_lock(&lock);
+
+	/* Don't suppress a CC2 with sigp_retry() */
+	if (smp_sigp(idx, SIGP_RESTART, 0, NULL)) {
+		spin_unlock(&lock);
+		return -1;
+	}
+
+	cpus[idx].active = true;
+
+	spin_unlock(&lock);
+
+	return 0;
+}
+
 int smp_cpu_start(uint16_t idx, struct psw psw)
 {
 	int rc;
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index bae03dfd..24a0e2e0 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -42,6 +42,7 @@ uint16_t smp_cpu_addr(uint16_t idx);
 bool smp_cpu_stopped(uint16_t idx);
 bool smp_sense_running_status(uint16_t idx);
 int smp_cpu_restart(uint16_t idx);
+int smp_cpu_restart_nowait(uint16_t idx);
 int smp_cpu_start(uint16_t idx, struct psw psw);
 int smp_cpu_stop(uint16_t idx);
 int smp_cpu_stop_nowait(uint16_t idx);
diff --git a/s390x/smp.c b/s390x/smp.c
index 11c2c673..03160b80 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -55,23 +55,35 @@ static void test_restart(void)
 	struct cpu *cpu = smp_cpu_from_idx(1);
 	struct lowcore *lc = cpu->lowcore;
 
+	report_prefix_push("restart");
+	report_prefix_push("stopped");
+
 	lc->restart_new_psw.mask = extract_psw_mask();
 	lc->restart_new_psw.addr = (unsigned long)test_func;
 
 	/* Make sure cpu is stopped */
 	smp_cpu_stop(1);
 	set_flag(0);
-	smp_cpu_restart(1);
+	smp_cpu_restart_nowait(1);
+	report(!smp_cpu_stopped(1), "cpu started");
 	wait_for_flag();
+	report_pass("test flag");
+
+	report_prefix_pop();
+	report_prefix_push("running");
 
 	/*
 	 * Wait until cpu 1 has set the flag because it executed the
 	 * restart function.
 	 */
 	set_flag(0);
-	smp_cpu_restart(1);
+	smp_cpu_restart_nowait(1);
+	report(!smp_cpu_stopped(1), "cpu started");
 	wait_for_flag();
-	report_pass("restart while running");
+	report_pass("test flag");
+
+	report_prefix_pop();
+	report_prefix_pop();
 }
 
 static void test_stop(void)
-- 
2.32.0

