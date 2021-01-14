Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204EC2F62AC
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 15:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbhANOGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 09:06:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbhANOGH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 09:06:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610633080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gTmzUx4XqAggyZApGiSYmY6PGlS/O4UhRM5c2tO4Ock=;
        b=arwkMjLv/KwauZfx9t/YZq50HcXKMGLAlJLmrhenDsWgdeIBS47uoGSVt9IdaAujiFJ9X/
        ePaQdX9130AL8u2yXJ+yLIp7AFperOjrGu1K9xei0UVrBGsZJJDzlkwvN7PALynEYzJknF
        bs4uxUrsPXCVc44nvJY47m6qJhPOXVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-ZkcUa2JkOBabFPSGeDElSg-1; Thu, 14 Jan 2021 09:04:38 -0500
X-MC-Unique: ZkcUa2JkOBabFPSGeDElSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFA57C73B9;
        Thu, 14 Jan 2021 14:04:35 +0000 (UTC)
Received: from gondolin (ovpn-114-65.ams2.redhat.com [10.36.114.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6FB16F985;
        Thu, 14 Jan 2021 14:04:25 +0000 (UTC)
Date:   Thu, 14 Jan 2021 15:04:22 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, pair@us.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>, brijesh.singh@amd.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        david@redhat.com, Ram Pai <linuxram@us.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, pbonzini@redhat.com, thuth@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20210114150422.5f74ca41.cohuck@redhat.com>
In-Reply-To: <20210114122048.GG1643043@redhat.com>
References: <20210105115614.7daaadd6.pasic@linux.ibm.com>
        <20210105204125.GE4102@ram-ibm-com.ibm.com>
        <20210111175914.13adfa2e.cohuck@redhat.com>
        <20210113124226.GH2938@work-vm>
        <6e02e8d5-af4b-624b-1a12-d03b9d554a41@de.ibm.com>
        <20210114103643.GD2905@work-vm>
        <db2295ce-333f-2a3e-8219-bfa4853b256f@de.ibm.com>
        <20210114120531.3c7f350e.cohuck@redhat.com>
        <20210114114533.GF2905@work-vm>
        <b791406c-fde2-89db-4186-e1660f14418c@de.ibm.com>
        <20210114122048.GG1643043@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 12:20:48 +0000
Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Thu, Jan 14, 2021 at 12:50:12PM +0100, Christian Borntraeger wrote:
> >=20
> >=20
> > On 14.01.21 12:45, Dr. David Alan Gilbert wrote: =20
> > > * Cornelia Huck (cohuck@redhat.com) wrote: =20
> > >> On Thu, 14 Jan 2021 11:52:11 +0100
> > >> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > >> =20
> > >>> On 14.01.21 11:36, Dr. David Alan Gilbert wrote: =20
> > >>>> * Christian Borntraeger (borntraeger@de.ibm.com) wrote:   =20
> > >>>>>
> > >>>>>
> > >>>>> On 13.01.21 13:42, Dr. David Alan Gilbert wrote:   =20
> > >>>>>> * Cornelia Huck (cohuck@redhat.com) wrote:   =20
> > >>>>>>> On Tue, 5 Jan 2021 12:41:25 -0800
> > >>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:
> > >>>>>>>   =20
> > >>>>>>>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:  =
 =20
> > >>>>>>>>> On Mon, 4 Jan 2021 10:40:26 -0800
> > >>>>>>>>> Ram Pai <linuxram@us.ibm.com> wrote:   =20
> > >>>>>>>   =20
> > >>>>>>>>>> The main difference between my proposal and the other propos=
al is...
> > >>>>>>>>>>
> > >>>>>>>>>>   In my proposal the guest makes the compatibility decision =
and acts
> > >>>>>>>>>>   accordingly.  In the other proposal QEMU makes the compati=
bility
> > >>>>>>>>>>   decision and acts accordingly. I argue that QEMU cannot ma=
ke a good
> > >>>>>>>>>>   compatibility decision, because it wont know in advance, i=
f the guest
> > >>>>>>>>>>   will or will-not switch-to-secure.
> > >>>>>>>>>>      =20
> > >>>>>>>>>
> > >>>>>>>>> You have a point there when you say that QEMU does not know i=
n advance,
> > >>>>>>>>> if the guest will or will-not switch-to-secure. I made that a=
rgument
> > >>>>>>>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. M=
y idea
> > >>>>>>>>> was to flip that property on demand when the conversion occur=
s. David
> > >>>>>>>>> explained to me that this is not possible for ppc, and that h=
aving the
> > >>>>>>>>> "securable-guest-memory" property (or whatever the name will =
be)
> > >>>>>>>>> specified is a strong indication, that the VM is intended to =
be used as
> > >>>>>>>>> a secure VM (thus it is OK to hurt the case where the guest d=
oes not
> > >>>>>>>>> try to transition). That argument applies here as well.     =
=20
> > >>>>>>>>
> > >>>>>>>> As suggested by Cornelia Huck, what if QEMU disabled the
> > >>>>>>>> "securable-guest-memory" property if 'must-support-migrate' is=
 enabled?
> > >>>>>>>> Offcourse; this has to be done with a big fat warning stating
> > >>>>>>>> "secure-guest-memory" feature is disabled on the machine.
> > >>>>>>>> Doing so, will continue to support guest that do not try to tr=
ansition.
> > >>>>>>>> Guest that try to transition will fail and terminate themselve=
s.   =20
> > >>>>>>>
> > >>>>>>> Just to recap the s390x situation:
> > >>>>>>>
> > >>>>>>> - We currently offer a cpu feature that indicates secure execut=
ion to
> > >>>>>>>   be available to the guest if the host supports it.
> > >>>>>>> - When we introduce the secure object, we still need to support
> > >>>>>>>   previous configurations and continue to offer the cpu feature=
, even
> > >>>>>>>   if the secure object is not specified.
> > >>>>>>> - As migration is currently not supported for secured guests, w=
e add a
> > >>>>>>>   blocker once the guest actually transitions. That means that
> > >>>>>>>   transition fails if --only-migratable was specified on the co=
mmand
> > >>>>>>>   line. (Guests not transitioning will obviously not notice any=
thing.)
> > >>>>>>> - With the secure object, we will already fail starting QEMU if
> > >>>>>>>   --only-migratable was specified.
> > >>>>>>>
> > >>>>>>> My suggestion is now that we don't even offer the cpu feature if
> > >>>>>>> --only-migratable has been specified. For a guest that does not=
 want to
> > >>>>>>> transition to secure mode, nothing changes; a guest that wants =
to
> > >>>>>>> transition to secure mode will notice that the feature is not a=
vailable
> > >>>>>>> and fail appropriately (or ultimately, when the ultravisor call=
 fails).
> > >>>>>>> We'd still fail starting QEMU for the secure object + --only-mi=
gratable
> > >>>>>>> combination.
> > >>>>>>>
> > >>>>>>> Does that make sense?   =20
> > >>>>>>
> > >>>>>> It's a little unusual; I don't think we have any other cases whe=
re
> > >>>>>> --only-migratable changes the behaviour; I think it normally onl=
y stops
> > >>>>>> you doing something that would have made it unmigratable or caus=
es
> > >>>>>> an operation that would make it unmigratable to fail.   =20
> > >>>>>
> > >>>>> I would like to NOT block this feature with --only-migrateable. A=
 guest
> > >>>>> can startup unprotected (and then is is migrateable). the migrati=
on blocker
> > >>>>> is really a dynamic aspect during runtime.    =20
> > >>>>
> > >>>> But the point of --only-migratable is to turn things that would ha=
ve
> > >>>> blocked migration into failures, so that a VM started with
> > >>>> --only-migratable is *always* migratable.   =20
> > >>>
> > >>> Hmmm, fair enough. How do we do this with host-model? The construct=
ed model
> > >>> would contain unpack, but then it will fail to startup? Or do we si=
lently=20
> > >>> drop unpack in that case? Both variants do not feel completely righ=
t.  =20
> > >>
> > >> Failing if you explicitly specified unpacked feels right, but failing
> > >> if you just used the host model feels odd. Removing unpack also is a
> > >> bit odd, but I think the better option if we want to do anything abo=
ut
> > >> it at all. =20
> > >=20
> > > 'host-model' feels a bit special; but breaking the rule that
> > > only-migratable doesn't change behaviour is weird
> > > Can you do host,-unpack   to make that work explicitly? =20
> >=20
> > I guess that should work. But it means that we need to add logic in lib=
virt
> > to disable unpack for host-passthru and host-model. Next problem is the=
n,
> > that a future version might implement migration of such guests, which m=
eans
> > that libvirt must then stop fencing unpack. =20
>=20
> The "host-model" is supposed to always be migratable, so we should
> fence the feature there.
>=20
> host-passthrough is "undefined" whether it is migratable - it may or may
> not work, no guarantees made by libvirt.
>=20
> Ultimately I think the problem is that there ought to be an explicit
> config to enable the feature for s390, as there is for SEV, and will
> also presumably be needed for ppc.=20

Yes, an explicit config is what we want; unfortunately, we have to deal
with existing setups as well...

The options I see are
- leave things for existing setups as they are now (i.e. might become
  unmigratable when the guest transitions), and make sure we're doing
  the right thing with the new object
- always make the unpack feature conflict with migration requirements;
  this is a guest-visible change

The first option might be less hairy, all considered?

