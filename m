Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA93A1F37B8
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 12:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgFIKRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 06:17:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22238 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgFIKRT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 06:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591697837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3kr0diAHGiZkx5sVcjzLX57ALpozHuI6negv/a0mFBA=;
        b=LRLciQMsjou1w57LnRm1YhWSXOC9CBKUUK3hGFI3zsPZG6CGwtuwKG8y7tjhy8XqnRiZom
        XwyFx5KwGZPZn21POkDCUjLPWNnRx3h2M6U+HNwkK3Jlvrx5I+pJaVGCRRobTpn20qoy5C
        ZWmJUdqQ6XdFv5Pv4z4eAvA7LrAZ070=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-V3CNbOdPNHu6H7I0haBEHw-1; Tue, 09 Jun 2020 06:17:01 -0400
X-MC-Unique: V3CNbOdPNHu6H7I0haBEHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FFA11054F8B;
        Tue,  9 Jun 2020 10:16:59 +0000 (UTC)
Received: from gondolin (ovpn-113-27.ams2.redhat.com [10.36.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9EA6100164C;
        Tue,  9 Jun 2020 10:16:53 +0000 (UTC)
Date:   Tue, 9 Jun 2020 12:16:41 +0200
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
Message-ID: <20200609121641.5b3ffa48.cohuck@redhat.com>
In-Reply-To: <20200607030735.GN228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <20200521034304.340040-19-david@gibson.dropbear.id.au>
        <20200606162014-mutt-send-email-mst@kernel.org>
        <20200607030735.GN228651@umbus.fritz.box>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/59YR5Udn9lEsdlpWfEsPJrT";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/59YR5Udn9lEsdlpWfEsPJrT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 7 Jun 2020 13:07:35 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Sat, Jun 06, 2020 at 04:21:31PM -0400, Michael S. Tsirkin wrote:
> > On Thu, May 21, 2020 at 01:43:04PM +1000, David Gibson wrote: =20
> > > The default behaviour for virtio devices is not to use the platforms =
normal
> > > DMA paths, but instead to use the fact that it's running in a hypervi=
sor
> > > to directly access guest memory.  That doesn't work if the guest's me=
mory
> > > is protected from hypervisor access, such as with AMD's SEV or POWER'=
s PEF.
> > >=20
> > > So, if a guest memory protection mechanism is enabled, then apply the
> > > iommu_platform=3Don option so it will go through normal DMA mechanism=
s.
> > > Those will presumably have some way of marking memory as shared with =
the
> > > hypervisor or hardware so that DMA will work.
> > >=20
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > ---
> > >  hw/core/machine.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >=20
> > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > index 88d699bceb..cb6580954e 100644
> > > --- a/hw/core/machine.c
> > > +++ b/hw/core/machine.c
> > > @@ -28,6 +28,8 @@
> > >  #include "hw/mem/nvdimm.h"
> > >  #include "migration/vmstate.h"
> > >  #include "exec/guest-memory-protection.h"
> > > +#include "hw/virtio/virtio.h"
> > > +#include "hw/virtio/virtio-pci.h"
> > > =20
> > >  GlobalProperty hw_compat_5_0[] =3D {};
> > >  const size_t hw_compat_5_0_len =3D G_N_ELEMENTS(hw_compat_5_0);
> > > @@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState *mach=
ine)
> > >           * areas.
> > >           */
> > >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > > +
> > > +        /*
> > > +         * Virtio devices can't count on directly accessing guest
> > > +         * memory, so they need iommu_platform=3Don to use normal DM=
A
> > > +         * mechanisms.  That requires disabling legacy virtio suppor=
t
> > > +         * for virtio pci devices
> > > +         */
> > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy"=
, "on");
> > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platfo=
rm", "on");
> > >      }
> > >   =20
> >=20
> > I think it's a reasonable way to address this overall.
> > As Cornelia has commented, addressing ccw as well =20
>=20
> Sure.  I was assuming somebody who actually knows ccw could do that as
> a follow up.

FWIW, I think we could simply enable iommu_platform for protected
guests for ccw; no prereqs like pci's disable-legacy.

>=20
> > as cases where user has
> > specified the property manually could be worth-while. =20
>=20
> I don't really see what's to be done there.  I'm assuming that if the
> user specifies it, they know what they're doing - particularly with
> nonstandard guests there are some odd edge cases where those
> combinations might work, they're just not very likely.

If I understood Halil correctly, devices without iommu_platform
apparently can crash protected guests on s390. Is that supposed to be a
"if it breaks, you get to keep the pieces" situation, or do we really
want to enforce iommu_platform?

--Sig_/59YR5Udn9lEsdlpWfEsPJrT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl7fYYkACgkQ3s9rk8bw
L6+Ogg/8CyUEKbMCFVoEYeE2/cCowf+ZgHo/5pBTjZPrDK4kczqle2Ggjpzan8Li
suuCWtxUT44MBJYecjUH6NQ9Y26Q/vhKLRKFSOeY/Tgxg2mrt4e+ZiBiZQ1H9XTH
o0PZeTyHJoUFmzOl2udbSYQ044RjYmxoTSly+oM4NX//JQ/t0fvDUQv3anIV5rkJ
kqWhfdg5o81FI17v0AoC2WjOkQTVzld+LREOb0OoYx2LtGECaHYnoP9oIAEz0uu0
iGNXNv1SrLjdayWSbOrUCr1POhiBCW+H0wS7YPvze/UVeCnH3cV41xIN/U8SruNA
e6/e0bPIm3VOybRTYuvfScc3TZ9m8vdqAKiMF567CF853gZSt27eUB1D8gK+165W
T1GjxZsDS/ke0YVliysaAm3SGbcYaLXcq7TWl89Cg8ucsYDVWO9sGIZSIQt1MaND
dC2MdF2gSaFQyoAgMR4nFW9nwwj7ew/sYPAVSPIiJDWXdd+bjG9FLN9SKiqf+2yD
0owyG4egD8V24nXiaSFdweE6MOWHyQKCg9Q+RYbsN0EGBzzUe8WNr+hEAxiYTRpW
cib/fWHWG/vK8EuIYj3UxdBVhZR4zbGPGrMeRou64jO9BLz7qwcHzscZGRg69kos
3BzIYznYFuUodzrHS/pWIDNhJFuGjAsuF9Nwkn7DWaztRI20LeM=
=axIE
-----END PGP SIGNATURE-----

--Sig_/59YR5Udn9lEsdlpWfEsPJrT--

