Return-Path: <kvm+bounces-22213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D0093BD02
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 09:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C510B2830A7
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 07:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9F116F84F;
	Thu, 25 Jul 2024 07:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQMa8i/m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBB84428
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721892160; cv=none; b=f2/t/QjB68FsFb3BMOxlx9FoDm3xBB+GhJUuz9SfvEDa6ljcOMsRXeFfBD8kucBYo9F6PwkRsDV7PbXv0v5Y9Jlne5OUazmHP13QrZMwGTq8sF7DW294jh/F3ry04z1e6SuN2M3ImzfUyzKBwkd5C64+j5wY7tturCwgb7fA4nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721892160; c=relaxed/simple;
	bh=fCGXuk1OlehWsXuBwZOTRT0DK5yQ8xJuS1pxLg/KV+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A7cDbLTob8UhoDQFdUxUvt9YtntEOKb31DzFDLG95tI1NDHjVI2QgA7iJ+X+nrcYgYdBLLYS0wY44+yebL+s/2UtYKvKFPqsU6X8vgagY1gN+M9nCuegudVXmXUEPayVtzkQbofTvhX+lcTJpbkHXeEVgPeagsOlEXy+tWCjewE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQMa8i/m; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721892158; x=1753428158;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fCGXuk1OlehWsXuBwZOTRT0DK5yQ8xJuS1pxLg/KV+c=;
  b=kQMa8i/m4JKYSkwl+ezoBqD/8RQvhJ0eWxbkTajfCkO/rS0zRfti/2KB
   QdUzsYCrFe9FbRleh74kN9txg3261VIbEghm3OT6UXDCb3nBkSP0oKLjE
   DtPFzWj4Z7WfXlWzrQpY4CeeGA2HT0Vzu8YtR61ycTZldZ2NrNDwaSLo5
   iGcxlBBRDxia8HwWbKWFBQFA08oXwtEcCd5y9GgGITA4cb12mMvl6dqha
   8n1OqHPF2a52jsXkWAE51IBaGXj4X1q2y8mJ12jdsDAYIFLQi3wHbEvOe
   BAjFENYO1rQzqJJzC/ie6QZIVYiRrunyXe48VZ45VoeJrWtWrqD4EZbgr
   A==;
X-CSE-ConnectionGUID: +J89pn50RHCCxX8KOFNL+Q==
X-CSE-MsgGUID: uhMoSoLIRJGR3fXafKBZYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30753916"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="30753916"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:38 -0700
X-CSE-ConnectionGUID: CUQ2TppUT7y1qyX+oSeVHw==
X-CSE-MsgGUID: vhKsDaAtQeCfNWrdhm/Zcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="52858136"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:35 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [RFC PATCH 0/6] Enable shared device assignment
Date: Thu, 25 Jul 2024 03:21:09 -0400
Message-ID: <20240725072118.358923-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
discard") effectively disables device assignment with guest_memfd.
guest_memfd is required for confidential guests, so device assignment to
confidential guests is disabled. A supporting assumption for disabling
device-assignment was that TEE I/O (SEV-TIO, TDX Connect, COVE-IO
etc...) solves the confidential-guest device-assignment problem [1].
That turns out not to be the case because TEE I/O depends on being able
to operate devices against "shared"/untrusted memory for device
initialization and error recovery scenarios.

This series utilizes an existing framework named RamDiscardManager to
notify VFIO of page conversions. However, there's still one concern
related to the semantics of RamDiscardManager which is used to manage
the memory plug/unplug state. This is a little different from the memory
shared/private in our requirement. See the "Open" section below for more
details.

Background
==========
Confidential VMs have two classes of memory: shared and private memory.
Shared memory is accessible from the host/VMM while private memory is
not. Confidential VMs can decide which memory is shared/private and
convert memory between shared/private at runtime.

"guest_memfd" is a new kind of fd whose primary goal is to serve guest
private memory. The key differences between guest_memfd and normal memfd
are that guest_memfd is spawned by a KVM ioctl, bound to its owner VM and
cannot be mapped, read or written by userspace.

In QEMU's implementation, shared memory is allocated with normal methods
(e.g. mmap or fallocate) while private memory is allocated from
guest_memfd. When a VM performs memory conversions, QEMU frees pages via
madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
allocates new pages from the other side.

Problem
=======
Device assignment in QEMU is implemented via VFIO system. In the normal
VM, VM memory is pinned at the beginning of time by VFIO. In the
confidential VM, the VM can convert memory and when that happens
nothing currently tells VFIO that its mappings are stale. This means
that page conversion leaks memory and leaves stale IOMMU mappings. For
example, sequence like the following can result in stale IOMMU mappings:

1. allocate shared page
2. convert page shared->private
3. discard shared page
4. convert page private->shared
5. allocate shared page
6. issue DMA operations against that shared page

After step 3, VFIO is still pinning the page. However, DMA operations in
step 6 will hit the old mapping that was allocated in step 1, which
causes the device to access the invalid data.

Currently, the commit 852f0048f3 ("RAMBlock: make guest_memfd require
uncoordinated discard") has blocked the device assignment with
guest_memfd to avoid this problem.

Solution
========
The key to enable shared device assignment is to solve the stale IOMMU
mappings problem.

Given the constraints and assumptions here is a solution that satisfied
the use cases. RamDiscardManager, an existing interface currently
utilized by virtio-mem, offers a means to modify IOMMU mappings in
accordance with VM page assignment. Page conversion is similar to
hot-removing a page in one mode and adding it back in the other.

This series implements a RamDiscardManager for confidential VMs and
utilizes its infrastructure to notify VFIO of page conversions.

Another possible attempt [2] was to not discard shared pages in step 3
above. This was an incomplete band-aid because guests would consume
twice the memory since shared pages wouldn't be freed even after they
were converted to private.

Open
====
Implementing a RamDiscardManager to notify VFIO of page conversions
causes changes in semantics: private memory is treated as discarded (or
hot-removed) memory. This isn't aligned with the expectation of current
RamDiscardManager users (e.g. VFIO or live migration) who really
expect that discarded memory is hot-removed and thus can be skipped when
the users are processing guest memory. Treating private memory as
discarded won't work in future if VFIO or live migration needs to handle
private memory. e.g. VFIO may need to map private memory to support
Trusted IO and live migration for confidential VMs need to migrate
private memory.

There are two possible ways to mitigate the semantics changes.
1. Develop a new mechanism to notify the page conversions between
private and shared. For example, utilize the notifier_list in QEMU. VFIO
registers its own handler and gets notified upon page conversions. This
is a clean approach which only touches the notifier workflow. A
challenge is that for device hotplug, existing shared memory should be
mapped in IOMMU. This will need additional changes.

2. Extend the existing RamDiscardManager interface to manage not only
the discarded/populated status of guest memory but also the
shared/private status. RamDiscardManager users like VFIO will be
notified with one more argument indicating what change is happening and
can take action accordingly. It also has challenges e.g. QEMU allows
only one RamDiscardManager, how to support virtio-mem for confidential
VMs would be a problem. And some APIs like .is_populated() exposed by
RamDiscardManager are meaningless to shared/private memory. So they may
need some adjustments.

Testing
=======
This patch series is tested based on the internal TDX KVM/QEMU tree.

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
[1] https://lore.kernel.org/all/d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com/
[2] https://lore.kernel.org/all/20240320083945.991426-20-michael.roth@amd.com/

Chenyi Qiang (6):
  guest_memfd: Introduce an object to manage the guest-memfd with
    RamDiscardManager
  guest_memfd: Introduce a helper to notify the shared/private state
    change
  KVM: Notify the state change via RamDiscardManager helper during
    shared/private conversion
  memory: Register the RamDiscardManager instance upon guest_memfd
    creation
  guest-memfd: Default to discarded (private) in guest_memfd_manager
  RAMBlock: make guest_memfd require coordinate discard

 accel/kvm/kvm-all.c                  |   7 +
 include/sysemu/guest-memfd-manager.h |  49 +++
 system/guest-memfd-manager.c         | 425 +++++++++++++++++++++++++++
 system/meson.build                   |   1 +
 system/physmem.c                     |  11 +-
 5 files changed, 492 insertions(+), 1 deletion(-)
 create mode 100644 include/sysemu/guest-memfd-manager.h
 create mode 100644 system/guest-memfd-manager.c


base-commit: 900536d3e97aed7fdd9cb4dadd3bf7023360e819
-- 
2.43.5


