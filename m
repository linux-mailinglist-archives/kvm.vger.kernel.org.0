Return-Path: <kvm+bounces-65294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D7DCA433B
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 16:17:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C676303BED0
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 15:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FA82DEA77;
	Thu,  4 Dec 2025 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ioyh8RHz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPALj42U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93912DE6F8
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861020; cv=none; b=XERlDo4wSlSwLZ3r+t5hAyR5L2bll5MfOwv+oG9cmwgi1cPPT97yXa+IV3fWeWFdCHhHuIREcqaGzFqtczZQdSLtRZQ6Pv6vCndBQYMnjgoA1wBMDbxnlOp5389EBmMXd/aIkO9qpZ0GR9r8w2TI+HA12rkDnf9qi0dP7pXPwtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861020; c=relaxed/simple;
	bh=YZrU39LZ+1N2e7UrW746DAf5wMDP77P1FpRzJ7y1WH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPbpzFvnIAgGgDXRllcszm1n0gjqzzcLA1KdnnyYPKBhct2zr5nCVcJBM4MwqOgobEHcYK0qJhEFRmxhugULVzOVSFiRgPx8cbfEmC/WyKya2AeodrAnr0cRZmnQwdf9GVqbfQfPl4IwXmhL7rMSk5NywxzuuA40n0V5rPXVD+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ioyh8RHz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPALj42U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QqnsDgnWNJJ4lTRWnBZQypy/wcJe61u46quVDoPefb0=;
	b=Ioyh8RHzDpT8nONaNXCOsUkcYKoCv9Jj8rDzm+XpD4QnNEOdUb45dyrbZOJJz3Rt4e5xiX
	hp6PBjKVjjoCecRSqwwRXHtKoWqshPNNqnaIzq4tJMuNqi5Nobw1V7Y2XQ2SQLMVZbAZhd
	e6sUL4lKXAZzy4ZLaDBMuPa9C5o9OXI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-B36WNkM9MI-2jTc2RZrOxQ-1; Thu, 04 Dec 2025 10:10:15 -0500
X-MC-Unique: B36WNkM9MI-2jTc2RZrOxQ-1
X-Mimecast-MFC-AGG-ID: B36WNkM9MI-2jTc2RZrOxQ_1764861015
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b19a112b75so218155485a.1
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 07:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764861014; x=1765465814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QqnsDgnWNJJ4lTRWnBZQypy/wcJe61u46quVDoPefb0=;
        b=SPALj42UQQF4WnRWhMO88DtGIBiyF2S0UTxChHni1TvpBrvyYGI7Jlhy3mwcCfq+mv
         3hPKmoGT1wL8ZPlfOhlAhToLSNDjHz1jHronDyr8rwago0PRZgRHOnAa5pgW4MG7ln8m
         3q8IneEl6968xWGEue43Ui5rkIk01w3CFqjNQ4Wv0eNDn97zCotooz529C63XknE8OJb
         28BIgCfv1t8XIfW5Knc/R+UMP/JpjYGfKAPt9xdOKPue9SZH/hiiyp0WTqsHtBIN4B4k
         DtLMnGwO5tkkRahek2n6rvlGFxHvuAwfq7rEb+EczdjP44r+YzX1W4zuFN54J5Fo6Nk3
         n2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861014; x=1765465814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QqnsDgnWNJJ4lTRWnBZQypy/wcJe61u46quVDoPefb0=;
        b=HuNs6dZxf0ailldDT3PQYy7sZY770CnQu/fO7Io1ipffiFKWOkTCwRcP4yC+Dyg//L
         RoR5udDtxFnnnG8eJO+JnSp9RUuMQJMHLr3sCnMMZt2zZBgXnuzo6iOQ8uTFaM5M0Mh/
         kN0kQuZPpeZXwIbltRtkGoAlBjNhmUhZtadAFl9cp1eNxT1La+sPUYxbnqstmEcKCSgr
         lKRhrFmyVdhD/nk/NKw2yzJpY+4G/Etqw/c9Srjg1DWoHwM1ixSFq4YQnzpnK6ZCFgoS
         iCI4Vh96FtItsGc9na1bxf/9z8NqbVWnTfB6pvxQnLMeHeT8/oKOkWMvGJw7XTfBjxaW
         wbGA==
X-Gm-Message-State: AOJu0Yxvo7uJK9nhq139y271+tMmqxjf73H6iUK3GSnYs8KAINGc61Ej
	G7o23UKJZ6G5eXaE0K+nOI6AIsWyzzZjx1m+fHAOZYSgcZLbCT9j6ifRhWQMW+fUrQOI2Un6jQ+
	mARHLKPgx/zOv6hAVeDaLM5NFOvpcVREKRQklPpw/j1ple2RbwLilvvUkRrQky8XBA3GwD+Fx7J
	wxxIUza2EBqbHx8DOBbz5M3v2y+7nD1Kx6PNc=
X-Gm-Gg: ASbGncvKLGoCwjxTU2HhLURknk2CqGgAIqljb/zfaxyhplK42Pb2Sw0cSajclQjus2I
	o1I77+Md4u1aS59aC6b6VApRf+q01qNskJ0Q+6L5nAwASiwZGAhkoKDeg9YwQGagZcPzrB6JKRq
	Hna2mVsaCvN7O4DvA6biR+Pmzzq/e6JRpWt1FOBdrOuTI+q2O80nPOyzmOueAkdUKDLVkHP64dT
	/EdDIHacDI+Re4ZNVUoKxx/DF4kxPaE/oXsoRScqr8AxPXXsAi2I6zaO4N+yu/XoNG9133dZIdS
	WztAN4vZNJSq2Pue0lyYhM6A92oABXp5mLS2D2YBfEVo/c/AGOf5VoDFIfT36cqoaJFIa7iFeEg
	H
X-Received: by 2002:a05:620a:4493:b0:8b2:f145:7f2e with SMTP id af79cd13be357-8b5e77339b4mr883016785a.77.1764861014268;
        Thu, 04 Dec 2025 07:10:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHg1P7IVsR21tbM+ynMYgTnLBafpvtkF3gYNVFFKjN2cvYYIUWpdyVgk1EkcF9l/NqzRg+vQw==
X-Received: by 2002:a05:620a:4493:b0:8b2:f145:7f2e with SMTP id af79cd13be357-8b5e77339b4mr883007985a.77.1764861013650;
        Thu, 04 Dec 2025 07:10:13 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:13 -0800 (PST)
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
Subject: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
Date: Thu,  4 Dec 2025 10:10:03 -0500
Message-ID: <20251204151003.171039-5-peterx@redhat.com>
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

This patch enables best-effort mmap() for vfio-pci bars even without
MAP_FIXED, so as to utilize huge pfnmaps as much as possible.  It should
also avoid userspace changes (switching to MAP_FIXED with pre-aligned VA
addresses) to start enabling huge pfnmaps on VFIO bars.

Here the trick is making sure the MMIO PFNs will be aligned with the VAs
allocated from mmap() when !MAP_FIXED, so that whatever returned from
mmap(!MAP_FIXED) of vfio-pci MMIO regions will be automatically suitable
for huge pfnmaps as much as possible.

To achieve that, a custom vfio_device's get_mapping_hint() for vfio-pci
devices is needed.

Note that BAR's MMIO physical addresses should normally be guaranteed to be
BAR-size aligned.  It means the MMIO address will also always be aligned
with vfio-pci's file offset address space, per VFIO_PCI_OFFSET_SHIFT.

With that guaranteed, VA allocator can calculate the alignment with pgoff,
which will be further aligned with the MMIO physical addresses to be mapped
in the VMA later.

So far, stick with the simple plan to rely on the hardware assumption that
should always be true.  Leave it for later if pgoff needs adjustments when
there's a real demand of it when calculating the alignment.

For discussion on the requirement of this feature, see:

https://lore.kernel.org/linux-pci/20250529214414.1508155-1-amastro@fb.com/

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c      |  1 +
 drivers/vfio/pci/vfio_pci_core.c | 49 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  2 ++
 3 files changed, 52 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index ac10f14417f2f..8f29037cee6eb 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -145,6 +145,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
 	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
+	.get_mapping_order	= vfio_pci_core_get_mapping_order,
 };
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc9..28ab37715acc0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,6 +1640,55 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
+/*
+ * Hint function for mmap() about the size of mapping to be carried out.
+ * This helps to enable huge pfnmaps as much as possible on BAR mappings.
+ *
+ * This function does the minimum check on mmap() parameters to make the
+ * hint valid only. The majority of mmap() sanity check will be done later
+ * in mmap().
+ */
+int vfio_pci_core_get_mapping_order(struct vfio_device *device,
+				    unsigned long pgoff, size_t len)
+{
+	struct vfio_pci_core_device *vdev =
+	    container_of(device, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	unsigned long req_start;
+	size_t phys_len;
+
+	/* Currently, only bars 0-5 supports huge pfnmap */
+	if (index >= VFIO_PCI_ROM_REGION_INDEX)
+		return 0;
+
+	/*
+	 * NOTE: we're keeping things simple as of now, assuming the
+	 * physical address of BARs (aka, pci_resource_start(pdev, index))
+	 * should always be aligned with pgoff in vfio-pci's address space.
+	 */
+	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
+	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
+
+	/*
+	 * If this happens, it will probably fail mmap() later.. mapping
+	 * hint isn't important anymore.
+	 */
+	if (req_start >= phys_len)
+		return 0;
+
+	phys_len = MIN(phys_len - req_start, len);
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
+		return PUD_ORDER;
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
+		return PMD_ORDER;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_get_mapping_order);
+
 static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 					   unsigned int order)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2a..d320dfacc5681 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,8 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+int vfio_pci_core_get_mapping_order(struct vfio_device *device,
+		unsigned long pgoff, size_t len);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.50.1


