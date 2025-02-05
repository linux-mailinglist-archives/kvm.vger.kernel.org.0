Return-Path: <kvm+bounces-37417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A845BA29D84
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 00:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7D7F166872
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 23:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8403622259E;
	Wed,  5 Feb 2025 23:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VA41LJHX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E822256E
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 23:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738797505; cv=none; b=sA0bUDPiQ5qrF+W+JOVuL4WI9DLXstauJjDBHaA8cCGzvsU9p09FESNVp3vkAt5J36YMcBE2XgB8WbCQkcOjXReKrCR9FGYbUunt+lzxKEuquL5e8L6Ha1yP3/BQuYOQn/po7tzRws5gq7dwgCCoYQtIUoUazeJwa7zvd2qTylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738797505; c=relaxed/simple;
	bh=fsYmWYGZlPnMx8rPd45rFmtH5cOXmj1gG2W6neNXrNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGadOEG7aqFaOgRiZ+armNATKrSltDwZX+tObWWJ3iP6evVgqdjhzv4Q/2InJgN3mTDVUweb/ZTatfGg5Q4A3+UYtQ/WGxHv8PNoNNaC9lB5qSvxxm3KcocFjqZe2qSkNydp+n/+b2jsK7Q3A1RDQ76/L6t1kLafSNm2kcGrNtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VA41LJHX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738797503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FZa80BhZdx9gmyyMrwsj4JyFeb2ASk0SBEuM3S7wkWc=;
	b=VA41LJHXtOLrxc5rqjO+kFP3/UHo6s/Q+9Q/M+PgRSVy0G/lS4MAILOPxAz6XqnQszD1tU
	U4OqxFSRN/xZEIyWmv0FVIaJ7mM3SV8HlhLQcs4TU1tq0KYzu6Rx4QAiEzeLKKeOKswd/N
	KWg4d3N45sXwPCgtHZ50hsh8Oo1QW7U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-TONjRLI-McyooT1dQwr4iQ-1; Wed,
 05 Feb 2025 18:18:20 -0500
X-MC-Unique: TONjRLI-McyooT1dQwr4iQ-1
X-Mimecast-MFC-AGG-ID: TONjRLI-McyooT1dQwr4iQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0063180087D;
	Wed,  5 Feb 2025 23:18:18 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.81.141])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC67C1800570;
	Wed,  5 Feb 2025 23:18:16 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] vfio/type1: Use mapping page mask for pfnmaps
Date: Wed,  5 Feb 2025 16:17:21 -0700
Message-ID: <20250205231728.2527186-6-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-1-alex.williamson@redhat.com>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

vfio-pci supports huge_fault for PCI MMIO BARs and will insert pud and
pmd mappings for well aligned mappings.  follow_pfnmap_start() walks the
page table and therefore knows the page mask of the level where the
address is found and returns this through follow_pfnmap_args.pgmask.
Subsequent pfns from this address until the end of the mapping page are
necessarily consecutive.  Use this information to retrieve a range of
pfnmap pfns in a single pass.

With optimal mappings and alignment on systems with 1GB pud and 4KB
page size, this reduces iterations for DMA mapping PCI BARs by a
factor of 256K.  In real world testing, the overhead of iterating
pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
sub-millisecond overhead.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 939920454da7..6f3e8d981311 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch *batch)
 
 static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
-			    bool write_fault)
+			    unsigned long *pgmask, bool write_fault)
 {
 	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
 	int ret;
@@ -544,10 +544,12 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			return ret;
 	}
 
-	if (write_fault && !args.writable)
+	if (write_fault && !args.writable) {
 		ret = -EFAULT;
-	else
+	} else {
 		*pfn = args.pfn;
+		*pgmask = args.pgmask;
+	}
 
 	follow_pfnmap_end(&args);
 	return ret;
@@ -590,15 +592,23 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	vma = vma_lookup(mm, vaddr);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
+		unsigned long pgmask;
+
+		ret = follow_fault_pfn(vma, mm, vaddr, pfn, &pgmask,
+				       prot & IOMMU_WRITE);
 		if (ret == -EAGAIN)
 			goto retry;
 
 		if (!ret) {
-			if (is_invalid_reserved_pfn(*pfn))
-				ret = 1;
-			else
+			if (is_invalid_reserved_pfn(*pfn)) {
+				unsigned long epfn;
+
+				epfn = (((*pfn << PAGE_SHIFT) + ~pgmask + 1)
+					& pgmask) >> PAGE_SHIFT;
+				ret = min_t(int, npages, epfn - *pfn);
+			} else {
 				ret = -EFAULT;
+			}
 		}
 	}
 done:
-- 
2.47.1


