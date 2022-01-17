Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E41A490D12
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbiAQRAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241371AbiAQRAB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:00:01 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGSdkt028902
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oOpitOAsYhRPOBoYbyPcHJixHjNV9LwJM+mTa56AieY=;
 b=RGgE2fH0+1uOJFcLznHh3nzDo0G6XkN2sc2UmOjORC6rzOBWYaO+nNOnn8zeS8TfoBjM
 tOMVYJuP9egA6i0WAVESnsDHD+fpX+DxwVw86c26LL2vOsK9cbOL+D4aiilPtLINcsqk
 +xiby2dx3OcfMOtVEjMFgLHUStV4a03tYHRoF1Xk2c203aWRahOyIrQj2P4ZCmlEHecm
 M0WMcG93PCt7XU2EwOs5PzXmjnpZSgQw08vZjMZkQaDPqW9PNN7g7bU1SqDAW/8/aI5k
 5VL4NOGh0KhDzhN1Fch+A6RavQz8qZyLqVGEfMFEIkwsIOi7iyTnep9pZ67a5mgWM807 /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnc0trpk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HH00Yb012850
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnc0trpje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 17:00:00 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGlsfM030109;
        Mon, 17 Jan 2022 16:59:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw955p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxsME37945652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3946A405C;
        Mon, 17 Jan 2022 16:59:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A58AA4054;
        Mon, 17 Jan 2022 16:59:54 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:54 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 10/13] s390x: mvpg-sie: Use snippet helpers
Date:   Mon, 17 Jan 2022 17:59:46 +0100
Message-Id: <20220117165949.75964-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z7HHrfbQ-NY3JWJIIgQzPwkAbVvzuw4_
X-Proofpoint-ORIG-GUID: X-eLfKrbIQKRO4OFp-Fbt0l0IVt-G6aW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Time to use our shiny new snippet helpers.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
-	setup_vm();
+	extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
+	extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
 
-	/* Allocate 1MB as guest memory */
-	guest = alloc_pages(8);
+	setup_vm();
 
-	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
+	snippet_setup_guest(&vm, false);
+	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
+		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
 
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
2.31.1

