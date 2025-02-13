Return-Path: <kvm+bounces-38096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AC19A34F0D
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13D611890687
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE172661BC;
	Thu, 13 Feb 2025 20:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PMASN/N5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90856245B16;
	Thu, 13 Feb 2025 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477300; cv=none; b=ZSTPKzd0z1tn1A/jWNrAULqDvHrTnkyx6MikQr8wZql15keNh2bXJT9Y5X+bebOic9aWJc3jD5dqA2xKN3mFbOGtbaqYGfFJDTuZ1+6VoQ9KD3JzQC5Mg1O5otdA64q9O95iS3MFrDR/yk/+kcUsV3PKDJ95AERVw6/ipFyqVC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477300; c=relaxed/simple;
	bh=ORS5HrZy+g0Vrmbhcwj0RiL29dqM7JhzqFxHfA5+nMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9nqAMh0dxrAwVzt0FQRkJpOxMqFe7fsQbGoyxMplhdWAxBBHvYmVawJ2i50nnLqzd3PvVX1dKmARq7h6InH+sMblRKfaj8ggq1i0rvgmKEiuQxeYUlrPUx4SH5zLktzorig5Fst5go+ge3+fPK6D8AnL6cnJjFVDTtQrWz2L6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PMASN/N5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51DH0Vip001470;
	Thu, 13 Feb 2025 20:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Dt5HDnpCQtDO5o0o6
	tMBo3+xdOSCl9z7IQbdJlB/vSs=; b=PMASN/N5a6lf2smg6GJkXk2J13oGSq6pY
	Nw18EMDCYzup/cdMuacVIlJm2XCXC+cTbEXHAYGTVTVgriSKJKNSxR/a3CsYtYHy
	FrLu9jxWwwt6MYLK+CEFHwo6BElD4nKDLrnfFvBcqXVrMwfIfFUIRlJAgctfmxFg
	zx4ThNeQDO1eQIMTxEl95kCeGpBRUr7IoWj1CKeofS8qhVveJJMDQpfPAut3Kng0
	tzT9qIafUu4t9epMSAaBqFBvodAmNxWK1GRJwSNJdDVB5gWG32SFLZNFr+FCdSQR
	BzMqiZh3jvlJYPJIMLWRVEqJmu37VeKfJpc7oNDdUPG0mO0YAxqLg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44s4santq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Feb 2025 20:08:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51DGxIBn011656;
	Thu, 13 Feb 2025 20:08:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44pktk7st4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Feb 2025 20:08:08 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51DK85nw60358952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 20:08:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED74D20040;
	Thu, 13 Feb 2025 20:08:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A46020043;
	Thu, 13 Feb 2025 20:08:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.41.52])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Feb 2025 20:08:04 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v1 2/2] KVM: s390: pv: fix race when making a page secure
Date: Thu, 13 Feb 2025 21:07:55 +0100
Message-ID: <20250213200755.196832-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213200755.196832-1-imbrenda@linux.ibm.com>
References: <20250213200755.196832-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VpbHjetMkuaz9E9KCFu2bx-6s5XPsIls
X-Proofpoint-GUID: VpbHjetMkuaz9E9KCFu2bx-6s5XPsIls
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_08,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 clxscore=1015
 impostorscore=0 spamscore=0 mlxscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502130141

Holding the pte lock for the page that is being converted to secure is
needed to avoid races. A previous commit removed the locking, which
caused issues. Fix by locking the pte again.

Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  2 +-
 arch/s390/kernel/uv.c      | 19 +++++++++++++++++--
 arch/s390/kvm/gmap.c       | 12 ++++++++----
 3 files changed, 26 insertions(+), 7 deletions(-)

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
index 9f05df2da2f7..de3c092da7b9 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -245,7 +245,7 @@ static int expected_folio_refs(struct folio *folio)
  * Context: The caller must hold exactly one extra reference on the folio
  *          (it's the same logic as split_folio())
  */
-int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
+static int __make_folio_secure(struct folio *folio, unsigned long hva, struct uv_cb_header *uvcb)
 {
 	int expected, cc = 0;
 
@@ -277,7 +277,22 @@ int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 		return -EAGAIN;
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
-EXPORT_SYMBOL_GPL(make_folio_secure);
+
+int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
+{
+	spinlock_t *ptelock;
+	pte_t *ptep;
+	int rc;
+
+	ptep = get_locked_pte(mm, hva, &ptelock);
+	if (!ptep)
+		return -ENXIO;
+	rc = __make_folio_secure(page_folio(pte_page(*ptep)), hva, uvcb);
+	pte_unmap_unlock(ptep, ptelock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(make_hva_secure);
 
 /*
  * To be called with the folio locked or with an extra reference! This will
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index fc4d490d25a2..e56c0ab5fec7 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -55,7 +55,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
 	return atomic_read(&mm->context.protected_count) > 1;
 }
 
-static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
+static int __gmap_make_secure(struct gmap *gmap, struct page *page, unsigned long hva, void *uvcb)
 {
 	struct folio *folio = page_folio(page);
 	int rc;
@@ -83,7 +83,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
 		return -EAGAIN;
 	if (should_export_before_import(uvcb, gmap->mm))
 		uv_convert_from_secure(folio_to_phys(folio));
-	rc = make_folio_secure(folio, uvcb);
+	rc = make_hva_secure(gmap->mm, hva, uvcb);
 	folio_unlock(folio);
 
 	/*
@@ -120,6 +120,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 {
 	struct kvm *kvm = gmap->private;
+	unsigned long vmaddr;
 	struct page *page;
 	int rc = 0;
 
@@ -127,8 +128,11 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 
 	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
 	mmap_read_lock(gmap->mm);
-	if (page)
-		rc = __gmap_make_secure(gmap, page, uvcb);
+	vmaddr = gfn_to_hva(gmap->private, gpa_to_gfn(gaddr));
+	if (kvm_is_error_hva(vmaddr))
+		rc = -ENXIO;
+	if (!rc && page)
+		rc = __gmap_make_secure(gmap, page, vmaddr, uvcb);
 	kvm_release_page_clean(page);
 	mmap_read_unlock(gmap->mm);
 
-- 
2.48.1


