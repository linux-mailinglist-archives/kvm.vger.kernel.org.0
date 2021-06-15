Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1318A3A837E
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhFOPC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 11:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231274AbhFOPC6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 11:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623769253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kvDRHIPTMWRdjunH7atJ0Ekx4bg6biP+/uO+nH2vm70=;
        b=GTsW/QgzWVs9Scb3El5QzRFxb1fE2kgI5e8RZ2sCjZvkEPfGG1GX22lzOVxkipu5IB4LR1
        xr2wg7+hMxjS12gIZ22yzpYb3EFpfFxsus34r8I4ISaFTw4lcoql9ZLJ2GGZPHQNedTRQo
        9xNgMaerQtiOSjDkE4g+ogeXIv8TumE=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-7rZBdfO2OoyiWztMKA0aQQ-1; Tue, 15 Jun 2021 11:00:32 -0400
X-MC-Unique: 7rZBdfO2OoyiWztMKA0aQQ-1
Received: by mail-ot1-f69.google.com with SMTP id e28-20020a9d491c0000b02903daf90867beso9548248otf.11
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 08:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kvDRHIPTMWRdjunH7atJ0Ekx4bg6biP+/uO+nH2vm70=;
        b=KtktuQfRq5MAjPsujlY8ZFvf4jGNJwEpV/802AKQe2mcXKJF05BFwQugOkmSw1g/fz
         cGWG/C/Z2kuoxbmA8BSt3XF9R5gDJJppMsC6hWtjcYLZGIObI6wkr1n9gvdmiDu1sxTb
         lqaRENjy6YVqm0YvICIp5fti7ULUN+vJvLIAYSqWGlo0KkGjKzuP2H2yJOQxzC21UUIH
         yYpeLunQjEvYNaTCdYq4BhhE94Q6VY+Oh0G2AUEsyzUBPztMV97fGOJL1uMwfyYeC1rl
         f6hpEGNl6ISGuW56cHUB907cHvz0d/Z4CaYQduSLKkQ4kuSdwzY4CufxPltK2f/LSN5M
         hMOg==
X-Gm-Message-State: AOAM532H65l7oG+AltoM1jLHET1DrinyJejxDx/UhF5BaUcQJG+DRq9C
        bfZdjlvD5v5Ev0QlZerqSTJAODTtd/nQhfsvYhSbGrO1muPVYWgKemRg2y3LiO68ENCjvODdf3D
        j4kBSUQg1/+f0
X-Received: by 2002:a9d:20a2:: with SMTP id x31mr17536689ota.263.1623769231658;
        Tue, 15 Jun 2021 08:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGruaBJPm457fRiRlGb85/ee6++hhEpRZjrPbDGmDqUi5CKE5wvS9jZkzN+6NgP3pDJ3f/Zg==
X-Received: by 2002:a9d:20a2:: with SMTP id x31mr17536660ota.263.1623769231344;
        Tue, 15 Jun 2021 08:00:31 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id u10sm4050146otj.75.2021.06.15.08.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:00:30 -0700 (PDT)
Date:   Tue, 15 Jun 2021 09:00:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210615090029.41849d7a.alex.williamson@redhat.com>
In-Reply-To: <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
        <20210603160809.15845-10-mgurtovoy@nvidia.com>
        <20210608152643.2d3400c1.alex.williamson@redhat.com>
        <20210608224517.GQ1002214@nvidia.com>
        <20210608192711.4956cda2.alex.williamson@redhat.com>
        <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
        <20210614124250.0d32537c.alex.williamson@redhat.com>
        <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Jun 2021 02:12:15 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 6/14/2021 9:42 PM, Alex Williamson wrote:
> > On Sun, 13 Jun 2021 11:19:46 +0300
> > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> > =20
> >> On 6/9/2021 4:27 AM, Alex Williamson wrote: =20
> >>> On Tue, 8 Jun 2021 19:45:17 -0300
> >>> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>>    =20
> >>>> On Tue, Jun 08, 2021 at 03:26:43PM -0600, Alex Williamson wrote: =20
> >>>>>> drivers that specifically opt into this feature and the driver now=
 has
> >>>>>> the opportunity to provide a proper match table that indicates wha=
t HW
> >>>>>> it can properly support. vfio-pci continues to support everything.=
 =20
> >>>>> In doing so, this also breaks the new_id method for vfio-pci. =20
> >>>> Does it? How? The driver_override flag is per match entry not for the
> >>>> entire device so new_id added things will work the same as before as
> >>>> their new match entry's flags will be zero. =20
> >>> Hmm, that might have been a testing issue; combining driverctl with
> >>> manual new_id testing might have left a driver_override in place.
> >>>       =20
> >>>>> Sorry, with so many userspace regressions, crippling the
> >>>>> driver_override interface with an assumption of such a narrow focus,
> >>>>> creating a vfio specific match flag, I don't see where this can go.
> >>>>> Thanks, =20
> >>>> On the other hand it overcomes all the objections from the last go
> >>>> round: how userspace figures out which driver to use with
> >>>> driver_override and integrating the universal driver into the scheme.
> >>>>
> >>>> pci_stub could be delt with by marking it for driver_override like
> >>>> vfio_pci. =20
> >>> By marking it a "vfio driver override"? :-\
> >>>    =20
> >>>> But driverctl as a general tool working with any module is not really
> >>>> addressable.
> >>>>
> >>>> Is the only issue the blocking of the arbitary binding? That is not a
> >>>> critical peice of this, IIRC =20
> >>> We can't break userspace, which means new_id and driver_override need
> >>> to work as they do now.  There are scads of driver binding scripts in
> >>> the wild, for vfio-pci and other drivers.  We can't assume such a
> >>> narrow scope.  Thanks, =20
> >> what about the following code ?
> >>
> >> @@ -152,12 +152,28 @@ static const struct pci_device_id
> >> *pci_match_device(struct pci_driver *drv,
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&drv->dynids.=
lock);
> >>
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!found_id)
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 found_id =3D pci_match_id(drv->id_table, dev);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_id)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return found_id; =20
> > a) A dynamic ID match always works regardless of driver override...
> > =20
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* driver_override will always m=
atch, send a dummy id */
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!found_id && dev->driver_ove=
rride)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 found_id =3D pci_match_id(drv->i=
d_table, dev);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_id) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /*
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * if we found id in the static table, we must fulfill=
 the
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * matching flags (i.e. if PCI_ID_F_DRIVER_OVERRIDE fl=
ag is
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * set, driver_override should be provided).
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 bool is_driver_override =3D
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (found_id->=
flags & PCI_ID_F_DRIVER_OVERRIDE) !=3D 0;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if ((is_driver_override && !dev->driver_override) || =20
> > b) A static ID match fails if the driver provides an override flag and
> > the device does not have an override set, or...
> > =20
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (dev->driver_override && !is_driver=
_override)) =20
> > c) The device has an override set and the driver does not support the
> > override flag.
> > =20
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (dev->driver_override)=
 {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /*
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * if we didn't find suitable id in the static table,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * driver_override will still , send a dummy id
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 found_id =3D &pci_device_id_any;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>
> >>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return found_id;
> >>   =C2=A0}
> >>
> >>
> >> dynamic ids (new_id) works as before.
> >>
> >> Old driver_override works as before. =20
> > This is deceptively complicated, but no, I don't believe it does.  By
> > my understanding of c) an "old" driver can no longer use
> > driver_override for binding a known device.  It seems that if we have a
> > static ID match, then we cannot have a driver_override set for the
> > device in such a case.  This is a userspace regression. =20
>=20
> If I'll remove condition c) everyone will be happy ?
>=20
> I really would like to end this ongoing discussion and finally have a=20
> clear idea of what we want.
>=20
> By clear I mean C code.
>=20
> If we'll continue raising ideas we'll never reach our goal. And my goal=20
> is the next merge window.

Bjorn would ultimately need to make the call on that, I don't see an
obvious regression if c) is dropped.  pci-stub and pci-pf-stub should
be included in the proposal so we can better understand how creating a
"vfio" override in PCI-core plays out for other override types.  Also I
don't think dynamic IDs should be handled uniquely, new_id_store()
should gain support for flags and userspace should be able to add new
dynamic ID with override-only matches to the table.  Thanks,

Alex

