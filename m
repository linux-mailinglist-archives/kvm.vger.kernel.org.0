Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FE8FBD25
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfKNAoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:44:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:18506 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfKNAoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:44:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 16:44:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,302,1569308400"; 
   d="scan'208";a="355644464"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga004.jf.intel.com with ESMTP; 13 Nov 2019 16:44:18 -0800
Date:   Wed, 13 Nov 2019 19:36:15 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v9 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20191114003615.GD18001@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-2-git-send-email-kwankhede@nvidia.com>
 <20191112153005.53bf324c@x1.home>
 <20191113032332.GB18001@joy-OptiPlex-7040>
 <d0be166b-9ffe-645d-de74-b48855995326@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0be166b-9ffe-645d-de74-b48855995326@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 14, 2019 at 03:02:55AM +0800, Kirti Wankhede wrote:
> 
> 
> On 11/13/2019 8:53 AM, Yan Zhao wrote:
> > On Wed, Nov 13, 2019 at 06:30:05AM +0800, Alex Williamson wrote:
> >> On Tue, 12 Nov 2019 22:33:36 +0530
> >> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>
> >>> - Defined MIGRATION region type and sub-type.
> >>> - Used 3 bits to define VFIO device states.
> >>>      Bit 0 => _RUNNING
> >>>      Bit 1 => _SAVING
> >>>      Bit 2 => _RESUMING
> >>>      Combination of these bits defines VFIO device's state during migration
> >>>      _RUNNING => Normal VFIO device running state. When its reset, it
> >>> 		indicates _STOPPED state. when device is changed to
> >>> 		_STOPPED, driver should stop device before write()
> >>> 		returns.
> >>>      _SAVING | _RUNNING => vCPUs are running, VFIO device is running but
> >>>                            start saving state of device i.e. pre-copy state
> >>>      _SAVING  => vCPUs are stopped, VFIO device should be stopped, and
> >>
> >> s/should/must/
> >>
> >>>                  save device state,i.e. stop-n-copy state
> >>>      _RESUMING => VFIO device resuming state.
> >>>      _SAVING | _RESUMING and _RUNNING | _RESUMING => Invalid states
> >>
> >> A table might be useful here and in the uapi header to indicate valid
> >> states:
> >>
> >> | _RESUMING | _SAVING | _RUNNING | Description
> >> +-----------+---------+----------+------------------------------------------
> >> |     0     |    0    |     0    | Stopped, not saving or resuming (a)
> >> +-----------+---------+----------+------------------------------------------
> >> |     0     |    0    |     1    | Running, default state
> >> +-----------+---------+----------+------------------------------------------
> >> |     0     |    1    |     0    | Stopped, migration interface in save mode
> >> +-----------+---------+----------+------------------------------------------
> >> |     0     |    1    |     1    | Running, save mode interface, iterative
> >> +-----------+---------+----------+------------------------------------------
> >> |     1     |    0    |     0    | Stopped, migration resume interface active
> >> +-----------+---------+----------+------------------------------------------
> >> |     1     |    0    |     1    | Invalid (b)
> >> +-----------+---------+----------+------------------------------------------
> >> |     1     |    1    |     0    | Invalid (c)
> >> +-----------+---------+----------+------------------------------------------
> >> |     1     |    1    |     1    | Invalid (d)
> >>
> >> I think we need to consider whether we define (a) as generally
> >> available, for instance we might want to use it for diagnostics or a
> >> fatal error condition outside of migration.
> >>
> 
> We have to set it as init state. I'll add this it.
> 
> >> Are there hidden assumptions between state transitions here or are
> >> there specific next possible state diagrams that we need to include as
> >> well?
> >>
> >> I'm curious if Intel agrees with the states marked invalid with their
> >> push for post-copy support.
> >>
> > hi Alex and Kirti,
> > Actually, for postcopy, I think we anyway need an extra POSTCOPY state
> > introduced. Reasons as below:
> > - in the target side, _RSESUMING state is set in the beginning of
> >    migration. It cannot be used as a state to inform device of that
> >    currently it's in postcopy state and device DMAs are to be trapped and
> >    pre-faulted.
> >    we also cannot use state (_RESUMING + _RUNNING) as an indicator of
> >    postcopy, because before device & vm running in target side, some device
> >    state are already loaded (e.g. page tables, pending workloads),
> >    target side can do pre-pagefault at that period before target vm up.
> > - in the source side, after device is stopped, postcopy needs saving
> >    device state only (as compared to device state + remaining dirty
> >    pages in precopy). state (!_RUNNING + _SAVING) here again cannot
> >    differentiate precopy and postcopy here.
> > 
> >>>      Bits 3 - 31 are reserved for future use. User should perform
> >>>      read-modify-write operation on this field.
> >>> - Defined vfio_device_migration_info structure which will be placed at 0th
> >>>    offset of migration region to get/set VFIO device related information.
> >>>    Defined members of structure and usage on read/write access:
> >>>      * device_state: (read/write)
> >>>          To convey VFIO device state to be transitioned to. Only 3 bits are
> >>> 	used as of now, Bits 3 - 31 are reserved for future use.
> >>>      * pending bytes: (read only)
> >>>          To get pending bytes yet to be migrated for VFIO device.
> >>>      * data_offset: (read only)
> >>>          To get data offset in migration region from where data exist
> >>> 	during _SAVING and from where data should be written by user space
> >>> 	application during _RESUMING state.
> >>>      * data_size: (read/write)
> >>>          To get and set size in bytes of data copied in migration region
> >>> 	during _SAVING and _RESUMING state.
> >>>
> >>> Migration region looks like:
> >>>   ------------------------------------------------------------------
> >>> |vfio_device_migration_info|    data section                      |
> >>> |                          |     ///////////////////////////////  |
> >>>   ------------------------------------------------------------------
> >>>   ^                              ^
> >>>   offset 0-trapped part        data_offset
> >>>
> >>> Structure vfio_device_migration_info is always followed by data section
> >>> in the region, so data_offset will always be non-0. Offset from where data
> >>> to be copied is decided by kernel driver, data section can be trapped or
> >>> mapped depending on how kernel driver defines data section.
> >>> Data section partition can be defined as mapped by sparse mmap capability.
> >>> If mmapped, then data_offset should be page aligned, where as initial
> >>> section which contain vfio_device_migration_info structure might not end
> >>> at offset which is page aligned.
> >>> Vendor driver should decide whether to partition data section and how to
> >>> partition the data section. Vendor driver should return data_offset
> >>> accordingly.
> >>>
> >>> For user application, data is opaque. User should write data in the same
> >>> order as received.
> >>>
> >>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >>> ---
> >>>   include/uapi/linux/vfio.h | 108 ++++++++++++++++++++++++++++++++++++++++++++++
> >>>   1 file changed, 108 insertions(+)
> >>>
> >>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>> index 9e843a147ead..35b09427ad9f 100644
> >>> --- a/include/uapi/linux/vfio.h
> >>> +++ b/include/uapi/linux/vfio.h
> >>> @@ -305,6 +305,7 @@ struct vfio_region_info_cap_type {
> >>>   #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
> >>>   #define VFIO_REGION_TYPE_GFX                    (1)
> >>>   #define VFIO_REGION_TYPE_CCW			(2)
> >>> +#define VFIO_REGION_TYPE_MIGRATION              (3)
> >>>   
> >>>   /* sub-types for VFIO_REGION_TYPE_PCI_* */
> >>>   
> >>> @@ -379,6 +380,113 @@ struct vfio_region_gfx_edid {
> >>>   /* sub-types for VFIO_REGION_TYPE_CCW */
> >>>   #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
> >>>   
> >>> +/* sub-types for VFIO_REGION_TYPE_MIGRATION */
> >>> +#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
> >>> +
> >>> +/*
> >>> + * Structure vfio_device_migration_info is placed at 0th offset of
> >>> + * VFIO_REGION_SUBTYPE_MIGRATION region to get/set VFIO device related migration
> >>> + * information. Field accesses from this structure are only supported at their
> >>> + * native width and alignment, otherwise the result is undefined and vendor
> >>> + * drivers should return an error.
> >>> + *
> >>> + * device_state: (read/write)
> >>> + *      To indicate vendor driver the state VFIO device should be transitioned
> >>> + *      to. If device state transition fails, write on this field return error.
> >>> + *      It consists of 3 bits:
> >>> + *      - If bit 0 set, indicates _RUNNING state. When its reset, that indicates
> >>
> >> Let's use set/cleared or 1/0 to indicate bit values, 'reset' is somewhat
> >> ambiguous.
> 
> Ok. Updating it.
> 
> >>
> >>> + *        _STOPPED state. When device is changed to _STOPPED, driver should stop
> >>> + *        device before write() returns.
> >>> + *      - If bit 1 set, indicates _SAVING state. When set, that indicates driver
> >>> + *        should start gathering device state information which will be provided
> >>> + *        to VFIO user space application to save device's state.
> >>> + *      - If bit 2 set, indicates _RESUMING state. When set, that indicates
> >>> + *        prepare to resume device, data provided through migration region
> >>> + *        should be used to resume device.
> >>> + *      Bits 3 - 31 are reserved for future use. User should perform
> >>> + *      read-modify-write operation on this field.
> >>> + *      _SAVING and _RESUMING bits set at the same time is invalid state.
> >>> + *	Similarly _RUNNING and _RESUMING bits set is invalid state.
> >>> + *
> >>> + * pending bytes: (read only)
> >>> + *      Number of pending bytes yet to be migrated from vendor driver
> >>> + *
> >>> + * data_offset: (read only)
> >>> + *      User application should read data_offset in migration region from where
> >>> + *      user application should read device data during _SAVING state or write
> >>> + *      device data during _RESUMING state. See below for detail of sequence to
> >>> + *      be followed.
> >>> + *
> >>> + * data_size: (read/write)
> >>> + *      User application should read data_size to get size of data copied in
> >>> + *      bytes in migration region during _SAVING state and write size of data
> >>> + *      copied in bytes in migration region during _RESUMING state.
> >>> + *
> >>> + * Migration region looks like:
> >>> + *  ------------------------------------------------------------------
> >>> + * |vfio_device_migration_info|    data section                      |
> >>> + * |                          |     ///////////////////////////////  |
> >>> + * ------------------------------------------------------------------
> >>> + *   ^                              ^
> >>> + *  offset 0-trapped part        data_offset
> >>> + *
> >>> + * Structure vfio_device_migration_info is always followed by data section in
> >>> + * the region, so data_offset will always be non-0. Offset from where data is
> >>> + * copied is decided by kernel driver, data section can be trapped or mapped
> >>> + * or partitioned, depending on how kernel driver defines data section.
> >>> + * Data section partition can be defined as mapped by sparse mmap capability.
> >>> + * If mmapped, then data_offset should be page aligned, where as initial section
> >>> + * which contain vfio_device_migration_info structure might not end at offset
> >>> + * which is page aligned.
> >>
> >> "The user is not required to to access via mmap regardless of the
> >> region mmap capabilities."
> >>
> > But once the user decides to access via mmap, it has to read data of
> > data_size each time, otherwise the vendor driver has no idea of how many
> > data are already read from user. Agree?
> > 
> 
> that's right.
> 
> >>> + * Vendor driver should decide whether to partition data section and how to
> >>> + * partition the data section. Vendor driver should return data_offset
> >>> + * accordingly.
> >>> + *
> >>> + * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy phase
> >>> + * and for _SAVING device state or stop-and-copy phase:
> >>> + * a. read pending_bytes. If pending_bytes > 0, go through below steps.
> >>> + * b. read data_offset, indicates kernel driver to write data to staging buffer.
> >>> + *    Kernel driver should return this read operation only after writing data to
> >>> + *    staging buffer is done.
> > May I know under what condition this data_offset will be changed per
> > each iteration from a-f ?
> > 
> 
> Its upto vendor driver, if vendor driver maintains multiple partitions 
> in data section.
>
So, do you mean each time before doing b (reading data_offset), step a
(reading pending_bytes) is mandatory, otherwise the vendor driver does
not know which data_offset is?
Then, any lock to wrap step a and b to ensure atomic?

Thanks
Yan


> >>
> >> "staging buffer" implies a vendor driver implementation, perhaps we
> >> could just state that data is available from (region + data_offset) to
> >> (region + data_offset + data_size) upon return of this read operation.
> >>
> 
> Makes sense. Updating it.
> 
> >>> + * c. read data_size, amount of data in bytes written by vendor driver in
> >>> + *    migration region.
> >>> + * d. read data_size bytes of data from data_offset in the migration region.
> >>> + * e. process data.
> >>> + * f. Loop through a to e. Next read on pending_bytes indicates that read data
> >>> + *    operation from migration region for previous iteration is done.
> >>
> >> I think this indicate that step (f) should be to read pending_bytes, the
> >> read sequence is not complete until this step.  Optionally the user can
> >> then proceed to step (b).  There are no read side-effects of (a) afaict.
> >>
> 
> I tried to reword this sequence to be more specific:
> 
> * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy 
> * phase and for _SAVING device state or stop-and-copy phase:
> * a. read pending_bytes, indicates start of new iteration to get device 
> *    data. If there was previous iteration, then this read operation
> *    indicates previous iteration is done. If pending_bytes > 0, go
> *    through below steps.
> * b. read data_offset, indicates kernel driver to make data available
> *    through data section. Kernel driver should return this read
> *    operation only after data is available from (region + data_offset)
> *    to (region + data_offset + data_size).
> * c. read data_size, amount of data in bytes available through migration
> *    region.
> * d. read data of data_size bytes from (region + data_offset) from
> *    migration region.
> * e. process data.
> * f. Loop through a to e.
> 
> Hope this is more clear.
> 
> >> Is the use required to reach pending_bytes == 0 before changing
> >> device_state, particularly transitioning to !_RUNNING?
> 
> No, its not necessary to reach till pending_bytes==0 in pre-copy phase.
> 
> >>  Presumably the
> >> user can exit this sequence at any time by clearing _SAVING.
> 
> In that case device state data is not complete, which will result in not 
> able to resume device with that data.
> In stop-and-copy phase, user should iterate till pending_bytes is 0.
> 
> >>
> >>> + *
> >>> + * Sequence to be followed while _RESUMING device state:
> >>> + * While data for this device is available, repeat below steps:
> >>> + * a. read data_offset from where user application should write data.
> > before proceed to step b, need to read data_size from vendor driver to determine
> > the max len of data to write. I think it's necessary in such a condition
> > that source vendor driver and target vendor driver do not offer data sections of
> > the same size. e.g. in source side, the data section is of size 100M,
> > but in target side, the data section is only of 50M size.
> > rather than simply fail, loop and write seems better.
> > 
> 
> Makes sense. Doing this change for next version.
> 
> > Thanks
> > Yan
> >>> + * b. write data of data_size to migration region from data_offset.
> >>> + * c. write data_size which indicates vendor driver that data is written in
> >>> + *    staging buffer. Vendor driver should read this data from migration
> >>> + *    region and resume device's state.
> >>
> >> The device defaults to _RUNNING state, so a prerequisite is to set
> >> _RESUMING and clear _RUNNING, right?
> 
> Yes.
> 
> >>
> >>> + *
> >>> + * For user application, data is opaque. User should write data in the same
> >>> + * order as received.
> >>> + */
> >>> +
> >>> +struct vfio_device_migration_info {
> >>> +	__u32 device_state;         /* VFIO device state */
> >>> +#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> >>> +#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> >>> +#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> >>> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
> >>> +				     VFIO_DEVICE_STATE_SAVING |  \
> >>> +				     VFIO_DEVICE_STATE_RESUMING)
> >>> +
> >>> +#define VFIO_DEVICE_STATE_INVALID_CASE1    (VFIO_DEVICE_STATE_SAVING | \
> >>> +					    VFIO_DEVICE_STATE_RESUMING)
> >>> +
> >>> +#define VFIO_DEVICE_STATE_INVALID_CASE2    (VFIO_DEVICE_STATE_RUNNING | \
> >>> +					    VFIO_DEVICE_STATE_RESUMING)
> >>
> >> These seem difficult to use, maybe we just need a
> >> VFIO_DEVICE_STATE_VALID macro?
> >>
> >> #define VFIO_DEVICE_STATE_VALID(state) \
> >>    (state & VFIO_DEVICE_STATE_RESUMING ? \
> >>    (state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
> >>
> 
> This will not be work when use of other bits gets added in future. 
> That's the reason I preferred to add individual invalid states which 
> user should check.
> 
> Thanks,
> Kirti
> 
> >> Thanks,
> >> Alex
> >>
> >>> +	__u32 reserved;
> >>> +	__u64 pending_bytes;
> >>> +	__u64 data_offset;
> >>> +	__u64 data_size;
> >>> +} __attribute__((packed));
> >>> +
> >>>   /*
> >>>    * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
> >>>    * which allows direct access to non-MSIX registers which happened to be within
> >>
