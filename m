Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB06127A40
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 12:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLTLu4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 20 Dec 2019 06:50:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:43217 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfLTLu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 06:50:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 03:50:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="228584602"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2019 03:50:54 -0800
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 20 Dec 2019 03:50:54 -0800
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 20 Dec 2019 03:50:54 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.29]) with mapi id 14.03.0439.000;
 Fri, 20 Dec 2019 19:50:52 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 0/7] Use 1st-level for IOVA translation
Thread-Topic: [PATCH v4 0/7] Use 1st-level for IOVA translation
Thread-Index: AQHVthray/3ZZTiwzUq7igUsBwcT3qfC6XAw
Date:   Fri, 20 Dec 2019 11:50:52 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A13A364@SHSMSX104.ccr.corp.intel.com>
References: <20191219031634.15168-1-baolu.lu@linux.intel.com>
In-Reply-To: <20191219031634.15168-1-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzVmNGY2YTUtM2IzMC00NWJjLTg0ZjYtYzk2NGM2YjlhNGZiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiK0NqSTRiTk9FY0ltVksrZ1cxWWtXUlhRZlI1MG1Zb0RNdnZJZ3FsUnMrNlZWN3diOUl3QlNvMVhaSHlzYVwvQUsifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Baolu,

In a brief, this version is pretty good to me. However, I still want
to have the following checks to see if anything missed. Wish it
helps.

1) would using IOVA over FLPT default on?
My opinion is that before we have got gIOVA nested translation
done for passthru devices, we should make this feature as off.

2) the domain->agaw is somehow calculated according to the
capabilities related to second level page table. As we are moving
IOVA to FLPT, I'd suggest to calculate domain->agaw with the
translation modes FLPT supports (e.g. 4 level and 5 level)

3) Per VT-d spec, FLPT has canonical requirement to the input
addresses. So I'd suggest to add some enhance regards to it.
Please refer to chapter 3.6 :-).

3.6 First-Level Translation
First-level translation restricts the input-address to a canonical address (i.e., address bits 63:N have
the same value as address bit [N-1], where N is 48-bits with 4-level paging and 57-bits with 5-level
paging). Requests subject to first-level translation by remapping hardware are subject to canonical
address checking as a pre-condition for first-level translation, and a violation is treated as a
translation-fault.

Regards,
Yi Liu

> From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
> Sent: Thursday, December 19, 2019 11:16 AM
> To: Joerg Roedel <joro@8bytes.org>; David Woodhouse <dwmw2@infradead.org>;
> Alex Williamson <alex.williamson@redhat.com>
> Subject: [PATCH v4 0/7] Use 1st-level for IOVA translation
> 
> Intel VT-d in scalable mode supports two types of page tables
> for DMA translation: the first level page table and the second
> level page table. The first level page table uses the same
> format as the CPU page table, while the second level page table
> keeps compatible with previous formats. The software is able
> to choose any one of them for DMA remapping according to the use
> case.
> 
> This patchset aims to move IOVA (I/O Virtual Address) translation
> to 1st-level page table in scalable mode. This will simplify vIOMMU
> (IOMMU simulated by VM hypervisor) design by using the two-stage
> translation, a.k.a. nested mode translation.
> 
> As Intel VT-d architecture offers caching mode, guest IOVA (GIOVA)
> support is currently implemented in a shadow page manner. The device
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
> This patch applies the first level page table for IOVA translation
> unless the DOMAIN_ATTR_NESTING domain attribution has been set.
> Setting of this attribution means the second level will be used to
> map gPA (guest physical address) to hPA (host physical address), and
> the mappings between gVA (guest virtual address) and gPA will be
> maintained by the guest with the page table address binding to host's
> first level.
> 
> Based-on-idea-by: Ashok Raj <ashok.raj@intel.com>
> Based-on-idea-by: Kevin Tian <kevin.tian@intel.com>
> Based-on-idea-by: Liu Yi L <yi.l.liu@intel.com>
> Based-on-idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Based-on-idea-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
> Based-on-idea-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> Change log:
> 
> v3->v4:
>  - The previous version was posted here
>    https://lkml.org/lkml/2019/12/10/2126
>  - Set Execute Disable (bit 63) in first level table entries.
>  - Enhance pasid-based iotlb invalidation for both default domain
>    and auxiliary domain.
>  - Add debugfs file to expose page table internals.
> 
> v2->v3:
>  - The previous version was posted here
>    https://lkml.org/lkml/2019/11/27/1831
>  - Accept Jacob's suggestion on merging two page tables.
> 
>  v1->v2
>  - The first series was posted here
>    https://lkml.org/lkml/2019/9/23/297
>  - Use per domain page table ops to handle different page tables.
>  - Use first level for DMA remapping by default on both bare metal
>    and vm guest.
>  - Code refine according to code review comments for v1.
> 
> Lu Baolu (7):
>   iommu/vt-d: Identify domains using first level page table
>   iommu/vt-d: Add set domain DOMAIN_ATTR_NESTING attr
>   iommu/vt-d: Add PASID_FLAG_FL5LP for first-level pasid setup
>   iommu/vt-d: Setup pasid entries for iova over first level
>   iommu/vt-d: Flush PASID-based iotlb for iova over first level
>   iommu/vt-d: Use iova over first level
>   iommu/vt-d: debugfs: Add support to show page table internals
> 
>  drivers/iommu/dmar.c                |  41 ++++++
>  drivers/iommu/intel-iommu-debugfs.c |  75 +++++++++++
>  drivers/iommu/intel-iommu.c         | 201 +++++++++++++++++++++++++---
>  drivers/iommu/intel-pasid.c         |   7 +-
>  drivers/iommu/intel-pasid.h         |   6 +
>  drivers/iommu/intel-svm.c           |   8 +-
>  include/linux/intel-iommu.h         |  20 ++-
>  7 files changed, 326 insertions(+), 32 deletions(-)
> 
> --
> 2.17.1

