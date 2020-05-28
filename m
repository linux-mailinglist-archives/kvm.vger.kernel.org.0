Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A511E6D13
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 23:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436473AbgE1VDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 17:03:55 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8806 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407418AbgE1VDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 17:03:53 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed026db0000>; Thu, 28 May 2020 14:02:19 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 May 2020 14:03:50 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 May 2020 14:03:50 -0700
Received: from [10.40.100.117] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 May
 2020 21:03:36 +0000
Subject: Re: [PATCH Kernel v23 0/8] Add UAPIs to support migration for VFIO
 devices
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <1589998088-3250-1-git-send-email-kwankhede@nvidia.com>
 <20200528044752.GB1378@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <c1202fe6-bc94-aac6-05d6-bcea76479957@nvidia.com>
Date:   Fri, 29 May 2020 02:33:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528044752.GB1378@joy-OptiPlex-7040>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590699739; bh=fNB6JVlPpuBzZY6lmvceCp6XLAO5nfIE6OxQGJkW1Kk=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=In8RaofIjOrTpwDodaYgpg2fYMbqY//oB7GzxxBbxsbs7x0ffilLdhQ7yxQ6TRcLJ
         jGJF7ge+fWzH/GnTVvtt1oCIULPe8tI/evd/azCG+iNoDZMVT9ssm7/pee0tOgaTPu
         ENwlU3jswxXFYHR5gtlERjCcgcwZKSBs2CM2pxOuyry04FPmttBUtnPt6OzC7Rwf6l
         yzxeKbrJuPnNCCG4aFlqwHCEPyX6jar/KgxUcpXTVfVnGaMvyhZq0Xsq5ri19EEnyC
         RRb3T/xi8O2F5cO4sysUIfnNR2xwJT7ipXjmtZHtuDI8yx8VVPn+/rtl8P25rnvOMQ
         C/ZauX4DrwDPA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/28/2020 10:17 AM, Yan Zhao wrote:
> 
> The whole series works for us in general:
>          Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

Thanks.

Kirti


> 
> On Wed, May 20, 2020 at 11:38:00PM +0530, Kirti Wankhede wrote:
>> Hi,
>>
>> This patch set adds:
>> * IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
>>    respect to IOMMU container rather than per device. All pages pinned by
>>    vendor driver through vfio_pin_pages external API has to be marked as
>>    dirty during  migration. When IOMMU capable device is present in the
>>    container and all pages are pinned and mapped, then all pages are marked
>>    dirty.
>>    When there are CPU writes, CPU dirty page tracking can identify dirtied
>>    pages, but any page pinned by vendor driver can also be written by
>>    device. As of now there is no device which has hardware support for
>>    dirty page tracking. So all pages which are pinned should be considered
>>    as dirty.
>>    This ioctl is also used to start/stop dirty pages tracking for pinned and
>>    unpinned pages while migration is active.
>>
>> * Updated IOCTL VFIO_IOMMU_UNMAP_DMA to get dirty pages bitmap before
>>    unmapping IO virtual address range.
>>    With vIOMMU, during pre-copy phase of migration, while CPUs are still
>>    running, IO virtual address unmap can happen while device still keeping
>>    reference of guest pfns. Those pages should be reported as dirty before
>>    unmap, so that VFIO user space application can copy content of those
>>    pages from source to destination.
>>
>> * Patch 8 detect if IOMMU capable device driver is smart to report pages
>>    to be marked dirty by pinning pages using vfio_pin_pages() API.
>>
>>
>> Yet TODO:
>> Since there is no device which has hardware support for system memmory
>> dirty bitmap tracking, right now there is no other API from vendor driver
>> to VFIO IOMMU module to report dirty pages. In future, when such hardware
>> support will be implemented, an API will be required such that vendor
>> driver could report dirty pages to VFIO module during migration phases.
>>
>> v22 -> v23
>> - Fixed issue reported by Yan
>> https://lore.kernel.org/kvm/97977ede-3c5b-c5a5-7858-7eecd7dd531c@nvidia.com/
>> - Fixed nit picks suggested by Cornelia
>>
>> v21 -> v22
>> - Fixed issue raised by Alex :
>> https://lore.kernel.org/kvm/20200515163307.72951dd2@w520.home/
>>
>> v20 -> v21
>> - Added checkin for GET_BITMAP ioctl for vfio_dma boundaries.
>> - Updated unmap ioctl function - as suggested by Alex.
>> - Updated comments in DIRTY_TRACKING ioctl definition - as suggested by
>>    Cornelia.
>>
>> v19 -> v20
>> - Fixed ioctl to get dirty bitmap to get bitmap of multiple vfio_dmas
>> - Fixed unmap ioctl to get dirty bitmap of multiple vfio_dmas.
>> - Removed flag definition from migration capability.
>>
>> v18 -> v19
>> - Updated migration capability with supported page sizes bitmap for dirty
>>    page tracking and  maximum bitmap size supported by kernel module.
>> - Added patch to calculate and cache pgsize_bitmap when iommu->domain_list
>>    is updated.
>> - Removed extra buffers added in previous version for bitmap manipulation
>>    and optimised the code.
>>
>> v17 -> v18
>> - Add migration capability to the capability chain for VFIO_IOMMU_GET_INFO
>>    ioctl
>> - Updated UMAP_DMA ioctl to return bitmap of multiple vfio_dma
>>
>> v16 -> v17
>> - Fixed errors reported by kbuild test robot <lkp@intel.com> on i386
>>
>> v15 -> v16
>> - Minor edits and nit picks (Auger Eric)
>> - On copying bitmap to user, re-populated bitmap only for pinned pages,
>>    excluding unmapped pages and CPU dirtied pages.
>> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>>    https://lkml.org/lkml/2020/3/12/1255
>>
>> v14 -> v15
>> - Minor edits and nit picks.
>> - In the verification of user allocated bitmap memory, added check of
>>     maximum size.
>> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>>    https://lkml.org/lkml/2020/3/12/1255
>>
>> v13 -> v14
>> - Added struct vfio_bitmap to kabi. updated structure
>>    vfio_iommu_type1_dirty_bitmap_get and vfio_iommu_type1_dma_unmap.
>> - All small changes suggested by Alex.
>> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>>    https://lkml.org/lkml/2020/3/12/1255
>>
>> v12 -> v13
>> - Changed bitmap allocation in vfio_iommu_type1 to per vfio_dma
>> - Changed VFIO_IOMMU_DIRTY_PAGES ioctl behaviour to be per vfio_dma range.
>> - Changed vfio_iommu_type1_dirty_bitmap structure to have separate data
>>    field.
>>
>> v11 -> v12
>> - Changed bitmap allocation in vfio_iommu_type1.
>> - Remove atomicity of ref_count.
>> - Updated comments for migration device state structure about error
>>    reporting.
>> - Nit picks from v11 reviews
>>
>> v10 -> v11
>> - Fix pin pages API to free vpfn if it is marked as unpinned tracking page.
>> - Added proposal to detect if IOMMU capable device calls external pin pages
>>    API to mark pages dirty.
>> - Nit picks from v10 reviews
>>
>> v9 -> v10:
>> - Updated existing VFIO_IOMMU_UNMAP_DMA ioctl to get dirty pages bitmap
>>    during unmap while migration is active
>> - Added flag in VFIO_IOMMU_GET_INFO to indicate driver support dirty page
>>    tracking.
>> - If iommu_mapped, mark all pages dirty.
>> - Added unpinned pages tracking while migration is active.
>> - Updated comments for migration device state structure with bit
>>    combination table and state transition details.
>>
>> v8 -> v9:
>> - Split patch set in 2 sets, Kernel and QEMU.
>> - Dirty pages bitmap is queried from IOMMU container rather than from
>>    vendor driver for per device. Added 2 ioctls to achieve this.
>>
>> v7 -> v8:
>> - Updated comments for KABI
>> - Added BAR address validation check during PCI device's config space load
>>    as suggested by Dr. David Alan Gilbert.
>> - Changed vfio_migration_set_state() to set or clear device state flags.
>> - Some nit fixes.
>>
>> v6 -> v7:
>> - Fix build failures.
>>
>> v5 -> v6:
>> - Fix build failure.
>>
>> v4 -> v5:
>> - Added decriptive comment about the sequence of access of members of
>>    structure vfio_device_migration_info to be followed based on Alex's
>>    suggestion
>> - Updated get dirty pages sequence.
>> - As per Cornelia Huck's suggestion, added callbacks to VFIODeviceOps to
>>    get_object, save_config and load_config.
>> - Fixed multiple nit picks.
>> - Tested live migration with multiple vfio device assigned to a VM.
>>
>> v3 -> v4:
>> - Added one more bit for _RESUMING flag to be set explicitly.
>> - data_offset field is read-only for user space application.
>> - data_size is read for every iteration before reading data from migration,
>>    that is removed assumption that data will be till end of migration
>>    region.
>> - If vendor driver supports mappable sparsed region, map those region
>>    during setup state of save/load, similarly unmap those from cleanup
>>    routines.
>> - Handles race condition that causes data corruption in migration region
>>    during save device state by adding mutex and serialiaing save_buffer and
>>    get_dirty_pages routines.
>> - Skip called get_dirty_pages routine for mapped MMIO region of device.
>> - Added trace events.
>> - Split into multiple functional patches.
>>
>> v2 -> v3:
>> - Removed enum of VFIO device states. Defined VFIO device state with 2
>>    bits.
>> - Re-structured vfio_device_migration_info to keep it minimal and defined
>>    action on read and write access on its members.
>>
>> v1 -> v2:
>> - Defined MIGRATION region type and sub-type which should be used with
>>    region type capability.
>> - Re-structured vfio_device_migration_info. This structure will be placed
>>    at 0th offset of migration region.
>> - Replaced ioctl with read/write for trapped part of migration region.
>> - Added both type of access support, trapped or mmapped, for data section
>>    of the region.
>> - Moved PCI device functions to pci file.
>> - Added iteration to get dirty page bitmap until bitmap for all requested
>>    pages are copied.
>>
>> Thanks,
>> Kirti
>>
>>
>> Kirti Wankhede (8):
>>    vfio: UAPI for migration interface for device state
>>    vfio iommu: Remove atomicity of ref_count of pinned pages
>>    vfio iommu: Cache pgsize_bitmap in struct vfio_iommu
>>    vfio iommu: Add ioctl definition for dirty pages tracking
>>    vfio iommu: Implementation of ioctl for dirty pages tracking
>>    vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
>>    vfio iommu: Add migration capability to report supported features
>>    vfio: Selective dirty page tracking if IOMMU backed device pins pages
>>
>>   drivers/vfio/vfio.c             |  13 +-
>>   drivers/vfio/vfio_iommu_type1.c | 571 ++++++++++++++++++++++++++++++++++++----
>>   include/linux/vfio.h            |   4 +-
>>   include/uapi/linux/vfio.h       | 318 ++++++++++++++++++++++
>>   4 files changed, 847 insertions(+), 59 deletions(-)
>>
>> -- 
>> 2.7.0
>>
