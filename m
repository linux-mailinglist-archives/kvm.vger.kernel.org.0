Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E5A59E4CF
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242500AbiHWOEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 10:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242815AbiHWOAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 10:00:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F1B23B3EC
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 04:08:03 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NAUkeT006633
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NbGhBPKo27SpqZyaNHn74Gl3SpPLzhLPdCOBBqbsb5c=;
 b=cLkykzFxAp4FVL5ODrL8MCodlUJWsYZZ5TgrQ1bGc/8VDact5lnfHUHIEa9dKXMYaO2+
 3rC31gdbiSDbCKH8D/aiXMDYGP6e7fw399ejKzGBasigA5e7Vgl0LKk4V1h2oPvDc0G/
 NPhCKcqmcWmmjzNCVXJy/Aglv5IxN5BWrGT6IjGnc+zxw3Wz2OvTUhWE7Fd8jA3W/BSI
 NLf7QgevGeh8U/ZAAruPzSplP8prbYT+3H4yiWSGidxdbUCr6oJYw1cBeNf9LIjaszLl
 AMvyIOajz/5nqvH39fcJ61bYzopqkajaQ1f6+TXN0fdMQ31GLEDoYWttC0xcl/y99WHT hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4w7508w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:40 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NAVeGP009377
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:39 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4w7508uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 10:38:39 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NALbWk025876;
        Tue, 23 Aug 2022 10:38:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3j2q89amqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 10:38:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NAcY9X31850822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 10:38:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E714942041;
        Tue, 23 Aug 2022 10:38:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4DD74204F;
        Tue, 23 Aug 2022 10:38:33 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 10:38:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v6 2/4] lib/s390x: add CPU timer related defines and functions
Date:   Tue, 23 Aug 2022 12:38:31 +0200
Message-Id: <20220823103833.156942-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220823103833.156942-1-nrb@linux.ibm.com>
References: <20220823103833.156942-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x9oh_lzk9bN9N5Ea-n64BXfEzNFd27_D
X-Proofpoint-GUID: dTDk4GJTEv8jQpyK2SLw3QBBxooJ5zl3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=972 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will make use of the CPU timer, so add some defines and
functions to work with the CPU timer.

Since shifts for both CPU timer and TOD clock are the same, introduce a
new constant S390_CLOCK_SHIFT_US for this value. The respective shifts
for CPU timer and TOD clock reference it, so the semantic difference
between the two defines is kept.

Also add a constant for the CPU timer subclass mask.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  1 +
 lib/s390x/asm/time.h     | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index e7ae454b3a33..b92291e8ae3f 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -78,6 +78,7 @@ struct cpu {
 #define CTL0_EMERGENCY_SIGNAL			(63 - 49)
 #define CTL0_EXTERNAL_CALL			(63 - 50)
 #define CTL0_CLOCK_COMPARATOR			(63 - 52)
+#define CTL0_CPU_TIMER				(63 - 53)
 #define CTL0_SERVICE_SIGNAL			(63 - 54)
 #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
 
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

