Return-Path: <kvm+bounces-66510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 25DC1CD6D17
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FA0630BB2D1
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEC434C80D;
	Mon, 22 Dec 2025 16:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TiKckmly"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A269934AB14;
	Mon, 22 Dec 2025 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422291; cv=none; b=A7HRIIco/S0382db7uDKptDAg2KhRYovxkUNV8tISxA9pmXWJUgOwPXVjSJib6Pjku7iJ8D6dySAz8Mda4zbZ6flVvGQHr6roH8fxSSclZGwT5FWecSaWyT/KcxcYlcVXlmlKBmBvhUe6ZOBD/92XK6UzWXaH5JYoJB2vE1SZcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422291; c=relaxed/simple;
	bh=tQ7ZfXB9ZXDlcmFysBo23Xp9GFuYby3tlZYYHMXadd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgP85p2uSLnhCEFAslY8KqWv92pTPAG/7o5m6nEjT1SE3eOZe+GAEIJUtyA2LsnsZmkY2yomSbgfxnzO9izvOXRa7iMHFIgFCoSNz6O+FXigonWaoKCXBuPnQ+dENZHYwCNpgNPW/ZCnwcMvyeI+2iqYorhINRBmxa2YAg5IkZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TiKckmly; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMEPSIH009936;
	Mon, 22 Dec 2025 16:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=sfabJ+KRqcST8fijI
	Ee+SWh0YBAFVQBRgPbcPZm55fw=; b=TiKckmlymK6higgoBCeLmqu9dWI7nj3bI
	Dnz/inMB2AdvIk9CIyTbmOBlq1X2Uy061YlBZFx9u+S3b+CZymxRBY0CgN0VKfYU
	y4jENuXnP+F6gRP+tENSezpb1JCcnf1OUskHC89QGvvqe5o67KuU0jhWxnm8myOf
	+ZIefU/Kp6w8WTGGNN+bz0k6HLJUGE4SQZYYaGfGWs48jNswsGeWBih7GJz9IhuY
	OVz0kfXjNiO1H7ebGTdnz15zbYR5+YBxMQxZUWvQYm1Scu3G7rfDx4/ASG9gghHr
	iwv/GtfXcUW5W8XHl8yCxnZADW/HYNYOY3z2C+psqi1zAvH032Zyw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ketrtcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGN9dc005242;
	Mon, 22 Dec 2025 16:51:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b67mjy3kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:12 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGp7MZ45744570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:51:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A15B520040;
	Mon, 22 Dec 2025 16:51:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3BA020043;
	Mon, 22 Dec 2025 16:51:05 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:51:05 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 24/28] KVM: s390: Switch to new gmap
Date: Mon, 22 Dec 2025 17:50:29 +0100
Message-ID: <20251222165033.162329-25-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X5O2oS-FoorksShJAzu3ajnvz2OhlnOq
X-Authority-Analysis: v=2.4 cv=Qdxrf8bv c=1 sm=1 tr=0 ts=69497701 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=uKg510MlI9vT2tuH0HEA:9 a=obqATW7AqfSl8cD7:21
X-Proofpoint-ORIG-GUID: X5O2oS-FoorksShJAzu3ajnvz2OhlnOq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX/I1/A7Ogst6R
 3S9V86+FcL5LCLCG+E2gfhdVAMgL7Yn54B9h0jltF7EJJblDWhR1IKcgauwSjfb8w+xcZ3MAVjI
 CGshJkgypAWHsUq8YmePBUpQYLAeSwRwDzeY8Ss2xWVOfmRDtVg86gsmpHgkhqvQjBgXlQxjnPx
 BKMI7+RjEbUKDzVfBw/PyRe7hcYucZe7E7m1gUSanP4sxka0M8sAZDDbxGIJkqQPZ87iJK81Je1
 crZgveRWoDaGY4K4mUH0esreFeZX013y4NMrFFL2L+WlVFgQ+NO7ydQMo8JsJzGc5slzEZ8knoi
 8IfUNAyl+Zm+1wPMoDGcAZxg2Zn6hNSPYEVfBf75Py/KvSKo9uQtGcOGDC/zjAdGujgxi0qyb5e
 UCQ7tay8FMTA5KzMcdE1ndXoa60Z6m3j+hbBp8IBOWw9tpGwEtAU0cNJoKbdB+gbDt+KWCnPiGV
 fLXJVGqLCanSw0mkqGg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

Switch KVM/s390 to use the new gmap code.

Remove includes to <gmap.h> and include "gmap.h" instead; fix all the
existing users of the old gmap functions to use the new ones instead.

Fix guest storage key access functions to work with the new gmap.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/Kconfig                   |   2 +-
 arch/s390/include/asm/kvm_host.h    |   5 +-
 arch/s390/include/asm/mmu_context.h |   4 -
 arch/s390/include/asm/tlb.h         |   3 -
 arch/s390/include/asm/uaccess.h     |  70 +--
 arch/s390/include/asm/uv.h          |   1 -
 arch/s390/kernel/uv.c               | 114 +---
 arch/s390/kvm/Makefile              |   2 +-
 arch/s390/kvm/diag.c                |   2 +-
 arch/s390/kvm/gaccess.c             | 869 +++++++++++++++++-----------
 arch/s390/kvm/gaccess.h             |  18 +-
 arch/s390/kvm/gmap-vsie.c           | 141 -----
 arch/s390/kvm/intercept.c           |  15 +-
 arch/s390/kvm/interrupt.c           |   6 +-
 arch/s390/kvm/kvm-s390.c            | 767 +++++++-----------------
 arch/s390/kvm/kvm-s390.h            |  19 +-
 arch/s390/kvm/priv.c                | 213 +++----
 arch/s390/kvm/pv.c                  | 174 ++++--
 arch/s390/kvm/vsie.c                | 169 +++---
 arch/s390/lib/uaccess.c             | 184 +-----
 arch/s390/mm/gmap_helpers.c         |  38 +-
 21 files changed, 1106 insertions(+), 1710 deletions(-)
 delete mode 100644 arch/s390/kvm/gmap-vsie.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 0e5fad5f06ca..8270754985e9 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -33,7 +33,7 @@ config GENERIC_LOCKBREAK
 	def_bool y if PREEMPTION
 
 config PGSTE
-	def_bool y if KVM
+	def_bool n
 
 config AUDIT_ARCH
 	def_bool y
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 816776a8a8e3..64a50f0862aa 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -442,7 +442,7 @@ struct kvm_vcpu_arch {
 	bool acrs_loaded;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
-	void *mc; /* Placeholder */
+	struct kvm_s390_mmu_cache *mc;
 };
 
 struct kvm_vm_stat {
@@ -636,6 +636,8 @@ struct kvm_s390_pv {
 	struct mutex import_lock;
 };
 
+struct kvm_s390_mmu_cache;
+
 struct kvm_arch {
 	struct esca_block *sca;
 	debug_info_t *dbf;
@@ -675,6 +677,7 @@ struct kvm_arch {
 	struct kvm_s390_pv pv;
 	struct list_head kzdev_list;
 	spinlock_t kzdev_list_lock;
+	struct kvm_s390_mmu_cache *mc;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 48e548c01daa..bd1ef5e2d2eb 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -30,11 +30,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
 #if IS_ENABLED(CONFIG_KVM)
-	mm->context.has_pgste = 0;
-	mm->context.uses_skeys = 0;
-	mm->context.uses_cmm = 0;
 	mm->context.allow_cow_sharing = 1;
-	mm->context.allow_gmap_hpage_1m = 0;
 #endif
 	switch (mm->context.asce_limit) {
 	default:
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 1e50f6f1ad9d..7354b42ee994 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -36,7 +36,6 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 
 #include <asm/tlbflush.h>
 #include <asm-generic/tlb.h>
-#include <asm/gmap.h>
 
 /*
  * Release the page cache reference for a pte removed by
@@ -85,8 +84,6 @@ static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_pmds = 1;
-	if (mm_has_pgste(tlb->mm))
-		gmap_unlink(tlb->mm, (unsigned long *)pte, address);
 	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pte));
 }
 
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index c5e02addcd67..dff035372601 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -471,65 +471,15 @@ do {									\
 #define arch_get_kernel_nofault __mvc_kernel_nofault
 #define arch_put_kernel_nofault __mvc_kernel_nofault
 
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
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0744874ca6df..d919e69662f5 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -631,7 +631,6 @@ int uv_pin_shared(unsigned long paddr);
 int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
-int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
 int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio);
 int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
 int uv_convert_from_secure(unsigned long paddr);
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index cb4e8089fbca..daf7481692ed 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -209,39 +209,6 @@ int uv_convert_from_secure_pte(pte_t pte)
 	return uv_convert_from_secure_folio(pfn_folio(pte_pfn(pte)));
 }
 
-/**
- * should_export_before_import - Determine whether an export is needed
- * before an import-like operation
- * @uvcb: the Ultravisor control block of the UVC to be performed
- * @mm: the mm of the process
- *
- * Returns whether an export is needed before every import-like operation.
- * This is needed for shared pages, which don't trigger a secure storage
- * exception when accessed from a different guest.
- *
- * Although considered as one, the Unpin Page UVC is not an actual import,
- * so it is not affected.
- *
- * No export is needed also when there is only one protected VM, because the
- * page cannot belong to the wrong VM in that case (there is no "other VM"
- * it can belong to).
- *
- * Return: true if an export is needed before every import, otherwise false.
- */
-static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
-{
-	/*
-	 * The misc feature indicates, among other things, that importing a
-	 * shared page from a different protected VM will automatically also
-	 * transfer its ownership.
-	 */
-	if (uv_has_feature(BIT_UV_FEAT_MISC))
-		return false;
-	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
-		return false;
-	return atomic_read(&mm->context.protected_count) > 1;
-}
-
 /*
  * Calculate the expected ref_count for a folio that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
@@ -313,20 +280,6 @@ int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 }
 EXPORT_SYMBOL(__make_folio_secure);
 
-static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct uv_cb_header *uvcb)
-{
-	int rc;
-
-	if (!folio_trylock(folio))
-		return -EAGAIN;
-	if (should_export_before_import(uvcb, mm))
-		uv_convert_from_secure(folio_to_phys(folio));
-	rc = __make_folio_secure(folio, uvcb);
-	folio_unlock(folio);
-
-	return rc;
-}
-
 /**
  * s390_wiggle_split_folio() - try to drain extra references to a folio and
  *			       split the folio if it is large.
@@ -414,56 +367,6 @@ int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(s390_wiggle_split_folio);
 
-int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
-{
-	struct vm_area_struct *vma;
-	struct folio_walk fw;
-	struct folio *folio;
-	int rc;
-
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, hva);
-	if (!vma) {
-		mmap_read_unlock(mm);
-		return -EFAULT;
-	}
-	folio = folio_walk_start(&fw, vma, hva, 0);
-	if (!folio) {
-		mmap_read_unlock(mm);
-		return -ENXIO;
-	}
-
-	folio_get(folio);
-	/*
-	 * Secure pages cannot be huge and userspace should not combine both.
-	 * In case userspace does it anyway this will result in an -EFAULT for
-	 * the unpack. The guest is thus never reaching secure mode.
-	 * If userspace plays dirty tricks and decides to map huge pages at a
-	 * later point in time, it will receive a segmentation fault or
-	 * KVM_RUN will return -EFAULT.
-	 */
-	if (folio_test_hugetlb(folio))
-		rc = -EFAULT;
-	else if (folio_test_large(folio))
-		rc = -E2BIG;
-	else if (!pte_write(fw.pte) || (pte_val(fw.pte) & _PAGE_INVALID))
-		rc = -ENXIO;
-	else
-		rc = make_folio_secure(mm, folio, uvcb);
-	folio_walk_end(&fw, vma);
-	mmap_read_unlock(mm);
-
-	if (rc == -E2BIG || rc == -EBUSY) {
-		rc = s390_wiggle_split_folio(mm, folio);
-		if (!rc)
-			rc = -EAGAIN;
-	}
-	folio_put(folio);
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(make_hva_secure);
-
 /*
  * To be called with the folio locked or with an extra reference! This will
  * prevent kvm_s390_pv_make_secure() from touching the folio concurrently.
@@ -474,21 +377,18 @@ int arch_make_folio_accessible(struct folio *folio)
 {
 	int rc = 0;
 
-	/* Large folios cannot be secure */
-	if (unlikely(folio_test_large(folio)))
-		return 0;
-
 	/*
-	 * PG_arch_1 is used in 2 places:
-	 * 1. for storage keys of hugetlb folios and KVM
-	 * 2. As an indication that this small folio might be secure. This can
-	 *    overindicate, e.g. we set the bit before calling
-	 *    convert_to_secure.
-	 * As secure pages are never large folios, both variants can co-exists.
+	 * PG_arch_1 is used as an indication that this small folio might be
+	 * secure. This can overindicate, e.g. we set the bit before calling
+	 * convert_to_secure.
 	 */
 	if (!test_bit(PG_arch_1, &folio->flags.f))
 		return 0;
 
+	/* Large folios cannot be secure */
+	if (WARN_ON_ONCE(folio_test_large(folio)))
+		return -EFAULT;
+
 	rc = uv_pin_shared(folio_to_phys(folio));
 	if (!rc) {
 		clear_bit(PG_arch_1, &folio->flags.f);
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 1e2dcd3e2436..dac9d53b23d8 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -8,7 +8,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
+kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
 kvm-y += dat.o gmap.o faultin.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 53233dec8cad..d89d1c381522 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -10,13 +10,13 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
-#include <asm/gmap.h>
 #include <asm/gmap_helpers.h>
 #include <asm/virtio-ccw.h>
 #include "kvm-s390.h"
 #include "trace.h"
 #include "trace-s390.h"
 #include "gaccess.h"
+#include "gmap.h"
 
 static void do_discard_gfn_range(struct kvm_vcpu *vcpu, gfn_t gfn_start, gfn_t gfn_end)
 {
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 1d0725f3951a..0fe3d91b8305 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -11,15 +11,43 @@
 #include <linux/err.h>
 #include <linux/pgtable.h>
 #include <linux/bitfield.h>
+#include <linux/kvm_host.h>
+#include <linux/kvm_types.h>
+#include <asm/diag.h>
 #include <asm/access-regs.h>
 #include <asm/fault.h>
-#include <asm/gmap.h>
 #include <asm/dat-bits.h>
 #include "kvm-s390.h"
+#include "dat.h"
+#include "gmap.h"
 #include "gaccess.h"
+#include "faultin.h"
 
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
+union dat_table_entry {
+	unsigned long val;
+	union region1_table_entry pgd;
+	union region2_table_entry p4d;
+	union region3_table_entry pud;
+	union segment_table_entry pmd;
+	union page_table_entry pte;
+};
+
+#define WALK_N_ENTRIES 7
+#define LEVEL_MEM -2
+struct pgtwalk {
+	struct guest_fault raw_entries[WALK_N_ENTRIES];
+	gpa_t last_addr;
+	int level;
+	bool p;
+};
+
+static inline struct guest_fault *get_entries(struct pgtwalk *w)
+{
+	return w->raw_entries - LEVEL_MEM;
+}
+
 /*
  * raddress union which will contain the result (real or absolute address)
  * after a page table walk. The rfaa, sfaa and pfra members are used to
@@ -81,6 +109,28 @@ struct aste {
 	/* .. more fields there */
 };
 
+union oac {
+	unsigned int val;
+	struct {
+		struct {
+			unsigned short key : 4;
+			unsigned short     : 4;
+			unsigned short as  : 2;
+			unsigned short     : 4;
+			unsigned short k   : 1;
+			unsigned short a   : 1;
+		} oac1;
+		struct {
+			unsigned short key : 4;
+			unsigned short     : 4;
+			unsigned short as  : 2;
+			unsigned short     : 4;
+			unsigned short k   : 1;
+			unsigned short a   : 1;
+		} oac2;
+	};
+};
+
 int ipte_lock_held(struct kvm *kvm)
 {
 	if (sclp.has_siif)
@@ -603,28 +653,16 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 static int vm_check_access_key_gpa(struct kvm *kvm, u8 access_key,
 				   enum gacc_mode mode, gpa_t gpa)
 {
-	u8 storage_key, access_control;
-	bool fetch_protected;
-	unsigned long hva;
+	union skey storage_key;
 	int r;
 
-	if (access_key == 0)
-		return 0;
-
-	hva = gfn_to_hva(kvm, gpa_to_gfn(gpa));
-	if (kvm_is_error_hva(hva))
-		return PGM_ADDRESSING;
-
-	mmap_read_lock(current->mm);
-	r = get_guest_storage_key(current->mm, hva, &storage_key);
-	mmap_read_unlock(current->mm);
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		r = dat_get_storage_key(kvm->arch.gmap->asce, gpa_to_gfn(gpa), &storage_key);
 	if (r)
 		return r;
-	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
-	if (access_control == access_key)
+	if (access_key == 0 || storage_key.acc == access_key)
 		return 0;
-	fetch_protected = storage_key & _PAGE_FP_BIT;
-	if ((mode == GACC_FETCH || mode == GACC_IFETCH) && !fetch_protected)
+	if ((mode == GACC_FETCH || mode == GACC_IFETCH) && !storage_key.fp)
 		return 0;
 	return PGM_PROTECTION;
 }
@@ -667,8 +705,7 @@ static int vcpu_check_access_key_gpa(struct kvm_vcpu *vcpu, u8 access_key,
 				     enum gacc_mode mode, union asce asce, gpa_t gpa,
 				     unsigned long ga, unsigned int len)
 {
-	u8 storage_key, access_control;
-	unsigned long hva;
+	union skey storage_key;
 	int r;
 
 	/* access key 0 matches any storage key -> allow */
@@ -678,26 +715,23 @@ static int vcpu_check_access_key_gpa(struct kvm_vcpu *vcpu, u8 access_key,
 	 * caller needs to ensure that gfn is accessible, so we can
 	 * assume that this cannot fail
 	 */
-	hva = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gpa));
-	mmap_read_lock(current->mm);
-	r = get_guest_storage_key(current->mm, hva, &storage_key);
-	mmap_read_unlock(current->mm);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		r = dat_get_storage_key(vcpu->arch.gmap->asce, gpa_to_gfn(gpa), &storage_key);
 	if (r)
 		return r;
-	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
 	/* access key matches storage key -> allow */
-	if (access_control == access_key)
+	if (storage_key.acc == access_key)
 		return 0;
 	if (mode == GACC_FETCH || mode == GACC_IFETCH) {
 		/* it is a fetch and fetch protection is off -> allow */
-		if (!(storage_key & _PAGE_FP_BIT))
+		if (!storage_key.fp)
 			return 0;
 		if (fetch_prot_override_applicable(vcpu, mode, asce) &&
 		    fetch_prot_override_applies(ga, len))
 			return 0;
 	}
 	if (storage_prot_override_applicable(vcpu) &&
-	    storage_prot_override_applies(access_control))
+	    storage_prot_override_applies(storage_key.acc))
 		return 0;
 	return PGM_PROTECTION;
 }
@@ -797,37 +831,79 @@ static int access_guest_page_gpa(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa
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
+		"       lr      %%r0,%[spec]\n"
+		"0:     mvcos   %[to],%[from],%[size]\n"
+		"1:     lhi     %[exc],0\n"
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
@@ -950,18 +1026,101 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
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
@@ -974,89 +1133,36 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
  *         * -EAGAIN: transient failure (len 1 or 2)
  *         * -EOPNOTSUPP: read-only memslot (should never occur)
  */
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old_addr,
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old,
 			       union kvm_s390_quad new, u8 acc, bool *success)
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
-		ret = cmpxchg_user_key((u8 __user *)hva, &old, old_addr->one, new.one, acc);
-		*success = !ret && old == old_addr->one;
-		old_addr->one = old;
-		break;
-	}
-	case 2: {
-		u16 old;
-
-		ret = cmpxchg_user_key((u16 __user *)hva, &old, old_addr->two, new.two, acc);
-		*success = !ret && old == old_addr->two;
-		old_addr->two = old;
-		break;
-	}
-	case 4: {
-		u32 old;
-
-		ret = cmpxchg_user_key((u32 __user *)hva, &old, old_addr->four, new.four, acc);
-		*success = !ret && old == old_addr->four;
-		old_addr->four = old;
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
 
-		ret = cmpxchg_user_key((u64 __user *)hva, &old, old_addr->eight, new.eight, acc);
-		*success = !ret && old == old_addr->eight;
-		old_addr->eight = old;
-		break;
-	}
-	case 16: {
-		__uint128_t old;
+	lockdep_assert_held(&kvm->srcu);
 
-		ret = cmpxchg_user_key((__uint128_t __user *)hva, &old, old_addr->sixteen,
-				       new.sixteen, acc);
-		*success = !ret && old == old_addr->sixteen;
-		old_addr->sixteen = old;
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
@@ -1158,304 +1264,365 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
 }
 
 /**
- * kvm_s390_shadow_tables - walk the guest page table and create shadow tables
+ * walk_guest_tables() - walk the guest page table and pin the dat tables
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
- * @pgt: pointer to the beginning of the page table for the given address if
- *	 successful (return value 0), or to the first invalid DAT entry in
- *	 case of exceptions (return value > 0)
- * @dat_protection: referenced memory is write protected
- * @fake: pgt references contiguous guest memory block, not a pgtable
+ * @w: will be filled with information on the pinned pages
+ * @wr: indicates a write access if true
+ *
+ * Return:
+ * * 0 in case of success,
+ * * a PIC code > 0 in case the address translation fails
+ * * an error code < 0 if other errors happen in the host
  */
-static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
-				  unsigned long *pgt, int *dat_protection,
-				  int *fake)
+static int walk_guest_tables(struct gmap *sg, unsigned long saddr, struct pgtwalk *w, bool wr)
 {
-	struct kvm *kvm;
-	struct gmap *parent;
-	union asce asce;
+	struct gmap *parent = sg->parent;
+	struct guest_fault *entries;
+	union dat_table_entry table;
 	union vaddress vaddr;
 	unsigned long ptr;
+	struct kvm *kvm;
+	union asce asce;
 	int rc;
 
-	*fake = 0;
-	*dat_protection = 0;
-	kvm = sg->private;
-	parent = sg->parent;
+	kvm = parent->kvm;
+	asce = sg->guest_asce;
+	entries = get_entries(w);
+
+	w->level = LEVEL_MEM;
+	w->last_addr = saddr;
+	if (asce.r)
+		return kvm_s390_get_guest_page(kvm, entries + LEVEL_MEM, gpa_to_gfn(saddr), false);
+
 	vaddr.addr = saddr;
-	asce.val = sg->orig_asce;
 	ptr = asce.rsto * PAGE_SIZE;
-	if (asce.r) {
-		*fake = 1;
-		ptr = 0;
-		asce.dt = ASCE_TYPE_REGION1;
-	}
+
+	if (!asce_contains_gfn(asce, gpa_to_gfn(saddr)))
+		return PGM_ASCE_TYPE;
 	switch (asce.dt) {
 	case ASCE_TYPE_REGION1:
-		if (vaddr.rfx01 > asce.tl && !*fake)
+		if (vaddr.rfx01 > asce.tl)
 			return PGM_REGION_FIRST_TRANS;
 		break;
 	case ASCE_TYPE_REGION2:
-		if (vaddr.rfx)
-			return PGM_ASCE_TYPE;
 		if (vaddr.rsx01 > asce.tl)
 			return PGM_REGION_SECOND_TRANS;
 		break;
 	case ASCE_TYPE_REGION3:
-		if (vaddr.rfx || vaddr.rsx)
-			return PGM_ASCE_TYPE;
 		if (vaddr.rtx01 > asce.tl)
 			return PGM_REGION_THIRD_TRANS;
 		break;
 	case ASCE_TYPE_SEGMENT:
-		if (vaddr.rfx || vaddr.rsx || vaddr.rtx)
-			return PGM_ASCE_TYPE;
 		if (vaddr.sx01 > asce.tl)
 			return PGM_SEGMENT_TRANSLATION;
 		break;
 	}
 
+	w->level = asce.dt;
 	switch (asce.dt) {
-	case ASCE_TYPE_REGION1: {
-		union region1_table_entry rfte;
-
-		if (*fake) {
-			ptr += vaddr.rfx * _REGION1_SIZE;
-			rfte.val = ptr;
-			goto shadow_r2t;
-		}
-		*pgt = ptr + vaddr.rfx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8, &rfte.val);
+	case ASCE_TYPE_REGION1:
+		w->last_addr = ptr + vaddr.rfx * 8;
+		rc = kvm_s390_get_guest_page_and_read_gpa(kvm, entries + w->level,
+							  w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (rfte.i)
+		if (table.pgd.i)
 			return PGM_REGION_FIRST_TRANS;
-		if (rfte.tt != TABLE_TYPE_REGION1)
+		if (table.pgd.tt != TABLE_TYPE_REGION1)
 			return PGM_TRANSLATION_SPEC;
-		if (vaddr.rsx01 < rfte.tf || vaddr.rsx01 > rfte.tl)
+		if (vaddr.rsx01 < table.pgd.tf || vaddr.rsx01 > table.pgd.tl)
 			return PGM_REGION_SECOND_TRANS;
 		if (sg->edat_level >= 1)
-			*dat_protection |= rfte.p;
-		ptr = rfte.rto * PAGE_SIZE;
-shadow_r2t:
-		rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
-		if (rc)
-			return rc;
-		kvm->stat.gmap_shadow_r1_entry++;
-	}
+			w->p |= table.pgd.p;
+		ptr = table.pgd.rto * PAGE_SIZE;
+		w->level--;
 		fallthrough;
-	case ASCE_TYPE_REGION2: {
-		union region2_table_entry rste;
-
-		if (*fake) {
-			ptr += vaddr.rsx * _REGION2_SIZE;
-			rste.val = ptr;
-			goto shadow_r3t;
-		}
-		*pgt = ptr + vaddr.rsx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8, &rste.val);
+	case ASCE_TYPE_REGION2:
+		w->last_addr = ptr + vaddr.rsx * 8;
+		rc = kvm_s390_get_guest_page_and_read_gpa(kvm, entries + w->level,
+							  w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (rste.i)
+		if (table.p4d.i)
 			return PGM_REGION_SECOND_TRANS;
-		if (rste.tt != TABLE_TYPE_REGION2)
+		if (table.p4d.tt != TABLE_TYPE_REGION2)
 			return PGM_TRANSLATION_SPEC;
-		if (vaddr.rtx01 < rste.tf || vaddr.rtx01 > rste.tl)
+		if (vaddr.rtx01 < table.p4d.tf || vaddr.rtx01 > table.p4d.tl)
 			return PGM_REGION_THIRD_TRANS;
 		if (sg->edat_level >= 1)
-			*dat_protection |= rste.p;
-		ptr = rste.rto * PAGE_SIZE;
-shadow_r3t:
-		rste.p |= *dat_protection;
-		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
-		if (rc)
-			return rc;
-		kvm->stat.gmap_shadow_r2_entry++;
-	}
+			w->p |= table.p4d.p;
+		ptr = table.p4d.rto * PAGE_SIZE;
+		w->level--;
 		fallthrough;
-	case ASCE_TYPE_REGION3: {
-		union region3_table_entry rtte;
-
-		if (*fake) {
-			ptr += vaddr.rtx * _REGION3_SIZE;
-			rtte.val = ptr;
-			goto shadow_sgt;
-		}
-		*pgt = ptr + vaddr.rtx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8, &rtte.val);
+	case ASCE_TYPE_REGION3:
+		w->last_addr = ptr + vaddr.rtx * 8;
+		rc = kvm_s390_get_guest_page_and_read_gpa(kvm, entries + w->level,
+							  w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (rtte.i)
+		if (table.pud.i)
 			return PGM_REGION_THIRD_TRANS;
-		if (rtte.tt != TABLE_TYPE_REGION3)
+		if (table.pud.tt != TABLE_TYPE_REGION3)
 			return PGM_TRANSLATION_SPEC;
-		if (rtte.cr && asce.p && sg->edat_level >= 2)
+		if (table.pud.cr && asce.p && sg->edat_level >= 2)
 			return PGM_TRANSLATION_SPEC;
-		if (rtte.fc && sg->edat_level >= 2) {
-			*dat_protection |= rtte.fc0.p;
-			*fake = 1;
-			ptr = rtte.fc1.rfaa * _REGION3_SIZE;
-			rtte.val = ptr;
-			goto shadow_sgt;
+		if (sg->edat_level >= 1)
+			w->p |= table.pud.p;
+		if (table.pud.fc && sg->edat_level >= 2) {
+			table.val = u64_replace_bits(table.val, saddr, ~_REGION3_MASK);
+			goto edat_applies;
 		}
-		if (vaddr.sx01 < rtte.fc0.tf || vaddr.sx01 > rtte.fc0.tl)
+		if (vaddr.sx01 < table.pud.fc0.tf || vaddr.sx01 > table.pud.fc0.tl)
 			return PGM_SEGMENT_TRANSLATION;
-		if (sg->edat_level >= 1)
-			*dat_protection |= rtte.fc0.p;
-		ptr = rtte.fc0.sto * PAGE_SIZE;
-shadow_sgt:
-		rtte.fc0.p |= *dat_protection;
-		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
-		if (rc)
-			return rc;
-		kvm->stat.gmap_shadow_r3_entry++;
-	}
+		ptr = table.pud.fc0.sto * PAGE_SIZE;
+		w->level--;
 		fallthrough;
-	case ASCE_TYPE_SEGMENT: {
-		union segment_table_entry ste;
-
-		if (*fake) {
-			ptr += vaddr.sx * _SEGMENT_SIZE;
-			ste.val = ptr;
-			goto shadow_pgt;
-		}
-		*pgt = ptr + vaddr.sx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.sx * 8, &ste.val);
+	case ASCE_TYPE_SEGMENT:
+		w->last_addr = ptr + vaddr.sx * 8;
+		rc = kvm_s390_get_guest_page_and_read_gpa(kvm, entries + w->level,
+							  w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (ste.i)
+		if (table.pmd.i)
 			return PGM_SEGMENT_TRANSLATION;
-		if (ste.tt != TABLE_TYPE_SEGMENT)
+		if (table.pmd.tt != TABLE_TYPE_SEGMENT)
 			return PGM_TRANSLATION_SPEC;
-		if (ste.cs && asce.p)
+		if (table.pmd.cs && asce.p)
 			return PGM_TRANSLATION_SPEC;
-		*dat_protection |= ste.fc0.p;
-		if (ste.fc && sg->edat_level >= 1) {
-			*fake = 1;
-			ptr = ste.fc1.sfaa * _SEGMENT_SIZE;
-			ste.val = ptr;
-			goto shadow_pgt;
+		w->p |= table.pmd.p;
+		if (table.pmd.fc && sg->edat_level >= 1) {
+			table.val = u64_replace_bits(table.val, saddr, ~_SEGMENT_MASK);
+			goto edat_applies;
 		}
-		ptr = ste.fc0.pto * (PAGE_SIZE / 2);
-shadow_pgt:
-		ste.fc0.p |= *dat_protection;
-		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
+		ptr = table.pmd.fc0.pto * (PAGE_SIZE / 2);
+		w->level--;
+	}
+	w->last_addr = ptr + vaddr.px * 8;
+	rc = kvm_s390_get_guest_page_and_read_gpa(kvm, entries + w->level,
+						  w->last_addr, &table.val);
+	if (rc)
+		return rc;
+	if (table.pte.i)
+		return PGM_PAGE_TRANSLATION;
+	if (table.pte.z)
+		return PGM_TRANSLATION_SPEC;
+	w->p |= table.pte.p;
+edat_applies:
+	if (wr && w->p)
+		return PGM_PROTECTION;
+
+	return kvm_s390_get_guest_page(kvm, entries + LEVEL_MEM, table.pte.pfra, wr);
+}
+
+static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union pte *ptep,
+			  struct guest_fault *f, bool p)
+{
+	union pgste pgste;
+	union pte newpte;
+	int rc;
+
+	lockdep_assert_held(&sg->kvm->mmu_lock);
+	lockdep_assert_held(&sg->parent->children_lock);
+
+	scoped_guard(spinlock, &sg->host_to_rmap_lock)
+		rc = gmap_insert_rmap(sg, f->gfn, gpa_to_gfn(raddr), TABLE_TYPE_PAGE_TABLE);
+	if (rc)
+		return rc;
+
+	pgste = pgste_get_lock(ptep_h);
+	newpte = _pte(f->pfn, f->writable, !p, 0);
+	newpte.s.d |= ptep->s.d;
+	newpte.s.sd |= ptep->s.sd;
+	newpte.h.p &= ptep->h.p;
+	pgste = _gmap_ptep_xchg(sg->parent, ptep_h, newpte, pgste, f->gfn, false);
+	pgste.vsie_notif = 1;
+	pgste_set_unlock(ptep_h, pgste);
+
+	newpte = _pte(f->pfn, 0, !p, 0);
+	pgste = pgste_get_lock(ptep);
+	pgste = __dat_ptep_xchg(ptep, pgste, newpte, gpa_to_gfn(raddr), sg->asce, uses_skeys(sg));
+	pgste_set_unlock(ptep, pgste);
+
+	return 0;
+}
+
+static int _do_shadow_crste(struct gmap *sg, gpa_t raddr, union crste *host, union crste *table,
+			    struct guest_fault *f, bool p)
+{
+	union crste newcrste;
+	gfn_t gfn;
+	int rc;
+
+	lockdep_assert_held(&sg->kvm->mmu_lock);
+	lockdep_assert_held(&sg->parent->children_lock);
+
+	gfn = f->gfn & gpa_to_gfn(is_pmd(*table) ? _SEGMENT_MASK : _REGION3_MASK);
+	scoped_guard(spinlock, &sg->host_to_rmap_lock)
+		rc = gmap_insert_rmap(sg, gfn, gpa_to_gfn(raddr), host->h.tt);
+	if (rc)
+		return rc;
+
+	newcrste = _crste_fc1(f->pfn, host->h.tt, f->writable, !p);
+	newcrste.s.fc1.d |= host->s.fc1.d;
+	newcrste.s.fc1.sd |= host->s.fc1.sd;
+	newcrste.h.p &= host->h.p;
+	newcrste.s.fc1.vsie_notif = 1;
+	newcrste.s.fc1.prefix_notif = host->s.fc1.prefix_notif;
+	_gmap_crstep_xchg(sg->parent, host, newcrste, f->gfn, false);
+
+	newcrste = _crste_fc1(f->pfn, host->h.tt, 0, !p);
+	dat_crstep_xchg(table, newcrste, gpa_to_gfn(raddr), sg->asce);
+	return 0;
+}
+
+static int _gaccess_do_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
+			      unsigned long saddr, struct pgtwalk *w)
+{
+	struct guest_fault *entries;
+	int flags, i, hl, gl, l, rc;
+	union crste *table, *host;
+	union pte *ptep, *ptep_h;
+
+	lockdep_assert_held(&sg->kvm->mmu_lock);
+	lockdep_assert_held(&sg->parent->children_lock);
+
+	entries = get_entries(w);
+	ptep_h = NULL;
+	ptep = NULL;
+
+	rc = dat_entry_walk(NULL, gpa_to_gfn(saddr), sg->asce, DAT_WALK_ANY, TABLE_TYPE_PAGE_TABLE,
+			    &table, &ptep);
+	if (rc)
+		return rc;
+
+	/* A race occourred. The shadow mapping is already valid, nothing to do */
+	if ((ptep && !ptep->h.i) || (!ptep && crste_leaf(*table)))
+		return 0;
+
+	gl = get_level(table, ptep);
+
+	/*
+	 * Skip levels that are already protected. For each level, protect
+	 * only the page containing the entry, not the whole table.
+	 */
+	for (i = gl ; i >= w->level; i--) {
+		rc = gmap_protect_rmap(mc, sg, entries[i - 1].gfn, gpa_to_gfn(saddr),
+				       entries[i - 1].pfn, i, entries[i - 1].writable);
+		if (rc)
+			return rc;
+	}
+
+	rc = dat_entry_walk(NULL, entries[LEVEL_MEM].gfn, sg->parent->asce, DAT_WALK_LEAF,
+			    TABLE_TYPE_PAGE_TABLE, &host, &ptep_h);
+	if (rc)
+		return rc;
+
+	hl = get_level(host, ptep_h);
+	/* Get the smallest granularity */
+	l = min3(gl, hl, w->level);
+
+	flags = DAT_WALK_SPLIT_ALLOC | (uses_skeys(sg->parent) ? DAT_WALK_USES_SKEYS : 0);
+	/* If necessary, create the shadow mapping */
+	if (l < gl) {
+		rc = dat_entry_walk(mc, gpa_to_gfn(saddr), sg->asce, flags, l, &table, &ptep);
 		if (rc)
 			return rc;
-		kvm->stat.gmap_shadow_sg_entry++;
 	}
+	if (l < hl) {
+		rc = dat_entry_walk(mc, entries[LEVEL_MEM].gfn, sg->parent->asce,
+				    flags, l, &host, &ptep_h);
+		if (rc)
+			return rc;
 	}
-	/* Return the parent address of the page table */
-	*pgt = ptr;
-	return 0;
+
+	if (KVM_BUG_ON(l > TABLE_TYPE_REGION3, sg->kvm))
+		return -EFAULT;
+	if (l == TABLE_TYPE_PAGE_TABLE)
+		return _do_shadow_pte(sg, saddr, ptep_h, ptep, entries + LEVEL_MEM, w->p);
+	return _do_shadow_crste(sg, saddr, host, table, entries + LEVEL_MEM, w->p);
 }
 
-/**
- * shadow_pgt_lookup() - find a shadow page table
- * @sg: pointer to the shadow guest address space structure
- * @saddr: the address in the shadow aguest address space
- * @pgt: parent gmap address of the page table to get shadowed
- * @dat_protection: if the pgtable is marked as protected by dat
- * @fake: pgt references contiguous guest memory block, not a pgtable
- *
- * Returns 0 if the shadow page table was found and -EAGAIN if the page
- * table was not found.
- *
- * Called with sg->mm->mmap_lock in read.
- */
-static int shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
-			     int *dat_protection, int *fake)
+static inline int _gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+					unsigned long seq, struct pgtwalk *walk)
 {
-	unsigned long pt_index;
-	unsigned long *table;
-	struct page *page;
 	int rc;
 
-	spin_lock(&sg->guest_table_lock);
-	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
-	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
-		/* Shadow page tables are full pages (pte+pgste) */
-		page = pfn_to_page(*table >> PAGE_SHIFT);
-		pt_index = gmap_pgste_get_pgt_addr(page_to_virt(page));
-		*pgt = pt_index & ~GMAP_SHADOW_FAKE_TABLE;
-		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
-		*fake = !!(pt_index & GMAP_SHADOW_FAKE_TABLE);
-		rc = 0;
-	} else  {
-		rc = -EAGAIN;
+	if (kvm_s390_array_needs_retry_unsafe(vcpu->kvm, seq, walk->raw_entries))
+		return -EAGAIN;
+again:
+	rc = kvm_s390_mmu_cache_topup(vcpu->arch.mc);
+	if (rc)
+		return rc;
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
+		if (kvm_s390_array_needs_retry_safe(vcpu->kvm, seq, walk->raw_entries))
+			return -EAGAIN;
+		scoped_guard(spinlock, &sg->parent->children_lock)
+			rc = _gaccess_do_shadow(vcpu->arch.mc, sg, saddr, walk);
+		if (rc == -ENOMEM)
+			goto again;
+		if (!rc)
+			kvm_s390_release_faultin_array(vcpu->kvm, walk->raw_entries, false);
 	}
-	spin_unlock(&sg->guest_table_lock);
 	return rc;
 }
 
 /**
- * kvm_s390_shadow_fault - handle fault on a shadow page table
- * @vcpu: virtual cpu
- * @sg: pointer to the shadow guest address space structure
+ * __kvm_s390_shadow_fault() - handle fault on a shadow page table
+ * @vcpu: virtual cpu that triggered the action
+ * @sg: the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
  * @datptr: will contain the address of the faulting DAT table entry, or of
  *	    the valid leaf, plus some flags
+ * @wr: whether this is a write access
  *
- * Returns: - 0 if the shadow fault was successfully resolved
- *	    - > 0 (pgm exception code) on exceptions while faulting
- *	    - -EAGAIN if the caller can retry immediately
- *	    - -EFAULT when accessing invalid guest addresses
- *	    - -ENOMEM if out of memory
+ * Return:
+ * * 0 if the shadow fault was successfully resolved
+ * * > 0 (pgm exception code) on exceptions while faulting
+ * * -EAGAIN if the caller can retry immediately
+ * * -EFAULT when accessing invalid guest addresses
+ * * -ENOMEM if out of memory
  */
-int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
-			  unsigned long saddr, unsigned long *datptr)
+static int __gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+				  union mvpg_pei *datptr, bool wr)
 {
-	union vaddress vaddr;
-	union page_table_entry pte;
-	unsigned long pgt = 0;
-	int dat_protection, fake;
+	struct pgtwalk walk = {	.p = false, };
+	unsigned long seq;
 	int rc;
 
-	if (KVM_BUG_ON(!gmap_is_shadow(sg), vcpu->kvm))
-		return -EFAULT;
+	seq = vcpu->kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
 
-	mmap_read_lock(sg->mm);
-	/*
-	 * We don't want any guest-2 tables to change - so the parent
-	 * tables/pointers we read stay valid - unshadowing is however
-	 * always possible - only guest_table_lock protects us.
-	 */
-	ipte_lock(vcpu->kvm);
-
-	rc = shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
+	rc = walk_guest_tables(sg, saddr, &walk, wr);
+	if (datptr) {
+		datptr->val = walk.last_addr;
+		datptr->dat_prot = wr && walk.p;
+		datptr->not_pte = walk.level > TABLE_TYPE_PAGE_TABLE;
+		datptr->real = sg->guest_asce.r;
+	}
+	if (!rc)
+		rc = _gaccess_shadow_fault(vcpu, sg, saddr, seq, &walk);
 	if (rc)
-		rc = kvm_s390_shadow_tables(sg, saddr, &pgt, &dat_protection,
-					    &fake);
+		kvm_s390_release_faultin_array(vcpu->kvm, walk.raw_entries, true);
+	return rc;
+}
 
-	vaddr.addr = saddr;
-	if (fake) {
-		pte.val = pgt + vaddr.px * PAGE_SIZE;
-		goto shadow_page;
-	}
+int gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+			 union mvpg_pei *datptr, bool wr)
+{
+	int rc;
 
-	switch (rc) {
-	case PGM_SEGMENT_TRANSLATION:
-	case PGM_REGION_THIRD_TRANS:
-	case PGM_REGION_SECOND_TRANS:
-	case PGM_REGION_FIRST_TRANS:
-		pgt |= PEI_NOT_PTE;
-		break;
-	case 0:
-		pgt += vaddr.px * 8;
-		rc = gmap_read_table(sg->parent, pgt, &pte.val);
-	}
-	if (datptr)
-		*datptr = pgt | dat_protection * PEI_DAT_PROT;
-	if (!rc && pte.i)
-		rc = PGM_PAGE_TRANSLATION;
-	if (!rc && pte.z)
-		rc = PGM_TRANSLATION_SPEC;
-shadow_page:
-	pte.p |= dat_protection;
-	if (!rc)
-		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
-	vcpu->kvm->stat.gmap_shadow_pg_entry++;
+	if (KVM_BUG_ON(!test_bit(GMAP_FLAG_SHADOW, &sg->flags), vcpu->kvm))
+		return -EFAULT;
+
+	rc = kvm_s390_mmu_cache_topup(vcpu->arch.mc);
+	if (rc)
+		return rc;
+
+	ipte_lock(vcpu->kvm);
+	rc = __gaccess_shadow_fault(vcpu, sg, saddr, datptr, wr || sg->guest_asce.r);
 	ipte_unlock(vcpu->kvm);
-	mmap_read_unlock(sg->mm);
+
 	return rc;
 }
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 774cdf19998f..b5385cec60f4 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -206,7 +206,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode);
 
-int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old_addr,
+int cmpxchg_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, int len, union kvm_s390_quad *old,
 			       union kvm_s390_quad new, u8 access_key, bool *success);
 
 /**
@@ -450,11 +450,17 @@ void ipte_unlock(struct kvm *kvm);
 int ipte_lock_held(struct kvm *kvm);
 int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
 
-/* MVPG PEI indication bits */
-#define PEI_DAT_PROT 2
-#define PEI_NOT_PTE 4
+union mvpg_pei {
+	unsigned long val;
+	struct {
+		unsigned long addr    : 61;
+		unsigned long not_pte :  1;
+		unsigned long dat_prot:  1;
+		unsigned long real    :  1;
+	};
+};
 
-int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
-			  unsigned long saddr, unsigned long *datptr);
+int gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+			 union mvpg_pei *datptr, bool wr);
 
 #endif /* __KVM_S390_GACCESS_H */
diff --git a/arch/s390/kvm/gmap-vsie.c b/arch/s390/kvm/gmap-vsie.c
deleted file mode 100644
index 56ef153eb8fe..000000000000
--- a/arch/s390/kvm/gmap-vsie.c
+++ /dev/null
@@ -1,141 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Guest memory management for KVM/s390 nested VMs.
- *
- * Copyright IBM Corp. 2008, 2020, 2024
- *
- *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
- *               Martin Schwidefsky <schwidefsky@de.ibm.com>
- *               David Hildenbrand <david@redhat.com>
- *               Janosch Frank <frankja@linux.vnet.ibm.com>
- */
-
-#include <linux/compiler.h>
-#include <linux/kvm.h>
-#include <linux/kvm_host.h>
-#include <linux/pgtable.h>
-#include <linux/pagemap.h>
-#include <linux/mman.h>
-
-#include <asm/lowcore.h>
-#include <asm/gmap.h>
-#include <asm/uv.h>
-
-#include "kvm-s390.h"
-
-/**
- * gmap_find_shadow - find a specific asce in the list of shadow tables
- * @parent: pointer to the parent gmap
- * @asce: ASCE for which the shadow table is created
- * @edat_level: edat level to be used for the shadow translation
- *
- * Returns the pointer to a gmap if a shadow table with the given asce is
- * already available, ERR_PTR(-EAGAIN) if another one is just being created,
- * otherwise NULL
- *
- * Context: Called with parent->shadow_lock held
- */
-static struct gmap *gmap_find_shadow(struct gmap *parent, unsigned long asce, int edat_level)
-{
-	struct gmap *sg;
-
-	lockdep_assert_held(&parent->shadow_lock);
-	list_for_each_entry(sg, &parent->children, list) {
-		if (!gmap_shadow_valid(sg, asce, edat_level))
-			continue;
-		if (!sg->initialized)
-			return ERR_PTR(-EAGAIN);
-		refcount_inc(&sg->ref_count);
-		return sg;
-	}
-	return NULL;
-}
-
-/**
- * gmap_shadow - create/find a shadow guest address space
- * @parent: pointer to the parent gmap
- * @asce: ASCE for which the shadow table is created
- * @edat_level: edat level to be used for the shadow translation
- *
- * The pages of the top level page table referred by the asce parameter
- * will be set to read-only and marked in the PGSTEs of the kvm process.
- * The shadow table will be removed automatically on any change to the
- * PTE mapping for the source table.
- *
- * Returns a guest address space structure, ERR_PTR(-ENOMEM) if out of memory,
- * ERR_PTR(-EAGAIN) if the caller has to retry and ERR_PTR(-EFAULT) if the
- * parent gmap table could not be protected.
- */
-struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce, int edat_level)
-{
-	struct gmap *sg, *new;
-	unsigned long limit;
-	int rc;
-
-	if (KVM_BUG_ON(parent->mm->context.allow_gmap_hpage_1m, (struct kvm *)parent->private) ||
-	    KVM_BUG_ON(gmap_is_shadow(parent), (struct kvm *)parent->private))
-		return ERR_PTR(-EFAULT);
-	spin_lock(&parent->shadow_lock);
-	sg = gmap_find_shadow(parent, asce, edat_level);
-	spin_unlock(&parent->shadow_lock);
-	if (sg)
-		return sg;
-	/* Create a new shadow gmap */
-	limit = -1UL >> (33 - (((asce & _ASCE_TYPE_MASK) >> 2) * 11));
-	if (asce & _ASCE_REAL_SPACE)
-		limit = -1UL;
-	new = gmap_alloc(limit);
-	if (!new)
-		return ERR_PTR(-ENOMEM);
-	new->mm = parent->mm;
-	new->parent = gmap_get(parent);
-	new->private = parent->private;
-	new->orig_asce = asce;
-	new->edat_level = edat_level;
-	new->initialized = false;
-	spin_lock(&parent->shadow_lock);
-	/* Recheck if another CPU created the same shadow */
-	sg = gmap_find_shadow(parent, asce, edat_level);
-	if (sg) {
-		spin_unlock(&parent->shadow_lock);
-		gmap_free(new);
-		return sg;
-	}
-	if (asce & _ASCE_REAL_SPACE) {
-		/* only allow one real-space gmap shadow */
-		list_for_each_entry(sg, &parent->children, list) {
-			if (sg->orig_asce & _ASCE_REAL_SPACE) {
-				spin_lock(&sg->guest_table_lock);
-				gmap_unshadow(sg);
-				spin_unlock(&sg->guest_table_lock);
-				list_del(&sg->list);
-				gmap_put(sg);
-				break;
-			}
-		}
-	}
-	refcount_set(&new->ref_count, 2);
-	list_add(&new->list, &parent->children);
-	if (asce & _ASCE_REAL_SPACE) {
-		/* nothing to protect, return right away */
-		new->initialized = true;
-		spin_unlock(&parent->shadow_lock);
-		return new;
-	}
-	spin_unlock(&parent->shadow_lock);
-	/* protect after insertion, so it will get properly invalidated */
-	mmap_read_lock(parent->mm);
-	rc = __kvm_s390_mprotect_many(parent, asce & _ASCE_ORIGIN,
-				      ((asce & _ASCE_TABLE_LENGTH) + 1),
-				      PROT_READ, GMAP_NOTIFY_SHADOW);
-	mmap_read_unlock(parent->mm);
-	spin_lock(&parent->shadow_lock);
-	new->initialized = true;
-	if (rc) {
-		list_del(&new->list);
-		gmap_free(new);
-		new = ERR_PTR(rc);
-	}
-	spin_unlock(&parent->shadow_lock);
-	return new;
-}
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 420ae62977e2..39aff324203e 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -21,6 +21,7 @@
 #include "gaccess.h"
 #include "trace.h"
 #include "trace-s390.h"
+#include "faultin.h"
 
 u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
 {
@@ -367,8 +368,11 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_s390_handle_dat_fault(vcpu, srcaddr, 0);
-	if (rc != 0)
+
+	do {
+		rc = kvm_s390_faultin_gfn_simple(vcpu, NULL, gpa_to_gfn(srcaddr), false);
+	} while (rc == -EAGAIN);
+	if (rc)
 		return rc;
 
 	/* Ensure that the source is paged-in, no actual access -> no key checking */
@@ -376,8 +380,11 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_s390_handle_dat_fault(vcpu, dstaddr, FOLL_WRITE);
-	if (rc != 0)
+
+	do {
+		rc = kvm_s390_faultin_gfn_simple(vcpu, NULL, gpa_to_gfn(dstaddr), true);
+	} while (rc == -EAGAIN);
+	if (rc)
 		return rc;
 
 	kvm_s390_retry_instr(vcpu);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 249cdc822ec5..f55eca9aa638 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -26,7 +26,6 @@
 #include <linux/uaccess.h>
 #include <asm/sclp.h>
 #include <asm/isc.h>
-#include <asm/gmap.h>
 #include <asm/nmi.h>
 #include <asm/airq.h>
 #include <asm/tpi.h>
@@ -34,6 +33,7 @@
 #include "gaccess.h"
 #include "trace-s390.h"
 #include "pci.h"
+#include "gmap.h"
 
 #define PFAULT_INIT 0x0600
 #define PFAULT_DONE 0x0680
@@ -2632,12 +2632,12 @@ static int flic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 	case KVM_DEV_FLIC_APF_ENABLE:
 		if (kvm_is_ucontrol(dev->kvm))
 			return -EINVAL;
-		dev->kvm->arch.gmap->pfault_enabled = 1;
+		set_bit(GMAP_FLAG_PFAULT_ENABLED, &dev->kvm->arch.gmap->flags);
 		break;
 	case KVM_DEV_FLIC_APF_DISABLE_WAIT:
 		if (kvm_is_ucontrol(dev->kvm))
 			return -EINVAL;
-		dev->kvm->arch.gmap->pfault_enabled = 0;
+		clear_bit(GMAP_FLAG_PFAULT_ENABLED, &dev->kvm->arch.gmap->flags);
 		/*
 		 * Make sure no async faults are in transition when
 		 * clearing the queues. So we don't need to worry
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f5411e093fb5..a714037cef31 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -40,7 +40,6 @@
 #include <asm/lowcore.h>
 #include <asm/machine.h>
 #include <asm/stp.h>
-#include <asm/gmap.h>
 #include <asm/gmap_helpers.h>
 #include <asm/nmi.h>
 #include <asm/isc.h>
@@ -53,6 +52,8 @@
 #include <asm/uv.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
+#include "gmap.h"
+#include "faultin.h"
 #include "pci.h"
 
 #define CREATE_TRACE_POINTS
@@ -264,16 +265,11 @@ static DECLARE_BITMAP(kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS)
 /* available subfunctions indicated via query / "test bit" */
 static struct kvm_s390_vm_cpu_subfunc kvm_s390_available_subfunc;
 
-static struct gmap_notifier gmap_notifier;
-static struct gmap_notifier vsie_gmap_notifier;
 debug_info_t *kvm_s390_dbf;
 debug_info_t *kvm_s390_dbf_uv;
 
 /* Section: not file related */
 /* forward declarations */
-static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
-			      unsigned long end);
-
 static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
 {
 	u8 delta_idx = 0;
@@ -529,10 +525,6 @@ static int __init __kvm_s390_init(void)
 	if (rc)
 		goto err_gib;
 
-	gmap_notifier.notifier_call = kvm_gmap_notifier;
-	gmap_register_pte_notifier(&gmap_notifier);
-	vsie_gmap_notifier.notifier_call = kvm_s390_vsie_gmap_notifier;
-	gmap_register_pte_notifier(&vsie_gmap_notifier);
 	atomic_notifier_chain_register(&s390_epoch_delta_notifier,
 				       &kvm_clock_notifier);
 
@@ -552,8 +544,6 @@ static int __init __kvm_s390_init(void)
 
 static void __kvm_s390_exit(void)
 {
-	gmap_unregister_pte_notifier(&gmap_notifier);
-	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
 	atomic_notifier_chain_unregister(&s390_epoch_delta_notifier,
 					 &kvm_clock_notifier);
 
@@ -569,7 +559,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
 	if (ioctl == KVM_S390_ENABLE_SIE)
-		return s390_enable_sie();
+		return 0;
 	return -EINVAL;
 }
 
@@ -698,32 +688,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-	int i;
-	gfn_t cur_gfn, last_gfn;
-	unsigned long gaddr, vmaddr;
-	struct gmap *gmap = kvm->arch.gmap;
-	DECLARE_BITMAP(bitmap, _PAGE_ENTRIES);
-
-	/* Loop over all guest segments */
-	cur_gfn = memslot->base_gfn;
-	last_gfn = memslot->base_gfn + memslot->npages;
-	for (; cur_gfn <= last_gfn; cur_gfn += _PAGE_ENTRIES) {
-		gaddr = gfn_to_gpa(cur_gfn);
-		vmaddr = gfn_to_hva_memslot(memslot, cur_gfn);
-		if (kvm_is_error_hva(vmaddr))
-			continue;
-
-		bitmap_zero(bitmap, _PAGE_ENTRIES);
-		gmap_sync_dirty_log_pmd(gmap, bitmap, gaddr, vmaddr);
-		for (i = 0; i < _PAGE_ENTRIES; i++) {
-			if (test_bit(i, bitmap))
-				mark_page_dirty(kvm, cur_gfn + i);
-		}
+	gfn_t last_gfn = memslot->base_gfn + memslot->npages;
 
-		if (fatal_signal_pending(current))
-			return;
-		cond_resched();
-	}
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		gmap_sync_dirty_log(kvm->arch.gmap, memslot->base_gfn, last_gfn);
 }
 
 /* Section: vm related */
@@ -883,9 +851,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			r = -EINVAL;
 		else {
 			r = 0;
-			mmap_write_lock(kvm->mm);
-			kvm->mm->context.allow_gmap_hpage_1m = 1;
-			mmap_write_unlock(kvm->mm);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -958,7 +923,7 @@ static int kvm_s390_get_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
-	unsigned int idx;
+
 	switch (attr->attr) {
 	case KVM_S390_VM_MEM_ENABLE_CMMA:
 		ret = -ENXIO;
@@ -969,8 +934,6 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus)
 			ret = -EBUSY;
-		else if (kvm->mm->context.allow_gmap_hpage_1m)
-			ret = -EINVAL;
 		else {
 			kvm->arch.use_cmma = 1;
 			/* Not compatible with cmma. */
@@ -979,7 +942,9 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		}
 		mutex_unlock(&kvm->lock);
 		break;
-	case KVM_S390_VM_MEM_CLR_CMMA:
+	case KVM_S390_VM_MEM_CLR_CMMA: {
+		gfn_t start_gfn = 0;
+
 		ret = -ENXIO;
 		if (!sclp.has_cmma)
 			break;
@@ -988,13 +953,13 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 			break;
 
 		VM_EVENT(kvm, 3, "%s", "RESET: CMMA states");
-		mutex_lock(&kvm->lock);
-		idx = srcu_read_lock(&kvm->srcu);
-		s390_reset_cmma(kvm->arch.gmap->mm);
-		srcu_read_unlock(&kvm->srcu, idx);
-		mutex_unlock(&kvm->lock);
+		do {
+			start_gfn = dat_reset_cmma(kvm->arch.gmap->asce, start_gfn);
+			cond_resched();
+		} while (start_gfn);
 		ret = 0;
 		break;
+	}
 	case KVM_S390_VM_MEM_LIMIT_SIZE: {
 		unsigned long new_limit;
 
@@ -1011,29 +976,12 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		if (!new_limit)
 			return -EINVAL;
 
-		/* gmap_create takes last usable address */
-		if (new_limit != KVM_S390_NO_MEM_LIMIT)
-			new_limit -= 1;
-
 		ret = -EBUSY;
-		mutex_lock(&kvm->lock);
-		if (!kvm->created_vcpus) {
-			/* gmap_create will round the limit up */
-			struct gmap *new = gmap_create(current->mm, new_limit);
-
-			if (!new) {
-				ret = -ENOMEM;
-			} else {
-				gmap_remove(kvm->arch.gmap);
-				new->private = kvm;
-				kvm->arch.gmap = new;
-				ret = 0;
-			}
-		}
-		mutex_unlock(&kvm->lock);
+		if (!kvm->created_vcpus)
+			ret = gmap_set_limit(kvm->arch.gmap, gpa_to_gfn(new_limit));
 		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
 		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
-			 (void *) kvm->arch.gmap->asce);
+			 (void *)kvm->arch.gmap->asce.val);
 		break;
 	}
 	default:
@@ -1198,19 +1146,13 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 		kvm->arch.migration_mode = 1;
 		return 0;
 	}
-	/* mark all the pages in active slots as dirty */
 	kvm_for_each_memslot(ms, bkt, slots) {
 		if (!ms->dirty_bitmap)
 			return -EINVAL;
-		/*
-		 * The second half of the bitmap is only used on x86,
-		 * and would be wasted otherwise, so we put it to good
-		 * use here to keep track of the state of the storage
-		 * attributes.
-		 */
-		memset(kvm_second_dirty_bitmap(ms), 0xff, kvm_dirty_bitmap_bytes(ms));
 		ram_pages += ms->npages;
 	}
+	/* mark all the pages as dirty */
+	gmap_set_cmma_all_dirty(kvm->arch.gmap);
 	atomic64_set(&kvm->arch.cmma_dirty_pages, ram_pages);
 	kvm->arch.migration_mode = 1;
 	kvm_s390_sync_request_broadcast(kvm, KVM_REQ_START_MIGRATION);
@@ -2116,40 +2058,32 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 
 static int kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 {
-	uint8_t *keys;
-	uint64_t hva;
-	int srcu_idx, i, r = 0;
+	union skey *keys;
+	int i, r = 0;
 
 	if (args->flags != 0)
 		return -EINVAL;
 
 	/* Is this guest using storage keys? */
-	if (!mm_uses_skeys(current->mm))
+	if (!uses_skeys(kvm->arch.gmap))
 		return KVM_S390_GET_SKEYS_NONE;
 
 	/* Enforce sane limit on memory allocation */
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
+	keys = kvmalloc_array(args->count, sizeof(*keys), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
-	mmap_read_lock(current->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-	for (i = 0; i < args->count; i++) {
-		hva = gfn_to_hva(kvm, args->start_gfn + i);
-		if (kvm_is_error_hva(hva)) {
-			r = -EFAULT;
-			break;
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		for (i = 0; i < args->count; i++) {
+			r = dat_get_storage_key(kvm->arch.gmap->asce,
+						args->start_gfn + i, keys + i);
+			if (r)
+				break;
 		}
-
-		r = get_guest_storage_key(current->mm, hva, &keys[i]);
-		if (r)
-			break;
 	}
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(current->mm);
 
 	if (!r) {
 		r = copy_to_user((uint8_t __user *)args->skeydata_addr, keys,
@@ -2164,10 +2098,9 @@ static int kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 
 static int kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 {
-	uint8_t *keys;
-	uint64_t hva;
-	int srcu_idx, i, r = 0;
-	bool unlocked;
+	struct kvm_s390_mmu_cache *mc;
+	union skey *keys;
+	int i, r = 0;
 
 	if (args->flags != 0)
 		return -EINVAL;
@@ -2176,7 +2109,7 @@ static int kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
+	keys = kvmalloc_array(args->count, sizeof(*keys), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
@@ -2188,159 +2121,41 @@ static int kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	}
 
 	/* Enable storage key handling for the guest */
-	r = s390_enable_skey();
+	r = gmap_enable_skeys(kvm->arch.gmap);
 	if (r)
 		goto out;
 
-	i = 0;
-	mmap_read_lock(current->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-        while (i < args->count) {
-		unlocked = false;
-		hva = gfn_to_hva(kvm, args->start_gfn + i);
-		if (kvm_is_error_hva(hva)) {
-			r = -EFAULT;
-			break;
-		}
-
+	r = -EINVAL;
+	for (i = 0; i < args->count; i++) {
 		/* Lowest order bit is reserved */
-		if (keys[i] & 0x01) {
-			r = -EINVAL;
-			break;
-		}
-
-		r = set_guest_storage_key(current->mm, hva, keys[i], 0);
-		if (r) {
-			r = fixup_user_fault(current->mm, hva,
-					     FAULT_FLAG_WRITE, &unlocked);
-			if (r)
-				break;
-		}
-		if (!r)
-			i++;
-	}
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(current->mm);
-out:
-	kvfree(keys);
-	return r;
-}
-
-/*
- * Base address and length must be sent at the start of each block, therefore
- * it's cheaper to send some clean data, as long as it's less than the size of
- * two longs.
- */
-#define KVM_S390_MAX_BIT_DISTANCE (2 * sizeof(void *))
-/* for consistency */
-#define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
-
-static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
-			      u8 *res, unsigned long bufsize)
-{
-	unsigned long pgstev, hva, cur_gfn = args->start_gfn;
-
-	args->count = 0;
-	while (args->count < bufsize) {
-		hva = gfn_to_hva(kvm, cur_gfn);
-		/*
-		 * We return an error if the first value was invalid, but we
-		 * return successfully if at least one value was copied.
-		 */
-		if (kvm_is_error_hva(hva))
-			return args->count ? 0 : -EFAULT;
-		if (get_pgste(kvm->mm, hva, &pgstev) < 0)
-			pgstev = 0;
-		res[args->count++] = (pgstev >> 24) & 0x43;
-		cur_gfn++;
+		if (keys[i].zero)
+			goto out;
 	}
 
-	return 0;
-}
-
-static struct kvm_memory_slot *gfn_to_memslot_approx(struct kvm_memslots *slots,
-						     gfn_t gfn)
-{
-	return ____gfn_to_memslot(slots, gfn, true);
-}
-
-static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
-					      unsigned long cur_gfn)
-{
-	struct kvm_memory_slot *ms = gfn_to_memslot_approx(slots, cur_gfn);
-	unsigned long ofs = cur_gfn - ms->base_gfn;
-	struct rb_node *mnode = &ms->gfn_node[slots->node_idx];
-
-	if (ms->base_gfn + ms->npages <= cur_gfn) {
-		mnode = rb_next(mnode);
-		/* If we are above the highest slot, wrap around */
-		if (!mnode)
-			mnode = rb_first(&slots->gfn_tree);
-
-		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
-		ofs = 0;
-	}
-
-	if (cur_gfn < ms->base_gfn)
-		ofs = 0;
-
-	ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, ofs);
-	while (ofs >= ms->npages && (mnode = rb_next(mnode))) {
-		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
-		ofs = find_first_bit(kvm_second_dirty_bitmap(ms), ms->npages);
+	mc = kvm_s390_new_mmu_cache();
+	if (!mc) {
+		r = -ENOMEM;
+		goto out;
 	}
-	return ms->base_gfn + ofs;
-}
 
-static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
-			     u8 *res, unsigned long bufsize)
-{
-	unsigned long mem_end, cur_gfn, next_gfn, hva, pgstev;
-	struct kvm_memslots *slots = kvm_memslots(kvm);
-	struct kvm_memory_slot *ms;
-
-	if (unlikely(kvm_memslots_empty(slots)))
-		return 0;
-
-	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
-	ms = gfn_to_memslot(kvm, cur_gfn);
-	args->count = 0;
-	args->start_gfn = cur_gfn;
-	if (!ms)
-		return 0;
-	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-	mem_end = kvm_s390_get_gfn_end(slots);
-
-	while (args->count < bufsize) {
-		hva = gfn_to_hva(kvm, cur_gfn);
-		if (kvm_is_error_hva(hva))
-			return 0;
-		/* Decrement only if we actually flipped the bit to 0 */
-		if (test_and_clear_bit(cur_gfn - ms->base_gfn, kvm_second_dirty_bitmap(ms)))
-			atomic64_dec(&kvm->arch.cmma_dirty_pages);
-		if (get_pgste(kvm->mm, hva, &pgstev) < 0)
-			pgstev = 0;
-		/* Save the value */
-		res[args->count++] = (pgstev >> 24) & 0x43;
-		/* If the next bit is too far away, stop. */
-		if (next_gfn > cur_gfn + KVM_S390_MAX_BIT_DISTANCE)
-			return 0;
-		/* If we reached the previous "next", find the next one */
-		if (cur_gfn == next_gfn)
-			next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-		/* Reached the end of memory or of the buffer, stop */
-		if ((next_gfn >= mem_end) ||
-		    (next_gfn - args->start_gfn >= bufsize))
-			return 0;
-		cur_gfn++;
-		/* Reached the end of the current memslot, take the next one. */
-		if (cur_gfn - ms->base_gfn >= ms->npages) {
-			ms = gfn_to_memslot(kvm, cur_gfn);
-			if (!ms)
-				return 0;
+	r = 0;
+	do {
+		r = kvm_s390_mmu_cache_topup(mc);
+		if (r == -ENOMEM)
+			break;
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			for (i = 0 ; i < args->count; i++) {
+				r = dat_set_storage_key(mc, kvm->arch.gmap->asce,
+							args->start_gfn + i, keys[i], 0);
+				if (r)
+					break;
+			}
 		}
-	}
-	return 0;
+	} while (r == -ENOMEM);
+	kvm_s390_free_mmu_cache(mc);
+out:
+	kvfree(keys);
+	return r;
 }
 
 /*
@@ -2354,8 +2169,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 				  struct kvm_s390_cmma_log *args)
 {
-	unsigned long bufsize;
-	int srcu_idx, peek, ret;
+	int peek, ret;
 	u8 *values;
 
 	if (!kvm->arch.use_cmma)
@@ -2368,8 +2182,8 @@ static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 	if (!peek && !kvm->arch.migration_mode)
 		return -EINVAL;
 	/* CMMA is disabled or was not used, or the buffer has length zero */
-	bufsize = min(args->count, KVM_S390_CMMA_SIZE_MAX);
-	if (!bufsize || !kvm->mm->context.uses_cmm) {
+	args->count = min(args->count, KVM_S390_CMMA_SIZE_MAX);
+	if (!args->count || !uses_cmm(kvm->arch.gmap)) {
 		memset(args, 0, sizeof(*args));
 		return 0;
 	}
@@ -2379,18 +2193,18 @@ static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 		return 0;
 	}
 
-	values = vmalloc(bufsize);
+	values = vmalloc(args->count);
 	if (!values)
 		return -ENOMEM;
 
-	mmap_read_lock(kvm->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-	if (peek)
-		ret = kvm_s390_peek_cmma(kvm, args, values, bufsize);
-	else
-		ret = kvm_s390_get_cmma(kvm, args, values, bufsize);
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(kvm->mm);
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (peek)
+			ret = dat_peek_cmma(args->start_gfn, kvm->arch.gmap->asce, &args->count,
+					    values);
+		else
+			ret = dat_get_cmma(kvm->arch.gmap->asce, &args->start_gfn, &args->count,
+					   values, &kvm->arch.cmma_dirty_pages);
+	}
 
 	if (kvm->arch.migration_mode)
 		args->remaining = atomic64_read(&kvm->arch.cmma_dirty_pages);
@@ -2412,11 +2226,9 @@ static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 				  const struct kvm_s390_cmma_log *args)
 {
-	unsigned long hva, mask, pgstev, i;
-	uint8_t *bits;
-	int srcu_idx, r = 0;
-
-	mask = args->mask;
+	struct kvm_s390_mmu_cache *mc;
+	u8 *bits = NULL;
+	int r = 0;
 
 	if (!kvm->arch.use_cmma)
 		return -ENXIO;
@@ -2430,9 +2242,12 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	if (args->count == 0)
 		return 0;
 
+	mc = kvm_s390_new_mmu_cache();
+	if (!mc)
+		return -ENOMEM;
 	bits = vmalloc(array_size(sizeof(*bits), args->count));
 	if (!bits)
-		return -ENOMEM;
+		goto out;
 
 	r = copy_from_user(bits, (void __user *)args->values, args->count);
 	if (r) {
@@ -2440,29 +2255,19 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 		goto out;
 	}
 
-	mmap_read_lock(kvm->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-	for (i = 0; i < args->count; i++) {
-		hva = gfn_to_hva(kvm, args->start_gfn + i);
-		if (kvm_is_error_hva(hva)) {
-			r = -EFAULT;
+	do {
+		r = kvm_s390_mmu_cache_topup(mc);
+		if (r)
 			break;
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			r = dat_set_cmma_bits(mc, kvm->arch.gmap->asce, args->start_gfn,
+					      args->count, args->mask, bits);
 		}
+	} while (r == -ENOMEM);
 
-		pgstev = bits[i];
-		pgstev = pgstev << 24;
-		mask &= _PGSTE_GPS_USAGE_MASK | _PGSTE_GPS_NODAT;
-		set_pgste_bits(kvm->mm, hva, mask, pgstev);
-	}
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(kvm->mm);
-
-	if (!kvm->mm->context.uses_cmm) {
-		mmap_write_lock(kvm->mm);
-		kvm->mm->context.uses_cmm = 1;
-		mmap_write_unlock(kvm->mm);
-	}
+	set_bit(GMAP_FLAG_USES_CMM, &kvm->arch.gmap->flags);
 out:
+	kvm_s390_free_mmu_cache(mc);
 	vfree(bits);
 	return r;
 }
@@ -2671,6 +2476,13 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			break;
 
 		mmap_write_lock(kvm->mm);
+		/*
+		 * Disable creation of new THPs. Existing THPs can stay, they
+		 * will be split when any part of them gets imported.
+		 */
+		mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, kvm->mm);
+		mm_flags_set(MMF_DISABLE_THP_COMPLETELY, kvm->mm);
+		set_bit(GMAP_FLAG_EXPORT_ON_UNMAP, &kvm->arch.gmap->flags);
 		r = gmap_helper_disable_cow_sharing();
 		mmap_write_unlock(kvm->mm);
 		if (r)
@@ -2918,9 +2730,6 @@ static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 	acc_mode = mop->op == KVM_S390_MEMOP_ABSOLUTE_READ ? GACC_FETCH : GACC_STORE;
 
 	scoped_guard(srcu, &kvm->srcu) {
-		if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr))
-			return PGM_ADDRESSING;
-
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)
 			return check_gpa_range(kvm, mop->gaddr, mop->size, acc_mode, mop->key);
 
@@ -2933,7 +2742,6 @@ static int kvm_s390_vm_mem_op_abs(struct kvm *kvm, struct kvm_s390_mem_op *mop)
 		if (acc_mode != GACC_STORE && copy_to_user(uaddr, tmpbuf, mop->size))
 			return -EFAULT;
 	}
-
 	return 0;
 }
 
@@ -2962,9 +2770,6 @@ static int kvm_s390_vm_mem_op_cmpxchg(struct kvm *kvm, struct kvm_s390_mem_op *m
 		return -EFAULT;
 
 	scoped_guard(srcu, &kvm->srcu) {
-		if (!kvm_is_gpa_in_memslot(kvm, mop->gaddr))
-			return PGM_ADDRESSING;
-
 		r = cmpxchg_guest_abs_with_key(kvm, mop->gaddr, mop->size, &old, new,
 					       mop->key, &success);
 
@@ -3322,11 +3127,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		goto out_err;
 #endif
-
-	rc = s390_enable_sie();
-	if (rc)
-		goto out_err;
-
 	rc = -ENOMEM;
 
 	if (!sclp.has_64bscao)
@@ -3400,6 +3200,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	debug_register_view(kvm->arch.dbf, &debug_sprintf_view);
 	VM_EVENT(kvm, 3, "vm created with type %lu", type);
 
+	kvm->arch.mem_limit = type & KVM_VM_S390_UCONTROL ? KVM_S390_NO_MEM_LIMIT : sclp.hamax + 1;
+	kvm->arch.gmap = gmap_new(kvm, gpa_to_gfn(kvm->arch.mem_limit));
+	if (!kvm->arch.gmap)
+		goto out_err;
+	clear_bit(GMAP_FLAG_PFAULT_ENABLED, &kvm->arch.gmap->flags);
+
 	if (type & KVM_VM_S390_UCONTROL) {
 		struct kvm_userspace_memory_region2 fake_memslot = {
 			.slot = KVM_S390_UCONTROL_MEMSLOT,
@@ -3409,23 +3215,15 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 			.flags = 0,
 		};
 
-		kvm->arch.gmap = NULL;
-		kvm->arch.mem_limit = KVM_S390_NO_MEM_LIMIT;
 		/* one flat fake memslot covering the whole address-space */
 		mutex_lock(&kvm->slots_lock);
 		KVM_BUG_ON(kvm_set_internal_memslot(kvm, &fake_memslot), kvm);
 		mutex_unlock(&kvm->slots_lock);
+		set_bit(GMAP_FLAG_IS_UCONTROL, &kvm->arch.gmap->flags);
 	} else {
-		if (sclp.hamax == U64_MAX)
-			kvm->arch.mem_limit = TASK_SIZE_MAX;
-		else
-			kvm->arch.mem_limit = min_t(unsigned long, TASK_SIZE_MAX,
-						    sclp.hamax + 1);
-		kvm->arch.gmap = gmap_create(current->mm, kvm->arch.mem_limit - 1);
-		if (!kvm->arch.gmap)
-			goto out_err;
-		kvm->arch.gmap->private = kvm;
-		kvm->arch.gmap->pfault_enabled = 0;
+		struct crst_table *table = dereference_asce(kvm->arch.gmap->asce);
+
+		crst_table_init((void *)table, _CRSTE_HOLE(table->crstes[0].h.tt).val);
 	}
 
 	kvm->arch.use_pfmfi = sclp.has_pfmfi;
@@ -3459,8 +3257,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 		sca_del_vcpu(vcpu);
 	kvm_s390_update_topology_change_report(vcpu->kvm, 1);
 
-	if (kvm_is_ucontrol(vcpu->kvm))
-		gmap_remove(vcpu->arch.gmap);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		scoped_guard(spinlock, &vcpu->kvm->arch.gmap->children_lock)
+			gmap_remove_child(vcpu->arch.gmap);
+		vcpu->arch.gmap = gmap_put(vcpu->arch.gmap);
+	}
 
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
@@ -3468,6 +3269,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (kvm_s390_pv_cpu_get_handle(vcpu))
 		kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc);
 	free_page((unsigned long)(vcpu->arch.sie_block));
+	kvm_s390_free_mmu_cache(vcpu->arch.mc);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
@@ -3494,25 +3296,14 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
-	if (!kvm_is_ucontrol(kvm))
-		gmap_remove(kvm->arch.gmap);
 	kvm_s390_destroy_adapters(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
+	kvm->arch.gmap = gmap_put(kvm->arch.gmap);
 	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
 }
 
 /* Section: vcpu related */
-static int __kvm_ucontrol_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.gmap = gmap_create(current->mm, -1UL);
-	if (!vcpu->arch.gmap)
-		return -ENOMEM;
-	vcpu->arch.gmap->private = vcpu->kvm;
-
-	return 0;
-}
-
 static void sca_del_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct esca_block *sca = vcpu->kvm->arch.sca;
@@ -3853,9 +3644,15 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
+	vcpu->arch.mc = kvm_s390_new_mmu_cache();
+	if (!vcpu->arch.mc)
+		return -ENOMEM;
 	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!sie_page)
+	if (!sie_page) {
+		kvm_s390_free_mmu_cache(vcpu->arch.mc);
+		vcpu->arch.mc = NULL;
 		return -ENOMEM;
+	}
 
 	vcpu->arch.sie_block = &sie_page->sie_block;
 	vcpu->arch.sie_block->itdba = virt_to_phys(&sie_page->itdb);
@@ -3897,8 +3694,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		vcpu->run->kvm_valid_regs |= KVM_SYNC_FPRS;
 
 	if (kvm_is_ucontrol(vcpu->kvm)) {
-		rc = __kvm_ucontrol_vcpu_init(vcpu);
-		if (rc)
+		rc = -ENOMEM;
+		vcpu->arch.gmap = gmap_new_child(vcpu->kvm->arch.gmap, -1UL);
+		if (!vcpu->arch.gmap)
 			goto out_free_sie_block;
 	}
 
@@ -3914,8 +3712,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 
 out_ucontrol_uninit:
-	if (kvm_is_ucontrol(vcpu->kvm))
-		gmap_remove(vcpu->arch.gmap);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		gmap_remove_child(vcpu->arch.gmap);
+		vcpu->arch.gmap = gmap_put(vcpu->arch.gmap);
+	}
 out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
 	return rc;
@@ -3979,32 +3779,6 @@ void kvm_s390_sync_request(int req, struct kvm_vcpu *vcpu)
 	kvm_s390_vcpu_request(vcpu);
 }
 
-static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
-			      unsigned long end)
-{
-	struct kvm *kvm = gmap->private;
-	struct kvm_vcpu *vcpu;
-	unsigned long prefix;
-	unsigned long i;
-
-	trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
-
-	if (gmap_is_shadow(gmap))
-		return;
-	if (start >= 1UL << 31)
-		/* We are only interested in prefix pages */
-		return;
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		/* match against both prefix pages */
-		prefix = kvm_s390_get_prefix(vcpu);
-		if (prefix <= end && start <= prefix + 2*PAGE_SIZE - 1) {
-			VCPU_EVENT(vcpu, 2, "gmap notifier for %lx-%lx",
-				   start, end);
-			kvm_s390_sync_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
-		}
-	}
-}
-
 bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
@@ -4386,72 +4160,53 @@ static bool ibs_enabled(struct kvm_vcpu *vcpu)
 	return kvm_s390_test_cpuflags(vcpu, CPUSTAT_IBS);
 }
 
-static int __kvm_s390_fixup_fault_sync(struct gmap *gmap, gpa_t gaddr, unsigned int flags)
-{
-	struct kvm *kvm = gmap->private;
-	gfn_t gfn = gpa_to_gfn(gaddr);
-	bool unlocked;
-	hva_t vmaddr;
-	gpa_t tmp;
-	int rc;
-
-	if (kvm_is_ucontrol(kvm)) {
-		tmp = __gmap_translate(gmap, gaddr);
-		gfn = gpa_to_gfn(tmp);
-	}
-
-	vmaddr = gfn_to_hva(kvm, gfn);
-	rc = fixup_user_fault(gmap->mm, vmaddr, FAULT_FLAG_WRITE, &unlocked);
-	if (!rc)
-		rc = __gmap_link(gmap, gaddr, vmaddr);
-	return rc;
-}
-
-/**
- * __kvm_s390_mprotect_many() - Apply specified protection to guest pages
- * @gmap: the gmap of the guest
- * @gpa: the starting guest address
- * @npages: how many pages to protect
- * @prot: indicates access rights: PROT_NONE, PROT_READ or PROT_WRITE
- * @bits: pgste notification bits to set
- *
- * Returns: 0 in case of success, < 0 in case of error - see gmap_protect_one()
- *
- * Context: kvm->srcu and gmap->mm need to be held in read mode
- */
-int __kvm_s390_mprotect_many(struct gmap *gmap, gpa_t gpa, u8 npages, unsigned int prot,
-			     unsigned long bits)
+static int vcpu_ucontrol_translate(struct kvm_vcpu *vcpu, gpa_t *gaddr)
 {
-	unsigned int fault_flag = (prot & PROT_WRITE) ? FAULT_FLAG_WRITE : 0;
-	gpa_t end = gpa + npages * PAGE_SIZE;
+	union crste *crstep;
+	union pte *ptep;
 	int rc;
 
-	for (; gpa < end; gpa = ALIGN(gpa + 1, rc)) {
-		rc = gmap_protect_one(gmap, gpa, prot, bits);
-		if (rc == -EAGAIN) {
-			__kvm_s390_fixup_fault_sync(gmap, gpa, fault_flag);
-			rc = gmap_protect_one(gmap, gpa, prot, bits);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		/*
+		 * This translates the per-vCPU guest address into a
+		 * fake guest address, which can then be used with the
+		 * fake memslots that are identity mapping userspace.
+		 * This allows ucontrol VMs to use the normal fault
+		 * resolution path, like normal VMs.
+		 */
+		rc = dat_entry_walk(NULL, gpa_to_gfn(*gaddr), vcpu->arch.gmap->asce,
+				    0, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
+		if (rc) {
+			vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
+			vcpu->run->s390_ucontrol.trans_exc_code = *gaddr;
+			vcpu->run->s390_ucontrol.pgm_code = PGM_SEGMENT_TRANSLATION;
+			return -EREMOTE;
 		}
-		if (rc < 0)
-			return rc;
+		*gaddr &= ~_SEGMENT_MASK;
+		*gaddr |= dat_get_ptval(pte_table_start(ptep), PTVAL_VMADDR) << _SEGMENT_SHIFT;
 	}
-
 	return 0;
 }
 
-static int kvm_s390_mprotect_notify_prefix(struct kvm_vcpu *vcpu)
+static int kvm_s390_fixup_prefix(struct kvm_vcpu *vcpu)
 {
 	gpa_t gaddr = kvm_s390_get_prefix(vcpu);
-	int idx, rc;
-
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	mmap_read_lock(vcpu->arch.gmap->mm);
+	gfn_t gfn;
+	int rc;
 
-	rc = __kvm_s390_mprotect_many(vcpu->arch.gmap, gaddr, 2, PROT_WRITE, GMAP_NOTIFY_MPROT);
+	if (vcpu_ucontrol_translate(vcpu, &gaddr))
+		return -EREMOTE;
+	gfn = gpa_to_gfn(gaddr);
 
-	mmap_read_unlock(vcpu->arch.gmap->mm);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	rc = kvm_s390_faultin_gfn_simple(vcpu, NULL, gfn, true);
+	if (rc)
+		return rc;
+	rc = kvm_s390_faultin_gfn_simple(vcpu, NULL, gfn + 1, true);
+	if (rc)
+		return rc;
 
+	scoped_guard(write_lock, &vcpu->kvm->mmu_lock)
+		rc = dat_set_prefix_notif_bit(vcpu->kvm->arch.gmap->asce, gfn);
 	return rc;
 }
 
@@ -4471,7 +4226,7 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	if (kvm_check_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu)) {
 		int rc;
 
-		rc = kvm_s390_mprotect_notify_prefix(vcpu);
+		rc = kvm_s390_fixup_prefix(vcpu);
 		if (rc) {
 			kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
 			return rc;
@@ -4520,8 +4275,7 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 		 * Re-enable CMM virtualization if CMMA is available and
 		 * CMM has been used.
 		 */
-		if ((vcpu->kvm->arch.use_cmma) &&
-		    (vcpu->kvm->mm->context.uses_cmm))
+		if (vcpu->kvm->arch.use_cmma && uses_cmm(vcpu->arch.gmap))
 			vcpu->arch.sie_block->ecb2 |= ECB2_CMMA;
 		goto retry;
 	}
@@ -4633,7 +4387,7 @@ bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
 		return false;
 	if (!(vcpu->arch.sie_block->gcr[0] & CR0_SERVICE_SIGNAL_SUBMASK))
 		return false;
-	if (!vcpu->arch.gmap->pfault_enabled)
+	if (!pfault_enabled(vcpu->arch.gmap))
 		return false;
 
 	hva = gfn_to_hva(vcpu->kvm, current->thread.gmap_teid.addr);
@@ -4726,98 +4480,25 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
 		current->thread.gmap_int_code, current->thread.gmap_teid.val);
 }
 
-/*
- * __kvm_s390_handle_dat_fault() - handle a dat fault for the gmap of a vcpu
- * @vcpu: the vCPU whose gmap is to be fixed up
- * @gfn: the guest frame number used for memslots (including fake memslots)
- * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
- * @foll: FOLL_* flags
- *
- * Return: 0 on success, < 0 in case of error.
- * Context: The mm lock must not be held before calling. May sleep.
- */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int foll)
-{
-	struct kvm_memory_slot *slot;
-	unsigned int fault_flags;
-	bool writable, unlocked;
-	unsigned long vmaddr;
-	struct page *page;
-	kvm_pfn_t pfn;
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, gpa_t gaddr, bool wr)
+{
+	struct guest_fault f = {
+		.write_attempt = wr,
+		.attempt_pfault = pfault_enabled(vcpu->arch.gmap),
+	};
 	int rc;
 
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
-		return vcpu_post_run_addressing_exception(vcpu);
-
-	fault_flags = foll & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
-	if (vcpu->arch.gmap->pfault_enabled)
-		foll |= FOLL_NOWAIT;
-	vmaddr = __gfn_to_hva_memslot(slot, gfn);
-
-try_again:
-	pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
+	if (vcpu_ucontrol_translate(vcpu, &gaddr))
+		return -EREMOTE;
+	f.gfn = gpa_to_gfn(gaddr);
 
-	/* Access outside memory, inject addressing exception */
-	if (is_noslot_pfn(pfn))
+	rc = kvm_s390_faultin_gfn(vcpu, NULL, &f);
+	if (rc <= 0)
+		return rc;
+	if (rc == PGM_ADDRESSING)
 		return vcpu_post_run_addressing_exception(vcpu);
-	/* Signal pending: try again */
-	if (pfn == KVM_PFN_ERR_SIGPENDING)
-		return -EAGAIN;
-
-	/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT) */
-	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
-		trace_kvm_s390_major_guest_pfault(vcpu);
-		if (kvm_arch_setup_async_pf(vcpu))
-			return 0;
-		vcpu->stat.pfault_sync++;
-		/* Could not setup async pfault, try again synchronously */
-		foll &= ~FOLL_NOWAIT;
-		goto try_again;
-	}
-	/* Any other error */
-	if (is_error_pfn(pfn))
-		return -EFAULT;
-
-	/* Success */
-	mmap_read_lock(vcpu->arch.gmap->mm);
-	/* Mark the userspace PTEs as young and/or dirty, to avoid page fault loops */
-	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
-	if (!rc)
-		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
-	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
-		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
-	}
-	mmap_read_unlock(vcpu->arch.gmap->mm);
-	return rc;
-}
-
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int foll)
-{
-	unsigned long gaddr_tmp;
-	gfn_t gfn;
-
-	gfn = gpa_to_gfn(gaddr);
-	if (kvm_is_ucontrol(vcpu->kvm)) {
-		/*
-		 * This translates the per-vCPU guest address into a
-		 * fake guest address, which can then be used with the
-		 * fake memslots that are identity mapping userspace.
-		 * This allows ucontrol VMs to use the normal fault
-		 * resolution path, like normal VMs.
-		 */
-		mmap_read_lock(vcpu->arch.gmap->mm);
-		gaddr_tmp = __gmap_translate(vcpu->arch.gmap, gaddr);
-		mmap_read_unlock(vcpu->arch.gmap->mm);
-		if (gaddr_tmp == -EFAULT) {
-			vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
-			vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
-			vcpu->run->s390_ucontrol.pgm_code = PGM_SEGMENT_TRANSLATION;
-			return -EREMOTE;
-		}
-		gfn = gpa_to_gfn(gaddr_tmp);
-	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, foll);
+	KVM_BUG_ON(rc, vcpu->kvm);
+	return -EINVAL;
 }
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
@@ -4994,7 +4675,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 		exit_reason = kvm_s390_enter_exit_sie(vcpu->arch.sie_block,
 						      vcpu->run->s.regs.gprs,
-						      vcpu->arch.gmap->asce);
+						      vcpu->arch.gmap->asce.val);
 
 		__enable_cpu_timer_accounting(vcpu);
 		guest_timing_exit_irqoff();
@@ -5529,8 +5210,8 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
 				 struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	void *tmpbuf __free(kvfree) = NULL;
 	enum gacc_mode acc_mode;
-	void *tmpbuf = NULL;
 	int r;
 
 	r = mem_op_validate_common(mop, KVM_S390_MEMOP_F_INJECT_EXCEPTION |
@@ -5552,32 +5233,21 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
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
 
@@ -5767,37 +5437,39 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #ifdef CONFIG_KVM_S390_UCONTROL
 	case KVM_S390_UCAS_MAP: {
-		struct kvm_s390_ucas_mapping ucasmap;
+		struct kvm_s390_ucas_mapping ucas;
 
-		if (copy_from_user(&ucasmap, argp, sizeof(ucasmap))) {
-			r = -EFAULT;
+		r = -EFAULT;
+		if (copy_from_user(&ucas, argp, sizeof(ucas)))
 			break;
-		}
 
-		if (!kvm_is_ucontrol(vcpu->kvm)) {
-			r = -EINVAL;
+		r = -EINVAL;
+		if (!kvm_is_ucontrol(vcpu->kvm))
+			break;
+		if (!IS_ALIGNED(ucas.user_addr | ucas.vcpu_addr | ucas.length, _SEGMENT_SIZE))
 			break;
-		}
 
-		r = gmap_map_segment(vcpu->arch.gmap, ucasmap.user_addr,
-				     ucasmap.vcpu_addr, ucasmap.length);
+		r = gmap_ucas_map(vcpu->arch.gmap, gpa_to_gfn(ucas.user_addr),
+				  gpa_to_gfn(ucas.vcpu_addr),
+				  ucas.length >> _SEGMENT_SHIFT);
 		break;
 	}
 	case KVM_S390_UCAS_UNMAP: {
-		struct kvm_s390_ucas_mapping ucasmap;
+		struct kvm_s390_ucas_mapping ucas;
 
-		if (copy_from_user(&ucasmap, argp, sizeof(ucasmap))) {
-			r = -EFAULT;
+		r = -EFAULT;
+		if (copy_from_user(&ucas, argp, sizeof(ucas)))
 			break;
-		}
 
-		if (!kvm_is_ucontrol(vcpu->kvm)) {
-			r = -EINVAL;
+		r = -EINVAL;
+		if (!kvm_is_ucontrol(vcpu->kvm))
+			break;
+		if (!IS_ALIGNED(ucas.vcpu_addr | ucas.length, _SEGMENT_SIZE))
 			break;
-		}
 
-		r = gmap_unmap_segment(vcpu->arch.gmap, ucasmap.vcpu_addr,
-			ucasmap.length);
+		gmap_ucas_unmap(vcpu->arch.gmap, gpa_to_gfn(ucas.vcpu_addr),
+				ucas.length >> _SEGMENT_SHIFT);
+		r = 0;
 		break;
 	}
 #endif
@@ -5970,34 +5642,39 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
+	struct kvm_s390_mmu_cache *mc = NULL;
 	int rc = 0;
 
-	if (kvm_is_ucontrol(kvm))
+	if (change == KVM_MR_FLAGS_ONLY)
 		return;
 
+	mc = kvm_s390_new_mmu_cache();
+	if (!mc) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	switch (change) {
 	case KVM_MR_DELETE:
-		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
-					old->npages * PAGE_SIZE);
+		rc = dat_delete_slot(mc, kvm->arch.gmap->asce, old->base_gfn, old->npages);
 		break;
 	case KVM_MR_MOVE:
-		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
-					old->npages * PAGE_SIZE);
+		rc = dat_delete_slot(mc, kvm->arch.gmap->asce, old->base_gfn, old->npages);
 		if (rc)
 			break;
 		fallthrough;
 	case KVM_MR_CREATE:
-		rc = gmap_map_segment(kvm->arch.gmap, new->userspace_addr,
-				      new->base_gfn * PAGE_SIZE,
-				      new->npages * PAGE_SIZE);
+		rc = dat_create_slot(mc, kvm->arch.gmap->asce, new->base_gfn, new->npages);
 		break;
 	case KVM_MR_FLAGS_ONLY:
 		break;
 	default:
 		WARN(1, "Unknown KVM MR CHANGE: %d\n", change);
 	}
+out:
 	if (rc)
 		pr_warn("failed to commit memory region\n");
+	kvm_s390_free_mmu_cache(mc);
 	return;
 }
 
@@ -6011,7 +5688,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
  */
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return false;
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		return dat_test_age_gfn(kvm->arch.gmap->asce, range->start, range->end);
 }
 
 /**
@@ -6024,7 +5702,8 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
  */
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return false;
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		return gmap_age_gfn(kvm->arch.gmap, range->start, range->end);
 }
 
 /**
@@ -6041,7 +5720,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
  */
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return false;
+	return gmap_unmap_gfn_range(kvm->arch.gmap, range->slot, range->start, range->end);
 }
 
 static inline unsigned long nonhyp_mask(int i)
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c44c52266e26..bf1d7798c1af 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -19,6 +19,8 @@
 #include <asm/facility.h>
 #include <asm/processor.h>
 #include <asm/sclp.h>
+#include "dat.h"
+#include "gmap.h"
 
 #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
 
@@ -114,9 +116,7 @@ static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 static inline int kvm_is_ucontrol(struct kvm *kvm)
 {
 #ifdef CONFIG_KVM_S390_UCONTROL
-	if (kvm->arch.gmap)
-		return 0;
-	return 1;
+	return test_bit(GMAP_FLAG_IS_UCONTROL, &kvm->arch.gmap->flags);
 #else
 	return 0;
 #endif
@@ -440,14 +440,9 @@ int kvm_s390_skey_check_enable(struct kvm_vcpu *vcpu);
 /* implemented in vsie.c */
 int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu);
 void kvm_s390_vsie_kick(struct kvm_vcpu *vcpu);
-void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
-				 unsigned long end);
+void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, gpa_t start, gpa_t end);
 void kvm_s390_vsie_init(struct kvm *kvm);
 void kvm_s390_vsie_destroy(struct kvm *kvm);
-int gmap_shadow_valid(struct gmap *sg, unsigned long asce, int edat_level);
-
-/* implemented in gmap-vsie.c */
-struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce, int edat_level);
 
 /* implemented in sigp.c */
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
@@ -469,15 +464,9 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
 int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
 int __kvm_s390_mprotect_many(struct gmap *gmap, gpa_t gpa, u8 npages, unsigned int prot,
 			     unsigned long bits);
 
-static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
-{
-	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
-}
-
 bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu);
 
 /* implemented in diag.c */
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 0b14d894f38a..a3250ad83a8e 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -21,13 +21,14 @@
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
 #include <asm/page-states.h>
-#include <asm/gmap.h>
 #include <asm/ptrace.h>
 #include <asm/sclp.h>
 #include <asm/ap.h>
+#include <asm/gmap_helpers.h>
 #include "gaccess.h"
 #include "kvm-s390.h"
 #include "trace.h"
+#include "gmap.h"
 
 static int handle_ri(struct kvm_vcpu *vcpu)
 {
@@ -222,7 +223,7 @@ int kvm_s390_skey_check_enable(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.skey_enabled)
 		return 0;
 
-	rc = s390_enable_skey();
+	rc = gmap_enable_skeys(vcpu->arch.gmap);
 	VCPU_EVENT(vcpu, 3, "enabling storage keys for guest: %d", rc);
 	if (rc)
 		return rc;
@@ -255,10 +256,9 @@ static int try_handle_skey(struct kvm_vcpu *vcpu)
 
 static int handle_iske(struct kvm_vcpu *vcpu)
 {
-	unsigned long gaddr, vmaddr;
-	unsigned char key;
+	unsigned long gaddr;
 	int reg1, reg2;
-	bool unlocked;
+	union skey key;
 	int rc;
 
 	vcpu->stat.instruction_iske++;
@@ -275,37 +275,21 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
 	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
-	if (kvm_is_error_hva(vmaddr))
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-retry:
-	unlocked = false;
-	mmap_read_lock(current->mm);
-	rc = get_guest_storage_key(current->mm, vmaddr, &key);
-
-	if (rc) {
-		rc = fixup_user_fault(current->mm, vmaddr,
-				      FAULT_FLAG_WRITE, &unlocked);
-		if (!rc) {
-			mmap_read_unlock(current->mm);
-			goto retry;
-		}
-	}
-	mmap_read_unlock(current->mm);
-	if (rc == -EFAULT)
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		rc = dat_get_storage_key(vcpu->arch.gmap->asce, gpa_to_gfn(gaddr), &key);
+	if (rc > 0)
+		return kvm_s390_inject_program_int(vcpu, rc);
 	if (rc < 0)
 		return rc;
 	vcpu->run->s.regs.gprs[reg1] &= ~0xff;
-	vcpu->run->s.regs.gprs[reg1] |= key;
+	vcpu->run->s.regs.gprs[reg1] |= key.skey;
 	return 0;
 }
 
 static int handle_rrbe(struct kvm_vcpu *vcpu)
 {
-	unsigned long vmaddr, gaddr;
+	unsigned long gaddr;
 	int reg1, reg2;
-	bool unlocked;
 	int rc;
 
 	vcpu->stat.instruction_rrbe++;
@@ -322,24 +306,10 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
 	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
-	if (kvm_is_error_hva(vmaddr))
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-retry:
-	unlocked = false;
-	mmap_read_lock(current->mm);
-	rc = reset_guest_reference_bit(current->mm, vmaddr);
-	if (rc < 0) {
-		rc = fixup_user_fault(current->mm, vmaddr,
-				      FAULT_FLAG_WRITE, &unlocked);
-		if (!rc) {
-			mmap_read_unlock(current->mm);
-			goto retry;
-		}
-	}
-	mmap_read_unlock(current->mm);
-	if (rc == -EFAULT)
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		rc = dat_reset_reference_bit(vcpu->arch.gmap->asce, gpa_to_gfn(gaddr));
+	if (rc > 0)
+		return kvm_s390_inject_program_int(vcpu, rc);
 	if (rc < 0)
 		return rc;
 	kvm_s390_set_psw_cc(vcpu, rc);
@@ -354,9 +324,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 {
 	unsigned char m3 = vcpu->arch.sie_block->ipb >> 28;
 	unsigned long start, end;
-	unsigned char key, oldkey;
+	union skey key, oldkey;
 	int reg1, reg2;
-	bool unlocked;
 	int rc;
 
 	vcpu->stat.instruction_sske++;
@@ -377,7 +346,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
-	key = vcpu->run->s.regs.gprs[reg1] & 0xfe;
+	key.skey = vcpu->run->s.regs.gprs[reg1] & 0xfe;
 	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	start = kvm_s390_logical_to_effective(vcpu, start);
 	if (m3 & SSKE_MB) {
@@ -389,27 +358,17 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 	}
 
 	while (start != end) {
-		unsigned long vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
-		unlocked = false;
-
-		if (kvm_is_error_hva(vmaddr))
-			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-
-		mmap_read_lock(current->mm);
-		rc = cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,
-						m3 & SSKE_NQ, m3 & SSKE_MR,
-						m3 & SSKE_MC);
-
-		if (rc < 0) {
-			rc = fixup_user_fault(current->mm, vmaddr,
-					      FAULT_FLAG_WRITE, &unlocked);
-			rc = !rc ? -EAGAIN : rc;
+		scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
+			rc = dat_cond_set_storage_key(vcpu->arch.mc, vcpu->arch.gmap->asce,
+						      gpa_to_gfn(start), key, &oldkey,
+						      m3 & SSKE_NQ, m3 & SSKE_MR, m3 & SSKE_MC);
 		}
-		mmap_read_unlock(current->mm);
-		if (rc == -EFAULT)
+		if (rc > 1)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-		if (rc == -EAGAIN)
+		if (rc == -ENOMEM) {
+			kvm_s390_mmu_cache_topup(vcpu->arch.mc);
 			continue;
+		}
 		if (rc < 0)
 			return rc;
 		start += PAGE_SIZE;
@@ -422,7 +381,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 		} else {
 			kvm_s390_set_psw_cc(vcpu, rc);
 			vcpu->run->s.regs.gprs[reg1] &= ~0xff00UL;
-			vcpu->run->s.regs.gprs[reg1] |= (u64) oldkey << 8;
+			vcpu->run->s.regs.gprs[reg1] |= (u64)oldkey.skey << 8;
 		}
 	}
 	if (m3 & SSKE_MB) {
@@ -1082,7 +1041,7 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	bool mr = false, mc = false, nq;
 	int reg1, reg2;
 	unsigned long start, end;
-	unsigned char key;
+	union skey key;
 
 	vcpu->stat.instruction_pfmf++;
 
@@ -1110,7 +1069,7 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	}
 
 	nq = vcpu->run->s.regs.gprs[reg1] & PFMF_NQ;
-	key = vcpu->run->s.regs.gprs[reg1] & PFMF_KEY;
+	key.skey = vcpu->run->s.regs.gprs[reg1] & PFMF_KEY;
 	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	start = kvm_s390_logical_to_effective(vcpu, start);
 
@@ -1141,14 +1100,6 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	}
 
 	while (start != end) {
-		unsigned long vmaddr;
-		bool unlocked = false;
-
-		/* Translate guest address to host address */
-		vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
-		if (kvm_is_error_hva(vmaddr))
-			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-
 		if (vcpu->run->s.regs.gprs[reg1] & PFMF_CF) {
 			if (kvm_clear_guest(vcpu->kvm, start, PAGE_SIZE))
 				return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
@@ -1159,19 +1110,17 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 
 			if (rc)
 				return rc;
-			mmap_read_lock(current->mm);
-			rc = cond_set_guest_storage_key(current->mm, vmaddr,
-							key, NULL, nq, mr, mc);
-			if (rc < 0) {
-				rc = fixup_user_fault(current->mm, vmaddr,
-						      FAULT_FLAG_WRITE, &unlocked);
-				rc = !rc ? -EAGAIN : rc;
+			scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
+				rc = dat_cond_set_storage_key(vcpu->arch.mc, vcpu->arch.gmap->asce,
+							      gpa_to_gfn(start), key,
+							      NULL, nq, mr, mc);
 			}
-			mmap_read_unlock(current->mm);
-			if (rc == -EFAULT)
-				return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-			if (rc == -EAGAIN)
+			if (rc > 1)
+				return kvm_s390_inject_program_int(vcpu, rc);
+			if (rc == -ENOMEM) {
+				kvm_s390_mmu_cache_topup(vcpu->arch.mc);
 				continue;
+			}
 			if (rc < 0)
 				return rc;
 		}
@@ -1195,8 +1144,10 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 {
 	int r1, r2, nappended, entries;
-	unsigned long gfn, hva, res, pgstev, ptev;
+	union essa_state state;
 	unsigned long *cbrlo;
+	unsigned long gfn;
+	bool dirtied;
 
 	/*
 	 * We don't need to set SD.FPF.SK to 1 here, because if we have a
@@ -1205,33 +1156,12 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 
 	kvm_s390_get_regs_rre(vcpu, &r1, &r2);
 	gfn = vcpu->run->s.regs.gprs[r2] >> PAGE_SHIFT;
-	hva = gfn_to_hva(vcpu->kvm, gfn);
 	entries = (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
 
-	if (kvm_is_error_hva(hva))
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-
-	nappended = pgste_perform_essa(vcpu->kvm->mm, hva, orc, &ptev, &pgstev);
-	if (nappended < 0) {
-		res = orc ? 0x10 : 0;
-		vcpu->run->s.regs.gprs[r1] = res; /* Exception Indication */
+	nappended = dat_perform_essa(vcpu->arch.gmap->asce, gfn, orc, &state, &dirtied);
+	vcpu->run->s.regs.gprs[r1] = state.val;
+	if (nappended < 0)
 		return 0;
-	}
-	res = (pgstev & _PGSTE_GPS_USAGE_MASK) >> 22;
-	/*
-	 * Set the block-content state part of the result. 0 means resident, so
-	 * nothing to do if the page is valid. 2 is for preserved pages
-	 * (non-present and non-zero), and 3 for zero pages (non-present and
-	 * zero).
-	 */
-	if (ptev & _PAGE_INVALID) {
-		res |= 2;
-		if (pgstev & _PGSTE_GPS_ZERO)
-			res |= 1;
-	}
-	if (pgstev & _PGSTE_GPS_NODAT)
-		res |= 0x20;
-	vcpu->run->s.regs.gprs[r1] = res;
 	/*
 	 * It is possible that all the normal 511 slots were full, in which case
 	 * we will now write in the 512th slot, which is reserved for host use.
@@ -1243,17 +1173,34 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 		cbrlo[entries] = gfn << PAGE_SHIFT;
 	}
 
-	if (orc) {
-		struct kvm_memory_slot *ms = gfn_to_memslot(vcpu->kvm, gfn);
-
-		/* Increment only if we are really flipping the bit */
-		if (ms && !test_and_set_bit(gfn - ms->base_gfn, kvm_second_dirty_bitmap(ms)))
-			atomic64_inc(&vcpu->kvm->arch.cmma_dirty_pages);
-	}
+	if (dirtied)
+		atomic64_inc(&vcpu->kvm->arch.cmma_dirty_pages);
 
 	return nappended;
 }
 
+static void _essa_clear_cbrl(struct kvm_vcpu *vcpu, unsigned long *cbrl, int len)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	int i;
+
+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
+
+	for (i = 0; i < len; i++) {
+		if (dat_entry_walk(NULL, gpa_to_gfn(cbrl[i]), vcpu->arch.gmap->asce,
+				   0, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep))
+			continue;
+		if (!ptep || ptep->s.pr)
+			continue;
+		pgste = pgste_get_lock(ptep);
+		if (pgste.usage == PGSTE_GPS_USAGE_UNUSED || pgste.zero)
+			gmap_helper_zap_one_page(vcpu->kvm->mm, cbrl[i]);
+		pgste_set_unlock(ptep, pgste);
+	}
+}
+
 static int handle_essa(struct kvm_vcpu *vcpu)
 {
 	lockdep_assert_held(&vcpu->kvm->srcu);
@@ -1261,11 +1208,9 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 	/* entries expected to be 1FF */
 	int entries = (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
 	unsigned long *cbrlo;
-	struct gmap *gmap;
 	int i, orc;
 
 	VCPU_EVENT(vcpu, 4, "ESSA: release %d pages", entries);
-	gmap = vcpu->arch.gmap;
 	vcpu->stat.instruction_essa++;
 	if (!vcpu->kvm->arch.use_cmma)
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
@@ -1289,11 +1234,7 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		 * value really needs to be written to; if the value is
 		 * already correct, we do nothing and avoid the lock.
 		 */
-		if (vcpu->kvm->mm->context.uses_cmm == 0) {
-			mmap_write_lock(vcpu->kvm->mm);
-			vcpu->kvm->mm->context.uses_cmm = 1;
-			mmap_write_unlock(vcpu->kvm->mm);
-		}
+		set_bit(GMAP_FLAG_USES_CMM, &vcpu->arch.gmap->flags);
 		/*
 		 * If we are here, we are supposed to have CMMA enabled in
 		 * the SIE block. Enabling CMMA works on a per-CPU basis,
@@ -1307,20 +1248,22 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		/* Retry the ESSA instruction */
 		kvm_s390_retry_instr(vcpu);
 	} else {
-		mmap_read_lock(vcpu->kvm->mm);
-		i = __do_essa(vcpu, orc);
-		mmap_read_unlock(vcpu->kvm->mm);
+		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+			i = __do_essa(vcpu, orc);
 		if (i < 0)
 			return i;
 		/* Account for the possible extra cbrl entry */
 		entries += i;
 	}
-	vcpu->arch.sie_block->cbrlo &= PAGE_MASK;	/* reset nceo */
+	/* reset nceo */
+	vcpu->arch.sie_block->cbrlo &= PAGE_MASK;
 	cbrlo = phys_to_virt(vcpu->arch.sie_block->cbrlo);
-	mmap_read_lock(gmap->mm);
-	for (i = 0; i < entries; ++i)
-		__gmap_zap(gmap, cbrlo[i]);
-	mmap_read_unlock(gmap->mm);
+
+	mmap_read_lock(vcpu->kvm->mm);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		_essa_clear_cbrl(vcpu, cbrlo, entries);
+	mmap_read_unlock(vcpu->kvm->mm);
+
 	return 0;
 }
 
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 6ba5a0305e25..b6809ee0bfa5 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -12,13 +12,16 @@
 #include <linux/minmax.h>
 #include <linux/pagemap.h>
 #include <linux/sched/signal.h>
-#include <asm/gmap.h>
 #include <asm/uv.h>
 #include <asm/mman.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
+#include "dat.h"
+#include "gaccess.h"
+#include "gmap.h"
+#include "faultin.h"
 
 bool kvm_s390_pv_is_protected(struct kvm *kvm)
 {
@@ -34,6 +37,85 @@ bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pv_cpu_is_protected);
 
+/**
+ * should_export_before_import - Determine whether an export is needed
+ * before an import-like operation
+ * @uvcb: the Ultravisor control block of the UVC to be performed
+ * @mm: the mm of the process
+ *
+ * Returns whether an export is needed before every import-like operation.
+ * This is needed for shared pages, which don't trigger a secure storage
+ * exception when accessed from a different guest.
+ *
+ * Although considered as one, the Unpin Page UVC is not an actual import,
+ * so it is not affected.
+ *
+ * No export is needed also when there is only one protected VM, because the
+ * page cannot belong to the wrong VM in that case (there is no "other VM"
+ * it can belong to).
+ *
+ * Return: true if an export is needed before every import, otherwise false.
+ */
+static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
+{
+	/*
+	 * The misc feature indicates, among other things, that importing a
+	 * shared page from a different protected VM will automatically also
+	 * transfer its ownership.
+	 */
+	if (uv_has_feature(BIT_UV_FEAT_MISC))
+		return false;
+	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
+		return false;
+	return atomic_read(&mm->context.protected_count) > 1;
+}
+
+struct pv_make_secure {
+	void *uvcb;
+	struct folio *folio;
+	int rc;
+	bool needs_export;
+};
+
+static int __kvm_s390_pv_make_secure(struct guest_fault *f, struct folio *folio)
+{
+	struct pv_make_secure *priv = f->priv;
+	int rc;
+
+	if (priv->needs_export)
+		uv_convert_from_secure(folio_to_phys(folio));
+
+	if (folio_test_hugetlb(folio))
+		return -EFAULT;
+	if (folio_test_large(folio))
+		return -E2BIG;
+
+	if (!f->page)
+		folio_get(folio);
+	rc = __make_folio_secure(folio, priv->uvcb);
+	if (!f->page)
+		folio_put(folio);
+
+	return rc;
+}
+
+static void _kvm_s390_pv_make_secure(struct guest_fault *f)
+{
+	struct pv_make_secure *priv = f->priv;
+	struct folio *folio;
+
+	folio = pfn_folio(f->pfn);
+	priv->rc = -EAGAIN;
+	if (folio_trylock(folio)) {
+		priv->rc = __kvm_s390_pv_make_secure(f, folio);
+		if (priv->rc == -E2BIG || priv->rc == -EBUSY) {
+			priv->folio = folio;
+			folio_get(folio);
+		}
+		folio_unlock(folio);
+	}
+}
+
 /**
  * kvm_s390_pv_make_secure() - make one guest page secure
  * @kvm: the guest
@@ -45,14 +127,34 @@ EXPORT_SYMBOL_GPL(kvm_s390_pv_cpu_is_protected);
  */
 int kvm_s390_pv_make_secure(struct kvm *kvm, unsigned long gaddr, void *uvcb)
 {
-	unsigned long vmaddr;
+	struct pv_make_secure priv = { .uvcb = uvcb };
+	struct guest_fault f = {
+		.write_attempt = true,
+		.gfn = gpa_to_gfn(gaddr),
+		.callback = _kvm_s390_pv_make_secure,
+		.priv = &priv,
+	};
+	int rc;
 
 	lockdep_assert_held(&kvm->srcu);
 
-	vmaddr = gfn_to_hva(kvm, gpa_to_gfn(gaddr));
-	if (kvm_is_error_hva(vmaddr))
-		return -EFAULT;
-	return make_hva_secure(kvm->mm, vmaddr, uvcb);
+	priv.needs_export = should_export_before_import(uvcb, kvm->mm);
+
+	scoped_guard(mutex, &kvm->arch.pv.import_lock) {
+		rc = kvm_s390_faultin_gfn(NULL, kvm, &f);
+
+		if (!rc) {
+			rc = priv.rc;
+			if (priv.folio) {
+				rc = s390_wiggle_split_folio(kvm->mm, priv.folio);
+				if (!rc)
+					rc = -EAGAIN;
+			}
+		}
+	}
+	if (priv.folio)
+		folio_put(priv.folio);
+	return rc;
 }
 
 int kvm_s390_pv_convert_to_secure(struct kvm *kvm, unsigned long gaddr)
@@ -299,35 +401,6 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 	return 0;
 }
 
-/**
- * kvm_s390_destroy_lower_2g - Destroy the first 2GB of protected guest memory.
- * @kvm: the VM whose memory is to be cleared.
- *
- * Destroy the first 2GB of guest memory, to avoid prefix issues after reboot.
- * The CPUs of the protected VM need to be destroyed beforehand.
- */
-static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
-{
-	const unsigned long pages_2g = SZ_2G / PAGE_SIZE;
-	struct kvm_memory_slot *slot;
-	unsigned long len;
-	int srcu_idx;
-
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-
-	/* Take the memslot containing guest absolute address 0 */
-	slot = gfn_to_memslot(kvm, 0);
-	/* Clear all slots or parts thereof that are below 2GB */
-	while (slot && slot->base_gfn < pages_2g) {
-		len = min_t(u64, slot->npages, pages_2g - slot->base_gfn) * PAGE_SIZE;
-		s390_uv_destroy_range(kvm->mm, slot->userspace_addr, slot->userspace_addr + len);
-		/* Take the next memslot */
-		slot = gfn_to_memslot(kvm, slot->base_gfn + slot->npages);
-	}
-
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-}
-
 static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct uv_cb_destroy_fast uvcb = {
@@ -342,7 +415,6 @@ static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
 		*rc = uvcb.header.rc;
 	if (rrc)
 		*rrc = uvcb.header.rrc;
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM FAST: rc %x rrc %x",
 		     uvcb.header.rc, uvcb.header.rrc);
 	WARN_ONCE(cc && uvcb.header.rc != 0x104,
@@ -391,7 +463,7 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EINVAL;
 
 	/* Guest with segment type ASCE, refuse to destroy asynchronously */
-	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
+	if (kvm->arch.gmap->asce.dt == TABLE_TYPE_SEGMENT)
 		return -EINVAL;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -404,8 +476,7 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 		priv->stor_var = kvm->arch.pv.stor_var;
 		priv->stor_base = kvm->arch.pv.stor_base;
 		priv->handle = kvm_s390_pv_get_handle(kvm);
-		priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
-		WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+		priv->old_gmap_table = (unsigned long)dereference_asce(kvm->arch.gmap->asce);
 		if (s390_replace_asce(kvm->arch.gmap))
 			res = -ENOMEM;
 	}
@@ -415,7 +486,7 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return res;
 	}
 
-	kvm_s390_destroy_lower_2g(kvm);
+	gmap_pv_destroy_range(kvm->arch.gmap, 0, gpa_to_gfn(SZ_2G), false);
 	kvm_s390_clear_pv_state(kvm);
 	kvm->arch.pv.set_aside = priv;
 
@@ -449,7 +520,6 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	if (!cc) {
 		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
@@ -532,7 +602,7 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
 	 * cleanup has been performed.
 	 */
 	if (need_zap && mmget_not_zero(kvm->mm)) {
-		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
+		gmap_pv_destroy_range(kvm->arch.gmap, 0, asce_end(kvm->arch.gmap->asce), false);
 		mmput(kvm->mm);
 	}
 
@@ -570,7 +640,7 @@ int kvm_s390_pv_deinit_aside_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EINVAL;
 
 	/* When a fatal signal is received, stop immediately */
-	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX))
+	if (gmap_pv_destroy_range(kvm->arch.gmap, 0, asce_end(kvm->arch.gmap->asce), true))
 		goto done;
 	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
 		ret = -EIO;
@@ -609,6 +679,7 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 	r = kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
 	if (!r && is_destroy_fast_available() && kvm_s390_pv_get_handle(kvm))
 		kvm_s390_pv_deinit_vm_fast(kvm, &dummy, &dummy);
+	set_bit(GMAP_FLAG_EXPORT_ON_UNMAP, &kvm->arch.gmap->flags);
 }
 
 static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
@@ -642,7 +713,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Inputs */
 	uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
 	uvcb.guest_stor_len = kvm->arch.pv.guest_len;
-	uvcb.guest_asce = kvm->arch.gmap->asce;
+	uvcb.guest_asce = kvm->arch.gmap->asce.val;
 	uvcb.guest_sca = virt_to_phys(kvm->arch.sca);
 	uvcb.conf_base_stor_origin =
 		virt_to_phys((void *)kvm->arch.pv.stor_base);
@@ -669,7 +740,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		}
 		return -EIO;
 	}
-	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
 	return 0;
 }
 
@@ -704,26 +774,14 @@ static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak,
 		.tweak[1] = offset,
 	};
 	int ret = kvm_s390_pv_make_secure(kvm, addr, &uvcb);
-	unsigned long vmaddr;
-	bool unlocked;
 
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
 
 	if (ret == -ENXIO) {
-		mmap_read_lock(kvm->mm);
-		vmaddr = gfn_to_hva(kvm, gpa_to_gfn(addr));
-		if (kvm_is_error_hva(vmaddr)) {
-			ret = -EFAULT;
-		} else {
-			ret = fixup_user_fault(kvm->mm, vmaddr, FAULT_FLAG_WRITE, &unlocked);
-			if (!ret)
-				ret = __gmap_link(kvm->arch.gmap, addr, vmaddr);
-		}
-		mmap_read_unlock(kvm->mm);
+		ret = kvm_s390_faultin_gfn_simple(NULL, kvm, gpa_to_gfn(addr), true);
 		if (!ret)
 			return -EAGAIN;
-		return ret;
 	}
 
 	if (ret && ret != -EAGAIN)
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 1dd54ca3070a..840d1e9e3ae2 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -15,7 +15,6 @@
 #include <linux/io.h>
 #include <linux/mman.h>
 
-#include <asm/gmap.h>
 #include <asm/mmu_context.h>
 #include <asm/sclp.h>
 #include <asm/nmi.h>
@@ -23,6 +22,7 @@
 #include <asm/facility.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
+#include "gmap.h"
 
 enum vsie_page_flags {
 	VSIE_PAGE_IN_USE = 0,
@@ -41,8 +41,11 @@ struct vsie_page {
 	 * are reused conditionally, should be accessed via READ_ONCE.
 	 */
 	struct kvm_s390_sie_block *scb_o;	/* 0x0218 */
-	/* the shadow gmap in use by the vsie_page */
-	struct gmap *gmap;			/* 0x0220 */
+	/*
+	 * Flags: must be set/cleared atomically after the vsie page can be
+	 * looked up by other CPUs.
+	 */
+	unsigned long flags;			/* 0x0220 */
 	/* address of the last reported fault to guest2 */
 	unsigned long fault_addr;		/* 0x0228 */
 	/* calculated guest addresses of satellite control blocks */
@@ -57,33 +60,14 @@ struct vsie_page {
 	 * radix tree.
 	 */
 	gpa_t scb_gpa;				/* 0x0258 */
-	/*
-	 * Flags: must be set/cleared atomically after the vsie page can be
-	 * looked up by other CPUs.
-	 */
-	unsigned long flags;			/* 0x0260 */
-	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
+	/* the shadow gmap in use by the vsie_page */
+	struct gmap_cache gmap_cache;		/* 0x0260 */
+	__u8 reserved[0x0700 - 0x0278];		/* 0x0278 */
 	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
 
-/**
- * gmap_shadow_valid() - check if a shadow guest address space matches the
- *                       given properties and is still valid
- * @sg: pointer to the shadow guest address space structure
- * @asce: ASCE for which the shadow table is requested
- * @edat_level: edat level to be used for the shadow translation
- *
- * Returns 1 if the gmap shadow is still valid and matches the given
- * properties, the caller can continue using it. Returns 0 otherwise; the
- * caller has to request a new shadow gmap in this case.
- */
-int gmap_shadow_valid(struct gmap *sg, unsigned long asce, int edat_level)
-{
-	if (sg->removed)
-		return 0;
-	return sg->orig_asce == asce && sg->edat_level == edat_level;
-}
+static_assert(sizeof(struct vsie_page) == PAGE_SIZE);
 
 /* trigger a validity icpt for the given scb */
 static int set_validity_icpt(struct kvm_s390_sie_block *scb,
@@ -612,26 +596,17 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return rc;
 }
 
-void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
-				 unsigned long end)
+void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, gpa_t start, gpa_t end)
 {
-	struct kvm *kvm = gmap->private;
-	struct vsie_page *cur;
+	struct vsie_page *cur, *next;
 	unsigned long prefix;
-	int i;
 
-	if (!gmap_is_shadow(gmap))
-		return;
+	KVM_BUG_ON(!test_bit(GMAP_FLAG_SHADOW, &gmap->flags), gmap->kvm);
 	/*
 	 * Only new shadow blocks are added to the list during runtime,
 	 * therefore we can safely reference them all the time.
 	 */
-	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
-		cur = READ_ONCE(kvm->arch.vsie.pages[i]);
-		if (!cur)
-			continue;
-		if (READ_ONCE(cur->gmap) != gmap)
-			continue;
+	list_for_each_entry_safe(cur, next, &gmap->scb_users, gmap_cache.list) {
 		prefix = cur->scb_s.prefix << GUEST_PREFIX_SHIFT;
 		/* with mso/msl, the prefix lies at an offset */
 		prefix += cur->scb_s.mso;
@@ -667,9 +642,9 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct
 	/* with mso/msl, the prefix lies at offset *mso* */
 	prefix += scb_s->mso;
 
-	rc = kvm_s390_shadow_fault(vcpu, sg, prefix, NULL);
+	rc = gaccess_shadow_fault(vcpu, sg, prefix, NULL, true);
 	if (!rc && (scb_s->ecb & ECB_TE))
-		rc = kvm_s390_shadow_fault(vcpu, sg, prefix + PAGE_SIZE, NULL);
+		rc = gaccess_shadow_fault(vcpu, sg, prefix + PAGE_SIZE, NULL, true);
 	/*
 	 * We don't have to mprotect, we will be called for all unshadows.
 	 * SIE will detect if protection applies and trigger a validity.
@@ -952,6 +927,7 @@ static int inject_fault(struct kvm_vcpu *vcpu, __u16 code, __u64 vaddr,
  */
 static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
+	bool wr = kvm_s390_cur_gmap_fault_is_write();
 	int rc;
 
 	if ((current->thread.gmap_int_code & PGM_INT_CODE_MASK) == PGM_PROTECTION)
@@ -959,11 +935,10 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, stru
 		return inject_fault(vcpu, PGM_PROTECTION,
 				    current->thread.gmap_teid.addr * PAGE_SIZE, 1);
 
-	rc = kvm_s390_shadow_fault(vcpu, sg, current->thread.gmap_teid.addr * PAGE_SIZE, NULL);
+	rc = gaccess_shadow_fault(vcpu, sg, current->thread.gmap_teid.addr * PAGE_SIZE, NULL, wr);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
-				  current->thread.gmap_teid.addr * PAGE_SIZE,
-				  kvm_s390_cur_gmap_fault_is_write());
+				  current->thread.gmap_teid.addr * PAGE_SIZE, wr);
 		if (rc >= 0)
 			vsie_page->fault_addr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	}
@@ -979,7 +954,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, stru
 static void handle_last_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	if (vsie_page->fault_addr)
-		kvm_s390_shadow_fault(vcpu, sg, vsie_page->fault_addr, NULL);
+		gaccess_shadow_fault(vcpu, sg, vsie_page->fault_addr, NULL, true);
 	vsie_page->fault_addr = 0;
 }
 
@@ -1064,8 +1039,9 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct gmap *sg)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	unsigned long pei_dest, pei_src, src, dest, mask, prefix;
+	unsigned long src, dest, mask, prefix;
 	u64 *pei_block = &vsie_page->scb_o->mcic;
+	union mvpg_pei pei_dest, pei_src;
 	int edat, rc_dest, rc_src;
 	union ctlreg0 cr0;
 
@@ -1079,8 +1055,8 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
 	src = _kvm_s390_real_to_abs(prefix, src) + scb_s->mso;
 
-	rc_dest = kvm_s390_shadow_fault(vcpu, sg, dest, &pei_dest);
-	rc_src = kvm_s390_shadow_fault(vcpu, sg, src, &pei_src);
+	rc_dest = gaccess_shadow_fault(vcpu, sg, dest, &pei_dest, true);
+	rc_src = gaccess_shadow_fault(vcpu, sg, src, &pei_src, false);
 	/*
 	 * Either everything went well, or something non-critical went wrong
 	 * e.g. because of a race. In either case, simply retry.
@@ -1115,8 +1091,8 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 		rc_src = rc_src != PGM_PAGE_TRANSLATION ? rc_src : 0;
 	}
 	if (!rc_dest && !rc_src) {
-		pei_block[0] = pei_dest;
-		pei_block[1] = pei_src;
+		pei_block[0] = pei_dest.val;
+		pei_block[1] = pei_src.val;
 		return 1;
 	}
 
@@ -1187,7 +1163,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struc
 			goto xfer_to_guest_mode_check;
 		}
 		guest_timing_enter_irqoff();
-		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, sg->asce);
+		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, sg->asce.val);
 		guest_timing_exit_irqoff();
 		local_irq_enable();
 	}
@@ -1237,43 +1213,64 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struc
 
 static void release_gmap_shadow(struct vsie_page *vsie_page)
 {
-	if (vsie_page->gmap)
-		gmap_put(vsie_page->gmap);
-	WRITE_ONCE(vsie_page->gmap, NULL);
+	struct gmap *gmap = vsie_page->gmap_cache.gmap;
+
+	KVM_BUG_ON(!gmap->parent, gmap->kvm);
+	lockdep_assert_held(&gmap->parent->children_lock);
+
+	list_del(&vsie_page->gmap_cache.list);
+	vsie_page->gmap_cache.gmap = NULL;
 	prefix_unmapped(vsie_page);
+
+	if (list_empty(&gmap->scb_users)) {
+		gmap_remove_child(gmap);
+		gmap_put(gmap);
+	}
 }
 
-static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
-			       struct vsie_page *vsie_page)
+static struct gmap *acquire_gmap_shadow(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
-	unsigned long asce;
 	union ctlreg0 cr0;
 	struct gmap *gmap;
+	union asce asce;
 	int edat;
 
-	asce = vcpu->arch.sie_block->gcr[1];
+	asce.val = vcpu->arch.sie_block->gcr[1];
 	cr0.val = vcpu->arch.sie_block->gcr[0];
 	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
 	edat += edat && test_kvm_facility(vcpu->kvm, 78);
 
-	/*
-	 * ASCE or EDAT could have changed since last icpt, or the gmap
-	 * we're holding has been unshadowed. If the gmap is still valid,
-	 * we can safely reuse it.
-	 */
-	if (vsie_page->gmap && gmap_shadow_valid(vsie_page->gmap, asce, edat)) {
-		vcpu->kvm->stat.gmap_shadow_reuse++;
-		return 0;
+	scoped_guard(spinlock, &vcpu->kvm->arch.gmap->children_lock) {
+		gmap = vsie_page->gmap_cache.gmap;
+		if (gmap) {
+			/*
+			 * ASCE or EDAT could have changed since last icpt, or the gmap
+			 * we're holding has been unshadowed. If the gmap is still valid,
+			 * we can safely reuse it.
+			 */
+			if (gmap_is_shadow_valid(gmap, asce, edat)) {
+				vcpu->kvm->stat.gmap_shadow_reuse++;
+				gmap_get(gmap);
+				return gmap;
+			}
+			/* release the old shadow and mark the prefix as unmapped */
+			release_gmap_shadow(vsie_page);
+		}
 	}
-
-	/* release the old shadow - if any, and mark the prefix as unmapped */
-	release_gmap_shadow(vsie_page);
-	gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
+	gmap = gmap_create_shadow(vcpu->arch.mc, vcpu->kvm->arch.gmap, asce, edat);
 	if (IS_ERR(gmap))
-		return PTR_ERR(gmap);
-	vcpu->kvm->stat.gmap_shadow_create++;
-	WRITE_ONCE(vsie_page->gmap, gmap);
-	return 0;
+		return gmap;
+	scoped_guard(spinlock, &vcpu->kvm->arch.gmap->children_lock) {
+		/* unlikely race condition, remove the previous shadow */
+		if (vsie_page->gmap_cache.gmap)
+			release_gmap_shadow(vsie_page);
+		vcpu->kvm->stat.gmap_shadow_create++;
+		list_add(&vsie_page->gmap_cache.list, &gmap->scb_users);
+		vsie_page->gmap_cache.gmap = gmap;
+		prefix_unmapped(vsie_page);
+		gmap_get(gmap);
+	}
+	return gmap;
 }
 
 /*
@@ -1330,8 +1327,11 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	int rc = 0;
 
 	while (1) {
-		rc = acquire_gmap_shadow(vcpu, vsie_page);
-		sg = vsie_page->gmap;
+		sg = acquire_gmap_shadow(vcpu, vsie_page);
+		if (IS_ERR(sg)) {
+			rc = PTR_ERR(sg);
+			sg = NULL;
+		}
 		if (!rc)
 			rc = map_prefix(vcpu, vsie_page, sg);
 		if (!rc) {
@@ -1359,6 +1359,9 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 			kvm_s390_rewind_psw(vcpu, 4);
 			break;
 		}
+		if (sg)
+			sg = gmap_put(sg);
+		cond_resched();
 	}
 
 	if (rc == -EFAULT) {
@@ -1455,8 +1458,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	vsie_page->scb_gpa = ULONG_MAX;
 
 	/* Double use of the same address or allocation failure. */
-	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9,
-			      vsie_page)) {
+	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, vsie_page)) {
 		put_vsie_page(vsie_page);
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
@@ -1465,7 +1467,12 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	mutex_unlock(&kvm->arch.vsie.mutex);
 
 	memset(&vsie_page->scb_s, 0, sizeof(struct kvm_s390_sie_block));
-	release_gmap_shadow(vsie_page);
+	if (vsie_page->gmap_cache.gmap) {
+		scoped_guard(spinlock, &kvm->arch.gmap->children_lock)
+			if (vsie_page->gmap_cache.gmap)
+				release_gmap_shadow(vsie_page);
+	}
+	prefix_unmapped(vsie_page);
 	vsie_page->fault_addr = 0;
 	vsie_page->scb_s.ihcpu = 0xffffU;
 	return vsie_page;
@@ -1541,8 +1548,10 @@ void kvm_s390_vsie_destroy(struct kvm *kvm)
 	mutex_lock(&kvm->arch.vsie.mutex);
 	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
 		vsie_page = kvm->arch.vsie.pages[i];
+		scoped_guard(spinlock, &kvm->arch.gmap->children_lock)
+			if (vsie_page->gmap_cache.gmap)
+				release_gmap_shadow(vsie_page);
 		kvm->arch.vsie.pages[i] = NULL;
-		release_gmap_shadow(vsie_page);
 		/* free the radix tree entry */
 		if (vsie_page->scb_gpa != ULONG_MAX)
 			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
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
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index 4864cb35fc25..d653c64b869a 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -34,28 +34,6 @@ static void ptep_zap_softleaf_entry(struct mm_struct *mm, softleaf_t entry)
 	free_swap_and_cache(entry);
 }
 
-static inline pgste_t pgste_get_lock(pte_t *ptep)
-{
-	unsigned long value = 0;
-#ifdef CONFIG_PGSTE
-	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
-
-	do {
-		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
-	} while (value & PGSTE_PCL_BIT);
-	value |= PGSTE_PCL_BIT;
-#endif
-	return __pgste(value);
-}
-
-static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
-{
-#ifdef CONFIG_PGSTE
-	barrier();
-	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
-#endif
-}
-
 /**
  * gmap_helper_zap_one_page() - discard a page if it was swapped.
  * @mm: the mm
@@ -68,9 +46,7 @@ static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
 void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 {
 	struct vm_area_struct *vma;
-	unsigned long pgstev;
 	spinlock_t *ptl;
-	pgste_t pgste;
 	pte_t *ptep;
 
 	mmap_assert_locked(mm);
@@ -85,18 +61,8 @@ void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 	if (unlikely(!ptep))
 		return;
 	if (pte_swap(*ptep)) {
-		preempt_disable();
-		pgste = pgste_get_lock(ptep);
-		pgstev = pgste_val(pgste);
-
-		if ((pgstev & _PGSTE_GPS_USAGE_MASK) == _PGSTE_GPS_USAGE_UNUSED ||
-		    (pgstev & _PGSTE_GPS_ZERO)) {
-			ptep_zap_softleaf_entry(mm, softleaf_from_pte(*ptep));
-			pte_clear(mm, vmaddr, ptep);
-		}
-
-		pgste_set_unlock(ptep, pgste);
-		preempt_enable();
+		ptep_zap_softleaf_entry(mm, softleaf_from_pte(*ptep));
+		pte_clear(mm, vmaddr, ptep);
 	}
 	pte_unmap_unlock(ptep, ptl);
 }
-- 
2.52.0


