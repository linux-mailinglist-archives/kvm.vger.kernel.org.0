Return-Path: <kvm+bounces-57304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE36B530B1
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CE917B4840
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752DB32253D;
	Thu, 11 Sep 2025 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZe3Hghg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E4F31C570;
	Thu, 11 Sep 2025 11:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757590449; cv=none; b=lFPkdrnrVa+LKwK5aSKW0QxfqaQz0tLNjcVoHc47trZYj7TDhDyqJ9+TviX4OvJXPHr0HuXlM10ASdE7PSyAIab6CXfQ6Y+N5i9xo9zOV07oZ9XA0TVQMDszts6vSS8w7NyWzom8D+O7jNB1Q1vOlji/W/vDd4ZRN29GJsH6fps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757590449; c=relaxed/simple;
	bh=J3JcsAko8zSIGuiXV9DflNw5AuJmzcXfJS1bY+J5d1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpfdPGC55ah/zxRGI+CW5h65wU9tLNbVI0g9q7vFOCx3AMdlBnGHlQsPBWnbDzPUA37LPt2zUI0HuEKqe7N/Zi6PTdIIOQdFn6T/mui3/9w4h4wouLK/S+MVKqay8hdLwuLtJTbg4JnaKeUVg/4AHmyae2z3A4/i7S4nR8MXpbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZe3Hghg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D78C4CEF1;
	Thu, 11 Sep 2025 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590449;
	bh=J3JcsAko8zSIGuiXV9DflNw5AuJmzcXfJS1bY+J5d1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZe3Hghg8tuilG38NUupXeM//AvgeiRR0kwGj/2e8WXc5R8k2LXEtxylcKu0V7VR4
	 1FL71pt5mLy3q7tg9mEDnGu1K88Gjtgeu2UYS8C2bKbKCCRRb9g+8K76CZAztiQE4R
	 zdqO+vDPlmfczjhKjstsRUe+TJcL8TsKnPJphvQgKiSQraI79PT0SA713CHwIloZ1b
	 QjKoUmsx9DTS6kou4xIZNyzUdbLcMrmVlBlLOlxFHYRxg+hUASmotNa3o3ZOLnAna3
	 tmduKfLeIIC88uvLVpyqh0eIdL4F2g8wYiqMwsjlbdIeqNN/nVtXrzcn3ko/5wuWDV
	 Cj92uwQIUWB2g==
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
Subject: [PATCH v2 07/10] vfio/pci: Add dma-buf export config for MMIO regions
Date: Thu, 11 Sep 2025 14:33:11 +0300
Message-ID: <e15b8a93822a69041e616edbea16e22644023be9.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
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


