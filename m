Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BB4424F89
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbhJGIyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:54:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240537AbhJGIyN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:54:13 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19786u8E002712;
        Thu, 7 Oct 2021 04:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FT2IV99QtWohoVuHtPbk3fJbQiHmrjdN2tjoxVa9VG8=;
 b=PyD/5mqf6W16NORkXWr6Tm3xbKC5DwSgSATbx1xrWR9CaBWjWPRKO/5blJA6F/87GOp6
 z2zAMzpx2Xy765Y6YyPHRFQ2xM4IQG7SzoeVDYD1cpc9+eGP4h6QLNZFvpDi9dpyrl5c
 wdmS9rC7hiCo7UrVRdRn6kdgMgCy0aWc5puKLefEXlwF7H+gOqCMkmu9zxpHG/Y8oXn3
 0Js4DVlMdLo6XYJzCOhkXwYAPymHB85B7txe0H1kLBtgEdFKp3agAddI2uI0YRxDA5ik
 XqQ1GYjqrVYjoS1yDQma/u1d5GloIqHW7Mr8qwBydqN3w7uT65wm2XAVLxTBTsoukml1 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh1wwe32g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:19 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1977mV8I012430;
        Thu, 7 Oct 2021 04:52:19 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh1wwe30b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:19 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978puHl003748;
        Thu, 7 Oct 2021 08:52:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3bef2aan4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:52:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978kXkq49349110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:46:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 903DDAE04D;
        Thu,  7 Oct 2021 08:51:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B92F8AE065;
        Thu,  7 Oct 2021 08:51:54 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:51:54 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 5/9] lib: s390x: Add access key argument to tprot
Date:   Thu,  7 Oct 2021 08:50:23 +0000
Message-Id: <20211007085027.13050-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hBrVw29rcg85rPGvEZAEGpUyTlEFZrzH
X-Proofpoint-GUID: 4t2C4tl_sylg8qrwnnOMW6yH4QVfZour
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=776 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Currently there is only one callee passing a non zero key,
but having the argument will be useful in the future.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 6 +++---
 lib/s390x/sclp.c         | 2 +-
 s390x/skrf.c             | 3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index c8d2722a..b34aa792 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -233,15 +233,15 @@ static inline uint16_t get_machine_id(void)
 	return cpuid;
 }
 
-static inline int tprot(unsigned long addr)
+static inline int tprot(unsigned long addr, char access_key)
 {
 	int cc;
 
 	asm volatile(
-		"	tprot	0(%1),0\n"
+		"	tprot	0(%1),0(%2)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
-		: "=d" (cc) : "a" (addr) : "cc");
+		: "=d" (cc) : "a" (addr), "a" (access_key << 4) : "cc");
 	return cc;
 }
 
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 9502d161..02722498 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -217,7 +217,7 @@ void sclp_memory_setup(void)
 	/* probe for r/w memory up to max memory size */
 	while (ram_size < max_ram_size) {
 		expect_pgm_int();
-		cc = tprot(ram_size + storage_increment_size - 1);
+		cc = tprot(ram_size + storage_increment_size - 1, 0);
 		/* stop once we receive an exception or have protected memory */
 		if (clear_pgm_int() || cc != 0)
 			break;
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 8ca7588c..ca4efbf1 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -103,8 +103,7 @@ static void test_tprot(void)
 {
 	report_prefix_push("tprot");
 	expect_pgm_int();
-	asm volatile("tprot	%[addr],0xf0(0)\n"
-		     : : [addr] "a" (pagebuf) : );
+	tprot((unsigned long)pagebuf, 0xf);
 	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
 	report_prefix_pop();
 }
-- 
2.30.2

