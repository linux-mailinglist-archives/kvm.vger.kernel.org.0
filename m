Return-Path: <kvm+bounces-34822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64AEEA06426
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55B621676E9
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7AD2010E6;
	Wed,  8 Jan 2025 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Qw66DaQ1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714D201016;
	Wed,  8 Jan 2025 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360108; cv=none; b=LJO3jYpeTYcuEOqJg7HajR9AF6zbwdaKLcIQmTfawG49Xd7ZKGR/vbebuKDIpAtS4qizrCtenaBQj6REWNLsvZLqCwnGhtRJ9+PgEZ8zm+7GL3dvHbkG5hlUzWU0ndQlHHV7mkhX3W8Vh7XXpvoAdq1UGSHru/YJFHk4TcjCDMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360108; c=relaxed/simple;
	bh=LaUHCvPmMpJFZ/HypkesW2Xtd1TCoh5oNqM2iVxH2H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmOxB3ppFRrhW9p1WNHmhYYIdID9e2pf/BDZNhVRmvspLppzocGy01lwOJZo80Z4bkurkEVP4LfCOYsQg2cBNbq/hM5jnoNJMpb4YajRcURGve98Jm9PXpEgASdvLNcWPpB96yvydbGTmvtwDb99f09IK5fY9H1/NLWI7F19L1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Qw66DaQ1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508Djx9f015550;
	Wed, 8 Jan 2025 18:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Qgc8QgXRR7IkuxvLL
	/YSOwOuvq0I7tHbwyhQyZTXID8=; b=Qw66DaQ1qWVzPdidCCrjthbk8kynBaXpO
	ZA7t7gHziO0iRWS5rzUkGU+ZJI9XtTRATSwYFDVqFJ60vEC0Q2vFvgEkF5qxRVmF
	xC5Hlck0Qhab2KPqPCWzK/IIlSvGkfMDwxX9OgV3pVTv0lKAI/ClXGCWTQ5vBjsF
	lYWROH0kOS6R7UJtr5vyDtluPvkdCJ9YWjWU1kmgRIL0wmG7o4JdB/4J5N19RGYc
	QMzDTmkocU0XcjSos7h5jj9xdwJTNrDyBU4chmg/0RjJybgBNiJhTZZkd9b2NDiP
	Ew4zsaLI9G/D2pD/4ESHhHnqMYvUlJ+3ME5aB75pWSRa3nlYk/U7g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huc3tqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508GpxAW013659;
	Wed, 8 Jan 2025 18:14:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygap12f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEr7f45679074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28F8B2004B;
	Wed,  8 Jan 2025 18:14:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E60A920043;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 04/13] KVM: s390: move pv gmap functions into kvm
Date: Wed,  8 Jan 2025 19:14:42 +0100
Message-ID: <20250108181451.74383-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108181451.74383-1-imbrenda@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: biODPBwaMYK47rNTACh2eEcj3UcNR3N1
X-Proofpoint-GUID: biODPBwaMYK47rNTACh2eEcj3UcNR3N1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080148

Move gmap related functions from kernel/uv into kvm.

Create a new file to collect gmap-related functions.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |   7 +-
 arch/s390/kernel/uv.c      | 293 ++++++-------------------------------
 arch/s390/kvm/Makefile     |   2 +-
 arch/s390/kvm/gmap.c       | 183 +++++++++++++++++++++++
 arch/s390/kvm/gmap.h       |  17 +++
 arch/s390/kvm/intercept.c  |   1 +
 arch/s390/kvm/kvm-s390.c   |   1 +
 arch/s390/kvm/pv.c         |   1 +
 8 files changed, 251 insertions(+), 254 deletions(-)
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index dc332609f2c3..22ec1a24c291 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -628,12 +628,13 @@ static inline int is_prot_virt_host(void)
 }
 
 int uv_pin_shared(unsigned long paddr);
-int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
-int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
 int uv_convert_from_secure_pte(pte_t pte);
-int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
+int uv_wiggle_folio(struct folio *folio, bool split);
+int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
+int uv_convert_from_secure(unsigned long paddr);
+int uv_convert_from_secure_folio(struct folio *folio);
 
 void setup_uv(void);
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 6f9654a191ad..832c39c9ccfa 100644
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
@@ -237,13 +227,32 @@ static int expected_folio_refs(struct folio *folio)
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
+ *         -EBUSY if the folio is in writeback, has too many references, or is large;
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
+		return -EBUSY;
 	if (folio_test_writeback(folio))
-		return -EAGAIN;
-	expected = expected_folio_refs(folio);
+		return -EBUSY;
+	expected = expected_folio_refs(folio) + 1;
 	if (!folio_ref_freeze(folio, expected))
 		return -EBUSY;
 	set_bit(PG_arch_1, &folio->flags);
@@ -267,251 +276,35 @@ static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 		return -EAGAIN;
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
+EXPORT_SYMBOL_GPL(make_folio_secure);
 
 /**
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
+ * uv_wiggle_folio() - try to drain extra references to a folio
+ * @folio: the folio
+ * @split: whether to split a large folio
  *
- * No export is needed also when there is only one protected VM, because the
- * page cannot belong to the wrong VM in that case (there is no "other VM"
- * it can belong to).
- *
- * Return: true if an export is needed before every import, otherwise false.
+ * Context: Must be called while holding an extra reference to the folio;
+ *          the mm lock should not be held.
  */
-static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
+int uv_wiggle_folio(struct folio *folio, bool split)
 {
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
 	int rc;
 
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
+	folio_wait_writeback(folio);
+	if (split) {
 		folio_lock(folio);
 		rc = split_folio(folio);
 		folio_unlock(folio);
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
+
+		if (rc == -EBUSY)
 			return -EAGAIN;
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
+		if (rc != -EAGAIN)
+			return rc;
 	}
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
+	lru_add_drain_all();
+	return -EAGAIN;
 }
-EXPORT_SYMBOL_GPL(gmap_destroy_page);
+EXPORT_SYMBOL_GPL(uv_wiggle_folio);
 
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
index 000000000000..a142bbbddc25
--- /dev/null
+++ b/arch/s390/kvm/gmap.c
@@ -0,0 +1,183 @@
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
+	 * the unpack. The guest is thus never reaching secure mode. If
+	 * userspace is playing dirty tricky with mapping huge pages later
+	 * on this will result in a segmentation fault or in a -EFAULT return
+	 * code from the KVM_RUN ioctl.
+	 */
+	if (folio_test_hugetlb(folio))
+		return -EFAULT;
+	if (folio_test_large(folio)) {
+		mmap_read_unlock(gmap->mm);
+		rc = uv_wiggle_folio(folio, true);
+		mmap_read_lock(gmap->mm);
+		if (rc)
+			return rc;
+		folio = page_folio(page);
+	}
+
+	rc = -EAGAIN;
+	if (folio_trylock(folio)) {
+		if (should_export_before_import(uvcb, gmap->mm))
+			uv_convert_from_secure(folio_to_phys(folio));
+		rc = make_folio_secure(folio, uvcb);
+		folio_unlock(folio);
+	}
+
+	/*
+	 * Unlikely case: the page is not mapped anymore. Return success
+	 * and let the proper fault handler fault in the page again.
+	 */
+	if (rc == -ENXIO)
+		return 0;
+	/* The folio has too many references, try to shake some off */
+	if (rc == -EBUSY) {
+		mmap_read_unlock(gmap->mm);
+		uv_wiggle_folio(folio, false);
+		mmap_read_lock(gmap->mm);
+		return -EAGAIN;
+	}
+
+	return rc;
+}
+
+int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
+{
+	struct page *page;
+	int rc = 0;
+
+	mmap_read_lock(gmap->mm);
+	page = gfn_to_page(gmap->private, gpa_to_gfn(gaddr));
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
+ * gmap_destroy_page - Destroy a guest page.
+ * @gmap: the gmap of the guest
+ * @gaddr: the guest address to destroy
+ *
+ * An attempt will be made to destroy the given guest page. If the attempt
+ * fails, an attempt is made to export the page. If both attempts fail, an
+ * appropriate error is returned.
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
index 8e4e7e45238b..bdbb143a75c9 100644
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
-- 
2.47.1


