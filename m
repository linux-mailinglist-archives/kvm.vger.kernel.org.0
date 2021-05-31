Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264F3396A2F
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 01:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhEaX5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 19:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhEaX5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 19:57:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E960FC061574;
        Mon, 31 May 2021 16:55:25 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622505322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5vmi0BzxnECvD2BBqu/D7TOOgm9sE7/xlUP8a9uvWs=;
        b=H5FKsko1bTRHWPqeQ2kRNRMqLN4bOcJ9nfCBeWkLBObvDeLp54FgetIr6v1e6QopS3QkSR
        mfx/tB377SutMQutlDIQByh9Wmyf+Ir3B/VbcQv3seYIJk101FW3G8m8k9HbaxbNGzzZ34
        D7LEaXY/QfL+XRnTx94MPwT+xivbHJVRCSUGgtlZXghkZ7v6+NVgZEkGQpOx/ZR/qmp9n5
        wLDBIeAat1f9eHTE3LXcsyyUNquKP8fb6EhKBa6oya4N7kINX/7K5g5lVBUdWjjOKcmotR
        d7+mMvuC91vmjVwuZtp8l3IKw88ieD4JadxykMSV5lPGLziC00ALD5SfqnehZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622505322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5vmi0BzxnECvD2BBqu/D7TOOgm9sE7/xlUP8a9uvWs=;
        b=EnKEeq4eCDQWpPXobGzy1vV5xqo1QlJ7DDzMdhqa/6bwfBXMdBYNq6bqLtaDAehgUQmAPu
        c/oCuCqK2sxtUICQ==
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
In-Reply-To: <20210531165754.GV1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com> <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com> <20210523235023.GL1002214@nvidia.com> <87mtsb3sth.ffs@nanos.tec.linutronix.de> <20210531165754.GV1002214@nvidia.com>
Date:   Tue, 01 Jun 2021 01:55:22 +0200
Message-ID: <875yyy31cl.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31 2021 at 13:57, Jason Gunthorpe wrote:
> On Mon, May 31, 2021 at 04:02:02PM +0200, Thomas Gleixner wrote:
>> > I'm quite surprised that every mdev doesn't create its own ims_domain
>> > in its probe function.
>> 
>> What for?
>
> IDXD wouldn't need it, but proper IMS HW with no bound of number of
> vectors can't provide a ims_info.max_slots value here.

There is no need to do so:

     https://lore.kernel.org/r/20200826112335.202234502@linutronix.de

which has the IMS_MSI_QUEUE variant at which you looked at and said:

 "I haven't looked through everything in detail, but this does look like
  it is good for the mlx5 devices."

ims_info.max_slots is a property of the IMS_MSI_ARRAY and does not make
any restrictions on other storage.
  
> Instead each use use site, like VFIO, would want to specify the number
> of vectors to allocate for its own usage, then parcel them out one by
> one in the normal way. Basically VFIO is emulating a normal MSI-X
> table.

Just with a size which exceeds a normal MSI-X table, but that's an
implementation detail of the underlying physical device. It does not put
any restrictions on mdev at all.

>> > This places a global total limit on the # of vectors which makes me
>> > ask what was the point of using IMS in the first place ?
>>
>> That depends on how IMS is implemented. The IDXD variant has a fixed
>> sized message store which is shared between all subdevices, so yet
>> another domain would not provide any value.
>
> Right, IDXD would have been perfectly happy to use the normal MSI-X
> table from what I can see.

Again. No, it's a storage size problem and regular MSI-X does not
support auxiliary data.

>> For the case where the IMS store is seperate, you still have one central
>> irqdomain per physical device. The domain allocation function can then
>> create storage on demand or reuse existing storage and just fill in the
>> pointers.
>
> I think it is philosophically backwards, and it is in part what is
> motivating pretending this weird auxdomain and PASID stuff is generic.

That's a different story and as I explained to Dave already hacking all
this into mdev is backwards, but that does not make your idea of a
irqdomain per mdev any more reasonable.

The mdev does not do anything irq chip/domain related. It uses what the
underlying physical device provides. If you think otherwise then please
provide me the hierarchical model which I explained here:

 https://lore.kernel.org/r/87h7tcgbs2.fsf@nanos.tec.linutronix.de
 https://lore.kernel.org/r/87bljg7u4f.fsf@nanos.tec.linutronix.de

> The VFIO model is the IRQ table is associated with a VM. When the
> vfio_device is created it decides how big the MSI-X table will be and
> it needs to allocate a block of interrupts to emulate it. For security
> those interrupts need to be linked in the HW to the vfio_device and
> the VM. ie VM A cannot trigger an interrupt that would deliver to VM
> B.

Fine.

> IDXD choose to use the PASID, but other HW might use a generic VM_ID.

So what?

> Further, IDXD choose to use a VM_ID per IMS entry, but other HW is
> likely to use a VM_ID per block of IMS entries. Ie the HW tree starts
> a VM object, then locates the IMS table for that object, then triggers
> the interrupt.

If you read my other reply to Dave carefuly then you might have noticed
that this is crap and irrelevant because the ID (whatever it is) is per
device and that ID has to be stored in the device. Whether the actual
irq chip/domain driver implementation uses it per associated irq or not
does not matter at all.

> If we think about the later sort of HW I don't think the whole aux
> data and domain per pci function makes alot of sense.

First of all that is already debunked and will go nowhere and second
there is no requirement to implement this for some other incarnation of
IMS when done correctly. That whole irq_set_auxdata() stuff is not going
anywhere simply because it's not needed at all.

All what's needed is a function to store some sort of ID per device
(mdev) and the underlying IMS driver takes care of what to do with it.

That has to happen before the interrupts are allocated and if that info
is invalid then the allocation function can reject it.

> You'd want a domain per VM_ID and all the IMS entires in that domain
> share the same VM_ID. In this regard the irq domain will correspond to
> the security boundary.

The real problems are:

  - Intel misled me with the requirement to set PASID after the fact
    which is simply wrong and what caused me to come up with that
    irq_set_auxdata() workaround.

  - Their absolute ignorance for proper layering led to adding all that
    irq_set_auxdata() muck to this mdev library.

Ergo, the proper thing to do is to fix this ID storage problem (PASID,
VM_ID or whatever) at the proper place, i.e. store it in struct device
(which is associated to that mdev) and let the individual drivers handle
it as they require.

It's that simple and this needs to be fixed and not some made up
philosophical question about irqdomains per mdev. Those would be even
worse than what Intel did here.

Thanks,

        tglx


