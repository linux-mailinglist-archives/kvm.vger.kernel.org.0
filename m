Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A384B191A79
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 21:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgCXUGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 16:06:09 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18871 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgCXUGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 16:06:09 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7a68220000>; Tue, 24 Mar 2020 13:05:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 24 Mar 2020 13:06:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 24 Mar 2020 13:06:07 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 20:06:07 +0000
Received: from kwankhede-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 24 Mar 2020 20:06:01 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v16 Kernel 0/7] KABIs to support migration for VFIO devices
Date:   Wed, 25 Mar 2020 01:02:32 +0530
Message-ID: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585080354; bh=Z2j+6gx1dsfGmQOm+VWO6MwVPydfmL204YqWASsyX9s=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=IkcnvMdaw/wLfFAcVde+tdG/OUzRlNCuGMyVQ4lMaPypvAB/h7ElumQ5D0giLUbeb
         5EojZ9TrWNSR8BEDtVERnipX5sjIMm/GgHMPKd+B899G5BIJhOpMmr2JHJyqjuw9+F
         roUXEk6s1OCXmobItd3kPoC1nkLKWaywmfnaf8420uKO5o5nZHqVSLwoUsu6FRyJ44
         5ttQ0hMraH3KEum3aKfSPHFXr3OG8RctJL7Yjn0Uo8Waqa+8LS8Bc9iIVzp6CIt6YQ
         ci8ChrfiVZ55w3l/MwGv4yNP7J+HF6It5d1AEl7Ei70EyZRCOo8tw8pIhY4yQbABvc
         u7+HKkz/WeRHg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch set adds:
* New IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
  respect to IOMMU container rather than per device. All pages pinned by
  vendor driver through vfio_pin_pages external API has to be marked as
  dirty during  migration. When IOMMU capable device is present in the
  container and all pages are pinned and mapped, then all pages are marked
  dirty.
  When there are CPU writes, CPU dirty page tracking can identify dirtied
  pages, but any page pinned by vendor driver can also be written by
  device. As of now there is no device which has hardware support for
  dirty page tracking. So all pages which are pinned should be considered
  as dirty.
  This ioctl is also used to start/stop dirty pages tracking for pinned and
  unpinned pages while migration is active.

* Updated IOCTL VFIO_IOMMU_UNMAP_DMA to get dirty pages bitmap before
  unmapping IO virtual address range.
  With vIOMMU, during pre-copy phase of migration, while CPUs are still
  running, IO virtual address unmap can happen while device still keeping
  reference of guest pfns. Those pages should be reported as dirty before
  unmap, so that VFIO user space application can copy content of those
  pages from source to destination.

* Patch 7 detect if IOMMU capable device driver is smart to report pages
  to be marked dirty by pinning pages using vfio_pin_pages() API.


Yet TODO:
Since there is no device which has hardware support for system memmory
dirty bitmap tracking, right now there is no other API from vendor driver
to VFIO IOMMU module to report dirty pages. In future, when such hardware
support will be implemented, an API will be required such that vendor
driver could report dirty pages to VFIO module during migration phases.

Adding revision history from previous QEMU patch set to understand KABI
changes done till now

v15 -> v16
- Minor edits and nit picks (Auger Eric)
- On copying bitmap to user, re-populated bitmap only for pinned pages,
  excluding unmapped pages and CPU dirtied pages.
- Patches are on tag: next-20200318 and 1-3 patches from Yan's series
  https://lkml.org/lkml/2020/3/12/1255

v14 -> v15
- Minor edits and nit picks.
- In the verification of user allocated bitmap memory, added check of
   maximum size.
- Patches are on tag: next-20200318 and 1-3 patches from Yan's series
  https://lkml.org/lkml/2020/3/12/1255

v13 -> v14
- Added struct vfio_bitmap to kabi. updated structure
  vfio_iommu_type1_dirty_bitmap_get and vfio_iommu_type1_dma_unmap.
- All small changes suggested by Alex.
- Patches are on tag: next-20200318 and 1-3 patches from Yan's series
  https://lkml.org/lkml/2020/3/12/1255

v12 -> v13
- Changed bitmap allocation in vfio_iommu_type1 to per vfio_dma
- Changed VFIO_IOMMU_DIRTY_PAGES ioctl behaviour to be per vfio_dma range.
- Changed vfio_iommu_type1_dirty_bitmap structure to have separate data
  field.

v11 -> v12
- Changed bitmap allocation in vfio_iommu_type1.
- Remove atomicity of ref_count.
- Updated comments for migration device state structure about error
  reporting.
- Nit picks from v11 reviews

v10 -> v11
- Fix pin pages API to free vpfn if it is marked as unpinned tracking page.
- Added proposal to detect if IOMMU capable device calls external pin pages
  API to mark pages dirty.
- Nit picks from v10 reviews

v9 -> v10:
- Updated existing VFIO_IOMMU_UNMAP_DMA ioctl to get dirty pages bitmap
  during unmap while migration is active
- Added flag in VFIO_IOMMU_GET_INFO to indicate driver support dirty page
  tracking.
- If iommu_mapped, mark all pages dirty.
- Added unpinned pages tracking while migration is active.
- Updated comments for migration device state structure with bit
  combination table and state transition details.

v8 -> v9:
- Split patch set in 2 sets, Kernel and QEMU.
- Dirty pages bitmap is queried from IOMMU container rather than from
  vendor driver for per device. Added 2 ioctls to achieve this.

v7 -> v8:
- Updated comments for KABI
- Added BAR address validation check during PCI device's config space load
  as suggested by Dr. David Alan Gilbert.
- Changed vfio_migration_set_state() to set or clear device state flags.
- Some nit fixes.

v6 -> v7:
- Fix build failures.

v5 -> v6:
- Fix build failure.

v4 -> v5:
- Added decriptive comment about the sequence of access of members of
  structure vfio_device_migration_info to be followed based on Alex's
  suggestion
- Updated get dirty pages sequence.
- As per Cornelia Huck's suggestion, added callbacks to VFIODeviceOps to
  get_object, save_config and load_config.
- Fixed multiple nit picks.
- Tested live migration with multiple vfio device assigned to a VM.

v3 -> v4:
- Added one more bit for _RESUMING flag to be set explicitly.
- data_offset field is read-only for user space application.
- data_size is read for every iteration before reading data from migration,
  that is removed assumption that data will be till end of migration
  region.
- If vendor driver supports mappable sparsed region, map those region
  during setup state of save/load, similarly unmap those from cleanup
  routines.
- Handles race condition that causes data corruption in migration region
  during save device state by adding mutex and serialiaing save_buffer and
  get_dirty_pages routines.
- Skip called get_dirty_pages routine for mapped MMIO region of device.
- Added trace events.
- Split into multiple functional patches.

v2 -> v3:
- Removed enum of VFIO device states. Defined VFIO device state with 2
  bits.
- Re-structured vfio_device_migration_info to keep it minimal and defined
  action on read and write access on its members.

v1 -> v2:
- Defined MIGRATION region type and sub-type which should be used with
  region type capability.
- Re-structured vfio_device_migration_info. This structure will be placed
  at 0th offset of migration region.
- Replaced ioctl with read/write for trapped part of migration region.
- Added both type of access support, trapped or mmapped, for data section
  of the region.
- Moved PCI device functions to pci file.
- Added iteration to get dirty page bitmap until bitmap for all requested
  pages are copied.

Thanks,
Kirti


Kirti Wankhede (7):
  vfio: KABI for migration interface for device state
  vfio iommu: Remove atomicity of ref_count of pinned pages
  vfio iommu: Add ioctl definition for dirty pages tracking.
  vfio iommu: Implementation of ioctl for dirty pages tracking.
  vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
  vfio iommu: Adds flag to indicate dirty pages tracking capability
    support
  vfio: Selective dirty page tracking if IOMMU backed device pins pages

 drivers/vfio/vfio.c             |  13 +-
 drivers/vfio/vfio_iommu_type1.c | 421 ++++++++++++++++++++++++++++++++++++++--
 include/linux/vfio.h            |   4 +-
 include/uapi/linux/vfio.h       | 299 +++++++++++++++++++++++++++-
 4 files changed, 715 insertions(+), 22 deletions(-)

-- 
2.7.0

