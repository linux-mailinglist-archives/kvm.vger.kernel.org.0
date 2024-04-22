Return-Path: <kvm+bounces-15460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C508AC4A1
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 09:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 841361F2190C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 07:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF84487BC;
	Mon, 22 Apr 2024 07:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UG33bpgU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026E1391;
	Mon, 22 Apr 2024 07:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713769234; cv=none; b=c8vfXQz2b6ucpTgfedFliAP3joluIotaAl9ki5RbxBVsQW2HwMkoFnvY3v5LOJlxdKGw6MztRktfo+lNdwD5ag+9ABObfr5QfenGI2lhJGd4qTfKmvVVnqmMIfJ+dfTxoH7fjXiqHCCXBU0/YZ9j9RcHfUzTzK5wdOIJpS3nl7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713769234; c=relaxed/simple;
	bh=YiQ/DpX5SzCxzEYtaD9CawGrBTtPFSoR6EHdNCTOEU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HU5E3uOPYZWY2jnGV47kc8cCDmBR4wg2xw04Ro00SgtJ83oqVu16MQR+GmVeC8jwdVvEHU/bOdUIoCRqTRM0FsLN7ZnoVukxv4su6aI0ai7QbZqq9qKO9mkPiIs8PJ5ru8bU1AHl3WnuF+MdwakTgYWo4FSpF72LDAYjJC4OKCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UG33bpgU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713769229; x=1745305229;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YiQ/DpX5SzCxzEYtaD9CawGrBTtPFSoR6EHdNCTOEU0=;
  b=UG33bpgUK26z6jSpuS9mD88TcDr8RLiT6Bp/FC+EMO3q+YvX8pJ3ESYn
   7xcCdF18UzrRj+dYxyNlddziSRpVhDBhFvjV0f6ZxhYmnLyDvEcdYttGx
   8x34k3u/XxLomnTvDgbF7Oyzwreb3m1VassmmhPXgtCVkNW73YSCKF2ju
   v0kNOpqzlWGE23LRnoSd/zPxL+aRrts+WbqOdoTcoKLypUpGvVjfpl8jI
   7cczzqGl7CP9bCCppi/waYjdezU+3s0W0b6YeoRcrzfw3PHMIfDZH01I+
   /PPLGpzsvdlaOBEFOLttc5jSmwHQ8Az/pqRMQs9TWs9LGGEf1R9HCCjiJ
   g==;
X-CSE-ConnectionGUID: cCMVz7rAQjOhd2PLkEoSDQ==
X-CSE-MsgGUID: iX2Ml7wHRo6svhCOoTmQzA==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="13080580"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="13080580"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:00:29 -0700
X-CSE-ConnectionGUID: eAlJzHO0RaGZrtSzJ/mIig==
X-CSE-MsgGUID: hGIa9n8XS2avXsL5VcGSaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="61362271"
Received: from vkasired-desk2.fm.intel.com ([10.105.128.132])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:00:29 -0700
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
To: dri-devel@lists.freedesktop.org,
	kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Oded Gabbay <ogabbay@kernel.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v1 0/2] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Sun, 21 Apr 2024 23:30:31 -0700
Message-ID: <20240422063602.3690124-1-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is an attempt to revive the patches posted by Jason Gunthorpe at:
https://patchwork.kernel.org/project/linux-media/cover/0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/

Here is the cover letter text from Jason's original series:
"dma-buf has become a way to safely acquire a handle to non-struct page
memory that can still have lifetime controlled by the exporter. Notably
RDMA can now import dma-buf FDs and build them into MRs which allows for
PCI P2P operations. Extend this to allow vfio-pci to export MMIO memory
from PCI device BARs.

This series supports a use case for SPDK where a NVMe device will be owned
by SPDK through VFIO but interacting with a RDMA device. The RDMA device
may directly access the NVMe CMB or directly manipulate the NVMe device's
doorbell using PCI P2P.

However, as a general mechanism, it can support many other scenarios with
VFIO. I imagine this dmabuf approach to be usable by iommufd as well for
generic and safe P2P mappings.

This series goes after the "Break up ioctl dispatch functions to one
function per ioctl" series."

In addition to the SPDK use-case mentioned above, the capability added
in this patch series can also be useful when a buffer (located in device
memory such as VRAM) needs to be shared between any two GPU devices or
instances (assuming one of them is bound to VFIO PCI) as long as they
are P2P DMA compatible.

The main difference between this series and the original one is the usage
of P2P DMA APIs to create struct pages (ZONE_DEVICE) to populate the
scatterlist instead of using DMA addresses. Other additions include a
mmap handler to provide CPU access to the dmabuf and support for
creating the dmabuf from multiple areas (or ranges).

This series is available at:
https://gitlab.freedesktop.org/Vivek/drm-tip/-/commits/vfio_dmabuf_v1

along with additional patches for Qemu and Spice here:
https://gitlab.freedesktop.org/Vivek/qemu/-/commits/vfio_dmabuf_1
https://gitlab.freedesktop.org/Vivek/spice/-/commits/encode_dmabuf_v4 

This series is tested using the following method:
- Run Qemu with the following relevant options:
  qemu-system-x86_64 -m 4096m ....
  -device vfio-pci,host=0000:03:00.0
  -device virtio-vga,max_outputs=1,blob=true,xres=1920,yres=1080
  -spice port=3001,gl=on,disable-ticketing=on,preferred-codec=gstreamer:h264
  -object memory-backend-memfd,id=mem1,size=4096M
  -machine memory-backend=mem1 ...
- Run upstream Weston with the following options in the Guest VM:
  ./weston --drm-device=card1 --additional-devices=card0

where card1 is a DG2 dGPU (assigned to vfio-pci) and card0 is
virtio-gpu.

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>

Vivek Kasireddy (2):
  vfio: Export vfio device get and put registration helpers
  vfio/pci: Allow MMIO regions to be exported through dma-buf

 drivers/vfio/pci/Makefile          |   1 +
 drivers/vfio/pci/dma_buf.c         | 348 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c |   8 +-
 drivers/vfio/pci/vfio_pci_core.c   |  28 ++-
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 drivers/vfio/vfio_main.c           |   2 +
 include/linux/vfio.h               |   2 +
 include/linux/vfio_pci_core.h      |   1 +
 include/uapi/linux/vfio.h          |  25 +++
 9 files changed, 430 insertions(+), 8 deletions(-)
 create mode 100644 drivers/vfio/pci/dma_buf.c

-- 
2.43.0


