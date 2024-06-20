Return-Path: <kvm+bounces-20089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5796E9107EA
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DB402830DE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3E91ACE9A;
	Thu, 20 Jun 2024 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X3HkMIt+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E8C1AE0BA;
	Thu, 20 Jun 2024 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893039; cv=none; b=nGMe8K9dWdYsAkEqmDMoOZHRCJINOLoMuBZcNy+vYFsZdtNKzXVr+XJ3K2dQFXuqSiE4jPg1RPwyoJKv3gfTzFxIP8zIUbTwOnU/g9NK9kGCToc7jhQDusNlghVJtX3EOoCrn6VokbtYWZfgMMPINCvFmqHGTfE0enuJgq13cbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893039; c=relaxed/simple;
	bh=Km/sCIal4KA+/3RwOV6NWtBT+wUhcfEHKXkvLUrmdPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tPHWw/zTl8M1U8seA5eOm7Z8mD+8bQKRivIM3fULI3mRdLlcovwROXH+vVcXbNdDwrEIpmzLtLLg6dEjSNTc0hIiEdR5uMukxYHZxywgE5gHmYD1NCfDC6YVnS89mEmFfq7C1QWfynTYR8cGTRdIvlHGNOLaQHm8rJt5CNj1+fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X3HkMIt+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KEEQfv022258;
	Thu, 20 Jun 2024 14:17:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=fey+DeOa62WmH
	7MehgUb+g88MYUXM4kvv+BBrjsafb4=; b=X3HkMIt+8c+Mb6nIZnLUDFGbbkTpk
	wuu4vtb+o+DsXie9xTdbT6KcXpQ4wUNjpMF0dHrZ4GurOrrxePFxcsReVknOLD9D
	ULkmmgPBWfKEX1inMNb2rD7OOcnDGBNfrJhDDtykrPcnZJdVok49SUj9tKAHXrW2
	J+ShOiAvgeBmqhbuqfOH2fuo7Ki9K2HWCCJOceLkfBpvYFgmf+T4iNxoYFl/4Bsk
	aK9Tm8z87aLLbnNiphtyMOrZBS4lgRGuW/rZuQ3KUeqfuWtW8WMzamNcTVNTRqUW
	XJnG7EybxMxkC9sldpBCaXNCMTIdx2p0lFpJS6sozYcIOAtWjJW/fBWSg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnbhg503-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:14 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEHElV028082;
	Thu, 20 Jun 2024 14:17:14 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnbhg501-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KE1XUn019495;
	Thu, 20 Jun 2024 14:17:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ysnp1q00g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH4Dp38273320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 417F920063;
	Thu, 20 Jun 2024 14:17:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B58D20065;
	Thu, 20 Jun 2024 14:17:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v3 6/7] s390x: Use library functions for snippet exit
Date: Thu, 20 Jun 2024 16:16:59 +0200
Message-Id: <20240620141700.4124157-7-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240620141700.4124157-1-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0h6RvCqA1W4GDTukv-dr2qcuWFX78y4v
X-Proofpoint-ORIG-GUID: tLcW6hBz1W0TN-8ZXZ5aWw9U598dmX4A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200099

Replace the existing code for exiting from snippets with the newly
introduced library functionality.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/sie-dat.c            | 11 +++--------
 s390x/snippets/c/sie-dat.c | 19 +------------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
index 9e60f26e..c8f38220 100644
--- a/s390x/sie-dat.c
+++ b/s390x/sie-dat.c
@@ -27,23 +27,18 @@ static void test_sie_dat(void)
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
index 9d89801d..26f045b1 100644
--- a/s390x/snippets/c/sie-dat.c
+++ b/s390x/snippets/c/sie-dat.c
@@ -10,28 +10,11 @@
 #include <libcflat.h>
 #include <asm-generic/page.h>
 #include <asm/mem.h>
+#include <snippet-guest.h>
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


