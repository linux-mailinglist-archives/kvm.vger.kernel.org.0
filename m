Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076881233B8
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 18:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfLQRjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 12:39:49 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11828 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfLQRjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 12:39:48 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df912d80000>; Tue, 17 Dec 2019 09:39:36 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 17 Dec 2019 09:39:46 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 17 Dec 2019 09:39:46 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 17:39:45 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Dec 2019 17:39:38 +0000
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
        "Kirti Wankhede" <kwankhede@nvidia.com>
Subject: [PATCH v11 Kernel 1/6] vfio: KABI for migration interface for device state
Date:   Tue, 17 Dec 2019 22:40:46 +0530
Message-ID: <1576602651-15430-2-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576604377; bh=7AYRXh4LoclkN77ICtn3qTCw/alys5vsy9xwsNonWIk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=phuagMhXJzzoR9ii6XHePNemKQPtxo9DwZrXP6xc89c3Xz6eoxFdKA1ok9NddJ3Re
         cEXNBFozcfrF9sdIVvnmW1JiAY6D+XPMVvCSjFoA+SG4eu2rjt8AhQATeHoIULqCtm
         CK5oYxc+r1S3UagIvZlWKEVRszVn/D/xnZy/u8sJFuGz5hskIPh8GZeO25fz0USESA
         XIlN2zfBSa2NhzxImaWZyRaeGJpy6mWKnIfHwEdfsyxPIJQamzy8XXM+PLCSrXEq1x
         LBKTpqxdMpb8N+ZvEgZXVUevFVIIOGunY2nKRWd2wXpN+ufvp1LIaYACRlSxaTD/E+
         ewBw5LgKnBbFg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Defined MIGRATION region type and sub-type.

- Defined vfio_device_migration_info structure which will be placed at 0th
  offset of migration region to get/set VFIO device related information.
  Defined members of structure and usage on read/write access.

- Defined device states and added state transition details in the comment.

- Added sequence to be followed while saving and resuming VFIO device state

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 include/uapi/linux/vfio.h | 187 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..b7ac8f7c0d3c 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -305,6 +305,7 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_TYPE_CCW			(2)
+#define VFIO_REGION_TYPE_MIGRATION              (3)
 
 /* sub-types for VFIO_REGION_TYPE_PCI_* */
 
@@ -379,6 +380,192 @@ struct vfio_region_gfx_edid {
 /* sub-types for VFIO_REGION_TYPE_CCW */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
 
+/* sub-types for VFIO_REGION_TYPE_MIGRATION */
+#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
+
+/*
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
+ *      - If bit 0 set, indicates _RUNNING state. When it's clear, that
+ *	  indicates _STOP state. When device is changed to _STOP, driver should
+ *	  stop device before write() returns.
+ *      - If bit 1 set, indicates _SAVING state. When set, that indicates driver
+ *        should start gathering device state information which will be provided
+ *        to VFIO user space application to save device's state.
+ *      - If bit 2 set, indicates _RESUMING state. When set, that indicates
+ *        prepare to resume device, data provided through migration region
+ *        should be used to resume device.
+ *      Bits 3 - 31 are reserved for future use. User should perform
+ *      read-modify-write operation on this field.
+ *
+ *  +------- _RESUMING
+ *  |+------ _SAVING
+ *  ||+----- _RUNNING
+ *  |||
+ *  000b => Device Stopped, not saving or resuming
+ *  001b => Device running state, default state
+ *  010b => Stop Device & save device state, stop-and-copy state
+ *  011b => Device running and save device state, pre-copy state
+ *  100b => Device stopped and device state is resuming
+ *  101b => Invalid state
+ *  110b => Invalid state
+ *  111b => Invalid state
+ *
+ * State transitions:
+ *
+ *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
+ *                (100b)     (001b)     (011b)        (010b)       (000b)
+ * 0. Running or Default state
+ *                             |
+ *
+ * 1. Normal Shutdown (optional)
+ *                             |------------------------------------->|
+ *
+ * 2. Save state or Suspend
+ *                             |------------------------->|---------->|
+ *
+ * 3. Save state during live migration
+ *                             |----------->|------------>|---------->|
+ *
+ * 4. Resuming
+ *                  |<---------|
+ *
+ * 5. Resumed
+ *                  |--------->|
+ *
+ * 0. Default state of VFIO device is _RUNNNG when VFIO application starts.
+ * 1. During normal VFIO application shutdown, vfio device state changes
+ *    from _RUNNING to _STOP. This is optional, user space application may or
+ *    may not perform this state transition and vendor driver may not need.
+ * 2. When VFIO application save state or suspend application, VFIO device
+ *    state transition is from _RUNNING to stop-and-copy state and then to
+ *    _STOP.
+ *    On state transition from _RUNNING to stop-and-copy, driver must
+ *    stop device, save device state and send it to application through
+ *    migration region.
+ *    On _RUNNING to stop-and-copy state transition failure, application should
+ *    set VFIO device state to _RUNNING.
+ * 3. In VFIO application live migration, state transition is from _RUNNING
+ *    to pre-copy to stop-and-copy to _STOP.
+ *    On state transition from _RUNNING to pre-copy, driver should start
+ *    gathering device state while application is still running and send device
+ *    state data to application through migration region.
+ *    On state transition from pre-copy to stop-and-copy, driver must stop
+ *    device, save device state and send it to application through migration
+ *    region.
+ *    On any failure during any of these state transition, VFIO device state
+ *    should be set to _RUNNING.
+ * 4. To start resuming phase, VFIO device state should be transitioned from
+ *    _RUNNING to _RESUMING state.
+ *    In _RESUMING state, driver should use received device state data through
+ *    migration region to resume device.
+ *    On failure during this state transition, application should set _RUNNING
+ *    state.
+ * 5. On providing saved device data to driver, appliation should change state
+ *    from _RESUMING to _RUNNING.
+ *    On failure to transition to _RUNNING state, VFIO application should reset
+ *    the device and set _RUNNING state so that device doesn't remain in unknown
+ *    or bad state. On reset, driver must reset device and device should be
+ *    available in default initial state, _RUNNING.
+ *
+ * pending bytes: (read only)
+ *      Number of pending bytes yet to be migrated from vendor driver
+ *
+ * data_offset: (read only)
+ *      User application should read data_offset in migration region from where
+ *      user application should read device data during _SAVING state or write
+ *      device data during _RESUMING state. See below for detail of sequence to
+ *      be followed.
+ *
+ * data_size: (read/write)
+ *      User application should read data_size to get size of data copied in
+ *      bytes in migration region during _SAVING state and write size of data
+ *      copied in bytes in migration region during _RESUMING state.
+ *
+ * Migration region looks like:
+ *  ------------------------------------------------------------------
+ * |vfio_device_migration_info|    data section                      |
+ * |                          |     ///////////////////////////////  |
+ * ------------------------------------------------------------------
+ *   ^                              ^
+ *  offset 0-trapped part        data_offset
+ *
+ * Structure vfio_device_migration_info is always followed by data section in
+ * the region, so data_offset will always be non-0. Offset from where data is
+ * copied is decided by kernel driver, data section can be trapped or mapped
+ * or partitioned, depending on how kernel driver defines data section.
+ * Data section partition can be defined as mapped by sparse mmap capability.
+ * If mmapped, then data_offset should be page aligned, where as initial section
+ * which contain vfio_device_migration_info structure might not end at offset
+ * which is page aligned. The user is not required to access via mmap regardless
+ * of the region mmap capabilities.
+ * Vendor driver should decide whether to partition data section and how to
+ * partition the data section. Vendor driver should return data_offset
+ * accordingly.
+ *
+ * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy phase
+ * and for _SAVING device state or stop-and-copy phase:
+ * a. read pending_bytes, indicates start of new iteration to get device data.
+ *    If pending_bytes > 0, go through below steps.
+ * b. read data_offset, indicates kernel driver to make data available through
+ *    data section. Kernel driver should return this read operation only after
+ *    data is available from (region + data_offset) to (region + data_offset +
+ *    data_size).
+ * c. read data_size, amount of data in bytes available through migration
+ *    region.
+ * d. read data of data_size bytes from (region + data_offset) from migration
+ *    region.
+ * e. process data.
+ * f. read pending_bytes, this read operation indicates data from previous
+ *    iteration had read. If pending_bytes > 0, goto step b.
+ *
+ * User can transition from _SAVING|_RUNNING (pre-copy state) to _SAVING
+ * (stop-and-copy) state regardless of pending bytes.
+ * User should iterate in _SAVING (stop-and-copy) until pending_bytes is 0.
+ *
+ * Sequence to be followed while _RESUMING device state:
+ * While data for this device is available, repeat below steps:
+ * a. read data_offset from where user application should write data.
+ * b. write data of data_size to migration region from data_offset. Data size
+ *    could be data packet size at source during _SAVING or migration region
+ *    data section size which ever is less.
+ * c. write data_size which indicates vendor driver that data is written in
+ *    staging buffer. Vendor driver should read this data from migration
+ *    region and resume device's state.
+ *
+ * For user application, data is opaque. User should write data in the same
+ * order as received.
+ */
+
+struct vfio_device_migration_info {
+	__u32 device_state;         /* VFIO device state */
+#define VFIO_DEVICE_STATE_STOP      (0)
+#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
+#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
+#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
+#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
+				     VFIO_DEVICE_STATE_SAVING |  \
+				     VFIO_DEVICE_STATE_RESUMING)
+
+#define VFIO_DEVICE_STATE_INVALID_CASE1    (VFIO_DEVICE_STATE_SAVING | \
+					    VFIO_DEVICE_STATE_RESUMING)
+
+#define VFIO_DEVICE_STATE_INVALID_CASE2    (VFIO_DEVICE_STATE_RUNNING | \
+					    VFIO_DEVICE_STATE_RESUMING)
+	__u32 reserved;
+	__u64 pending_bytes;
+	__u64 data_offset;
+	__u64 data_size;
+} __attribute__((packed));
+
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
  * which allows direct access to non-MSIX registers which happened to be within
-- 
2.7.0

