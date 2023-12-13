Return-Path: <kvm+bounces-4323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1753C811193
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9233281EF0
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E472C198;
	Wed, 13 Dec 2023 12:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="egWi7QZj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C83CF;
	Wed, 13 Dec 2023 04:49:54 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDBg7w1012627;
	Wed, 13 Dec 2023 12:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ohNkST7v9P/jw2vaqTn4Kx8aR9QUP7uMxD/EhkxjZ/I=;
 b=egWi7QZj/S9UqrYSJpVfAHAav0vsXuN94ukm6UYGjCl6p8QnIe3lXr8O5JnazDqMzSdw
 gctP9ZuaxBMQRcJ7Qx6CoBQ38Nl71gfB8Al2+2f8WdsVlvyWO1EzupklEEwTeC5W8PN+
 7jfbgOi2wIPFLvtrHGQIPZDCM7MouKg/NOYpcjPTqWIQoTqLk5z19QFTZ88q3pfQWp52
 AtypcA9s0v621MRiK7lA5cF4c2qrGAB9xCgskqlCdziQqI0t5dBzi/C/TNAWWVVcXSLw
 ZlIMJdnkmwI4GMRAznzdv0x9qC06yxGt3deKfxtN2XRy8DU8LeP0Er+PKx3nCz4BQ5Aq 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybyj9wa7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:51 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDCSmX5029544;
	Wed, 13 Dec 2023 12:49:50 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybyj9w9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:50 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDArZX0004139;
	Wed, 13 Dec 2023 12:49:49 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw4skgdxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:49 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDCnjPO17302216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:49:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 482C720040;
	Wed, 13 Dec 2023 12:49:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16F4D2004D;
	Wed, 13 Dec 2023 12:49:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 12:49:45 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/5] s390x: Use library functions for snippet exit
Date: Wed, 13 Dec 2023 13:49:41 +0100
Message-Id: <20231213124942.604109-5-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231213124942.604109-1-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9VbWiMtbsb5W4N--mjhcbFI-EkzxryuP
X-Proofpoint-ORIG-GUID: iMHelifZZqLFyKF2zrZKJs5MTtfUFmzr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130093

Replace the existing code for exiting from snippets with the newly
introduced library functionality.
This causes additional report()s, otherwise no change in functionality
intended.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/sie-dat.c            | 10 ++--------
 s390x/snippets/c/sie-dat.c | 19 +------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
index 9e60f26e..6b6e6868 100644
--- a/s390x/sie-dat.c
+++ b/s390x/sie-dat.c
@@ -27,23 +27,17 @@ static void test_sie_dat(void)
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
+	assert(snippet_get_force_exit_value(&vm, &test_page_gpa));
 	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
 	test_page_hva = __va(test_page_hpa);
 	report_info("test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
 
 	/* guest will now write to the test buffer and we verify the contents */
 	sie(&vm);
-	assert(vm.sblk->icptcode == ICPT_INST &&
-	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
+	assert(snippet_check_force_exit(&vm));
 
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
2.41.0


