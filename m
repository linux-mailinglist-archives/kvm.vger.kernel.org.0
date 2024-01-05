Return-Path: <kvm+bounces-5754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC82825CA0
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 23:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7386F284FDE
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 22:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BBC360AC;
	Fri,  5 Jan 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rAE8JeIu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016BE36094;
	Fri,  5 Jan 2024 22:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 405LEd8x011374;
	Fri, 5 Jan 2024 22:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jL9WuhB2I9klluRSf1v59LBWX2ZrrXN58UHByaLNpo0=;
 b=rAE8JeIulLgB4wc3EHZftj3UKUE9dYHAf+lhJJ1PQvDkn7rlRyY74rSceWXqw6WDeLtN
 vdzAndJHY2JUCXCfdT58CbH5D//REiZ9nEezb4Pk6QnTt/0azxxIaZtwIDPIYwQiiZKm
 Do/OaUVd4DX9QL7pR8x59hT4MiHo11TIua4dOB6BoNe+wRQqZI+r/vkCUOs0QciAdqes
 WXBdhWRWuUzi/4iY4UtA4heahS3/j71XN4akYZ0cARQDkFW5ICQbxgAXJdFhU8QlxYWt
 Y4UfM6OaUObbq/DkIzoMMalUN9Kynq6m9cj4ZIkAfvoAEzS6cGxvcnEMMWcPObUvE316 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3verf3twwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:28 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 405Mq3sA022409;
	Fri, 5 Jan 2024 22:54:27 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3verf3twvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:27 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 405KRmxA024643;
	Fri, 5 Jan 2024 22:54:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vb082sumc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 405MsOS928377712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Jan 2024 22:54:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E103120043;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A160620040;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v2 4/5] s390x: Use library functions for snippet exit
Date: Fri,  5 Jan 2024 23:54:18 +0100
Message-Id: <20240105225419.2841310-5-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240105225419.2841310-1-nsg@linux.ibm.com>
References: <20240105225419.2841310-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fLc0S04-2nOv7NHMO-Z90UnBKRVfxYpA
X-Proofpoint-ORIG-GUID: 8YnYsq3TgjgVPbV2YaneIPBBL_Zz_dPo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-05_08,2024-01-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxlogscore=989 clxscore=1015 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401050176

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
index ecfcb60e..414afd42 100644
--- a/s390x/snippets/c/sie-dat.c
+++ b/s390x/snippets/c/sie-dat.c
@@ -9,28 +9,11 @@
  */
 #include <libcflat.h>
 #include <asm-generic/page.h>
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
2.43.0


