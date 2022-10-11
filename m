Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB085FB85F
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 18:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJKQkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 12:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJKQkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 12:40:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E1B2182B
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 09:40:04 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BEiM0P022055
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vUTfR8xy7oAzzN5mU8tJbE0fMZ3aepTOuz5ykQZJSLU=;
 b=Uq+fCpAATmZTQgCrr08/WSDUNvBl8dr3BdmzxNYXhculzKPOePV5fkZsAfypiFwx40tm
 f9g/pYeInVXwwvEm7nkUJYr0blqNofIiT0zugVf7x1p7uKT5pbl3nbazuwTOLGLxEDt7
 wFsfRSLzM4sBqVQMmUAVj4jxw1KlYUG5Y/T6+m3ernk7ohdK2mWFqjpJbScjO2ltYDS1
 MdIikiXPUMlBrrrCtj8BLGv0hCXvlXjKdZp6ma/vZp/wrG3FE/euovHUboN5OvhjyrW7
 vxdcRngoU+dcGDcJ2wvm4qYaouYi6PsOAJWmWQiDzUMAiB1KNum6MOSKvPw/S7kSXd5s rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5a6f27n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BF6aua011314
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u94mg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:14:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BFEYTj20185598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 15:14:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E6D042047;
        Tue, 11 Oct 2022 15:14:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08FEB42045;
        Tue, 11 Oct 2022 15:14:34 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 15:14:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/2] lib/s390x: move TOD clock related functions to library
Date:   Tue, 11 Oct 2022 17:14:32 +0200
Message-Id: <20221011151433.886294-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221011151433.886294-1-nrb@linux.ibm.com>
References: <20221011151433.886294-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5optPosSzJ62qq0PQQ7V2wP9_nQkLSXm
X-Proofpoint-GUID: 5optPosSzJ62qq0PQQ7V2wP9_nQkLSXm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=972
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210110086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TOD-clock related functions can be useful for other tests beside the
sck test, hence move them to the library.

While at it, add a wrapper for stckf and express get_clock_us() with
stck() to reduce code duplication.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/time.h | 50 +++++++++++++++++++++++++++++++++++++++++++-
 s390x/sck.c          | 32 ----------------------------
 2 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index d8d91d68a667..c5e1797fd29e 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -18,11 +18,59 @@
 
 #define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
 
+static inline int sck(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	sck %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d"(cc)
+		: [time] "Q"(*time)
+		: "cc"
+	);
+
+	return cc;
+}
+
+static inline int stck(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	stck %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d" (cc), [time] "=Q" (*time)
+		:
+		: "cc", "memory"
+	);
+
+	return cc;
+}
+
+static inline int stckf(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	stckf %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d" (cc), [time] "=Q" (*time)
+		:
+		: "cc", "memory"
+	);
+
+	return cc;
+}
+
 static inline uint64_t get_clock_us(void)
 {
 	uint64_t clk;
 
-	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
+	stck(&clk);
 
 	return clk >> STCK_SHIFT_US;
 }
diff --git a/s390x/sck.c b/s390x/sck.c
index 88d52b74a586..dff496187602 100644
--- a/s390x/sck.c
+++ b/s390x/sck.c
@@ -12,38 +12,6 @@
 #include <asm/interrupt.h>
 #include <asm/time.h>
 
-static inline int sck(uint64_t *time)
-{
-	int cc;
-
-	asm volatile(
-		"	sck %[time]\n"
-		"	ipm %[cc]\n"
-		"	srl %[cc],28\n"
-		: [cc] "=d"(cc)
-		: [time] "Q"(*time)
-		: "cc"
-	);
-
-	return cc;
-}
-
-static inline int stck(uint64_t *time)
-{
-	int cc;
-
-	asm volatile(
-		"	stck %[time]\n"
-		"	ipm %[cc]\n"
-		"	srl %[cc],28\n"
-		: [cc] "=d" (cc), [time] "=Q" (*time)
-		:
-		: "cc", "memory"
-	);
-
-	return cc;
-}
-
 static void test_priv(void)
 {
 	uint64_t time_to_set_privileged = 0xfacef00dcafe0000,
-- 
2.36.1

