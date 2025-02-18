Return-Path: <kvm+bounces-38504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B97A3AB9F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:24:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D66B3168121
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0461DE8B7;
	Tue, 18 Feb 2025 22:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpkB22U9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39D31DE880
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 22:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739917364; cv=none; b=NYt87Y9x1nTY6p/O/Dls+dkmYAzD6RcBBbjfOzUtzgk4zHIQFVyEaGhrY+KvOuXQ7Ppj7CiIyd5G5rdxdTQ7kC6z9WWGp/873Mx9cMufDFQolMaYJImO2muepPA6MEUmUx967hDZk+M9JD9yhwi0t1X1te7rOFs67wDd8iH2h6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739917364; c=relaxed/simple;
	bh=I0ZdTj8BmgqXnptu5DqBvvj81DWasr9opqmNnG45eSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGkZWX59ZOjeQdErNacAc9H8cCW+5phScCK4NLOBQUkIACM9Ug37Fi0d/2W3ePqXM+iDP+8Otf2lMSYznfTxomPkm5eoljlMbBqjQXqs4P9xM9KNKvdf8m83tyVNWWm6zi9QGCcgHvN5pVmNb191Q4OTrC2cGJ9a4o1a85pHECA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpkB22U9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739917360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jnx3EEunpJZjox9YHzpXUDwmXWPi4uIum6tx1nb7cx0=;
	b=fpkB22U9LHdm2TreR3Bo/vOrEax0x1Y9Bm66le9G0X3ZEI8uLOoBFsquax6wB/Xa9ISVol
	agDEHVjnDLAneyWvcwoj33k5gwFale7OTm03RJYpiUzR4VHvqSykBP6Xs7SE+bEaCDFRry
	d7qgFmA90XYi0LeewOuwiUy48bM7t4M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-y8fXHio6OM-KxVoJCnyMDA-1; Tue,
 18 Feb 2025 17:22:37 -0500
X-MC-Unique: y8fXHio6OM-KxVoJCnyMDA-1
X-Mimecast-MFC-AGG-ID: y8fXHio6OM-KxVoJCnyMDA_1739917356
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72AA21800877;
	Tue, 18 Feb 2025 22:22:36 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.88.77])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 280D4300019F;
	Tue, 18 Feb 2025 22:22:33 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org
Subject: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
Date: Tue, 18 Feb 2025 15:22:06 -0700
Message-ID: <20250218222209.1382449-7-alex.williamson@redhat.com>
In-Reply-To: <20250218222209.1382449-1-alex.williamson@redhat.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
 drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ce661f03f139..0ac56072af9f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch *batch)
 
 static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
-			    bool write_fault)
+			    unsigned long *addr_mask, bool write_fault)
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
+		*addr_mask = args.addr_mask;
+	}
 
 	follow_pfnmap_end(&args);
 	return ret;
@@ -590,15 +592,22 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	vma = vma_lookup(mm, vaddr);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
+		unsigned long addr_mask;
+
+		ret = follow_fault_pfn(vma, mm, vaddr, pfn, &addr_mask,
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
+				epfn = (*pfn | (~addr_mask >> PAGE_SHIFT)) + 1;
+				ret = min_t(long, npages, epfn - *pfn);
+			} else {
 				ret = -EFAULT;
+			}
 		}
 	}
 done:
-- 
2.48.1


