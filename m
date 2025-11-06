Return-Path: <kvm+bounces-62205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 792F1C3C63E
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E09ED50573E
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2FF357707;
	Thu,  6 Nov 2025 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Df47OZgl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDA5354AFA;
	Thu,  6 Nov 2025 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445500; cv=none; b=IoH7HY7eL5gN/MkEKMxd976kcOuXb+RS96YQlwDGWiR8PAI5oU5crfIZdkqAKcu2QQhDLjm7CorN0wRqEfswkXMuxgNiLmnZZdU0yu2dwn3JFXnpwaL7FuopPmNyyMc/4T1EDQ8/SFBLNJASnARogVV2y1mLyIvamYO+phlOP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445500; c=relaxed/simple;
	bh=HjT6PSv82yZ5RlmPmkhwGmwqkdnJAlfi9L5XtZkTVFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8B2rSyuzEn/jTRn9KFT/imlUctgt5ynhdcfAg066DOhmNNrMUzScEw9+5LIvRbhJoP1fo653OCAm30/Om4kFtAOIYQQY4gWhsqQinyM/5Fczuu1y5YoU4BEw5pBh+BURKR0uXRDOUhfO0pCfLmuJn02zA8I0KPMmimyzVZs7XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Df47OZgl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6AbbKX032170;
	Thu, 6 Nov 2025 16:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=B+Alml57ko8NSyv5T
	Ob5jZj+8RHLLqivaER2V0L4FMg=; b=Df47OZglJXB0wDWToCbQ6+dWR4XBagaTc
	C8zUb86YcG79g5/+Rlj993PgSD2cP8ob/ZLHxNc3vSuAse5eGjO/P9OB9eIaGgxr
	nL7kDLE0XdPU6pKrgr2Umi0sxmPjv/Z7B/FyqvFR2xzhKhjTPTRI+xPj0r1WvdI5
	zDtnmphee8787kyVvf8l+2qo5JFsVnblqlJQuXQgl/yUsZ32JIGNsENEdQvtgpKb
	dTKCMdwvIgY5R3wEOQqEQ4Dgjqi+e3sicynDU/Zo47SkAaNx3mkqI+y5oSWdw7IV
	T6ao8pACuvTNiVNeeRZK51D8/SQm/+CmnKLuOjtBdCSQRwpMXL8og==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a58mm79m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6ECLqB025582;
	Thu, 6 Nov 2025 16:11:33 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5vhsxhbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBTHc60424680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 615A120043;
	Thu,  6 Nov 2025 16:11:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0DAB2004B;
	Thu,  6 Nov 2025 16:11:28 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 23/23] KVM: s390: Fix storage key memop IOCTLs
Date: Thu,  6 Nov 2025 17:11:17 +0100
Message-ID: <20251106161117.350395-24-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106161117.350395-1-imbrenda@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0OwBMBG78y-kH5B89KxFPWjnU-BxdbXW
X-Proofpoint-GUID: 0OwBMBG78y-kH5B89KxFPWjnU-BxdbXW
X-Authority-Analysis: v=2.4 cv=SqidKfO0 c=1 sm=1 tr=0 ts=690cc8b6 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=QaLLgIs-QyH7cEw5VHcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwOSBTYWx0ZWRfX25JT1pqcLawW
 3n6sfrWNj4ihPL9nwEcO3B0ujFC8TsUtoFip7YPeaZ6swYArPA+ae1b9wv0T+4Ef/apRKmm2vKn
 LqVj8ZkOrit2uwc6CEcD8/pFGmNqG63z3zpidWvxEuyexNLzH29oEb0qq6RhuWlURXE6YEJ2rUx
 EDzpgV+0x/JgTctnHhN7erH1xHzX07MvO8lLLefC0RpYDsB51Ig9/eo6/4txPQ0GBgC21tTiQ5T
 J4dnvy/EODZ1jVeVxUx/niNqNejh8KimaBhR5jL0Q8v2aNRufT5yyFL39BNX+8DXqVEZSnFmVuf
 yx8wWrVwyzqQJNAhwyzpOYgt0Zb92vCqbddNtGCp+mk+et81LG4cB+n/kUp4jU0FKlrsHy9thRg
 MHzRtIzzX4LHvTPuJG1x5/c0M1unJA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010009

Storage key memop IOCTLs accessed guest memory through the userspace
mapping, relying on the fact that PGSTEs would get synchronized
automatically.

With the new gmap code, the userspace mapping does not have the PGSTEs
anymore. Using the userspace mapping yields a potentially outdated view
of the storage keys used for guest memory.

Rewrite both cmpxchg and guest read/write backends to go through the
guest mapping (gmap); this guarantees that the storage keys of guest
memory will be in the correct state.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uaccess.h |  70 +------
 arch/s390/kvm/gaccess.c         | 312 +++++++++++++++++++++-----------
 arch/s390/kvm/gaccess.h         |   4 +-
 arch/s390/kvm/kvm-s390.c        |  97 +++-------
 arch/s390/kvm/kvm-s390.h        |   8 +
 arch/s390/lib/uaccess.c         | 184 +++----------------
 6 files changed, 279 insertions(+), 396 deletions(-)

diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index 3e5b8b677057..6380e03cfb62 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -471,65 +471,15 @@ do {									\
 #define __get_kernel_nofault __mvc_kernel_nofault
 #define __put_kernel_nofault __mvc_kernel_nofault
 
-void __cmpxchg_user_key_called_with_bad_pointer(void);
-
-int __cmpxchg_user_key1(unsigned long address, unsigned char *uval,
-			unsigned char old, unsigned char new, unsigned long key);
-int __cmpxchg_user_key2(unsigned long address, unsigned short *uval,
-			unsigned short old, unsigned short new, unsigned long key);
-int __cmpxchg_user_key4(unsigned long address, unsigned int *uval,
-			unsigned int old, unsigned int new, unsigned long key);
-int __cmpxchg_user_key8(unsigned long address, unsigned long *uval,
-			unsigned long old, unsigned long new, unsigned long key);
-int __cmpxchg_user_key16(unsigned long address, __uint128_t *uval,
-			 __uint128_t old, __uint128_t new, unsigned long key);
-
-static __always_inline int _cmpxchg_user_key(unsigned long address, void *uval,
-					     __uint128_t old, __uint128_t new,
-					     unsigned long key, int size)
-{
-	switch (size) {
-	case 1:  return __cmpxchg_user_key1(address, uval, old, new, key);
-	case 2:  return __cmpxchg_user_key2(address, uval, old, new, key);
-	case 4:  return __cmpxchg_user_key4(address, uval, old, new, key);
-	case 8:  return __cmpxchg_user_key8(address, uval, old, new, key);
-	case 16: return __cmpxchg_user_key16(address, uval, old, new, key);
-	default: __cmpxchg_user_key_called_with_bad_pointer();
-	}
-	return 0;
-}
-
-/**
- * cmpxchg_user_key() - cmpxchg with user space target, honoring storage keys
- * @ptr: User space address of value to compare to @old and exchange with
- *	 @new. Must be aligned to sizeof(*@ptr).
- * @uval: Address where the old value of *@ptr is written to.
- * @old: Old value. Compared to the content pointed to by @ptr in order to
- *	 determine if the exchange occurs. The old value read from *@ptr is
- *	 written to *@uval.
- * @new: New value to place at *@ptr.
- * @key: Access key to use for checking storage key protection.
- *
- * Perform a cmpxchg on a user space target, honoring storage key protection.
- * @key alone determines how key checking is performed, neither
- * storage-protection-override nor fetch-protection-override apply.
- * The caller must compare *@uval and @old to determine if values have been
- * exchanged. In case of an exception *@uval is set to zero.
- *
- * Return:     0: cmpxchg executed
- *	       -EFAULT: an exception happened when trying to access *@ptr
- *	       -EAGAIN: maxed out number of retries (byte and short only)
- */
-#define cmpxchg_user_key(ptr, uval, old, new, key)			\
-({									\
-	__typeof__(ptr) __ptr = (ptr);					\
-	__typeof__(uval) __uval = (uval);				\
-									\
-	BUILD_BUG_ON(sizeof(*(__ptr)) != sizeof(*(__uval)));		\
-	might_fault();							\
-	__chk_user_ptr(__ptr);						\
-	_cmpxchg_user_key((unsigned long)(__ptr), (void *)(__uval),	\
-			  (old), (new), (key), sizeof(*(__ptr)));	\
-})
+int __cmpxchg_key1(void *address, unsigned char *uval, unsigned char old,
+		   unsigned char new, unsigned long key);
+int __cmpxchg_key2(void *address, unsigned short *uval, unsigned short old,
+		   unsigned short new, unsigned long key);
+int __cmpxchg_key4(void *address, unsigned int *uval, unsigned int old,
+		   unsigned int new, unsigned long key);
+int __cmpxchg_key8(void *address, unsigned long *uval, unsigned long old,
+		   unsigned long new, unsigned long key);
+int __cmpxchg_key16(void *address, __uint128_t *uval, __uint128_t old,
+		    __uint128_t new, unsigned long key);
 
 #endif /* __S390_UACCESS_H */
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 85421a10a915..642164cbcd63 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -43,6 +43,28 @@ struct pgtwalk {
 	bool p;
 };
 
+union oac {
+	unsigned int val;
+	struct {
+		struct {
+			unsigned short key : 4;
+			unsigned short	   : 4;
+			unsigned short as  : 2;
+			unsigned short	   : 4;
+			unsigned short k   : 1;
+			unsigned short a   : 1;
+		} oac1;
+		struct {
+			unsigned short key : 4;
+			unsigned short	   : 4;
+			unsigned short as  : 2;
+			unsigned short	   : 4;
+			unsigned short k   : 1;
+			unsigned short a   : 1;
+		} oac2;
+	};
+};
+
 static inline struct guest_fault *get_entries(struct pgtwalk *w)
 {
 	return w->raw_entries - LEVEL_MEM;
@@ -824,37 +846,79 @@ static int access_guest_page_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa
 	return rc;
 }
 
+static int mvcos_key(void *to, const void *from, unsigned long size, u8 dst_key, u8 src_key)
+{
+	union oac spec = {
+		.oac1.key = dst_key,
+		.oac1.k = !!dst_key,
+		.oac2.key = src_key,
+		.oac2.k = !!src_key,
+	};
+	int exception = PGM_PROTECTION;
+
+	asm_inline volatile(
+		"	lr	%%r0,%[spec]\n"
+		"0:	mvcos	%[to],%[from],%[size]\n"
+		"1:	lhi     %[exc],0\n"
+		"2:\n"
+		EX_TABLE(0b, 2b)
+		EX_TABLE(1b, 2b)
+		: [size] "+d" (size), [to] "=Q" (*(char *)to), [exc] "+d" (exception)
+		: [spec] "d" (spec.val), [from] "Q" (*(const char *)from)
+		: "memory", "cc", "0");
+	return exception;
+}
+
+struct acc_page_key_context {
+	void *data;
+	int exception;
+	unsigned short offset;
+	unsigned short len;
+	bool store;
+	u8 access_key;
+};
+
+static void _access_guest_page_with_key_gpa(struct guest_fault *f)
+{
+	struct acc_page_key_context *context = f->priv;
+	void *ptr;
+	int r;
+
+	ptr = __va(PFN_PHYS(f->pfn) | context->offset);
+
+	if (context->store)
+		r = mvcos_key(ptr, context->data, context->len, context->access_key, 0);
+	else
+		r = mvcos_key(context->data, ptr, context->len, 0, context->access_key);
+
+	context->exception = r;
+}
+
 static int access_guest_page_with_key_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
-					  void *data, unsigned int len, u8 access_key)
+					  void *data, unsigned int len, u8 acc)
 {
-	struct kvm_memory_slot *slot;
-	bool writable;
-	gfn_t gfn;
-	hva_t hva;
+	struct acc_page_key_context context = {
+		.offset = offset_in_page(gpa),
+		.len = len,
+		.data = data,
+		.access_key = acc,
+		.store = mode == GACC_STORE,
+	};
+	struct guest_fault fault = {
+		.gfn = gpa_to_gfn(gpa),
+		.priv = &context,
+		.write_attempt = mode == GACC_STORE,
+		.callback = _access_guest_page_with_key_gpa,
+	};
 	int rc;
 
-	gfn = gpa_to_gfn(gpa);
-	slot = gfn_to_memslot(kvm, gfn);
-	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
+	if (KVM_BUG_ON((len + context.offset) > PAGE_SIZE, kvm))
+		return -EINVAL;
 
-	if (kvm_is_error_hva(hva))
-		return PGM_ADDRESSING;
-	/*
-	 * Check if it's a ro memslot, even tho that can't occur (they're unsupported).
-	 * Don't try to actually handle that case.
-	 */
-	if (!writable && mode == GACC_STORE)
-		return -EOPNOTSUPP;
-	hva += offset_in_page(gpa);
-	if (mode == GACC_STORE)
-		rc = copy_to_user_key((void __user *)hva, data, len, access_key);
-	else
-		rc = copy_from_user_key(data, (void __user *)hva, len, access_key);
+	rc = kvm_s390_faultin_gfn(NULL, kvm, &fault);
 	if (rc)
-		return PGM_PROTECTION;
-	if (mode == GACC_STORE)
-		mark_page_dirty_in_slot(kvm, slot, gfn);
-	return 0;
+		return rc;
+	return context.exception;
 }
 
 int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
@@ -977,18 +1041,101 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 	return rc;
 }
 
+/**
+ * __cmpxchg_with_key() - cmpxchg memory, honoring storage keys
+ * @ptr: Address of value to compare to *@old and exchange with
+ *       @new. Must be aligned to sizeof(*@ptr).
+ * @uval: Address where the old value of *@ptr is written to.
+ * @old: Old value. Compared to the content pointed to by @ptr in order to
+ *       determine if the exchange occurs. The old value read from *@ptr is
+ *       written to *@uval.
+ * @new: New value to place at *@ptr.
+ * @access_key: Access key to use for checking storage key protection.
+ *
+ * Perform a cmpxchg on guest memory, honoring storage key protection.
+ * @access_key alone determines how key checking is performed, neither
+ * storage-protection-override nor fetch-protection-override apply.
+ * In case of an exception *@uval is set to zero.
+ *
+ * Return:
+ * * 0: cmpxchg executed successfully
+ * * 1: cmpxchg executed unsuccessfully
+ * * PGM_PROTECTION: an exception happened when trying to access *@ptr
+ * * -EAGAIN: maxed out number of retries (byte and short only)
+ */
+static int __cmpxchg_with_key(union kvm_s390_quad *ptr, union kvm_s390_quad *old,
+			      union kvm_s390_quad new, int size, u8 access_key)
+{
+	union kvm_s390_quad tmp = { .sixteen = 0 };
+	int rc;
+
+	/*
+	 * The cmpxchg_key macro depends on the type of "old", so we need
+	 * a case for each valid length and get some code duplication as long
+	 * as we don't introduce a new macro.
+	 */
+	switch (size) {
+	case 1:
+		rc = __cmpxchg_key1(&ptr->one, &tmp.one, old->one, new.one, access_key);
+		break;
+	case 2:
+		rc = __cmpxchg_key2(&ptr->two, &tmp.two, old->two, new.two, access_key);
+		break;
+	case 4:
+		rc = __cmpxchg_key4(&ptr->four, &tmp.four, old->four, new.four, access_key);
+		break;
+	case 8:
+		rc = __cmpxchg_key8(&ptr->eight, &tmp.eight, old->eight, new.eight, access_key);
+		break;
+	case 16:
+		rc = __cmpxchg_key16(&ptr->sixteen, &tmp.sixteen, old->sixteen, new.sixteen,
+				     access_key);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (!rc && memcmp(&tmp, old, size))
+		rc = 1;
+	*old = tmp;
+	/*
+	 * Assume that the fault is caused by protection, either key protection
+	 * or user page write protection.
+	 */
+	if (rc == -EFAULT)
+		rc = PGM_PROTECTION;
+	return rc;
+}
+
+struct cmpxchg_key_context {
+	union kvm_s390_quad new;
+	union kvm_s390_quad *old;
+	int exception;
+	unsigned short offset;
+	u8 access_key;
+	u8 len;
+};
+
+static void _cmpxchg_guest_abs_with_key(struct guest_fault *f)
+{
+	struct cmpxchg_key_context *context = f->priv;
+
+	context->exception = __cmpxchg_with_key(__va(PFN_PHYS(f->pfn) | context->offset),
+						context->old, context->new, context->len,
+						context->access_key);
+}
+
 /**
  * cmpxchg_guest_abs_with_key() - Perform cmpxchg on guest absolute address.
  * @kvm: Virtual machine instance.
  * @gpa: Absolute guest address of the location to be changed.
  * @len: Operand length of the cmpxchg, required: 1 <= len <= 16. Providing a
  *       non power of two will result in failure.
- * @old_addr: Pointer to old value. If the location at @gpa contains this value,
- *            the exchange will succeed. After calling cmpxchg_guest_abs_with_key()
- *            *@old_addr contains the value at @gpa before the attempt to
- *            exchange the value.
+ * @old: Pointer to old value. If the location at @gpa contains this value,
+ *       the exchange will succeed. After calling cmpxchg_guest_abs_with_key()
+ *       *@old contains the value at @gpa before the attempt to
+ *       exchange the value.
  * @new: The value to place at @gpa.
- * @access_key: The access key to use for the guest access.
+ * @acc: The access key to use for the guest access.
  * @success: output value indicating if an exchange occurred.
  *
  * Atomically exchange the value at @gpa by @new, if it contains *@old.
@@ -1001,89 +1148,36 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  *         * -EAGAIN: transient failure (len 1 or 2)
  *         * -EOPNOTSUPP: read-only memslot (should never occur)
  */
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len,
-			       __uint128_t *old_addr, __uint128_t new,
-			       u8 access_key, bool *success)
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old,
+			       union kvm_s390_quad new, u8 acc, bool *success)
 {
-	gfn_t gfn = gpa_to_gfn(gpa);
-	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
-	bool writable;
-	hva_t hva;
-	int ret;
-
-	if (!IS_ALIGNED(gpa, len))
-		return -EINVAL;
-
-	hva = gfn_to_hva_memslot_prot(slot, gfn, &writable);
-	if (kvm_is_error_hva(hva))
-		return PGM_ADDRESSING;
-	/*
-	 * Check if it's a read-only memslot, even though that cannot occur
-	 * since those are unsupported.
-	 * Don't try to actually handle that case.
-	 */
-	if (!writable)
-		return -EOPNOTSUPP;
-
-	hva += offset_in_page(gpa);
-	/*
-	 * The cmpxchg_user_key macro depends on the type of "old", so we need
-	 * a case for each valid length and get some code duplication as long
-	 * as we don't introduce a new macro.
-	 */
-	switch (len) {
-	case 1: {
-		u8 old;
-
-		ret = cmpxchg_user_key((u8 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
-		break;
-	}
-	case 2: {
-		u16 old;
-
-		ret = cmpxchg_user_key((u16 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
-		break;
-	}
-	case 4: {
-		u32 old;
-
-		ret = cmpxchg_user_key((u32 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
-		break;
-	}
-	case 8: {
-		u64 old;
+	struct cmpxchg_key_context context = {
+		.old = old,
+		.new = new,
+		.offset = offset_in_page(gpa),
+		.len = len,
+		.access_key = acc,
+	};
+	struct guest_fault fault = {
+		.gfn = gpa_to_gfn(gpa),
+		.priv = &context,
+		.write_attempt = true,
+		.callback = _cmpxchg_guest_abs_with_key,
+	};
+	int rc;
 
-		ret = cmpxchg_user_key((u64 __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
-		break;
-	}
-	case 16: {
-		__uint128_t old;
+	lockdep_assert_held(&kvm->srcu);
 
-		ret = cmpxchg_user_key((__uint128_t __user *)hva, &old, *old_addr, new, access_key);
-		*success = !ret && old == *old_addr;
-		*old_addr = old;
-		break;
-	}
-	default:
+	if (len > 16 || !IS_ALIGNED(gpa, len))
 		return -EINVAL;
-	}
-	if (*success)
-		mark_page_dirty_in_slot(kvm, slot, gfn);
-	/*
-	 * Assume that the fault is caused by protection, either key protection
-	 * or user page write protection.
-	 */
-	if (ret == -EFAULT)
-		ret = PGM_PROTECTION;
-	return ret;
+
+	rc = kvm_s390_faultin_gfn(NULL, kvm, &fault);
+	if (rc)
+		return rc;
+	*success = !context.exception;
+	if (context.exception == 1)
+		return 0;
+	return context.exception;
 }
 
 /**
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index f30d3a07da5a..b5385cec60f4 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -206,8 +206,8 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode);
 
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, __uint128_t *old,
-			       __uint128_t new, u8 access_key, bool *success);
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old,
+			       union kvm_s390_quad new, u8 access_key, bool *success);
 
 /**
  * write_guest_with_key - copy data from kernel space to guest space
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1315cbcab1af..f42d6c40f50f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2743,9 +2743,9 @@ static int mem_op_validate_common(struct kvm_s390_mem_op *mop, u64 supported_fla
 static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	void *tmpbuf __free(kvfree) = NULL;
 	enum gacc_mode acc_mode;
-	void *tmpbuf = NULL;
-	int r, srcu_idx;
+	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_SKEY_PROTECTION |
 					KVM_S390_MEMOP_F_CHECK_ONLY);
@@ -2758,52 +2758,32 @@ static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 			return -ENOMEM;
 	}
 
-	srcu_idx = srcu_read_lock(&kvm->srcu);
+	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
 
-	if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr)) {
-		r = PGM_ADDRESSING;
-		goto out_unlock;
-	}
+	scoped_guard(srcu, &kvm->srcu) {
+		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)
+			return check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
 
-	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
-	if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-		r = check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
-		goto out_unlock;
-	}
-	if (acc_mode == GACC_FETCH) {
+		if (acc_mode == GACC_STORE && copy_from_user(tmpbuf, uaddr, mop->size))
+			return -EFAULT;
 		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-					      mop->size, GACC_FETCH, mop->key);
+					      mop->size, acc_mode, mop->key);
 		if (r)
-			goto out_unlock;
-		if (copy_to_user(uaddr, tmpbuf, mop->size))
-			r = -EFAULT;
-	} else {
-		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
-			r = -EFAULT;
-			goto out_unlock;
-		}
-		r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
-					      mop->size, GACC_STORE, mop->key);
+			return r;
+		if (acc_mode != GACC_STORE && copy_to_user(uaddr, tmpbuf, mop->size))
+			return -EFAULT;
 	}
-
-out_unlock:
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-
-	vfree(tmpbuf);
-	return r;
+	return 0;
 }
 
 static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void __user *old_addr = (void __user *)mop->old_addr;
-	union {
-		__uint128_t quad;
-		char raw[sizeof(__uint128_t)];
-	} old = { .quad = 0}, new = { .quad = 0 };
-	unsigned int off_in_quad = sizeof(new) - mop->size;
-	int r, srcu_idx;
+	union kvm_s390_quad old = { .sixteen = 0 };
+	union kvm_s390_quad new = { .sixteen = 0 };
 	bool success;
+	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_SKEY_PROTECTION);
 	if (r)
@@ -2815,25 +2795,19 @@ static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *m
 	 */
 	if (mop->size > sizeof(new))
 		return -EINVAL;
-	if (copy_from_user(&new.raw[off_in_quad], uaddr, mop->size))
+	if (copy_from_user(&new, uaddr, mop->size))
 		return -EFAULT;
-	if (copy_from_user(&old.raw[off_in_quad], old_addr, mop->size))
+	if (copy_from_user(&old, old_addr, mop->size))
 		return -EFAULT;
 
-	srcu_idx = srcu_read_lock(&kvm->srcu);
+	success = false;
+	scoped_guard(srcu, &kvm->srcu) {
+		r = cmpxchg_guest_abs_with_key(kvm, mop->gaddr, mop->size, &old, new,
+					       mop->key, &success);
 
-	if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr)) {
-		r = PGM_ADDRESSING;
-		goto out_unlock;
+		if (!success && copy_to_user(old_addr, &old, mop->size))
+			return -EFAULT;
 	}
-
-	r = cmpxchg_guest_abs_with_key(kvm, mop->gaddr, mop->size, &old.quad,
-				       new.quad, mop->key, &success);
-	if (!success && copy_to_user(old_addr, &old.raw[off_in_quad], mop->size))
-		r = -EFAULT;
-
-out_unlock:
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return r;
 }
 
@@ -5393,8 +5367,8 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
 				 struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	void *tmpbuf __free(kvfree) = NULL;
 	enum gacc_mode acc_mode;
-	void *tmpbuf = NULL;
 	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_INJECT_EXCEPTION |
@@ -5416,32 +5390,21 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
 	if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 		r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
 				    acc_mode, mop->key);
-		goto out_inject;
-	}
-	if (acc_mode == GACC_FETCH) {
+	} else if (acc_mode == GACC_FETCH) {
 		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
 					mop->size, mop->key);
-		if (r)
-			goto out_inject;
-		if (copy_to_user(uaddr, tmpbuf, mop->size)) {
-			r = -EFAULT;
-			goto out_free;
-		}
+		if (!r && copy_to_user(uaddr, tmpbuf, mop->size))
+			return -EFAULT;
 	} else {
-		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
-			r = -EFAULT;
-			goto out_free;
-		}
+		if (copy_from_user(tmpbuf, uaddr, mop->size))
+			return -EFAULT;
 		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
 					 mop->size, mop->key);
 	}
 
-out_inject:
 	if (r > 0 && (mop->flags & KVM_S390_MEMOP_F_INJECT_EXCEPTION) != 0)
 		kvm_s390_inject_prog_irq(vcpu, &vcpu->arch.pgm);
 
-out_free:
-	vfree(tmpbuf);
 	return r;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 0af9b27d9f18..8a979b1f1a7b 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -24,6 +24,14 @@
 
 #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
 
+union kvm_s390_quad {
+	__uint128_t sixteen;
+	unsigned long eight;
+	unsigned int four;
+	unsigned short two;
+	unsigned char one;
+};
+
 static inline void kvm_s390_fpu_store(struct kvm_run *run)
 {
 	fpu_stfpc(&run->s.regs.fpc);
diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 1a6ba105e071..0ac2f3998b14 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -34,136 +34,19 @@ void debug_user_asce(int exit)
 }
 #endif /*CONFIG_DEBUG_ENTRY */
 
-union oac {
-	unsigned int val;
-	struct {
-		struct {
-			unsigned short key : 4;
-			unsigned short	   : 4;
-			unsigned short as  : 2;
-			unsigned short	   : 4;
-			unsigned short k   : 1;
-			unsigned short a   : 1;
-		} oac1;
-		struct {
-			unsigned short key : 4;
-			unsigned short	   : 4;
-			unsigned short as  : 2;
-			unsigned short	   : 4;
-			unsigned short k   : 1;
-			unsigned short a   : 1;
-		} oac2;
-	};
-};
-
-static uaccess_kmsan_or_inline __must_check unsigned long
-raw_copy_from_user_key(void *to, const void __user *from, unsigned long size, unsigned long key)
-{
-	unsigned long osize;
-	union oac spec = {
-		.oac2.key = key,
-		.oac2.as = PSW_BITS_AS_SECONDARY,
-		.oac2.k = 1,
-		.oac2.a = 1,
-	};
-	int cc;
-
-	while (1) {
-		osize = size;
-		asm_inline volatile(
-			"	lr	%%r0,%[spec]\n"
-			"0:	mvcos	%[to],%[from],%[size]\n"
-			"1:	nopr	%%r7\n"
-			CC_IPM(cc)
-			EX_TABLE_UA_MVCOS_FROM(0b, 0b)
-			EX_TABLE_UA_MVCOS_FROM(1b, 0b)
-			: CC_OUT(cc, cc), [size] "+d" (size), [to] "=Q" (*(char *)to)
-			: [spec] "d" (spec.val), [from] "Q" (*(const char __user *)from)
-			: CC_CLOBBER_LIST("memory", "0"));
-		if (CC_TRANSFORM(cc) == 0)
-			return osize - size;
-		size -= 4096;
-		to += 4096;
-		from += 4096;
-	}
-}
-
-unsigned long _copy_from_user_key(void *to, const void __user *from,
-				  unsigned long n, unsigned long key)
-{
-	unsigned long res = n;
-
-	might_fault();
-	if (!should_fail_usercopy()) {
-		instrument_copy_from_user_before(to, from, n);
-		res = raw_copy_from_user_key(to, from, n, key);
-		instrument_copy_from_user_after(to, from, n, res);
-	}
-	if (unlikely(res))
-		memset(to + (n - res), 0, res);
-	return res;
-}
-EXPORT_SYMBOL(_copy_from_user_key);
-
-static uaccess_kmsan_or_inline __must_check unsigned long
-raw_copy_to_user_key(void __user *to, const void *from, unsigned long size, unsigned long key)
-{
-	unsigned long osize;
-	union oac spec = {
-		.oac1.key = key,
-		.oac1.as = PSW_BITS_AS_SECONDARY,
-		.oac1.k = 1,
-		.oac1.a = 1,
-	};
-	int cc;
-
-	while (1) {
-		osize = size;
-		asm_inline volatile(
-			"	lr	%%r0,%[spec]\n"
-			"0:	mvcos	%[to],%[from],%[size]\n"
-			"1:	nopr	%%r7\n"
-			CC_IPM(cc)
-			EX_TABLE_UA_MVCOS_TO(0b, 0b)
-			EX_TABLE_UA_MVCOS_TO(1b, 0b)
-			: CC_OUT(cc, cc), [size] "+d" (size), [to] "=Q" (*(char __user *)to)
-			: [spec] "d" (spec.val), [from] "Q" (*(const char *)from)
-			: CC_CLOBBER_LIST("memory", "0"));
-		if (CC_TRANSFORM(cc) == 0)
-			return osize - size;
-		size -= 4096;
-		to += 4096;
-		from += 4096;
-	}
-}
-
-unsigned long _copy_to_user_key(void __user *to, const void *from,
-				unsigned long n, unsigned long key)
-{
-	might_fault();
-	if (should_fail_usercopy())
-		return n;
-	instrument_copy_to_user(to, from, n);
-	return raw_copy_to_user_key(to, from, n, key);
-}
-EXPORT_SYMBOL(_copy_to_user_key);
-
 #define CMPXCHG_USER_KEY_MAX_LOOPS 128
 
-static nokprobe_inline int __cmpxchg_user_key_small(unsigned long address, unsigned int *uval,
-						    unsigned int old, unsigned int new,
-						    unsigned int mask, unsigned long key)
+static nokprobe_inline int __cmpxchg_key_small(void *address, unsigned int *uval,
+					       unsigned int old, unsigned int new,
+					       unsigned int mask, unsigned long key)
 {
 	unsigned long count;
 	unsigned int prev;
-	bool sacf_flag;
 	int rc = 0;
 
 	skey_regions_initialize();
-	sacf_flag = enable_sacf_uaccess();
 	asm_inline volatile(
 		"20:	spka	0(%[key])\n"
-		"	sacf	256\n"
 		"	llill	%[count],%[max_loops]\n"
 		"0:	l	%[prev],%[address]\n"
 		"1:	nr	%[prev],%[mask]\n"
@@ -178,8 +61,7 @@ static nokprobe_inline int __cmpxchg_user_key_small(unsigned long address, unsig
 		"	nr	%[tmp],%[mask]\n"
 		"	jnz	5f\n"
 		"	brct	%[count],2b\n"
-		"5:	sacf	768\n"
-		"	spka	%[default_key]\n"
+		"5:	spka	%[default_key]\n"
 		"21:\n"
 		EX_TABLE_UA_LOAD_REG(0b, 5b, %[rc], %[prev])
 		EX_TABLE_UA_LOAD_REG(1b, 5b, %[rc], %[prev])
@@ -197,16 +79,16 @@ static nokprobe_inline int __cmpxchg_user_key_small(unsigned long address, unsig
 		[default_key] "J" (PAGE_DEFAULT_KEY),
 		[max_loops] "J" (CMPXCHG_USER_KEY_MAX_LOOPS)
 		: "memory", "cc");
-	disable_sacf_uaccess(sacf_flag);
 	*uval = prev;
 	if (!count)
 		rc = -EAGAIN;
 	return rc;
 }
 
-int __kprobes __cmpxchg_user_key1(unsigned long address, unsigned char *uval,
-				  unsigned char old, unsigned char new, unsigned long key)
+int __kprobes __cmpxchg_key1(void *addr, unsigned char *uval, unsigned char old,
+			     unsigned char new, unsigned long key)
 {
+	unsigned long address = (unsigned long)addr;
 	unsigned int prev, shift, mask, _old, _new;
 	int rc;
 
@@ -215,15 +97,16 @@ int __kprobes __cmpxchg_user_key1(unsigned long address, unsigned char *uval,
 	_old = (unsigned int)old << shift;
 	_new = (unsigned int)new << shift;
 	mask = ~(0xff << shift);
-	rc = __cmpxchg_user_key_small(address, &prev, _old, _new, mask, key);
+	rc = __cmpxchg_key_small((void *)address, &prev, _old, _new, mask, key);
 	*uval = prev >> shift;
 	return rc;
 }
-EXPORT_SYMBOL(__cmpxchg_user_key1);
+EXPORT_SYMBOL(__cmpxchg_key1);
 
-int __kprobes __cmpxchg_user_key2(unsigned long address, unsigned short *uval,
-				  unsigned short old, unsigned short new, unsigned long key)
+int __kprobes __cmpxchg_key2(void *addr, unsigned short *uval, unsigned short old,
+			     unsigned short new, unsigned long key)
 {
+	unsigned long address = (unsigned long)addr;
 	unsigned int prev, shift, mask, _old, _new;
 	int rc;
 
@@ -232,27 +115,23 @@ int __kprobes __cmpxchg_user_key2(unsigned long address, unsigned short *uval,
 	_old = (unsigned int)old << shift;
 	_new = (unsigned int)new << shift;
 	mask = ~(0xffff << shift);
-	rc = __cmpxchg_user_key_small(address, &prev, _old, _new, mask, key);
+	rc = __cmpxchg_key_small((void *)address, &prev, _old, _new, mask, key);
 	*uval = prev >> shift;
 	return rc;
 }
-EXPORT_SYMBOL(__cmpxchg_user_key2);
+EXPORT_SYMBOL(__cmpxchg_key2);
 
-int __kprobes __cmpxchg_user_key4(unsigned long address, unsigned int *uval,
-				  unsigned int old, unsigned int new, unsigned long key)
+int __kprobes __cmpxchg_key4(void *address, unsigned int *uval, unsigned int old,
+			     unsigned int new, unsigned long key)
 {
 	unsigned int prev = old;
-	bool sacf_flag;
 	int rc = 0;
 
 	skey_regions_initialize();
-	sacf_flag = enable_sacf_uaccess();
 	asm_inline volatile(
 		"20:	spka	0(%[key])\n"
-		"	sacf	256\n"
 		"0:	cs	%[prev],%[new],%[address]\n"
-		"1:	sacf	768\n"
-		"	spka	%[default_key]\n"
+		"1:	spka	%[default_key]\n"
 		"21:\n"
 		EX_TABLE_UA_LOAD_REG(0b, 1b, %[rc], %[prev])
 		EX_TABLE_UA_LOAD_REG(1b, 1b, %[rc], %[prev])
@@ -264,27 +143,22 @@ int __kprobes __cmpxchg_user_key4(unsigned long address, unsigned int *uval,
 		[key] "a" (key << 4),
 		[default_key] "J" (PAGE_DEFAULT_KEY)
 		: "memory", "cc");
-	disable_sacf_uaccess(sacf_flag);
 	*uval = prev;
 	return rc;
 }
-EXPORT_SYMBOL(__cmpxchg_user_key4);
+EXPORT_SYMBOL(__cmpxchg_key4);
 
-int __kprobes __cmpxchg_user_key8(unsigned long address, unsigned long *uval,
-				  unsigned long old, unsigned long new, unsigned long key)
+int __kprobes __cmpxchg_key8(void *address, unsigned long *uval, unsigned long old,
+			     unsigned long new, unsigned long key)
 {
 	unsigned long prev = old;
-	bool sacf_flag;
 	int rc = 0;
 
 	skey_regions_initialize();
-	sacf_flag = enable_sacf_uaccess();
 	asm_inline volatile(
 		"20:	spka	0(%[key])\n"
-		"	sacf	256\n"
 		"0:	csg	%[prev],%[new],%[address]\n"
-		"1:	sacf	768\n"
-		"	spka	%[default_key]\n"
+		"1:	spka	%[default_key]\n"
 		"21:\n"
 		EX_TABLE_UA_LOAD_REG(0b, 1b, %[rc], %[prev])
 		EX_TABLE_UA_LOAD_REG(1b, 1b, %[rc], %[prev])
@@ -296,27 +170,22 @@ int __kprobes __cmpxchg_user_key8(unsigned long address, unsigned long *uval,
 		[key] "a" (key << 4),
 		[default_key] "J" (PAGE_DEFAULT_KEY)
 		: "memory", "cc");
-	disable_sacf_uaccess(sacf_flag);
 	*uval = prev;
 	return rc;
 }
-EXPORT_SYMBOL(__cmpxchg_user_key8);
+EXPORT_SYMBOL(__cmpxchg_key8);
 
-int __kprobes __cmpxchg_user_key16(unsigned long address, __uint128_t *uval,
-				   __uint128_t old, __uint128_t new, unsigned long key)
+int __kprobes __cmpxchg_key16(void *address, __uint128_t *uval, __uint128_t old,
+			      __uint128_t new, unsigned long key)
 {
 	__uint128_t prev = old;
-	bool sacf_flag;
 	int rc = 0;
 
 	skey_regions_initialize();
-	sacf_flag = enable_sacf_uaccess();
 	asm_inline volatile(
 		"20:	spka	0(%[key])\n"
-		"	sacf	256\n"
 		"0:	cdsg	%[prev],%[new],%[address]\n"
-		"1:	sacf	768\n"
-		"	spka	%[default_key]\n"
+		"1:	spka	%[default_key]\n"
 		"21:\n"
 		EX_TABLE_UA_LOAD_REGPAIR(0b, 1b, %[rc], %[prev])
 		EX_TABLE_UA_LOAD_REGPAIR(1b, 1b, %[rc], %[prev])
@@ -328,8 +197,7 @@ int __kprobes __cmpxchg_user_key16(unsigned long address, __uint128_t *uval,
 		[key] "a" (key << 4),
 		[default_key] "J" (PAGE_DEFAULT_KEY)
 		: "memory", "cc");
-	disable_sacf_uaccess(sacf_flag);
 	*uval = prev;
 	return rc;
 }
-EXPORT_SYMBOL(__cmpxchg_user_key16);
+EXPORT_SYMBOL(__cmpxchg_key16);
-- 
2.51.1


