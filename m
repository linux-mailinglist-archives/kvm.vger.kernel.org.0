Return-Path: <kvm+bounces-49241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BE4AD6AAC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B525416146A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69EE221FDD;
	Thu, 12 Jun 2025 08:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NSr0uFjh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28133221DB1
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 08:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716878; cv=none; b=eHX7kK6UZoU3ioqAn7xyiiyG0wjW8ds+fYQNNPJ4yBhXWEsrGp4t3ipvuW77Gij6tUjf3r17f+qB2vn2etNVH8+G2/LIeMEk55EtSuh7kD0LCgN9SAfsVRL98J+zPqIiMfIOrKhh5alDj8gGXmvg/Ay4JszMFjo8USflBIa/vKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716878; c=relaxed/simple;
	bh=joAghIkMYWd3PwQ3ujiYRJi4NlnEZo8X1PfGmwzB2O0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P3zrOp3ZM3ThsIIQgstQwd1muXI03PJx8e8NBfp+c7gqWo9l8YbkspLm1ema+3e28a4m04s/d0pKEZ5hsCa7XYDTPmJ/xtvCYv9zUry5VrJ8kHolVFP/KI39HLPf8B6oyvLXXOAM2vA1cIKeR/UhrnB/QN6NrBx7SuEa1COo6nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NSr0uFjh; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716877; x=1781252877;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=joAghIkMYWd3PwQ3ujiYRJi4NlnEZo8X1PfGmwzB2O0=;
  b=NSr0uFjh/+9Nk98YBnEk/bCitVew2TiSXsmA8tjSWBwtwxK/ixCfYWyV
   5jX5iSqIPk1dBJ7GcehjistyMd2/UbMz+dd/pOsPrml1grqYiwJbTRI9x
   HULwjG+5m/AhNAOvu/idJXi5sOH8mGgXV2QSFcMZbsbYZmi1zZnq6IXoM
   0vbiC8/H56mXplfsDuXI8DCYJGtSkppzUjxSSsmJ5UEKrYu/Da6QRId01
   woOh+E9ZRrXZh/YS/xFRU59Yu8VFaYyFErpT+Uz1aDHQlxrfLq3IrO1Gs
   L6z1iDKOU/i70gcKYhHZGtVmyjqKSIA7IvRtZ0fyv0Xt4gqkNJ8aOaqLL
   w==;
X-CSE-ConnectionGUID: BCS1HKIoThWoZi42vI8AHw==
X-CSE-MsgGUID: q8bHN12JTI6Jcf4ntedQQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="69453404"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="69453404"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:27:57 -0700
X-CSE-ConnectionGUID: NQmv2W5WSy+Nx6F6IAFlbQ==
X-CSE-MsgGUID: UU37cAuWSheeqWtyRGWcyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="152442004"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:27:53 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v7 0/5] Enable shared device assignment
Date: Thu, 12 Jun 2025 16:27:41 +0800
Message-ID: <20250612082747.51539-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v7 series of the shared device assignment support.

There are not many differences compared to the previous version [1]. The
primary changes include some code cleanup in patch #4 and the addition
of a new comment in patch #5 to describe the brief period of status
consistency.

Overview of this series:

- Patch 1-3: Preparation patches. These include function exposure and
  some function prototype changes.
- Patch 4: Introduce a new object to implement RamDiscardManager
  interface and a helper to notify the shared/private state change.
- Patch 5: Enable coordinated discarding of RAM with guest_memfd through
  the RamDiscardManager interface.

---

Background
==========
Confidential VMs have two classes of memory: shared and private memory.
Shared memory is accessible from the host/VMM while private memory is
not. Confidential VMs can decide which memory is shared/private and
convert memory between shared and private at runtime.

"guest_memfd" is a new kind of fd whose primary goal is to serve guest
private memory. In current implementation, shared memory is allocated
with normal methods (e.g. mmap or fallocate) while private memory is
allocated from guest_memfd. When a VM performs memory conversions, QEMU
frees pages via madvise or via PUNCH_HOLE on memfd or guest_memfd from
one side, and allocates new pages from the other side. This will cause a
stale IOMMU mapping issue mentioned in [2] when we try to enable shared
device assignment in confidential VMs.

Solution
========
The key to enable shared device assignment is to update the IOMMU mappings
on page conversion. RamDiscardManager, an existing interface currently
utilized by virtio-mem, offers a means to modify IOMMU mappings in
accordance with VM page assignment. Page conversions is similar to
hot-removing a page in one mode and adding it back in the other.

This series implements a RamDiscardmanager for confidential VMs and
utilizes its infrastructure to notify VFIO of page conversions.

Limitation and future extension
===============================
This series only supports the basic shared device assignment functionality.
There are still some limitations and areas that can be extended or
optimized in the future.

Relationship with in-place conversion
-------------------------------------
In-place page conversion is the ongoing work to allow mmap() of
guest_memfd to userspace so that both private and shared memory can use
the same physical memory as the backend. This new design eliminates the
need to discard pages during shared/private conversions. When it is
ready, shared device assignment needs be adjusted to achieve an
unmap-before-conversion-to-private and map-after-conversion-to-shared
sequence to be compatible with the change.

Partial unmap limitation
------------------------
VFIO expects the DMA mapping for a specific IOVA to be mapped and
unmapped with the same granularity. The guest may perform partial
conversion, such as converting a small region within a larger one. To
prevent such invalid cases, current operations are performed with 4K
granularity. This could be optimized after DMA mapping cut operation
[3] is introduced in the future. We can always perform a
split-before-unmap if partial conversions happens. If the split
succeeds, the unmap will succeed and be atomic. If the split fails, the
unmap process fails.

More attributes management
--------------------------
Current RamDiscardManager can only manage a pair of opposite states like
populated/discared or shared/private. If more states need to be
considered, for example, support virtio-mem in confidential VMs, three
states would be possible (shared populated/private populated/discard).
Current framework cannot handle such scenario and we need to think of
some new framework at that time [4].

Memory overhead optimization
----------------------------
A comment from Baolu [5] suggests considering using Maple Tree or a generic
interval tree to manage private/shared state instead of a bitmap, which
can reduce memory consumption. This optmization can also be considered
in other bitmap use cases like dirty bitmaps for guest RAM.

Testing
=======
This patch series is tested based on kenrel v6.16-rc1 since TDX base
support has been merged. The QEMU repo is available at
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2025-06-12-v2

To facilitate shared device assignment with the NIC, employ the legacy
type1 VFIO with the QEMU command:

qemu-system-x86_64 [...]
    -device vfio-pci,host=XX:XX.X

The parameter of dma_entry_limit needs to be adjusted. For example, a
16GB guest needs to adjust the parameter like
vfio_iommu_type1.dma_entry_limit=4194304.

If use the iommufd-backed VFIO with the qemu command:

qemu-system-x86_64 [...]
    -object iommufd,id=iommufd0 \
    -device vfio-pci,host=XX:XX.X,iommufd=iommufd0

Related link
============
[1] https://lore.kernel.org/qemu-devel/20250530083256.105186-1-chenyi.qiang@intel.com/
[2] https://lore.kernel.org/qemu-devel/20240423150951.41600-54-pbonzini@redhat.com/
[3] https://lore.kernel.org/linux-iommu/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com/
[4] https://lore.kernel.org/qemu-devel/d1a71e00-243b-4751-ab73-c05a4e090d58@redhat.com/
[5] https://lore.kernel.org/qemu-devel/013b36a9-9310-4073-b54c-9c511f23decf@linux.intel.com/

Chenyi Qiang (5):
  memory: Export a helper to get intersection of a MemoryRegionSection
    with a given range
  memory: Change memory_region_set_ram_discard_manager() to return the
    result
  memory: Unify the definiton of ReplayRamPopulate() and
    ReplayRamDiscard()
  ram-block-attributes: Introduce RamBlockAttributes to manage RAMBlock
    with guest_memfd
  physmem: Support coordinated discarding of RAM with guest_memfd

 MAINTAINERS                   |   1 +
 accel/kvm/kvm-all.c           |   9 +
 hw/virtio/virtio-mem.c        |  83 +++----
 include/system/memory.h       | 100 ++++++--
 include/system/ramblock.h     |  22 ++
 migration/ram.c               |   5 +-
 system/memory.c               |  22 +-
 system/meson.build            |   1 +
 system/physmem.c              |  23 +-
 system/ram-block-attributes.c | 442 ++++++++++++++++++++++++++++++++++
 system/trace-events           |   3 +
 11 files changed, 627 insertions(+), 84 deletions(-)
 create mode 100644 system/ram-block-attributes.c

-- 
2.43.5


