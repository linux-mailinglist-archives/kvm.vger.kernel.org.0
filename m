Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5651259D6
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 04:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfLSDRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 22:17:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:29385 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfLSDRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 22:17:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 19:17:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222160398"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 19:17:30 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 0/7] Use 1st-level for IOVA translation
Date:   Thu, 19 Dec 2019 11:16:27 +0800
Message-Id: <20191219031634.15168-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-d in scalable mode supports two types of page tables
for DMA translation: the first level page table and the second
level page table. The first level page table uses the same
format as the CPU page table, while the second level page table
keeps compatible with previous formats. The software is able
to choose any one of them for DMA remapping according to the use
case.

This patchset aims to move IOVA (I/O Virtual Address) translation
to 1st-level page table in scalable mode. This will simplify vIOMMU
(IOMMU simulated by VM hypervisor) design by using the two-stage
translation, a.k.a. nested mode translation.

As Intel VT-d architecture offers caching mode, guest IOVA (GIOVA)
support is currently implemented in a shadow page manner. The device
simulation software, like QEMU, has to figure out GIOVA->GPA mappings
and write them to a shadowed page table, which will be used by the
physical IOMMU. Each time when mappings are created or destroyed in
vIOMMU, the simulation software has to intervene. Hence, the changes
on GIOVA->GPA could be shadowed to host.


     .-----------.
     |  vIOMMU   |
     |-----------|                 .--------------------.
     |           |IOTLB flush trap |        QEMU        |
     .-----------. (map/unmap)     |--------------------|
     |GIOVA->GPA |---------------->|    .------------.  |
     '-----------'                 |    | GIOVA->HPA |  |
     |           |                 |    '------------'  |
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
      |GIOVA->HPA |
      '-----------'
      |           |
      '-----------'

In VT-d 3.0, scalable mode is introduced, which offers two-level
translation page tables and nested translation mode. Regards to
GIOVA support, it can be simplified by 1) moving the GIOVA support
over 1st-level page table to store GIOVA->GPA mapping in vIOMMU,
2) binding vIOMMU 1st level page table to the pIOMMU, 3) using pIOMMU
second level for GPA->HPA translation, and 4) enable nested (a.k.a.
dual-stage) translation in host. Compared with current shadow GIOVA
support, the new approach makes the vIOMMU design simpler and more
efficient as we only need to flush the pIOMMU IOTLB and possible
device-IOTLB when an IOVA mapping in vIOMMU is torn down.

     .-----------.
     |  vIOMMU   |
     |-----------|                 .-----------.
     |           |IOTLB flush trap |   QEMU    |
     .-----------.    (unmap)      |-----------|
     |GIOVA->GPA |---------------->|           |
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
     |GIOVA->GPA |<---First level
     '-----------'
     | GPA->HPA  |<---Scond level
     '-----------'
     '-----------'

This patch applies the first level page table for IOVA translation
unless the DOMAIN_ATTR_NESTING domain attribution has been set.
Setting of this attribution means the second level will be used to
map gPA (guest physical address) to hPA (host physical address), and
the mappings between gVA (guest virtual address) and gPA will be
maintained by the guest with the page table address binding to host's
first level.

Based-on-idea-by: Ashok Raj <ashok.raj@intel.com>
Based-on-idea-by: Kevin Tian <kevin.tian@intel.com>
Based-on-idea-by: Liu Yi L <yi.l.liu@intel.com>
Based-on-idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Based-on-idea-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Based-on-idea-by: Lu Baolu <baolu.lu@linux.intel.com>

Change log:

v3->v4:
 - The previous version was posted here
   https://lkml.org/lkml/2019/12/10/2126
 - Set Execute Disable (bit 63) in first level table entries.
 - Enhance pasid-based iotlb invalidation for both default domain
   and auxiliary domain.
 - Add debugfs file to expose page table internals.

v2->v3:
 - The previous version was posted here
   https://lkml.org/lkml/2019/11/27/1831
 - Accept Jacob's suggestion on merging two page tables.

 v1->v2
 - The first series was posted here
   https://lkml.org/lkml/2019/9/23/297
 - Use per domain page table ops to handle different page tables.
 - Use first level for DMA remapping by default on both bare metal
   and vm guest.
 - Code refine according to code review comments for v1.

Lu Baolu (7):
  iommu/vt-d: Identify domains using first level page table
  iommu/vt-d: Add set domain DOMAIN_ATTR_NESTING attr
  iommu/vt-d: Add PASID_FLAG_FL5LP for first-level pasid setup
  iommu/vt-d: Setup pasid entries for iova over first level
  iommu/vt-d: Flush PASID-based iotlb for iova over first level
  iommu/vt-d: Use iova over first level
  iommu/vt-d: debugfs: Add support to show page table internals

 drivers/iommu/dmar.c                |  41 ++++++
 drivers/iommu/intel-iommu-debugfs.c |  75 +++++++++++
 drivers/iommu/intel-iommu.c         | 201 +++++++++++++++++++++++++---
 drivers/iommu/intel-pasid.c         |   7 +-
 drivers/iommu/intel-pasid.h         |   6 +
 drivers/iommu/intel-svm.c           |   8 +-
 include/linux/intel-iommu.h         |  20 ++-
 7 files changed, 326 insertions(+), 32 deletions(-)

-- 
2.17.1

