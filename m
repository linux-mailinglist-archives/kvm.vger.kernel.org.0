Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A1346F77B
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 00:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhLIXiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 18:38:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229760AbhLIXiT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 18:38:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639092885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CDlNDQa9Zg41ZRatMIisKukQgYZPQpmiS9p00UQrja8=;
        b=Y4KvpXJBH0kSVcxBeSww8GRNMEbki+dohbevNG7XTfu+VN7+F/lyXsCY0OlfojQ0S6lDms
        ejUpLsIHqdnnVJLH6ASDVd+m0CNBnAwbm4hMqCZq0MnUtrF221f2PiyrK95mttpSbPqCtJ
        pA57iw9py81uT3Hh/pj2h9oV3GNdhlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-NMIE3G3gNyywqFSH_6Gf0A-1; Thu, 09 Dec 2021 18:34:42 -0500
X-MC-Unique: NMIE3G3gNyywqFSH_6Gf0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C62741006AA5;
        Thu,  9 Dec 2021 23:34:40 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.2.16.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F8BB604CC;
        Thu,  9 Dec 2021 23:34:30 +0000 (UTC)
Subject: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     jgg@nvidia.com, cohuck@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        farman@linux.ibm.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com
Date:   Thu, 09 Dec 2021 16:34:29 -0700
Message-ID: <163909282574.728533.7460416142511440919.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A new NDMA state is being proposed to support a quiescent state for
contexts containing multiple devices with peer-to-peer DMA support.
Formally define it.

Clarify various aspects of the migration region data fields and
protocol.  Remove QEMU related terminology and flows from the uAPI;
these will be provided in Documentation/ so as not to confuse the
device_state bitfield with a finite state machine with restricted
state transitions.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/uapi/linux/vfio.h |  405 ++++++++++++++++++++++++---------------------
 1 file changed, 214 insertions(+), 191 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..1fdbc928f886 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -408,199 +408,211 @@ struct vfio_region_gfx_edid {
 #define VFIO_REGION_SUBTYPE_MIGRATION           (1)
 
 /*
- * The structure vfio_device_migration_info is placed at the 0th offset of
- * the VFIO_REGION_SUBTYPE_MIGRATION region to get and set VFIO device related
- * migration information. Field accesses from this structure are only supported
- * at their native width and alignment. Otherwise, the result is undefined and
- * vendor drivers should return an error.
+ * The structure vfio_device_migration_info is placed at the immediate start of
+ * the per-device VFIO_REGION_SUBTYPE_MIGRATION region to manage the device
+ * state and migration information for the device.  Field accesses for this
+ * structure are only supported using their native width and alignment,
+ * accesses otherwise are undefined and the kernel migration driver should
+ * return an error.
  *
  * device_state: (read/write)
- *      - The user application writes to this field to inform the vendor driver
- *        about the device state to be transitioned to.
- *      - The vendor driver should take the necessary actions to change the
- *        device state. After successful transition to a given state, the
- *        vendor driver should return success on write(device_state, state)
- *        system call. If the device state transition fails, the vendor driver
- *        should return an appropriate -errno for the fault condition.
- *      - On the user application side, if the device state transition fails,
- *	  that is, if write(device_state, state) returns an error, read
- *	  device_state again to determine the current state of the device from
- *	  the vendor driver.
- *      - The vendor driver should return previous state of the device unless
- *        the vendor driver has encountered an internal error, in which case
- *        the vendor driver may report the device_state VFIO_DEVICE_STATE_ERROR.
- *      - The user application must use the device reset ioctl to recover the
- *        device from VFIO_DEVICE_STATE_ERROR state. If the device is
- *        indicated to be in a valid device state by reading device_state, the
- *        user application may attempt to transition the device to any valid
- *        state reachable from the current state or terminate itself.
- *
- *      device_state consists of 3 bits:
- *      - If bit 0 is set, it indicates the _RUNNING state. If bit 0 is clear,
- *        it indicates the _STOP state. When the device state is changed to
- *        _STOP, driver should stop the device before write() returns.
- *      - If bit 1 is set, it indicates the _SAVING state, which means that the
- *        driver should start gathering device state information that will be
- *        provided to the VFIO user application to save the device's state.
- *      - If bit 2 is set, it indicates the _RESUMING state, which means that
- *        the driver should prepare to resume the device. Data provided through
- *        the migration region should be used to resume the device.
- *      Bits 3 - 31 are reserved for future use. To preserve them, the user
- *      application should perform a read-modify-write operation on this
- *      field when modifying the specified bits.
- *
- *  +------- _RESUMING
- *  |+------ _SAVING
- *  ||+----- _RUNNING
- *  |||
- *  000b => Device Stopped, not saving or resuming
- *  001b => Device running, which is the default state
- *  010b => Stop the device & save the device state, stop-and-copy state
- *  011b => Device running and save the device state, pre-copy state
- *  100b => Device stopped and the device state is resuming
- *  101b => Invalid state
- *  110b => Error state
- *  111b => Invalid state
- *
- * State transitions:
- *
- *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
- *                (100b)     (001b)     (011b)        (010b)       (000b)
- * 0. Running or default state
- *                             |
- *
- * 1. Normal Shutdown (optional)
- *                             |------------------------------------->|
- *
- * 2. Save the state or suspend
- *                             |------------------------->|---------->|
- *
- * 3. Save the state during live migration
- *                             |----------->|------------>|---------->|
- *
- * 4. Resuming
- *                  |<---------|
- *
- * 5. Resumed
- *                  |--------->|
- *
- * 0. Default state of VFIO device is _RUNNING when the user application starts.
- * 1. During normal shutdown of the user application, the user application may
- *    optionally change the VFIO device state from _RUNNING to _STOP. This
- *    transition is optional. The vendor driver must support this transition but
- *    must not require it.
- * 2. When the user application saves state or suspends the application, the
- *    device state transitions from _RUNNING to stop-and-copy and then to _STOP.
- *    On state transition from _RUNNING to stop-and-copy, driver must stop the
- *    device, save the device state and send it to the application through the
- *    migration region. The sequence to be followed for such transition is given
- *    below.
- * 3. In live migration of user application, the state transitions from _RUNNING
- *    to pre-copy, to stop-and-copy, and to _STOP.
- *    On state transition from _RUNNING to pre-copy, the driver should start
- *    gathering the device state while the application is still running and send
- *    the device state data to application through the migration region.
- *    On state transition from pre-copy to stop-and-copy, the driver must stop
- *    the device, save the device state and send it to the user application
- *    through the migration region.
- *    Vendor drivers must support the pre-copy state even for implementations
- *    where no data is provided to the user before the stop-and-copy state. The
- *    user must not be required to consume all migration data before the device
- *    transitions to a new state, including the stop-and-copy state.
- *    The sequence to be followed for above two transitions is given below.
- * 4. To start the resuming phase, the device state should be transitioned from
- *    the _RUNNING to the _RESUMING state.
- *    In the _RESUMING state, the driver should use the device state data
- *    received through the migration region to resume the device.
- * 5. After providing saved device data to the driver, the application should
- *    change the state from _RESUMING to _RUNNING.
+ *   The device_state field is a bitfield written by the user to transition
+ *   the associated device between valid migration states using these rules:
+ *     - The user may read or write the device state register at any time.
+ *     - The kernel migration driver must fully transition the device to the
+ *       new state value before the write(2) operation returns to the user.
+ *     - The user may change multiple bits of the bitfield in the same write
+ *       operation, so long as the resulting state is valid.
+ *     - The kernel migration driver must not generate asynchronous device
+ *       state transitions outside of manipulation by the user or the
+ *       VFIO_DEVICE_RESET ioctl as described below.
+ *     - In the event of a device state transition failure, the kernel
+ *       migration driver must return a write(2) error with appropriate errno
+ *       to the user.
+ *     - Upon such an error, re-reading the device_state field must indicate
+ *       the device migration state as either the same state as prior to the
+ *       failing write or, at the migration driver discretion, indicate the
+ *       device state as VFIO_DEVICE_STATE_ERROR.
+ *     - To continue using a device that has entered VFIO_DEVICE_STATE_ERROR,
+ *       the user must issue a VFIO_DEVICE_RESET ioctl, which must transition
+ *       the migration state to the default value (defined below).
+ *     - Devices supporting migration via this specification must support the
+ *       VFIO_DEVICE_RESET ioctl and any use of that ioctl must return the
+ *       device migration state to the default value.
+ *
+ *   The device_state field defines the following bitfield use:
+ *
+ *     - Bit 0 (RUNNING) [REQUIRED]:
+ *        - Setting this bit indicates the device is fully operational, the
+ *          device may generate interrupts, DMA, respond to MMIO, all vfio
+ *          device regions are functional, and the device may advance its
+ *          internal state.  The default device_state must indicate the device
+ *          in exclusively the RUNNING state, with no other bits in this field
+ *          set.
+ *        - Clearing this bit (ie. !RUNNING) must stop the operation of the
+ *          device.  The device must not generate interrupts, DMA, or advance
+ *          its internal state.  The user should take steps to restrict access
+ *          to vfio device regions other than the migration region while the
+ *          device is !RUNNING or risk corruption of the device migration data
+ *          stream.  The device and kernel migration driver must accept and
+ *          respond to interaction to support external subsystems in the
+ *          !RUNNING state, for example PCI MSI-X and PCI config space.
+ *          Failure by the user to restrict device access while !RUNNING must
+ *          not result in error conditions outside the user context (ex.
+ *          host system faults).
+ *     - Bit 1 (SAVING) [REQUIRED]:
+ *        - Setting this bit enables and initializes the migration region data
+ *          window and associated fields within vfio_device_migration_info for
+ *          capturing the migration data stream for the device.  The migration
+ *          driver may perform actions such as enabling dirty logging of device
+ *          state with this bit.  The SAVING bit is mutually exclusive with the
+ *          RESUMING bit defined below.
+ *        - Clearing this bit (ie. !SAVING) de-initializes the migration region
+ *          data window and indicates the completion or termination of the
+ *          migration data stream for the device.
+ *     - Bit 2 (RESUMING) [REQUIRED]:
+ *        - Setting this bit enables and initializes the migration region data
+ *          window and associated fields within vfio_device_migration_info for
+ *          restoring the device from a migration data stream captured from a
+ *          SAVING session with a compatible device.  The migration driver may
+ *          perform internal device resets as necessary to reinitialize the
+ *          internal device state for the incoming migration data.
+ *        - Clearing this bit (ie. !RESUMING) de-initializes the migration
+ *          region data window and indicates the end of a resuming session for
+ *          the device.  The kernel migration driver should complete the
+ *          incorporation of data written to the migration data window into the
+ *          device internal state and perform final validity and consistency
+ *          checking of the new device state.  If the user provided data is
+ *          found to be incomplete, inconsistent, or otherwise invalid, the
+ *          migration driver must indicate a write(2) error and follow the
+ *          previously described protocol to return either the previous state
+ *          or an error state.
+ *     - Bit 3 (NDMA) [OPTIONAL]:
+ *        The NDMA or "No DMA" state is intended to be a quiescent state for
+ *        the device for the purposes of managing multiple devices within a
+ *        user context where peer-to-peer DMA between devices may be active.
+ *        Support for the NDMA bit is indicated through the presence of the
+ *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
+ *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
+ *        region.
+ *        - Setting this bit must prevent the device from initiating any
+ *          new DMA or interrupt transactions.  The migration driver must
+ *          complete any such outstanding operations prior to completing
+ *          the transition to the NDMA state.  The NDMA device_state
+ *          essentially represents a sub-set of the !RUNNING state for the
+ *          purpose of quiescing the device, therefore the NDMA device_state
+ *          bit is superfluous in combinations including !RUNNING.
+ *        - Clearing this bit (ie. !NDMA) negates the device operational
+ *          restrictions required by the NDMA state.
+ *     - Bits [31:4]:
+ *        Reserved for future use, users should use read-modify-write
+ *        operations to the device_state field for manipulation of the above
+ *        defined bits for optimal compatibility.
+ *
+ *   All combinations for the above defined device_state bits are considered
+ *   valid with the following exceptions:
+ *     - RESUMING and SAVING are mutually exclusive, all combinations of
+ *       (RESUMING | SAVING) are invalid.  Furthermore the specific combination
+ *       (!NDMA | RESUMING | SAVING | !RUNNING) is reserved to indicate the
+ *       device error state VFIO_DEVICE_STATE_ERROR.  This variant is
+ *       specifically chosen due to the !RUNNING state of the device as the
+ *       migration driver should do everything possible, including an internal
+ *       reset of the device, to ensure that the device is fully stopped in
+ *       this state.  Other invalid combinations are reserved for future use
+ *       and must not be reachable.
+ *     - Combinations involving (RESUMING | RUNNING) are currently unsupported
+ *       by this revision of the uAPI.
+ *
+ *   Migration drivers should attempt to support any transition between valid
+ *   states.  For further discussion of device_state relative to expected usage
+ *   scenarios, see: Documentation/driver-api/vfio.rst
  *
  * reserved:
- *      Reads on this field return zero and writes are ignored.
+ *   Reads on this field return zero and writes are ignored.
  *
  * pending_bytes: (read only)
- *      The number of pending bytes still to be migrated from the vendor driver.
+ *   The kernel migration driver uses this field to indicate an estimate of
+ *   the remaining data size (in bytes) for the user to copy while SAVING is
+ *   set in the device_state.  The value should be considered volatile,
+ *   especially while RUNNING is still set in the device_state.  Userspace
+ *   uses this field to test whether data is available to be read from the
+ *   data section described below.  Userspace should only consider whether
+ *   the value read is zero or non-zero for the purposes of the protocol
+ *   below.  The user may only consider the migration data stream to be
+ *   completed when pending_bytes reports a zero value while the device is
+ *   !RUNNING.  The kernel migration driver must not require the user to reach
+ *   a zero value for this field to transition to a !RUNNING device_state.
+ *   The value of this field is undefined when !SAVING.
  *
  * data_offset: (read only)
- *      The user application should read data_offset field from the migration
- *      region. The user application should read the device data from this
- *      offset within the migration region during the _SAVING state or write
- *      the device data during the _RESUMING state. See below for details of
- *      sequence to be followed.
+ *   This field indicates the offset relative to the start of the device
+ *   migration region for the user to collect (SAVING) or store (RESUMING)
+ *   migration data for the device following the protocol described below.
+ *   The migration driver may provide sparse mmap support for the migration
+ *   region and use the data_offset field to direct user accesses as
+ *   appropriate, but must not require mmap access when provided.  The value
+ *   of this field is undefined when device_state does not include either
+ *   SAVING or RESUMING.
  *
  * data_size: (read/write)
- *      The user application should read data_size to get the size in bytes of
- *      the data copied in the migration region during the _SAVING state and
- *      write the size in bytes of the data copied in the migration region
- *      during the _RESUMING state.
- *
- * The format of the migration region is as follows:
- *  ------------------------------------------------------------------
- * |vfio_device_migration_info|    data section                      |
- * |                          |     ///////////////////////////////  |
- * ------------------------------------------------------------------
- *   ^                              ^
- *  offset 0-trapped part        data_offset
- *
- * The structure vfio_device_migration_info is always followed by the data
- * section in the region, so data_offset will always be nonzero. The offset
- * from where the data is copied is decided by the kernel driver. The data
- * section can be trapped, mmapped, or partitioned, depending on how the kernel
- * driver defines the data section. The data section partition can be defined
- * as mapped by the sparse mmap capability. If mmapped, data_offset must be
- * page aligned, whereas initial section which contains the
- * vfio_device_migration_info structure, might not end at the offset, which is
- * page aligned. The user is not required to access through mmap regardless
- * of the capabilities of the region mmap.
- * The vendor driver should determine whether and how to partition the data
- * section. The vendor driver should return data_offset accordingly.
- *
- * The sequence to be followed while in pre-copy state and stop-and-copy state
- * is as follows:
- * a. Read pending_bytes, indicating the start of a new iteration to get device
- *    data. Repeated read on pending_bytes at this stage should have no side
- *    effects.
- *    If pending_bytes == 0, the user application should not iterate to get data
- *    for that device.
- *    If pending_bytes > 0, perform the following steps.
- * b. Read data_offset, indicating that the vendor driver should make data
- *    available through the data section. The vendor driver should return this
- *    read operation only after data is available from (region + data_offset)
- *    to (region + data_offset + data_size).
- * c. Read data_size, which is the amount of data in bytes available through
- *    the migration region.
- *    Read on data_offset and data_size should return the offset and size of
- *    the current buffer if the user application reads data_offset and
- *    data_size more than once here.
- * d. Read data_size bytes of data from (region + data_offset) from the
- *    migration region.
- * e. Process the data.
- * f. Read pending_bytes, which indicates that the data from the previous
- *    iteration has been read. If pending_bytes > 0, go to step b.
- *
- * The user application can transition from the _SAVING|_RUNNING
- * (pre-copy state) to the _SAVING (stop-and-copy) state regardless of the
- * number of pending bytes. The user application should iterate in _SAVING
- * (stop-and-copy) until pending_bytes is 0.
- *
- * The sequence to be followed while _RESUMING device state is as follows:
- * While data for this device is available, repeat the following steps:
- * a. Read data_offset from where the user application should write data.
- * b. Write migration data starting at the migration region + data_offset for
- *    the length determined by data_size from the migration source.
- * c. Write data_size, which indicates to the vendor driver that data is
- *    written in the migration region. Vendor driver must return this write
- *    operations on consuming data. Vendor driver should apply the
- *    user-provided migration region data to the device resume state.
- *
- * If an error occurs during the above sequences, the vendor driver can return
- * an error code for next read() or write() operation, which will terminate the
- * loop. The user application should then take the next necessary action, for
- * example, failing migration or terminating the user application.
- *
- * For the user application, data is opaque. The user application should write
- * data in the same order as the data is received and the data should be of
- * same transaction size at the source.
+ *   This field indicates the length of the current data segment in bytes.
+ *   While SAVING, the kernel migration driver uses this field to indicate to
+ *   the user the length of the migration data stream available at data_offset.
+ *   When RESUMING, the user writes this field with the length of the data
+ *   segment written at the migration driver provided data_offset.  The value
+ *   of this field is undefined when device_state does not include either
+ *   SAVING or RESUMING.
+ *
+ * The following protocol is used while the device is in the SAVING
+ * device_state:
+ *
+ * a) The user reads pending_bytes.  If the read value is zero, no data is
+ *    currently available for the device.  If the device is !RUNNING and a
+ *    zero value is read, this indicates the end of the device migration
+ *    stream and the device must not generate any new migration data.  If
+ *    the read value is non-zero, the user may proceed to collect device
+ *    migration data in step b).  Repeated reads of pending_bytes is allowed
+ *    and must not compromise the migration data stream provided the user does
+ *    not proceed to the following step.
+ * b) The user reads data_offset, which indicates to the migration driver to
+ *    make a segment of device migration data available to the user at the
+ *    provided offset.  This action commits the user to collect the data
+ *    segment.
+ * c) The user reads data_size to determine the extent of the currently
+ *    available migration data segment.
+ * d) The user collects the data_size segment of device migration data at the
+ *    previously provided data_offset using access methods compatible to those
+ *    for the migration region.  The user must not be required to collect the
+ *    data in a single operation.
+ * e) The user re-reads pending_bytes to indicate to the migration driver that
+ *    the provided data has been collected.  Provided the read pending_bytes
+ *    value is non-zero, the user may proceed directly to step b) for another
+ *    iteration.
+ *
+ * The following protocol is used while the device is in the RESUMING
+ * device_state:
+ *
+ * a) The user reads data_offset, which directs the user to the location
+ *    within the migration region to store the migration data segment.
+ * b) The user writes the migration data segment starting at the provided
+ *    data_offset.  The user must preserve the data segment size as used when
+ *    the segment was collected from the device when SAVING.
+ * c) The user writes the data_size field with the number of bytes written to
+ *    the migration region in step b).  The kernel migration driver may use
+ *    this write to indicate the end of the current iteration.
+ * d) User proceeds to step a) so long as the migration data stream is not
+ *    complete.
+ *
+ * The kernel migration driver may indicate an error condition by returning
+ * a fault on read(2) or write(2) for any operation most approximate to the
+ * detection of the error.  Field accesses are provided within the protocol
+ * such that an opportunity exists to return a fault regardless of whether the
+ * data section is directly accessed via an mmap.
+ *
+ * The user must consider the migration data segments to be opaque and
+ * non-fungible.  During RESUMING, the data segments must be written in the
+ * size and order as provided during SAVING, irrespective of other bits within
+ * the device_state bitfield (ex. a transition to !RUNNING).
  */
 
 struct vfio_device_migration_info {
@@ -609,21 +621,25 @@ struct vfio_device_migration_info {
 #define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
 #define VFIO_DEVICE_STATE_SAVING    (1 << 1)
 #define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
-#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
-				     VFIO_DEVICE_STATE_SAVING |  \
+#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
+#define VFIO_DEVICE_STATE_ERROR     (VFIO_DEVICE_STATE_SAVING | \
 				     VFIO_DEVICE_STATE_RESUMING)
+#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING  | \
+				     VFIO_DEVICE_STATE_SAVING   | \
+				     VFIO_DEVICE_STATE_RESUMING | \
+				     VFIO_DEVICE_STATE_NDMA)
 
 #define VFIO_DEVICE_STATE_VALID(state) \
-	(state & VFIO_DEVICE_STATE_RESUMING ? \
-	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
+	(!((state & VFIO_DEVICE_STATE_SAVING) && \
+	   (state & VFIO_DEVICE_STATE_RESUMING)) && \
+	 !((state & VFIO_DEVICE_STATE_RESUMING) && \
+	   (state & VFIO_DEVICE_STATE_RUNNING)))
 
 #define VFIO_DEVICE_STATE_IS_ERROR(state) \
-	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
-					      VFIO_DEVICE_STATE_RESUMING))
+	((state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_ERROR)
 
 #define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
-					     VFIO_DEVICE_STATE_RESUMING)
+	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_ERROR)
 
 	__u32 reserved;
 	__u64 pending_bytes;
@@ -631,6 +647,13 @@ struct vfio_device_migration_info {
 	__u64 data_size;
 };
 
+/*
+ * The Migration NDMA capability is exposed on a device Migration region
+ * to indicate support for the VFIO_DEVICE_STATE_NDMA bit of
+ * vfio_device_migration_info.device_state.
+ */
+#define VFIO_REGION_INFO_CAP_MIG_NDMA		6
+
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
  * which allows direct access to non-MSIX registers which happened to be within


