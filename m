Return-Path: <kvm+bounces-38095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB290A34F0C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:08:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 368687A4D0B
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF3A266189;
	Thu, 13 Feb 2025 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sf1HJI6T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90502245B16;
	Thu, 13 Feb 2025 20:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477293; cv=none; b=FcqN5ovcQ6VvEgRiyGuY3w23T18IVta4GtnX9gX1Cqkw7zX1bftE2ID6rNyehMOTLRW8iUyF/10w+QiKaUnWLHqDbq1tysXkK2uzKU2j51xOYmm/ev9FyfiFmplW+xdq79YadCCk7UZ0fFclNTeW10QY3bVxf6J9pCs72D9/X9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477293; c=relaxed/simple;
	bh=WFkHIjRkYq2udFxiMBoppk1YWDW2wsno/8U3HvrC4uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4yV5LuRluC/GkyQ8ZD3q4gw0k3mlApR8AU9Ep3ADCEdztB2N1ftFcPj0hk3RReTi1OYgOCBXsM5jfzKkmYmzHhK/ZUmIsReCohG4KrTvi5rGR+RbBWYk8dXhwjuBSKu7TF+00MOa8cw7PiEoy8V16fTYvyopufZv/wE59ATVgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sf1HJI6T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51DG89UB015175;
	Thu, 13 Feb 2025 20:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QnfdJ+pnBxouUouwd
	jlSD9rEKeg3h0DNEYUXte3fGQo=; b=Sf1HJI6TGSnIv8GxUT6n66Kqr9Cj/D2ep
	n1Fr5F4RqgWoUyRY0P4WvAvwhGREY66d/If/P6M1p2MPoKDSi9MSrWQ8Lw48R3TS
	Ozezaige8VY9f/3SlVBY5TC/uiZVKPZ9n98h6Q5zE9syc+6mA0gk2ybQGPjthJ8B
	8vcC+C0qLt4cfYLOXjEJwuTbwxNYrEF1tXg/jic65srsbn4jHWuyZ+UnYKLvB9N3
	SG9npqpjbk36qg5AgxbYUAYoxQMZUK3jQHl54PXi7ca0U2USnHyxyZI/Z/k4XAI2
	hRGFR67pxynoDEFFoX7ewrDvcLqnL1vyiY/n/stq/Mbm2DE0CTfWA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44sceq3v2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Feb 2025 20:08:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51DJIQMg016689;
	Thu, 13 Feb 2025 20:08:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pk3kg16j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Feb 2025 20:08:08 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51DK84cq40501534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 20:08:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45B3920040;
	Thu, 13 Feb 2025 20:08:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A670D20043;
	Thu, 13 Feb 2025 20:08:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.41.52])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Feb 2025 20:08:03 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v1 1/2] KVM: s390: fix issues when splitting folios
Date: Thu, 13 Feb 2025 21:07:54 +0100
Message-ID: <20250213200755.196832-2-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: dBdElZUNlNIL7OokksXFv4aaR5gfISwU
X-Proofpoint-ORIG-GUID: dBdElZUNlNIL7OokksXFv4aaR5gfISwU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_08,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502130141

When splitting a folio with split_folio(), the extra reference on the
folio gets assigned to the first page of the old folio. Use
split_huge_page_to_list_to_order() instead, which transfers the extra
reference to a specified page.

Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  2 +-
 arch/s390/kvm/gmap.c         |  4 ++--
 arch/s390/mm/gmap.c          | 11 ++++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 4e73ef46d4b2..563df4d8ba90 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -139,7 +139,7 @@ int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
-int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct page *page, bool split);
 unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
 
 /**
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 02adf151d4de..fc4d490d25a2 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -72,7 +72,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
 		return -EFAULT;
 	if (folio_test_large(folio)) {
 		mmap_read_unlock(gmap->mm);
-		rc = kvm_s390_wiggle_split_folio(gmap->mm, folio, true);
+		rc = kvm_s390_wiggle_split_folio(gmap->mm, page, true);
 		mmap_read_lock(gmap->mm);
 		if (rc)
 			return rc;
@@ -100,7 +100,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
 	/* The folio has too many references, try to shake some off */
 	if (rc == -EBUSY) {
 		mmap_read_unlock(gmap->mm);
-		kvm_s390_wiggle_split_folio(gmap->mm, folio, false);
+		kvm_s390_wiggle_split_folio(gmap->mm, page, false);
 		mmap_read_lock(gmap->mm);
 		return -EAGAIN;
 	}
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 94d927785800..8117597419d3 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2630,14 +2630,15 @@ EXPORT_SYMBOL_GPL(s390_replace_asce);
 /**
  * kvm_s390_wiggle_split_folio() - try to drain extra references to a folio and optionally split
  * @mm:    the mm containing the folio to work on
- * @folio: the folio
+ * @page:  one of the pages of the folio that needs to be split
  * @split: whether to split a large folio
  *
  * Context: Must be called while holding an extra reference to the folio;
  *          the mm lock should not be held.
  */
-int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split)
+int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct page *page, bool split)
 {
+	struct folio *folio = page_folio(page);
 	int rc;
 
 	lockdep_assert_not_held(&mm->mmap_lock);
@@ -2645,7 +2646,11 @@ int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool
 	lru_add_drain_all();
 	if (split) {
 		folio_lock(folio);
-		rc = split_folio(folio);
+		rc = min_order_for_split(folio);
+		if (rc > 0)
+			rc = -EINVAL;
+		if (!rc)
+			rc = split_huge_page_to_list_to_order(page, NULL, 0);
 		folio_unlock(folio);
 
 		if (rc != -EBUSY)
-- 
2.48.1


