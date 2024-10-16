Return-Path: <kvm+bounces-29022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 731A69A1128
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBAC31F24CF7
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0302144A8;
	Wed, 16 Oct 2024 18:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TX/BZWUW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBFD210195;
	Wed, 16 Oct 2024 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101813; cv=none; b=JAzztOwbt/eB+Da4bNDQtkxw8ISV/OLpwViFsP8qv2q1ieEZM30yJDzdwC//I5WryT005wHKJWiXvBYxuTHm6YvSbtTyr8NN5+bRq6vBBtPbYXFn9CiFGY6xNYBO6cnBY1Z8PsXOvXQqfB5X2Jw64p40JIcL84iMphiDWYVKvy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101813; c=relaxed/simple;
	bh=bBBKuJCx1AIpGf30S88tX/OKx6J/Gq6hl6pLgmUdlPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgciJcqUSAHamWomMT2bI9ITSwnTsQlfcjbZKVs8uOkIBIhiaz+Yo+tH0WHur2a016zpUa1Nf42KxNIMTnjxOVvdR7ToQhTprMaOSDcnZEpzUQJjsYirWXFd0CV69rIfLRyUuzZxsq3rCDAoWUo7nLyl9abuKh5Q8tNwRWwS1kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TX/BZWUW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GFj1vd029595;
	Wed, 16 Oct 2024 18:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uQeM+TzA576VDxP9W
	2y+SZ8MTQww7xNptWT3qgceP2o=; b=TX/BZWUWYDg2rgLpFPSiccdBEO8T3+OVS
	5O/pYnaxem3biBi10bhVt8hAWgDwYPsS7IUj2mIb6+5+IqYx1d2WR7ZocikgPkIX
	TUfDp4FbHDyLAY2pK0Lp8h930/fd9S9a4/8edCK97y8s/W20TQ1j6Bon8/D2tWPr
	WpCUwL1o2reWVVqE3ct9Ls8G54j9kktlGrYTjpBuwc3QzFC24UF20T0toqVmIIdL
	PJddFMem/rHvVACh6JURTasEQizfLXVRB0eNUA66exhzw1C2gLrc37w4muorkqD2
	azSeENTl+zKV3W7uODhiSUAolm/hmNs0cWb0epRj6SNGq7sZb78Jw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42agd70kuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:30 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GI3U5Z026740;
	Wed, 16 Oct 2024 18:03:30 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42agd70kum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GGw3Q4006789;
	Wed, 16 Oct 2024 18:03:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xkap92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GI3PVd20513030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 18:03:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92F7E20049;
	Wed, 16 Oct 2024 18:03:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F36620040;
	Wed, 16 Oct 2024 18:03:25 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 18:03:25 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v4 5/6] s390x: Use library functions for snippet exit
Date: Wed, 16 Oct 2024 20:03:16 +0200
Message-ID: <20241016180320.686132-6-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241016180320.686132-1-nsg@linux.ibm.com>
References: <20241016180320.686132-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NTPn4AWDQ4hDqjXWdNzln42wE3_Z1-dQ
X-Proofpoint-ORIG-GUID: AAfXAiU0Vkw1UbliRTnWb5IczKtF9J_L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160115

Replace the existing code for exiting from snippets with the newly
introduced library functionality.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/sie-dat.c            | 12 ++++--------
 s390x/snippets/c/sie-dat.c | 19 +------------------
 2 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
index f0257770..44bf29fe 100644
--- a/s390x/sie-dat.c
+++ b/s390x/sie-dat.c
@@ -17,6 +17,7 @@
 #include <sclp.h>
 #include <sie.h>
 #include <snippet.h>
+#include <snippet-exit.h>
 #include "snippets/c/sie-dat.h"
 
 static struct vm vm;
@@ -27,23 +28,18 @@ static void test_sie_dat(void)
 	uint64_t test_page_gpa, test_page_hpa;
 	uint8_t *test_page_hva, expected_val;
 	bool contents_match;
-	uint8_t r1;
 
 	/* guest will tell us the guest physical address of the test buffer */
 	sie(&vm);
-	assert(vm.sblk->icptcode == ICPT_INST &&
-	       (vm.sblk->ipa & 0xff00) == 0x8300 && vm.sblk->ipb == 0x9c0000);
-
-	r1 = (vm.sblk->ipa & 0xf0) >> 4;
-	test_page_gpa = vm.save_area.guest.grs[r1];
+	assert(snippet_is_force_exit_value(&vm));
+	test_page_gpa = snippet_get_force_exit_value(&vm);
 	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
 	test_page_hva = __va(test_page_hpa);
 	report_info("test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
 
 	/* guest will now write to the test buffer and we verify the contents */
 	sie(&vm);
-	assert(vm.sblk->icptcode == ICPT_INST &&
-	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
+	assert(snippet_is_force_exit(&vm));
 
 	contents_match = true;
 	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
index 9d89801d..ba1604de 100644
--- a/s390x/snippets/c/sie-dat.c
+++ b/s390x/snippets/c/sie-dat.c
@@ -10,28 +10,11 @@
 #include <libcflat.h>
 #include <asm-generic/page.h>
 #include <asm/mem.h>
+#include <snippet-exit.h>
 #include "sie-dat.h"
 
 static uint8_t test_pages[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
-static inline void force_exit(void)
-{
-	asm volatile("diag	0,0,0x44\n"
-		     :
-		     :
-		     : "memory"
-	);
-}
-
-static inline void force_exit_value(uint64_t val)
-{
-	asm volatile("diag	%[val],0,0x9c\n"
-		     :
-		     : [val] "d"(val)
-		     : "memory"
-	);
-}
-
 int main(void)
 {
 	uint8_t *invalid_ptr;
-- 
2.44.0


