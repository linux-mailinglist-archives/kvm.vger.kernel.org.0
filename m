Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F37318AA4D
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 02:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgCSB0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 21:26:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:52159 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSB0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 21:26:40 -0400
IronPort-SDR: 67GvSidWLQUPhnSeih/T8HzhRFt5sDBT46jALzrSYeNqjfYI9zwyMR9M1/OSHms9koRPJ5Gylp
 bUxjCnRe4M+g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:26:37 -0700
IronPort-SDR: myUd6AGo14ImczSNYOjQ3J9JIp0T505rjFM+l8WRkb0P7jGVg85hWWQ8Vzf3c25p7PgMMUSsgO
 sHYki/SW80Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="391641101"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 18 Mar 2020 18:26:32 -0700
Date:   Wed, 18 Mar 2020 21:17:03 -0400
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
Subject: Re: [PATCH v14 Kernel 1/7] vfio: KABI for migration interface for
 device state
Message-ID: <20200319011703.GC4641@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-2-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584560474-19946-2-git-send-email-kwankhede@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 03:41:08AM +0800, Kirti Wankhede wrote:
> - Defined MIGRATION region type and sub-type.
> 
> - Defined vfio_device_migration_info structure which will be placed at the
>   0th offset of migration region to get/set VFIO device related
>   information. Defined members of structure and usage on read/write access.
> 
> - Defined device states and state transition details.
> 
> - Defined sequence to be followed while saving and resuming VFIO device.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 227 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 227 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..d0021467af53 100644
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
> @@ -379,6 +380,232 @@ struct vfio_region_gfx_edid {
>  /* sub-types for VFIO_REGION_TYPE_CCW */
>  #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
>  
> +/* sub-types for VFIO_REGION_TYPE_MIGRATION */
> +#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
> +
> +/*
> + * The structure vfio_device_migration_info is placed at the 0th offset of
> + * the VFIO_REGION_SUBTYPE_MIGRATION region to get and set VFIO device related
> + * migration information. Field accesses from this structure are only supported
> + * at their native width and alignment. Otherwise, the result is undefined and
> + * vendor drivers should return an error.
> + *
> + * device_state: (read/write)
> + *      - The user application writes to this field to inform the vendor driver
> + *        about the device state to be transitioned to.
> + *      - The vendor driver should take the necessary actions to change the
> + *        device state. After successful transition to a given state, the
> + *        vendor driver should return success on write(device_state, state)
> + *        system call. If the device state transition fails, the vendor driver
> + *        should return an appropriate -errno for the fault condition.
> + *      - On the user application side, if the device state transition fails,
> + *	  that is, if write(device_state, state) returns an error, read
> + *	  device_state again to determine the current state of the device from
> + *	  the vendor driver.
> + *      - The vendor driver should return previous state of the device unless
> + *        the vendor driver has encountered an internal error, in which case
> + *        the vendor driver may report the device_state VFIO_DEVICE_STATE_ERROR.
> + *      - The user application must use the device reset ioctl to recover the
> + *        device from VFIO_DEVICE_STATE_ERROR state. If the device is
> + *        indicated to be in a valid device state by reading device_state, the
> + *        user application may attempt to transition the device to any valid
> + *        state reachable from the current state or terminate itself.
> + *
> + *      device_state consists of 3 bits:
> + *      - If bit 0 is set, it indicates the _RUNNING state. If bit 0 is clear,
> + *        it indicates the _STOP state. When the device state is changed to
> + *        _STOP, driver should stop the device before write() returns.
> + *      - If bit 1 is set, it indicates the _SAVING state, which means that the
> + *        driver should start gathering device state information that will be
> + *        provided to the VFIO user application to save the device's state.
> + *      - If bit 2 is set, it indicates the _RESUMING state, which means that
> + *        the driver should prepare to resume the device. Data provided through
> + *        the migration region should be used to resume the device.
> + *      Bits 3 - 31 are reserved for future use. To preserve them, the user
> + *      application should perform a read-modify-write operation on this
> + *      field when modifying the specified bits.
> + *
> + *  +------- _RESUMING
> + *  |+------ _SAVING
> + *  ||+----- _RUNNING
> + *  |||
> + *  000b => Device Stopped, not saving or resuming
> + *  001b => Device running, which is the default state
> + *  010b => Stop the device & save the device state, stop-and-copy state
> + *  011b => Device running and save the device state, pre-copy state
> + *  100b => Device stopped and the device state is resuming
> + *  101b => Invalid state
> + *  110b => Error state
> + *  111b => Invalid state
> + *
> + * State transitions:
> + *
> + *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
> + *                (100b)     (001b)     (011b)        (010b)       (000b)
> + * 0. Running or default state
> + *                             |
> + *
> + * 1. Normal Shutdown (optional)
> + *                             |------------------------------------->|
> + *
> + * 2. Save the state or suspend
> + *                             |------------------------->|---------->|
> + *
> + * 3. Save the state during live migration
> + *                             |----------->|------------>|---------->|
> + *
> + * 4. Resuming
> + *                  |<---------|
> + *
> + * 5. Resumed
> + *                  |--------->|
> + *
> + * 0. Default state of VFIO device is _RUNNNG when the user application starts.
> + * 1. During normal shutdown of the user application, the user application may
> + *    optionally change the VFIO device state from _RUNNING to _STOP. This
> + *    transition is optional. The vendor driver must support this transition but
> + *    must not require it.
> + * 2. When the user application saves state or suspends the application, the
> + *    device state transitions from _RUNNING to stop-and-copy and then to _STOP.
> + *    On state transition from _RUNNING to stop-and-copy, driver must stop the
> + *    device, save the device state and send it to the application through the
> + *    migration region. The sequence to be followed for such transition is given
> + *    below.
> + * 3. In live migration of user application, the state transitions from _RUNNING
> + *    to pre-copy, to stop-and-copy, and to _STOP.
> + *    On state transition from _RUNNING to pre-copy, the driver should start
> + *    gathering the device state while the application is still running and send
> + *    the device state data to application through the migration region.
> + *    On state transition from pre-copy to stop-and-copy, the driver must stop
> + *    the device, save the device state and send it to the user application
> + *    through the migration region.
> + *    Vendor drivers must support the pre-copy state even for implementations
> + *    where no data is provided to the user before the stop-and-copy state. The
> + *    user must not be required to consume all migration data before the device
> + *    transitions to a new state, including the stop-and-copy state.
> + *    The sequence to be followed for above two transitions is given below.
> + * 4. To start the resuming phase, the device state should be transitioned from
> + *    the _RUNNING to the _RESUMING state.
> + *    In the _RESUMING state, the driver should use the device state data
> + *    received through the migration region to resume the device.
> + * 5. After providing saved device data to the driver, the application should
> + *    change the state from _RESUMING to _RUNNING.
> + *
> + * reserved:
> + *      Reads on this field return zero and writes are ignored.
> + *
> + * pending_bytes: (read only)
> + *      The number of pending bytes still to be migrated from the vendor driver.
> + *
> + * data_offset: (read only)
> + *      The user application should read data_offset in the migration region
> + *      from where the user application should read the device data during the
> + *      _SAVING state or write the device data during the _RESUMING state. See
> + *      below for details of sequence to be followed.
> + *
> + * data_size: (read/write)
> + *      The user application should read data_size to get the size in bytes of
> + *      the data copied in the migration region during the _SAVING state and
> + *      write the size in bytes of the data copied in the migration region
> + *      during the _RESUMING state.
> + *
> + * The format of the migration region is as follows:
> + *  ------------------------------------------------------------------
> + * |vfio_device_migration_info|    data section                      |
> + * |                          |     ///////////////////////////////  |
> + * ------------------------------------------------------------------
> + *   ^                              ^
> + *  offset 0-trapped part        data_offset
> + *
> + * The structure vfio_device_migration_info is always followed by the data
> + * section in the region, so data_offset will always be nonzero. The offset
> + * from where the data is copied is decided by the kernel driver. The data
> + * section can be trapped, mapped, or partitioned, depending on how the kernel
> + * driver defines the data section. The data section partition can be defined
> + * as mapped by the sparse mmap capability. If mmapped, data_offset should be
> + * page aligned, whereas initial section which contains the
> + * vfio_device_migration_info structure, might not end at the offset, which is
> + * page aligned. The user is not required to access through mmap regardless
> + * of the capabilities of the region mmap.
> + * The vendor driver should determine whether and how to partition the data
> + * section. The vendor driver should return data_offset accordingly.
> + *
> + * The sequence to be followed for the _SAVING|_RUNNING device state or
> + * pre-copy phase and for the _SAVING device state or stop-and-copy phase is as
> + * follows:
> + * a. Read pending_bytes, indicating the start of a new iteration to get device
> + *    data. Repeated read on pending_bytes at this stage should have no side
> + *    effects.
> + *    If pending_bytes == 0, the user application should not iterate to get data
> + *    for that device.
> + *    If pending_bytes > 0, perform the following steps.
> + * b. Read data_offset, indicating that the vendor driver should make data
> + *    available through the data section. The vendor driver should return this
> + *    read operation only after data is available from (region + data_offset)
> + *    to (region + data_offset + data_size).
> + * c. Read data_size, which is the amount of data in bytes available through
> + *    the migration region.
> + *    Read on data_offset and data_size should return the offset and size of
> + *    the current buffer if the user application reads data_offset and
> + *    data_size more than once here.
If data region is mmaped, merely reading data_offset and data_size
cannot let kernel know what are correct values to return.
Consider to add a read operation which is trapped into kernel to let
kernel exactly know it needs to move to the next offset and update data_size
?

> + * d. Read data_size bytes of data from (region + data_offset) from the
> + *    migration region.
> + * e. Process the data.
> + * f. Read pending_bytes, which indicates that the data from the previous
> + *    iteration has been read. If pending_bytes > 0, go to step b.
> + *
> + * If an error occurs during the above sequence, the vendor driver can return
> + * an error code for next read() or write() operation, which will terminate the
> + * loop. The user application should then take the next necessary action, for
> + * example, failing migration or terminating the user application.
> + *
> + * The user application can transition from the _SAVING|_RUNNING
> + * (pre-copy state) to the _SAVING (stop-and-copy) state regardless of the
> + * number of pending bytes. The user application should iterate in _SAVING
> + * (stop-and-copy) until pending_bytes is 0.
> + *
> + * The sequence to be followed while _RESUMING device state is as follows:
> + * While data for this device is available, repeat the following steps:
> + * a. Read data_offset from where the user application should write data.
> + * b. Write migration data starting at the migration region + data_offset for
> + *    the length determined by data_size from the migration source.
> + * c. Write data_size, which indicates to the vendor driver that data is
> + *    written in the migration region. Vendor driver should apply the
> + *    user-provided migration region data to the device resume state.
> + *
> + * For the user application, data is opaque. The user application should write
> + * data in the same order as the data is received and the data should be of
> + * same transaction size at the source.
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
> +#define VFIO_DEVICE_STATE_IS_ERROR(state) \
> +	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
> +					      VFIO_DEVICE_STATE_RESUMING))
> +
> +#define VFIO_DEVICE_STATE_SET_ERROR(state) \
> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> +					     VFIO_DEVICE_STATE_RESUMING)
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
