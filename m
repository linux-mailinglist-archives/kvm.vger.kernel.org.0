Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0088E46C041
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbhLGQFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:05:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239396AbhLGQFs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:05:48 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7EqQDA015333;
        Tue, 7 Dec 2021 16:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xvEcyoX1IPYUwn7eM0f6UZgfKlc9gOscPo9579zIcAI=;
 b=D/2Mbw3vt1ghmbycCq6ZwTrXbRQnhWd69M1XsAsi/n72XXSD5EzRU9ayKTMn9DGMLkLz
 fE4qUw55pgvahLYosY2SGX5YiCsIZfdenQh9/OmhlY7YPVXChdwluivMvrQ3HFE3/tcu
 kM8Pd07cubxGejr6GFA1LYKkofdnui+w6rKUpi5jWFNEAMH3aIMbysoFL15GbjuBpKJn
 9eW4iXfafOlGAxgf9aA1KKXqXSfJjK5O/PKEPCSPRANdilL7kL70R5ZhVgUVhZ+zjqBY
 U16l32qtS0lPXJwi5LVN8wpi5sJCfV+H+B6WTaFukx9jgJoaQ0U1IvtxzBR+MhTUfGtV Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct9rt1knj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:17 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7FtD8s000979;
        Tue, 7 Dec 2021 16:02:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct9rt1kmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Frm6P031587;
        Tue, 7 Dec 2021 16:02:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3cqyy9pye9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7G2AHQ24248592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 16:02:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADBF34C050;
        Tue,  7 Dec 2021 16:02:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 725B14C044;
        Tue,  7 Dec 2021 16:02:09 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:02:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 09/10] s390x: mvpg-sie: Use snippet helpers
Date:   Tue,  7 Dec 2021 16:00:04 +0000
Message-Id: <20211207160005.1586-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207160005.1586-1-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -7i70Yuq-7DwuZtX2K5USQ-LampucfDl
X-Proofpoint-ORIG-GUID: wZ9_EskjU7k0tGxQu7BzKMOKrAeS-rkW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time to use our shiny new snippet helpers.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/mvpg-sie.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index d526069d..8ae9a52a 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -21,17 +21,12 @@
 #include <sie.h>
 #include <snippet.h>
 
-static u8 *guest;
 static struct vm vm;
 
 static uint8_t *src;
 static uint8_t *dst;
 static uint8_t *cmp;
 
-extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
-extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
-int binary_size;
-
 static void test_mvpg_pei(void)
 {
 	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
@@ -78,9 +73,6 @@ static void test_mvpg_pei(void)
 
 static void test_mvpg(void)
 {
-	int binary_size = SNIPPET_LEN(c, mvpg_snippet);
-
-	memcpy(guest, SNIPPET_NAME_START(c, mvpg_snippet), binary_size);
 	memset(src, 0x42, PAGE_SIZE);
 	memset(dst, 0x43, PAGE_SIZE);
 	sie(&vm);
@@ -89,20 +81,20 @@ static void test_mvpg(void)
 
 static void setup_guest(void)
 {
+	extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
+	extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
+
 	setup_vm();
 
-	/* Allocate 1MB as guest memory */
-	guest = alloc_pages(8);
+	snippet_setup_guest(&vm, false);
+	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
+		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
 
-	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
-
-	vm.sblk->gpsw = snippet_psw;
-	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
 	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
 	vm.sblk->eca = ECA_MVPGI;
 
-	src = guest + PAGE_SIZE * 6;
-	dst = guest + PAGE_SIZE * 5;
+	src = (uint8_t *) vm.sblk->mso + PAGE_SIZE * 6;
+	dst = (uint8_t *) vm.sblk->mso + PAGE_SIZE * 5;
 	cmp = alloc_page();
 	memset(cmp, 0, PAGE_SIZE);
 }
-- 
2.32.0

