Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BEC4EEC28
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345443AbiDALSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345507AbiDALSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847E4184608
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:34 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231BDIPe022732
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GGxeMJmfpJ3wIkc5x2jkg+bl3Tmillm6T7pUK+VdpvI=;
 b=bqX27WksK3+9wfp0wql+C+5pxwnSw6gspN57imr/97HerwXNYsBu8VUukIcT85OGxSYW
 FkRJahW8WJJPoBnfTKqDNHx8USocnTQ1xTp+TEWKUZc/AqWynwuVjdzQM+YLYb+SjJz2
 yqy884NzflXHXE7nxl8dQ6S8Z9nKF2GJYwF+ca0E9DbFQ7Q3DHaIghU9rDugZosFGO2l
 tvqbvBzqaShzBOpqbpcpRvM0G1QhpKCGp4AvRB3OcrEwaJROA6h8JNAHMoUwbGIB/ZY9
 tXnJm67QVrW6QprLwkxUZXtdP1Y9eCcRaZ4iJEncDCYc0rxK/ZoLkhMZexRUH6zDQ5IY jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f60awr24a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:33 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BG8lO000888
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f60awr23m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B8dLk027950;
        Fri, 1 Apr 2022 11:16:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf94v65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGRPS49217940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB8C54C062;
        Fri,  1 Apr 2022 11:16:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E95D4C040;
        Fri,  1 Apr 2022 11:16:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:27 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 05/27] s390x: smp: Create and use a non-waiting CPU restart
Date:   Fri,  1 Apr 2022 13:15:58 +0200
Message-Id: <20220401111620.366435-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mOhkDGmFaBPx3vvjO-H-q9pB2odJ80oU
X-Proofpoint-GUID: MC0K5vMYf6Wj-xiqp_YJzkSWh9SGbcaO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

The kvm-unit-tests infrastructure for a CPU restart waits for the
SIGP RESTART to complete. In order to test the restart itself,
create a variation that does not wait, and test the state of the
CPU directly.

While here, add some better report prefixes/messages, to clarify
which condition is being examined (similar to test_stop_store_status()).

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/smp.h |  1 +
 lib/s390x/smp.c | 24 ++++++++++++++++++++++++
 s390x/smp.c     | 21 ++++++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

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
2.34.1

