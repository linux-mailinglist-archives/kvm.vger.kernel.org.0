Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D6457D9E4
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 08:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbiGVGAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 02:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGVGAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 02:00:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F5D40BEA
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 23:00:50 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M5pUrF004070
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eIZdepR+Wm57hpK5yFwBMtMGsL+/aVzcBDZ/icH67vU=;
 b=H8yezDNZgV5Jh/lOfUCw8wKf24U7xFwWwwEg7vpKvrieNxC0Q+oWYBDw3xuZ7T0r3+Ab
 Db8NwD6HyAeNgh7m0kkKCF65mTR+7pDXT3z3nuQAVWeL9ZZ97PXRqbUCWa6DdEwQ16Kc
 YJipqnOY/8B2AgH8Rl+WXRWkjL+dNAsKkMHXMH/ctAOD43HMi2f0UnN+7SzNbrYfLzDQ
 nW/ykaTvn5Uh1OQmM34KxnTEhxKrAefZTx7UlgSFW7bGQs86IuSOzuE4CJZsErev2Jya
 uD7mNnh5UITKkm6ism3TAlO1OKJZRWz3AfHlnXnP5+FyhCWe7pfSSLtDomL8kXQIlCFc gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp47g5e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M5tN4q017889
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp47g5cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M5q3Ir003319;
        Fri, 22 Jul 2022 06:00:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8wxwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M60iFG19464556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 06:00:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8B0D5204E;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 75F2652054;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/4] lib: s390x: add CPU timer functions to time.h
Date:   Fri, 22 Jul 2022 08:00:41 +0200
Message-Id: <20220722060043.733796-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722060043.733796-1-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k-nlzjZpIHpJMj2DVn6UU6hzSsbL4rdj
X-Proofpoint-GUID: 2vBJkS2nQA6WgyT6pLo82lyY2A-DM2ne
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=760 adultscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220021
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will make use of the CPU timer, so add a convenience
function to set the CPU timer.

Since shifts for both CPU timer and TOD clock are the same, introduce a
new define S390_CLOCK_SHIFT_US. The respective shifts for CPU timer and
TOD clock reference it, so the semantic difference between the two
defines is kept.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/time.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 7652a151e87a..d8d91d68a667 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -11,9 +11,13 @@
 #ifndef _ASMS390X_TIME_H_
 #define _ASMS390X_TIME_H_
 
-#define STCK_SHIFT_US	(63 - 51)
+#define S390_CLOCK_SHIFT_US	(63 - 51)
+
+#define STCK_SHIFT_US	S390_CLOCK_SHIFT_US
 #define STCK_MAX	((1UL << 52) - 1)
 
+#define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
+
 static inline uint64_t get_clock_us(void)
 {
 	uint64_t clk;
@@ -45,4 +49,15 @@ static inline void mdelay(unsigned long ms)
 	udelay(ms * 1000);
 }
 
+static inline void cpu_timer_set_ms(int64_t timeout_ms)
+{
+	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_SHIFT_US;
+
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

