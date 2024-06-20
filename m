Return-Path: <kvm+bounces-20084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1859107E2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D2E72836DC
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F6E1AE09B;
	Thu, 20 Jun 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G3SykGCn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84917554A;
	Thu, 20 Jun 2024 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893036; cv=none; b=aTzLzwdeTIZmawNYnCIC0KwlFkIJk5XgU6k6sm5kFU8hJUcnqxlJL5lb8OQXhoKuAL71Zp92ybYhAllm6yr/tjPZsj55p54BgraiuKXbO/IlyuM1NONEQAdc6V0jLp1emorF5rAvIYMl48vsgQqdmXsv24LgzyhgBhPxYHrjApA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893036; c=relaxed/simple;
	bh=5m+tafdMaBvin1wJINeCnSEppqOYjt5wBv2oOLycUak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iHPWEty/9q/eDBS2agouanjaWdCCFd990OuLGlt2cfBj4LHQ6u3a0hmmdUh7K58XvJbtd1gl7Mh7ZbjPz3TjR7wWofvTTAFfxH7HpWuqLYF5LX1s7dSWRHM5YJr+y1rTg/ebjQHw/8ZpXEzae2pCrdRinTXOI0trSEiJ3lXfxOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G3SykGCn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KDufso008232;
	Thu, 20 Jun 2024 14:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=sKVi360H4+JzR
	HGS53qsuhs4zv2uF27pujXLHQKxS9Y=; b=G3SykGCnSGN4AM1XwXqLlR1MK9qJy
	ixfdYoygTnn64xg+XkwUqKPhvI15s0wA916USN1NDtqEoOJU0IQCAQ7ealY/5nUH
	4vyD82ynkhXWerKCf0cnn6YOQncJex/P1vd3DtFire1aWzoHmBid7YjR5d33Haet
	RwLEvfJQYSogRp6OPjDuL1fDKVHmavv/17zl8HsG1gHb3mDWoQFHliSh+KMF50mO
	YkXSmTWtrf+jUzCQk6YlfsI8+oqNTrnCa/9DDdOGxEz9FUxoiAHEm5GEUWGuA+2Z
	xaJh5EVF0MHMipF1TtubEi28hVOOMl4VmmgiLmnGnYG1ErEKoWOndk3hQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndu83nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:11 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEHAwl013494;
	Thu, 20 Jun 2024 14:17:10 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndu83nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KE38dw023897;
	Thu, 20 Jun 2024 14:17:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ysp9qpv2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH36J26149378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9824820040;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B8DC2004F;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 4/7] s390x: Add function for checking diagnose intercepts
Date: Thu, 20 Jun 2024 16:16:57 +0200
Message-Id: <20240620141700.4124157-5-nsg@linux.ibm.com>
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
X-Proofpoint-GUID: _VfbhLlqZ5DvPkWe89Pax-t64bEiZXew
X-Proofpoint-ORIG-GUID: e5RNXUZrsgLXju1pWb16Y-ne1RPYAoAc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200099

sie_is_diag_icpt() checks if the intercept is due to an expected
diagnose call and is valid.
It subsumes pv_icptdata_check_diag.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/pv_icptdata.h | 42 --------------------------------
 lib/s390x/sie.h         | 12 ++++++++++
 lib/s390x/sie.c         | 53 +++++++++++++++++++++++++++++++++++++++++
 s390x/pv-diags.c        |  8 +++----
 s390x/pv-icptcode.c     | 11 ++++-----
 s390x/pv-ipl.c          |  7 +++---
 6 files changed, 76 insertions(+), 57 deletions(-)
 delete mode 100644 lib/s390x/pv_icptdata.h

diff --git a/lib/s390x/pv_icptdata.h b/lib/s390x/pv_icptdata.h
deleted file mode 100644
index 4746117e..00000000
--- a/lib/s390x/pv_icptdata.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Commonly used checks for PV SIE intercept data
- *
- * Copyright IBM Corp. 2023
- * Author: Janosch Frank <frankja@linux.ibm.com>
- */
-
-#ifndef _S390X_PV_ICPTDATA_H_
-#define _S390X_PV_ICPTDATA_H_
-
-#include <sie.h>
-
-/*
- * Checks the diagnose instruction intercept data for consistency with
- * the constants defined by the PV SIE architecture
- *
- * Supports: 0x44, 0x9c, 0x288, 0x308, 0x500
- */
-static bool pv_icptdata_check_diag(struct vm *vm, int diag)
-{
-	int icptcode;
-
-	switch (diag) {
-	case 0x44:
-	case 0x9c:
-	case 0x288:
-	case 0x308:
-		icptcode = ICPT_PV_NOTIFY;
-		break;
-	case 0x500:
-		icptcode = ICPT_PV_INSTR;
-		break;
-	default:
-		/* If a new diag is introduced add it to the cases above! */
-		assert(0);
-	}
-
-	return vm->sblk->icptcode == icptcode && vm->sblk->ipa == 0x8302 &&
-	       vm->sblk->ipb == 0x50000000 && vm->save_area.guest.grs[5] == diag;
-}
-#endif
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 53cd767f..6d1a0d6e 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -287,6 +287,18 @@ static inline bool sie_is_pv(struct vm *vm)
 	return vm->sblk->sdf == 2;
 }
 
+/**
+ * sie_is_diag_icpt() - Check if intercept is due to diagnose instruction
+ * @vm: the guest
+ * @diag: the expected diagnose code
+ *
+ * Check that the intercept is due to diagnose @diag and valid.
+ * For protected virtualisation, check that the intercept data meets additional
+ * constraints.
+ *
+ * Returns: true if intercept is due to a valid and has matching diagnose code
+ */
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag);
 void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 0fa915cf..d4ba2a40 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -42,6 +42,59 @@ void sie_check_validity(struct vm *vm, uint16_t vir_exp)
 	report(vir_exp == vir, "VALIDITY: %x", vir);
 }
 
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
+{
+	union {
+		struct {
+			uint64_t     : 16;
+			uint64_t ipa : 16;
+			uint64_t ipb : 32;
+		};
+		struct {
+			uint64_t          : 16;
+			uint64_t opcode   :  8;
+			uint64_t r_1      :  4;
+			uint64_t r_2      :  4;
+			uint64_t r_base   :  4;
+			uint64_t displace : 12;
+			uint64_t zero     : 16;
+		};
+	} instr = { .ipa = vm->sblk->ipa, .ipb = vm->sblk->ipb };
+	uint8_t icptcode;
+	uint64_t code;
+
+	switch (diag) {
+	case 0x44:
+	case 0x9c:
+	case 0x288:
+	case 0x308:
+		icptcode = ICPT_PV_NOTIFY;
+		break;
+	case 0x500:
+		icptcode = ICPT_PV_INSTR;
+		break;
+	default:
+		/* If a new diag is introduced add it to the cases above! */
+		assert_msg(false, "unknown diag");
+	}
+
+	if (sie_is_pv(vm)) {
+		if (instr.r_1 != 0 || instr.r_2 != 2 || instr.r_base != 5)
+			return false;
+		if (instr.displace)
+			return false;
+	} else {
+		icptcode = ICPT_INST;
+	}
+	if (vm->sblk->icptcode != icptcode)
+		return false;
+	if (instr.opcode != 0x83 || instr.zero)
+		return false;
+	code = instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
+	code = (code + instr.displace) & 0xffff;
+	return code == diag;
+}
+
 void sie_handle_validity(struct vm *vm)
 {
 	if (vm->sblk->icptcode != ICPT_VALIDITY)
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 3193ad99..6ebe469a 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -9,7 +9,6 @@
  */
 #include <libcflat.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
 #include <sie.h>
 #include <sclp.h>
 #include <asm/facility.h>
@@ -32,8 +31,7 @@ static void test_diag_500(void)
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x500),
-	       "intercept values");
+	report(sie_is_diag_icpt(&vm, 0x500), "intercept values");
 	report(vm.save_area.guest.grs[1] == 1 &&
 	       vm.save_area.guest.grs[2] == 2 &&
 	       vm.save_area.guest.grs[3] == 3 &&
@@ -45,7 +43,7 @@ static void test_diag_500(void)
 	 */
 	vm.sblk->iictl = IICTL_CODE_OPERAND;
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
 	       "operand exception");
 
@@ -57,7 +55,7 @@ static void test_diag_500(void)
 	vm.sblk->iictl = IICTL_CODE_SPECIFICATION;
 	/* Inject PGM, next exit should be 9c */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
 	       "specification exception");
 
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
index d7c47d6f..bc90df1e 100644
--- a/s390x/pv-icptcode.c
+++ b/s390x/pv-icptcode.c
@@ -13,7 +13,6 @@
 #include <smp.h>
 #include <sclp.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
 #include <asm/facility.h>
 #include <asm/barrier.h>
 #include <asm/sigp.h>
@@ -47,7 +46,7 @@ static void test_validity_timing(void)
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x44), "spt done");
+	report(sie_is_diag_icpt(&vm, 0x44), "spt done");
 	stck(&time_exit);
 	tmp = vm.sblk->cputm;
 	mb();
@@ -258,7 +257,7 @@ static void test_validity_asce(void)
 
 	/* Try if we can still do an entry with the correct asce */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x44), "re-entry with valid CR1");
+	report(sie_is_diag_icpt(&vm, 0x44), "re-entry with valid CR1");
 	uv_destroy_guest(&vm);
 	free_pages(pgd_new);
 	report_prefix_pop();
@@ -294,7 +293,7 @@ static void run_icpt_122_tests_prefix(unsigned long prefix)
 
 	sie(&vm);
 	/* Guest indicates that it has been setup via the diag 0x44 */
-	assert(pv_icptdata_check_diag(&vm, 0x44));
+	assert(sie_is_diag_icpt(&vm, 0x44));
 	/* If the pages have not been shared these writes will cause exceptions */
 	ptr = (uint32_t *)prefix;
 	WRITE_ONCE(ptr, 0);
@@ -328,7 +327,7 @@ static void test_icpt_112(void)
 
 	/* Setup of the guest's state for 0x0 prefix */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x44));
+	assert(sie_is_diag_icpt(&vm, 0x44));
 
 	/* Test on standard 0x0 prefix */
 	run_icpt_122_tests_prefix(0);
@@ -348,7 +347,7 @@ static void test_icpt_112(void)
 
 	/* Try a re-entry after everything has been imported again */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == 42,
 	       "re-entry successful");
 	report_prefix_pop();
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
index cc46e7f7..cd49bd95 100644
--- a/s390x/pv-ipl.c
+++ b/s390x/pv-ipl.c
@@ -11,7 +11,6 @@
 #include <sie.h>
 #include <sclp.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
 
@@ -35,7 +34,7 @@ static void test_diag_308(int subcode)
 
 	/* First exit is a diag 0x500 */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x500));
+	assert(sie_is_diag_icpt(&vm, 0x500));
 
 	/*
 	 * The snippet asked us for the subcode and we answer by
@@ -46,7 +45,7 @@ static void test_diag_308(int subcode)
 
 	/* Continue after diag 0x500, next icpt should be the 0x308 */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x308));
+	assert(sie_is_diag_icpt(&vm, 0x308));
 	assert(vm.save_area.guest.grs[2] == subcode);
 
 	/*
@@ -118,7 +117,7 @@ static void test_diag_308(int subcode)
 	 * see a diagnose 0x9c PV instruction notification.
 	 */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == 42,
 	       "continue after load");
 
-- 
2.44.0


