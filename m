Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3C10F16B
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfLBUOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:14:46 -0500
Received: from mga12.intel.com ([192.55.52.136]:59428 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbfLBUOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 15:14:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 12:14:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="222559928"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002.jf.intel.com with ESMTP; 02 Dec 2019 12:14:44 -0800
Date:   Mon, 2 Dec 2019 12:19:27 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 0/8] Use 1st-level for DMA remapping
Message-ID: <20191202121927.2fef85ba@jacob-builder>
In-Reply-To: <20191128022550.9832-1-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019 10:25:42 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> Intel VT-d in scalable mode supports two types of page talbes
tables
> for DMA translation: the first level page table and the second
> level page table. The first level page table uses the same
> format as the CPU page table, while the second level page table
> keeps compatible with previous formats. The software is able
> to choose any one of them for DMA remapping according to the use
> case.
> 
> This patchset aims to move IOVA (I/O Virtual Address) translation
move guest IOVA only, right?
> to 1st-level page table in scalable mode. This will simplify vIOMMU
> (IOMMU simulated by VM hypervisor) design by using the two-stage
> translation, a.k.a. nested mode translation.
> 
> As Intel VT-d architecture offers caching mode, guest IOVA (GIOVA)
> support is now implemented in a shadow page manner. The device
> simulation software, like QEMU, has to figure out GIOVA->GPA mappings
> and write them to a shadowed page table, which will be used by the
> physical IOMMU. Each time when mappings are created or destroyed in
> vIOMMU, the simulation software has to intervene. Hence, the changes
> on GIOVA->GPA could be shadowed to host.
> 
> 
>      .-----------.
>      |  vIOMMU   |
>      |-----------|                 .--------------------.
>      |           |IOTLB flush trap |        QEMU        |
>      .-----------. (map/unmap)     |--------------------|
>      |GIOVA->GPA |---------------->|    .------------.  |
>      '-----------'                 |    | GIOVA->HPA |  |
>      |           |                 |    '------------'  |
>      '-----------'                 |                    |
>                                    |                    |
>                                    '--------------------'
>                                                 |
>             <------------------------------------
>             |
>             v VFIO/IOMMU API
>       .-----------.
>       |  pIOMMU   |
>       |-----------|
>       |           |
>       .-----------.
>       |GIOVA->HPA |
>       '-----------'
>       |           |
>       '-----------'
> 
> In VT-d 3.0, scalable mode is introduced, which offers two-level
> translation page tables and nested translation mode. Regards to
> GIOVA support, it can be simplified by 1) moving the GIOVA support
> over 1st-level page table to store GIOVA->GPA mapping in vIOMMU,
> 2) binding vIOMMU 1st level page table to the pIOMMU, 3) using pIOMMU
> second level for GPA->HPA translation, and 4) enable nested (a.k.a.
> dual-stage) translation in host. Compared with current shadow GIOVA
> support, the new approach makes the vIOMMU design simpler and more
> efficient as we only need to flush the pIOMMU IOTLB and possible
> device-IOTLB when an IOVA mapping in vIOMMU is torn down.
> 
>      .-----------.
>      |  vIOMMU   |
>      |-----------|                 .-----------.
>      |           |IOTLB flush trap |   QEMU    |
>      .-----------.    (unmap)      |-----------|
>      |GIOVA->GPA |---------------->|           |
>      '-----------'                 '-----------'
>      |           |                       |
>      '-----------'                       |
>            <------------------------------
>            |      VFIO/IOMMU          
>            |  cache invalidation and  
>            | guest gpd bind interfaces
>            v
>      .-----------.
>      |  pIOMMU   |
>      |-----------|
>      .-----------.
>      |GIOVA->GPA |<---First level
>      '-----------'
>      | GPA->HPA  |<---Scond level
>      '-----------'
>      '-----------'
> 
> This patch set includes two parts. The former part implements the
> per-domain page table abstraction, which makes the page table
> difference transparent to various map/unmap APIs. The later part
s/later/latter/
> applies the first level page table for IOVA translation unless the
> DOMAIN_ATTR_NESTING domain attribution has been set, which indicates
> nested mode in use.
> 
Maybe I am reading this wrong, but shouldn't it be the opposite?
i.e. Use FL page table for IOVA if it is a nesting domain?

> Based-on-idea-by: Ashok Raj <ashok.raj@intel.com>
> Based-on-idea-by: Kevin Tian <kevin.tian@intel.com>
> Based-on-idea-by: Liu Yi L <yi.l.liu@intel.com>
> Based-on-idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Based-on-idea-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
> Based-on-idea-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> Change log:
> 
>  v1->v2
>  - The first series was posted here
>    https://lkml.org/lkml/2019/9/23/297
>  - Use per domain page table ops to handle different page tables.
>  - Use first level for DMA remapping by default on both bare metal
>    and vm guest.
>  - Code refine according to code review comments for v1.
> 
> Lu Baolu (8):
>   iommu/vt-d: Add per domain page table ops
>   iommu/vt-d: Move domain_flush_cache helper into header
>   iommu/vt-d: Implement second level page table ops
>   iommu/vt-d: Apply per domain second level page table ops
>   iommu/vt-d: Add first level page table interfaces
>   iommu/vt-d: Implement first level page table ops
>   iommu/vt-d: Identify domains using first level page table
>   iommu/vt-d: Add set domain DOMAIN_ATTR_NESTING attr
> 
>  drivers/iommu/Makefile             |   2 +-
>  drivers/iommu/intel-iommu.c        | 412
> +++++++++++++++++++++++------ drivers/iommu/intel-pgtable.c      |
> 376 ++++++++++++++++++++++++++ include/linux/intel-iommu.h        |
> 64 ++++- include/trace/events/intel_iommu.h |  60 +++++
>  5 files changed, 837 insertions(+), 77 deletions(-)
>  create mode 100644 drivers/iommu/intel-pgtable.c
> 

[Jacob Pan]
