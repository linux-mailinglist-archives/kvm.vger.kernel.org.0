Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0B5A238B
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 10:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245443AbiHZIt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 04:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245242AbiHZItw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 04:49:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9779195B7
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 01:49:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q8gNMO035785
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PbpP+ABPLVMb2fufOxH269t+uLsVErt/6m63cjwzmzg=;
 b=hNCE4DmXGr1rbfq/3ANs1JLD5XuE79810N4m9crvdiAEgjldYikNfg+fhMhZaPLwe1hT
 7cZjOcp4iojI2obSvJfHpyTGpO7x0JUgS7RIYqzGQtlSS5By3c6/XJ/ZT4Ph0a4MX/u4
 EUoAKteLjbmDqi7tP23F+qSt1itjcgcwzDlco9cHVY0Hp35n/HLugH0NCqMnlF92FJEW
 nReCwCd3ru1O1wGbwSxRs/scHF/K+ITgUiKmJ6g2AEsg7WiAqbiJW3aY6+zQUYl9Jl6F
 428QX677NbkgEdyGRyP+hdfaiYQkYyH0zHU5TXxx7nIni6A2z6vYt9henIHMiMxUIpCH qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6tw6859p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:50 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27Q8gdUo036749
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:49:50 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6tw6858y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 08:49:50 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27Q8lxFR002918;
        Fri, 26 Aug 2022 08:49:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3j2pvj7gg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 08:49:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27Q8njZK39321984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 08:49:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAD96AE04D;
        Fri, 26 Aug 2022 08:49:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B80EBAE055;
        Fri, 26 Aug 2022 08:49:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Aug 2022 08:49:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/2] lib/s390x: move TOD clock related functions to library
Date:   Fri, 26 Aug 2022 10:49:43 +0200
Message-Id: <20220826084944.19466-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220826084944.19466-1-nrb@linux.ibm.com>
References: <20220826084944.19466-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2blXXBDEudYrfvM2B-6P_LX-uuvQBT1r
X-Proofpoint-GUID: sw9SFIyJNEfgD5PQvpnJSqIPYS94NMge
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=989
 suspectscore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TOD-clock related functions can be useful for other tests beside the
sck test, hence move them to the library.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/time.h | 48 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/sck.c          | 32 -----------------------------
 2 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 7652a151e87a..81b57e2b4894 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -28,6 +28,54 @@ static inline uint64_t get_clock_ms(void)
 	return get_clock_us() / 1000;
 }
 
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
 static inline void udelay(unsigned long us)
 {
 	unsigned long startclk = get_clock_us();
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

