Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CE24D67BD
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350814AbiCKRjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350777AbiCKRjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:39:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5001AEED7;
        Fri, 11 Mar 2022 09:38:32 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BFGB8b032636;
        Fri, 11 Mar 2022 17:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bQ19AFhNQ965+dbWlTRvGuuuTm2yNEklAH6ut4OQWkw=;
 b=dUwKa04ffRhd5T2sxUPpvLWXVWLrHiGDmrXHMR9n0cn4ohRNAYs4Gyd9qBgyJ7JyqF1f
 VHVS3HGNlHjwCP/3j/4CMScZDXHHjeeNREsrd6Cq+A5mIImD89gd1RkUf6xNp+rbt5HJ
 3iz2PwV+9RhrA5S0nbvfzzKCmxtNGIip4ERprD15w+OXX09bS9b50Y+iYfaKSZiDakXS
 qUlvm+bF5Am4HYAE7Ay4zHM3JVP7W1hyveXrXKGC0/0Hu/nMgf5k5RNlBItZSONxaB+d
 bDM4lAJeESqWLHutp8SSb+n79c5RD/yRgU4XFIxQH1u8agSOWlMIwUJlm9wzvTzTYeri fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3er8wu2pg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:32 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BGKPBh031409;
        Fri, 11 Mar 2022 17:38:31 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3er8wu2pf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:31 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHXch8016755;
        Fri, 11 Mar 2022 17:38:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3eqr1nssy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHcQt452298062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:38:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71B78A4053;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E07FA4051;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id CD300E1371; Fri, 11 Mar 2022 18:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v2 5/6] s390x: smp: Create and use a non-waiting CPU restart
Date:   Fri, 11 Mar 2022 18:38:21 +0100
Message-Id: <20220311173822.1234617-6-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220311173822.1234617-1-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i_z8IleN_2eSadydSsfYFCmAnOcnaEMo
X-Proofpoint-ORIG-GUID: fXdZe72BGpxJntILx3rUtza3rWyJnPdm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_06,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

The kvm-unit-tests infrastructure for a CPU restart waits for the
SIGP RESTART to complete. In order to test the restart itself,
create a variation that does not wait, and test the state of the
CPU directly.

While here, add some better report prefixes/messages, to clarify
which condition is being examined (similar to test_stop_store_status()).

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 lib/s390x/smp.c | 24 ++++++++++++++++++++++++
 lib/s390x/smp.h |  1 +
 s390x/smp.c     | 21 ++++++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index b69c0e09..5be29d36 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -194,6 +194,30 @@ int smp_cpu_restart(uint16_t idx)
 	return rc;
 }
 
+/*
+ * Functionally equivalent to smp_cpu_restart(), but without the
+ * elements that wait/serialize matters here in the test.
+ * Used to see if KVM itself is serialized correctly.
+ */
+int smp_cpu_restart_nowait(uint16_t idx)
+{
+	check_idx(idx);
+
+	spin_lock(&lock);
+
+	/* Don't suppress a CC2 with sigp_retry() */
+	if (sigp(cpus[idx].addr, SIGP_RESTART, 0, NULL)) {
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
index f70a9c54..913da155 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -54,6 +54,10 @@ static void test_restart(void)
 {
 	struct cpu *cpu = smp_cpu_from_idx(1);
 	struct lowcore *lc = cpu->lowcore;
+	int rc;
+
+	report_prefix_push("restart");
+	report_prefix_push("stopped");
 
 	lc->restart_new_psw.mask = extract_psw_mask();
 	lc->restart_new_psw.addr = (unsigned long)test_func;
@@ -61,17 +65,28 @@ static void test_restart(void)
 	/* Make sure cpu is stopped */
 	smp_cpu_stop(1);
 	set_flag(0);
-	smp_cpu_restart(1);
+	rc = smp_cpu_restart_nowait(1);
+	report(!rc, "return code");
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
+	rc = smp_cpu_restart_nowait(1);
+	report(!rc, "return code");
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

