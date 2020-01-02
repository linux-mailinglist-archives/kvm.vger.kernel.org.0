Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A7612E9E5
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 19:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgABSZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 13:25:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35502 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727829AbgABSZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 13:25:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577989553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zpMPkLNjCydjzIFCgFF4os2BurY0JHFNvUrS43WJLe4=;
        b=Am2pty0xBZO9BeJDX5PUbAiOzubdb6Xe5Ocb0fC+sjmlA8015VEwUN1pZB75ri8Rmqldpx
        DyQheecUC+crfaACClfD6o3dz+bP6mFWdyq6OTyICPp3bWgZJ2qA3U0gFGB9pRNu2No4oh
        EfCKhvv1Sz35nXoIeJFf+hLJRBnc+wY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-aInhqq1JNJOHuh6VFkxvBw-1; Thu, 02 Jan 2020 13:25:50 -0500
X-MC-Unique: aInhqq1JNJOHuh6VFkxvBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2575DBE5;
        Thu,  2 Jan 2020 18:25:47 +0000 (UTC)
Received: from work-vm (ovpn-117-17.ams2.redhat.com [10.36.117.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F317763BCA;
        Thu,  2 Jan 2020 18:25:40 +0000 (UTC)
Date:   Thu, 2 Jan 2020 18:25:37 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, jonathan.davies@nutanix.com, eauger@redhat.com,
        aik@ozlabs.ru, pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, yan.y.zhao@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v10 Kernel 1/5] vfio: KABI for migration interface for
 device state
Message-ID: <20200102182537.GK2927@work-vm>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
 <1576527700-21805-2-git-send-email-kwankhede@nvidia.com>
 <20191216154406.023f912b@x1.home>
 <f773a92a-acbd-874d-34ba-36c1e9ffe442@nvidia.com>
 <20191217114357.6496f748@x1.home>
 <3527321f-e310-8324-632c-339b22f15de5@nvidia.com>
 <20191219102706.0a316707@x1.home>
 <928e41b5-c3fd-ed75-abd6-ada05cda91c9@nvidia.com>
 <20191219140929.09fa24da@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219140929.09fa24da@x1.home>
User-Agent: Mutt/1.13.0 (2019-11-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Fri, 20 Dec 2019 01:40:35 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > On 12/19/2019 10:57 PM, Alex Williamson wrote:
> > 
> > <Snip>
> > 

<snip>

> > 
> > If device state it at pre-copy state (011b).
> > Transition, i.e., write to device state as stop-and-copy state (010b) 
> > failed, then by previous state I meant device should return pre-copy 
> > state(011b), i.e. previous state which was successfully set, or as you 
> > said current state which was successfully set.
> 
> Yes, the point I'm trying to make is that this version of the spec
> tries to tell the user what they should do upon error according to our
> current interpretation of the QEMU migration protocol.  We're not
> defining the QEMU migration protocol, we're defining something that can
> be used in a way to support that protocol.  So I think we should be
> concerned with defining our spec, for example my proposal would be: "If
> a state transition fails the user can read device_state to determine the
> current state of the device.  This should be the previous state of the
> device unless the vendor driver has encountered an internal error, in
> which case the device may report the invalid device_state 110b.  The
> user must use the device reset ioctl in order to recover the device
> from this state.  If the device is indicated in a valid device state
> via reading device_state, the user may attempt to transition the device
> to any valid state reachable from the current state."

We might want to be able to distinguish between:
  a) The device has failed and needs a reset
  b) The migration has failed

If some part of the devices mechanics for migration fail, but the device
is otherwise operational then we should be able to decide to fail the
migration without taking the device down, which might be very bad for
the VM.
Losing a VM during migration due to a problem with migration really
annoys users; it's one thing the migration failing, but taking the VM
out as well really gets to them.

Having the device automatically transition back to the 'running' state
seems a bad idea to me; much better to tell the hypervisor and provide
it with a way to clean up; for example, imagine a system with multiple
devices that are being migrated, most of them have happily transitioned
to stop-and-copy, but then the last device decides to fail - so now
someone is going to have to take all of them back to running.

Dave

> > >>> and allowable state transitions independent
> > >>> of the expected usage model.  
> > >>
> > >> Do you mean to define array of ['from','to'], same as runstate
> > >> transition array in QEMU?
> > >>    static const RunStateTransition runstate_transitions_def[]  
> > > 
> > > I'm thinking that independent of expected QEMU usage models, are there
> > > any invalid transitions or is every state reachable from every other
> > > state.  I'm afraid this design is so focused on a specific usage model
> > > that vendor drivers are going to fall over if the user invokes a
> > > transition outside of those listed above.  If there are invalid
> > > transitions, those should be listed so they can be handled
> > > consistently.  If there are no invalid transitions, it should be noted
> > > in the spec to encourage vendor drivers to expect this.
> > >   
> > 
> > I think vendor driver can decide which state transitions it can support, 
> > rather than defining/prescribing that all.
> > Suppose, if vendor driver doesn't want to support save-restore 
> > functionality, then vendor driver can return error -EINVAL for write() 
> > operation on device_state for transition from _RUNNING to 
> > stop-and-copy(010b) state.
> 
> This is unsupportable.  If the vendor driver doesn't want to support
> save-restore then they simply do not implement the migration
> extensions.  If they expose this interface then the user (QEMU) will
> rightfully assume that the device supports migration, only to find out
> upon trying to use it that it's unsupported, or maybe broken.
> 
> > >>> For example, I think a user should always
> > >>> be allowed to transition a device to stopped regardless of the expected
> > >>> migration flow.  An error might have occurred elsewhere and we want to
> > >>> stop everything for debugging.  I think it's also allowable to switch
> > >>> directly from running to stop-and-copy, for example to save and resume
> > >>> a VM offline.
> > >>>        
> > >>>>> Also, it seems like it's the vendor driver's discretion to actually
> > >>>>> provide data during the pre-copy phase.  As we've defined it, the
> > >>>>> vendor driver needs to participate in the migration region regardless,
> > >>>>> they might just always report no pending_bytes until we enter
> > >>>>> stop-and-copy.
> > >>>>>         
> > >>>>
> > >>>> Yes. And if pending_bytes are reported as 0 in pre-copy by vendor driver
> > >>>> then QEMU doesn't reiterate for that device.  
> > >>>
> > >>> Maybe we can state that as the expected mechanism to avoid a vendor
> > >>> driver trying to invent alternative means, ex. failing transition to
> > >>> pre-copy, requesting new flags, etc.
> > >>>      
> > >>
> > >> Isn't Sequence to be followed below sufficient to state that?  
> > > 
> > > I think we understand it because we've been discussing it so long, but
> > > without that background it could be subtle.
> > >     
> > >>>>>> + * 4. To start resuming phase, VFIO device state should be transitioned from
> > >>>>>> + *    _RUNNING to _RESUMING state.
> > >>>>>> + *    In _RESUMING state, driver should use received device state data through
> > >>>>>> + *    migration region to resume device.
> > >>>>>> + *    On failure during this state transition, application should set _RUNNING
> > >>>>>> + *    state.  
> > >>>>>
> > >>>>> Same comment regarding setting next state after failure.  
> > >>>>
> > >>>> If device couldn't be transitioned to _RESUMING, then it should be set
> > >>>> to default state, that is _RUNNING.
> > >>>>     
> > >>>>>         
> > >>>>>> + * 5. On providing saved device data to driver, appliation should change state
> > >>>>>> + *    from _RESUMING to _RUNNING.
> > >>>>>> + *    On failure to transition to _RUNNING state, VFIO application should reset
> > >>>>>> + *    the device and set _RUNNING state so that device doesn't remain in unknown
> > >>>>>> + *    or bad state. On reset, driver must reset device and device should be
> > >>>>>> + *    available in default usable state.  
> > >>>>>
> > >>>>> Didn't we discuss that the reset ioctl should return the device to the
> > >>>>> initial state, including the transition to _RUNNING?  
> > >>>>
> > >>>> Yes, that's default usable state, rewording it to initial state.
> > >>>>     
> > >>>>>    Also, as above,
> > >>>>> it's the user write that triggers the failure, this register is listed
> > >>>>> as read-write, so what value does the vendor driver report for the
> > >>>>> state when read after a transition failure?  Is it reported as _RESUMING
> > >>>>> as it was prior to the attempted transition, or may the invalid states
> > >>>>> be used by the vendor driver to indicate the device is broken?
> > >>>>>         
> > >>>>
> > >>>> If transition as failed, device should report its previous state and
> > >>>> reset device should bring back to usable _RUNNING state.  
> > >>>
> > >>> If device_state reports previous state then user should reasonably
> > >>> infer that the device is already in that sate without a need for them
> > >>> to set it, IMO.  
> > >>
> > >> But if there is any error in read()/write() then user should device
> > >> which next state device should be put in, which would be different that
> > >> previous state.  
> > > 
> > > That's a different answer than telling the user the next state should
> > > be _RUNNING.
> > >   
> > >>>>>> + *
> > >>>>>> + * pending bytes: (read only)
> > >>>>>> + *      Number of pending bytes yet to be migrated from vendor driver
> > >>>>>> + *
> > >>>>>> + * data_offset: (read only)
> > >>>>>> + *      User application should read data_offset in migration region from where
> > >>>>>> + *      user application should read device data during _SAVING state or write
> > >>>>>> + *      device data during _RESUMING state. See below for detail of sequence to
> > >>>>>> + *      be followed.
> > >>>>>> + *
> > >>>>>> + * data_size: (read/write)
> > >>>>>> + *      User application should read data_size to get size of data copied in
> > >>>>>> + *      bytes in migration region during _SAVING state and write size of data
> > >>>>>> + *      copied in bytes in migration region during _RESUMING state.
> > >>>>>> + *
> > >>>>>> + * Migration region looks like:
> > >>>>>> + *  ------------------------------------------------------------------
> > >>>>>> + * |vfio_device_migration_info|    data section                      |
> > >>>>>> + * |                          |     ///////////////////////////////  |
> > >>>>>> + * ------------------------------------------------------------------
> > >>>>>> + *   ^                              ^
> > >>>>>> + *  offset 0-trapped part        data_offset
> > >>>>>> + *
> > >>>>>> + * Structure vfio_device_migration_info is always followed by data section in
> > >>>>>> + * the region, so data_offset will always be non-0. Offset from where data is
> > >>>>>> + * copied is decided by kernel driver, data section can be trapped or mapped
> > >>>>>> + * or partitioned, depending on how kernel driver defines data section.
> > >>>>>> + * Data section partition can be defined as mapped by sparse mmap capability.
> > >>>>>> + * If mmapped, then data_offset should be page aligned, where as initial section
> > >>>>>> + * which contain vfio_device_migration_info structure might not end at offset
> > >>>>>> + * which is page aligned. The user is not required to access via mmap regardless
> > >>>>>> + * of the region mmap capabilities.
> > >>>>>> + * Vendor driver should decide whether to partition data section and how to
> > >>>>>> + * partition the data section. Vendor driver should return data_offset
> > >>>>>> + * accordingly.
> > >>>>>> + *
> > >>>>>> + * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy phase
> > >>>>>> + * and for _SAVING device state or stop-and-copy phase:
> > >>>>>> + * a. read pending_bytes, indicates start of new iteration to get device data.
> > >>>>>> + *    If there was previous iteration, then this read operation indicates
> > >>>>>> + *    previous iteration is done. If pending_bytes > 0, go through below steps.
> > >>>>>> + * b. read data_offset, indicates kernel driver to make data available through
> > >>>>>> + *    data section. Kernel driver should return this read operation only after
> > >>>>>> + *    data is available from (region + data_offset) to (region + data_offset +
> > >>>>>> + *    data_size).
> > >>>>>> + * c. read data_size, amount of data in bytes available through migration
> > >>>>>> + *    region.
> > >>>>>> + * d. read data of data_size bytes from (region + data_offset) from migration
> > >>>>>> + *    region.
> > >>>>>> + * e. process data.
> > >>>>>> + * f. Loop through a to e.  
> > >>>>>
> > >>>>> It seems we always need to end an iteration by reading pending_bytes to
> > >>>>> signal to the vendor driver to release resources, so should the end of
> > >>>>> the loop be:
> > >>>>>
> > >>>>> e. Read pending_bytes
> > >>>>> f. Goto b. or optionally restart next iteration at a.
> > >>>>>
> > >>>>> I think this is defined such that reading data_offset commits resources
> > >>>>> and reading pending_bytes frees them, allowing userspace to restart at
> > >>>>> reading pending_bytes with no side-effects.  Therefore reading
> > >>>>> pending_bytes repeatedly is supported.  Is the same true for
> > >>>>> data_offset and data_size?  It seems reasonable that the vendor driver
> > >>>>> can simply return offset and size for the current buffer if the user
> > >>>>> reads these more than once.
> > >>>>>        
> > >>>>
> > >>>> Right.  
> > >>>
> > >>> Can we add that to the spec?
> > >>>      
> > >>
> > >> ok.
> > >>  
> > >>>>> How is a protocol or device error signaled?  For example, we can have a
> > >>>>> user error where they read data_size before data_offset.  Should the
> > >>>>> vendor driver generate a fault reading data_size in this case.  We can
> > >>>>> also have internal errors in the vendor driver, should the vendor
> > >>>>> driver use a special errno or update device_state autonomously to
> > >>>>> indicate such an error?  
> > >>>>
> > >>>> If there is any error during the sequence, vendor driver can return
> > >>>> error code for next read/write operation, that will terminate the loop
> > >>>> and migration would fail.  
> > >>>
> > >>> Please add to spec.
> > >>>      
> > >>
> > >> Ok
> > >>  
> > >>>>> I believe it's also part of the intended protocol that the user can
> > >>>>> transition from _SAVING|_RUNNING to _SAVING at any point, regardless of
> > >>>>> pending_bytes.  This should be noted.
> > >>>>>         
> > >>>>
> > >>>> Ok. Updating comment.
> > >>>>     
> > >>>>>> + *
> > >>>>>> + * Sequence to be followed while _RESUMING device state:
> > >>>>>> + * While data for this device is available, repeat below steps:
> > >>>>>> + * a. read data_offset from where user application should write data.
> > >>>>>> + * b. write data of data_size to migration region from data_offset.  
> > >>>>>
> > >>>>> Whose's data_size, the _SAVING end or the _RESUMING end?  I think this
> > >>>>> is intended to be the transaction size from the _SAVING source,  
> > >>>>
> > >>>> Not necessarily. data_size could be MIN(transaction size of source,
> > >>>> migration data section). If migration data section is smaller than data
> > >>>> packet size at source, then it has to be broken and iteratively sent.  
> > >>>
> > >>> So you're saying that a transaction from the source is divisible by the
> > >>> user under certain conditions.  What other conditions exist?  
> > >>
> > >> I don't think there are any other conditions than above.
> > >>  
> > >>>   Can the
> > >>> user decide arbitrary sizes less than the MIN() stated above?  This
> > >>> needs to be specified.
> > >>>     
> > >>
> > >> No, User can't decide arbitrary sizes.  
> > > 
> > > TBH, I'd expect a vendor driver that offers a different migration
> > > region size, such that it becomes the user's responsibility to split
> > > transactions should just claim it's not compatible with the source, as
> > > determined by the previously defined compatibility protocol.  If we
> > > really need this requirement, it needs to be justified and the exact
> > > conditions under which the user performs this needs to be specified.
> > >   
> > 
> > Let User decide whether it wants to support different migration region 
> > sizes at source and destination or not instead of putting hard requirement.
> 
> The requirement is set forth by the vendor driver.  The user has no
> choice how big a BAR region is for a vfio-pci device.  Perhaps if they
> have internal knowledge of the device they might be able to only use
> part of the BAR, but as decided previously the migration data is
> intended to be opaque to the user.  If the user gets to decide the
> migration region size then we're back to an interface where the vendor
> driver is required to support arbitrary transaction sizes dictated by
> the user splitting the data.
> 
> > >>>>> but it
> > >>>>> could easily be misinterpreted as reading data_size on the _RESUMING
> > >>>>> end.
> > >>>>>         
> > >>>>>> + * c. write data_size which indicates vendor driver that data is written in
> > >>>>>> + *    staging buffer. Vendor driver should read this data from migration
> > >>>>>> + *    region and resume device's state.  
> > >>>>>
> > >>>>> I think we also need to define the error protocol.  The user could
> > >>>>> mis-order transactions or there could be an internal error in the
> > >>>>> vendor driver or device.  Are all read(2)/write(2) operations
> > >>>>> susceptible to defined errnos to signal this?  
> > >>>>
> > >>>> Yes.  
> > >>>
> > >>> And those defined errnos are specified...
> > >>>      
> > >>
> > >> Those could be standard errors like -EINVAL, ENOMEM....  
> > > 
> > > I thought we might specify specific errors to consistently indicate
> > > non-continuable faults among vendor drivers.  Is anything other than
> > > -EAGAIN considered non-fatal to the operation?  For example, could
> > > EEXIST indicate duplicate data that the user has already written but
> > > not be considered a fatal error?  Would EFAULT perhaps indicate a
> > > continuable ordering error?  If any fault indicates the save/resume has
> > > failed, shouldn't the user be able to see the device is in such a state
> > > by reading device_state (except we have no state defined to indicate
> > > that)?
> > >     
> > 
> > Do we have to define all standard errors returned here would mean meant 
> > what?
> > 
> > Right from initial versions of migration reviews we always thought that 
> > device_state should be only set by user, vendor driver could return 
> > error state was never thought of. Returning error to read()/write() 
> > operation indicate that device is not able to handle that operation so 
> > user will decide what action to be taken next.
> > Now you are proposing to add a state that vendor driver can set, as 
> > defined in my above comment?
> 
> The question is how does the user decide what action to be taken next.
> Defining specific errnos (not all of them) might aid in that decision.
> Maybe the simplest course of action is to require that the user is
> perfect, if they duplicate a transaction or misorder anything on the
> resuming end, we generate an errno on write(2) to the data area and the
> device goes to device_state 110b.  This makes it clear that we are no
> longer in a resuming state and the user needs to start over by
> resetting the device.  An internal error on resume would be handled the
> same.
> 
> On saving, the responsibility is primarily with the vendor driver, but
> transitioning the device_state to invalid and requiring a reset should
> not be taken as lightly as the resume path.  So does any errno on
> read(2) during the saving protocol indicate failure?  Would the vendor
> driver self-transition to !_SAVING in device_state?
> 
> For both cases, do we want to make an exception for -EAGAIN as
> non-fatal?
> 
> > >>>>>    Is it reflected in
> > >>>>> device_state?  
> > >>>>
> > >>>> No.  
> > >>>
> > >>> So a user should do what, just keep trying?
> > >>>     
> > >>
> > >> No, fail migration process. If error is at source or destination then
> > >> user can decide either resume at source or terminate application.  
> > > 
> > > This is describing the expected QEMU protocol resolution, the question
> > > is relative to the vfio API we're defining here.  If any fault in the
> > > save/resume protocol results in the device being unusable, there should
> > > be an indication (perhaps through device_state) that the device is in a
> > > broken state, and the mechanism to put it into a new state should be
> > > defined.  For instance, if the device is resuming, a fault occurs
> > > writing state data to the device, and the user transitions to running.
> > > Is the device incorporating the partial state data into its run state?
> > > I suspect not, and wouldn't that be more obvious if we defined a
> > > protocol where the device can be inspected to be in a bogus state via
> > > reading device_state, at which point we might define performing a
> > > device reset as the only mechanism to change the device_state after
> > > that point.
> > >  
> > 
> > Same as above my comment.
> > 
> > >>>>> What's the recovery protocol?
> > >>>>>         
> > >>>>
> > >>>> On read()/write() failure user should take necessary action.  
> > >>>
> > >>> Where is that necessary action defined?  Can they just try again?  Do
> > >>> they transition in and out of _RESUMING to try again?  Do they need to
> > >>> reset the device?
> > >>>      
> > >>
> > >> User application should decide what action to take on failure, right?
> > >>    "vfio is not prescribing the migration semantics to userspace, it's
> > >> presenting an interface that support the user semantics."  
> > > 
> > > Exactly, we're not defining how QEMU handles a fault in this spec,
> > > we're defining how a user interacting with the device knows a fault has
> > > occurred, can inspect the device to determine that the device is in a
> > > broken state, and the "necessary action" to advance the device forward
> > > to a new state.
> > >   
> > >>>>>> + *
> > >>>>>> + * For user application, data is opaque. User should write data in the same
> > >>>>>> + * order as received.  
> > >>>>>
> > >>>>> Order and transaction size, ie. each data_size chunk is indivisible by
> > >>>>> the user.  
> > >>>>
> > >>>> Transaction size can differ, but order should remain same.  
> > >>>
> > >>> Under what circumstances and to what extent can transaction size
> > >>> differ?  
> > >>
> > >> It depends in migration region size.
> > >>  
> > >>>   Is the MIN() algorithm above the absolute lower bound or just
> > >>> a suggestion?  
> > >>
> > >>
> > >>  
> > >>>   Is the user allowed to concatenate transactions from the
> > >>> source together on the target if the region is sufficiently large?  
> > >>
> > >> Yes that can be done, because data is just byte stream for user. Vendor
> > >> driver receives the byte stream and knows how to decode it.  
> > > 
> > > But that byte stream is opaque to the user, the vendor driver might
> > > implement it such that every transaction has a header and splitting the
> > > transaction might mean that the truncated transaction no longer fits
> > > the expected size.  If we're lucky, the vendor driver's implementation
> > > might detect that.  If we're not, the vendor driver might misinterpret
> > > the next packet.  I think if the user is to consider all data as
> > > opaque, they must also consider every transaction as indivisible or
> > > else we're assuming something about the contents of that transaction.
> > >   
> > 
> > User shouldn't assume about contents of transactions.
> > I think vendor driver should consider incomming data as data byte stream 
> > and decoding packets should not be based on migration region size.
> 
> I think this likely matches your implementation, but even defining the
> migration stream as a byte stream imposes implementation constraints on
> other vendor drivers.  They may intend to implement it as discrete
> packets with headers known only to them.  We can't both say it's "opaque
> and left to the vendor driver" and also define it as a position-less
> byte stream.  Thanks,
> 
> Alex
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

