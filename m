Return-Path: <kvm+bounces-58942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA5CBA727A
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 16:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10BEE3BD414
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 14:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3B9227BB5;
	Sun, 28 Sep 2025 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLB5tQ50"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0B0225760;
	Sun, 28 Sep 2025 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759071087; cv=none; b=hjVJ0GN1FpF4ESCW9EnFga7WqrUIXOusYEYAUnNSMLBVb4KsPwWBvM153NciUSHCrhAw/HX5KFs3fMslqzcUSXFwKSZgO1pX1e8/lnUW2yxbAWOKfN9Ftt/sNdlh7+e5xOR4gjuLAPj+bCDRXKUZU6+sImc7s0wL4jZd4GLq2Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759071087; c=relaxed/simple;
	bh=DKvwpCnqloOQP4gNjx4LpWv4LaALSpED/WAUwRqb9RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buBqCu8Xx4mCOmc5+fykejaEs5bpWOzcC6PtGWqudcbIkc7G/WtKihXxRXNu4kjgjqswhynPcit/Ff/Y/Q/79idBsP4yRD7KEH4ZLQZ8MJ/HRIzpB9TTeBtSkkTG2bXVXdyJ4OXa32RdSYvmU5hkBoMLodpXvUUcHIhBJgaH48A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLB5tQ50; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23892C4CEF0;
	Sun, 28 Sep 2025 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071086;
	bh=DKvwpCnqloOQP4gNjx4LpWv4LaALSpED/WAUwRqb9RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLB5tQ504wyZ06bziwpYmGZs7d/65HLAkuIuZ2w4wn63OQWzA8bn3uwK2vY1fgyI7
	 YteGOFAlizroxNAAuzQVXbCY9BcNIxlVfue87ttl/p7PYCe+EKehOJBOf/gVZL7//D
	 n0laClD+mHZgAZM/Osi+VvseOvikIkXb3YMq3iu8apoVM0OBIeMSkcTfGVuSjG+EE9
	 3kEM4QUMzbWESQaHowjOKmhur2RNOJQhGfp4qdw9S7QyYrhUnGD0GXrNplr9mN60YV
	 6Lr/kXRnTMWDPREa03fJk816RxmBwA7pvVuO5H7m9HKib+l/yxguspmf3YaWOSj33n
	 pNZ5pv/0Y7MIw==
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
Subject: [PATCH v4 07/10] vfio/pci: Add dma-buf export config for MMIO regions
Date: Sun, 28 Sep 2025 17:50:17 +0300
Message-ID: <b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
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
index 2b0172f54665..55ae888bf26a 100644
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


