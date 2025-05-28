Return-Path: <kvm+bounces-47897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CD8AC6DBE
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 18:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97A5B3B1548
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D46228D836;
	Wed, 28 May 2025 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZgpjSsu9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3BB28CF7C;
	Wed, 28 May 2025 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449017; cv=none; b=j6Uog8HmU/qFTJ6N2dtNONzY33HwnkY5C0zK1X96OZPTphrF1ThqPhSUi5C+YQ/bJ/2sBLqJKWRYmCB2KiFbX0oyT86m9dTPJlFL6/jbF1EEECQxrz0FFCVFEzao/hGOnJf1l6a6pemhmd/e3f30cXPkueQ/56fAX8UURy6/xJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449017; c=relaxed/simple;
	bh=/ym5VcY4W49DTJ0l9IME5f0qxruTLakDNef7R2lWvqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3nynDDWiDsfPg0xgsCkVSLHR4wqwYBUDguDKgWJCvRNA54pxlhr8/QT0n0lnAuHDvMVnLMSe1q8J+xBEz3Xh8QKGr/I0PxwfixvExKhIu0ARRWXj07KBJ0wh7zi7FY+L1T2IIAo9YiETbIqfCSrI09l56/ADg/cxaDji8G5z/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZgpjSsu9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SE9LrR017181;
	Wed, 28 May 2025 16:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=boVqgYyux6n5rMbJ4
	EuLlky9Xe9ZCQgrkdzqh7Py93s=; b=ZgpjSsu9E+3HU1sS4QEjc/O4PpewraAlF
	2FK81gNvXEcjNdX5SxU90JTZlTw6w/kBZLNSdORhUg8RfUt/4TyRwG6YiGET5ZGb
	wCP/2ZzRc9tB/Pfjvsu2x0Ga1f2oZzJTQ9Ufh7tJUVtJZUmc5y7oE3r0KY69N+9A
	+PUgC9F0QeCK7kv9XuHSsd1zBv3mqDJtpDU7tWa4Eli+kH2YVT25qsKEXQfnpEeX
	asitwf2BLtg6om1f1VyfyBvOOo/lgtcMP20JeMlx8/qzwZtMGi+gGobmjt8hnRfV
	zH8JTy3BNpRPqx+mjBfPhFDzHfEdxPL2HdaqSGFSbmDKW1E99892w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40ggpmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SElX73015798;
	Wed, 28 May 2025 16:16:50 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46uu537xx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 16:16:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SGGkHT33882764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 16:16:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D32A20049;
	Wed, 28 May 2025 16:16:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CB912004B;
	Wed, 28 May 2025 16:16:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 16:16:45 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 3/7] s390/uv: Improve splitting of large folios that cannot be split while dirty
Date: Wed, 28 May 2025 18:16:32 +0200
Message-ID: <20250528161636.280717-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250528161636.280717-1-imbrenda@linux.ibm.com>
References: <20250528161636.280717-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=avmyCTZV c=1 sm=1 tr=0 ts=683736f2 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=wEelP6EhEpy43wW1egAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzOSBTYWx0ZWRfX6+JQjJEq4mQ6 3v/lXdG9bHBOUYHoi9TyTvmdoETLKzWVV42DMPVSf2bq8Rj0DKqzj7Or0pQYKl/VP1x0Lx8Pf8X PSGVMhnAgG4fEZEdb0OoDdBeclQwkBDLQW3NU1SBWeK2VyDmolzFUo46zeEz8a4DAvAXCxS06jc
 YMkJvkVRzumfK0JIyaxzRXKw8hSugaHV6JZNDhFLQuRh4QCZQ+9NCmB5nT6oVkta2ldVWEyzp5N nWgywmWDcdb5QfLJSGTNugLFbcBG6hG7Q3gtDzwNqF/umEs+NjNMiPZkUWCe7KbFVH8hpmYqSKN 4xn15IU281eYsU5RJ5qfUAFPtSegQkLEa2k5YnmYH7I1xFGDVqMvo2Ka4UnQaW6X/1gTVNa5lUw
 HKZbuXSO75Qoi1cDKq7HobWvrFJVR8oMyxEQtuIHhjIhwlfH3qfyJGVfD1VMekPwYQbmc7HY
X-Proofpoint-GUID: uCIKebkAZXBshRWtvg7XiZxYsbJg6cz5
X-Proofpoint-ORIG-GUID: uCIKebkAZXBshRWtvg7XiZxYsbJg6cz5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_08,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280139

From: David Hildenbrand <david@redhat.com>

Currently, starting a PV VM on an iomap-based filesystem with large
folio support, such as XFS, will not work. We'll be stuck in
unpack_one()->gmap_make_secure(), because we can't seem to make progress
splitting the large folio.

The problem is that we require a writable PTE but a writable PTE under such
filesystems will imply a dirty folio.

So whenever we have a writable PTE, we'll have a dirty folio, and dirty
iomap folios cannot currently get split, because
split_folio()->split_huge_page_to_list_to_order()->filemap_release_folio()
will fail in iomap_release_folio().

So we will not make any progress splitting such large folios.

Until dirty folios can be split more reliably, let's manually trigger
writeback of the problematic folio using
filemap_write_and_wait_range(), and retry the split immediately
afterwards exactly once, before looking up the folio again.

Should this logic be part of split_folio()? Likely not; most split users
don't have to split so eagerly to make any progress.

For now, this seems to affect xfs, zonefs and erofs, and this patch
makes it work again (tested on xfs only).

While this could be considered a fix for commit 6795801366da ("xfs: Support
large folios"), commit df2f9708ff1f ("zonefs: enable support for large
folios") and commit ce529cc25b18 ("erofs: enable large folios for iomap
mode"), before commit eef88fe45ac9 ("s390/uv: Split large folios in
gmap_make_secure()"), we did not try splitting large folios at all. So it's
all rather part of making SE compatible with file systems that support
large folios. But to have some "Fixes:" tag, let's just use eef88fe45ac9.

Not CCing stable, because there are a lot of dependencies, and it simply
not working is not critical in stable kernels.

Reported-by: Sebastian Mitterle <smitterl@redhat.com>
Closes: https://issues.redhat.com/browse/RHEL-58218
Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250516123946.1648026-4-david@redhat.com
Message-ID: <20250516123946.1648026-4-david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 66 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f6ddb2b54032..d278bf0c09d1 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/pagewalk.h>
+#include <linux/backing-dev.h>
 #include <asm/facility.h>
 #include <asm/sections.h>
 #include <asm/uv.h>
@@ -338,22 +339,75 @@ static int make_folio_secure(struct mm_struct *mm, struct folio *folio, struct u
  */
 static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
 {
-	int rc;
+	int rc, tried_splits;
 
 	lockdep_assert_not_held(&mm->mmap_lock);
 	folio_wait_writeback(folio);
 	lru_add_drain_all();
 
-	if (folio_test_large(folio)) {
+	if (!folio_test_large(folio))
+		return 0;
+
+	for (tried_splits = 0; tried_splits < 2; tried_splits++) {
+		struct address_space *mapping;
+		loff_t lstart, lend;
+		struct inode *inode;
+
 		folio_lock(folio);
 		rc = split_folio(folio);
+		if (rc != -EBUSY) {
+			folio_unlock(folio);
+			return rc;
+		}
+
+		/*
+		 * Splitting with -EBUSY can fail for various reasons, but we
+		 * have to handle one case explicitly for now: some mappings
+		 * don't allow for splitting dirty folios; writeback will
+		 * mark them clean again, including marking all page table
+		 * entries mapping the folio read-only, to catch future write
+		 * attempts.
+		 *
+		 * While the system should be writing back dirty folios in the
+		 * background, we obtained this folio by looking up a writable
+		 * page table entry. On these problematic mappings, writable
+		 * page table entries imply dirty folios, preventing the
+		 * split in the first place.
+		 *
+		 * To prevent a livelock when trigger writeback manually and
+		 * letting the caller look up the folio again in the page
+		 * table (turning it dirty), immediately try to split again.
+		 *
+		 * This is only a problem for some mappings (e.g., XFS);
+		 * mappings that do not support writeback (e.g., shmem) do not
+		 * apply.
+		 */
+		if (!folio_test_dirty(folio) || folio_test_anon(folio) ||
+		    !folio->mapping || !mapping_can_writeback(folio->mapping)) {
+			folio_unlock(folio);
+			break;
+		}
+
+		/*
+		 * Ideally, we'd only trigger writeback on this exact folio. But
+		 * there is no easy way to do that, so we'll stabilize the
+		 * mapping while we still hold the folio lock, so we can drop
+		 * the folio lock to trigger writeback on the range currently
+		 * covered by the folio instead.
+		 */
+		mapping = folio->mapping;
+		lstart = folio_pos(folio);
+		lend = lstart + folio_size(folio) - 1;
+		inode = igrab(mapping->host);
 		folio_unlock(folio);
 
-		if (rc != -EBUSY)
-			return rc;
-		return -EAGAIN;
+		if (unlikely(!inode))
+			break;
+
+		filemap_write_and_wait_range(mapping, lstart, lend);
+		iput(mapping->host);
 	}
-	return 0;
+	return -EAGAIN;
 }
 
 int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
-- 
2.49.0


