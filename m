Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E734564E8
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 22:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhKRVMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 16:12:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229514AbhKRVMR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 16:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637269756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Urfwj+y75PwDE5lU9UV+6XO4MbTLPXSUwzBb111QeTY=;
        b=XrabggJ9o0oqgLDtJJnuSlM0PpL8pGpo7Q/iZ4Uxdn5AqvEUtq9N8kNqEh+r+qGemJnlxR
        IMJ1aaOKUyZ5mYA1rOucwa7zNRsfdjO258VWYsXmgxR9YXhhS7qlpUbIjf4WOyOsDgCEoP
        zuUaTzLNGltAysJ/QBTMT16X6KHzO8o=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-FZ3IkA3JMx-jfwBqD9NX0w-1; Thu, 18 Nov 2021 16:09:15 -0500
X-MC-Unique: FZ3IkA3JMx-jfwBqD9NX0w-1
Received: by mail-oi1-f198.google.com with SMTP id r65-20020aca4444000000b002bce52a8122so1616357oia.14
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 13:09:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Urfwj+y75PwDE5lU9UV+6XO4MbTLPXSUwzBb111QeTY=;
        b=G1650HWIMG7izk95MmmZ/Lm+4SvDaWbzGGW2BTKRelAY3CO19jqrws0vGkeZztnD8b
         iiwLEG/HzkE2yo2FinEQrNyiT13GxUYcZ+zP7HZkGieTyhRWcn01kxR+S4b90L0XiaG0
         8WB+8QZSlLkw7yzG6b+ZYOet0Ue6Kpp6PQ9ib3p4+6ThCn1TiIJVG4XIf1OfTHaUS8my
         voYPEDpvoGf/DoXW1zE7BqoVYSRufn7FfrM26mHQd0WjVvcTsojT0Vupt6vkPU/hNcTf
         UiY1/BVUNpYP1BIQkL4vj/HWpafjg4EKbN8eokhfybh0SXkT6lx3Mya/9M1jGNO81eSQ
         Px4w==
X-Gm-Message-State: AOAM530Uw148eJYA+Jx3TS7S/+bl0wvfVPmg2RhmmAUWkBz5H/g2sNmi
        mCCuZecvU2ZnMrIWyncvyDoTBqcHWCv6icpmX51inqzBbzwuBISl87HjlRrv+HchuqjF7UAfTv3
        syane4FUzwZnf
X-Received: by 2002:aca:af50:: with SMTP id y77mr115153oie.134.1637269754742;
        Thu, 18 Nov 2021 13:09:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZ2jVBhIXRuJeKQxcIinFLrQGDRo0bUzm2Bp9C01L4SlUzDN+PdHKZMBXqusH98ASVJ0ZuDg==
X-Received: by 2002:aca:af50:: with SMTP id y77mr115129oie.134.1637269754447;
        Thu, 18 Nov 2021 13:09:14 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 70sm176600otn.74.2021.11.18.13.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 13:09:14 -0800 (PST)
Date:   Thu, 18 Nov 2021 14:09:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/3] vfio/pci: use runtime PM for vfio-device into low
 power state
Message-ID: <20211118140913.180bf94f.alex.williamson@redhat.com>
In-Reply-To: <8a49aa97-5de9-9cc8-d45f-e96456d66603@nvidia.com>
References: <20211115133640.2231-1-abhsahu@nvidia.com>
        <20211115133640.2231-4-abhsahu@nvidia.com>
        <20211117105323.2866b739.alex.williamson@redhat.com>
        <8a49aa97-5de9-9cc8-d45f-e96456d66603@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Nov 2021 20:51:41 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:
> On 11/17/2021 11:23 PM, Alex Williamson wrote:
>  Thanks Alex for checking this series and providing your inputs.=20
> =20
> > If we're transitioning a device to D3cold rather than D3hot as
> > requested by userspace, isn't that a user visible change?  =20
>=20
>   For most of the driver, in linux kernel, the D3hot vs D3cold
>   state will be decided at PCI core layer. In the PCI core layer,
>   pci_target_state() determines which D3 state to choose. It checks
>   for platform_pci_power_manageable() and then it calls
>   platform_pci_choose_state() to find the target state.
>   In VM, the platform_pci_power_manageable() check will fail if the
>   guest is linux OS. So, it uses, D3hot state.

Right, but my statement is really more that the device PM registers
cannot be used to put the device into D3cold, so the write of the PM
register that we're trapping was the user/guest's intention to put the
device into D3hot.  We therefore need to be careful about differences
in the resulting device state when it comes out of D3cold vs D3hot.

>   But there are few drivers which does not use the PCI framework
>   generic power related routines during runtime suspend/system suspend
>   and set the PCI power state directly with D3hot.

Current vfio-pci being one of those ;)

>   Also, the guest can be non-Linux OS also and, in that case,
>   it will be difficult to know the behavior. So, it may impact
>   these cases.

That's what I'm worried about.

> > For instance, a device may report NoSoftRst- indicating that the device
> > does not do a soft reset on D3hot->D0 transition.  If we're instead
> > putting the device in D3cold, then a transition back to D0 has very
> > much undergone a reset.  On one hand we should at least virtualize the
> > NoSoftRst bit to allow the guest to restore the device, but I wonder if
> > that's really safe.  Is a better option to prevent entering D3cold if
> > the device isn't natively reporting NoSoftRst-?
> >  =20
>=20
>  You mean to say NoSoftRst+ instead of NoSoftRst- as visible in

Oops yes.  The concern is if the user/guest is not expecting a soft
reset when using D3hot, but we transparently promote D3hot to D3cold
which will always implies a device reset.

>  the lspci output. For NoSoftRst- case, we do a soft reset on
>  D3hot->D0 transition. But, will this case not be handled internally
>  in drivers/pci/pci-driver.c ? For both system suspend and runtime suspen=
d,
>  we check for pci_dev->state_saved flag and do pci_save_state()
>  irrespective of NoSoftRst bit. For NoSoftRst- case, pci_restore_bars()
>  will be called in pci_raw_set_power_state() which will reinitialize devi=
ce
>  for D3hot/D3cold-> D0 case. Once the device is initialized in the host,
>  then for guest, it should work without re-initializing again in the
>  guest side. I am not sure, if my understanding is correct.

The soft reset is not limited to the state that the PCI subsystem can
save and restore.  Device specific state that the user/guest may
legitimately expect to be retained may be reset as well.

[PCIe v5 5.3.1.4]
	Functional context is required to be maintained by Functions in
	the D3 hot state if the No_Soft_Reset field in the PMCSR is Set.

Unfortunately I don't see a specific definition of "functional
context", but I interpret that to include device specific state.  For
example, if a GPU contains specific frame buffer data and reports
NoSoftRst+, wouldn't it be reasonable to expect that framebuffer data
to be retained on D3hot->D0 transition?
=20
> > We're also essentially making a policy decision on behalf of
> > userspace that favors power saving over latency.  Is that
> > universally the correct trade-off?  =20
>=20
>  For most drivers, the D3hot vs D3cold should not be favored due
>  to latency reasons. In the linux kernel side, I am seeing, the
>  PCI framework try to use D3cold state if platform and device
>  supports that. But its correct that covertly replacing D3hot with
>  D3cold may be concern for some drivers.
>=20
> > I can imagine this could be desirable for many use cases,
> > but if we're going to covertly replace D3hot with D3cold, it seems
> > like there should be an opt-in.  Is co-opting the PM capability for
> > this even really acceptable or should there be a device ioctl to
> > request D3cold and plumbing through QEMU such that a VM guest can
> > make informed choices regarding device power management?
> >  =20
>=20
>  Making IOCTL is also an option but that case, this support needs to
>  be added in all hypervisors and user must pass this information
>  explicitly for each device. Another option could be to use
>  module parameter to explicitly enable D3cold support. If module
>  parameter is not set, then we can call pci_d3cold_disable() and
>  in that case, runtime PM should not use D3cold state.
>=20
>  Also, I was checking we can pass this information though some
>  virtualized register bit which will be only defined for passing
>  the information between guest and host. In the guest side if the
>  target state is being decided with pci_target_state(), then
>  the D3cold vs D3hot should not matter for the driver running
>  in the guest side and in that case, it depends upon platform support.
>  We can set this virtualize bit to 1. But, if driver is either
>  setting D3hot state explicitly or has called pci_d3cold_disable() or
>  similar API available in the guest OS, then set this bit to 0 and
>  in that case, the D3cold state can be disabled in the host side.
>  But don't know if is possible to use some non PCI defined
>  virtualized register bit.=20

If you're suggesting a device config space register, that's troublesome
because we can't guarantee that simply because a range of config space
isn't within a capability that it doesn't have some device specific
purpose.  However, we could certainly implement virtual registers in
the hypervisor that implement the ACPI support that an OS would use on
bare metal to implement D3cold.  Those could trigger this ioctl through
the vfio device.

>  I am not sure what should be best option to make choice
>  regarding d3cold but if we can have some option by which this
>  can be done without involvement of user, then it will benefit
>  for lot of cases. Currently, the D3cold is supported only in
>  very few desktops/servers but in future, we will see on
>  most of the platforms. =20

I tend to see it as an interesting hack to promote D3hot to D3cold, and
potentially very useful.  However, we're also introducing potentially
unexpected device behavior, so I think it would probably need to be an
opt-in.  Possibly if the device reports NoSoftRst- we could use it by
default, but even virtualizing the NoSoftRst suggests that there's an
expectation that the guest driver has that support available.
=20
> > Also if the device is not responsive to config space due to the user
> > placing it in D3 now, I'd expect there are other ioctl paths that
> > need to be blocked, maybe even MMIO paths that might be a gap for
> > existing D3hot support.  Thanks,
>=20
>  I was in assumption that most of IOCTL code will be called by the
>  hypervisor before guest OS boot and during that time, the device
>  will be always in D0. But, if we have paths where IOCTL can be
>  called when the device has been suspended by guest OS, then can we
>  use runtime_get/put API=E2=80=99s there also ?

It's more a matter of preventing user actions that can cause harm
rather than expecting certain operations only in specific states.  We
could chose to either resume the device for those operations or fail
the operation.  We should probably also leverage the memory-disable
support to fault mmap access to MMIO when the device is in D3* as well.
Thanks,

Alex

