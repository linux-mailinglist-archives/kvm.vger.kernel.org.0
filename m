Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC541F508E
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 10:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgFJItG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 04:49:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30920 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726908AbgFJItG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 04:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591778944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QKVu7ZxADo1gAnMY/bxV17fSsYxogX6tQ4JdkA15wn8=;
        b=SeSL8vGl25YdvTeBb81bsaRUH+XdCx22SlqAatWAVoSk/lr1mnTrc724uloSUJ5S7rqtau
        pJyQ52jbd4Jxcw/jzvYG/uiJrJRb9hjOOswaUiBFHzlvVnOiPwvhLenxPdZGsfVyWd4YYP
        ESn8uJf1hAqUhrbh7XhKxBSf7ySx/GY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-MGqV5kenOn6Ifd6CWxZumQ-1; Wed, 10 Jun 2020 04:49:02 -0400
X-MC-Unique: MGqV5kenOn6Ifd6CWxZumQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49E35A0BD7;
        Wed, 10 Jun 2020 08:49:00 +0000 (UTC)
Received: from gondolin (ovpn-112-196.ams2.redhat.com [10.36.112.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4A8619D71;
        Wed, 10 Jun 2020 08:48:54 +0000 (UTC)
Date:   Wed, 10 Jun 2020 10:48:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com, qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [RFC v2 18/18] guest memory protection: Alter virtio default
 properties for protected guests
Message-ID: <20200610104842.2687215a.cohuck@redhat.com>
In-Reply-To: <20200610043922.GI494336@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <20200521034304.340040-19-david@gibson.dropbear.id.au>
        <20200606162014-mutt-send-email-mst@kernel.org>
        <20200607030735.GN228651@umbus.fritz.box>
        <20200609121641.5b3ffa48.cohuck@redhat.com>
        <20200610043922.GI494336@umbus.fritz.box>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/5mCuw9L7XD9E/ZA074aXWEx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/5mCuw9L7XD9E/ZA074aXWEx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jun 2020 14:39:22 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Tue, Jun 09, 2020 at 12:16:41PM +0200, Cornelia Huck wrote:
> > On Sun, 7 Jun 2020 13:07:35 +1000
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > On Sat, Jun 06, 2020 at 04:21:31PM -0400, Michael S. Tsirkin wrote: =
=20
> > > > On Thu, May 21, 2020 at 01:43:04PM +1000, David Gibson wrote:   =20
> > > > > The default behaviour for virtio devices is not to use the platfo=
rms normal
> > > > > DMA paths, but instead to use the fact that it's running in a hyp=
ervisor
> > > > > to directly access guest memory.  That doesn't work if the guest'=
s memory
> > > > > is protected from hypervisor access, such as with AMD's SEV or PO=
WER's PEF.
> > > > >=20
> > > > > So, if a guest memory protection mechanism is enabled, then apply=
 the
> > > > > iommu_platform=3Don option so it will go through normal DMA mecha=
nisms.
> > > > > Those will presumably have some way of marking memory as shared w=
ith the
> > > > > hypervisor or hardware so that DMA will work.
> > > > >=20
> > > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > > ---
> > > > >  hw/core/machine.c | 11 +++++++++++
> > > > >  1 file changed, 11 insertions(+)
> > > > >=20
> > > > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > > > index 88d699bceb..cb6580954e 100644
> > > > > --- a/hw/core/machine.c
> > > > > +++ b/hw/core/machine.c
> > > > > @@ -28,6 +28,8 @@
> > > > >  #include "hw/mem/nvdimm.h"
> > > > >  #include "migration/vmstate.h"
> > > > >  #include "exec/guest-memory-protection.h"
> > > > > +#include "hw/virtio/virtio.h"
> > > > > +#include "hw/virtio/virtio-pci.h"
> > > > > =20
> > > > >  GlobalProperty hw_compat_5_0[] =3D {};
> > > > >  const size_t hw_compat_5_0_len =3D G_N_ELEMENTS(hw_compat_5_0);
> > > > > @@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState *=
machine)
> > > > >           * areas.
> > > > >           */
> > > > >          machine_set_mem_merge(OBJECT(machine), false, &error_abo=
rt);
> > > > > +
> > > > > +        /*
> > > > > +         * Virtio devices can't count on directly accessing gues=
t
> > > > > +         * memory, so they need iommu_platform=3Don to use norma=
l DMA
> > > > > +         * mechanisms.  That requires disabling legacy virtio su=
pport
> > > > > +         * for virtio pci devices
> > > > > +         */
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-leg=
acy", "on");
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_pl=
atform", "on");
> > > > >      }
> > > > >     =20
> > > >=20
> > > > I think it's a reasonable way to address this overall.
> > > > As Cornelia has commented, addressing ccw as well   =20
> > >=20
> > > Sure.  I was assuming somebody who actually knows ccw could do that a=
s
> > > a follow up. =20
> >=20
> > FWIW, I think we could simply enable iommu_platform for protected
> > guests for ccw; no prereqs like pci's disable-legacy. =20
>=20
> Right, and the code above should in fact already do so, since it
> applies that to TYPE_VIRTIO_DEVICE, which is common.  The
> disable-legacy part should be harmless for s390, since this is
> effectively just setting a default, and we don't expect any
> TYPE_VIRTIO_PCI devices to be instantiated on z.

Well, virtio-pci is available on s390, so people could try to use it --
however, forcing disable-legacy won't hurt in that case, as it won't
make the situation worse (I don't expect virtio-pci to work on s390
protected guests.)

>=20
> > > > as cases where user has
> > > > specified the property manually could be worth-while.   =20
> > >=20
> > > I don't really see what's to be done there.  I'm assuming that if the
> > > user specifies it, they know what they're doing - particularly with
> > > nonstandard guests there are some odd edge cases where those
> > > combinations might work, they're just not very likely. =20
> >=20
> > If I understood Halil correctly, devices without iommu_platform
> > apparently can crash protected guests on s390. Is that supposed to be a
> > "if it breaks, you get to keep the pieces" situation, or do we really
> > want to enforce iommu_platform? =20
>=20
> I actually think "if you broke it, keep the pieces" is an acceptable
> approach here, but that doesn't preclude some further enforcement to
> improve UX.

I'm worried about spreading dealing with this over too many code areas,
though.

--Sig_/5mCuw9L7XD9E/ZA074aXWEx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl7gnmoACgkQ3s9rk8bw
L6//GQ//bnJsYCKaP5H7gvnnm3QfOJ6l/xJixBZwXIAo2IdomMaKgvFq9pyeQycs
6086cHGvkuelTwkEAnd976K8DEvD1w5ITOwdZsHQeQF1qw0OGIjaFtUSZaR5Te/I
dciAAq8BxSjI/vof4bowyWxvEyFhU2NVYbKsCY3CVG12XvRm5wFhdeUmr2bEItSn
6yhywUJ0XnoseIZUqGvhaRlHinhe+1XyVxg0FrKNFJXS6vSYAWPPMUltrv03lbRY
UowGUb+lNjTHTa6bbyL+YwTzzFPymo/a9CVYWckCy2bZV6FglAJ35an42t8ihpNX
YV9cL6+gYt6x/m1SwtQzYRM7mjXJ3SRb+Z6X0//IQtlY4hkC5uy4wN+tvrOj1geL
C7pLFSpu2Y6opbennxD4TjR/Qk9VlXN7GDgO8m6FnPbonDuBw5v6ZpdrOR7GEGBj
ZAJ4ZmZJhQiNFyfBsjkjUjN0tnIAPayfrdCmsoAA3qZNHueR6aMrlYieTtsYsL7J
bBi1oumBh7milx85JDURBRlWLm0DJc1uScxJl+Tmrt7JBenmEenN0KwuDK2spOhx
+tscrpiGhnZtbfW/uDgTx0aLjzz0PqyjQt0Ik0logINb9LGxWd4PJYPyYsVFNZFj
bszoynyOXMh6xAR8IYAXDOU9oAIiIUbwpocRjsCwo0rxTUr8lHg=
=PBGb
-----END PGP SIGNATURE-----

--Sig_/5mCuw9L7XD9E/ZA074aXWEx--

