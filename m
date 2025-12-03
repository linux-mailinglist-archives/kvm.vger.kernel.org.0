Return-Path: <kvm+bounces-65241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D0DCA183D
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 21:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C0A5A300ACD6
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 20:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BA42FB62A;
	Wed,  3 Dec 2025 20:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="JBceXR7n";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L45FbkyR"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B3398FA5;
	Wed,  3 Dec 2025 20:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764792285; cv=none; b=P43PdOMsH+GIWVOGhc0d4OAOCTDGr5FoDGzXoFX3NBiLyW6tgxIQH+S+6k607q2JNeu5wtajQixwZDE8fPlRGI9OUQGSwVC8yha2EgS5hnAoqrQTVtAEmmTfJZ0EuF7eFIsAwaWE4DvI2LxBdDk7P+slSGicBnwVmot75XlruQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764792285; c=relaxed/simple;
	bh=41huTewt9XRsfgxUCRpC6WM5ALcCHuwX5dFIqXqd1tk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Q3kSkSd1g9ebfzX2jsH4kOlncdygi1f3tbPK/Uv4XcdNKmjPV3vymvpTmht+z0Y/qqAE5Ep9pnNtFLZcQ7y20CJU3M/jGvEnKu4bWGJX5Sc4pAQfMHxzJ5NiyHgrigJl6Bc09fmHRjSNzgrmfvQrgG9CLwKZRVHJ6QSQzowj3Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=JBceXR7n; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L45FbkyR; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6FCB77A011A;
	Wed,  3 Dec 2025 15:04:40 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 03 Dec 2025 15:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm3; t=1764792280; x=1764878680; bh=Js
	mMkqwdT7iFZYAP+gAyPeskb3savfq9TYw5qhZ43ps=; b=JBceXR7nY+94rIiCCa
	lL2Smw7fXA4KChuZZZk+eyAJyljp0aeciG2kIMtJhpsXQsF6IryepPocBQ4cS9vv
	sbWjgPeTLId9Q8ZN4WYTNTQtVi75sLPgt1ZTmd6zO2tmwLAChjWqoSkp9ctHBD05
	YfXwYFSQxxwdvTZxbmJ67bcD2EbzNAm1ifHrYj+vOqxSIrxMe4JsummKJJ2xaBZS
	bCK4WUiUzPbaKv7CCsOUh0165fMJz0kaEPnr64DM6aTZNGgF0eN2KPQNyaxAfvA0
	LFZngv4EKbwnf9DkPS1Sb9Ls/GpRtJKkwH2FxJ3fOqUzefuw1fvRnmPZyDzz0eD8
	YGrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1764792280; x=1764878680; bh=JsmMkqwdT7iFZYAP+gAyPeskb3sa
	vfq9TYw5qhZ43ps=; b=L45FbkyRHFrexs/2AGbi5N7IxipXwqV7oI8w224MOIIl
	v9FL0fmohwZcVrA/ijEteI8f08BM1/Jk+liZAXF7NKAZ0+vomqsbzlp9X0kQengo
	IMg2BskXp18Ljo25vw9zgDCSpO4CIdnQ1fh1vGvdow7RLkOOU1Rz/YmPBL5ohKVg
	ZuIOXEwvbfjTqXFpDRfkxZpVirha4yi2CFGyREB/q9Gs0GeuYJls6vNm5X91GtPp
	SzULSO2B5BVavBZ7CHvq1Xpt6tl9C1fQAg7dG9+v8xVJkFL2bZNBmOS4v4uZm9MI
	KbtVza8MCKpHCdL0ECFRhfUrytegljQG/czdIlPNHg==
X-ME-Sender: <xms:15cwaV5DWOpLzkAho8AQqsROUnURBxWnF7aGyPI6DbbvN_Mk6xvsyQ>
    <xme:15cwaTmRckF_gasllqD8TF9kmrtArAVkW3-OV4CpoOvgLsx0XP2_o2_sq0I2HPn4R
    uauADbmWuB4ISIiI3qEFVSBqp1g8wC3ns4ZHpZusCPl8H6QjyVZlA>
X-ME-Received: <xmr:15cwaarfgWK3GosOsw6zOZQu_XQcgVs2AexkWk1IqVyVscAK5Spbte9P>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucghihhllhhi
    rghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrthhtvghrnh
    epjeeiledthfdvtedvuefhgfffteeftedtfedthfethedvtdeuvdfgveetgfdtffdunecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigs
    ohhtrdhorhhgpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehj
    ghhgsehnvhhiughirgdrtghomhdprhgtphhtthhopehlvghonheskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtphhtthhopegu
    mhgrthhlrggtkhesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:15cwaStXRI__zMtX9NXJoN43JUs2qHyHr54Glq6GN3iLz4ZWogt_tw>
    <xmx:2JcwafEa6H-jN8e9y97pnqToyvYfkHlpHS1j7gAWMLGBkE2ncjlk4A>
    <xmx:2Jcwabb5nGBpwv5FMZ6WPmEiQUdy-PBsPwny63S2NJV9erRx9ssf5A>
    <xmx:2JcwaXWUhMYczIucXxjvnOC-Vv26wG3YDr3xvIcj_qxvWdKakss7_Q>
    <xmx:2JcwaSecnGjU12LFSoA5RIyjd2_cJMOi8ggl4gmEiGHYJkel2zIZRvwl>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Dec 2025 15:04:39 -0500 (EST)
Date: Wed, 3 Dec 2025 13:04:35 -0700
From: Alex Williamson <alex@shazbot.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jason Gunthorpe
 <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Ankit Agrawal
 <ankita@nvidia.com>, David Matlack <dmatlack@google.com>
Subject: [GIT PULL] VFIO updates for v6.19-rc1
Message-ID: <20251203130435.4ab658aa.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

There's been lots of work across p2pdma, dma-buf, drm, and mm this cycle
which results in an unusual number of conflicts across the tree.

There's a shared tag here with the IOMMUFD, which Jason Gunthorpe
expands on in his pull request that completes some longstanding work to
enable vfio MMIO regions to be shared via dma-buf and exposed through
IOMMUFD for p2p use cases.  With this we can start moving users in
earnest over to IOMMUFD as the primary IOMMU backend for vfio.

The DMA work as part of this is currently showing a conflict against the
dma-mapping-6.18-2025-11-27 tag that's already been merged.  Stephen
noted[1] this conflict in linux-next with the following resolution:

--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@@ -479,9 -479,8 +479,9 @@@ int dma_direct_map_sg(struct device *de
                        }
                        break;
                case PCI_P2PDMA_MAP_BUS_ADDR:
-                       sg->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
-                                       sg_phys(sg));
+                       sg->dma_address = pci_p2pdma_bus_addr_map(
+                               p2pdma_state.mem, sg_phys(sg));
 +                      sg_dma_len(sg) = sg->length;
                        sg_dma_mark_bus_address(sg);
                        continue;
                default:

This conflict exists in the shared tag with IOMMUFD, so we'll hit it in
one or the other merges.

Also given the shared dma-buf enablement, IOMMUFD makes some adjacent
header changes that Stephen identified[2], including new lines from both.

I don't yet see pull requests from Andrew, but Stephen also reported
selftest conflicts in mm-nonmm-stable versus the vfio specific work
done here and some competing poison handling registration versus mmap
fault handling changes in the nvgrace-gpu driver relative to mm-stable.

The selftest conflicts are numerous but trivial[3][4][5][6],
essentially context collisions.

The nvgrace-gpu conflict[7] vs mm-stable is going to require more work
than just the build fix resolution provided there, but the scope of the
affected device is so limited that we'd rather address it more
completely in the -rc cycle.  Adding the missing variable with
initialization is fine for now.

Finally, the i915 vGPU driver was updating their ioctl handling at the
same time we were overhauling region-info handling in the core,
resulting in one last conflict.  Stephen reported and provided a
resolution[8].  The conflicting commit is included in Dave's drm pull
from 12/3.

If there's any trouble, please let me know.  Thanks,

Alex

[1]https://lore.kernel.org/all/20251127121342.73a2fa9f@canb.auug.org.au/
[2]https://lore.kernel.org/all/20251201124340.335d7144@canb.auug.org.au/
[3]https://lore.kernel.org/all/20251201101046.009b0919@canb.auug.org.au/
[4]https://lore.kernel.org/all/20251201101312.4dfd2b19@canb.auug.org.au/
[5]https://lore.kernel.org/all/20251201101549.5792d6df@canb.auug.org.au/
[6]https://lore.kernel.org/all/20251201103154.32226085@canb.auug.org.au/
[7]https://lore.kernel.org/all/20251201114439.4fab07f6@canb.auug.org.au/
[8]https://lore.kernel.org/all/20251125000151.23372279@canb.auug.org.au/

The following changes since commit d323ad739666761646048fca587734f4ae64f2c8:

  vfio: selftests: replace iova=vaddr with allocated iovas (2025-11-12 08:04:42 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.19-rc1

for you to fetch changes up to d721f52e31553a848e0e9947ca15a49c5674aef3:

  vfio: selftests: Add vfio_pci_device_init_perf_test (2025-11-28 10:58:07 -0700)

----------------------------------------------------------------
VFIO updates for v6.19-rc1

 - Move libvfio selftest artifacts in preparation of more tightly
   coupled integration with KVM selftests. (David Matlack)

 - Fix comment typo in mtty driver. (Chu Guangqing)

 - Support for new hardware revision in the hisi_acc vfio-pci variant
   driver where the migration registers can now be accessed via the PF.
   When enabled for this support, the full BAR can be exposed to the
   user. (Longfang Liu)

 - Fix vfio cdev support for VF token passing, using the correct size
   for the kernel structure, thereby actually allowing userspace to
   provide a non-zero UUID token.  Also set the match token callback for
   the hisi_acc, fixing VF token support for this this vfio-pci variant
   driver. (Raghavendra Rao Ananta)

 - Introduce internal callbacks on vfio devices to simplify and
   consolidate duplicate code for generating VFIO_DEVICE_GET_REGION_INFO
   data, removing various ioctl intercepts with a more structured
   solution. (Jason Gunthorpe)

 - Introduce dma-buf support for vfio-pci devices, allowing MMIO regions
   to be exposed through dma-buf objects with lifecycle managed through
   move operations.  This enables low-level interactions such as a
   vfio-pci based SPDK drivers interacting directly with dma-buf capable
   RDMA devices to enable peer-to-peer operations.  IOMMUFD is also now
   able to build upon this support to fill a long standing feature gap
   versus the legacy vfio type1 IOMMU backend with an implementation of
   P2P support for VM use cases that better manages the lifecycle of the
   P2P mapping. (Leon Romanovsky, Jason Gunthorpe, Vivek Kasireddy)

 - Convert eventfd triggering for error and request signals to use RCU
   mechanisms in order to avoid a 3-way lockdep reported deadlock issue.
   (Alex Williamson)

 - Fix a 32-bit overflow introduced via dma-buf support manifesting with
   large DMA buffers. (Alex Mastro)

 - Convert nvgrace-gpu vfio-pci variant driver to insert mappings on
   fault rather than at mmap time.  This conversion serves both to make
   use of huge PFNMAPs but also to both avoid corrected RAS events
   during reset by now being subject to vfio-pci-core's use of
   unmap_mapping_range(), and to enable a device readiness test after
   reset. (Ankit Agrawal)

 - Refactoring of vfio selftests to support multi-device tests and split
   code to provide better separation between IOMMU and device objects.
   This work also enables a new test suite addition to measure parallel
   device initialization latency. (David Matlack)

----------------------------------------------------------------
Alex Mastro (1):
      dma-buf: fix integer overflow in fill_sg_entry() for buffers >= 8GiB

Alex Williamson (3):
      Merge tag 'vfio-v6.19-dma-buf-v9+' into v6.19/vfio/next
      vfio/pci: Use RCU for error/request triggers to avoid circular locking
      Merge tag 'vfio-v6.18-rc6' into v6.19/vfio/next

Ankit Agrawal (6):
      vfio: refactor vfio_pci_mmap_huge_fault function
      vfio/nvgrace-gpu: Add support for huge pfnmap
      vfio: use vfio_pci_core_setup_barmap to map bar in mmap
      vfio/nvgrace-gpu: split the code to wait for GPU ready
      vfio/nvgrace-gpu: Inform devmem unmapped after reset
      vfio/nvgrace-gpu: wait for the GPU mem to be ready

Chu Guangqing (1):
      vfio/mtty: Fix spelling typo in samples/vfio-mdev

David Matlack (19):
      vfio: selftests: Store libvfio build outputs in $(OUTPUT)/libvfio
      vfio: selftests: Move run.sh into scripts directory
      vfio: selftests: Split run.sh into separate scripts
      vfio: selftests: Allow passing multiple BDFs on the command line
      vfio: selftests: Rename struct vfio_iommu_mode to iommu_mode
      vfio: selftests: Introduce struct iommu
      vfio: selftests: Support multiple devices in the same container/iommufd
      vfio: selftests: Eliminate overly chatty logging
      vfio: selftests: Prefix logs with device BDF where relevant
      vfio: selftests: Upgrade driver logging to dev_err()
      vfio: selftests: Rename struct vfio_dma_region to dma_region
      vfio: selftests: Move IOMMU library code into iommu.c
      vfio: selftests: Move IOVA allocator into iova_allocator.c
      vfio: selftests: Stop passing device for IOMMU operations
      vfio: selftests: Rename vfio_util.h to libvfio.h
      vfio: selftests: Move vfio_selftests_*() helpers into libvfio.c
      vfio: selftests: Split libvfio.h into separate header files
      vfio: selftests: Eliminate INVALID_IOVA
      vfio: selftests: Add vfio_pci_device_init_perf_test

Jason Gunthorpe (24):
      vfio: Provide a get_region_info op
      vfio/hisi: Convert to the get_region_info op
      vfio/virtio: Convert to the get_region_info op
      vfio/nvgrace: Convert to the get_region_info op
      vfio/pci: Fill in the missing get_region_info ops
      vfio/mtty: Provide a get_region_info op
      vfio/mdpy: Provide a get_region_info op
      vfio/mbochs: Provide a get_region_info op
      vfio/platform: Provide a get_region_info op
      vfio/fsl: Provide a get_region_info op
      vfio/cdx: Provide a get_region_info op
      vfio/ccw: Provide a get_region_info op
      vfio/gvt: Provide a get_region_info op
      vfio: Require drivers to implement get_region_info
      vfio: Add get_region_info_caps op
      vfio/mbochs: Convert mbochs to use vfio_info_add_capability()
      vfio/gvt: Convert to get_region_info_caps
      vfio/ccw: Convert to get_region_info_caps
      vfio/pci: Convert all PCI drivers to get_region_info_caps
      vfio/platform: Convert to get_region_info_caps
      vfio: Move the remaining drivers to get_region_info_caps
      vfio: Remove the get_region_info op
      PCI/P2PDMA: Document DMABUF model
      vfio/nvgrace: Support get_dmabuf_phys

Leon Romanovsky (7):
      PCI/P2PDMA: Separate the mmap() support from the core logic
      PCI/P2PDMA: Simplify bus address mapping API
      PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
      PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
      dma-buf: provide phys_vec to scatter-gather mapping routine
      vfio/pci: Enable peer-to-peer DMA transactions by default
      vfio/pci: Add dma-buf export support for MMIO regions

Longfang Liu (2):
      crypto: hisilicon - qm updates BAR configuration
      hisi_acc_vfio_pci: adapt to new migration configuration

Raghavendra Rao Ananta (2):
      vfio: Fix ksize arg while copying user struct in vfio_df_ioctl_bind_iommufd()
      hisi_acc_vfio_pci: Add .match_token_uuid callback in hisi_acc_vfio_pci_migrn_ops

Vivek Kasireddy (2):
      vfio: Export vfio device get and put registration helpers
      vfio/pci: Share the core device pointer while invoking feature functions

 Documentation/driver-api/pci/p2pdma.rst            |  97 +++-
 block/blk-mq-dma.c                                 |   2 +-
 drivers/crypto/hisilicon/qm.c                      |  27 +
 drivers/dma-buf/Makefile                           |   2 +-
 drivers/dma-buf/dma-buf-mapping.c                  | 248 +++++++++
 drivers/gpu/drm/i915/gvt/kvmgt.c                   | 272 +++++-----
 drivers/iommu/dma-iommu.c                          |   4 +-
 drivers/pci/p2pdma.c                               | 186 +++++--
 drivers/s390/cio/vfio_ccw_ops.c                    |  47 +-
 drivers/vfio/cdx/main.c                            |  29 +-
 drivers/vfio/device_cdev.c                         |   2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |  43 +-
 drivers/vfio/pci/Kconfig                           |   3 +
 drivers/vfio/pci/Makefile                          |   1 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     | 171 ++++---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |  23 +-
 drivers/vfio/pci/mlx5/main.c                       |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c                | 342 +++++++++----
 drivers/vfio/pci/pds/vfio_dev.c                    |   1 +
 drivers/vfio/pci/qat/main.c                        |   1 +
 drivers/vfio/pci/vfio_pci.c                        |   6 +
 drivers/vfio/pci/vfio_pci_config.c                 |  23 +-
 drivers/vfio/pci/vfio_pci_core.c                   | 300 +++++------
 drivers/vfio/pci/vfio_pci_dmabuf.c                 | 316 ++++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c                  |  52 +-
 drivers/vfio/pci/vfio_pci_priv.h                   |  28 +-
 drivers/vfio/pci/virtio/common.h                   |   5 +-
 drivers/vfio/pci/virtio/legacy_io.c                |  38 +-
 drivers/vfio/pci/virtio/main.c                     |   5 +-
 drivers/vfio/platform/vfio_amba.c                  |   1 +
 drivers/vfio/platform/vfio_platform.c              |   1 +
 drivers/vfio/platform/vfio_platform_common.c       |  40 +-
 drivers/vfio/platform/vfio_platform_private.h      |   3 +
 drivers/vfio/vfio_main.c                           |  51 ++
 include/linux/dma-buf-mapping.h                    |  17 +
 include/linux/dma-buf.h                            |  11 +
 include/linux/hisi_acc_qm.h                        |   3 +
 include/linux/pci-p2pdma.h                         | 120 +++--
 include/linux/vfio.h                               |   6 +
 include/linux/vfio_pci_core.h                      |  69 ++-
 include/uapi/linux/vfio.h                          |  28 ++
 kernel/dma/direct.c                                |   4 +-
 mm/hmm.c                                           |   2 +-
 samples/vfio-mdev/mbochs.c                         |  71 +--
 samples/vfio-mdev/mdpy.c                           |  34 +-
 samples/vfio-mdev/mtty.c                           |  35 +-
 tools/testing/selftests/vfio/Makefile              |  10 +-
 tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c |  36 +-
 .../testing/selftests/vfio/lib/drivers/ioat/ioat.c |  18 +-
 tools/testing/selftests/vfio/lib/include/libvfio.h |  26 +
 .../selftests/vfio/lib/include/libvfio/assert.h    |  54 ++
 .../selftests/vfio/lib/include/libvfio/iommu.h     |  76 +++
 .../vfio/lib/include/libvfio/iova_allocator.h      |  23 +
 .../vfio/lib/include/libvfio/vfio_pci_device.h     | 125 +++++
 .../vfio/lib/include/libvfio/vfio_pci_driver.h     |  97 ++++
 .../testing/selftests/vfio/lib/include/vfio_util.h | 331 ------------
 tools/testing/selftests/vfio/lib/iommu.c           | 465 +++++++++++++++++
 tools/testing/selftests/vfio/lib/iova_allocator.c  |  94 ++++
 tools/testing/selftests/vfio/lib/libvfio.c         |  78 +++
 tools/testing/selftests/vfio/lib/libvfio.mk        |  23 +-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 556 +--------------------
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c |  16 +-
 tools/testing/selftests/vfio/run.sh                | 109 ----
 tools/testing/selftests/vfio/scripts/cleanup.sh    |  41 ++
 tools/testing/selftests/vfio/scripts/lib.sh        |  42 ++
 tools/testing/selftests/vfio/scripts/run.sh        |  16 +
 tools/testing/selftests/vfio/scripts/setup.sh      |  48 ++
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |  46 +-
 .../selftests/vfio/vfio_iommufd_setup_test.c       |   2 +-
 .../vfio/vfio_pci_device_init_perf_test.c          | 168 +++++++
 .../testing/selftests/vfio/vfio_pci_device_test.c  |  12 +-
 .../testing/selftests/vfio/vfio_pci_driver_test.c  |  51 +-
 72 files changed, 3430 insertions(+), 1904 deletions(-)
 create mode 100644 drivers/dma-buf/dma-buf-mapping.c
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c
 create mode 100644 include/linux/dma-buf-mapping.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/assert.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/iova_allocator.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
 delete mode 100644 tools/testing/selftests/vfio/lib/include/vfio_util.h
 create mode 100644 tools/testing/selftests/vfio/lib/iommu.c
 create mode 100644 tools/testing/selftests/vfio/lib/iova_allocator.c
 create mode 100644 tools/testing/selftests/vfio/lib/libvfio.c
 delete mode 100755 tools/testing/selftests/vfio/run.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/cleanup.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/lib.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/run.sh
 create mode 100755 tools/testing/selftests/vfio/scripts/setup.sh
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_device_init_perf_test.c

