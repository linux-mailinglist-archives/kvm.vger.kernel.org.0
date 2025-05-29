Return-Path: <kvm+bounces-47931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D6BAC77C5
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1FC5A26151
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E73254B17;
	Thu, 29 May 2025 05:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTx9ig1C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DDB25394F;
	Thu, 29 May 2025 05:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497299; cv=none; b=CR4MkAns61HJdAwsj9me88KnEYjQHTkuri3Bmuswf5F7Ixmt8BaVi7cMkwRDBMtnVhRGNG5r7gZ6swmCeyhno2MxY98WW4/a34WG4hth0YWHuUzDwlb6XWqh190Eu6KCfX5AaUpt+wA+t88PogfeXK32UR6l0C4Ab9bLs4VtM+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497299; c=relaxed/simple;
	bh=3W0vPV+xt1laPx1GlvtRmUQDEr7o4pclP/jpfWpkmNo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=VR+qlgsd4CfNewaDl8aQSAcTO9WrCFELEiUIMmaIhtT/EYSg/zVn8es0BA3tDRQPLj2SJtwYbJC/NdT2wxgVb2kOZsHolN4E+jlCNn9bDyfnl6/IWM+TqGYSw9SpYiF2mgPQvDQDAwJp6BMQLWoZFQEr+qAaQ3JjUkMl8/AthU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JTx9ig1C; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497298; x=1780033298;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3W0vPV+xt1laPx1GlvtRmUQDEr7o4pclP/jpfWpkmNo=;
  b=JTx9ig1CnQa3RX8+baCDSE+QwVq0WUnuShr5uUBm5HMmpj+VcH0HRIi0
   TNBwCq+CM/sMjSOKuiCnawd4Zcg0B7MkiNRXRvN2cpHkPXd7Pr9/bFQsf
   h3a7fUx1RW6chcQBlYowhhz31bT6kCEYjgZ7uSeM/8Rvk4QBPfJuhvgLn
   sfBC0oFnHGbnIMvALKI7ZhOpU12niQj/2vQgv7RIVEubNo66QX1EL6V55
   neloZyk2f1+NWPKUvsy6Dn+thxiYWt0/EMP7SP0yBKpEYuyIzAiihdbFs
   p9Msbak+jRNcHICHFswBUb68d7qPzQLYf0qt80Oog3FLVjC0U2E0CW6QR
   g==;
X-CSE-ConnectionGUID: NdMr94bMT3SzHjoSmZ4F1A==
X-CSE-MsgGUID: OT9wjN8QSq+esDFaIgrdWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67962860"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67962860"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:41:37 -0700
X-CSE-ConnectionGUID: RvMnXIMXTeecNPbA3HQ1fA==
X-CSE-MsgGUID: k9XihmlSTX+401gEmTOQxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443212"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:41:31 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 00/30] Host side (KVM/VFIO/IOMMUFD) support for TDISP using TSM
Date: Thu, 29 May 2025 13:34:43 +0800
Message-Id: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series is the generic host side (KVM/VFIO/IOMMUFD) support for the
whole life cycle of private device assignment. It follows the
previously discussed flow chart [1], aim to better illustrate the
overall flow of private device assignment, find out and narrow down the
gaps of different vendors, and reach some common directions.

This series is based on Dan's Core TSM infrastructure series [2].  To
give a clear overview of what components are needed, it also includes
some existing WIP patchsets in community.

This series has 3 sections:

Patch 1 - 11 deal with the private MMIO mapping in KVM MMU via DMABUF.
Leverage Jason & Vivek's latest VFIO dmabuf series [3], see Patch 2 - 4.
The concern for get_pfn() kAPI [4] is not addressed so are marked as
HACK, will investigate later.

Patch 12 - 22 is about TSM Bind/Unbind/Guest request management in VFIO
& IOMMUFD. Picks some of Shameer's patch in [5], see Patch 12 & 14.

Patch 23 - 30 is a solution to meet the TDX specific sequence
enforcement on various device Unbind cases, including converting device
back to shared, hot unplug, TD destroy. Start with a tdx_tsm driver
prototype and finally implement the Unbind enforcement inside the
driver. To be honest it is still awkward to me, but I need help.

This series don't include the VMEXIT handle for GHCI/GHCB calls for
Bind/Unbind/Guest request, cause it involves vendor specific code. The
general idea is KVM should just pass these calls to QEMU, QEMU parses
out the command and call the newly introduced VFIO/IOMMUFD IOCTLs.

With additional TDX Connect specific patches (not published), passed
engineering test for trusted DMA in TD.

[1]: https://lore.kernel.org/all/aCYsNSFQJZzHVOFI@yilunxu-OptiPlex-7050/
[2]: https://lore.kernel.org/all/20250516054732.2055093-1-dan.j.williams@intel.com/
[3]: https://lore.kernel.org/kvm/20250307052248.405803-1-vivek.kasireddy@intel.com/
[4]: https://lore.kernel.org/all/20250107142719.179636-1-yilun.xu@linux.intel.com/
[5]: https://lore.kernel.org/all/20250319173202.78988-3-shameerali.kolothum.thodi@huawei.com/


Alexey Kardashevskiy (1):
  iommufd/vdevice: Add TSM Guest request uAPI

Dan Williams (2):
  coco/tdx_tsm: Introduce a "tdx" subsystem and "tsm" device
  coco/tdx_tsm: TEE Security Manager driver for TDX

Shameer Kolothum (2):
  iommufd/device: Associate a kvm pointer to iommufd_device
  iommu/arm-smmu-v3-iommufd: Pass in kvm pointer to viommu_alloc

Vivek Kasireddy (3):
  vfio: Export vfio device get and put registration helpers
  vfio/pci: Share the core device pointer while invoking feature
    functions
  vfio/pci: Allow MMIO regions to be exported through dma-buf

Wu Hao (1):
  coco/tdx_tsm: Add connect()/disconnect() handlers prototype

Xu Yilun (21):
  HACK: dma-buf: Introduce dma_buf_get_pfn_unlocked() kAPI
  fixup! vfio/pci: fix dma-buf revoke typo on reset
  HACK: vfio/pci: Support get_pfn() callback for dma-buf
  KVM: Support vfio_dmabuf backed MMIO region
  KVM: x86/mmu: Handle page fault for vfio_dmabuf backed MMIO
  KVM: x86/mmu: Handle page fault for private MMIO
  vfio/pci: Export vfio dma-buf specific info for importers
  KVM: vfio_dmabuf: Fetch VFIO specific dma-buf data for sanity check
  fixup! iommufd/selftest: Sync iommufd_device_bind() change to selftest
  fixup: iommu/selftest: Sync .viommu_alloc() change to selftest
  iommufd/viommu: track the kvm pointer & its refcount in viommu core
  iommufd/device: Add TSM Bind/Unbind for TIO support
  iommufd/viommu: Add trusted IOMMU configuration handlers for vdev
  vfio/pci: Add TSM TDI bind/unbind IOCTLs for TEE-IO support
  vfio/pci: Do TSM Unbind before zapping bars
  fixup! PCI/TSM: Change the guest request type definition
  coco/tdx_tsm: Add bind()/unbind()/guest_req() handlers prototype
  PCI/TSM: Add PCI driver callbacks to handle TSM requirements
  vfio/pci: Implement TSM handlers for MMIO
  iommufd/vdevice: Implement TSM handlers for trusted DMA
  coco/tdx_tsm: Manage TDX Module enforced operation sequences for
    Unbind

 Documentation/virt/kvm/api.rst                |   7 +
 arch/x86/Kconfig                              |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  25 +-
 drivers/dma-buf/dma-buf.c                     |  87 +++-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   1 +
 drivers/iommu/iommufd/device.c                |  89 +++-
 drivers/iommu/iommufd/iommufd_private.h       |  10 +
 drivers/iommu/iommufd/main.c                  |   3 +
 drivers/iommu/iommufd/selftest.c              |   3 +-
 drivers/iommu/iommufd/viommu.c                | 202 ++++++++-
 drivers/vfio/iommufd.c                        |  24 +-
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/pci/vfio_pci_config.c            |  26 +-
 drivers/vfio/pci/vfio_pci_core.c              | 161 ++++++-
 drivers/vfio/pci/vfio_pci_dmabuf.c            | 411 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h              |  26 ++
 drivers/vfio/vfio_main.c                      |   2 +
 drivers/virt/coco/host/Kconfig                |  10 +
 drivers/virt/coco/host/Makefile               |   3 +
 drivers/virt/coco/host/tdx_tsm.c              | 328 ++++++++++++++
 drivers/virt/coco/host/tdx_tsm_bus.c          |  70 +++
 include/linux/dma-buf.h                       |  13 +
 include/linux/iommu.h                         |   4 +-
 include/linux/iommufd.h                       |  12 +-
 include/linux/kvm_host.h                      |  25 +-
 include/linux/pci-tsm.h                       |  19 +-
 include/linux/pci.h                           |   3 +
 include/linux/tdx_tsm_bus.h                   |  17 +
 include/linux/vfio.h                          |  27 ++
 include/linux/vfio_pci_core.h                 |   3 +
 include/uapi/linux/iommufd.h                  |  36 ++
 include/uapi/linux/kvm.h                      |   1 +
 include/uapi/linux/vfio.h                     |  67 +++
 virt/kvm/Kconfig                              |   6 +
 virt/kvm/Makefile.kvm                         |   1 +
 virt/kvm/kvm_main.c                           |  32 +-
 virt/kvm/kvm_mm.h                             |  19 +
 virt/kvm/vfio_dmabuf.c                        | 151 +++++++
 40 files changed, 1868 insertions(+), 60 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c
 create mode 100644 drivers/virt/coco/host/tdx_tsm.c
 create mode 100644 drivers/virt/coco/host/tdx_tsm_bus.c
 create mode 100644 include/linux/tdx_tsm_bus.h
 create mode 100644 virt/kvm/vfio_dmabuf.c


base-commit: 88c473f04098a0f5ac6fbaceaad2daa842006b6a
-- 
2.25.1


