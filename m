Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F544158CA5
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgBKKYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:24:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:32500 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728299AbgBKKYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 05:24:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 02:24:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="221889050"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 11 Feb 2020 02:24:29 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [RFC PATCH v3 8/9] vfio: header for vfio live migration region.
Date:   Tue, 11 Feb 2020 05:15:09 -0500
Message-Id: <20200211101509.21189-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211095727.20426-1-yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Header file copied from vfio live migration patch series v8. [1].

[1] https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05542.html

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/uapi/linux/vfio.h | 149 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 149 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..135a1d3fa111 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -306,6 +306,155 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_TYPE_CCW			(2)
 
+/* Migration region type and sub-type */
+#define VFIO_REGION_TYPE_MIGRATION          (3)
+#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
+
+/**
+ * Structure vfio_device_migration_info is placed at 0th offset of
+ * VFIO_REGION_SUBTYPE_MIGRATION region to get/set VFIO device related migration
+ * information. Field accesses from this structure are only supported at their
+ * native width and alignment, otherwise the result is undefined and vendor
+ * drivers should return an error.
+ *
+ * device_state: (read/write)
+ *      To indicate vendor driver the state VFIO device should be transitioned
+ *      to. If device state transition fails, write on this field return error.
+ *      It consists of 3 bits:
+ *      - If bit 0 set, indicates _RUNNING state. When its reset, that indicates
+ *        _STOPPED state. When device is changed to _STOPPED, driver should stop
+ *        device before write() returns.
+ *      - If bit 1 set, indicates _SAVING state.
+ *      - If bit 2 set, indicates _RESUMING state.
+ *      Bits 3 - 31 are reserved for future use. User should perform
+ *      read-modify-write operation on this field.
+ *      _SAVING and _RESUMING bits set at the same time is invalid state.
+ *
+ * pending bytes: (read only)
+ *      Number of pending bytes yet to be migrated from vendor driver
+ *
+ * data_offset: (read only)
+ *      User application should read data_offset in migration region from where
+ *      user application should read device data during _SAVING state or write
+ *      device data during _RESUMING state or read dirty pages bitmap. See below
+ *      for detail of sequence to be followed.
+ *
+ * data_size: (read/write)
+ *      User application should read data_size to get size of data copied in
+ *      migration region during _SAVING state and write size of data copied in
+ *      migration region during _RESUMING state.
+ *
+ * start_pfn: (write only)
+ *      Start address pfn to get bitmap of dirty pages from vendor driver duing
+ *      _SAVING state.
+ *
+ * page_size: (write only)
+ *      User application should write the page_size of pfn.
+ *
+ * total_pfns: (write only)
+ *      Total pfn count from start_pfn for which dirty bitmap is requested.
+ *
+ * copied_pfns: (read only)
+ *      pfn count for which dirty bitmap is copied to migration region.
+ *      Vendor driver should copy the bitmap with bits set only for pages to be
+ *      marked dirty in migration region.
+ *      - Vendor driver should return VFIO_DEVICE_DIRTY_PFNS_NONE if none of the
+ *        pages are dirty in requested range or rest of the range.
+ *      - Vendor driver should return VFIO_DEVICE_DIRTY_PFNS_ALL to mark all
+ *        pages dirty in the given range or rest of the range.
+ *      - Vendor driver should return pfn count for which bitmap is written in
+ *        the region.
+ *
+ * Migration region looks like:
+ *  ------------------------------------------------------------------
+ * |vfio_device_migration_info|    data section                      |
+ * |                          |     ///////////////////////////////  |
+ * ------------------------------------------------------------------
+ *   ^                              ^                             ^
+ *  offset 0-trapped part        data_offset                 data_size
+ *
+ * Data section is always followed by vfio_device_migration_info structure
+ * in the region, so data_offset will always be non-0. Offset from where data
+ * is copied is decided by kernel driver, data section can be trapped or
+ * mapped or partitioned, depending on how kernel driver defines data section.
+ * Data section partition can be defined as mapped by sparse mmap capability.
+ * If mmapped, then data_offset should be page aligned, where as initial section
+ * which contain vfio_device_migration_info structure might not end at offset
+ * which is page aligned.
+ * Data_offset can be same or different for device data and dirty pages bitmap.
+ * Vendor driver should decide whether to partition data section and how to
+ * partition the data section. Vendor driver should return data_offset
+ * accordingly.
+ *
+ * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy phase
+ * and for _SAVING device state or stop-and-copy phase:
+ * a. read pending_bytes. If pending_bytes > 0, go through below steps.
+ * b. read data_offset, indicates kernel driver to write data to staging buffer.
+ * c. read data_size, amount of data in bytes written by vendor driver in
+ *    migration region.
+ * d. read data_size bytes of data from data_offset in the migration region.
+ * e. process data.
+ * f. Loop through a to e.
+ *
+ * To copy system memory content during migration, vendor driver should be able
+ * to report system memory pages which are dirtied by that driver. For such
+ * dirty page reporting, user application should query for a range of GFNs
+ * relative to device address space (IOVA), then vendor driver should provide
+ * the bitmap of pages from this range which are dirtied by him through
+ * migration region where each bit represents a page and bit set to 1 represents
+ * that the page is dirty.
+ * User space application should take care of copying content of system memory
+ * for those pages.
+ *
+ * Steps to get dirty page bitmap:
+ * a. write start_pfn, page_size and total_pfns.
+ * b. read copied_pfns. Vendor driver should take one of the below action:
+ *     - Vendor driver should return VFIO_DEVICE_DIRTY_PFNS_NONE if driver
+ *       doesn't have any page to report dirty in given range or rest of the
+ *       range. Exit the loop.
+ *     - Vendor driver should return VFIO_DEVICE_DIRTY_PFNS_ALL to mark all
+ *       pages dirty for given range or rest of the range. User space
+ *       application mark all pages in the range as dirty and exit the loop.
+ *     - Vendor driver should return copied_pfns and provide bitmap for
+ *       copied_pfn in migration region.
+ * c. read data_offset, where vendor driver has written bitmap.
+ * d. read bitmap from the migration region from data_offset.
+ * e. Iterate through steps a to d while (total copied_pfns < total_pfns)
+ *
+ * Sequence to be followed while _RESUMING device state:
+ * While data for this device is available, repeat below steps:
+ * a. read data_offset from where user application should write data.
+ * b. write data of data_size to migration region from data_offset.
+ * c. write data_size which indicates vendor driver that data is written in
+ *    staging buffer.
+ *
+ * For user application, data is opaque. User should write data in the same
+ * order as received.
+ */
+
+struct vfio_device_migration_info {
+	__u32 device_state;         /* VFIO device state */
+#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
+#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
+#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
+#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
+				     VFIO_DEVICE_STATE_SAVING | \
+				     VFIO_DEVICE_STATE_RESUMING)
+#define VFIO_DEVICE_STATE_INVALID   (VFIO_DEVICE_STATE_SAVING | \
+				     VFIO_DEVICE_STATE_RESUMING)
+	__u32 reserved;
+	__u64 pending_bytes;
+	__u64 data_offset;
+	__u64 data_size;
+	__u64 start_pfn;
+	__u64 page_size;
+	__u64 total_pfns;
+	__u64 copied_pfns;
+#define VFIO_DEVICE_DIRTY_PFNS_NONE     (0)
+#define VFIO_DEVICE_DIRTY_PFNS_ALL      (~0ULL)
+} __attribute__((packed));
+
+
 /* sub-types for VFIO_REGION_TYPE_PCI_* */
 
 /* 8086 vendor PCI sub-types */
-- 
2.17.1

