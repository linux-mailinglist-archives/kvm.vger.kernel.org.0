Return-Path: <kvm+bounces-47101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74DBCABD508
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C4734C20B6
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DE326E15D;
	Tue, 20 May 2025 10:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b2wZSf32"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95E426B08D
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736947; cv=none; b=sviTO6bTM0g4T7Ty4HZDyzw+MLUVaL19wRxzxIArID3qjgEdmZsugh6LTUbozVswwElgxEG3YYBdB2l1fI1pFItobBwo/oSwqkR+K4ra0qBDn6eqHxmYS7z86UtiGRtYIkBtoXPMHUy7GyWD//gVz7VDy6nJb4QG4h7fZLB4sg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736947; c=relaxed/simple;
	bh=9JU4KRuBjIZ/fwOUCW3LW93ux2jg9gglm4OlG0lJK+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oJmuc2H/NmAzy6frimlQrgoidZ9iXxoPDaguzvAhxT2dYVkWLZHi22922UnNSSmrYFBNp/9qTX4edK3wAvVgGN6fLtDh4i0ON6/apLr+fOjLkzuZn5MX6aqqsFS51ck4/KB7CvWdKIO40fZAFBJ2LEoRYJ8s+zTdEyitOSejng8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b2wZSf32; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736945; x=1779272945;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9JU4KRuBjIZ/fwOUCW3LW93ux2jg9gglm4OlG0lJK+Y=;
  b=b2wZSf323Ebx87KL0354bAbAtZDwvFaIIaVjdvtSyTV1tZsxKqzVhmx0
   duwzZEyQrVdRU+Zm5FCCh15FpOhp52jePBHL58eJ7Ukponu368wWnSrt5
   VawuLAOsrIyCdJypQZic91IxL5qTSYP7UoIPghhfRDRO5c81WZ1AYOjIT
   51LMzO5y2KSQPKbfipLrxO9YBBsg3KCrXsjX1c9jgndN0xIc+EXAqJgy/
   Lqj2MpYPfQ9MQcbpNmj0epLzQqUHR1TS0LHJdw+jodbw5VE9z32sEUiHJ
   ewn6Z0vzGsmpPahaVHz3/88zA1XjLrNLYIcI5XxxEST4iW2R4sjM1iVjv
   g==;
X-CSE-ConnectionGUID: qHmXA5ruS4CvodQZ7jldyA==
X-CSE-MsgGUID: Rb5XRlx0Suu+FPwOMHvzyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566603"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566603"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:05 -0700
X-CSE-ConnectionGUID: NO/ICbJZSxefTCn+T6qDag==
X-CSE-MsgGUID: sQmbhplGRWCiCx6BWjz4pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905180"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:00 -0700
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
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v5 00/10] Enable shared device assignment
Date: Tue, 20 May 2025 18:28:40 +0800
Message-ID: <20250520102856.132417-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v5 series of the shared device assignment support.

As discussed in the v4 series [1], the GenericStateManager parent class
and PrivateSharedManager child interface were deemed to be in the wrong
direction. This series reverts back to the original single
RamDiscardManager interface and puts it as future work to allow the
co-existence of multiple pairs of state management. For example, if we
want to have virtio-mem co-exist with guest_memfd, it will need a new
framework to combine the private/shared/discard states [2].

Another change since the last version is the error handling of memory
conversion. Currently, the failure of kvm_convert_memory() causes QEMU
to quit instead of resuming the guest. The complex rollback operation
doesn't add value and merely adds code that is difficult to test.
Although in the future, it is more likely to encounter more errors on
conversion paths like unmap failure on shared to private in-place
conversion. This series keeps complex error handling out of the picture
for now and attaches related handling at the end of the series for
future extension.

Apart from the above two parts with future work, there's some
optimization work in the future, i.e., using other more memory-efficient
mechanism to track ranges of contiguous states instead of a bitmap [3].
This series still uses a bitmap for simplicity.
 
The overview of this series:
- Patch 1-3: Preparation patches. These include function exposure and
  some definition changes to return values.
- Patch 4-5: Introduce a new object to implement RamDiscardManager
  interface and a helper to notify the shared/private state change.
- Patch 6: Store the new object including guest_memfd information in
  RAMBlock. Register the RamDiscardManager instance to the target
  RAMBlock's MemoryRegion so that the RamDiscardManager users can run in
  the specific path.
- Patch 7: Unlock the coordinate discard so that the shared device
  assignment (VFIO) can work with guest_memfd. After this patch, the
  basic device assignement functionality can work properly.
- Patch 8-9: Some cleanup work. Move the state change handling into a
  RamDiscardListener so that it can be invoked together with the VFIO
  listener by the state_change() call. This series dropped the priority
  support in v4 which is required by in-place conversions, because the
  conversion path will likely change.
- Patch 10: More complex error handing including rollback and mixture
  states conversion case.

More small changes or details can be found in the individual patches.

---
Original cover letter:

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
stale IOMMU mapping issue mentioned in [4] when we try to enable shared
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
To support 1G page support for guest_memfd [5], the current direction is to
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
cut_mapping operation[6] is introduced in future. We can alway perform a
split-before-unmap if partial conversions happen. If the split succeeds,
the unmap will succeed and be atomic. If the split fails, the unmap
process fails.

Testing
=======
This patch series is tested based on TDX patches available at:
KVM: https://github.com/intel/tdx/tree/kvm-coco-queue-snapshot/kvm-coco-queue-snapshot-20250408
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2025-05-20

Because the new features like cut_mapping operation will only be support in iommufd.
It is recommended to use the iommufd-backed VFIO with the qemu command:

qemu-system-x86_64 [...]
    -object iommufd,id=iommufd0 \
    -device vfio-pci,host=XX:XX.X,iommufd=iommufd0

Following the bootup of the TD guest, the guest's IP address becomes
visible, and iperf is able to successfully send and receive data.

Related link
============
[1] https://lore.kernel.org/qemu-devel/20250407074939.18657-1-chenyi.qiang@intel.com/
[2] https://lore.kernel.org/qemu-devel/d1a71e00-243b-4751-ab73-c05a4e090d58@redhat.com/
[3] https://lore.kernel.org/qemu-devel/96ab7fa9-bd7a-444d-aef8-8c9c30439044@redhat.com/
[4] https://lore.kernel.org/qemu-devel/20240423150951.41600-54-pbonzini@redhat.com/
[5] https://lore.kernel.org/kvm/cover.1747264138.git.ackerleytng@google.com/
[6] https://lore.kernel.org/linux-iommu/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com/


Chenyi Qiang (10):
  memory: Export a helper to get intersection of a MemoryRegionSection
    with a given range
  memory: Change memory_region_set_ram_discard_manager() to return the
    result
  memory: Unify the definiton of ReplayRamPopulate() and
    ReplayRamDiscard()
  ram-block-attribute: Introduce RamBlockAttribute to manage RAMBlock
    with guest_memfd
  ram-block-attribute: Introduce a helper to notify shared/private state
    changes
  memory: Attach RamBlockAttribute to guest_memfd-backed RAMBlocks
  RAMBlock: Make guest_memfd require coordinate discard
  memory: Change NotifyRamDiscard() definition to return the result
  KVM: Introduce RamDiscardListener for attribute changes during memory
    conversions
  ram-block-attribute: Add more error handling during state changes

 MAINTAINERS                                 |   1 +
 accel/kvm/kvm-all.c                         |  79 ++-
 hw/vfio/listener.c                          |   6 +-
 hw/virtio/virtio-mem.c                      |  83 ++--
 include/system/confidential-guest-support.h |   9 +
 include/system/memory.h                     |  76 ++-
 include/system/ramblock.h                   |  22 +
 migration/ram.c                             |  33 +-
 system/memory.c                             |  22 +-
 system/meson.build                          |   1 +
 system/physmem.c                            |  18 +-
 system/ram-block-attribute.c                | 514 ++++++++++++++++++++
 target/i386/kvm/tdx.c                       |   1 +
 target/i386/sev.c                           |   1 +
 14 files changed, 770 insertions(+), 96 deletions(-)
 create mode 100644 system/ram-block-attribute.c

-- 
2.43.5


