Return-Path: <kvm+bounces-42799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 988C3A7D6E1
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20513AE781
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBA0225776;
	Mon,  7 Apr 2025 07:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hDTAKCDz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A091A315F
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012191; cv=none; b=A14sHJ10o2tQbbDLOPMa1R8lW3+y1QxTpslfcsNY0MBx+R4VU9ggAEs1makf20vQavo7Vn4mAFAI1cazgXZMU0ps5fh2xSxKbCGXhuMsn2buDX26FPcRO5UgVyZDDnvCVXreeFdUxZiIQH6t8+8m9+KD8bqjYPZo0+9sJ6tsu8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012191; c=relaxed/simple;
	bh=mSAezktNG8dVzVhMCB8PZG527ESENfq5hxoLu+AvQFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N4T6e1iJYFxhoBco+zQE4ALlG82l5h0bFNobQZNyn7nO9pnm4AfPKBZ/Epje/9Q7ynWtF+eQvNPfxa3CsFXbRliWzeM1jUIjduFt8uF2yof+syfFhjo/DrBl/yKXgFwKVLlHhLzcAhZCcF7aTwwWWtwc0gDxVflaUrZEB/FgIk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hDTAKCDz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012189; x=1775548189;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mSAezktNG8dVzVhMCB8PZG527ESENfq5hxoLu+AvQFY=;
  b=hDTAKCDzEdKm2NRxcQxooCSU1p2aC3PrL+oxsDaUO1qoKSk9AaQxnVFu
   uJVJBZailWkzN3vMt7qesERi6VQvHQCYFTb7LdFnj71DzOH9zOJ3ZN9hQ
   tFdYsmcqy/qHhW/aBcmwsgXg5CwSpQ72gakUApwAu5IeHTh3m6OJzUbku
   1FHkU8OvPdMGq9rgrQclnQHXC2DYobaeh2X5EsuQ4P2km476flBLsH95J
   3nGZU9IngPgXngvC14ardxXJO5+ww+ff6QFsfi/9rBr24LNuwH68Z1NMS
   aVSW4z3i+z9pV/7ZXWzrq2h+tFdxmOCiZbDSDWAf3oX6tLRy4/cj1aUa6
   A==;
X-CSE-ConnectionGUID: AXH+k2NrRmCjjTSVCJBysA==
X-CSE-MsgGUID: SYnzH7zxQimkXgRsiC0f1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857494"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857494"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:49:48 -0700
X-CSE-ConnectionGUID: UzeJQF2cTKO9kHzxBF8TBA==
X-CSE-MsgGUID: lxvyyHAzR66S88l7ynURxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405457"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:49:45 -0700
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
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v4 00/13] Enable shared device assignment
Date: Mon,  7 Apr 2025 15:49:20 +0800
Message-ID: <20250407074939.18657-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v4 series of the shared device assignment support.

Compared with v3 series, the main changes are:

- Introduced a new GenericStateManager parent class, so that the existing
  RamDiscardManager and new PrivateSharedManager can be its child class
  and manage different states.
- Changed the name of MemoryAttributeManager to RamBlockAttribute to
  distinguish from the XXXManager interface and still use it to manage
  guest_memfd information. Meanwhile, Use it to implement
  PrivateSharedManager instead of RamDiscardManager to distinguish the
  states of populate/discard and shared/private.
- Moved the attribute change operations into a listener so that both the
  attribute change and IOMMU pins can be invoked in listener callbacks.
- Added priority listener support in PrivateSharedListener so that the
  attribute change listener and VFIO listener can be triggered in
  expected order to comply with in-place conversin requirement.
- v3: https://lore.kernel.org/qemu-devel/20250310081837.13123-1-chenyi.qiang@intel.com/

The overview of this series:
- Patch 1-3: preparation patches. These include function exposure and
  some definition changes to return values.
- Patch 4: Introduce a generic state change parent class with
  RamDiscardManager as its child class. This paves the way to introduce
  new child classes to manage other memory states.
- Patch 5-6: Introduce a new child class, PrivateSharedManager, to
  manage the private and shared states. Also adds VFIO support for this
  new interface to coordinate RAM discard support. 
- Patch 7-9: Introduce a new object to implement the
  PrivateSharedManager interface and a callback to notify the
  shared/private state change. Stores it in RAMBlocks and register it in
  the target MemoryRegion so that the object can notify page conversion
  events to other systems.
- Patch 10-11: Moves the state change handling into a
  PrivateSharedListener so that it can be invoked together with the VFIO
  listener by the state_change() call.
- Patch 12: To comply with in-place conversion, introduces the priority
  listener support so that the attribute change and IOMMU pin can follow
  the expected order.
- Patch 13: Unlocks the coordinate discard so that the shared device
  assignment (VFIO) can work with guest_memfd.

More small changes or details can be found in the individual patches.

---
Original cover letter with minor changes related to new parent class:

Background
==========
Confidential VMs have two classes of memory: shared and private memory.
Shared memory is accessible from the host/VMM while private memory is
not. Confidential VMs can decide which memory is shared/private and
convert memory between shared/private at runtime.

"guest_memfd" is a new kind of fd whose primary goal is to serve guest
private memory. In current implementation, shared memory is allocated
with normal methods (e.g. mmap or fallocate) while private memory is
allocated from guest_memfd. When a VM performs memory conversions, QEMU
frees pages via madvise or via PUNCH_HOLE on memfd or guest_memfd from
one side, and allocates new pages from the other side. This will cause a
stale IOMMU mapping issue mentioned in [1] when we try to enable shared
device assignment in confidential VMs.

Solution
========
The key to enable shared device assignment is to update the IOMMU mappings
on page conversion. RamDiscardManager, an existing interface currently
utilized by virtio-mem, offers a means to modify IOMMU mappings in
accordance with VM page assignment. Although the required operations in
VFIO for page conversion are similar to memory plug/unplug, the states of
private/shared are different from discard/populated. We want a similar
mechanism with RamDiscardManager but used to manage the state of private
and shared.

This series introduce a new parent abstract class to manage a pair of
opposite states with RamDiscardManager as its child to manage
populate/discard states, and introduce a new child class,
PrivateSharedManager, which can also utilize the same infrastructure to
notify VFIO of page conversions.

Relationship with in-place page conversion
==========================================
To support 1G page support for guest_memfd [2], the current direction is to
allow mmap() of guest_memfd to userspace so that both private and shared
memory can use the same physical pages as the backend. This in-place page
conversion design eliminates the need to discard pages during shared/private
conversions. However, device assignment will still be blocked because the
in-place page conversion will reject the conversion when the page is pinned
by VFIO.

To address this, the key difference lies in the sequence of VFIO map/unmap
operations and the page conversion. It can be adjusted to achieve
unmap-before-conversion-to-private and map-after-conversion-to-shared,
ensuring compatibility with guest_memfd.

Limitation
==========
One limitation is that VFIO expects the DMA mapping for a specific IOVA
to be mapped and unmapped with the same granularity. The guest may
perform partial conversions, such as converting a small region within a
larger region. To prevent such invalid cases, all operations are
performed with 4K granularity. This could be optimized after the
cut_mapping operation [3] is introduced in future. We can alway perform a
split-before-unmap if partial conversions happen. If the split succeeds,
the unmap will succeed and be atomic. If the split fails, the unmap
process fails.

Testing
=======
This patch series is tested based on TDX patches available at:
KVM: https://github.com/intel/tdx/tree/kvm-coco-queue-snapshot/kvm-coco-queue-snapshot-20250322
     (With the revert of HEAD commit)
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2025-04-07

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

No additional adjustment required.

Following the bootup of the TD guest, the guest's IP address becomes
visible, and iperf is able to successfully send and receive data.

Related link
============
[1] https://lore.kernel.org/qemu-devel/20240423150951.41600-54-pbonzini@redhat.com/
[2] https://lore.kernel.org/lkml/cover.1726009989.git.ackerleytng@google.com/
[3] https://lore.kernel.org/linux-iommu/7-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/

Chenyi Qiang (13):
  memory: Export a helper to get intersection of a MemoryRegionSection
    with a given range
  memory: Change memory_region_set_ram_discard_manager() to return the
    result
  memory: Unify the definiton of ReplayRamPopulate() and
    ReplayRamDiscard()
  memory: Introduce generic state change parent class for
    RamDiscardManager
  memory: Introduce PrivateSharedManager Interface as child of
    GenericStateManager
  vfio: Add the support for PrivateSharedManager Interface
  ram-block-attribute: Introduce RamBlockAttribute to manage RAMBLock
    with guest_memfd
  ram-block-attribute: Introduce a callback to notify shared/private
    state changes
  memory: Attach RamBlockAttribute to guest_memfd-backed RAMBlocks
  memory: Change NotifyStateClear() definition to return the result
  KVM: Introduce CVMPrivateSharedListener for attribute changes during
    page conversions
  ram-block-attribute: Add priority listener support for
    PrivateSharedListener
  RAMBlock: Make guest_memfd require coordinate discard

 accel/kvm/kvm-all.c                         |  81 +++-
 hw/vfio/common.c                            | 131 +++++-
 hw/vfio/container-base.c                    |   1 +
 hw/virtio/virtio-mem.c                      | 168 +++----
 include/exec/memory.h                       | 407 ++++++++++------
 include/exec/ramblock.h                     |  25 +
 include/hw/vfio/vfio-container-base.h       |  10 +
 include/system/confidential-guest-support.h |  10 +
 migration/ram.c                             |  21 +-
 system/memory.c                             | 137 ++++--
 system/memory_mapping.c                     |   6 +-
 system/meson.build                          |   1 +
 system/physmem.c                            |  20 +-
 system/ram-block-attribute.c                | 495 ++++++++++++++++++++
 target/i386/kvm/tdx.c                       |   1 +
 target/i386/sev.c                           |   1 +
 16 files changed, 1192 insertions(+), 323 deletions(-)
 create mode 100644 system/ram-block-attribute.c

-- 
2.43.5


