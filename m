Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32275654A8
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiGDMNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbiGDMNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:13:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEE5CEF;
        Mon,  4 Jul 2022 05:13:35 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264C7puA018277;
        Mon, 4 Jul 2022 12:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mWCOmnuxzWvLNLfEJ8Vs9dWOw2rUeXUXgIGxyHeUMgs=;
 b=dTIzz7//73AMV5rAF8rJLkaVhSykACIftmdkVwlzR/C9SNWCXOwFunFjrroX49sYMh/Z
 PqypnRRk8o2ZgLqjMzGcK4ij/Ciu8BzL0BR0Wtiedd3OWC6YiYT5LxVT1mTxwGgj/Py+
 u3okNOkKr800SmV4KeI7YGTyo9t/ayJIWpHgeH68Tk2Fb+1/WY2dXLK+xwOQTcYVBvAk
 XtFZNPDfmStF8uWCtXHkmvsyukdaV98X9bcGthOsOq4N1KqM6VOGbeRjBtDN1mKudmhq
 mj5jYhiopeZUCveO7uK0CaYzqOWZvcr4YCEiLYvhcU2XjzTQ1ZkLpSaiAKOTpQ8sVPj3 rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3ypmrdwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:34 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264C9WV0024618;
        Mon, 4 Jul 2022 12:13:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3ypmrdvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264C5sss008568;
        Mon, 4 Jul 2022 12:13:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3h2d9japg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 12:13:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264CDTYp23658904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 12:13:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3791652050;
        Mon,  4 Jul 2022 12:13:29 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0445452051;
        Mon,  4 Jul 2022 12:13:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/4] lib: s390x: add CPU timer functions to time.h
Date:   Mon,  4 Jul 2022 14:13:26 +0200
Message-Id: <20220704121328.721841-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704121328.721841-1-nrb@linux.ibm.com>
References: <20220704121328.721841-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eM_oFtfiXnomEdHj7PNMiILC4QX9ZarG
X-Proofpoint-ORIG-GUID: T9DP3btdDOIpf0FbYGvBeslnkjKzzshB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=892 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will make use of the CPU timer, so add a convenience
function to set the CPU timer.

Since shifts for both CPU timer and TOD clock are the same, introduce a
new define TIMING_S390_SHIFT_US. The respective shifts for CPU timer and
TOD clock reference it, so the semantic difference between the two
defines is kept.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/time.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 7652a151e87a..9ae364afb8a3 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -11,9 +11,13 @@
 #ifndef _ASMS390X_TIME_H_
 #define _ASMS390X_TIME_H_
 
-#define STCK_SHIFT_US	(63 - 51)
+#define TIMING_S390_SHIFT_US	(63 - 51)
+
+#define STCK_SHIFT_US	TIMING_S390_SHIFT_US
 #define STCK_MAX	((1UL << 52) - 1)
 
+#define CPU_TIMER_SHIFT_US	TIMING_S390_SHIFT_US
+
 static inline uint64_t get_clock_us(void)
 {
 	uint64_t clk;
@@ -45,4 +49,14 @@ static inline void mdelay(unsigned long ms)
 	udelay(ms * 1000);
 }
 
+static inline void cpu_timer_set(int64_t timeout_ms)
+{
+	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_SHIFT_US;
+	asm volatile (
+		"spt %[timer_value]\n"
+		:
+		: [timer_value] "Q" (timer_value)
+	);
+}
+
 #endif
-- 
2.36.1

