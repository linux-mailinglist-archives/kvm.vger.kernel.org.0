Return-Path: <kvm+bounces-29021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D07DB9A1124
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 900D62836EE
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FB52141C7;
	Wed, 16 Oct 2024 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nQ/ZCXqi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F4F18BC22;
	Wed, 16 Oct 2024 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101813; cv=none; b=akTUKwYFEQNL1DOaXlZTmBi52RoJOdkFoDfGlAMy8fbbVLbLjkn47FfgfvzZVo1BHSTCqEbzxnXw/ZQ98YEG3jMA8gMtjerqy9c+PcGVMdWRt1J79uYgF2BiLQnwoU9GbWY0o02OyIxTfYiB+8Gv6pJXG08B2U8oDrD9eVqBAP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101813; c=relaxed/simple;
	bh=m3AO7aBK4MWTSz1LWFdO8AS1RY4l05ArBvO08Bco/2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGD+Rg7zi0E7GFKWn+dIC+gnBxZ8lhonVONVVRlynw6zTtmwyHdgzGC4ylJ3qxui/ymZsQRLm8u5NsQ4itTrMavlODeZS45AN4VS5+Dpsa5KLOVUux0oh2yiBgahGYbKpId+gj6JYGNiLUCtJ1odELjPcLC6VJ//Q/9ItBG8RrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nQ/ZCXqi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GHULf8022054;
	Wed, 16 Oct 2024 18:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mPUHICf5szgYoJCN9
	IfaDhAMJAmT40dXC0dlmKhWqcE=; b=nQ/ZCXqijEUbGC2pGnQJCs1KWuWONrsvC
	lytAzLkK7sAN//IFPeoV+o2oW0jVW12ANJvJDhc3HwnKL8YLSjdDOqIgCMiomNZE
	3fl8BQk0fLaPDWhzaKLiSCZeJHtV0Us0BCEbDWby4RoNb+ODq0JRDQx4eDuzRm2r
	jyRT6ln42Mamoqhe8fllA0ti1jq8oHcEUuOrjs9RwfO8G2b18Y/q8cIeVsYZHAxG
	NTmNfG39amSE07CVsop2ejnwc0YnHKQBT/wnk34cErp6TFb3JcOvnDIiNQ7Gr/uV
	c7st5/9qLHLlz9IwN+wo/p+LpkVkv0e6vOWC/e50D9Puofs0M3/WA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ahxj04gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:30 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GI0fjS021962;
	Wed, 16 Oct 2024 18:03:29 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ahxj04gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GGlTWs027451;
	Wed, 16 Oct 2024 18:03:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txtv1d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GI3Ora52691242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 18:03:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9828420049;
	Wed, 16 Oct 2024 18:03:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 433762004B;
	Wed, 16 Oct 2024 18:03:24 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 18:03:24 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [kvm-unit-tests PATCH v4 3/6] s390x: Add function for checking diagnose intercepts
Date: Wed, 16 Oct 2024 20:03:14 +0200
Message-ID: <20241016180320.686132-4-nsg@linux.ibm.com>
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
X-Proofpoint-GUID: GWgE8EGwI2uyXPgT9l7zGkVocwpog-dn
X-Proofpoint-ORIG-GUID: x4tAdbaeVIiOk_kCDe3qQJGtixISKOVF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410160115

sie_is_diag_icpt() checks if the intercept is due to an expected
diagnose call and is valid.
It subsumes pv_icptdata_check_diag.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/Makefile          |  1 +
 lib/s390x/pv_icptdata.h | 42 -----------------------------
 lib/s390x/sie-icpt.h    | 39 +++++++++++++++++++++++++++
 lib/s390x/sie-icpt.c    | 60 +++++++++++++++++++++++++++++++++++++++++
 s390x/pv-diags.c        |  9 +++----
 s390x/pv-icptcode.c     | 12 ++++-----
 s390x/pv-ipl.c          |  8 +++---
 7 files changed, 114 insertions(+), 57 deletions(-)
 delete mode 100644 lib/s390x/pv_icptdata.h
 create mode 100644 lib/s390x/sie-icpt.h
 create mode 100644 lib/s390x/sie-icpt.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd6..0ad8d021 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -111,6 +111,7 @@ cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
+cflatobjs += lib/s390x/sie-icpt.o
 cflatobjs += lib/s390x/fault.o
 
 OBJDIRS += lib/s390x
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
diff --git a/lib/s390x/sie-icpt.h b/lib/s390x/sie-icpt.h
new file mode 100644
index 00000000..604a7221
--- /dev/null
+++ b/lib/s390x/sie-icpt.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Functionality for SIE interception handling.
+ *
+ * Copyright IBM Corp. 2024
+ */
+
+#ifndef _S390X_SIE_ICPT_H_
+#define _S390X_SIE_ICPT_H_
+
+#include <libcflat.h>
+#include <sie.h>
+
+struct diag_itext {
+	uint64_t opcode   :  8;
+	uint64_t r_1      :  4;
+	uint64_t r_2      :  4;
+	uint64_t r_base   :  4;
+	uint64_t displace : 12;
+	uint64_t zero     : 16;
+	uint64_t          : 16;
+};
+
+struct diag_itext sblk_ip_as_diag(struct kvm_s390_sie_block *sblk);
+
+/**
+ * sie_is_diag_icpt() - Check if intercept is due to diagnose instruction
+ * @vm: the guest
+ * @diag: the expected diagnose code
+ *
+ * Check that the intercept is due to diagnose @diag and valid.
+ * For protected virtualization, check that the intercept data meets additional
+ * constraints.
+ *
+ * Returns: true if intercept is due to a valid and has matching diagnose code
+ */
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag);
+
+#endif /* _S390X_SIE_ICPT_H_ */
diff --git a/lib/s390x/sie-icpt.c b/lib/s390x/sie-icpt.c
new file mode 100644
index 00000000..17064424
--- /dev/null
+++ b/lib/s390x/sie-icpt.c
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Functionality for SIE interception handling.
+ *
+ * Copyright IBM Corp. 2024
+ */
+
+#include <sie-icpt.h>
+
+struct diag_itext sblk_ip_as_diag(struct kvm_s390_sie_block *sblk)
+{
+	union {
+		struct {
+			uint64_t ipa : 16;
+			uint64_t ipb : 32;
+			uint64_t     : 16;
+		};
+		struct diag_itext diag;
+	} instr = { .ipa = sblk->ipa, .ipb = sblk->ipb };
+
+	return instr.diag;
+}
+
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
+{
+	struct diag_itext instr = sblk_ip_as_diag(vm->sblk);
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
+		assert_msg(false, "unknown diag 0x%x", diag);
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
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 3193ad99..09b83d59 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -9,7 +9,7 @@
  */
 #include <libcflat.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
+#include <sie-icpt.h>
 #include <sie.h>
 #include <sclp.h>
 #include <asm/facility.h>
@@ -32,8 +32,7 @@ static void test_diag_500(void)
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x500),
-	       "intercept values");
+	report(sie_is_diag_icpt(&vm, 0x500), "intercept values");
 	report(vm.save_area.guest.grs[1] == 1 &&
 	       vm.save_area.guest.grs[2] == 2 &&
 	       vm.save_area.guest.grs[3] == 3 &&
@@ -45,7 +44,7 @@ static void test_diag_500(void)
 	 */
 	vm.sblk->iictl = IICTL_CODE_OPERAND;
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
 	       "operand exception");
 
@@ -57,7 +56,7 @@ static void test_diag_500(void)
 	vm.sblk->iictl = IICTL_CODE_SPECIFICATION;
 	/* Inject PGM, next exit should be 9c */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
 	       "specification exception");
 
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
index d7c47d6f..5293306b 100644
--- a/s390x/pv-icptcode.c
+++ b/s390x/pv-icptcode.c
@@ -13,7 +13,7 @@
 #include <smp.h>
 #include <sclp.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
+#include <sie-icpt.h>
 #include <asm/facility.h>
 #include <asm/barrier.h>
 #include <asm/sigp.h>
@@ -47,7 +47,7 @@ static void test_validity_timing(void)
 			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
 
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x44), "spt done");
+	report(sie_is_diag_icpt(&vm, 0x44), "spt done");
 	stck(&time_exit);
 	tmp = vm.sblk->cputm;
 	mb();
@@ -258,7 +258,7 @@ static void test_validity_asce(void)
 
 	/* Try if we can still do an entry with the correct asce */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x44), "re-entry with valid CR1");
+	report(sie_is_diag_icpt(&vm, 0x44), "re-entry with valid CR1");
 	uv_destroy_guest(&vm);
 	free_pages(pgd_new);
 	report_prefix_pop();
@@ -294,7 +294,7 @@ static void run_icpt_122_tests_prefix(unsigned long prefix)
 
 	sie(&vm);
 	/* Guest indicates that it has been setup via the diag 0x44 */
-	assert(pv_icptdata_check_diag(&vm, 0x44));
+	assert(sie_is_diag_icpt(&vm, 0x44));
 	/* If the pages have not been shared these writes will cause exceptions */
 	ptr = (uint32_t *)prefix;
 	WRITE_ONCE(ptr, 0);
@@ -328,7 +328,7 @@ static void test_icpt_112(void)
 
 	/* Setup of the guest's state for 0x0 prefix */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x44));
+	assert(sie_is_diag_icpt(&vm, 0x44));
 
 	/* Test on standard 0x0 prefix */
 	run_icpt_122_tests_prefix(0);
@@ -348,7 +348,7 @@ static void test_icpt_112(void)
 
 	/* Try a re-entry after everything has been imported again */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == 42,
 	       "re-entry successful");
 	report_prefix_pop();
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
index cc46e7f7..61a1e0c0 100644
--- a/s390x/pv-ipl.c
+++ b/s390x/pv-ipl.c
@@ -11,7 +11,7 @@
 #include <sie.h>
 #include <sclp.h>
 #include <snippet.h>
-#include <pv_icptdata.h>
+#include <sie-icpt.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
 
@@ -35,7 +35,7 @@ static void test_diag_308(int subcode)
 
 	/* First exit is a diag 0x500 */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x500));
+	assert(sie_is_diag_icpt(&vm, 0x500));
 
 	/*
 	 * The snippet asked us for the subcode and we answer by
@@ -46,7 +46,7 @@ static void test_diag_308(int subcode)
 
 	/* Continue after diag 0x500, next icpt should be the 0x308 */
 	sie(&vm);
-	assert(pv_icptdata_check_diag(&vm, 0x308));
+	assert(sie_is_diag_icpt(&vm, 0x308));
 	assert(vm.save_area.guest.grs[2] == subcode);
 
 	/*
@@ -118,7 +118,7 @@ static void test_diag_308(int subcode)
 	 * see a diagnose 0x9c PV instruction notification.
 	 */
 	sie(&vm);
-	report(pv_icptdata_check_diag(&vm, 0x9c) &&
+	report(sie_is_diag_icpt(&vm, 0x9c) &&
 	       vm.save_area.guest.grs[0] == 42,
 	       "continue after load");
 
-- 
2.44.0


