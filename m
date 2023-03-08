Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D8B6B12A4
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 21:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCHUHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 15:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCHUHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 15:07:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F4BAF2B8
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 12:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678305984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqzFSckHueM0aXNSANb++ihcLYh6l4SG1YDTHgu98eA=;
        b=gVpPACcmreh0ygeg+t8+5pahHvjJBWus9pgFAbSGWvEKVjBQJbyXFMLaAZUvu767C6LKFd
        flBpJWsj3HmEXmAfdfbUgfxyEpCzDwZJnb6cVN2HXQdP+O8TV5PaA3a6pKVhzpNDidPzjY
        Ybp4Vkd3nL6mD5ESWQMDaIl4p/Xa78g=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-G-z9tIM4NGiiS3f4w7ngEg-1; Wed, 08 Mar 2023 15:06:23 -0500
X-MC-Unique: G-z9tIM4NGiiS3f4w7ngEg-1
Received: by mail-il1-f199.google.com with SMTP id l5-20020a92d8c5000000b00316f26477d6so9272909ilo.10
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 12:06:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678305982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EqzFSckHueM0aXNSANb++ihcLYh6l4SG1YDTHgu98eA=;
        b=JgO9Z9O1JzSc7a3Vd59lnAE492e5Tk7KhL7aKgqGpimaHmdddTZpEx9h8cIJt1pXrk
         mELURw76iP5l134JvNPksUFtFYfhaWL6aL3nCOkRiwoNBPnNHmcctWnDZo2tC2PUUrDT
         Rg7Pbi0WFO19uQNQ2hVIuZwH6+KrF3kGXHPK8qG+hd6enFpOZzJKgX0jJBDI8xcAK2bC
         dyF7mUesFXzGREHQKO18HpOsY1Oc+EXX3zjvcsC1N1WiwG9MlBQO/gJETp2WWLoZqbLd
         X8KTlJoAbrVzUeDiUQXev2AOxnv6txByCYY75mSoZqoMMQ/cOYKWScQP4Pq7JHeP2Nwb
         ihrg==
X-Gm-Message-State: AO0yUKUZJDVi4ZLums2/SWsgvASzHYEiLYr16jfsZ1jP016svBlcQdIe
        7VKip3D4RgD/xnw2Z7zwVOAlc32gHBzIPaAloFZo6JfhilRpdiqb/sKoDBpt7Z1Ia5dcZQoIykf
        svBLHKbAL/Ufp
X-Received: by 2002:a5e:aa07:0:b0:6e9:d035:45df with SMTP id s7-20020a5eaa07000000b006e9d03545dfmr14333026ioe.6.1678305982306;
        Wed, 08 Mar 2023 12:06:22 -0800 (PST)
X-Google-Smtp-Source: AK7set+xdqja+v+gspmdhgaHJ3P7uV06zqPr158B/uCD7qDJiPCkpqyVNvR6AucSkRlenxDWrCw5Vw==
X-Received: by 2002:a5e:aa07:0:b0:6e9:d035:45df with SMTP id s7-20020a5eaa07000000b006e9d03545dfmr14333006ioe.6.1678305982003;
        Wed, 08 Mar 2023 12:06:22 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z10-20020a92650a000000b00317f477b039sm1867927ilb.4.2023.03.08.12.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 12:06:21 -0800 (PST)
Date:   Wed, 8 Mar 2023 13:06:19 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dominik Behr <dbehr@chromium.org>
Cc:     Grzegorz Jaszczyk <jaz@semihalf.com>, linux-kernel@vger.kernel.org,
        dmy@semihalf.com, tn@semihalf.com, upstream@semihalf.com,
        dtor@google.com, jgg@ziepe.ca, kevin.tian@intel.com,
        cohuck@redhat.com, abhsahu@nvidia.com, yishaih@nvidia.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org, libvir-list@redhat.com
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the
 user-space
Message-ID: <20230308130619.3736cf18.alex.williamson@redhat.com>
In-Reply-To: <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
References: <20230307220553.631069-1-jaz@semihalf.com>
        <20230307164158.4b41e32f.alex.williamson@redhat.com>
        <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
        <20230308104944.578d503c.alex.williamson@redhat.com>
        <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Mar 2023 10:45:51 -0800
Dominik Behr <dbehr@chromium.org> wrote:

> On Wed, Mar 8, 2023 at 9:49=E2=80=AFAM Alex Williamson
> <alex.williamson@redhat.com> wrote:
>=20
> > Adding libvirt folks.  This intentionally designs the interface in a
> > way that requires a privileged intermediary to monitor netlink on the
> > host, associate messages to VMs based on an attached device, and
> > re-inject the event to the VMM.  Why wouldn't we use a channel
> > associated with the device for such events, such that the VMM has
> > direct access?  The netlink path seems like it has more moving pieces,
> > possibly scalability issues, and maybe security issues? =20
>=20
> It is the same interface as other ACPI events like AC adapter LID etc
> are forwarded to user-space.
>  ACPI events are not particularly high frequency like interrupts.

I'm not sure that's relevant, these interfaces don't proclaim to
provide isolation among host processes which manage behavior relative
to accessories.  These are effectively system level services.  It's only
a very, very specialized use case that places a VMM as peers among these
processes.  Generally we don't want to grant a VMM any privileges beyond
what it absolutely needs, so letting a VMM managing an assigned NIC
really ought not to be able to snoop host events related to anything
other than the NIC.

> > > > What sort of ACPI events are we expecting to see here and what does=
 user space do with them? =20
> The use we are looking at right now are D-notifier events about the
> GPU power available to mobile discrete GPUs.
> The firmware notifies the GPU driver and resource daemon to
> dynamically adjust the amount of power that can be used by the GPU.
>=20
> > The proposed interface really has no introspection, how does the VMM
> > know which devices need ACPI tables added "upfront"?  How do these
> > events factor into hotplug device support, where we may not be able to
> > dynamically inject ACPI code into the VM? =20
>=20
> The VMM can examine PCI IDs and the associated firmware node of the
> PCI device to figure out what events to expect and what ACPI table to
> generate to support it but that should not be necessary.

I'm not entirely sure where your VMM is drawing the line between the VM
and management tools, but I think this is another case where the
hypervisor itself should not have privileges to examine the host
firmware tables to build its own.  Something like libvirt would be
responsible for that.

> A generic GPE based ACPI event forwarder as Grzegorz proposed can be
> injected at VM init time and handle any notification that comes later,
> even from hotplug devices.

It appears that forwarder is sending the notify to a specific ACPI
device node, so it's unclear to me how that becomes boilerplate AML
added to all VMs.  We'll need to notify different devices based on
different events, right?
=20
> > The acpi_bus_generate_netlink_event() below really only seems to form a
> > u8 event type from the u32 event.  Is this something that could be
> > provided directly from the vfio device uAPI with an ioeventfd, thus
> > providing introspection that a device supports ACPI event notifications
> > and the ability for the VMM to exclusively monitor those events, and
> > only those events for the device, without additional privileges? =20
>=20
> From what I can see these events are 8 bit as they come from ACPI.
> They also do not carry any payload and it is up to the receiving
> driver to query any additional context/state from the device.
> This will work the same in the VM where driver can query the same
> information from the passed through PCI device.
> There are multiple other netflink based ACPI events forwarders which
> do exactly the same thing for other devices like AC adapter, lid/power
> button, ACPI thermal notifications, etc.
> They all use the same mechanism and can be received by user-space
> programs whether VMMs or others.

But again, those other receivers are potentially system services, not
an isolated VM instance operating in a limited privilege environment.
IMO, it's very different if the host display server has access to lid
or power events than it is to allow some arbitrary VM that happens to
have an unrelated assigned device that same privilege.

On my laptop, I see multiple _GPE scopes, each apparently very unique
to the devices:

    Scope (_GPE)
    {
        Method (_L0C, 0, Serialized)  // _Lxx: Level-Triggered GPE, xx=3D0x=
00-0xFF
        {
            Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
        }  =20

        Method (_L0D, 0, Serialized)  // _Lxx: Level-Triggered GPE, xx=3D0x=
00-0xFF
        {
            Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
        }

        Method (_L0F, 0, Serialized)  // _Lxx: Level-Triggered GPE, xx=3D0x=
00-0xFF
        {  =20
            Notify (\_SB.PCI0.GPP0.PEGP, 0x81) // Information Change
        }  =20
    }=20

    Scope (_GPE)
    {
        Method (_L19, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=
=3D0x00-0xFF
        {
            Notify (\_SB.PCI0.GP17, 0x02) // Device Wake
            Notify (\_SB.PCI0.GP17.XHC0, 0x02) // Device Wake
            Notify (\_SB.PCI0.GP17.XHC1, 0x02) // Device Wake
            Notify (\_SB.PWRB, 0x02) // Device Wake
        }

        Method (_L08, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=
=3D0x00-0xFF
        {
            Notify (\_SB.PCI0.GP18, 0x02) // Device Wake
            Notify (\_SB.PCI0.GPP0, 0x02) // Device Wake
            Notify (\_SB.PCI0.GPP1, 0x02) // Device Wake
            Notify (\_SB.PCI0.GPP5, 0x02) // Device Wake
        }
    }

At least one more even significantly more extensive, calling methods
that interact with OpRegions.  So how does a simple stub of a
GPE block replicate this sort of behavior in the host AML?  Thanks,

Alex

