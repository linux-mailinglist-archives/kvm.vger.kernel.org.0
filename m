Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D7A16A0A4
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 09:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgBXIy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 03:54:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:55741 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbgBXIxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 03:53:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 00:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,479,1574150400"; 
   d="scan'208";a="437630183"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga006.fm.intel.com with ESMTP; 24 Feb 2020 00:53:34 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, zhenyuw@linux.intel.com
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 0/7] use vfio_dma_rw to read/write IOVAs from CPU side
Date:   Mon, 24 Feb 2020 03:43:50 -0500
Message-Id: <20200224084350.31574-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is better for a device model to use IOVAs to read/write memory to
perform some sort of virtual DMA on behalf of the device.

patch 1 exports VFIO group to external user so that it can hold the group
reference until finishing using of it. It saves ~500 cycles that are spent
on VFIO group looking up, referencing and dereferencing. (this data is
measured with 1 VFIO user).

patch 2 introduces interface vfio_dma_rw().

patch 3 introduces interfaces vfio_pin_pages_from_group() and
vfio_unpin_pages_from_group() to get rid of VFIO group looking-up in
vfio_pin_pages() and vfio_unpin_pages().

patch 4-5 let kvmgt switch from calling kvm_read/write_guest() to calling
vfio_dma_rw to rw IOVAs.

patch 6 let kvmgt switch to use lighter version of vfio_pin/unpin_pages(),
i.e. vfio_pin/unpin_pages_from_group()

patch 7 enables kvmgt to read/write IOVAs of size larger than PAGE_SIZE.


Performance:

Comparison between vfio_dma_rw() and kvm_read/write_guest():

1. avergage CPU cycles of each interface measured with 1 running VM:
 --------------------------------------------------
|  rw       |          avg cycles of               |
|  size     | (vfio_dma_rw - kvm_read/write_guest) |
|---------- ---------------------------------------|
| <= 1 page |            +155 ~ +195               |        
|--------------------------------------------------|
| 5 pages   |                -530                  |
|--------------------------------------------------|
| 20 pages  |           -2005 ~ -2533              |
 --------------------------------------------------

2. average scores

base: base code before applying code in this series. use
kvm_read/write_pages() to rw IOVAs

base + this series: use vfio_dma_rw() to read IOVAs and use
vfio_pin/unpin_pages_from_group(), and kvmgt is able to rw several pages
at a time.

Scores of benchmarks running in 1 VM each:
 -----------------------------------------------------------------
|                    | glmark2 | lightsmark | openarena | heavens |
|-----------------------------------------------------------------|
|       base         |  1248   |  219.70    |  114.9    |   560   |
|-----------------------------------------------------------------|
|base + this series  |  1248   |  225.8     |   115     |   559   |
 -----------------------------------------------------------------

Sum of scores of two benchmark instances running in 2 VMs each:
 -------------------------------------------------------
|                    | glmark2 | lightsmark | openarena |
|-------------------------------------------------------|
|       base         |  812    |  211.46    |  115.3    |
|-------------------------------------------------------|
|base + this series  |  814    |  214.69    |  115.9    |
 -------------------------------------------------------


Changelogs:
v2 --> v3:
- add vfio_group_get_external_user_from_dev() to improve performance (Alex)
- add vfio_pin/unpin_pages_from_group() to avoid repeated looking up of
  VFIO group in vfio_pin/unpin_pages() (Alex)
- add a check for IOMMU_READ permission. (Alex)
- rename vfio_iommu_type1_rw_dma_nopin() to
  vfio_iommu_type1_dma_rw_chunk(). (Alex)
- in kvmgt, change "write ? vfio_dma_rw(...,true) :
  vfio_dma_rw(...,false)" to vfio_dma_rw(dev, gpa, buf, len, write)
  (Alex and Paolo)
- in kvmgt, instead of read/write context pages 1:1, combining the
  reads/writes of continuous IOVAs to take advantage of vfio_dma_rw() for
  faster crossing page boundary accesses.

v1 --> v2:
- rename vfio_iova_rw to vfio_dma_rw, vfio iommu driver ops .iova_rw
to .dma_rw. (Alex).
- change iova and len from unsigned long to dma_addr_t and size_t,
respectively. (Alex)
- fix possible overflow in dma->vaddr + iova - dma->iova + offset (Alex)
- split DMAs from on page boundary to on max available size to eliminate
  redundant searching of vfio_dma and switching mm. (Alex)
- add a check for IOMMU_WRITE permission.

 Yan Zhao (7):
  vfio: allow external user to get vfio group from device
  vfio: introduce vfio_dma_rw to read/write a range of IOVAs
  vfio: avoid inefficient lookup of VFIO group in vfio_pin/unpin_pages
  drm/i915/gvt: hold reference of VFIO group during opening of vgpu
  drm/i915/gvt: subsitute kvm_read/write_guest with vfio_dma_rw
  drm/i915/gvt: avoid unnecessary lookup in each vfio pin & unpin pages
  drm/i915/gvt: rw more pages a time for shadow context

 drivers/gpu/drm/i915/gvt/gvt.h       |   1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c     |  43 +++----
 drivers/gpu/drm/i915/gvt/scheduler.c | 101 +++++++++++-----
 drivers/vfio/vfio.c                  | 175 +++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c      |  77 ++++++++++++
 include/linux/vfio.h                 |  13 ++
 6 files changed, 358 insertions(+), 52 deletions(-)

-- 
2.17.1

