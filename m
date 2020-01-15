Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE5713B861
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 04:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAODvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 22:51:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:3148 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbgAODvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 22:51:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 19:51:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,321,1574150400"; 
   d="scan'208";a="213570974"
Received: from unknown (HELO joy-OptiPlex-7040.sh.intel.com) ([10.239.13.9])
  by orsmga007.jf.intel.com with ESMTP; 14 Jan 2020 19:51:18 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, zhenyuw@linux.intel.com
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/2] use vfio_dma_rw to read/write IOVAs from CPU side
Date:   Tue, 14 Jan 2020 22:41:32 -0500
Message-Id: <20200115034132.2753-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is better for a device model to use IOVAs to read/write memory.
And because the rw operations come from CPUs, it is not necessary to call
vfio_pin_pages() to pin those pages.

patch 1 introduces interface vfio_dma_rw in vfio to read/write IOVAs
without pinning user space pages.

patch 2 let gvt switch from kvm side rw interface to vfio_dma_rw.

v2 changelog:
- rename vfio_iova_rw to vfio_dma_rw, vfio iommu driver ops .iova_rw
to .dma_rw. (Alex).
- change iova and len from unsigned long to dma_addr_t and size_t,
respectively. (Alex)
- fix possible overflow in dma->vaddr + iova - dma->iova + offset (Alex)
- split DMAs from on page boundary to on max available size to eliminate
  redundant searching of vfio_dma and switching mm. (Alex)
- add a check for IOMMU_WRITE permission.

Yan Zhao (2):
  vfio: introduce vfio_dma_rw to read/write a range of IOVAs
  drm/i915/gvt: subsitute kvm_read/write_guest with vfio_dma_rw

 drivers/gpu/drm/i915/gvt/kvmgt.c | 26 +++--------
 drivers/vfio/vfio.c              | 45 +++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c  | 76 ++++++++++++++++++++++++++++++++
 include/linux/vfio.h             |  5 +++
 4 files changed, 133 insertions(+), 19 deletions(-)

-- 
2.17.1

