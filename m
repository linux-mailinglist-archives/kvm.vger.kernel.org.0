Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CF210F4E8
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 03:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfLCCTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 21:19:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:24453 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfLCCTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 21:19:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 18:19:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,271,1571727600"; 
   d="scan'208";a="222654206"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 02 Dec 2019 18:19:35 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Use 1st-level for DMA remapping
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
 <20191202121927.2fef85ba@jacob-builder>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <608f472b-3eb1-8ea9-1561-cdf2e8191793@linux.intel.com>
Date:   Tue, 3 Dec 2019 10:19:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191202121927.2fef85ba@jacob-builder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jacob,

Thanks for reviewing it.

On 12/3/19 4:19 AM, Jacob Pan wrote:
> On Thu, 28 Nov 2019 10:25:42 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> Intel VT-d in scalable mode supports two types of page talbes
> tables

Got it, thanks!

>> for DMA translation: the first level page table and the second
>> level page table. The first level page table uses the same
>> format as the CPU page table, while the second level page table
>> keeps compatible with previous formats. The software is able
>> to choose any one of them for DMA remapping according to the use
>> case.
>>
>> This patchset aims to move IOVA (I/O Virtual Address) translation
> move guest IOVA only, right?

No. In v1, only for guest IOVA. This has been changed since v2 according
to comments during v1 review period. v2 will use first level for both
host and guest unless nested mode.

>> to 1st-level page table in scalable mode. This will simplify vIOMMU
>> (IOMMU simulated by VM hypervisor) design by using the two-stage
>> translation, a.k.a. nested mode translation.
>>
>> As Intel VT-d architecture offers caching mode, guest IOVA (GIOVA)
>> support is now implemented in a shadow page manner. The device
>> simulation software, like QEMU, has to figure out GIOVA->GPA mappings
>> and write them to a shadowed page table, which will be used by the
>> physical IOMMU. Each time when mappings are created or destroyed in
>> vIOMMU, the simulation software has to intervene. Hence, the changes
>> on GIOVA->GPA could be shadowed to host.
>>
>>
>>       .-----------.
>>       |  vIOMMU   |
>>       |-----------|                 .--------------------.
>>       |           |IOTLB flush trap |        QEMU        |
>>       .-----------. (map/unmap)     |--------------------|
>>       |GIOVA->GPA |---------------->|    .------------.  |
>>       '-----------'                 |    | GIOVA->HPA |  |
>>       |           |                 |    '------------'  |
>>       '-----------'                 |                    |
>>                                     |                    |
>>                                     '--------------------'
>>                                                  |
>>              <------------------------------------
>>              |
>>              v VFIO/IOMMU API
>>        .-----------.
>>        |  pIOMMU   |
>>        |-----------|
>>        |           |
>>        .-----------.
>>        |GIOVA->HPA |
>>        '-----------'
>>        |           |
>>        '-----------'
>>
>> In VT-d 3.0, scalable mode is introduced, which offers two-level
>> translation page tables and nested translation mode. Regards to
>> GIOVA support, it can be simplified by 1) moving the GIOVA support
>> over 1st-level page table to store GIOVA->GPA mapping in vIOMMU,
>> 2) binding vIOMMU 1st level page table to the pIOMMU, 3) using pIOMMU
>> second level for GPA->HPA translation, and 4) enable nested (a.k.a.
>> dual-stage) translation in host. Compared with current shadow GIOVA
>> support, the new approach makes the vIOMMU design simpler and more
>> efficient as we only need to flush the pIOMMU IOTLB and possible
>> device-IOTLB when an IOVA mapping in vIOMMU is torn down.
>>
>>       .-----------.
>>       |  vIOMMU   |
>>       |-----------|                 .-----------.
>>       |           |IOTLB flush trap |   QEMU    |
>>       .-----------.    (unmap)      |-----------|
>>       |GIOVA->GPA |---------------->|           |
>>       '-----------'                 '-----------'
>>       |           |                       |
>>       '-----------'                       |
>>             <------------------------------
>>             |      VFIO/IOMMU
>>             |  cache invalidation and
>>             | guest gpd bind interfaces
>>             v
>>       .-----------.
>>       |  pIOMMU   |
>>       |-----------|
>>       .-----------.
>>       |GIOVA->GPA |<---First level
>>       '-----------'
>>       | GPA->HPA  |<---Scond level
>>       '-----------'
>>       '-----------'
>>
>> This patch set includes two parts. The former part implements the
>> per-domain page table abstraction, which makes the page table
>> difference transparent to various map/unmap APIs. The later part
> s/later/latter/
>> applies the first level page table for IOVA translation unless the
>> DOMAIN_ATTR_NESTING domain attribution has been set, which indicates
>> nested mode in use.
>>
> Maybe I am reading this wrong, but shouldn't it be the opposite?
> i.e. Use FL page table for IOVA if it is a nesting domain?

My description seems to a bit confusing. If DOMAIN_ATTR_NESTING is set
for a domain, the second level will be used to map gPA (guest physical
address) to hPA (host physical address), and the mappings between gVA (
guest virtual address) and gPA will be maintained by the guest with the
page table address binding to host's first level. Otherwise, first level
will be used for mapping between gPA and hPA, or IOVA and DMA address.

Best regards,
baolu

> 
>> Based-on-idea-by: Ashok Raj <ashok.raj@intel.com>
>> Based-on-idea-by: Kevin Tian <kevin.tian@intel.com>
>> Based-on-idea-by: Liu Yi L <yi.l.liu@intel.com>
>> Based-on-idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Based-on-idea-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
>> Based-on-idea-by: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> Change log:
>>
>>   v1->v2
>>   - The first series was posted here
>>     https://lkml.org/lkml/2019/9/23/297
>>   - Use per domain page table ops to handle different page tables.
>>   - Use first level for DMA remapping by default on both bare metal
>>     and vm guest.
>>   - Code refine according to code review comments for v1.
>>
>> Lu Baolu (8):
>>    iommu/vt-d: Add per domain page table ops
>>    iommu/vt-d: Move domain_flush_cache helper into header
>>    iommu/vt-d: Implement second level page table ops
>>    iommu/vt-d: Apply per domain second level page table ops
>>    iommu/vt-d: Add first level page table interfaces
>>    iommu/vt-d: Implement first level page table ops
>>    iommu/vt-d: Identify domains using first level page table
>>    iommu/vt-d: Add set domain DOMAIN_ATTR_NESTING attr
>>
>>   drivers/iommu/Makefile             |   2 +-
>>   drivers/iommu/intel-iommu.c        | 412
>> +++++++++++++++++++++++------ drivers/iommu/intel-pgtable.c      |
>> 376 ++++++++++++++++++++++++++ include/linux/intel-iommu.h        |
>> 64 ++++- include/trace/events/intel_iommu.h |  60 +++++
>>   5 files changed, 837 insertions(+), 77 deletions(-)
>>   create mode 100644 drivers/iommu/intel-pgtable.c
>>
> 
> [Jacob Pan]
> 
