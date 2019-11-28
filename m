Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1563210C255
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 03:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfK1C36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 21:29:58 -0500
Received: from mga18.intel.com ([134.134.136.126]:17935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfK1C35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 21:29:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 18:29:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="221176106"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 27 Nov 2019 18:29:54 -0800
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
Subject: [PATCH v2 0/8] Use 1st-level for DMA remapping
Date:   Thu, 28 Nov 2019 10:25:42 +0800
Message-Id: <20191128022550.9832-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel VT-d in scalable mode supports two types of page talbes
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
support is now implemented in a shadow page manner. The device
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

This patch set includes two parts. The former part implements the
per-domain page table abstraction, which makes the page table
difference transparent to various map/unmap APIs. The later part
applies the first level page table for IOVA translation unless the
DOMAIN_ATTR_NESTING domain attribution has been set, which indicates
nested mode in use.

Based-on-idea-by: Ashok Raj <ashok.raj@intel.com>
Based-on-idea-by: Kevin Tian <kevin.tian@intel.com>
Based-on-idea-by: Liu Yi L <yi.l.liu@intel.com>
Based-on-idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Based-on-idea-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Based-on-idea-by: Lu Baolu <baolu.lu@linux.intel.com>

Change log:

 v1->v2
 - The first series was posted here
   https://lkml.org/lkml/2019/9/23/297
 - Use per domain page table ops to handle different page tables.
 - Use first level for DMA remapping by default on both bare metal
   and vm guest.
 - Code refine according to code review comments for v1.

Lu Baolu (8):
  iommu/vt-d: Add per domain page table ops
  iommu/vt-d: Move domain_flush_cache helper into header
  iommu/vt-d: Implement second level page table ops
  iommu/vt-d: Apply per domain second level page table ops
  iommu/vt-d: Add first level page table interfaces
  iommu/vt-d: Implement first level page table ops
  iommu/vt-d: Identify domains using first level page table
  iommu/vt-d: Add set domain DOMAIN_ATTR_NESTING attr

 drivers/iommu/Makefile             |   2 +-
 drivers/iommu/intel-iommu.c        | 412 +++++++++++++++++++++++------
 drivers/iommu/intel-pgtable.c      | 376 ++++++++++++++++++++++++++
 include/linux/intel-iommu.h        |  64 ++++-
 include/trace/events/intel_iommu.h |  60 +++++
 5 files changed, 837 insertions(+), 77 deletions(-)
 create mode 100644 drivers/iommu/intel-pgtable.c

-- 
2.17.1

