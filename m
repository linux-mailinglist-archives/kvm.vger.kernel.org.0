Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D326345CA72
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 17:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhKXQ7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 11:59:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241659AbhKXQ7J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 11:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637772959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1mVefncImkNOqFiqCPdf9K+lpakEpL+8Ti7m+pQo4ZU=;
        b=ZBpGuMBT56PTVpgc5O0IKgDgP07dt4E8KgOGtTlEGBpTyrnh3SnY/682IlRbIqc2fYXAPz
        zhAZucrmOR6qB/7jZftgsUN8paP4hLMMGDg4C/i8zdctIkwzXdmb8QTnzJYYsYLJ/Yw0TP
        kEu3gxxmF+iTpU3KO5Rye2IQRszZL8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-k62SVXxuOy-Tts5n7KUAYw-1; Wed, 24 Nov 2021 11:55:56 -0500
X-MC-Unique: k62SVXxuOy-Tts5n7KUAYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B5881030C22;
        Wed, 24 Nov 2021 16:55:54 +0000 (UTC)
Received: from localhost (unknown [10.39.193.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48B995D9CA;
        Wed, 24 Nov 2021 16:55:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
In-Reply-To: <20211123165352.GA4670@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
 <87zgpvj6lp.fsf@redhat.com> <20211123165352.GA4670@nvidia.com>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Wed, 24 Nov 2021 17:55:49 +0100
Message-ID: <87fsrljxwq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 23, 2021 at 03:21:06PM +0100, Cornelia Huck wrote:
>> On Mon, Nov 22 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>> > For VMMs they can also control if the VCPUs in
>> > +a VM are executing (VCPU RUNNING) and if the IOMMU is logging DMAs (DIRTY
>> > +TRACKING). These two controls are not part of the device_state register, KVM
>> > +will be used to control the VCPU and VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the
>> > +container controls dirty tracking.
>> 
>> We usually try to keep kvm out of documentation for the vfio
>> interfaces; better frame that as an example?
>
> It is important, we can't clearly explain how things like PRI work or
> NDMA without talking about a 'VCPU' concept. I think this is a case
> where trying to be general is only going to hurt understandability.
>
> Lets add some more text like 'VCPU RUNNING is used to model the
> ability of the VFIO userspace to mutate the device. For VMM cases this
> would be mapped to a KVM control on a VCPU, but non VMMs must also
> similarly suspend their use of the VFIO device in !VCPU_RUNNING'

Yes, defining what we mean by "VCPU RUNNING" and "DIRTY TRACKING" first
makes the most sense.

(It also imposes some rules on userspace, doesn't it? Whatever it does,
the interaction with vfio needs to be at least somewhat similar to what
QEMU or another VMM would do. I wonder if we need to be more concrete
here; but let's talk about the basic interface first.)

>
>> > +Along with the device_state the migration driver provides a data window which
>> > +allows streaming migration data into or out of the device.
>> > +
>> > +A lot of flexibility is provided to userspace in how it operates these bits. The
>> > +reference flow for saving device state in a live migration, with all features:
>> 
>> It may also vary depending on the device being migrated (a subchannel
>> passed via vfio-ccw will behave differently than a pci device.)
>
> I don't think I like this statement - why/where would the overall flow
> differ?

What I meant to say: If we give userspace the flexibility to operate
this, we also must give different device types some flexibility. While
subchannels will follow the general flow, they'll probably condense/omit
some steps, as I/O is quite different to PCI there.

>  
>> > +  RUNNING, VCPU_RUNNING
>> 
>> Nit: everywhere else you used "VCPU RUNNING".
>
> Oh, lets stick with the _ version then
>  
>> Also, can we separate device state bits as defined in vfio.h and VMM
>> state bits visually a bit :) better?
>
> Any idea? I used | for the migration_state and , for the externa ones.

Not any good one :( Maybe separate by tabs? We could probably coax the
generated documents into something more distinct, but it's not that easy
to do with normal text.

>
>> > +     Normal operating state
>> > +  RUNNING, DIRTY TRACKING, VCPU RUNNING
>> > +     Log DMAs
>> > +     Stream all memory
>> 
>> all memory accessed by the device?
>
> In this reference flow this is all VCPU memory. Ie you start global
> dirty tracking both in VFIO and in the VCPU and start copying all VM
> memory.

So, general migration, not just the vfio specific parts?

>
>> > +Actions on Set/Clear:
>> > + - SAVING | RUNNING
>> > +   The device clears the data window and begins streaming 'pre copy' migration
>> > +   data through the window. Device that cannot log internal state changes return
>> > +   a 0 length migration stream.
>> 
>> Hm. This and the following are "combination states", i.e. not what I'd
>> expect if I read about setting/clearing bits. 
>
> If you examine the mlx5 driver you'll see this is how the logic is
> actually implemented. It is actually very subtly complicated to
> implement this properly. I also added this text:
>
>  When multiple bits change in the migration_state the migration driver must
>  process them in a priority order:
>
>  - SAVING | RUNNING
>  - !RUNNING
>  - !NDMA
>  - SAVING | !RUNNING
>  - RESUMING
>  - !RESUMING
>  - NDMA
>  - RUNNING
>
> The combination states are actually two bit states and entry/exit are
> defined in terms of both bits.

"subtly complicated" captures this well :(

For example, if I interpret your list correctly, the driver should
prioritize clearing RUNNING over setting SAVING | !RUNNING. What does
that mean? If RUNNING is cleared, first deal with whatever action that
triggers, then later check if it is actually a case of setting SAVING |
!RUNNING, and perform the required actions for that?

Also, does e.g. SAVING | RUNNING mean that both SAVING and RUNNING are
getting set, or only one of them, if the other was already set?

>
>> What you describe is what happens if the device has RUNNING set and
>> additionally SAVING is set, isn't it? 
>
> Any change in SAVING & RUNNING that results in the new value being
> SAVING | RUNNING must follow the above description.
>
> So
>   SAVING|0 -> SAVING|RUNNING
>   0|RUNNING -> SAVING|RUNNING
>   0 -> SAVING|RUNNING
>
> Are all valid ways to reach this action.

Yeah, that's what I meant -- this is not very obvious from the
description.

>
> This is the substantive difference between the actions and the
> continuous, here something specific happes only on entry: 'clears the
> data window and begins'
>
> vs something like NDMA which is just continuously preventing DMA.

Hm. I'm still not quite convinced whether that is a good distinction to
make. I'll read on.

>
>> > + - SAVING | !RUNNING
>> > +   The device captures its internal state and begins streaming migration data
>> > +   through the migration window
>> > +
>> > + - RESUMING
>> > +   The data window is opened and can receive the migration data.
>> > +
>> > + - !RESUMING
>> > +   All the data transferred into the data window is loaded into the device's
>> > +   internal state. The migration driver can rely on userspace issuing a
>> > +   VFIO_DEVICE_RESET prior to starting RESUMING.
>> 
>> Can we also fail migration? I.e. clearing RESUMING without setting RUNNING.
>
> No, once RESUMING clears migration cannot be forced to fail, to abort
> userspace should trigger reset.
>
> This deserves some more language:
>
> If the migration data is invalid the device should go to the ERROR state.

Ok.

>
>> > + - DIRTY TRACKING
>> > +   On set clear the DMA log and start logging
>> > +
>> > +   On clear freeze the DMA log and allow userspace to read it. Userspace must
>> > +   take care to ensure that DMA is suspended before clearing DIRTY TRACKING, for
>> > +   instance by using NDMA.
>> > +
>> > +   DMA logs should be readable with an "atomic test and clear" to allow
>> > +   continuous non-disruptive sampling of the log.
>> 
>> I'm not sure whether including DIRTY TRACKING with the bits in
>> device_state could lead to confusion...
>
> It is part of the flow and userspace must sequence it properly, just
> like VCPU. We can't properly describe everything without talking about
> it.

We probably want to clearly distinguish (visually at least) between the
bits in the device_state and VCPU RUNNING/DIRTY TRACKING. Even if both
are needed to implement vfio migration correctly, one is more strictly
defined as an interface, while for the other we rely more on the
functionality.

>
>> > +Continuous Actions:
>> > +  - NDMA
>> > +    The device is not allowed to issue new DMA operations.
>> 
>> Doesn't that make it an action trigger as well? I.e. when NDMA is set, a
>> blocker for DMA operations is in place?
>
> For clarity I didn't split things like that. All the continuous
> behaviors start when the given bits begins and stop when the bits
> end.
>
> Most of the actions talk about changes in the data window

This might need some better terminology, I did not understand the split
like that...

"action trigger" is basically that the driver sets certain bits and a
certain device action happens. "continuous" means that a certain device
action is done as long as certain bits are set. Sounds a bit like edge
triggered vs level triggered to me. What about:

- event-triggered actions: bits get set/unset, an action needs to be
  done
- condition-triggered actions: as long as bits are set/unset, an action
  needs to be done

>  
>> > +    Before NDMA returns all in progress DMAs must be completed.
>> 
>> What does that mean? That the operation setting NDMA in device_state
>> returns? 
>
> Yes, it must be a synchronous behavior.

To be extra clear: the _setting_ action (e.g. a write), not the
condition (NDMA set)? Sorry if that sounds nitpicky, but I think we
should eliminate possible points of confusion early on.

>
>> > +  - !RUNNING
>> > +    The device should not change its internal state. Implies NDMA. Any internal
>> > +    state logging can stop.
>> 
>> So we have:
>> - !RUNNING -- no DMA, regardless whether NDMA is set
>> - RUNNING|NDMA -- the device can change its internal state, but not do
>>   DMA
>> 
>> !RUNNING|!NDMA would basically be a valid state if a device is stopped
>> before RESUMING, but not for outbound migration?
>
> The reference flows are just examples we can all think on, it is
> always valid to go to any of the legal bit patterns, but may not be
> useful.

Maybe we need to be more clear what is part of the reference flows vs
part of the interface rules, not sure.

>  
> This specifically not a FSM so any before/after migration_state is
> technically legal and the device should behave as described here.
>
>> > +  - SAVING | !RUNNING
>> > +    RESUMING | !RUNNING
>> > +    The device may assume there are no incoming MMIO operations.
>> > +
>> > +  - RUNNING
>> > +    The device can alter its internal state and must respond to incoming MMIO.
>> > +
>> > +  - SAVING | RUNNING
>> > +    The device is logging changes to the internal state.
>> > +
>> > +  - !VCPU RUNNING
>> > +    The CPU must not generate dirty pages or issue MMIO operations to devices.
>> > +
>> > +  - DIRTY TRACKING
>> > +    DMAs are logged
>> > +
>> > +  - ERROR
>> > +    The behavior of the device is undefined. The device must be recovered by
>> > +    issuing VFIO_DEVICE_RESET.
>> > +
>> 
>> I'm wondering whether it would be better to distinguish between
>> individual bit meanings vs composite states than set/clear actions vs
>> continuous actions. This could give us a good overview about what a
>> device can/should do while in a certain state and what flipping a
>> certain bit implies.
>
> Again, refer to the mlx5 implementation, there are not actually
> individual bits here controlling specific things. SAVING for instance
> has no device behavior meaning when discussed in isolation.

See my suggestion about revised naming above, I probably simply did not
understand what you were trying to express here.

I'm trying to understand this document without looking at the mlx5
implementation: Somebody using it as a guide needs to be able to
implement a driver without looking at another driver (unless they prefer
to work with examples.) Using the mlx5 driver as the basis for
_writing_ this document makes sense, but it needs to stand on its own.

