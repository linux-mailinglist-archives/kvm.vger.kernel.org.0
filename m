Return-Path: <kvm+bounces-26404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B129F9746AC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55E89286496
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7045C1BB688;
	Tue, 10 Sep 2024 23:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5CmHT76"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53101BC06D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011895; cv=none; b=KjaekAd+LgNn2RUyt1vi0lcCwRzuytF4NbfM2NlMJTHoN/naP9WG9EiWPc/Lj1pOI6DYIeE47Oj/72hhKXiBfBbAGa8PWk9lusgdAL184Ftz+Va4LByRxEBu87xpLodjYTIeaMe32AYqUuzHlgZoC9yMWkEhfBZdBeBFWjShRDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011895; c=relaxed/simple;
	bh=jfrlv9Zwe9WtcJZnfnb3Is0i40E/8Bmzj5N4J0pkDAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jEY9CO9x3Y0MrbJVMgcVuQNHR2uscXh8jGFO03Kv42PmJgoB0uN667oVXIXxVuGjsNKzFafT6iONRrzkpSQA5Ldca0nc6CWSmgN0Seis0NnDSBMCQKEvrXLoWD7lHV76EWGl28g3eq5uxAg7TCcYea4s8xt3B299NPHSP8qqPdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5CmHT76; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1a6d328eacso2912252276.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011893; x=1726616693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gEfEne/GQ2Ka6MCKI1Fo0Z3xc55YqHsI9PC21Ep9Z3Y=;
        b=E5CmHT76fBBu+F/q4KGEOE2wmRqPW9mRbNmFKKDxFFMnOuHGleA0eX+0cIpVG7rkb/
         sk0eYvo1Xi0n/Fmh8qku3Dd1Y3XMH6uMeWW9NQEXqh9xxWdUyhORl8QZ9LpxnsWYNBra
         COcmIprNQpNoT4GwSNk5UNASnbv7hUgnECVppTlfiPOUEYA4XFRUR/e21fdK344630Li
         P04PRj8tE+jF3XilgPp1gFEkDOeblVi5Z7D8q3EGvjTUZqwKXMPPHKGkjvjtKg71aOgP
         KZCr3XwYWr/c6TqtkNgAy8PEFIMJ37/z1L+DwO+RVYFhZvqMFPBtsjrieu9JuL57dkwu
         3qLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011893; x=1726616693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gEfEne/GQ2Ka6MCKI1Fo0Z3xc55YqHsI9PC21Ep9Z3Y=;
        b=TdWdMBZ/RHGlJ8DGG3uqzOHTG9R8XbPkv9XDL73p9qL+a7L0hFxQkBgwNcHvI7bEfk
         toASnady6j4vBpETtPVObd7cu6efiixyi2wC2aPpimNA3UWH00+3HmWk0ixCJE+rkRun
         V1TWILHS/QwjYwGWhV4WrYvnY2slluIihykygJl1EDN6UrrpJl9Sl0cVDXyKkT3nV1k7
         t9+ZiRUN6JifJ0fLCNomSYbjv5T88lB9asHJmbjpKSXcDJnl4iHeiQbmOwDdaaFXJOCY
         HnrikJh2ddak2eDFjpLW4nvevAm8h2lHza5OC2Ht8TCagvMI4qvlu74d9tQw+0Ozz5rQ
         720A==
X-Forwarded-Encrypted: i=1; AJvYcCXoq7KiRH7r6TW23e/21zJHJEzozKaZii1xqlqT+OqF9pUO7lmSKaiHXLGiL2wXaqjH1QA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUdCTrmD42mMk09n6vL7IHQUBoJ3eZml13+8c3fttQN03LfDVb
	Wkf46HtpU97eJkgxftyzKmTBRLyODnGdClMVItvC34/HEezwte7hNhpb0zzqL9EY4JK8aOZtcrA
	6UWFPbaS6dwu8AGq15PVYYg==
X-Google-Smtp-Source: AGHT+IF6ODlxEXjF8aJZSBZZ4I/iqFxheCqSbnSqwhL4p+xdg87aJqDyTNVQn4Ts0x37EKQBXrqF/+I4z5+HsrSwWw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a25:698a:0:b0:e16:50d2:3d39 with SMTP
 id 3f1490d57ef6-e1d8c5610cbmr1470276.9.1726011892629; Tue, 10 Sep 2024
 16:44:52 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:43 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <315ae41e7a53edab139c0323fa96892f2b647450.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 12/39] mm: hugetlb: Move and expose hugetlb_zero_partial_page()
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

This will used by guest_memfd in a later patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c    | 33 +++++----------------------------
 include/linux/hugetlb.h |  3 +++
 mm/hugetlb.c            | 21 +++++++++++++++++++++
 3 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 300a6ef300c1..f76001418672 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -720,29 +720,6 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
 }
 
-static void hugetlbfs_zero_partial_page(struct hstate *h,
-					struct address_space *mapping,
-					loff_t start,
-					loff_t end)
-{
-	pgoff_t idx = start >> huge_page_shift(h);
-	struct folio *folio;
-
-	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
-	if (IS_ERR(folio))
-		return;
-
-	start = start & ~huge_page_mask(h);
-	end = end & ~huge_page_mask(h);
-	if (!end)
-		end = huge_page_size(h);
-
-	folio_zero_segment(folio, (size_t)start, (size_t)end);
-
-	folio_unlock(folio);
-	folio_put(folio);
-}
-
 static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
@@ -768,9 +745,10 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	i_mmap_lock_write(mapping);
 
 	/* If range starts before first full page, zero partial page. */
-	if (offset < hole_start)
-		hugetlbfs_zero_partial_page(h, mapping,
-				offset, min(offset + len, hole_start));
+	if (offset < hole_start) {
+		hugetlb_zero_partial_page(h, mapping, offset,
+					  min(offset + len, hole_start));
+	}
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
@@ -782,8 +760,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	/* If range extends beyond last full page, zero partial page. */
 	if ((offset + len) > hole_end && (offset + len) > hole_start)
-		hugetlbfs_zero_partial_page(h, mapping,
-				hole_end, offset + len);
+		hugetlb_zero_partial_page(h, mapping, hole_end, offset + len);
 
 	i_mmap_unlock_write(mapping);
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 4d47bf94c211..752062044b0b 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -124,6 +124,9 @@ long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta);
 
 int hugetlb_acct_memory(struct hstate *h, long delta);
 
+void hugetlb_zero_partial_page(struct hstate *h, struct address_space *mapping,
+			       loff_t start, loff_t end);
+
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
 int move_hugetlb_page_tables(struct vm_area_struct *vma,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5a37b03e1361..372d8294fb2f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1989,6 +1989,27 @@ void free_huge_folio(struct folio *folio)
 	}
 }
 
+void hugetlb_zero_partial_page(struct hstate *h, struct address_space *mapping,
+			       loff_t start, loff_t end)
+{
+	pgoff_t idx = start >> huge_page_shift(h);
+	struct folio *folio;
+
+	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+	if (IS_ERR(folio))
+		return;
+
+	start = start & ~huge_page_mask(h);
+	end = end & ~huge_page_mask(h);
+	if (!end)
+		end = huge_page_size(h);
+
+	folio_zero_segment(folio, (size_t)start, (size_t)end);
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 /*
  * Must be called with the hugetlb lock held
  */
-- 
2.46.0.598.g6f2099f65c-goog


