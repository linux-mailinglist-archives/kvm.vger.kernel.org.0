Return-Path: <kvm+bounces-65293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8A0CA43BC
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 16:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8E6D3212A53
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 15:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A740A2DE6E9;
	Thu,  4 Dec 2025 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCJg/gpB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFVOQqOR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A272C08D4
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861017; cv=none; b=CuF+dEzAZDBztC4pjpoGnD0UteUVJGi7kBa/9tExgEBlBlxMTqyHOkDS0vSrvwEMoL9hF2wJntHp9Abji481eMhqSupSu3vNjc5bL9EcXsqqparcAXZi+rKPwcrIplm8+/FpNCIWbXBTwzUMdBydu+PzPs2QgsyVUZlKIPsRqKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861017; c=relaxed/simple;
	bh=/4MuTMD61olHbfivKDj1nhPnv6vtHlkiwYjbKFAVOmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWj84eQNJ3fFOL6HCiBwrwIo10rTo0BvHS+mQy6F7nMRah2ers/fZaoOBfzcbpodhTrn+HlL2BNbmAj78p82qgo7OWpJwpyZbBbX6eanNuBseyx4WbaJd19BW0KlDuNg5W16vXSiZEyAoNb56iNlcSiEeh3rqJUq2oEy9z9posU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PCJg/gpB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFVOQqOR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=shBKdGm4YTOEDFQeXrEUnQGLwKuFe6yb6HVy/vXuL+M=;
	b=PCJg/gpBE0UnH8t5HhtmfYz8wxEMslipnanUcniiiDJztA1NnCHez9dtC7905uaEDjQBki
	drQP7mEkgsaqy8RoJPt6GtmfIDUisnt4pJ22pPh/MmK+OoBjr0ETtcJGHUYwYcKEfbhKrh
	y+ob+z3TgXv3IzdhamtJXLH1hfPJrMk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-4zOaLfvJM1qgR60zJcZh7g-1; Thu, 04 Dec 2025 10:10:11 -0500
X-MC-Unique: 4zOaLfvJM1qgR60zJcZh7g-1
X-Mimecast-MFC-AGG-ID: 4zOaLfvJM1qgR60zJcZh7g_1764861011
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b22d590227so128807785a.1
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 07:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764861011; x=1765465811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shBKdGm4YTOEDFQeXrEUnQGLwKuFe6yb6HVy/vXuL+M=;
        b=hFVOQqORF6F0Fcyni/hXlu/o/8XVfo9dOxQQWB4me5Un66wiHXFMfLnqP6i2KlhcOe
         LnBg8X8jkMqu5VRpziMd6RU4wnvpt1L5JEGhJpZO2POZzbcpXZhNVG2FxAZMyqMiszb3
         4fJkO96F8Ku6ikzRjaP/x590bxtE4EHu0WM+S66bwZJ9PkMREZrMVGPbHNi4a2aiVJ+i
         4f/JRg3HY2OdN3xUaFnkUwGhPphGRgHt6YKOmKlhvMPxifyg0TA7CLgzUSIoTFEhh4zL
         R+vLZUvodp1MdKwnV5T14TMbrPCm/SlChEi/wjDtIoY13z2q73Dm2j+Qw4rkKnJSwYL3
         j4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861011; x=1765465811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=shBKdGm4YTOEDFQeXrEUnQGLwKuFe6yb6HVy/vXuL+M=;
        b=wmJrSXG5Og8KnhLpZrys9p9o3wxsGb3X8XnW2MziF7Pj1eYN5zF9ypgwdGHUVcCGIt
         lNyqJKOGlPQMkB2Nb7ftHb+hbTVmUQXVmeTmbyKMdNkTkN6lNmGeWZNgOobPdjK/M5sC
         OviQfwm3vPwHYGi+fHayS6EHUPnqGeRXcfyX9AEgBudBy6zcLqpasxQWDSKhwI2qgaOW
         oHTHfPdcMPomfPPQOLlR9r29ubbB9aMRoBXGT7IxeZbnhkocXfajesFyqz7WMiyuuYki
         JSDKg4NT86mKyRem2JwRYApWNy+uiadycp99JQfFV63A5xoiZ7e+adGavwwg/9C70erE
         pX+Q==
X-Gm-Message-State: AOJu0YzzsqZyJkt+HdDoJZDvsUfqocJiVs6zI/4MQuLcQ66d01gVxdfA
	nqEV1+hPshAsCE48tabNO3MFuLMVQBMHdmLA2BcDb8ucSHArxPPPtzyjdsT/aTG97Oa5C4heyy1
	Vz44tQrf1SlxWb7j1ip2gPukHgi3+uOszhcSGd1hxKVC7HiH5oApt3wvaBCOiZF5gjH/l0lIgfw
	oB3KVurccvAnH0kE8TNyzaM2CrBK+fgHlOIxs=
X-Gm-Gg: ASbGncuBJ9TCkzjsywnju21Z1xqR068yydmXlkPBV5xkYARjK0FB3asCETyR3fSVYZP
	ydZeGCH2XCPlDA5VFUrozUroJuLetQ6sYIzDl5yloEwdHhJBI73eCSUubyII+g7vGrSzM0saiF0
	ANPGoHTSrdomcjbjeDKc8I4+iQCebgdZgWN55KwWZky9Vyd4HArTeSw9acNkEbJB77FTuOYalkA
	htvKevHQOzj864jTMBGweCre2eC3d56Ek4bCWw7IENHT6m3kHNrVuBH2hKobmcGK2fgzfMZw7aV
	O6/zUSONc1tXxRdzsjRrgWJ+VDLKsJl4MydvgsCdm9TOE70fgsCmn4S0SQkbPwwam8J9/Y2wR4c
	k
X-Received: by 2002:a05:620a:408c:b0:89f:52d:8560 with SMTP id af79cd13be357-8b6181ed8b6mr519470785a.47.1764861010605;
        Thu, 04 Dec 2025 07:10:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUYHhbX8YMXNGXZOpMbNo0BJJ62y/raaT2i4rcEhXIK6eeuVSL9soO5R2l6I/8tLGphH/NCA==
X-Received: by 2002:a05:620a:408c:b0:89f:52d:8560 with SMTP id af79cd13be357-8b6181ed8b6mr519458985a.47.1764861009954;
        Thu, 04 Dec 2025 07:10:09 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:09 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Date: Thu,  4 Dec 2025 10:10:01 -0500
Message-ID: <20251204151003.171039-3-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
References: <20251204151003.171039-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add one new file operation, get_mapping_order().  It can be used by file
backends to report mapping order hints.

By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
the driver can report the possibility of mapping chunks that are larger
than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
when allocating the VA ranges.

This is useful because when chunks to be mapped are larger than PAGE_SIZE,
VA alignment matters and it needs to be aligned with the size of the chunk
to be mapped.

Said that, no matter what is the alignment used for the VA allocation, the
driver can still decide which size to map the chunks.  It is also not an
issue if it keeps mapping in PAGE_SIZE.

get_mapping_order() is defined to take three parameters.  Besides the 1st
parameter which will be the file object pointer, the 2nd + 3rd parameters
being the pgoff + size of the mmap() request.  Its retval is defined as the
order, which must be non-negative to enable the alignment.  When zero is
returned, it should behave like when the hint is not provided, IOW,
alignment will still be PAGE_SIZE.

When the order is too big, ignore the hint.  Normally drivers are trusted,
so it's more of an extra layer of safety measure.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/filesystems/vfs.rst |  4 +++
 include/linux/fs.h                |  1 +
 mm/mmap.c                         | 59 +++++++++++++++++++++++++++----
 3 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 4f13b01e42eb5..b707ddbebbf52 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1069,6 +1069,7 @@ This describes how the VFS can manipulate an open file.  As of kernel
 		int (*fasync) (int, struct file *, int);
 		int (*lock) (struct file *, int, struct file_lock *);
 		unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+		int (*get_mapping_order)(struct file *, unsigned long, size_t);
 		int (*check_flags)(int);
 		int (*flock) (struct file *, int, struct file_lock *);
 		ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
@@ -1165,6 +1166,9 @@ otherwise noted.
 ``get_unmapped_area``
 	called by the mmap(2) system call
 
+``get_mapping_order``
+	called by the mmap(2) system call to get mapping order hint
+
 ``check_flags``
 	called by the fcntl(2) system call for F_SETFL command
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd3b57cfadeeb..5ba373576bfe5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2287,6 +2287,7 @@ struct file_operations {
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	int (*get_mapping_order)(struct file *file, unsigned long pgoff, size_t len);
 	int (*check_flags)(int);
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
diff --git a/mm/mmap.c b/mm/mmap.c
index 8fa397a18252e..be3dd0623f00c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -808,6 +808,33 @@ unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *fi
 	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
 }
 
+static inline bool file_has_mmap_order_hint(struct file *file)
+{
+	return file && file->f_op && file->f_op->get_mapping_order;
+}
+
+static inline bool
+mmap_should_align(struct file *file, unsigned long addr, unsigned long len)
+{
+	/* When THP not enabled at all, skip */
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return false;
+
+	/* Never try any alignment if the mmap() address hint is provided */
+	if (addr)
+		return false;
+
+	/* Anonymous THP could use some better alignment when len aligned */
+	if (!file)
+		return IS_ALIGNED(len, PMD_SIZE);
+
+	/*
+	 * It's a file mapping, no address hint provided by caller, try any
+	 * alignment if the file backend would provide a hint
+	 */
+	return file_has_mmap_order_hint(file);
+}
+
 unsigned long
 __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
@@ -815,8 +842,9 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long)
 				  = NULL;
-
 	unsigned long error = arch_mmap_check(addr, len, flags);
+	unsigned long align;
+
 	if (error)
 		return error;
 
@@ -841,13 +869,30 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
-		   && !addr /* no hint */
-		   && IS_ALIGNED(len, PMD_SIZE)) {
-		/* Ensures that larger anonymous mappings are THP aligned. */
+	} else if (mmap_should_align(file, addr, len)) {
+		if (file_has_mmap_order_hint(file)) {
+			int order;
+			/*
+			 * Allow driver to opt-in on the order hint.
+			 *
+			 * Sanity check on the order returned. Treating
+			 * either negative or too big order to be invalid,
+			 * where alignment will be skipped.
+			 */
+			order = file->f_op->get_mapping_order(file, pgoff, len);
+			if (order < 0)
+				order = 0;
+			if (check_shl_overflow(PAGE_SIZE, order, &align))
+				/* No alignment applied */
+				align = PAGE_SIZE;
+		} else {
+			/* Default alignment for anonymous THPs */
+			align = PMD_SIZE;
+		}
+
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
-						     pgoff, flags, PMD_SIZE,
-						     vm_flags);
+						     pgoff, flags,
+						     align, vm_flags);
 	} else {
 		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
 						    pgoff, flags, vm_flags);
-- 
2.50.1


