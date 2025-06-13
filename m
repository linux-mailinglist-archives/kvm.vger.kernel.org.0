Return-Path: <kvm+bounces-49417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC0EAD8D57
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16EF1160494
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25845279DBB;
	Fri, 13 Jun 2025 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="We9gkzl5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7AE433D9
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822089; cv=none; b=KXZSMOIPKKLi8LkiNTOkuSmJRH86oQVjL7tACizowErJlidVUIrZE74NmkGXqMq0Hn6B67eREa72oSHyChNAQ64UOthGFsJDBSFVzWj4hXjYOK0ybn/wdkwpqOhoQC0/hK95FjKPdS6EvNhQ2LM3y9UksZkce7LyoQkR0omXqK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822089; c=relaxed/simple;
	bh=/Hj2o0NKvMzVIjNKTfgbctNmnmS2OLsACrglt6/q3Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8MZXAAvCRgQenie2TlhDZrImQBBRp2uMo4ycX023s7NAalxHt3BCXCPGCkCgAEIcci9WVOuCW0b1i8lereideAOtyKv7IA32bLAORE+LqAjBWoYisR4zOkqSZroHsWIvGiqdy2Q77cg5SSkM8dlxbKKo2jJroenNRyRtXHmer4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=We9gkzl5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749822086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Rg4eLLEgx6FDFHzHNf6mLR85Vz7bTkf4DxmFxHRoP8=;
	b=We9gkzl5EzKpfxDZU49arGick9p4aWJdjPxPdM0tn+ltXrciJThuGr3sbjskZYCYw0ZgCq
	NAlBc75PaoXKWPjw8Z69OtQp2o+MfDeir9FWpC3hqn/RQ0Sm6Np3lNY6F26bAU33kfNeqw
	VuQMhxPIpN0UwAU9o7t8vT9EUVk8ctY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-y4NxIWMcNI6X5I6-ra4Tpw-1; Fri, 13 Jun 2025 09:41:25 -0400
X-MC-Unique: y4NxIWMcNI6X5I6-ra4Tpw-1
X-Mimecast-MFC-AGG-ID: y4NxIWMcNI6X5I6-ra4Tpw_1749822085
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7d2107d6b30so328120085a.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749822085; x=1750426885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Rg4eLLEgx6FDFHzHNf6mLR85Vz7bTkf4DxmFxHRoP8=;
        b=mXHfqs5GuoBanUWGK8Cj6nF4Q7ZpelUq/dCEcgVrxmwlQvLauYrow1RVHQTSr0y8sx
         EBqqJWOrgtO1U4A+uwsn5vaSlRVjjXFjAVtNet2VQJxZnoF9emGNjEhKPlS72zPmXU4z
         BOauPt1f6BYkQI/Add735TOsubF39LRqnOu9+Ry2A8NaEu78vhN5UpNTh7QwCpi76/VT
         uQ9N3KjDyEknclJpGOYHef7rgSYQDpVxBRxZjCmov5cdvyGWInEo9vS2Xw/jhqCsKoC1
         0okSaMZWkj96JAAnphSAOWEz68n4kBA4Hwb9HLlNQ7eMlDN1dvuDSkVDPtcmfWV7w2Gf
         zCpg==
X-Forwarded-Encrypted: i=1; AJvYcCW+kXRqgCSXgLrxTXtchZmINuYbEICCNGeNyawu6B5TgQCsw1VfM986oGfl6QRJbTP7QCM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeON26owRnpfyJ21uvpg3grhLENocOx8Xewa4cj5VfzbjVfIb2
	Qzp1f0iAYUIJ4bhRahu0tdxhIVgCJnojYtkE+29v2U5QJMKq4Y6Ig5W249j8WZ/acmsspRg2eD5
	rVj7OK02c8ylbvKrQ644YnOEJUIMV0vo8GZ/nOK9FYZsX8uYRrnaJWA==
X-Gm-Gg: ASbGncsEwiuyVftTo2qRBXJzCS5B1U+FtQOYSTb3DdoWJeZZ56+nmBKjYf9r7Ofdtod
	Ry0TeWvuLWjjBZN4oVOj/lY8qEInsEHNKCOZ9HYPWGvub5s88iKVvD0PY/6Y7RkJYQtoCr4FeLf
	ehHJIJ0naOgrxNfBmZEIMvZ1Noz8lCEZf/vAOrZLxEeKvLW8V8735huo74NYahV86X5+h3ITDV6
	2AkfB6oq5jixAW/JRE0rKLvic02cbowr9exlvD6MEzBxPlBua4ocPB68CKu7PjZoLTVsx1Cy2Ax
	KhiNCHA4R+c=
X-Received: by 2002:a05:620a:1721:b0:7d3:aad4:6f87 with SMTP id af79cd13be357-7d3bc37ba17mr568288685a.7.1749822084907;
        Fri, 13 Jun 2025 06:41:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqZxKV2mT6BD/bi39sPGRhzywu281UAzYUirAEIW40JfRfajmXwptkVPgbiPNtRrb6I7XH6g==
X-Received: by 2002:a05:620a:1721:b0:7d3:aad4:6f87 with SMTP id af79cd13be357-7d3bc37ba17mr568285785a.7.1749822084512;
        Fri, 13 Jun 2025 06:41:24 -0700 (PDT)
Received: from x1.com ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8ee3f72sm171519285a.94.2025.06.13.06.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 06:41:23 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kvm@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	peterx@redhat.com
Subject: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
Date: Fri, 13 Jun 2025 09:41:11 -0400
Message-ID: <20250613134111.469884-6-peterx@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613134111.469884-1-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch enables best-effort mmap() for vfio-pci bars even without
MAP_FIXED, so as to utilize huge pfnmaps as much as possible.  It should
also avoid userspace changes (switching to MAP_FIXED with pre-aligned VA
addresses) to start enabling huge pfnmaps on VFIO bars.

Here the trick is making sure the MMIO PFNs will be aligned with the VAs
allocated from mmap() when !MAP_FIXED, so that whatever returned from
mmap(!MAP_FIXED) of vfio-pci MMIO regions will be automatically suitable
for huge pfnmaps as much as possible.

To achieve that, a custom vfio_device's get_unmapped_area() for vfio-pci
devices is needed.

Note that MMIO physical addresses should normally be guaranteed to be
always bar-size aligned, hence the bar offset can logically be directly
used to do the calculation.  However to make it strict and clear (rather
than relying on spec details), we still try to fetch the bar's physical
addresses from pci_dev.resource[].

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c      |  3 ++
 drivers/vfio/pci/vfio_pci_core.c | 65 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  6 +++
 3 files changed, 74 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5ba39f7623bb..d9ae6cdbea28 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -144,6 +144,9 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
 	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.get_unmapped_area	= vfio_pci_core_get_unmapped_area,
+#endif
 };
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcd..835bc168f8b7 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1641,6 +1641,71 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+/*
+ * Hint function to provide mmap() virtual address candidate so as to be
+ * able to map huge pfnmaps as much as possible.  It is done by aligning
+ * the VA to the PFN to be mapped in the specific bar.
+ *
+ * Note that this function does the minimum check on mmap() parameters to
+ * make the PFN calculation valid only. The majority of mmap() sanity check
+ * will be done later in mmap().
+ */
+unsigned long vfio_pci_core_get_unmapped_area(struct vfio_device *device,
+					      struct file *file,
+					      unsigned long addr,
+					      unsigned long len,
+					      unsigned long pgoff,
+					      unsigned long flags)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	unsigned long ret, phys_len, req_start, phys_addr;
+	unsigned int index;
+
+	index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
+	/* Currently, only bars 0-5 supports huge pfnmap */
+	if (index >= VFIO_PCI_ROM_REGION_INDEX)
+		goto fallback;
+
+	/* Bar offset */
+	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
+	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
+
+	/*
+	 * Make sure we at least can get a valid physical address to do the
+	 * math.  If this happens, it will probably fail mmap() later..
+	 */
+	if (req_start >= phys_len)
+		goto fallback;
+
+	phys_len = MIN(phys_len, len);
+	/* Calculate the start of physical address to be mapped */
+	phys_addr = pci_resource_start(pdev, index) + req_start;
+
+	/* Choose the alignment */
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE) {
+		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
+						   flags, PUD_SIZE, 0);
+		if (ret)
+			return ret;
+	}
+
+	if (phys_len >= PMD_SIZE) {
+		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
+						   flags, PMD_SIZE, 0);
+		if (ret)
+			return ret;
+	}
+
+fallback:
+	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_get_unmapped_area);
+#endif
+
 static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 					   unsigned int order)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b3..e59699e01901 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,12 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+unsigned long vfio_pci_core_get_unmapped_area(struct vfio_device *device,
+					      struct file *file,
+					      unsigned long addr,
+					      unsigned long len,
+					      unsigned long pgoff,
+					      unsigned long flags);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.49.0


