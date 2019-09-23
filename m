Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D4ABB3B8
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 14:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbfIWM1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 08:27:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:4334 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbfIWM1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 08:27:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 05:27:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,539,1559545200"; 
   d="scan'208";a="203116655"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 05:27:16 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
Date:   Mon, 23 Sep 2019 20:24:50 +0800
Message-Id: <20190923122454.9888-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset aims to move IOVA (I/O Virtual Address) translation
to 1st-level page table under scalable mode. The major purpose of
this effort is to make guest IOVA support more efficient.

As Intel VT-d architecture offers caching-mode, guest IOVA (GIOVA)
support is now implemented in a shadow page manner. The device
simulation software, like QEMU, has to figure out GIOVA->GPA mapping
and writes to a shadowed page table, which will be used by pIOMMU.
Each time when mappings are created or destroyed in vIOMMU, the
simulation software will intervene. The change on GIOVA->GPA will be
shadowed to host, and the pIOMMU will be updated via VFIO/IOMMU
interfaces.


     .-----------.
     |  vIOMMU   |
     |-----------|                 .--------------------.
     |           |IOTLB flush trap |        QEMU        |
     .-----------. (map/unmap)     |--------------------|
     | GVA->GPA  |---------------->|      .----------.  |
     '-----------'                 |      | GPA->HPA |  |
     |           |                 |      '----------'  |
     '-----------'                 |                    |
                                   |                    |
                                   '--------------------'
                                                |
            <------------------------------------
            |
            v VFIO/IOMMU API
      .-----------.
      |  pIOMMU   |
      |-----------|
      |           |
      .-----------.
      | GVA->HPA  |
      '-----------'
      |           |
      '-----------'

In VT-d 3.0, scalable mode is introduced, which offers two level
translation page tables and nested translation mode. Regards to
GIOVA support, it can be simplified by 1) moving the GIOVA support
over 1st-level page table to store GIOVA->GPA mapping in vIOMMU,
2) binding vIOMMU 1st level page table to the pIOMMU, 3) using pIOMMU
second level for GPA->HPA translation, and 4) enable nested (a.k.a.
dual stage) translation in host. Compared with current shadow GIOVA
support, the new approach is more secure and software is simplified
as we only need to flush the pIOMMU IOTLB and possible device-IOTLB
when an IOVA mapping in vIOMMU is torn down.

     .-----------.
     |  vIOMMU   |
     |-----------|                 .-----------.
     |           |IOTLB flush trap |   QEMU    |
     .-----------.    (unmap)      |-----------|
     | GVA->GPA  |---------------->|           |
     '-----------'                 '-----------'
     |           |                       |
     '-----------'                       |
           <------------------------------
           |      VFIO/IOMMU          
           |  cache invalidation and  
           | guest gpd bind interfaces
           v
     .-----------.
     |  pIOMMU   |
     |-----------|
     .-----------.
     | GVA->GPA  |<---First level
     '-----------'
     | GPA->HPA  |<---Scond level
     '-----------'
     '-----------'

This patch series only aims to achieve the first goal, a.k.a using
first level translation for IOVA mappings in vIOMMU. I am sending
it out for your comments. Any comments, suggestions and concerns are
welcomed.

Based-on-idea-by: Ashok Raj <ashok.raj@intel.com>
Based-on-idea-by: Kevin Tian <kevin.tian@intel.com>
Based-on-idea-by: Liu Yi L <yi.l.liu@intel.com>
Based-on-idea-by: Lu Baolu <baolu.lu@linux.intel.com>
Based-on-idea-by: Sanjay Kumar <sanjay.k.kumar@intel.com>

Lu Baolu (4):
  iommu/vt-d: Move domain_flush_cache helper into header
  iommu/vt-d: Add first level page table interfaces
  iommu/vt-d: Map/unmap domain with mmmap/mmunmap
  iommu/vt-d: Identify domains using first level page table

 drivers/iommu/Makefile             |   2 +-
 drivers/iommu/intel-iommu.c        | 142 ++++++++++--
 drivers/iommu/intel-pgtable.c      | 342 +++++++++++++++++++++++++++++
 include/linux/intel-iommu.h        |  31 ++-
 include/trace/events/intel_iommu.h |  60 +++++
 5 files changed, 553 insertions(+), 24 deletions(-)
 create mode 100644 drivers/iommu/intel-pgtable.c

-- 
2.17.1

