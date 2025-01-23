Return-Path: <kvm+bounces-36375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FDFBA1A5FC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1DA218874F0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0F7213220;
	Thu, 23 Jan 2025 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CNGgIg2d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650F0211276;
	Thu, 23 Jan 2025 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643602; cv=none; b=klItJkukFQKlQjDaRweZnntQF5d9rTNEzZVukLYMfbhczUi3iJtckCrA+rchmC4N5F1plBm6a0inYZJXVzzP9XJSuNvLGb7BmYPryGYtRyzbI3lntTZmioXUaeK7QF7aWLqqvw+vGlL6GOkoLnDgModNxiWSlDxY/Ac+seDHNqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643602; c=relaxed/simple;
	bh=ErCXWFRvhbqHQ1S1GQMTfrWCNVZ1pevSKdBtui2zvfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orJHNMgJVFLmLsJ5AJlPxy8LNhxRRUL1L5Z3k9cIPLIpYaZY3mKebdjCC7X3d14W5lzr1NCCGCSWFTGBBer1fQyN9MkUgu/jnRJLBRYJsxAV5Dbvx+CFrxvM3hzUkD/5Mc2B5+6XVgMMRZw4OT22ujZ+HUmSNI8CCWoxZx//FEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CNGgIg2d; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N3xQqu016773;
	Thu, 23 Jan 2025 14:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=J4NT3ERBzZp4jVXJ2
	MGO1UeCNN+mbTLRbE/ZDl79DO8=; b=CNGgIg2dQULLCXORRAAc+Q8TGp+Vmem5l
	Cz9vCfRMAGa03PKFBwFvxRT601TI1SArY63NOa7jgg7qapDtRyrsOUYCVSTIR0S2
	5GuJvMOc6jX/6R14vIvMJEI6ik70tc5TbvPjyMs5P3FsyTZxX3e596UjzS9Sf5U5
	Vov8EKSv4X/1sp8KtqKgsZOpbL3zObLsJdyk60MVkWhWP+IP2xgcTK055nmGI9yp
	ZOEoE8p1gZc/LT6+CwzgV6m8SvjzX407Z4cQtNDGVPLR7rri8Q5YhzDiD7bCCi75
	4DARX664KTDts9nFjelQsB6nmC8irr01Bji0EjYINQskZRr2LwXWA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b3gtwn3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:35 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NEcamA009283;
	Thu, 23 Jan 2025 14:46:34 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b3gtwn3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NCFdnp021012;
	Thu, 23 Jan 2025 14:46:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb1nksy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkU8764946598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0255620040;
	Thu, 23 Jan 2025 14:46:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF7262004B;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 05/15] KVM: s390: move pv gmap functions into kvm
Date: Thu, 23 Jan 2025 15:46:17 +0100
Message-ID: <20250123144627.312456-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123144627.312456-1-imbrenda@linux.ibm.com>
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n_dAM5D-nfB9cGP9Agc9yT2R1H2KQt7X
X-Proofpoint-GUID: 59QoPEiwch3_bOcIbf9GDM7YhD22VxTX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

Move gmap related functions from kernel/uv into kvm.

Create a new file to collect gmap-related functions.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |   1 +
 arch/s390/include/asm/uv.h   |   6 +-
 arch/s390/kernel/uv.c        | 292 ++++-------------------------------
 arch/s390/kvm/Makefile       |   2 +-
 arch/s390/kvm/gmap.c         | 209 +++++++++++++++++++++++++
 arch/s390/kvm/gmap.h         |  17 ++
 arch/s390/kvm/intercept.c    |   1 +
 arch/s390/kvm/kvm-s390.c     |   1 +
 arch/s390/kvm/pv.c           |   1 +
 arch/s390/mm/gmap.c          |  28 ++++
 10 files changed, 291 insertions(+), 267 deletions(-)
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 13f51a6a5bb1..3e66f53fe3cc 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -149,6 +149,7 @@ int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
 
 /**
  * s390_uv_destroy_range - Destroy a range of pages in the given mm.
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index dc332609f2c3..b11f5b6d0bd1 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -628,12 +628,12 @@ static inline int is_prot_virt_host(void)
 }
 
 int uv_pin_shared(unsigned long paddr);
-int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
-int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
-int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
+int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
+int uv_convert_from_secure(unsigned long paddr);
+int uv_convert_from_secure_folio(struct folio *folio);
 
 void setup_uv(void);
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 6f9654a191ad..9f05df2da2f7 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -19,19 +19,6 @@
 #include <asm/sections.h>
 #include <asm/uv.h>
 
-#if !IS_ENABLED(CONFIG_KVM)
-unsigned long __gmap_translate(struct gmap *gmap, unsigned long gaddr)
-{
-	return 0;
-}
-
-int gmap_fault(struct gmap *gmap, unsigned long gaddr,
-	       unsigned int fault_flags)
-{
-	return 0;
-}
-#endif
-
 /* the bootdata_preserved fields come from ones in arch/s390/boot/uv.c */
 int __bootdata_preserved(prot_virt_guest);
 EXPORT_SYMBOL(prot_virt_guest);
@@ -159,6 +146,7 @@ int uv_destroy_folio(struct folio *folio)
 	folio_put(folio);
 	return rc;
 }
+EXPORT_SYMBOL(uv_destroy_folio);
 
 /*
  * The present PTE still indirectly holds a folio reference through the mapping.
@@ -175,7 +163,7 @@ int uv_destroy_pte(pte_t pte)
  *
  * @paddr: Absolute host address of page to be exported
  */
-static int uv_convert_from_secure(unsigned long paddr)
+int uv_convert_from_secure(unsigned long paddr)
 {
 	struct uv_cb_cfs uvcb = {
 		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
@@ -187,11 +175,12 @@ static int uv_convert_from_secure(unsigned long paddr)
 		return -EINVAL;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(uv_convert_from_secure);
 
 /*
  * The caller must already hold a reference to the folio.
  */
-static int uv_convert_from_secure_folio(struct folio *folio)
+int uv_convert_from_secure_folio(struct folio *folio)
 {
 	int rc;
 
@@ -206,6 +195,7 @@ static int uv_convert_from_secure_folio(struct folio *folio)
 	folio_put(folio);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(uv_convert_from_secure_folio);
 
 /*
  * The present PTE still indirectly holds a folio reference through the mapping.
@@ -237,13 +227,33 @@ static int expected_folio_refs(struct folio *folio)
 	return res;
 }
 
-static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
+/**
+ * make_folio_secure() - make a folio secure
+ * @folio: the folio to make secure
+ * @uvcb: the uvcb that describes the UVC to be used
+ *
+ * The folio @folio will be made secure if possible, @uvcb will be passed
+ * as-is to the UVC.
+ *
+ * Return: 0 on success;
+ *         -EBUSY if the folio is in writeback or has too many references;
+ *         -E2BIG if the folio is large;
+ *         -EAGAIN if the UVC needs to be attempted again;
+ *         -ENXIO if the address is not mapped;
+ *         -EINVAL if the UVC failed for other reasons.
+ *
+ * Context: The caller must hold exactly one extra reference on the folio
+ *          (it's the same logic as split_folio())
+ */
+int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 {
 	int expected, cc = 0;
 
+	if (folio_test_large(folio))
+		return -E2BIG;
 	if (folio_test_writeback(folio))
-		return -EAGAIN;
-	expected = expected_folio_refs(folio);
+		return -EBUSY;
+	expected = expected_folio_refs(folio) + 1;
 	if (!folio_ref_freeze(folio, expected))
 		return -EBUSY;
 	set_bit(PG_arch_1, &folio->flags);
@@ -267,251 +277,7 @@ static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 		return -EAGAIN;
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
-
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
-/*
- * Drain LRU caches: the local one on first invocation and the ones of all
- * CPUs on successive invocations. Returns "true" on the first invocation.
- */
-static bool drain_lru(bool *drain_lru_called)
-{
-	/*
-	 * If we have tried a local drain and the folio refcount
-	 * still does not match our expected safe value, try with a
-	 * system wide drain. This is needed if the pagevecs holding
-	 * the page are on a different CPU.
-	 */
-	if (*drain_lru_called) {
-		lru_add_drain_all();
-		/* We give up here, don't retry immediately. */
-		return false;
-	}
-	/*
-	 * We are here if the folio refcount does not match the
-	 * expected safe value. The main culprits are usually
-	 * pagevecs. With lru_add_drain() we drain the pagevecs
-	 * on the local CPU so that hopefully the refcount will
-	 * reach the expected safe value.
-	 */
-	lru_add_drain();
-	*drain_lru_called = true;
-	/* The caller should try again immediately */
-	return true;
-}
-
-/*
- * Requests the Ultravisor to make a page accessible to a guest.
- * If it's brought in the first time, it will be cleared. If
- * it has been exported before, it will be decrypted and integrity
- * checked.
- */
-int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
-{
-	struct vm_area_struct *vma;
-	bool drain_lru_called = false;
-	spinlock_t *ptelock;
-	unsigned long uaddr;
-	struct folio *folio;
-	pte_t *ptep;
-	int rc;
-
-again:
-	rc = -EFAULT;
-	mmap_read_lock(gmap->mm);
-
-	uaddr = __gmap_translate(gmap, gaddr);
-	if (IS_ERR_VALUE(uaddr))
-		goto out;
-	vma = vma_lookup(gmap->mm, uaddr);
-	if (!vma)
-		goto out;
-	/*
-	 * Secure pages cannot be huge and userspace should not combine both.
-	 * In case userspace does it anyway this will result in an -EFAULT for
-	 * the unpack. The guest is thus never reaching secure mode. If
-	 * userspace is playing dirty tricky with mapping huge pages later
-	 * on this will result in a segmentation fault.
-	 */
-	if (is_vm_hugetlb_page(vma))
-		goto out;
-
-	rc = -ENXIO;
-	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
-	if (!ptep)
-		goto out;
-	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
-		folio = page_folio(pte_page(*ptep));
-		rc = -EAGAIN;
-		if (folio_test_large(folio)) {
-			rc = -E2BIG;
-		} else if (folio_trylock(folio)) {
-			if (should_export_before_import(uvcb, gmap->mm))
-				uv_convert_from_secure(PFN_PHYS(folio_pfn(folio)));
-			rc = make_folio_secure(folio, uvcb);
-			folio_unlock(folio);
-		}
-
-		/*
-		 * Once we drop the PTL, the folio may get unmapped and
-		 * freed immediately. We need a temporary reference.
-		 */
-		if (rc == -EAGAIN || rc == -E2BIG)
-			folio_get(folio);
-	}
-	pte_unmap_unlock(ptep, ptelock);
-out:
-	mmap_read_unlock(gmap->mm);
-
-	switch (rc) {
-	case -E2BIG:
-		folio_lock(folio);
-		rc = split_folio(folio);
-		folio_unlock(folio);
-		folio_put(folio);
-
-		switch (rc) {
-		case 0:
-			/* Splitting succeeded, try again immediately. */
-			goto again;
-		case -EAGAIN:
-			/* Additional folio references. */
-			if (drain_lru(&drain_lru_called))
-				goto again;
-			return -EAGAIN;
-		case -EBUSY:
-			/* Unexpected race. */
-			return -EAGAIN;
-		}
-		WARN_ON_ONCE(1);
-		return -ENXIO;
-	case -EAGAIN:
-		/*
-		 * If we are here because the UVC returned busy or partial
-		 * completion, this is just a useless check, but it is safe.
-		 */
-		folio_wait_writeback(folio);
-		folio_put(folio);
-		return -EAGAIN;
-	case -EBUSY:
-		/* Additional folio references. */
-		if (drain_lru(&drain_lru_called))
-			goto again;
-		return -EAGAIN;
-	case -ENXIO:
-		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
-			return -EFAULT;
-		return -EAGAIN;
-	}
-	return rc;
-}
-EXPORT_SYMBOL_GPL(gmap_make_secure);
-
-int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
-{
-	struct uv_cb_cts uvcb = {
-		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
-		.header.len = sizeof(uvcb),
-		.guest_handle = gmap->guest_handle,
-		.gaddr = gaddr,
-	};
-
-	return gmap_make_secure(gmap, gaddr, &uvcb);
-}
-EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
-
-/**
- * gmap_destroy_page - Destroy a guest page.
- * @gmap: the gmap of the guest
- * @gaddr: the guest address to destroy
- *
- * An attempt will be made to destroy the given guest page. If the attempt
- * fails, an attempt is made to export the page. If both attempts fail, an
- * appropriate error is returned.
- */
-int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
-{
-	struct vm_area_struct *vma;
-	struct folio_walk fw;
-	unsigned long uaddr;
-	struct folio *folio;
-	int rc;
-
-	rc = -EFAULT;
-	mmap_read_lock(gmap->mm);
-
-	uaddr = __gmap_translate(gmap, gaddr);
-	if (IS_ERR_VALUE(uaddr))
-		goto out;
-	vma = vma_lookup(gmap->mm, uaddr);
-	if (!vma)
-		goto out;
-	/*
-	 * Huge pages should not be able to become secure
-	 */
-	if (is_vm_hugetlb_page(vma))
-		goto out;
-
-	rc = 0;
-	folio = folio_walk_start(&fw, vma, uaddr, 0);
-	if (!folio)
-		goto out;
-	/*
-	 * See gmap_make_secure(): large folios cannot be secure. Small
-	 * folio implies FW_LEVEL_PTE.
-	 */
-	if (folio_test_large(folio) || !pte_write(fw.pte))
-		goto out_walk_end;
-	rc = uv_destroy_folio(folio);
-	/*
-	 * Fault handlers can race; it is possible that two CPUs will fault
-	 * on the same secure page. One CPU can destroy the page, reboot,
-	 * re-enter secure mode and import it, while the second CPU was
-	 * stuck at the beginning of the handler. At some point the second
-	 * CPU will be able to progress, and it will not be able to destroy
-	 * the page. In that case we do not want to terminate the process,
-	 * we instead try to export the page.
-	 */
-	if (rc)
-		rc = uv_convert_from_secure_folio(folio);
-out_walk_end:
-	folio_walk_end(&fw, vma);
-out:
-	mmap_read_unlock(gmap->mm);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(gmap_destroy_page);
+EXPORT_SYMBOL_GPL(make_folio_secure);
 
 /*
  * To be called with the folio locked or with an extra reference! This will
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 02217fb4ae10..d972dea657fd 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -8,7 +8,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
+kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
new file mode 100644
index 000000000000..c9e72ca640c2
--- /dev/null
+++ b/arch/s390/kvm/gmap.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Guest memory management for KVM/s390
+ *
+ * Copyright IBM Corp. 2008, 2020, 2024
+ *
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *               Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *               David Hildenbrand <david@redhat.com>
+ *               Janosch Frank <frankja@linux.vnet.ibm.com>
+ */
+
+#include <linux/compiler.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/pgtable.h>
+#include <linux/pagemap.h>
+
+#include <asm/lowcore.h>
+#include <asm/gmap.h>
+#include <asm/uv.h>
+
+#include "gmap.h"
+
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
+static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
+{
+	struct folio *folio = page_folio(page);
+	int rc;
+
+	/*
+	 * Secure pages cannot be huge and userspace should not combine both.
+	 * In case userspace does it anyway this will result in an -EFAULT for
+	 * the unpack. The guest is thus never reaching secure mode.
+	 * If userspace plays dirty tricks and decides to map huge pages at a
+	 * later point in time, it will receive a segmentation fault or
+	 * KVM_RUN will return -EFAULT.
+	 */
+	if (folio_test_hugetlb(folio))
+		return -EFAULT;
+	if (folio_test_large(folio)) {
+		mmap_read_unlock(gmap->mm);
+		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, true);
+		mmap_read_lock(gmap->mm);
+		if (rc)
+			return rc;
+		folio = page_folio(page);
+	}
+
+	if (!folio_trylock(folio))
+		return -EAGAIN;
+	if (should_export_before_import(uvcb, gmap->mm))
+		uv_convert_from_secure(folio_to_phys(folio));
+	rc = make_folio_secure(folio, uvcb);
+	folio_unlock(folio);
+
+	/*
+	 * In theory a race is possible and the folio might have become
+	 * large again before the folio_trylock() above. In that case, no
+	 * action is performed and -EAGAIN is returned; the callers will
+	 * have to try again later.
+	 * In most cases this implies running the VM again, getting the same
+	 * exception again, and make another attempt in this function.
+	 * This is expected to happen extremely rarely.
+	 */
+	if (rc == -E2BIG)
+		return -EAGAIN;
+	/*
+	 * Unlikely case: the page is not mapped anymore. Return success
+	 * and let the proper fault handler fault in the page again.
+	 */
+	if (rc == -ENXIO)
+		return 0;
+	/* The folio has too many references, try to shake some off */
+	if (rc == -EBUSY) {
+		mmap_read_unlock(gmap->mm);
+		kvm_s390_wiggle_split_folio(gmap->mm, folio, false);
+		mmap_read_lock(gmap->mm);
+		return -EAGAIN;
+	}
+
+	return rc;
+}
+
+int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
+{
+	struct kvm *kvm = gmap->private;
+	struct page *page;
+	int rc = 0;
+
+	mmap_read_lock(gmap->mm);
+	scoped_guard(srcu, &kvm->srcu) {
+		page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
+	}
+	if (page)
+		rc = __gmap_make_secure(gmap, page, uvcb);
+	kvm_release_page_clean(page);
+	mmap_read_unlock(gmap->mm);
+
+	return rc;
+}
+
+int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
+{
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.guest_handle = gmap->guest_handle,
+		.gaddr = gaddr,
+	};
+
+	return gmap_make_secure(gmap, gaddr, &uvcb);
+}
+
+/**
+ * __gmap_destroy_page() - Destroy a guest page.
+ * @gmap: the gmap of the guest
+ * @page: the page to destroy
+ *
+ * An attempt will be made to destroy the given guest page. If the attempt
+ * fails, an attempt is made to export the page. If both attempts fail, an
+ * appropriate error is returned.
+ *
+ * Context: must be called holding the mm lock for gmap->mm
+ */
+static int __gmap_destroy_page(struct gmap *gmap, struct page *page)
+{
+	struct folio *folio = page_folio(page);
+	int rc;
+
+	/*
+	 * See gmap_make_secure(): large folios cannot be secure. Small
+	 * folio implies FW_LEVEL_PTE.
+	 */
+	if (folio_test_large(folio))
+		return -EFAULT;
+
+	rc = uv_destroy_folio(folio);
+	/*
+	 * Fault handlers can race; it is possible that two CPUs will fault
+	 * on the same secure page. One CPU can destroy the page, reboot,
+	 * re-enter secure mode and import it, while the second CPU was
+	 * stuck at the beginning of the handler. At some point the second
+	 * CPU will be able to progress, and it will not be able to destroy
+	 * the page. In that case we do not want to terminate the process,
+	 * we instead try to export the page.
+	 */
+	if (rc)
+		rc = uv_convert_from_secure_folio(folio);
+
+	return rc;
+}
+
+/**
+ * gmap_destroy_page() - Destroy a guest page.
+ * @gmap: the gmap of the guest
+ * @gaddr: the guest address to destroy
+ *
+ * An attempt will be made to destroy the given guest page. If the attempt
+ * fails, an attempt is made to export the page. If both attempts fail, an
+ * appropriate error is returned.
+ *
+ * Context: may sleep.
+ */
+int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
+{
+	struct page *page;
+	int rc = 0;
+
+	mmap_read_lock(gmap->mm);
+	page = gfn_to_page(gmap->private, gpa_to_gfn(gaddr));
+	if (page)
+		rc = __gmap_destroy_page(gmap, page);
+	kvm_release_page_clean(page);
+	mmap_read_unlock(gmap->mm);
+	return rc;
+}
diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
new file mode 100644
index 000000000000..f2b52ce29be3
--- /dev/null
+++ b/arch/s390/kvm/gmap.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2016, 2025
+ *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *               Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef ARCH_KVM_S390_GMAP_H
+#define ARCH_KVM_S390_GMAP_H
+
+int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
+int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
+int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
+
+#endif
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 5bbaadf75dc6..92ae003cd215 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -21,6 +21,7 @@
 #include "gaccess.h"
 #include "trace.h"
 #include "trace-s390.h"
+#include "gmap.h"
 
 u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2d63bee23f44..fe2827a9c882 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -50,6 +50,7 @@
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "pci.h"
+#include "gmap.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 75e81ba26d04..f0301e673810 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -17,6 +17,7 @@
 #include <linux/sched/mm.h>
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
+#include "gmap.h"
 
 bool kvm_s390_pv_is_protected(struct kvm *kvm)
 {
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 16b8a36c56de..3e6e25119a96 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -3035,3 +3035,31 @@ int s390_replace_asce(struct gmap *gmap)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_replace_asce);
+
+/**
+ * kvm_s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
+ * @mm:    the mm containing the folio to work on
+ * @folio: the folio
+ * @split: whether to split a large folio
+ *
+ * Context: Must be called while holding an extra reference to the folio;
+ *          the mm lock should not be held.
+ */
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
+{
+	int rc;
+
+	lockdep_assert_not_held(&mm->mmap_lock);
+	folio_wait_writeback(folio);
+	lru_add_drain_all();
+	if (split) {
+		folio_lock(folio);
+		rc = split_folio(folio);
+		folio_unlock(folio);
+
+		if (rc != -EBUSY)
+			return rc;
+	}
+	return -EAGAIN;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_wiggle_split_folio);
-- 
2.48.1


