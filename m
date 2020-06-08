Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D191F1449
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgFHINn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:13:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729095AbgFHINM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 04:13:12 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05885eDI015511;
        Mon, 8 Jun 2020 04:13:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41dha8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 04:13:11 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05886mgH019826;
        Mon, 8 Jun 2020 04:13:10 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41dha64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 04:13:10 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05885LW3016173;
        Mon, 8 Jun 2020 08:13:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 31g2s7se9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 08:13:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0588D5Xp59441350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 08:13:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A11924C059;
        Mon,  8 Jun 2020 08:13:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59BE24C040;
        Mon,  8 Jun 2020 08:13:05 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 08:13:05 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v8 06/12] s390x: clock and delays caluculations
Date:   Mon,  8 Jun 2020 10:12:55 +0200
Message-Id: <1591603981-16879-7-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_04:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=916
 bulkscore=0 suspectscore=1 cotscore=-2147483648 priorityscore=1501
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080062
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hardware gives us a good definition of the microsecond,
let's keep this information and let the routine accessing
the hardware keep all the information and return microseconds.

Calculate delays in microseconds and take care about wrapping
around zero.

Define values with macros and use inlines to keep the
milliseconds interface.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/time.h | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 1791380..eb15941 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -13,14 +13,39 @@
 #ifndef ASM_S390X_TIME_H
 #define ASM_S390X_TIME_H
 
-static inline uint64_t get_clock_ms(void)
+#define STCK_SHIFT	(63 - 51)
+#define STCK_MAX	((1 << (STCK_SHIFT + 1)) - 1)
+
+static inline uint64_t get_clock_us(void)
 {
 	uint64_t clk;
 
 	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
 
 	/* Bit 51 is incrememented each microsecond */
-	return (clk >> (63 - 51)) / 1000;
+	return clk >> STCK_SHIFT;
+}
+
+static inline void udelay(unsigned long us)
+{
+	unsigned long startclk = get_clock_us();
+	unsigned long c;
+
+	do {
+		c = get_clock_us();
+		if (c < startclk)
+			c += STCK_MAX;
+	} while (c < (startclk + us));
+}
+
+static inline void mdelay(unsigned long ms)
+{
+	udelay(ms * 1000);
+}
+
+static inline uint64_t get_clock_ms(void)
+{
+	return get_clock_us() / 1000;
 }
 
 #endif
-- 
2.25.1

