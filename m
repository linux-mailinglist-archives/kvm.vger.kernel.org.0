Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA52553485
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351676AbiFUOb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351671AbiFUOad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:30:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8123F24087;
        Tue, 21 Jun 2022 07:30:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEEThf010204;
        Tue, 21 Jun 2022 14:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=j5XBem0TU0hDKy2Rw7lj3Wy70cC5mEcF8PTvzkN+NBs=;
 b=ciz73FOuKniUR2FJ7/9o+yltX710MCkLOuIflZ0VmGxsAXaSHaGZQuAoNVjfHPTMNv+N
 EOqELZnyAQjbqGGiUkK8EUSXHtKssw5Oq6ZkHwTkm4hmaCGf4embR4Tz1kB5+eujFBxv
 dOouc/bBl29VeYIFDkKy/zp9q21XVMPthO1TRD1LUrooX5v9r+ijbFyfSnVYVKxr9GKx
 GavAXbLCd5lUTzpHYF/z6OfYREs/QxtlCFGpSItzNDKIE9IlXbP5+kRt1oRdiBlXr2lk
 izsSaesUucq0QhkxcfTvIUJX+RWZ4hANc/8mJ6XcbuO0lVYLo62DmcYzhpN92JM2iLng Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrhby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:29 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEGILw021063;
        Tue, 21 Jun 2022 14:30:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrh85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LEKntb029882;
        Tue, 21 Jun 2022 14:30:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3gs6b939c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LEUIiR13697534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 14:30:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A01534C046;
        Tue, 21 Jun 2022 14:30:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C3454C050;
        Tue, 21 Jun 2022 14:30:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 14:30:18 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 3/3] s390x: Rework TEID decoding and usage
Date:   Tue, 21 Jun 2022 16:30:15 +0200
Message-Id: <20220621143015.748290-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220621143015.748290-1-scgl@linux.ibm.com>
References: <20220621143015.748290-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Aj0-T7CJsgaDf2AMzcZ1hyRn6YrjovXo
X-Proofpoint-ORIG-GUID: Cl2Vm9tZ8gzloOZeYlcuC2uI6aTh0I6-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_06,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The translation-exception identification (TEID) contains information to
identify the cause of certain program exceptions, including translation
exceptions occurring during dynamic address translation, as well as
protection exceptions.
The meaning of fields in the TEID is complex, depending on the exception
occurring and various potentially installed facilities.

Rework the type describing the TEID, in order to ease decoding.
Change the existing code interpreting the TEID and extend it to take the
installed suppression-on-protection facility into account.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 62 ++++++++++++++++++++++++++++++---------
 lib/s390x/fault.h         | 30 +++++--------------
 lib/s390x/fault.c         | 58 +++++++++++++++++++++++-------------
 lib/s390x/interrupt.c     |  2 +-
 s390x/edat.c              | 25 +++++++++-------
 5 files changed, 108 insertions(+), 69 deletions(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index d9ab0bd7..fc66a925 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -20,23 +20,57 @@
 
 union teid {
 	unsigned long val;
-	struct {
-		unsigned long addr:52;
-		unsigned long fetch:1;
-		unsigned long store:1;
-		unsigned long reserved:6;
-		unsigned long acc_list_prot:1;
-		/*
-		 * depending on the exception and the installed facilities,
-		 * the m field can indicate several different things,
-		 * including whether the exception was triggered by a MVPG
-		 * instruction, or whether the addr field is meaningful
-		 */
-		unsigned long m:1;
-		unsigned long asce_id:2;
+	union {
+		/* common fields DAT exc & protection exc */
+		struct {
+			uint64_t addr			: 52 -  0;
+			uint64_t acc_exc_fetch_store	: 54 - 52;
+			uint64_t side_effect_acc	: 55 - 54;
+			uint64_t /* reserved */		: 62 - 55;
+			uint64_t asce_id		: 64 - 62;
+		};
+		/* DAT exc */
+		struct {
+			uint64_t /* pad */		: 61 -  0;
+			uint64_t dat_move_page		: 62 - 61;
+		};
+		/* suppression on protection */
+		struct {
+			uint64_t /* pad */		: 60 -  0;
+			uint64_t sop_acc_list		: 61 - 60;
+			uint64_t sop_teid_predictable	: 62 - 61;
+		};
+		/* enhanced suppression on protection 2 */
+		struct {
+			uint64_t /* pad */		: 56 -  0;
+			uint64_t esop2_prot_code_0	: 57 - 56;
+			uint64_t /* pad */		: 60 - 57;
+			uint64_t esop2_prot_code_1	: 61 - 60;
+			uint64_t esop2_prot_code_2	: 62 - 61;
+		};
 	};
 };
 
+enum prot_code {
+	PROT_KEY_OR_LAP,
+	PROT_DAT,
+	PROT_KEY,
+	PROT_ACC_LIST,
+	PROT_LAP,
+	PROT_IEP,
+	PROT_NUM_CODES /* Must always be last */
+};
+
+static inline enum prot_code teid_esop2_prot_code(union teid teid)
+{
+	int code = (teid.esop2_prot_code_0 << 2 |
+		    teid.esop2_prot_code_1 << 1 |
+		    teid.esop2_prot_code_2);
+
+	assert(code < PROT_NUM_CODES);
+	return (enum prot_code)code;
+}
+
 void register_pgm_cleanup_func(void (*f)(void));
 void handle_pgm_int(struct stack_frame_int *stack);
 void handle_ext_int(struct stack_frame_int *stack);
diff --git a/lib/s390x/fault.h b/lib/s390x/fault.h
index 726da2f0..867997f2 100644
--- a/lib/s390x/fault.h
+++ b/lib/s390x/fault.h
@@ -11,32 +11,16 @@
 #define _S390X_FAULT_H_
 
 #include <bitops.h>
+#include <asm/facility.h>
+#include <asm/interrupt.h>
 
 /* Instruction execution prevention, i.e. no-execute, 101 */
-static inline bool prot_is_iep(uint64_t teid)
+static inline bool prot_is_iep(union teid teid)
 {
-	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
-		return true;
-
-	return false;
-}
-
-/* Standard DAT exception, 001 */
-static inline bool prot_is_datp(uint64_t teid)
-{
-	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
-		return true;
-
-	return false;
-}
-
-/* Low-address protection exception, 100 */
-static inline bool prot_is_lap(uint64_t teid)
-{
-	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid))
-		return true;
-
-	return false;
+	if (!test_facility(130))
+		return false;
+	/* IEP installed -> ESOP2 installed */
+	return teid_esop2_prot_code(teid) == PROT_IEP;
 }
 
 void print_decode_teid(uint64_t teid);
diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
index efa62fcb..1cd6e265 100644
--- a/lib/s390x/fault.c
+++ b/lib/s390x/fault.c
@@ -13,35 +13,51 @@
 #include <asm/page.h>
 #include <fault.h>
 
-/* Decodes the protection exceptions we'll most likely see */
-static void print_decode_pgm_prot(uint64_t teid)
-{
-	if (prot_is_lap(teid)) {
-		printf("Type: LAP\n");
-		return;
-	}
 
-	if (prot_is_iep(teid)) {
-		printf("Type: IEP\n");
-		return;
-	}
+static void print_decode_pgm_prot(union teid teid)
+{
+	switch (get_supp_on_prot_facility()) {
+	case SOP_NONE:
+	case SOP_BASIC:
+		printf("Type: ?\n"); /* modern/relevant machines have ESOP */
+		break;
+	case SOP_ENHANCED_1:
+		if (teid.sop_teid_predictable) {/* implies access list or DAT */
+			if (teid.sop_acc_list)
+				printf("Type: ACC\n");
+			else
+				printf("Type: DAT\n");
+		} else {
+			printf("Type: KEY or LAP\n");
+		}
+		break;
+	case SOP_ENHANCED_2: {
+		static const char * const prot_str[] = {
+			"KEY or LAP",
+			"DAT",
+			"KEY",
+			"ACC",
+			"LAP",
+			"IEP",
+		};
+		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
+		int prot_code = teid_esop2_prot_code(teid);
 
-	if (prot_is_datp(teid)) {
-		printf("Type: DAT\n");
-		return;
+		printf("Type: %s\n", prot_str[prot_code]);
+		}
 	}
 }
 
-void print_decode_teid(uint64_t teid)
+void print_decode_teid(uint64_t raw_teid)
 {
-	int asce_id = teid & 3;
+	union teid teid = { .val = raw_teid };
 	bool dat = lowcore.pgm_old_psw.mask & PSW_MASK_DAT;
 
 	printf("Memory exception information:\n");
 	printf("DAT: %s\n", dat ? "on" : "off");
 
 	printf("AS: ");
-	switch (asce_id) {
+	switch (teid.asce_id) {
 	case AS_PRIM:
 		printf("Primary\n");
 		break;
@@ -65,10 +81,10 @@ void print_decode_teid(uint64_t teid)
 	 */
 	if ((lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
 	     lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
-	    !test_bit_inv(61, &teid)) {
-		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
+	    !teid.sop_teid_predictable) {
+		printf("Address: %lx, unpredictable\n ", raw_teid & PAGE_MASK);
 		return;
 	}
-	printf("TEID: %lx\n", teid);
-	printf("Address: %lx\n\n", teid & PAGE_MASK);
+	printf("TEID: %lx\n", raw_teid);
+	printf("Address: %lx\n\n", raw_teid & PAGE_MASK);
 }
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 6da20c44..ac3d1ecd 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -77,7 +77,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 		break;
 	case PGM_INT_CODE_PROTECTION:
 		/* Handling for iep.c test case. */
-		if (prot_is_iep(lowcore.trans_exc_id))
+		if (prot_is_iep((union teid) { .val = lowcore.trans_exc_id }))
 			/*
 			 * We branched to the instruction that caused
 			 * the exception so we can use the return
diff --git a/s390x/edat.c b/s390x/edat.c
index c6c25042..16138397 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -26,8 +26,8 @@ static void *root, *mem, *m;
 volatile unsigned int *p;
 
 /*
- * Check if a non-access-list protection exception happened for the given
- * address, in the primary address space.
+ * Check if the exception is consistent with DAT protection and has the correct
+ * address and primary address space.
  */
 static bool check_pgm_prot(void *ptr)
 {
@@ -37,14 +37,19 @@ static bool check_pgm_prot(void *ptr)
 		return false;
 
 	teid.val = lowcore.trans_exc_id;
-
-	/*
-	 * depending on the presence of the ESOP feature, the rest of the
-	 * field might or might not be meaningful when the m field is 0.
-	 */
-	if (!teid.m)
-		return true;
-	return (!teid.acc_list_prot && !teid.asce_id &&
+	switch (get_supp_on_prot_facility()) {
+	case SOP_NONE:
+	case SOP_BASIC:
+		assert(false); /* let's ignore ancient/irrelevant machines */
+	case SOP_ENHANCED_1:
+		if (!teid.sop_teid_predictable) /* implies key or low addr */
+			return false;
+		break;
+	case SOP_ENHANCED_2:
+		if (teid_esop2_prot_code(teid) != PROT_DAT)
+			return false;
+	}
+	return (!teid.sop_acc_list && !teid.asce_id &&
 		(teid.addr == ((unsigned long)ptr >> PAGE_SHIFT)));
 }
 
-- 
2.36.1

