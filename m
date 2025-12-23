Return-Path: <kvm+bounces-66624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A6ACDAC9B
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4416A3003DB2
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF241221DB3;
	Tue, 23 Dec 2025 23:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flo7KYVn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49042248176
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766530863; cv=none; b=bWb4VsqEcA+viwzM43W6JLEruFMGhoADvl26qEU5NZFT4bBUMTp87K3+/UDaN+28Cfu2WqcZ1xAHs/B8oK01gUoZs/oofcnQV+q2GdNNRnCDpjZm7A1Bb6erc5is3+QskUq4MDp0OyHt+qRrmc1ijg7YaU8pfyrBjnkh41J61k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766530863; c=relaxed/simple;
	bh=rLNGu760rf5ulNmGbVEA7VycQbQuICac6A1NiDTgKjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YJ/QpJZu0JdlXOjfHk5XnyI2AOXCcxyMR9tlOSbPdSPy/KrvOVvRKHZz86gtPAgH3y3Q48y5oTrnvzghyfONoAkwneVK6RGts5H0wJdJrS0IKy+U4exGQ6trN59Jjdu5fk7gN3GPgLS/JxD+31s7gZK0jcCFCPiWxN2Y/rofxyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flo7KYVn; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a351686c17so6104885ad.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 15:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766530860; x=1767135660; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N9pFd8E7CEwyAtGvaqN83UFqYCZHKvMlPmqNvC3XWFA=;
        b=flo7KYVn9WgPFaRaO4XCdOPinuLBEvbV8MI9STaV+pDeWxcTurtfHeIHsAFKxVdybF
         7yeHzg7p9AszF+OCh83lJA/Jnsjdd8FzaUi3sqOMqFf9mkLJbSTH7vIObsD8BWDZhIoE
         PrvG7AR4T6LNHyEMWuNJ6hG/xMVKWdNoOnXGn5qfB55HSqNe44PkdFYRhkwvQGJnuQ/1
         fimAWOuWP5eRV3GZQGVrwtVVuutWAHeT5DJW/R+uJO4UYmOMw/I12QFcvmJsuS7CZIME
         O6yRGcNxzSojH8+y+auijYFd7HNFxuqhrQxY347+8FlMGHUKpfjDCwjE45GQx8FPWLQT
         pf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766530860; x=1767135660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N9pFd8E7CEwyAtGvaqN83UFqYCZHKvMlPmqNvC3XWFA=;
        b=Qpsxnp2D6SwBb9B1yY9Cp+LV3eURpUvcJkNn3AY60/XDcZjwKbM9kiwfXw7BfwQmqb
         JIMnSWY1xiaisDWxUXbjUpgm3IOtwVYb7F1C/7+XcQf6D72iTitYx/ZXrRK2sfJ9L2/M
         H4SUOb0Lm80nGTSowUIjfCgnciOddxgpy31yfZYam5mk5O5V6oAdtk36oLAHEAcM9Hpt
         8QlRj8ipGKxfS4MDSTXpbb/DOfFQoHXm52+IgR6dsWcRGN/j5SVSS648KMa53+MTJUN3
         wCD1eJi42Z1hJXqtyxFPgt7ozHogqUd1s4EGn0cFQd2JdT6fjQkbkGfqvuDcMkXUrG3F
         zciw==
X-Gm-Message-State: AOJu0Yyc7nZ6WJrR1JkZaHCE6/uZJx/TzJKF+eqYayjnIrceVRXMI7Ea
	wZAp29erY/2NInS199aHxB2xUd4vx9WYHRYAqZ0J934K19a6knJH5QqsdhT/HqvK5NhiEbK1Z0P
	Rtu3M0hfcb1L5oyrWEuakqw==
X-Google-Smtp-Source: AGHT+IEKBTiT60w7uhNxwFAh2XNhy2bf6OTiZvr+Pn3AcnFScrQECOUvcwH+7dWZf7ZlBFUtVhFtKqNwb/jWTWt3
X-Received: from dlbtv7.prod.google.com ([2002:a05:7022:3c87:b0:11f:36a2:78d])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:1e09:b0:119:e56b:9583 with SMTP id a92af1059eb24-121722ac4bfmr12001063c88.8.1766530860485;
 Tue, 23 Dec 2025 15:01:00 -0800 (PST)
Date: Tue, 23 Dec 2025 23:00:43 +0000
In-Reply-To: <20251223230044.2617028-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251223230044.2617028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251223230044.2617028-2-aaronlewis@google.com>
Subject: [RFC PATCH 1/2] vfio: Improve DMA mapping performance for huge pages
From: Aaron Lewis <aaronlewis@google.com>
To: alex.williamson@redhat.com, jgg@nvidia.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Huge pages are pinned at 4K granularity.  That means when pinning a 1G
page, 2^18 pages are pinned one at a time.  This adds needless toil
which results in high latencies.

To improve this, increase the number of pages the batch is operating on
to the number of 4k pages in a huge page.  Doing that allows huge
pages to be pinned in larger chunks, reducing the number of individual
pages being pinned one at a time.

This results in a major speed up vs baseline and can be demonstrated
by the selftest "vfio_dma_mapping_perf_test".

Using this selftest and a sample profiler it is easy to see where all
the time is being spent, vfio_pin_pages_remote().  Optimizing for that
led to the gains called out below.

 Samples     Percentage  Name
 ---------------------------------------------
 30,947,392      0.209%  vfs_ioctl (ioctl.c) Inlined
 30,947,392      0.209%  vfio_fops_unl_ioctl (container.c)
 30,947,392      0.209%  vfio_iommu_type1_ioctl (vfio_iommu_type1.c)
 30,947,392      0.209%  vfio_iommu_type1_map_dma (vfio_iommu_type1.c) Inlined
 30,947,392      0.209%  vfio_dma_do_map (vfio_iommu_type1.c) Inlined
 30,947,392      0.209%  vfio_pin_map_dma (vfio_iommu_type1.c)
 30,947,392      0.209%  vfio_pin_pages_remote (vfio_iommu_type1.c)
 29,616,402      0.200%  vaddr_get_pfns (vfio_iommu_type1.c)
 29,616,402      0.200%  internal_get_user_pages_fast (gup.c)
 29,616,402      0.200%  __gup_longterm_locked (gup.c)
 28,962,361      0.195%  __get_user_pages_locked (gup.c) Inlined
 28,962,361      0.195%  __get_user_pages (gup.c)
 25,548,889      0.172%  follow_page_mask (gup.c)
 24,852,062      0.168%  follow_p4d_mask (gup.c) Inlined
 24,852,062      0.168%  follow_pud_mask (gup.c) Inlined
 17,683,506      0.119%  follow_devmap_pud (huge_memory.c)
 6,584,772       0.044%  pud_lock (mm.h) Inlined


 Results when mapping 8G of memory:
 ----------------------------------

Baseline
 - vfio_type1_iommu:      2.87ms
 - iommufd_compat_type1: 53.23ms
 - iommufd:               4.53ms

With fast huge page pinning
 - vfio_type1_iommu:      0.01ms
 - improvements to iommufd_compat_type1 and iommufd are tbd.


 Results when mapping 256G of memory:
 ----------------------------------

Baseline
 - vfio_type1_iommu:       99.36ms
 - iommufd_compat_type1: 1576.51ms
 - iommufd:               144.65ms

With fast huge page pinning:
 - vfio_type1_iommu:        0.20ms
 - improvements to iommufd_compat_type1 and iommufd are tbd.

Based on these results that is more than a 300x speed up for
vfio_type1_iommu!  E.g. 2.87ms -> 0.01ms and 99.36ms -> 0.20ms.

As of now there is only a proposal to speed up "vfio_type1_iommu".


 IOMMUFD:
 --------

More effort will be needed to see what kind of speed ups can be achieved
by optimizing iommufd.  Sample profiler results (below) show that it
isn't the GUP calls that are slowing it down like they were in the
"vfio_type1_iommu" case.  The majority of the slowdown is coming from
batch_from_pages(), and the majority of that time is being spent in
batch_add_pfn_num().

 Samples     Percentage  Name
 ---------------------------------------------
 2,710,320,547   10.22%  iommufd_fops_ioctl (main.c)
 2,710,320,547   10.22%  iommufd_ioas_map (ioas.c)
 2,710,320,547   10.22%  iopt_map_user_pages (io_pagetable.c)
 2,710,320,547   10.22%  iopt_map_common (io_pagetable.c)
 2,710,320,547   10.22%  iopt_map_pages (io_pagetable.c)
 2,710,320,547   10.22%  iopt_fill_domains_pages (io_pagetable.c) Inlined
 2,710,320,547   10.22%  iopt_area_fill_domains (pages.c)
 2,710,320,547   10.22%  pfn_reader_first (pages.c)
 2,710,320,547   10.22%  pfn_reader_next (pages.c)
 2,709,376,056   10.21%  pfn_reader_fill_span (pages.c) Inlined
   2,435,947,359   9.182%  batch_from_pages (pages.c) Inlined
     1,864,604,611  7.028%   batch_add_pfn (pages.c) Inlined
     1,864,604,611  7.028%   batch_add_pfn_num (pages.c) Inlined
   273,428,697     1.031%  pfn_reader_user_pin (pages.c)
     271,538,567     1.024%  gup_fast_fallback (gup.c)

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 drivers/vfio/vfio_iommu_type1.c | 37 ++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5167bec14e363..c1f7c2600a2d0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -108,6 +108,7 @@ struct vfio_batch {
 	unsigned int		capacity;	/* length of pages array */
 	unsigned int		size;		/* of batch currently */
 	unsigned int		offset;		/* of next entry in pages */
+	bool			override_size;	/* has size been overriden. */
 };
 
 struct vfio_iommu_group {
@@ -493,6 +494,7 @@ static int put_pfn(unsigned long pfn, int prot)
 
 static void __vfio_batch_init(struct vfio_batch *batch, bool single)
 {
+	batch->override_size = false;
 	batch->size = 0;
 	batch->offset = 0;
 
@@ -598,7 +600,18 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	ret = pin_user_pages_remote(mm, vaddr, pin_pages, flags | FOLL_LONGTERM,
 				    batch->pages, NULL);
 	if (ret > 0) {
+		unsigned long nr_pages = compound_nr(batch->pages[0]);
+		bool override_size = false;
+
+		if (PageHead(batch->pages[0]) && nr_pages > pin_pages &&
+		    ret == pin_pages) {
+			override_size = true;
+			ret = nr_pages;
+			page_ref_add(batch->pages[0], nr_pages - pin_pages);
+		}
+
 		*pfn = page_to_pfn(batch->pages[0]);
+		batch->override_size = override_size;
 		batch->size = ret;
 		batch->offset = 0;
 		goto done;
@@ -668,6 +681,20 @@ static long vpfn_pages(struct vfio_dma *dma,
 	return ret;
 }
 
+static long vfio_batch_num_pages_contiguous(struct vfio_batch *batch)
+{
+	if (batch->override_size) {
+		return batch->size;
+	}
+
+	/*
+	 * Using GUP with the FOLL_LONGTERM in vaddr_get_pfns() will not
+	 * return invalid or reserved pages.
+	 */
+	return num_pages_contiguous(&batch->pages[batch->offset],
+				    batch->size);
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -747,14 +774,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			    rsvd != is_invalid_reserved_pfn(pfn))
 				goto out;
 
-			/*
-			 * Using GUP with the FOLL_LONGTERM in
-			 * vaddr_get_pfns() will not return invalid
-			 * or reserved pages.
-			 */
-			nr_pages = num_pages_contiguous(
-					&batch->pages[batch->offset],
-					batch->size);
+			nr_pages = vfio_batch_num_pages_contiguous(batch);
+
 			if (!rsvd) {
 				acct_pages = nr_pages;
 				acct_pages -= vpfn_pages(dma, iova, nr_pages);
-- 
2.52.0.351.gbe84eed79e-goog


