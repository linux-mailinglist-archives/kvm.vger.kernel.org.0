Return-Path: <kvm+bounces-62182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE0CC3BB16
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 15:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 209184FA516
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 14:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF59A346A18;
	Thu,  6 Nov 2025 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6fIiXaZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C510B34676C;
	Thu,  6 Nov 2025 14:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762438654; cv=none; b=kEGFuALQDW0dn0+JgWfRmZDdjTmwuYiRvVH3g+NhZq5fmMp3gCHotidFDsfTCFHyGP30cBqlGxAiUP/Vo11voRyCdPikDY8lTKMIkaaSUb2CNg+uAKtIh7XAPvvyc+m9t8MK3sR/DzuZ3OaFoCrzjOX/STkUJluOBMsSzoBuEA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762438654; c=relaxed/simple;
	bh=RNhQRersDtpXI6Het2PRLPg6Pf8djhGeIyqap//L360=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sgvxEsy9UizFCBUn5PgUi9JZMz/OYijnkGlyZdT1FDvCcI5eef4C865OmwKC1foUa/WcXfUeYiIe9pZeCWBUYufNQIXJcC3JRGoXW/sI+9KxHuscjFvTYe/0hCXw773bI5PlwExxivb1dyPZoSb5sdLmQPSEqM+GU+j/b1mss2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6fIiXaZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98255C4CEF7;
	Thu,  6 Nov 2025 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438654;
	bh=RNhQRersDtpXI6Het2PRLPg6Pf8djhGeIyqap//L360=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6fIiXaZ/5bDfsBac8hg5pWveRHm4jDtJ2Pmq07lX/LOeyz3dSevkXrcQBCfyKuYd
	 U6SG36gTUwmv+VFgY/8Pi+n7w47W3F7HTwRRr4BHxDzJb3cyzVpP9wQ+r67ua/6N6I
	 jrgQKVzXxaJ/KaSZ87yyM64Tq1xoytln/zo7dCi1D1j/3osmxVx2BtmmLHnYiqda0p
	 RYm+25mT+E/zXXt1d3pA710K6i6NRouDKuwBIp797LHzwsEpR9aTnm1E31rgSOEK6i
	 iGKmgGdq0Q6+3C70mrCecWpZ/CFCYZZ3LIDg12Y42stnh1UvnmfA9P8IRgHSyLSp/g
	 vt+l5+4vaek2g==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v7 09/11] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Thu,  6 Nov 2025 16:16:54 +0200
Message-ID: <20251106-dmabuf-vfio-v7-9-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that all VFIO PCI devices have peer-to-peer capabilities
enables, so we would be able to export their MMIO memory through DMABUF,

VFIO has always supported P2P mappings with itself. VFIO type 1
insecurely reads PFNs directly out of a VMA's PTEs and programs them
into the IOMMU allowing any two VFIO devices to perform P2P to each
other.

All existing VMMs use this capability to export P2P into a VM where
the VM could setup any kind of DMA it likes. Projects like DPDK/SPDK
are also known to make use of this, though less frequently.

As a first step to more properly integrating VFIO with the P2P
subsystem unconditionally enable P2P support for VFIO PCI devices. The
struct p2pdma_provider will act has a handle to the P2P subsystem to
do things like DMA mapping.

While real PCI devices have to support P2P (they can't even tell if an
IOVA is P2P or not) there may be fake PCI devices that may trigger
some kind of catastrophic system failure. To date VFIO has never
tripped up on such a case, but if one is discovered the plan is to add
a PCI quirk and have pcim_p2pdma_init() fail. This will fully block
the broken device throughout any users of the P2P subsystem in the
kernel.

Thus P2P through DMABUF will follow the historical VFIO model and be
unconditionally enabled by vfio-pci.

Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ca9a95716a85..142b84b3f225 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-p2pdma.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2081,6 +2082,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	ret = pcim_p2pdma_init(vdev->pdev);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 

-- 
2.51.1


