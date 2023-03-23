Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43B6C6E69
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjCWRIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 13:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjCWRIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 13:08:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806E2199C5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679591235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9eDk+/tnvTqWMhnO7a3EwIKBIFD2a091m9Yulpg6oU=;
        b=VJTZ0Fk65PCX39vwp4opvsJogRDuar0GFft5yDMGGBHFiuvM913CMM0+BMsWV3WLmi5gWk
        l+G8n/naGQvahu+O3LtiyobktiTFUtJyMG7wgOwVCf+3egPLnE4DkT0FQnu4y17LEZAVyD
        UWEP4ejzITT/JgdLiafDmbVbEvr1mQI=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-hN0NA1m1N9-KXqURiA7zJw-1; Thu, 23 Mar 2023 13:07:14 -0400
X-MC-Unique: hN0NA1m1N9-KXqURiA7zJw-1
Received: by mail-il1-f198.google.com with SMTP id i14-20020a056e0212ce00b0031d17f33e9aso12123806ilm.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679591233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9eDk+/tnvTqWMhnO7a3EwIKBIFD2a091m9Yulpg6oU=;
        b=JiK/J8SzuxRSUsuUZxuajtbFddkM7ljjqz6yK5t9vim6eNkY8hRwrhKgdcBlBB5UR6
         +7/MD5aZiJ/jV9mKwTKNLNisdpKITjiDQKu5JbqS9GoN01HsknhSM/ZPSo7hPrrXv/D9
         g8RZQ9ZLqRwW+smYM8BF0bxL8V7udYZQkNl4OfjzP5Cews/UO3oUOIYiK+vQbVwbj70k
         5nY67+XknvjK8wG9eDxnWaotDKEsNDVKp51NvdumTpCmKPc/HwZJf740lpMi3GW/tQxz
         LOziS3IJjlMLB98OSRIBcQ7bbOmprfFZxq4PThq6Z/oWKbUkqF14O65hiU3MCUz8NNGR
         Sogw==
X-Gm-Message-State: AO0yUKU1vX20JmxbGmn8QLUsVBn+CCMZnxHAzVFQ+ROLoeUBv4JYzvW/
        9TLdhB4ihgEHW4nZPFlL48052iA5bxM8icq4vMlOjEqQ46CymLaTvLOg8LilyI25xVASgnvAntY
        IfA3AuVsbgVeo
X-Received: by 2002:a05:6602:25d1:b0:717:ce6a:188a with SMTP id d17-20020a05660225d100b00717ce6a188amr6886677iop.18.1679591233172;
        Thu, 23 Mar 2023 10:07:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set8F2AMXeqAhZshi9Oq4fupBpf++R+QMGkiYPDpgH6ZyCaheH2Kvo0IXF3JECuBPa9n1EEYjdw==
X-Received: by 2002:a05:6602:25d1:b0:717:ce6a:188a with SMTP id d17-20020a05660225d100b00717ce6a188amr6886655iop.18.1679591232729;
        Thu, 23 Mar 2023 10:07:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y10-20020a5e920a000000b00758c0c89df5sm1089722iop.13.2023.03.23.10.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:07:11 -0700 (PDT)
Date:   Thu, 23 Mar 2023 11:07:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     Dominik Behr <dbehr@google.com>, Dominik Behr <dbehr@chromium.org>,
        linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        upstream@semihalf.com, dtor@google.com, jgg@ziepe.ca,
        kevin.tian@intel.com, cohuck@redhat.com, abhsahu@nvidia.com,
        yishaih@nvidia.com, yi.l.liu@intel.com, kvm@vger.kernel.org,
        libvir-list@redhat.com
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the
 user-space
Message-ID: <20230323110709.6cc80b8c.alex.williamson@redhat.com>
In-Reply-To: <CAH76GKP+W9JUvQpqvjLHADMeRORPUf0d8vn5gCgE5fjxz0YkPQ@mail.gmail.com>
References: <20230307220553.631069-1-jaz@semihalf.com>
        <20230307164158.4b41e32f.alex.williamson@redhat.com>
        <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
        <20230308104944.578d503c.alex.williamson@redhat.com>
        <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
        <20230308130619.3736cf18.alex.williamson@redhat.com>
        <CABUrSUBBbXRVRo6b1EKBpgu7zk=8yZhQ__UXFGL_GpO+BA4Pkg@mail.gmail.com>
        <20230308163803.6bfc2922.alex.williamson@redhat.com>
        <CAH76GKP+W9JUvQpqvjLHADMeRORPUf0d8vn5gCgE5fjxz0YkPQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Mar 2023 14:41:23 +0100
Grzegorz Jaszczyk <jaz@semihalf.com> wrote:

> czw., 9 mar 2023 o 00:38 Alex Williamson <alex.williamson@redhat.com>
> napisa=C5=82(a):
> >
> > On Wed, 8 Mar 2023 14:44:28 -0800
> > Dominik Behr <dbehr@google.com> wrote:
> > =20
> > > On Wed, Mar 8, 2023 at 12:06=E2=80=AFPM Alex Williamson
> > > <alex.williamson@redhat.com> wrote: =20
> > > >
> > > > On Wed, 8 Mar 2023 10:45:51 -0800
> > > > Dominik Behr <dbehr@chromium.org> wrote:
> > > > =20
> > > > > It is the same interface as other ACPI events like AC adapter LID=
 etc
> > > > > are forwarded to user-space.
> > > > >  ACPI events are not particularly high frequency like interrupts.=
 =20
> > > >
> > > > I'm not sure that's relevant, these interfaces don't proclaim to
> > > > provide isolation among host processes which manage behavior relati=
ve
> > > > to accessories.  These are effectively system level services.  It's=
 only
> > > > a very, very specialized use case that places a VMM as peers among =
these
> > > > processes.  Generally we don't want to grant a VMM any privileges b=
eyond
> > > > what it absolutely needs, so letting a VMM managing an assigned NIC
> > > > really ought not to be able to snoop host events related to anything
> > > > other than the NIC. =20
> > > How is that related to the fact that we are forwarding VFIO-PCI events
> > > to netlink? Kernel does not grant any privileges to VMM.
> > > There are already other ACPI events on netlink. The implementer of the
> > > VMM can choose to allow VMM to snoop them or not.
> > > In our case our VMM (crosvm) does already snoop LID, battery and AC
> > > adapter events so the guest can adjust its behavior accordingly.
> > > This change just adds another class of ACPI events that are forwarded
> > > to netlink. =20
> >
> > That's true, it is the VMM choice whether to allow snooping netlink,
> > but this is being proposed as THE solution to allow VMMs to receive
> > ACPI events related to vfio assigned devices.  If the solution
> > inherently requires escalating the VMM privileges to see all netlink
> > events, that's a weakness in the proposal.  As noted previously,
> > there's also no introspection here, the VMM can't know whether it
> > should listen to netlink for ACPI events or include AML related to a
> > GPE for the device.  It cannot determine if either the kernel supports
> > this feature or if the device has an ACPI companion that can generate
> > these events. =20
>=20
> To be precise the VMM doesn't listen to all netlink events: it listens
> only to "acpi_event" family and acpi related multicast group, which
> means it listens to all events generated through
> acpi_bus_generate_netlink_event.
>=20
> Before sending this patch I thought about using eventfd instead
> netalink which will actually provide a channel associated with a given
> device and therefore such notifications will be received only by the
> VMM associated with such a device. Nevertheless, it seems like eventfd
> will allow to signalize events happening (notify on a given device)
> but is not capable of sending any payload so in our case there is no
> room for propagating notification value via eventfd. Maybe there is
> other mechanism eventfd-like which will allow to achieve above?

Reading an eventfd returns an 8-byte value, we generally only use it
as a counter, but it's been discussed previously and IIRC, it's possible
to use that value as a notification value.

> If there is no such mechanism, maybe instead of using existing acpi
> netlink events, which are associated with "acpi_event" netlink family
> and acpi multicast group, we could create per vfio-pci a different
> netlink family or probably reuse "acpi_event" family but use different
> multicast group, so each device will have dedicated netlink family.
> Does it seem reasonable?
>=20
> > =20
> > > > =20
> > > > > > > > What sort of ACPI events are we expecting to see here and w=
hat does user space do with them? =20
> > > > > The use we are looking at right now are D-notifier events about t=
he
> > > > > GPU power available to mobile discrete GPUs.
> > > > > The firmware notifies the GPU driver and resource daemon to
> > > > > dynamically adjust the amount of power that can be used by the GP=
U.
> > > > > =20
> > > > > > The proposed interface really has no introspection, how does th=
e VMM
> > > > > > know which devices need ACPI tables added "upfront"?  How do th=
ese
> > > > > > events factor into hotplug device support, where we may not be =
able to
> > > > > > dynamically inject ACPI code into the VM? =20
> > > > >
> > > > > The VMM can examine PCI IDs and the associated firmware node of t=
he
> > > > > PCI device to figure out what events to expect and what ACPI tabl=
e to
> > > > > generate to support it but that should not be necessary. =20
> > > >
> > > > I'm not entirely sure where your VMM is drawing the line between th=
e VM
> > > > and management tools, but I think this is another case where the
> > > > hypervisor itself should not have privileges to examine the host
> > > > firmware tables to build its own.  Something like libvirt would be
> > > > responsible for that. =20
> > > Yes, but that depends on the design of hypervisor and VMM and is not
> > > related to this patch. =20
> >
> > It is very much related to this patch if it proposes an interface to
> > solve a problem which is likely not compatible with the security model
> > of other VMMs.  We need a single solution to support all VMMs.
> > =20
> > > > =20
> > > > > A generic GPE based ACPI event forwarder as Grzegorz proposed can=
 be
> > > > > injected at VM init time and handle any notification that comes l=
ater,
> > > > > even from hotplug devices. =20
> > > >
> > > > It appears that forwarder is sending the notify to a specific ACPI
> > > > device node, so it's unclear to me how that becomes boilerplate AML
> > > > added to all VMs.  We'll need to notify different devices based on
> > > > different events, right? =20
> > > Valid point. The notifications have a "scope" ACPI path.
> > > In my experience these events are consumed without looking where they
> > > came from but I believe the patch can be extended to
> > > provide ACPI path, in your example "_SB.PCI0.GPP0.PEGP" instead of
> > > generic vfio_pci which VMM could use to translate an equivalent ACPI
> > > path in the guest and pass it to a generic ACPI GPE based notifier via
> > > shared memory. Grzegorz could you chime in whether that would be
> > > possible? =20
> >
> > So effectively we're imposing the host ACPI namespace on the VM, or at
> > least a mapping between the host and VM namespace?  The generality of
> > this is not improving. =20
>=20
> Yes, in the example VMM implementation we have mapping between the
> host pci device address and guest pci device. Therefore VMM knows,
> based on device name (BDF) sent via netlink, to which guest device
> this notification should be propagated. The boilerplate AML is added
> to each vfio-pci device which belongs to VMM and each vfio-pci device
> has associated pre-allocated GPE so the VMM knows which GPE should be
> triggered to replicate notification for a given device. BTW this is
> only current WIP VMM implementation - this could probably be optimized
> if needed.
>=20
> Handling hotplug devices is more problematic. I see that the kernel
> provides some runtime ACPI patching mechanism:
> https://www.kernel.org/doc/html/latest/firmware-guide/acpi/method-customi=
zing.html
> (which I never tried) but not even sure how VMM could take advantage
> of it. BTW this realized me that the same problem with hotplug applies
> to other vfio-pci use-cases e.g. runtime PM, which relies on guest
> virtual ACPI method:
> https://patchwork.kernel.org/project/linux-pm/patch/20220829114850.4341-5=
-abhsahu@nvidia.com/.
> Generating virtual ACPI content for hotplug devices seems like a more
> generic issue.

I don't think this is an equivalent case, the AML object is at the
slot, not the device and the direction is reversed.  The VMM can
implement PCI slot power control regardless of the host capabilities.
This is more like ACPI eject behavior, the guest triggers an event
which is processed by the VMM to perform an action.  The VMM doesn't
need to dynamically add slot power control capabilities based on the
features of the plugged device.

> > > > > > The acpi_bus_generate_netlink_event() below really only seems t=
o form a
> > > > > > u8 event type from the u32 event.  Is this something that could=
 be
> > > > > > provided directly from the vfio device uAPI with an ioeventfd, =
thus
> > > > > > providing introspection that a device supports ACPI event notif=
ications
> > > > > > and the ability for the VMM to exclusively monitor those events=
, and
> > > > > > only those events for the device, without additional privileges=
? =20
> > > > >
> > > > > From what I can see these events are 8 bit as they come from ACPI.
> > > > > They also do not carry any payload and it is up to the receiving
> > > > > driver to query any additional context/state from the device.
> > > > > This will work the same in the VM where driver can query the same
> > > > > information from the passed through PCI device.
> > > > > There are multiple other netflink based ACPI events forwarders wh=
ich
> > > > > do exactly the same thing for other devices like AC adapter, lid/=
power
> > > > > button, ACPI thermal notifications, etc.
> > > > > They all use the same mechanism and can be received by user-space
> > > > > programs whether VMMs or others. =20
> > > >
> > > > But again, those other receivers are potentially system services, n=
ot
> > > > an isolated VM instance operating in a limited privilege environmen=
t.
> > > > IMO, it's very different if the host display server has access to l=
id
> > > > or power events than it is to allow some arbitrary VM that happens =
to
> > > > have an unrelated assigned device that same privilege. =20
> > > Therefore these VFIO related ACPI events could be received by a system
> > > service via this netlink event and selectively forwarded to VMM if
> > > such is a desire of whoever implements the userspace.
> > > This is outside the scope of this patch. In our case our VMM does
> > > receive these LID, AC or battery events. =20
> >
> > But this is backwards, we're presupposing the choice to use netlink
> > based on the convenience of one VMM, which potentially creates
> > obstacles, maybe even security isolation issues for other VMMs.  The
> > method of delivering ACPI events to a VMM is very much within the scope
> > of this proposal.  Thanks,
> >
> > Alex
> > =20
>=20
> regarding:
> > > > On my laptop, I see multiple _GPE scopes, each apparently very uniq=
ue
> > > > to the devices:
> > > >
> > > >    Scope (_GPE)
> > > >    {
> > > >        Method (_L0C, 0, Serialized)  // _Lxx: Level-Triggered GPE, =
xx=3D0x00-0xFF
> > > >        {
> > > >            Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
> > > >        }
> > > >
> > > >        Method (_L0D, 0, Serialized)  // _Lxx: Level-Triggered GPE, =
xx=3D0x00-0xFF
> > > >        {
> > > >             Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
> > > >        }
> > > >
> > > >        Method (_L0F, 0, Serialized)  // _Lxx: Level-Triggered GPE, =
xx=3D0x00-0xFF
> > > >        {
> > > >             Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
> > > >         }
> > > >     }
> > > >
> > > >     Scope (_GPE)
> > > >     {
> > > >         Method (_L19, 0, NotSerialized)  // _Lxx: Level-Triggered G=
PE, xx=3D0x00-0xFF
> > > >         {
> > > >             Notify (\_SB.PCI0.GP17, 0x02) // Device Wake
> > > >             Notify (\_SB.PCI0.GP17.XHC0, 0x02) // Device Wake
> > > >             Notify (\_SB.PCI0.GP17.XHC1, 0x02) // Device Wake
> > > >             Notify (\_SB.PWRB, 0x02) // Device Wake
> > > >         }
> > > >
> > > >         Method (_L08, 0, NotSerialized)  // _Lxx: Level-Triggered G=
PE, xx=3D0x00-0xFF
> > > >         {
> > > >            Notify (\_SB.PCI0.GP18, 0x02) // Device Wake
> > > >             Notify (\_SB.PCI0.GPP0, 0x02) // Device Wake
> > > >             Notify (\_SB.PCI0.GPP1, 0x02) // Device Wake
> > > >             Notify (\_SB.PCI0.GPP5, 0x02) // Device Wake
> > > >         }
> > > >     }
> > > >
> > > > At least one more even significantly more extensive, calling methods
> > > > that interact with OpRegions.  So how does a simple stub of a
> > > > GPE block replicate this sort of behavior in the host AML?  Thanks,=
 =20
>=20
> The simple stub of GPE block will work to replicate the ACPI
> notification only: as mentioned earlier GPE handler will be generated
> per-vfio device so in your example if let assume that only:
> - \_SB.PCI0.GPP0.PEGP
> - \_SB.PCI0.GP17.XHC1
> will be pass-through to the guest, the generated AML code for VM will
> look more-less like below:
>=20
>         Scope (_GPE)
>         {
>             Method (_E00, 0, NotSerialized)
>             {
>                 Local0 =3D  \_SB.PCI0.GPP0.PEGP.NOTY
>                 Notify ( \_SB.PCI0.GPP0.PEGP, Local0)
>             }
>         }
>         Scope (_GPE)
>         {
>             Method (_E01, 0, NotSerialized)
>             {
>                 Local0 =3D\_SB.PCI0.GP17.XHC1.NOTY
>                 Notify (\_SB.PCI0.GP17.XHC1, Local0)
>             }
>         }
>=20
> So each pass-through device will have associated GPE (0 for
> \_SB.PCI0.GPP0.PEGP and 1 for \_SB.PCI0.GP17.XHC1). The path in Notify
> could actually be different and related to guest pci hierarchy (but
> associated to those host devices). Please also note that in this case
> we use GPE in order to "inform" guest about notification coming and we
> do not try to replicate host GPE scope description.
>=20
> Above we assumed that other devices (like \_SB.PCI0.GPP0/1) are not
> pass-through to the guest and notification are handled in host as
> usual (they are not binded to pci-vfio) and there is no need to
> generate AML code, allocate GPE for them and so on.

I'm pretty lost here.  The GPE code to read the notify value and relay
it to another AML object is relatively trivial, but that other AML
object needs to do something of some significance with that notify.
Minimally, it seems like the AML would need to establish the companion
relationship with the device so that a driver in the guest receives
that notify.  What does that look like, and can it be pre-seeded in the
AML regardless of whether the device is cold- or hot-plugged into the
VM?  Some specific examples would be useful.  It's not clear to me that
there isn't significant out-of-band effort required to understand and
replicate AML from host to guest to make this useful, so the generality
of this feature is hard to grasp.  Thanks,

Alex

