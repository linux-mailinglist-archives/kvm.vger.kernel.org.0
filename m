Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C571D4AD9
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 12:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgEOKY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 06:24:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:21991 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgEOKY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 06:24:57 -0400
IronPort-SDR: DguyeY0xQeGaYVVsB7KZBOLXRqfQu9WZyyBepvyCMXkiSSAQJPvkVJhVqOqOLirV3EYasiMzkB
 Lt2zemWmy2LA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:24:41 -0700
IronPort-SDR: e0KmnVrH754996k2OKgU2kmZWSwpkYvgcdtqRBlf3reeKZp39lQbJonXaxe25hJ1BD+qJWbohP
 Pvpr6e0nBpmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,394,1583222400"; 
   d="scan'208";a="266562192"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga006.jf.intel.com with ESMTP; 15 May 2020 03:24:36 -0700
Date:   Fri, 15 May 2020 06:14:47 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dgilbert@redhat.com,
        jonathan.davies@nutanix.com, eauger@redhat.com, aik@ozlabs.ru,
        pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@Alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH Kernel v20 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200515101447.GB5559@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
 <20200514213206.271fa661@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514213206.271fa661@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 09:32:06PM -0600, Alex Williamson wrote:
> Hi Yan & Intel folks,
> 
> I'm starting to run out of comments on this series, where are you with
> porting GVT-g migration to this API?  Are there remaining blocking
> issues?  Are we satisfied that the API is sufficient to support vIOMMU
> now?  Thanks,
> 
hi Alex
currently, we have ported to v17 kernel + v16 qemu with some fixes. gvt
is working but we didn't try viommu yet.
for this v20 kernel series, is there any qemu patches matching to it?

Thanks
Yan


> On Fri, 15 May 2020 02:07:39 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > Hi,
> > 
> > This patch set adds:
> > * IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
> >   respect to IOMMU container rather than per device. All pages pinned by
> >   vendor driver through vfio_pin_pages external API has to be marked as
> >   dirty during  migration. When IOMMU capable device is present in the
> >   container and all pages are pinned and mapped, then all pages are marked
> >   dirty.
> >   When there are CPU writes, CPU dirty page tracking can identify dirtied
> >   pages, but any page pinned by vendor driver can also be written by
> >   device. As of now there is no device which has hardware support for
> >   dirty page tracking. So all pages which are pinned should be considered
> >   as dirty.
> >   This ioctl is also used to start/stop dirty pages tracking for pinned and
> >   unpinned pages while migration is active.
> > 
> > * Updated IOCTL VFIO_IOMMU_UNMAP_DMA to get dirty pages bitmap before
> >   unmapping IO virtual address range.
> >   With vIOMMU, during pre-copy phase of migration, while CPUs are still
> >   running, IO virtual address unmap can happen while device still keeping
> >   reference of guest pfns. Those pages should be reported as dirty before
> >   unmap, so that VFIO user space application can copy content of those
> >   pages from source to destination.
> > 
> > * Patch 8 detect if IOMMU capable device driver is smart to report pages
> >   to be marked dirty by pinning pages using vfio_pin_pages() API.
> > 
> > 
> > Yet TODO:
> > Since there is no device which has hardware support for system memmory
> > dirty bitmap tracking, right now there is no other API from vendor driver
> > to VFIO IOMMU module to report dirty pages. In future, when such hardware
> > support will be implemented, an API will be required such that vendor
> > driver could report dirty pages to VFIO module during migration phases.
> > 
> > Adding revision history from previous QEMU patch set to understand KABI
> > changes done till now
> > 
> > v19 -> v20
> > - Fixed ioctl to get dirty bitmap to get bitmap of multiple vfio_dmas
> > - Fixed unmap ioctl to get dirty bitmap of multiple vfio_dmas.
> > - Removed flag definition from migration capability.
> > 
> > v18 -> v19
> > - Updated migration capability with supported page sizes bitmap for dirty
> >   page tracking and  maximum bitmap size supported by kernel module.
> > - Added patch to calculate and cache pgsize_bitmap when iommu->domain_list
> >   is updated.
> > - Removed extra buffers added in previous version for bitmap manipulation
> >   and optimised the code.
> > 
> > v17 -> v18
> > - Add migration capability to the capability chain for VFIO_IOMMU_GET_INFO
> >   ioctl
> > - Updated UMAP_DMA ioctl to return bitmap of multiple vfio_dma
> > 
> > v16 -> v17
> > - Fixed errors reported by kbuild test robot <lkp@intel.com> on i386
> > 
> > v15 -> v16
> > - Minor edits and nit picks (Auger Eric)
> > - On copying bitmap to user, re-populated bitmap only for pinned pages,
> >   excluding unmapped pages and CPU dirtied pages.
> > - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
> >   https://lkml.org/lkml/2020/3/12/1255
> > 
> > v14 -> v15
> > - Minor edits and nit picks.
> > - In the verification of user allocated bitmap memory, added check of
> >    maximum size.
> > - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
> >   https://lkml.org/lkml/2020/3/12/1255
> > 
> > v13 -> v14
> > - Added struct vfio_bitmap to kabi. updated structure
> >   vfio_iommu_type1_dirty_bitmap_get and vfio_iommu_type1_dma_unmap.
> > - All small changes suggested by Alex.
> > - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
> >   https://lkml.org/lkml/2020/3/12/1255
> > 
> > v12 -> v13
> > - Changed bitmap allocation in vfio_iommu_type1 to per vfio_dma
> > - Changed VFIO_IOMMU_DIRTY_PAGES ioctl behaviour to be per vfio_dma range.
> > - Changed vfio_iommu_type1_dirty_bitmap structure to have separate data
> >   field.
> > 
> > v11 -> v12
> > - Changed bitmap allocation in vfio_iommu_type1.
> > - Remove atomicity of ref_count.
> > - Updated comments for migration device state structure about error
> >   reporting.
> > - Nit picks from v11 reviews
> > 
> > v10 -> v11
> > - Fix pin pages API to free vpfn if it is marked as unpinned tracking page.
> > - Added proposal to detect if IOMMU capable device calls external pin pages
> >   API to mark pages dirty.
> > - Nit picks from v10 reviews
> > 
> > v9 -> v10:
> > - Updated existing VFIO_IOMMU_UNMAP_DMA ioctl to get dirty pages bitmap
> >   during unmap while migration is active
> > - Added flag in VFIO_IOMMU_GET_INFO to indicate driver support dirty page
> >   tracking.
> > - If iommu_mapped, mark all pages dirty.
> > - Added unpinned pages tracking while migration is active.
> > - Updated comments for migration device state structure with bit
> >   combination table and state transition details.
> > 
> > v8 -> v9:
> > - Split patch set in 2 sets, Kernel and QEMU.
> > - Dirty pages bitmap is queried from IOMMU container rather than from
> >   vendor driver for per device. Added 2 ioctls to achieve this.
> > 
> > v7 -> v8:
> > - Updated comments for KABI
> > - Added BAR address validation check during PCI device's config space load
> >   as suggested by Dr. David Alan Gilbert.
> > - Changed vfio_migration_set_state() to set or clear device state flags.
> > - Some nit fixes.
> > 
> > v6 -> v7:
> > - Fix build failures.
> > 
> > v5 -> v6:
> > - Fix build failure.
> > 
> > v4 -> v5:
> > - Added decriptive comment about the sequence of access of members of
> >   structure vfio_device_migration_info to be followed based on Alex's
> >   suggestion
> > - Updated get dirty pages sequence.
> > - As per Cornelia Huck's suggestion, added callbacks to VFIODeviceOps to
> >   get_object, save_config and load_config.
> > - Fixed multiple nit picks.
> > - Tested live migration with multiple vfio device assigned to a VM.
> > 
> > v3 -> v4:
> > - Added one more bit for _RESUMING flag to be set explicitly.
> > - data_offset field is read-only for user space application.
> > - data_size is read for every iteration before reading data from migration,
> >   that is removed assumption that data will be till end of migration
> >   region.
> > - If vendor driver supports mappable sparsed region, map those region
> >   during setup state of save/load, similarly unmap those from cleanup
> >   routines.
> > - Handles race condition that causes data corruption in migration region
> >   during save device state by adding mutex and serialiaing save_buffer and
> >   get_dirty_pages routines.
> > - Skip called get_dirty_pages routine for mapped MMIO region of device.
> > - Added trace events.
> > - Split into multiple functional patches.
> > 
> > v2 -> v3:
> > - Removed enum of VFIO device states. Defined VFIO device state with 2
> >   bits.
> > - Re-structured vfio_device_migration_info to keep it minimal and defined
> >   action on read and write access on its members.
> > 
> > v1 -> v2:
> > - Defined MIGRATION region type and sub-type which should be used with
> >   region type capability.
> > - Re-structured vfio_device_migration_info. This structure will be placed
> >   at 0th offset of migration region.
> > - Replaced ioctl with read/write for trapped part of migration region.
> > - Added both type of access support, trapped or mmapped, for data section
> >   of the region.
> > - Moved PCI device functions to pci file.
> > - Added iteration to get dirty page bitmap until bitmap for all requested
> >   pages are copied.
> > 
> > Thanks,
> > Kirti
> > 
> > 
> > 
> > Kirti Wankhede (8):
> >   vfio: UAPI for migration interface for device state
> >   vfio iommu: Remove atomicity of ref_count of pinned pages
> >   vfio iommu: Cache pgsize_bitmap in struct vfio_iommu
> >   vfio iommu: Add ioctl definition for dirty pages tracking
> >   vfio iommu: Implementation of ioctl for dirty pages tracking
> >   vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
> >   vfio iommu: Add migration capability to report supported features
> >   vfio: Selective dirty page tracking if IOMMU backed device pins pages
> > 
> >  drivers/vfio/vfio.c             |  13 +-
> >  drivers/vfio/vfio_iommu_type1.c | 565 ++++++++++++++++++++++++++++++++++++----
> >  include/linux/vfio.h            |   4 +-
> >  include/uapi/linux/vfio.h       | 315 ++++++++++++++++++++++
> >  4 files changed, 838 insertions(+), 59 deletions(-)
> > 
> 
