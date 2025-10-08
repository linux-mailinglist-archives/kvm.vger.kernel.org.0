Return-Path: <kvm+bounces-59668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31917BC6DB6
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4402B3A7061
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7832D060C;
	Wed,  8 Oct 2025 23:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IDYkaWks"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F332D0298
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965971; cv=none; b=uRGF0OfvvEwrMcoW4C9a2LIeZcZjh29lQBMjhpdmjBXWzaD7DujxxmIy8Z4idu/po/RKn4lueRd/QUVPUq2G7m7f161uC2fggyA9F8Zn8913g7U4GqdNcc+T/cbZJcgBSYOcrhpxUM3VPx/S2zNx68L0quBtzjgr3N0jybZzuAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965971; c=relaxed/simple;
	bh=B1jtZ37lNYelnhcEEAmflXsNCGBv4BlOrUgfj7nlm6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LLw7T+Go8TLcpDRg5uydEKXMvgDg6s4Kku61qEc5dFAH5hgB7B08RhFY01XJb5xvQVr76WcoxEMufBumerNRwItplTvl2mAY5SZakrUsOVK/6oKHnGKfvIqD7mPM0dWA6gu+jnU8nev1c2pS5DzFXSHqMRSA1TWur98n3HasS4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IDYkaWks; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7811a602576so702065b3a.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965969; x=1760570769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKSeplGvtCJRvcHUfH84diSRpRZ02zop18VmALGtAmI=;
        b=IDYkaWksZRqFk26HuHbhOnXEY2lBKXkLTf6YE6K8wia5OVWfwUOaHITTk5itIz4qz5
         oz/VZeqwCSyctiyVcGx8Pqxjf2Kod7HPwYwXHCsI4K13+KiPaTMSn7dxD2aG7fiQQhXg
         SeqGK4wP+tGXF0AyS1YbiZZHTTV9OAWW7IBpj8siHtkZUpiFnuTB2FaVZWMKWFXMLNNB
         81qAvnRvu0rih6pILGWxBtJntX6ZwLeAPCC4mQ9dBxIAZ5Bfo5/vmIdy+48ZyR32Y9LR
         yPTCIEcNNM46YKowQqbZcVRn/ukpcckZfoje2chYKE0IBEocOLEuUQsbUnr2MpmN7f20
         WBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965969; x=1760570769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MKSeplGvtCJRvcHUfH84diSRpRZ02zop18VmALGtAmI=;
        b=qoyTCIRgcu6Of1I8KmOgQAnz59ZNdtyPb0vOiQ1rvisWRVFoDWzQZ1C77vFbtMMdCB
         F+3v0G14h6cNYRsaYXirR4P8ITghSLLDfK6loKivIBezET3LoVMNvUZbt5UdCUC5G8Mo
         0nAHt3wNiMgWVGnheTPpjjF+TMXJOrfjDQ3LCh5wW8Pne3+SpA7DliiK5dfGcCuLg7Xs
         W3byakiyfR3VkYaJCkFAgf5xpQk1Vu8EY7HMSs0ijIxUrpKlSll6YoioQWWiprLJ2Uqw
         Pz/IZLWnJoBRUm8vjDgsFcVYstg1gTq7NoU7WSbXP9XuGLZKLJIeRHeJE3V2GLbC7BpI
         t+Jg==
X-Forwarded-Encrypted: i=1; AJvYcCXmIPTK5I/JHW6xXrXZpmb+fu9/rGxCN7kEeBDNLkb1OTAkw4iSzkb6MZAmFGHhxQxly4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdhCFbSjms1IJ03N2datrUap7Fi222R5wIy+ZI57I1Aj3XDY+m
	9m68eX85xyYza4V0UvUD8te8DtojNXFul/77/qJqbawJAuMdGTHoXGE1lsHIkHB8nt7q3X9awLw
	muIqMe53oW4DUrw==
X-Google-Smtp-Source: AGHT+IEHnCRtwx12wpOA3voirEgIxF6o2sHy4ZO20JfJSbgSF9H+mvYXijzREvbfOldrCq5F1Zqrk3xc60Pudw==
X-Received: from pfbgd4.prod.google.com ([2002:a05:6a00:8304:b0:77f:1f29:5399])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1385:b0:776:1de4:aee6 with SMTP id d2e1a72fcca58-7938723c475mr6389586b3a.16.1759965968602;
 Wed, 08 Oct 2025 16:26:08 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:27 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-9-dmatlack@google.com>
Subject: [PATCH 08/12] vfio: selftests: Rename struct vfio_dma_region to dma_region
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename struct vfio_dma_region to dma_region. This is in preparation for
separating the VFIO PCI device library code from the IOMMU library code.
This name change also better reflects the fact that DMA mappings can be
managed by either VFIO or IOMMUFD. i.e. the "vfio_" prefix is
misleading.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/vfio/lib/include/vfio_util.h |  8 ++++----
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 14 +++++++-------
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |  2 +-
 .../testing/selftests/vfio/vfio_pci_driver_test.c  |  6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index b7175d4c2132..cce521212348 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -77,7 +77,7 @@ typedef u64 iova_t;
 
 #define INVALID_IOVA UINT64_MAX
 
-struct vfio_dma_region {
+struct dma_region {
 	struct list_head link;
 	void *vaddr;
 	iova_t iova;
@@ -151,7 +151,7 @@ struct vfio_pci_driver {
 	bool memcpy_in_progress;
 
 	/* Region to be used by the driver (e.g. for in-memory descriptors) */
-	struct vfio_dma_region region;
+	struct dma_region region;
 
 	/* The maximum size that can be passed to memcpy_start(). */
 	u64 max_memcpy_size;
@@ -222,9 +222,9 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 void vfio_pci_device_reset(struct vfio_pci_device *device);
 
 void vfio_pci_dma_map(struct vfio_pci_device *device,
-		      struct vfio_dma_region *region);
+		      struct dma_region *region);
 void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			struct vfio_dma_region *region);
+			struct dma_region *region);
 
 void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
 			    size_t config, size_t size, void *data);
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 1788e7892ee3..c9cfba1dc62c 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -30,7 +30,7 @@
 
 iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
 {
-	struct vfio_dma_region *region;
+	struct dma_region *region;
 
 	list_for_each_entry(region, &device->iommu->dma_regions, link) {
 		if (vaddr < region->vaddr)
@@ -142,7 +142,7 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
 }
 
 static void vfio_iommu_dma_map(struct vfio_pci_device *device,
-			       struct vfio_dma_region *region)
+			       struct dma_region *region)
 {
 	struct vfio_iommu_type1_dma_map args = {
 		.argsz = sizeof(args),
@@ -156,7 +156,7 @@ static void vfio_iommu_dma_map(struct vfio_pci_device *device,
 }
 
 static void iommufd_dma_map(struct vfio_pci_device *device,
-			    struct vfio_dma_region *region)
+			    struct dma_region *region)
 {
 	struct iommu_ioas_map args = {
 		.size = sizeof(args),
@@ -173,7 +173,7 @@ static void iommufd_dma_map(struct vfio_pci_device *device,
 }
 
 void vfio_pci_dma_map(struct vfio_pci_device *device,
-		      struct vfio_dma_region *region)
+		      struct dma_region *region)
 {
 	if (device->iommu->iommufd)
 		iommufd_dma_map(device, region);
@@ -184,7 +184,7 @@ void vfio_pci_dma_map(struct vfio_pci_device *device,
 }
 
 static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
-				 struct vfio_dma_region *region)
+				 struct dma_region *region)
 {
 	struct vfio_iommu_type1_dma_unmap args = {
 		.argsz = sizeof(args),
@@ -196,7 +196,7 @@ static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
 }
 
 static void iommufd_dma_unmap(struct vfio_pci_device *device,
-			      struct vfio_dma_region *region)
+			      struct dma_region *region)
 {
 	struct iommu_ioas_unmap args = {
 		.size = sizeof(args),
@@ -209,7 +209,7 @@ static void iommufd_dma_unmap(struct vfio_pci_device *device,
 }
 
 void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			struct vfio_dma_region *region)
+			struct dma_region *region)
 {
 	if (device->iommu->iommufd)
 		iommufd_dma_unmap(device, region);
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index ab19c54a774d..680232777839 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -126,7 +126,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 {
 	const u64 size = variant->size ?: getpagesize();
 	const int flags = variant->mmap_flags;
-	struct vfio_dma_region region;
+	struct dma_region region;
 	struct iommu_mapping mapping;
 	u64 mapping_size = size;
 	int rc;
diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
index 2dbd70b7db62..79128a0c278d 100644
--- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
@@ -19,7 +19,7 @@ static const char *device_bdf;
 } while (0)
 
 static void region_setup(struct vfio_pci_device *device,
-			 struct vfio_dma_region *region, u64 size)
+			 struct dma_region *region, u64 size)
 {
 	const int flags = MAP_SHARED | MAP_ANONYMOUS;
 	const int prot = PROT_READ | PROT_WRITE;
@@ -36,7 +36,7 @@ static void region_setup(struct vfio_pci_device *device,
 }
 
 static void region_teardown(struct vfio_pci_device *device,
-			    struct vfio_dma_region *region)
+			    struct dma_region *region)
 {
 	vfio_pci_dma_unmap(device, region);
 	VFIO_ASSERT_EQ(munmap(region->vaddr, region->size), 0);
@@ -44,7 +44,7 @@ static void region_teardown(struct vfio_pci_device *device,
 
 FIXTURE(vfio_pci_driver_test) {
 	struct vfio_pci_device *device;
-	struct vfio_dma_region memcpy_region;
+	struct dma_region memcpy_region;
 	void *vaddr;
 	int msi_fd;
 
-- 
2.51.0.710.ga91ca5db03-goog


