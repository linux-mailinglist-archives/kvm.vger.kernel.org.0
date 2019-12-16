Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1588E121E86
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 23:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfLPWoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 17:44:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726448AbfLPWoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 17:44:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576536255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j28Lf3V1YDisZV22otE5P/GjWqvTpihlGzpsTc7ig3A=;
        b=d/orIeb/dI2jFhyi6SzK4dOL6xs5M3FpXKg5U7RDQGDkjEaKHYHBUHDAohBAKzJYw6r8tj
        jaln1XgSkwlNDHgtp7r9qEGav3TI/hh0ihUhpa/afQ9KxWhjjD5Up5FMaCSzZgI/AT+VEi
        N+BTzpQIC6f91pxWDXtwxoLpFTXHz7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-MboKfcO-NdWDIcW5uT3BiA-1; Mon, 16 Dec 2019 17:44:11 -0500
X-MC-Unique: MboKfcO-NdWDIcW5uT3BiA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33126DB20;
        Mon, 16 Dec 2019 22:44:09 +0000 (UTC)
Received: from x1.home (ovpn-116-53.phx2.redhat.com [10.3.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7F5760BE0;
        Mon, 16 Dec 2019 22:44:06 +0000 (UTC)
Date:   Mon, 16 Dec 2019 15:44:06 -0700
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
Subject: Re: [PATCH v10 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20191216154406.023f912b@x1.home>
In-Reply-To: <1576527700-21805-2-git-send-email-kwankhede@nvidia.com>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
        <1576527700-21805-2-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Dec 2019 01:51:36 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> - Defined MIGRATION region type and sub-type.
> 
> - Defined vfio_device_migration_info structure which will be placed at 0th
>   offset of migration region to get/set VFIO device related information.
>   Defined members of structure and usage on read/write access.
> 
> - Defined device states and added state transition details in the comment.
> 
> - Added sequence to be followed while saving and resuming VFIO device state
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 180 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 180 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..a0817ba267c1 100644
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
> @@ -379,6 +380,185 @@ struct vfio_region_gfx_edid {
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
> + *      To indicate vendor driver the state VFIO device should be transitioned
> + *      to. If device state transition fails, write on this field return error.
> + *      It consists of 3 bits:
> + *      - If bit 0 set, indicates _RUNNING state. When its clear, that indicates

s/its/it's/

> + *        _STOP state. When device is changed to _STOP, driver should stop
> + *        device before write() returns.
> + *      - If bit 1 set, indicates _SAVING state. When set, that indicates driver
> + *        should start gathering device state information which will be provided
> + *        to VFIO user space application to save device's state.
> + *      - If bit 2 set, indicates _RESUMING state. When set, that indicates
> + *        prepare to resume device, data provided through migration region
> + *        should be used to resume device.
> + *      Bits 3 - 31 are reserved for future use. User should perform
> + *      read-modify-write operation on this field.
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

Eventually this would be intended for post-copy, if supported by the
device, right?

> + *  110b => Invalid state
> + *  111b => Invalid state
> + *
> + * State transitions:
> + *
> + *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
> + *                (100b)     (001b)     (011b)        (010b)       (000b)
> + * 0. Running or Default state
> + *                             |
> + *
> + * 1. Normal Shutdown

Optional, userspace is under no obligation.

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
> + * 0. Default state of VFIO device is _RUNNNG when VFIO application starts.
> + * 1. During normal VFIO application shutdown, vfio device state changes
> + *    from _RUNNING to _STOP.

We cannot impose this requirement on existing userspace.  Userspace may
perform this action, but they are not required to and the vendor driver
must not require it.

> + * 2. When VFIO application save state or suspend application, VFIO device
> + *    state transition is from _RUNNING to stop-and-copy state and then to
> + *    _STOP.
> + *    On state transition from _RUNNING to stop-and-copy, driver must
> + *    stop device, save device state and send it to application through
> + *    migration region.
> + *    On _RUNNING to stop-and-copy state transition failure, application should
> + *    set VFIO device state to _RUNNING.

A state transition failure means that the user's write to device_state
failed, so is it the user's responsibility to set the next state?  Why
is it necessarily _RUNNING vs _STOP?

> + * 3. In VFIO application live migration, state transition is from _RUNNING
> + *    to pre-copy to stop-and-copy to _STOP.
> + *    On state transition from _RUNNING to pre-copy, driver should start
> + *    gathering device state while application is still running and send device
> + *    state data to application through migration region.
> + *    On state transition from pre-copy to stop-and-copy, driver must stop
> + *    device, save device state and send it to application through migration
> + *    region.
> + *    On any failure during any of these state transition, VFIO device state
> + *    should be set to _RUNNING.

Same comment as above regarding next state on failure.

Also, it seems like it's the vendor driver's discretion to actually
provide data during the pre-copy phase.  As we've defined it, the
vendor driver needs to participate in the migration region regardless,
they might just always report no pending_bytes until we enter
stop-and-copy.

> + * 4. To start resuming phase, VFIO device state should be transitioned from
> + *    _RUNNING to _RESUMING state.
> + *    In _RESUMING state, driver should use received device state data through
> + *    migration region to resume device.
> + *    On failure during this state transition, application should set _RUNNING
> + *    state.

Same comment regarding setting next state after failure.

> + * 5. On providing saved device data to driver, appliation should change state
> + *    from _RESUMING to _RUNNING.
> + *    On failure to transition to _RUNNING state, VFIO application should reset
> + *    the device and set _RUNNING state so that device doesn't remain in unknown
> + *    or bad state. On reset, driver must reset device and device should be
> + *    available in default usable state.

Didn't we discuss that the reset ioctl should return the device to the
initial state, including the transition to _RUNNING?  Also, as above,
it's the user write that triggers the failure, this register is listed
as read-write, so what value does the vendor driver report for the
state when read after a transition failure?  Is it reported as _RESUMING
as it was prior to the attempted transition, or may the invalid states
be used by the vendor driver to indicate the device is broken?

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
> + *    If there was previous iteration, then this read operation indicates
> + *    previous iteration is done. If pending_bytes > 0, go through below steps.
> + * b. read data_offset, indicates kernel driver to make data available through
> + *    data section. Kernel driver should return this read operation only after
> + *    data is available from (region + data_offset) to (region + data_offset +
> + *    data_size).
> + * c. read data_size, amount of data in bytes available through migration
> + *    region.
> + * d. read data of data_size bytes from (region + data_offset) from migration
> + *    region.
> + * e. process data.
> + * f. Loop through a to e.

It seems we always need to end an iteration by reading pending_bytes to
signal to the vendor driver to release resources, so should the end of
the loop be:

e. Read pending_bytes
f. Goto b. or optionally restart next iteration at a.

I think this is defined such that reading data_offset commits resources
and reading pending_bytes frees them, allowing userspace to restart at
reading pending_bytes with no side-effects.  Therefore reading
pending_bytes repeatedly is supported.  Is the same true for
data_offset and data_size?  It seems reasonable that the vendor driver
can simply return offset and size for the current buffer if the user
reads these more than once.

How is a protocol or device error signaled?  For example, we can have a
user error where they read data_size before data_offset.  Should the
vendor driver generate a fault reading data_size in this case.  We can
also have internal errors in the vendor driver, should the vendor
driver use a special errno or update device_state autonomously to
indicate such an error?

I believe it's also part of the intended protocol that the user can
transition from _SAVING|_RUNNING to _SAVING at any point, regardless of
pending_bytes.  This should be noted.

> + *
> + * Sequence to be followed while _RESUMING device state:
> + * While data for this device is available, repeat below steps:
> + * a. read data_offset from where user application should write data.
> + * b. write data of data_size to migration region from data_offset.

Whose's data_size, the _SAVING end or the _RESUMING end?  I think this
is intended to be the transaction size from the _SAVING source, but it
could easily be misinterpreted as reading data_size on the _RESUMING
end.

> + * c. write data_size which indicates vendor driver that data is written in
> + *    staging buffer. Vendor driver should read this data from migration
> + *    region and resume device's state.

I think we also need to define the error protocol.  The user could
mis-order transactions or there could be an internal error in the
vendor driver or device.  Are all read(2)/write(2) operations
susceptible to defined errnos to signal this?  Is it reflected in
device_state?  What's the recovery protocol?

> + *
> + * For user application, data is opaque. User should write data in the same
> + * order as received.

Order and transaction size, ie. each data_size chunk is indivisible by
the user.

> + */
> +
> +struct vfio_device_migration_info {
> +	__u32 device_state;         /* VFIO device state */
> +#define VFIO_DEVICE_STATE_STOP      (1 << 0)
> +#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)

Huh?  We should probably just refer to it consistently, ie. _RUNNING
and !_RUNNING, otherwise we have the incongruity that setting the _STOP
value is actually the opposite of the necessary logic value (_STOP = 1
is _RUNNING, _STOP = 0 is !_RUNNING).

> +#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> +#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
> +				     VFIO_DEVICE_STATE_SAVING |  \
> +				     VFIO_DEVICE_STATE_RESUMING)
> +
> +#define VFIO_DEVICE_STATE_INVALID_CASE1    (VFIO_DEVICE_STATE_SAVING | \
> +					    VFIO_DEVICE_STATE_RESUMING)
> +
> +#define VFIO_DEVICE_STATE_INVALID_CASE2    (VFIO_DEVICE_STATE_RUNNING | \
> +					    VFIO_DEVICE_STATE_RESUMING)

Gack, we fixed these in the last iteration!

> +	__u32 reserved;
> +	__u64 pending_bytes;
> +	__u64 data_offset;
> +	__u64 data_size;
> +} __attribute__((packed));
> +
>  /*
>   * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
>   * which allows direct access to non-MSIX registers which happened to be within

Thanks,
Alex

