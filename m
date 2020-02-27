Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37401713B3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 10:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgB0JH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 04:07:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:40212 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728504AbgB0JH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 04:07:59 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 01:07:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,491,1574150400"; 
   d="scan'208";a="261402058"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004.fm.intel.com with ESMTP; 27 Feb 2020 01:07:54 -0800
Date:   Thu, 27 Feb 2020 03:58:30 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v12 Kernel 1/7] vfio: KABI for migration interface for
 device state
Message-ID: <20200227085830.GG30338@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
 <1581104554-10704-2-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581104554-10704-2-git-send-email-kwankhede@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 08, 2020 at 03:42:28AM +0800, Kirti Wankhede wrote:
> - Defined MIGRATION region type and sub-type.
> 
> - Defined vfio_device_migration_info structure which will be placed at 0th
>   offset of migration region to get/set VFIO device related information.
>   Defined members of structure and usage on read/write access.
> 
> - Defined device states and state transition details.
> 
> - Defined sequence to be followed while saving and resuming VFIO device.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 208 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 208 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..572242620ce9 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -305,6 +305,7 @@ struct vfio_region_info_cap_type {
>  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
>  #define VFIO_REGION_TYPE_GFX                    (1)
>  #define VFIO_REGION_TYPE_CCW			(2)
> +#define VFIO_REGION_TYPE_MIGRATION              (3)
>  
>  /* sub-types for VFIO_REGION_TYPE_PCI_* */
>  
> @@ -379,6 +380,213 @@ struct vfio_region_gfx_edid {
>  /* sub-types for VFIO_REGION_TYPE_CCW */
>  #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
>  
> +/* sub-types for VFIO_REGION_TYPE_MIGRATION */
> +#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
> +
> +/*
> + * Structure vfio_device_migration_info is placed at 0th offset of
> + * VFIO_REGION_SUBTYPE_MIGRATION region to get/set VFIO device related migration
> + * information. Field accesses from this structure are only supported at their
> + * native width and alignment, otherwise the result is undefined and vendor
> + * drivers should return an error.
> + *
> + * device_state: (read/write)
> + *      - User application writes this field to inform vendor driver about the
> + *        device state to be transitioned to.
> + *      - Vendor driver should take necessary actions to change device state.
> + *        On successful transition to given state, vendor driver should return
> + *        success on write(device_state, state) system call. If device state
> + *        transition fails, vendor driver should return error, -EFAULT.
> + *      - On user application side, if device state transition fails, i.e. if
> + *        write(device_state, state) returns error, read device_state again to
> + *        determine the current state of the device from vendor driver.
> + *      - Vendor driver should return previous state of the device unless vendor
> + *        driver has encountered an internal error, in which case vendor driver
> + *        may report the device_state VFIO_DEVICE_STATE_ERROR.
> + *	- User application must use the device reset ioctl in order to recover
> + *	  the device from VFIO_DEVICE_STATE_ERROR state. If the device is
> + *	  indicated in a valid device state via reading device_state, the user
> + *	  application may decide attempt to transition the device to any valid
> + *	  state reachable from the current state or terminate itself.
> + *
> + *      device_state consists of 3 bits:
> + *      - If bit 0 set, indicates _RUNNING state. When it's clear, that
> + *	  indicates _STOP state. When device is changed to _STOP, driver should
> + *	  stop device before write() returns.
> + *      - If bit 1 set, indicates _SAVING state. When set, that indicates driver
> + *        should start gathering device state information which will be provided
> + *        to VFIO user application to save device's state.
> + *      - If bit 2 set, indicates _RESUMING state. When set, that indicates
> + *        prepare to resume device, data provided through migration region
> + *        should be used to resume device.
> + *      Bits 3 - 31 are reserved for future use. In order to preserve them,
> + *	user application should perform read-modify-write operation on this
> + *	field when modifying the specified bits.
> + *
> + *  +------- _RESUMING
> + *  |+------ _SAVING
> + *  ||+----- _RUNNING
> + *  |||
> + *  000b => Device Stopped, not saving or resuming
> + *  001b => Device running state, default state
> + *  010b => Stop Device & save device state, stop-and-copy state
> + *  011b => Device running and save device state, pre-copy state
> + *  100b => Device stopped and device state is resuming
> + *  101b => Invalid state
> + *  110b => Error state
> + *  111b => Invalid state
> + *
> + * State transitions:
> + *
> + *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
> + *                (100b)     (001b)     (011b)        (010b)       (000b)
> + * 0. Running or Default state
> + *                             |
> + *
> + * 1. Normal Shutdown (optional)
> + *                             |------------------------------------->|
> + *
> + * 2. Save state or Suspend
> + *                             |------------------------->|---------->|
> + *
> + * 3. Save state during live migration
> + *                             |----------->|------------>|---------->|
> + *
> + * 4. Resuming
> + *                  |<---------|
> + *
> + * 5. Resumed
> + *                  |--------->|
> + *
> + * 0. Default state of VFIO device is _RUNNNG when user application starts.
> + * 1. During normal user application shutdown, vfio device state changes
> + *    from _RUNNING to _STOP. This is optional, user application may or may not
> + *    perform this state transition and vendor driver may not need.
> + * 2. When user application save state or suspend application, device state
> + *    transitions from _RUNNING to stop-and-copy state and then to _STOP.
> + *    On state transition from _RUNNING to stop-and-copy, driver must
> + *    stop device, save device state and send it to application through
> + *    migration region. Sequence to be followed for such transition is given
> + *    below.
> + * 3. In user application live migration, state transitions from _RUNNING
> + *    to pre-copy to stop-and-copy to _STOP.
> + *    On state transition from _RUNNING to pre-copy, driver should start
> + *    gathering device state while application is still running and send device
> + *    state data to application through migration region.
> + *    On state transition from pre-copy to stop-and-copy, driver must stop
> + *    device, save device state and send it to user application through
> + *    migration region.
> + *    Sequence to be followed for above two transitions is given below.
> + * 4. To start resuming phase, device state should be transitioned from
> + *    _RUNNING to _RESUMING state.
> + *    In _RESUMING state, driver should use received device state data through
> + *    migration region to resume device.
> + * 5. On providing saved device data to driver, application should change state
> + *    from _RESUMING to _RUNNING.
> + *
> + * pending bytes: (read only)
> + *      Number of pending bytes yet to be migrated from vendor driver
> + *
> + * data_offset: (read only)
> + *      User application should read data_offset in migration region from where
> + *      user application should read device data during _SAVING state or write
> + *      device data during _RESUMING state. See below for detail of sequence to
> + *      be followed.
> + *
> + * data_size: (read/write)
> + *      User application should read data_size to get size of data copied in
> + *      bytes in migration region during _SAVING state and write size of data
> + *      copied in bytes in migration region during _RESUMING state.
> + *
> + * Migration region looks like:
> + *  ------------------------------------------------------------------
> + * |vfio_device_migration_info|    data section                      |
> + * |                          |     ///////////////////////////////  |
> + * ------------------------------------------------------------------
> + *   ^                              ^
> + *  offset 0-trapped part        data_offset
> + *
> + * Structure vfio_device_migration_info is always followed by data section in
> + * the region, so data_offset will always be non-0. Offset from where data is
> + * copied is decided by kernel driver, data section can be trapped or mapped
> + * or partitioned, depending on how kernel driver defines data section.
> + * Data section partition can be defined as mapped by sparse mmap capability.
> + * If mmapped, then data_offset should be page aligned, where as initial section
> + * which contain vfio_device_migration_info structure might not end at offset
> + * which is page aligned. The user is not required to access via mmap regardless
> + * of the region mmap capabilities.
> + * Vendor driver should decide whether to partition data section and how to
> + * partition the data section. Vendor driver should return data_offset
> + * accordingly.
> + *
> + * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy phase
> + * and for _SAVING device state or stop-and-copy phase:
> + * a. read pending_bytes, indicates start of new iteration to get device data.
> + *    Repeatative read on pending_bytes at this stage should have no side
> + *    effect.
if the data section is mmaped into user space, vendor driver is not able
to know when user application has finished reading of the data.
so, if user application reads pending_bytes repeatedly, vendor
driver actually does not know what value to return except by making
assumption that reading of data_size is a sign of data reading,
which is somewhat strange, as data_size is read before reading data.

e.g. vendor driver actually does not know how to handle below sequence
1. read pending_bytes
2. read data_offset
3. read pending_bytes
4. read data_size

and what if user space reads in below sequence but never launches a real
reading of data?
1. read pending_bytes
2. read data_offset
3. read data_size

Thanks
Yan
 
> + *    If pending_bytes == 0, user application should not iterate to get data
> + *    for that device.
> + *    If pending_bytes > 0, go through below steps.
> + * b. read data_offset, indicates vendor driver to make data available through
> + *    data section. Vendor driver should return this read operation only after
> + *    data is available from (region + data_offset) to (region + data_offset +
> + *    data_size).
> + * c. read data_size, amount of data in bytes available through migration
> + *    region.
> + *    Read on data_offset and data_size should return offset and size of current
> + *    buffer if user application reads those more than once here.
> + * d. read data of data_size bytes from (region + data_offset) from migration
> + *    region.
> + * e. process data.
> + * f. read pending_bytes, this read operation indicates data from previous
> + *    iteration had read. If pending_bytes > 0, goto step b.
> + *
> + * If there is any error during the above sequence, vendor driver can return
> + * error code for next read()/write() operation, that will terminate the loop
> + * and user should take next necessary action, for example, fail migration or
> + * terminate user application.
> + *
> + * User application can transition from _SAVING|_RUNNING (pre-copy state) to
> + * _SAVING (stop-and-copy) state regardless of pending bytes.
> + * User application should iterate in _SAVING (stop-and-copy) until
> + * pending_bytes is 0.
> + *
> + * Sequence to be followed while _RESUMING device state:
> + * While data for this device is available, repeat below steps:
> + * a. read data_offset from where user application should write data.
> + * b. write data of data_size to migration region from data_offset. Data size
> + *    should be data packet size at source during _SAVING.
> + * c. write data_size which indicates vendor driver that data is written in
> + *    migration region. Vendor driver should read this data from migration
> + *    region and resume device's state.
> + *
> + * For user application, data is opaque. User application should write data in
> + * the same order as received and should of same transaction size at source.
> + */
> +
> +struct vfio_device_migration_info {
> +	__u32 device_state;         /* VFIO device state */
> +#define VFIO_DEVICE_STATE_STOP      (0)
> +#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> +#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> +#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
> +				     VFIO_DEVICE_STATE_SAVING |  \
> +				     VFIO_DEVICE_STATE_RESUMING)
> +
> +#define VFIO_DEVICE_STATE_VALID(state) \
> +	(state & VFIO_DEVICE_STATE_RESUMING ? \
> +	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
> +
> +#define VFIO_DEVICE_STATE_ERROR			\
> +		(VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RESUMING)
> +
> +	__u32 reserved;
> +	__u64 pending_bytes;
> +	__u64 data_offset;
> +	__u64 data_size;
> +} __attribute__((packed));
> +
>  /*
>   * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
>   * which allows direct access to non-MSIX registers which happened to be within
> -- 
> 2.7.0
> 
