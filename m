Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD70A1D4A8C
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 12:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgEOKLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 06:11:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48524 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728030AbgEOKLo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 06:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589537502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5n/q0ZEk+eSi54ONI3TrFG41fshVuLJSHEwmOtF5WA=;
        b=E3yzjVHXCnUJLX06m9f/delrggl7qgIPpc8CXG4QScvvyCqiLwZuZYPtOXGSA51Ayv6meY
        saFpoQBxnOHbcPfqW+VDNCcVubCYr5HCBZ8jo/3TuT0MJDMtycOqYkROHC7NX0UTuLqVKv
        6/1hG8cmfI8VJG1WEscVw93ggP+CI0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-8QfXHDDlOXa3XMPvsgCtYw-1; Fri, 15 May 2020 06:11:34 -0400
X-MC-Unique: 8QfXHDDlOXa3XMPvsgCtYw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E09CF100A8EF;
        Fri, 15 May 2020 10:11:33 +0000 (UTC)
Received: from [10.36.112.179] (ovpn-112-179.ams2.redhat.com [10.36.112.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8465B6FDB2;
        Fri, 15 May 2020 10:11:32 +0000 (UTC)
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Micah Morton <mortonm@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
References: <20200511220046.120206-1-mortonm@chromium.org>
 <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
 <20200513083401.11e761a7@x1.home>
 <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com>
 <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
 <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com>
 <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7f4c8f6c-ff33-d574-855a-eb8b312019af@redhat.com>
Date:   Fri, 15 May 2020 12:11:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Micah,

On 5/14/20 7:44 PM, Micah Morton wrote:
> On Wed, May 13, 2020 at 3:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 13/05/20 21:10, Micah Morton wrote:
>>> * If we only care about the bus controller existing (in an emulated
>>> fashion) enough for the guest to discover the device in question, this
>>> could work. I’m concerned that power management could be an issue here
>>> however. For instance, I have a touchscreen device assigned to the
>>> guest (irq forwarding done with this module) that in response to the
>>> screen being touched prepares the i2c controller for a transaction by
>>> calling into the PM system which end up writing to the PCI config
>>> space** (here https://elixir.bootlin.com/linux/v5.6.12/source/drivers/i2c/busses/i2c-designware-master.c#L435).
>>> It seems like this kind of scenario expands the scope of what would
>>> need to be supported by the emulated i2c controller, which is less
>>> ideal. The way I have it currently working, vfio-pci emulates the PCI
>>> config space so the guest can do power management by accessing that
>>> space.
>>
>> This wouldn't be a problem.  When the emulated i2c controller starts a
>> transaction on th edevice, it will be performed by the host i2c
>> controller and this will lead to the same config space write.
> 
> I guess what you're saying is there would be an i2c controller
> (emulated PCI device) in the guest and the i2c device driver would
> still call i2c_dw_xfer as above and the execution in the guest would
> still continue all the way to pci_write_config_word(). Then when the
> guest executes the actual config write it would trap to the host,
> which would need to have the logic that the guest is trying to do
> runtime PM commands on an emulated PCI device so we need to step in
> and reset the actual PCI device on the host that backs that emulated
> device. Is this right?
> 
> Again, this is assuming we have the infrastructure to pass platform
> devices on x86 to the guest with vfio-platform, which I don't think is
> the case. +Auger Eric (not sure why gmail puts your name backwards)
> would you be able to comment on this based on my previous message?

VFIO_PLATFORM only is compiled on ARM today but that's probably not the
main issue here. I don't know if the fact the platform devices you want
to assign are behind this PCI I2C controller does change anything in the
way we would bind the devices to vfio-platform.

Up to now, in QEMU we have only generated DT bindings for the assigned
platform devices. Generating AML code has never been experienced.

What I don't get in your existing POC is how your enumerate the platform
devices resources (regs, IRQs) behing your controller. I understand you
devised a solution to expose the specific IRQ but what about regs? How
are they presented to your guest?

Thanks

Eric


> 
>>
>> I have another question: would it be possible to expose this IRQ through
>> /dev/i2c-* instead of messing with VFIO?
>>
>> In fact, adding support for /dev/i2c passthrough to QEMU has long been a
>> pet idea of mine (my usecase was different though: the idea was to write
>> programs for a microcontroller on an ARM single board computer and run
>> them under QEMU in emulation mode).  It's not trivial, because there
>> could be some impedence mismatch between the guest (which might be
>> programmed against a low-level controller or might even do bit banging)
>> and the i2c-dev interface which is more high level.  Also QEMU cannot do
>> clock stretching right now.  However, it's certainly doable.
> 
> I agree that would be a cool thing to have in QEMU. Unfortunately I am
> interested in assigning other PCI bus controllers to a guest VM and
> (similar to the i2c example above) in some cases these busses (e.g.
> LPC, SPI) have devices with arbitrary interrupts that need to be
> forwarded into the guest for things to work.
> 
> I realize this may seem like an over-use of VFIO, but I'm actually
> coming from the angle of wanting to assign _most_ of the important
> hardware on my device to a VM guest, and I'm looking to avoid
> emulation wherever possible. Of course there will be devices like the
> IOAPIC for which emulation is unavoidable, but I think emulation is
> avoidable here for the busses we've mentioned if there is a way to
> forward arbitrary interrupts into the guest.
> 
> Since all these use cases are so close to working with vfio-pci right
> out of the box, I was really hoping to come up with a simple and
> generic solution to the arbitrary interrupt problem that can be used
> for multiple bus types.
> 
>>
>>>> (Finally, in the past we were doing device assignment tasks within KVM
>>>> and it was a bad idea.  Anything you want to do within KVM with respect
>>>> to device assignment, someone else will want to do it from bare metal.
>>>
>>> Are you saying people would want to use this in non-virtualized
>>> scenarios like running drivers in userspace without any VMM/guest? And
>>> they could do that if this was part of VFIO and not part of KVM?
>>
>> Yes, see above for an example.
>>
>> Paolo
>>
> 

