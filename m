Return-Path: <kvm+bounces-40070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A00E3A4EC91
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 20:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1892887A7B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC31280413;
	Tue,  4 Mar 2025 18:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dibot4Mf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EAC27D78E;
	Tue,  4 Mar 2025 18:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741112603; cv=none; b=p4cWQ/iQ5HZgxT9U0KA97yZYvVrviow/bGAoJKQwHLSXkkvO7xs3FO6umDMCY5d7Xzm4oF9FHEcHI9vQISwjhOrLpL1rdZGsK9/GC1H8v7MJ4j1gTajk3v0xtnw2HemB7Fmc82WWwDqcTeaIrWYWL5JT+hTjkkXQkVYMbf2j5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741112603; c=relaxed/simple;
	bh=Hf1+Q9B7fNe/ej2Mbd1SMDxXq+3aMbm7iwZqN4PckfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIKbeRJU14P4chVZDRksAyCOpkfb3jK35lUACDMv0VgSnDxbdkrXhGk11xHMp7hOH7iaJBQ0pFIb8jIlxBSgURxsXoVo9ijJRwAdHl2x+QTVUAQdURNhUTMA9CVfyEmHQYVK/RCEp96nO8VgkfDakX563vC692ZHbqTDrBkt9uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dibot4Mf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524Hv7WU022683;
	Tue, 4 Mar 2025 18:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XPR4OeLh0wi8xT4pG
	EsDOwQphy1IcO8B6FzVnfjUkEU=; b=Dibot4MfP+w3tLDEp5LXe1D5WyAGAoXDR
	NJgPpaNX2/wnr6Z4buNbyF4xp8doM5lKJBndh5FkD/JfxwzCkqyaImoVqb2C4M0i
	d84Myb5sTQcErp5a0YjyJdXiYbeIohoL+587q6qmq8oB4zmtzlkve5O67otOgttK
	iAf+AaFVnHmRWYQ2O04XL1kQtJmVKeqTYrnDmP2DfQ1ynwYOl+A4/UtQFPa0YbJo
	iSZLb3883bCS94PT3XFNdbFGmuQDU3TfjOXUaup0VyTTplL23XfG5yQJn9YzqA8l
	o4F3VgQt4YjepNoMU7Vmheuqso3UGAnScuCa3LXLTRxsMrAIs6ujA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455ku55kea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 18:23:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524IHBTx032680;
	Tue, 4 Mar 2025 18:23:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 454cjsy27m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 18:23:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524INB5o48496966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 18:23:11 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 408AD20043;
	Tue,  4 Mar 2025 18:23:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83BF720040;
	Tue,  4 Mar 2025 18:23:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.33.201])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 18:23:10 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v4 1/1] KVM: s390: pv: fix race when making a page secure
Date: Tue,  4 Mar 2025 19:23:04 +0100
Message-ID: <20250304182304.178746-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250304182304.178746-1-imbrenda@linux.ibm.com>
References: <20250304182304.178746-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LqHfD_5FsFNjgzd6r6y3iREoOALY_zzd
X-Proofpoint-GUID: LqHfD_5FsFNjgzd6r6y3iREoOALY_zzd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_07,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040144

Holding the pte lock for the page that is being converted to secure is
needed to avoid races. A previous commit removed the locking, which
caused issues. Fix by locking the pte again.

Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
Reported-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/gmap.h |   1 -
 arch/s390/include/asm/uv.h   |   3 +-
 arch/s390/kernel/uv.c        | 135 +++++++++++++++++++++++++++++++++--
 arch/s390/kvm/gmap.c         | 101 ++------------------------
 arch/s390/kvm/kvm-s390.c     |  25 ++++---
 arch/s390/mm/gmap.c          |  28 --------
 6 files changed, 153 insertions(+), 140 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 4e73ef46d4b2..9f2814d0e1e9 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -139,7 +139,6 @@ int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
-int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
 unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
 
 /**
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index b11f5b6d0bd1..fa33a6ff2fab 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -631,9 +631,10 @@ int uv_pin_shared(unsigned long paddr);
 int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
-int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
+int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_from_secure_folio(struct folio *folio);
+int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
 
 void setup_uv(void);
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9f05df2da2f7..63420a5f3ee5 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -206,6 +206,39 @@ int uv_convert_from_secure_pte(pte_t pte)
 	return uv_convert_from_secure_folio(pfn_folio(pte_pfn(pte)));
 }
 
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
 /*
  * Calculate the expected ref_count for a folio that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
@@ -228,7 +261,7 @@ static int expected_folio_refs(struct folio *folio)
 }
 
 /**
- * make_folio_secure() - make a folio secure
+ * __make_folio_secure() - make a folio secure
  * @folio: the folio to make secure
  * @uvcb: the uvcb that describes the UVC to be used
  *
@@ -243,14 +276,13 @@ static int expected_folio_refs(struct folio *folio)
  *         -EINVAL if the UVC failed for other reasons.
  *
  * Context: The caller must hold exactly one extra reference on the folio
- *          (it's the same logic as split_folio())
+ *          (it's the same logic as split_folio()), and the folio must be
+ *          locked.
  */
-int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
+static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 {
 	int expected, cc = 0;
 
-	if (folio_test_large(folio))
-		return -E2BIG;
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 	expected = expected_folio_refs(folio) + 1;
@@ -277,7 +309,98 @@ int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 		return -EAGAIN;
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
-EXPORT_SYMBOL_GPL(make_folio_secure);
+
+static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct uv_cb_header *uvcb)
+{
+	int rc;
+
+	if (!folio_trylock(folio))
+		return -EAGAIN;
+	if (should_export_before_import(uvcb, mm))
+		uv_convert_from_secure(folio_to_phys(folio));
+	rc = __make_folio_secure(folio, uvcb);
+	folio_unlock(folio);
+
+	return rc;
+}
+
+static pte_t *get_locked_valid_pte(struct mm_struct *mm, unsigned long hva, spinlock_t **ptl)
+{
+	pte_t *ptep = get_locked_pte(mm, hva, ptl);
+
+	if (ptep && (pte_val(*ptep) & _PAGE_INVALID)) {
+		pte_unmap_unlock(ptep, *ptl);
+		ptep = NULL;
+	}
+	return ptep;
+}
+
+/**
+ * s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
+ * @mm:    the mm containing the folio to work on
+ * @folio: the folio
+ * @split: whether to split a large folio
+ *
+ * Context: Must be called while holding an extra reference to the folio;
+ *          the mm lock should not be held.
+ */
+int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
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
+EXPORT_SYMBOL_GPL(s390_wiggle_split_folio);
+
+int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
+{
+	struct folio *folio;
+	spinlock_t *ptelock;
+	pte_t *ptep;
+	int rc;
+
+	ptep = get_locked_valid_pte(mm, hva, &ptelock);
+	if (!ptep)
+		return -ENXIO;
+
+	folio = page_folio(pte_page(*ptep));
+	folio_get(folio);
+	/*
+	 * Secure pages cannot be huge and userspace should not combine both.
+	 * In case userspace does it anyway this will result in an -EFAULT for
+	 * the unpack. The guest is thus never reaching secure mode.
+	 * If userspace plays dirty tricks and decides to map huge pages at a
+	 * later point in time, it will receive a segmentation fault or
+	 * KVM_RUN will return -EFAULT.
+	 */
+	if (folio_test_hugetlb(folio))
+		rc =  -EFAULT;
+	else if (folio_test_large(folio))
+		rc = -E2BIG;
+	else if (!pte_write(*ptep))
+		rc = -ENXIO;
+	else
+		rc = make_folio_secure(mm, folio, uvcb);
+	pte_unmap_unlock(ptep, ptelock);
+
+	if (rc == -E2BIG || rc == -EBUSY)
+		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
+	folio_put(folio);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(make_hva_secure);
 
 /*
  * To be called with the folio locked or with an extra reference! This will
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 02adf151d4de..21580cfecc6a 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -22,92 +22,6 @@
 
 #include "gmap.h"
 
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
-static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
-{
-	struct folio *folio = page_folio(page);
-	int rc;
-
-	/*
-	 * Secure pages cannot be huge and userspace should not combine both.
-	 * In case userspace does it anyway this will result in an -EFAULT for
-	 * the unpack. The guest is thus never reaching secure mode.
-	 * If userspace plays dirty tricks and decides to map huge pages at a
-	 * later point in time, it will receive a segmentation fault or
-	 * KVM_RUN will return -EFAULT.
-	 */
-	if (folio_test_hugetlb(folio))
-		return -EFAULT;
-	if (folio_test_large(folio)) {
-		mmap_read_unlock(gmap->mm);
-		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, true);
-		mmap_read_lock(gmap->mm);
-		if (rc)
-			return rc;
-		folio = page_folio(page);
-	}
-
-	if (!folio_trylock(folio))
-		return -EAGAIN;
-	if (should_export_before_import(uvcb, gmap->mm))
-		uv_convert_from_secure(folio_to_phys(folio));
-	rc = make_folio_secure(folio, uvcb);
-	folio_unlock(folio);
-
-	/*
-	 * In theory a race is possible and the folio might have become
-	 * large again before the folio_trylock() above. In that case, no
-	 * action is performed and -EAGAIN is returned; the callers will
-	 * have to try again later.
-	 * In most cases this implies running the VM again, getting the same
-	 * exception again, and make another attempt in this function.
-	 * This is expected to happen extremely rarely.
-	 */
-	if (rc == -E2BIG)
-		return -EAGAIN;
-	/* The folio has too many references, try to shake some off */
-	if (rc == -EBUSY) {
-		mmap_read_unlock(gmap->mm);
-		kvm_s390_wiggle_split_folio(gmap->mm, folio, false);
-		mmap_read_lock(gmap->mm);
-		return -EAGAIN;
-	}
-
-	return rc;
-}
-
 /**
  * gmap_make_secure() - make one guest page secure
  * @gmap: the guest gmap
@@ -115,22 +29,21 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
  * @uvcb: the UVCB specifying which operation needs to be performed
  *
  * Context: needs to be called with kvm->srcu held.
- * Return: 0 on success, < 0 in case of error (see __gmap_make_secure()).
+ * Return: 0 on success, < 0 in case of error.
  */
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 {
 	struct kvm *kvm = gmap->private;
-	struct page *page;
+	unsigned long vmaddr;
 	int rc = 0;
 
 	lockdep_assert_held(&kvm->srcu);
 
-	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
-	mmap_read_lock(gmap->mm);
-	if (page)
-		rc = __gmap_make_secure(gmap, page, uvcb);
-	kvm_release_page_clean(page);
-	mmap_read_unlock(gmap->mm);
+	vmaddr = gfn_to_hva(kvm, gpa_to_gfn(gaddr));
+	if (kvm_is_error_hva(vmaddr))
+		rc = -ENXIO;
+	else
+		rc = make_hva_secure(gmap->mm, vmaddr, uvcb);
 
 	return rc;
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ebecb96bacce..020502af7dc9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4952,6 +4952,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned int flags = 0;
 	unsigned long gaddr;
+	int rc;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
@@ -4961,16 +4962,6 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case 0:
 		vcpu->stat.exit_null++;
 		break;
-	case PGM_NON_SECURE_STORAGE_ACCESS:
-		kvm_s390_assert_primary_as(vcpu);
-		/*
-		 * This is normal operation; a page belonging to a protected
-		 * guest has not been imported yet. Try to import the page into
-		 * the protected guest.
-		 */
-		if (gmap_convert_to_secure(vcpu->arch.gmap, gaddr) == -EINVAL)
-			send_sig(SIGSEGV, current, 0);
-		break;
 	case PGM_SECURE_STORAGE_ACCESS:
 	case PGM_SECURE_STORAGE_VIOLATION:
 		kvm_s390_assert_primary_as(vcpu);
@@ -4995,6 +4986,20 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		}
 		break;
+	case PGM_NON_SECURE_STORAGE_ACCESS:
+		kvm_s390_assert_primary_as(vcpu);
+		/*
+		 * This is normal operation; a page belonging to a protected
+		 * guest has not been imported yet. Try to import the page into
+		 * the protected guest.
+		 */
+		rc = gmap_convert_to_secure(vcpu->arch.gmap, gaddr);
+		if (rc == -EINVAL)
+			send_sig(SIGSEGV, current, 0);
+		if (rc != -ENXIO)
+			break;
+		flags = FAULT_FLAG_WRITE;
+		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
 	case PGM_PAGE_TRANSLATION:
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 94d927785800..d14b488e7a1f 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2626,31 +2626,3 @@ int s390_replace_asce(struct gmap *gmap)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_replace_asce);
-
-/**
- * kvm_s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
- * @mm:    the mm containing the folio to work on
- * @folio: the folio
- * @split: whether to split a large folio
- *
- * Context: Must be called while holding an extra reference to the folio;
- *          the mm lock should not be held.
- */
-int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
-{
-	int rc;
-
-	lockdep_assert_not_held(&mm->mmap_lock);
-	folio_wait_writeback(folio);
-	lru_add_drain_all();
-	if (split) {
-		folio_lock(folio);
-		rc = split_folio(folio);
-		folio_unlock(folio);
-
-		if (rc != -EBUSY)
-			return rc;
-	}
-	return -EAGAIN;
-}
-EXPORT_SYMBOL_GPL(kvm_s390_wiggle_split_folio);
-- 
2.48.1


