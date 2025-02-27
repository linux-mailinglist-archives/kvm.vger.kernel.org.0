Return-Path: <kvm+bounces-39569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EAAEA47E95
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5F19171785
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 123B022FDF2;
	Thu, 27 Feb 2025 13:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sb9kA4FL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B300224246;
	Thu, 27 Feb 2025 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740661813; cv=none; b=GpxTmQQIEdZXsGIYNi/e4EuwPOiFsHA/+S0IRmM+aJzeVXYNcgF9ywbnfZBWZ8lniWONMzYWRXSEpu0HHRR2NVtAGE7Mc+CFOVoU8XxhPJ4nWY0uZybrkBTPDhAbQPT6Ib+V9EivBQxCLtX03jY3u9DsPEZ7/j/g7f5lrZM7EUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740661813; c=relaxed/simple;
	bh=XsHhWP+gtPUIQQS0lQXR1RW7XGlCc2Fev4ihyV9a4s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axLac64GZX/W+sgkk92PO5j+KFrlxsmJMp1LiNfLPa2XRmOMo+lPAqpzCMTwhwRYfEVnGJjrUZbs1Xh2wvDQc33SfMQre1K7RF9tY1NpqWPNbiYdQ3YyIP/FpNPtpS9PWCNBsDCsN9eDFz79a/05/Sw0uMtr5S9AUBR9TaVwnN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sb9kA4FL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RBXdII028122;
	Thu, 27 Feb 2025 13:10:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XMw/tlzMCHwWHWdPY
	93QdHOtIDW3M0o8NQIxANYtI7U=; b=sb9kA4FLm7WOmkGDYHNVSLJQD6S0/RGm3
	x1gCqLHG93YEo4+IbQB0lPjFU5CtC90HAfIap6SHZoT/xO8dZQZw+a+jkW709pfd
	bW1vZUgy/MNmhS+n17rB1JVNUhTdsI/XwpyjQeorV/zOXd+6OccKOpn65D8YafCj
	ApqCWBAaTZRLDhssSmviBrBBxKpJ81Kp0I5OzriHWy9G8pgostKfzJMLc0Eoz5AA
	l+6y/FGF7eSJ5fAMMVfGwv7ysH3mWKtGOAcFGQzJiVhtE6E4l9qMRPYMnmSBRzZf
	UzwaCeKITMvrawUV9uU/HHrZkeJtjvQf1MXbpjQxjbjEAIhTyJh9Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452e4a304f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:10:08 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51RAoZ0b027344;
	Thu, 27 Feb 2025 13:10:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yum28aj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:10:07 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51RDA4o548497134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 13:10:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B80D20043;
	Thu, 27 Feb 2025 13:10:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 476C520040;
	Thu, 27 Feb 2025 13:10:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.9.246])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Feb 2025 13:10:03 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v3 1/1] KVM: s390: pv: fix race when making a page secure
Date: Thu, 27 Feb 2025 14:09:54 +0100
Message-ID: <20250227130954.440821-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250227130954.440821-1-imbrenda@linux.ibm.com>
References: <20250227130954.440821-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: erZ0Gs77WiDo7u-ih-VFi-mz3TV-UENj
X-Proofpoint-GUID: erZ0Gs77WiDo7u-ih-VFi-mz3TV-UENj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_06,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502270099

Holding the pte lock for the page that is being converted to secure is
needed to avoid races. A previous commit removed the locking, which
caused issues. Fix by locking the pte again.

Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
Reported-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |   2 +-
 arch/s390/kernel/uv.c      | 107 ++++++++++++++++++++++++++++++++++---
 arch/s390/kvm/gmap.c       |  99 +++-------------------------------
 arch/s390/kvm/kvm-s390.c   |  25 +++++----
 4 files changed, 123 insertions(+), 110 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index b11f5b6d0bd1..46fb0ef6f984 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -631,7 +631,7 @@ int uv_pin_shared(unsigned long paddr);
 int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
-int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
+int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_from_secure_folio(struct folio *folio);
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9f05df2da2f7..cacb12e59c1f 100644
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
@@ -277,7 +309,70 @@ int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
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
+		rc = kvm_s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
+	folio_put(folio);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(make_hva_secure);
 
 /*
  * To be called with the folio locked or with an extra reference! This will
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 02adf151d4de..c08950b4301c 100644
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
@@ -120,17 +34,16 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
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
-- 
2.48.1


