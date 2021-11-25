Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E663345DA08
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 13:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350570AbhKYMbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 07:31:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350555AbhKYMak (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 07:30:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637843248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E0ws/JHuSa6Tb9j7eo6eI5HRWp80n6jiMP5g8Ag673A=;
        b=VDfaCM9MVKIzPtdxb5+D/LfPoHZ91JItHl9gL57uQKsWesdseDXulQVBacgl7oEb3iQYqr
        I+TgH1Or1KpEOhT7UZWIWl4ntOKBvT5Bvez/yzsjOGWzVhMX2v+y4fNW5UVinf7AjCXM5k
        RsXQR1Z094A9lTeiHw2AO5Q7L+xWD0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-DiIwKDadMnmtpABQaci6Zw-1; Thu, 25 Nov 2021 07:27:25 -0500
X-MC-Unique: DiIwKDadMnmtpABQaci6Zw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBBFC190B2AE;
        Thu, 25 Nov 2021 12:27:23 +0000 (UTC)
Received: from localhost (unknown [10.39.193.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F6C919D9F;
        Thu, 25 Nov 2021 12:27:14 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
In-Reply-To: <20211124184020.GM4670@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com> <20211123165352.GA4670@nvidia.com>
 <87fsrljxwq.fsf@redhat.com> <20211124184020.GM4670@nvidia.com>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Thu, 25 Nov 2021 13:27:12 +0100
Message-ID: <87a6hsju8v.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Nov 24, 2021 at 05:55:49PM +0100, Cornelia Huck wrote:

>> What I meant to say: If we give userspace the flexibility to operate
>> this, we also must give different device types some flexibility. While
>> subchannels will follow the general flow, they'll probably condense/omit
>> some steps, as I/O is quite different to PCI there.
>
> I would say no - migration is general, no device type should get to
> violate this spec.  Did you have something specific in mind? There is
> very little PCI specific here already

I'm not really thinking about violating the spec, but more omitting
things that do not really apply to the hardware. For example, it is
really easy to shut up a subchannel, we don't really need to wait until
nothing happens anymore, and it doesn't even have MMIO. Also, I can't
imagine what e.g. ap would do. Granted, those are outliers, most devices
won't be too different from pci.

>> For example, if I interpret your list correctly, the driver should
>> prioritize clearing RUNNING over setting SAVING | !RUNNING. What does
>> that mean? If RUNNING is cleared, first deal with whatever action that
>> triggers, then later check if it is actually a case of setting SAVING |
>> !RUNNING, and perform the required actions for that?
>
> Yes.
>
> Since this is not a FSM a change from any two valid device_state
> values is completely legal. Many of these involve multiple driver
> steps. So all drivers must do the actions in the same order to have a
> real ABI.

Ok, I understand what you mean.

>
>> Also, does e.g. SAVING | RUNNING mean that both SAVING and RUNNING are
>> getting set, or only one of them, if the other was already set?
>
> It always refers to the requested migration_state
>
>> >   SAVING|0 -> SAVING|RUNNING
>> >   0|RUNNING -> SAVING|RUNNING
>> >   0 -> SAVING|RUNNING
>
> Are all described as userspace requesting a migration_state 
> of SAVING | RUNNING

ok

>> - event-triggered actions: bits get set/unset, an action needs to be
>>   done
>
> """Event-triggered actions happen when userspace requests a new
> migration_state that differs from the current migration_state. Actions
> happen on a bit group basis:"""
>
>> - condition-triggered actions: as long as bits are set/unset, an action
>>   needs to be done
>
> """Continuous actions are in effect so long as the below migration_state bit
>    group is active:"""

Ok, that works for me.

>  
>
>> >> What does that mean? That the operation setting NDMA in device_state
>> >> returns? 
>> >
>> > Yes, it must be a synchronous behavior.
>> 
>> To be extra clear: the _setting_ action (e.g. a write), not the
>> condition (NDMA set)? Sorry if that sounds nitpicky, but I think we
>> should eliminate possible points of confusion early on.
>
> ""Whenever the kernel returns with a migration_state of NDMA there can be no
>    in progress DMAs.""

ok

> Below is where I have things now:

(...)

The parts I had already read seem much clearer now, thanks.

> In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
> device back to device_state RUNNING. When a migration driver executes this
> ioctl it should discard the data window and set migration_state to RUNNING as
> part of resetting the device to a clean state. This must happen even if the
> migration_state has errored. A freshly opened device FD should always be in
> the RUNNING state.

Can the state immediately change from RUNNING to ERROR again?

>
> The migration driver has limitations on what device state it can affect. Any
> device state controlled by general kernel subsystems must not be changed
> during RESUME, and SAVING must tolerate mutation of this state. Change to
> externally controlled device state can happen at any time, asynchronously, to
> the migration (ie interrupt rebalancing).
>
> Some examples of externally controlled state:
>  - MSI-X interrupt page
>  - MSI/legacy interrupt configuration
>  - Large parts of the PCI configuration space, ie common control bits
>  - PCI power management
>  - Changes via VFIO_DEVICE_SET_IRQS
>
> During !RUNNING, especially during SAVING and RESUMING, the device may have
> limitations on what it can tolerate. An ideal device will discard/return all
> ones to all incoming MMIO/PIO operations (exclusive of the external state
> above) in !RUNNING. However, devices are free to have undefined behavior if
> they receive MMIOs. This includes corrupting/aborting the migration, dirtying
> pages, and segfaulting userspace.

Make this "MMIO, PIO, or equivalents"? For example, if we talk
subchannels, we might get an unsolicited state from the device (there's
no way to prevent that, until the subchannel has been completely disabled);
"discard it" would be the right answer here as well.

>
> However, a device may not compromise system integrity if it is subjected to a
> MMIO. It can not trigger an error TLP, it can not trigger a Machine Check, and
> it can not compromise device isolation.

"Machine Check" may be confusing to readers coming from s390; there, the
device does not trigger the machine check, but the channel subsystem
does, and we cannot prevent it. Maybe we can word it more as an example,
so readers get an idea what the limits in this state are?

(...)

> To elaborate details on the reference flows, they assume the following details
> about the external behaviors:
>
>  - !VCPU_RUNNING
>    Userspace must not generate dirty pages or issue MMIO operations to devices.

Generally, I/O operations? (Thinking of subchannels here again; if the
vcpu is not running, it cannot send I/O instructions.)

>    For a VMM this would typically be a control toward KVM.

I'm sorry, but I cannot parse this sentence... do you mean "implemented
by KVM"?

>
>  - DIRTY_TRACKING
>    Clear the DMA log and start DMA logging
>
>    DMA logs should be readable with an "atomic test and clear" to allow
>    continuous non-disruptive sampling of the log.
>
>    This is controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the container
>    fd.
>
>  - !DIRTY_TRACKING
>    Freeze the DMA log, stop tracking and allow userspace to read it.
>
>    If userspace is going to have any use of the dirty log it must ensure ensure
>    that all DMA is suspended before clearing DIRTY_TRACKING, for instance by
>    using NDMA or !RUNNING on all VFIO devices.

Although I would like to see some more feedback from others, I think
this is already a huge step in the right direction.

