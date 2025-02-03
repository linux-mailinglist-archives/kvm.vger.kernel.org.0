Return-Path: <kvm+bounces-37113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E0BA2548F
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A55B7160BA1
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A0E20766C;
	Mon,  3 Feb 2025 08:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aAq1DSOj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62A5207A19
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571811; cv=none; b=pKKLdUThUX7Ce0ci7LGsD8YIx6rysUGkRGggbuRCBMsxojG0LdlH+2pRIsMT0oteeLcsckWWMC7ZHrmEku5EQqnJooWZ1w3WykiCUAUsjestY6juVhLkyJoTCOpaxTvrSJI1RhGlPD0wrmCtXW+rVAJUTXZh6PKrIu+QSQc/0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571811; c=relaxed/simple;
	bh=pTt1HxOpcKGFulC43K15//sRXaSnw9CAJMmxbYk4W9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugDOhXaQPRHVe2RZXOyI24a1drx3thL3WouJDgb03pt0rypo0NTXsh2IG+FI2TRdsi5/vE4bmvnK4nCuK0/ZBdaQ4mjXgk6jnUeFjyMgiTfy7HC9dAl0bqtff2T2hjdEHE6swGAedUAARhepNuKlbjKfqBK8JyAmbXIM8v++a28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aAq1DSOj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512LkaJD027268;
	Mon, 3 Feb 2025 08:36:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uzUC2co3msp0iiX6i
	mP+T7yNPXZnHyO+vvROU0ZAqfI=; b=aAq1DSOjxkYCB/Mjau8VOWrp8tu++48fb
	UhGZKEQfvh3VCbXM1Xk/bv/t7c0kZ+/0zJRz1GHDrMji+4h8MzOvFMqJjORq5ZY8
	/8qleCwBTjL/Y5T13QcdjN9Gf0efnxzjovWyXs/S8VdU8kU1A5dR9wzBvLT7UUw3
	NVExVIBCbGaQUFaPU/lLdgfswjh/EscrOSdH/cl81DHyCXrKTa4JPg0tM2vvgCvV
	PZIviExFIp8iZaLQw6EfEeEpOJSvbpHxy6baP2IeA1G1LRzfDQV1FWl+4kg7gvS/
	iN00jaHVzrXSrkA15h7sGM7SoEIRWmc+vyNM2tlsf7Ck8Z/AysVoQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jayyba1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:34 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 5138aYTJ014597;
	Mon, 3 Feb 2025 08:36:34 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jayyba1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137OFgO007136;
	Mon, 3 Feb 2025 08:36:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxaydhhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:32 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aTLo48169336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19E8020040;
	Mon,  3 Feb 2025 08:36:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 962EC20043;
	Mon,  3 Feb 2025 08:36:28 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:28 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests GIT PULL 09/18] s390x: Use library functions for snippet exit
Date: Mon,  3 Feb 2025 09:35:17 +0100
Message-ID: <20250203083606.22864-10-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iQnsEK7vqMsgWpqXRwqBKG4PCks80ttk
X-Proofpoint-ORIG-GUID: 2VtnVHaFpL6GxQqdHswPUi89HDJt5ZN4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Replace the existing code for exiting from snippets with the newly
introduced library functionality.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20241016180320.686132-6-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
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
2.47.1


