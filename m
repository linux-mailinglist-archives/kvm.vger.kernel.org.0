Return-Path: <kvm+bounces-58755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDB7B9F877
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 15:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C86E188A8AC
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 13:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D055D27F18B;
	Thu, 25 Sep 2025 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nyyiardu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80AB27A92E;
	Thu, 25 Sep 2025 13:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758806333; cv=none; b=da50hkk87IK9soSmuk8RnZo/AIgYw4+OF8NE+/gPG4LFa6hNr/Y+h5UgJj1j8ilcI3eGFfR+oUy3DB6vEFafVYMDrBpF1e4aYqxMbjD+ErlTkTUBmBeg0NK/bhVD3mpZHXyX07Vc6L8jyUlNJp8R8/yaXkf3qz+z3wpzDYNgfcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758806333; c=relaxed/simple;
	bh=J3JcsAko8zSIGuiXV9DflNw5AuJmzcXfJS1bY+J5d1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9qnV48YvtAbSx04GS1Vgl1Xxzr4QHOZCdyehR9qgwd3gYCGDuaS+o+OJN3SghjGFuQXsKiGS9J4da6uxoj+z0nE50xdAKgXAHjvHhc10/2IFOI6Mfl0EmlDPezIqYCCCOjNNMVPSdgi4Ab+hHCh3Q/nPCyjd/CtJHrj8+sg8oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nyyiardu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDB3C4CEF7;
	Thu, 25 Sep 2025 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806332;
	bh=J3JcsAko8zSIGuiXV9DflNw5AuJmzcXfJS1bY+J5d1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nyyiardu2Jm2P99Ky9DPkc45OpBK6VXC2cDJ2ntyOymvqcGgd7qxrLq7aOKcpmvrB
	 5XtWc3qlZGvSsKGzKNx+xxbBh9eXebQcre8M4Bb/SEeFez1GqGCqP9IYRto9erX4mA
	 xMbo23J/F/gS9OYPIVigsvaRVXoubU6we02xEUbwHPq2xk6hXv4kjVijzWspwlc1DQ
	 i35RE92E6sbTQMb59F66xvBBp/vg5DYOswYfaxASsoGs62yrjSwe8ELTEJGw6PkZ4a
	 C+Bv9QieZeKuF7wRH7Mb2kELbArKXalgOTpImh/q8etNoCarPsndtLwMReFQauTWd0
	 bwvkCQ5iBtzuQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 07/10] vfio/pci: Add dma-buf export config for MMIO regions
Date: Thu, 25 Sep 2025 16:14:35 +0300
Message-ID: <b3b718403b85e792ddc8a8a1c47ff214b416eb7b.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Add new kernel config which indicates support for dma-buf export
of MMIO regions, which implementation is provided in next patches.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 2b0172f546652..55ae888bf26ae 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
 
 	  To enable s390x KVM vfio-pci extensions, say Y.
 
+config VFIO_PCI_DMABUF
+	bool "VFIO PCI extensions for DMA-BUF"
+	depends on VFIO_PCI_CORE
+	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
+	default y
+	help
+	  Enable support for VFIO PCI extensions that allow exporting
+	  device MMIO regions as DMA-BUFs for peer devices to access via
+	  peer-to-peer (P2P) DMA.
+
+	  This feature enables a VFIO-managed PCI device to export a portion
+	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
+	  to other userspace drivers or kernel subsystems capable of
+	  initiating DMA to that region.
+
+	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
+	  support for peer-to-peer DMA use cases.
+
+	  If unsure, say N.
+
 source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
-- 
2.51.0


