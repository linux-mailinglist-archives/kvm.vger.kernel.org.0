Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF415BDE42
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiITHcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiITHcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:32:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D8D5FACE;
        Tue, 20 Sep 2022 00:32:12 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7VkLL012137;
        Tue, 20 Sep 2022 07:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=zHHALfZF8bmyprv06ktyW0VatWEan4k+TIjdCoKp5EA=;
 b=mBk2WHFtatp671fwIva/0xGH46SwiXk+TWh5yNEZM3BNu3bKm+zUB3pt/Q/OnCMcnQwj
 49d8z3kUeP+r2OgCcI0kluWoHbj7x00eOdRV8nilhKqmLeQjXNwM6Kjqc4rX+yhf1KIc
 jefR81IrFiu21/+11lqqtdGkJhtw0RoFutw8NtnfXiDHkmDMVorfHCZ6qYBx+ECGRgqq
 bt49PPx0I5pKMbhFtDalmJCwTVw8vw31l/ctemGPSxNwcQZ57N4OeVai4NhyF3bGmr+z
 Ex5HnnnyO0Iof4EhggaOg7BvCMEAi19HU3hGnTR8iSQ41RXFUXYMWai0s6eq2gFBSN1g lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq978007a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7WB9o013510;
        Tue, 20 Sep 2022 07:32:11 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq9780070-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:11 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7MRDx011889;
        Tue, 20 Sep 2022 07:32:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3jn5v92jm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7WWQI52035996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:32:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2186611C04C;
        Tue, 20 Sep 2022 07:32:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25F6311C04A;
        Tue, 20 Sep 2022 07:32:05 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:32:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 06/11] lib/s390x: add CPU timer related defines and functions
Date:   Tue, 20 Sep 2022 07:30:30 +0000
Message-Id: <20220920073035.29201-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: icY3XKEla9_HOfV868fxfgXJZR3NACKL
X-Proofpoint-ORIG-GUID: CBZE__BMtcY7xREJFECM0tEuMbw3rbqt
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Upcoming changes will make use of the CPU timer, so add some defines and
functions to work with the CPU timer.

Since shifts for both CPU timer and TOD clock are the same, introduce a
new constant S390_CLOCK_SHIFT_US for this value. The respective shifts
for CPU timer and TOD clock reference it, so the semantic difference
between the two defines is kept.

Also add a constant for the CPU timer subclass mask.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220823103833.156942-3-nrb@linux.ibm.com
Message-Id: <20220823103833.156942-3-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  1 +
 lib/s390x/asm/time.h     | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index e7ae454b..b92291e8 100644
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
index 7652a151..d8d91d68 100644
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
2.34.1

