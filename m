Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D741B1D9D57
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 18:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgESQ6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 12:58:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25173 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728689AbgESQ6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 12:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589907498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQq0IknBCw/8RUO/la4jyQolojHPn4XGSA0+E/fLWtI=;
        b=K1zDZ0qwlkIlbYqRPPbVIJ+4uT7/b90ViUxby7LIivP72q47GvdLYr/Op5o6Ag6hL11cxO
        rqKHbRbCH1hINxKRgLg7oqgTFULt5iG4YS6K0uE8j755jZlqxOU1LfyVfSQssoua7fHYYI
        jHBDOdbABu4O1bFJK6OaNfLKf1qkIcA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410--ngrjc2jMHqqF9VPkbG-aw-1; Tue, 19 May 2020 12:58:09 -0400
X-MC-Unique: -ngrjc2jMHqqF9VPkbG-aw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29293A0BD9;
        Tue, 19 May 2020 16:58:07 +0000 (UTC)
Received: from x1.home (ovpn-112-50.phx2.redhat.com [10.3.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D74062AEB;
        Tue, 19 May 2020 16:58:04 +0000 (UTC)
Date:   Tue, 19 May 2020 10:58:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200519105804.02f3cae8@x1.home>
In-Reply-To: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

My impression is that we're getting pretty close to a workable
implementation here with v22 plus respins of patches 5, 6, and 8.  We
also have a matching QEMU series and a proposal for a new i40e
consumer, as well as I assume GVT-g updates happening internally at
Intel.  I expect all of the latter needs further review and discussion,
but we should be at the point where we can validate these proposed
kernel interfaces.  Therefore I'd like to make a call for reviews so
that we can get this wrapped up for the v5.8 merge window.  I know
Connie has some outstanding documentation comments and I'd like to make
sure everyone has an opportunity to check that their comments have been
addressed and we don't discover any new blocking issues.  Please send
your Acked-by/Reviewed-by/Tested-by tags if you're satisfied with this
interface and implementation.  Thanks!

Alex

On Mon, 18 May 2020 11:26:29 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Hi,
> 
> This patch set adds:
> * IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
>   respect to IOMMU container rather than per device. All pages pinned by
>   vendor driver through vfio_pin_pages external API has to be marked as
>   dirty during  migration. When IOMMU capable device is present in the
>   container and all pages are pinned and mapped, then all pages are marked
>   dirty.
>   When there are CPU writes, CPU dirty page tracking can identify dirtied
>   pages, but any page pinned by vendor driver can also be written by
>   device. As of now there is no device which has hardware support for
>   dirty page tracking. So all pages which are pinned should be considered
>   as dirty.
>   This ioctl is also used to start/stop dirty pages tracking for pinned and
>   unpinned pages while migration is active.
> 
> * Updated IOCTL VFIO_IOMMU_UNMAP_DMA to get dirty pages bitmap before
>   unmapping IO virtual address range.
>   With vIOMMU, during pre-copy phase of migration, while CPUs are still
>   running, IO virtual address unmap can happen while device still keeping
>   reference of guest pfns. Those pages should be reported as dirty before
>   unmap, so that VFIO user space application can copy content of those
>   pages from source to destination.
> 
> * Patch 8 detect if IOMMU capable device driver is smart to report pages
>   to be marked dirty by pinning pages using vfio_pin_pages() API.
> 
> 
> Yet TODO:
> Since there is no device which has hardware support for system memmory
> dirty bitmap tracking, right now there is no other API from vendor driver
> to VFIO IOMMU module to report dirty pages. In future, when such hardware
> support will be implemented, an API will be required such that vendor
> driver could report dirty pages to VFIO module during migration phases.
> 
> Adding revision history from previous QEMU patch set to understand KABI
> changes done till now
> 
> v21 -> v22
> - Fixed issue raised by Alex :
> https://lore.kernel.org/kvm/20200515163307.72951dd2@w520.home/
> 
> v20 -> v21
> - Added checkin for GET_BITMAP ioctl for vfio_dma boundaries.
> - Updated unmap ioctl function - as suggested by Alex.
> - Updated comments in DIRTY_TRACKING ioctl definition - as suggested by
>   Cornelia.
> 
> v19 -> v20
> - Fixed ioctl to get dirty bitmap to get bitmap of multiple vfio_dmas
> - Fixed unmap ioctl to get dirty bitmap of multiple vfio_dmas.
> - Removed flag definition from migration capability.
> 
> v18 -> v19
> - Updated migration capability with supported page sizes bitmap for dirty
>   page tracking and  maximum bitmap size supported by kernel module.
> - Added patch to calculate and cache pgsize_bitmap when iommu->domain_list
>   is updated.
> - Removed extra buffers added in previous version for bitmap manipulation
>   and optimised the code.
> 
> v17 -> v18
> - Add migration capability to the capability chain for VFIO_IOMMU_GET_INFO
>   ioctl
> - Updated UMAP_DMA ioctl to return bitmap of multiple vfio_dma
> 
> v16 -> v17
> - Fixed errors reported by kbuild test robot <lkp@intel.com> on i386
> 
> v15 -> v16
> - Minor edits and nit picks (Auger Eric)
> - On copying bitmap to user, re-populated bitmap only for pinned pages,
>   excluding unmapped pages and CPU dirtied pages.
> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>   https://lkml.org/lkml/2020/3/12/1255
> 
> v14 -> v15
> - Minor edits and nit picks.
> - In the verification of user allocated bitmap memory, added check of
>    maximum size.
> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>   https://lkml.org/lkml/2020/3/12/1255
> 
> v13 -> v14
> - Added struct vfio_bitmap to kabi. updated structure
>   vfio_iommu_type1_dirty_bitmap_get and vfio_iommu_type1_dma_unmap.
> - All small changes suggested by Alex.
> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>   https://lkml.org/lkml/2020/3/12/1255
> 
> v12 -> v13
> - Changed bitmap allocation in vfio_iommu_type1 to per vfio_dma
> - Changed VFIO_IOMMU_DIRTY_PAGES ioctl behaviour to be per vfio_dma range.
> - Changed vfio_iommu_type1_dirty_bitmap structure to have separate data
>   field.
> 
> v11 -> v12
> - Changed bitmap allocation in vfio_iommu_type1.
> - Remove atomicity of ref_count.
> - Updated comments for migration device state structure about error
>   reporting.
> - Nit picks from v11 reviews
> 
> v10 -> v11
> - Fix pin pages API to free vpfn if it is marked as unpinned tracking page.
> - Added proposal to detect if IOMMU capable device calls external pin pages
>   API to mark pages dirty.
> - Nit picks from v10 reviews
> 
> v9 -> v10:
> - Updated existing VFIO_IOMMU_UNMAP_DMA ioctl to get dirty pages bitmap
>   during unmap while migration is active
> - Added flag in VFIO_IOMMU_GET_INFO to indicate driver support dirty page
>   tracking.
> - If iommu_mapped, mark all pages dirty.
> - Added unpinned pages tracking while migration is active.
> - Updated comments for migration device state structure with bit
>   combination table and state transition details.
> 
> v8 -> v9:
> - Split patch set in 2 sets, Kernel and QEMU.
> - Dirty pages bitmap is queried from IOMMU container rather than from
>   vendor driver for per device. Added 2 ioctls to achieve this.
> 
> v7 -> v8:
> - Updated comments for KABI
> - Added BAR address validation check during PCI device's config space load
>   as suggested by Dr. David Alan Gilbert.
> - Changed vfio_migration_set_state() to set or clear device state flags.
> - Some nit fixes.
> 
> v6 -> v7:
> - Fix build failures.
> 
> v5 -> v6:
> - Fix build failure.
> 
> v4 -> v5:
> - Added decriptive comment about the sequence of access of members of
>   structure vfio_device_migration_info to be followed based on Alex's
>   suggestion
> - Updated get dirty pages sequence.
> - As per Cornelia Huck's suggestion, added callbacks to VFIODeviceOps to
>   get_object, save_config and load_config.
> - Fixed multiple nit picks.
> - Tested live migration with multiple vfio device assigned to a VM.
> 
> v3 -> v4:
> - Added one more bit for _RESUMING flag to be set explicitly.
> - data_offset field is read-only for user space application.
> - data_size is read for every iteration before reading data from migration,
>   that is removed assumption that data will be till end of migration
>   region.
> - If vendor driver supports mappable sparsed region, map those region
>   during setup state of save/load, similarly unmap those from cleanup
>   routines.
> - Handles race condition that causes data corruption in migration region
>   during save device state by adding mutex and serialiaing save_buffer and
>   get_dirty_pages routines.
> - Skip called get_dirty_pages routine for mapped MMIO region of device.
> - Added trace events.
> - Split into multiple functional patches.
> 
> v2 -> v3:
> - Removed enum of VFIO device states. Defined VFIO device state with 2
>   bits.
> - Re-structured vfio_device_migration_info to keep it minimal and defined
>   action on read and write access on its members.
> 
> v1 -> v2:
> - Defined MIGRATION region type and sub-type which should be used with
>   region type capability.
> - Re-structured vfio_device_migration_info. This structure will be placed
>   at 0th offset of migration region.
> - Replaced ioctl with read/write for trapped part of migration region.
> - Added both type of access support, trapped or mmapped, for data section
>   of the region.
> - Moved PCI device functions to pci file.
> - Added iteration to get dirty page bitmap until bitmap for all requested
>   pages are copied.
> 
> Thanks,
> Kirti
> 
> 
> 
> 
> Kirti Wankhede (8):
>   vfio: UAPI for migration interface for device state
>   vfio iommu: Remove atomicity of ref_count of pinned pages
>   vfio iommu: Cache pgsize_bitmap in struct vfio_iommu
>   vfio iommu: Add ioctl definition for dirty pages tracking
>   vfio iommu: Implementation of ioctl for dirty pages tracking
>   vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
>   vfio iommu: Add migration capability to report supported features
>   vfio: Selective dirty page tracking if IOMMU backed device pins pages
> 
>  drivers/vfio/vfio.c             |  13 +-
>  drivers/vfio/vfio_iommu_type1.c | 576 ++++++++++++++++++++++++++++++++++++----
>  include/linux/vfio.h            |   4 +-
>  include/uapi/linux/vfio.h       | 315 ++++++++++++++++++++++
>  4 files changed, 849 insertions(+), 59 deletions(-)
> 

