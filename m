Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2493B268A
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFXEyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:54 -0400
Received: from ozlabs.org ([203.11.71.1]:42003 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhFXEyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:49 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT1cxCz9sXk; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=gx1WywRC3hzAXTFvcjV77xiuCCDpKaGBAiNERwWNXHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZNjtTIv+aoOOMsQEuR9LI3Ajo5dPFwhh8uRET88yjg6nNycrrgKuuusUubj9oeAP
         ZDx3VYz++fBd1Jdpbv0q/KrHvxGcYdBW0DlLGmk9BLHt8qDq6PR9nWFSeznFOgwNrK
         CIxdpyKsA7PT2pbifAk00fEpP3NBndVLifehWURk=
Date:   Thu, 24 Jun 2021 13:49:37 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNQA0aGlaDf+UUTR@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
 <YLhsZRc72aIMZajz@yekko>
 <YLn/SJtzuJopSO2x@myrica>
 <YL8O1pAlg1jtHudn@yekko>
 <YMI/yynDsX/aaG8T@myrica>
 <YMq6voIhXt7guI+W@yekko>
 <YMzR46luaG7hXsJi@myrica>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1H+1uPZlhx9jF8kT"
Content-Disposition: inline
In-Reply-To: <YMzR46luaG7hXsJi@myrica>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1H+1uPZlhx9jF8kT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 18, 2021 at 07:03:31PM +0200, Jean-Philippe Brucker wrote:
> On Thu, Jun 17, 2021 at 01:00:14PM +1000, David Gibson wrote:
> > On Thu, Jun 10, 2021 at 06:37:31PM +0200, Jean-Philippe Brucker wrote:
> > > On Tue, Jun 08, 2021 at 04:31:50PM +1000, David Gibson wrote:
> > > > For the qemu case, I would imagine a two stage fallback:
> > > >=20
> > > >     1) Ask for the exact IOMMU capabilities (including pagetable
> > > >        format) that the vIOMMU has.  If the host can supply, you're
> > > >        good
> > > >=20
> > > >     2) If not, ask for a kernel managed IOAS.  Verify that it can m=
ap
> > > >        all the IOVA ranges the guest vIOMMU needs, and has an equal=
 or
> > > >        smaller pagesize than the guest vIOMMU presents.  If so,
> > > >        software emulate the vIOMMU by shadowing guest io pagetable
> > > >        updates into the kernel managed IOAS.
> > > >=20
> > > >     3) You're out of luck, don't start.
> > > >    =20
> > > > For both (1) and (2) I'd expect it to be asking this question *afte=
r*
> > > > saying what devices are attached to the IOAS, based on the virtual
> > > > hardware configuration.  That doesn't cover hotplug, of course, for
> > > > that you have to just fail the hotplug if the new device isn't
> > > > supportable with the IOAS you already have.
> > >=20
> > > Yes. So there is a point in time when the IOAS is frozen, and cannot =
take
> > > in new incompatible devices. I think that can support the usage I had=
 in
> > > mind. If the VMM (non-QEMU, let's say) wanted to create one IOASID FD=
 per
> > > feature set it could bind the first device, freeze the features, then=
 bind
> >=20
> > Are you thinking of this "freeze the features" as an explicitly
> > triggered action?  I have suggested that an explicit "ENABLE" step
> > might be useful, but that hasn't had much traction from what I've
> > seen.
>=20
> Seems like we do need an explicit enable step for the flow you described
> above:
>=20
> a) Bind all devices to an ioasid. Each bind succeeds.
> b) Ask for a specific set of features for this aggregate of device. Ask
>    for (1), fall back to (2), or abort.
> c) Boot the VM
> d) Hotplug a device, bind it to the ioasid. We're long past negotiating
>    features for the ioasid, so the host needs to reject the bind if the
>    new device is incompatible with what was requested at (b)
>=20
> So a successful request at (b) would be the point where we change the
> behavior of bind.
>=20
> Since the kernel needs a form of feature check in any case, I still have a
> preference for aborting the bind at (a) if the device isn't exactly
> compatible with other devices already in the ioasid, because it might be
> simpler to implement in the host, but I don't feel strongly about this.
>=20
>=20
> > > I'd like to understand better where the difficulty lies, with migrati=
on.
> > > Is the problem, once we have a guest running on physical machine A, to
> > > make sure that physical machine B supports the same IOMMU properties
> > > before migrating the VM over to B?  Why can't QEMU (instead of the us=
er)
> > > select a feature set on machine A, then when time comes to migrate, q=
uery
> > > all information from the host kernel on machine B and check that it
> > > matches what was picked for machine A?  Or is it only trying to
> > > accommodate different sets of features between A and B, that would be=
 too
> > > difficult?
> >=20
> > There are two problems
> >=20
> > 1) Although it could be done in theory, it's hard, and it would need a
> > huge rewrite to qemu's whole migration infrastructure to do this.
> > We'd need a way of representing host features, working out which sets
> > are compatible with which others depending on what things the guest is
> > allowed to use, encoding the information in the migration stream and
> > reporting failure.  None of this exists now.
> >=20
> > Indeed qemu requires that you create the (stopped) machine on the
> > destination (including virtual hardware configuration) before even
> > attempting to process the incoming migration.  It does not for the
> > most part transfer the machine configuration in the migration stream.
> > Now, that's generally considered a flaw with the design, but fixing it
> > is a huge project that no-one's really had the energy to begin despite
> > the idea being around for years.
> >=20
> > 2) It makes behaviour really hard to predict for management layers
> > above.  Things like oVirt automatically migrate around a cluster for
> > load balancing.  At the moment the model which works is basically that
> > you if you request the same guest features on each end of the
> > migration, and qemu starts with that configuration on each end, the
> > migration should work (or only fail for transient reasons).  If you
> > can't know if the migration is possible until you get the incoming
> > stream, reporting and exposing what will and won't work to the layer
> > above also becomes an immensely fiddly problem.
>=20
> That was really useful, thanks. One thing I'm worried about is the user
> having to know way too much detail about IOMMUs in order to pick a precise
> configuration. The Arm SMMUs have a lot of small features that
> implementations can mix and match and that a user shouldn't have to care
> about, and there are lots of different implementations by various vendors.
> I suppose QEMU can offer a couple of configurations with predefined sets
> of features, but it seems easy to end up with a config that gets rejected
> because it is slightly different than the hardware. Anyway this is a
> discussion we can have once we touch on the features in GET_INFO, I don't
> have a precise idea at the moment.

That's a reasonable concern.  Most of this is about selecting good
default modes in the machine type and virtual devices.  In general it
would be best to make the defaults for the virtual devices use only
features that are either available on enough current hardware or can
be software emulated without too much trouble.  Roughly have the qemu
mode default to the least common denominator IOMMU capabilities.  We
can update those defaults with new machine types as new hardware
becomes current and older stuff becomes rare/obsolete.  That still
leaves selecting an old machine type or explicitly overriding the
parameters if you need to either a) work on an old host that's missing
capabilities or b) want to take full advantage of a new host.

This can be a pretty complex judgement call of course.  There are many
tradeoffs, particularly of performance on new hosts versus
compatibility with old hosts.  There can be compelling reasons to
restrict the default model to new(ish) hardware even though it means
quite a lot of people with older hardware will need awkward options
(we have a non IOMMU related version of this problem on POWER; for
security reasons, current machine types default to enabling several
Spectre mitigations - but that means qemu won't start without special
options on hosts that have an old firmware which doesn't support those
mitigations).

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--1H+1uPZlhx9jF8kT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUAM8ACgkQbDjKyiDZ
s5IsEQ/+KuPQmgXZ7w8X3+AKd6WcXV7MXhmj04w4OSBEg7W4ZsUI0Z9K44hlu8Jh
aWGISehQxrfSuz9fN66zB/fRw3qPiP5UAv2adZZFzn0IUFHLJgViaNoyyi1AmcRt
floi0Lr8i9M0q+LnzPgnXjgTrXyossv8n6/x1V8Lneiez8L/SYFQz9wX7SFhNCV+
OqEhgoH3B5MmXa8GMeArkARXktTvpS7/MkD+1q+fCCEWQfGOetZStMlI+rgZKMg/
qrfcU1GH459uYOf9ZP1H5MXbbuO0ecsqWFTryPdXwQdv22OnF70KQX5cIbTGwS/X
+AtIyIwENzAXXr0OAHyDYn4MZhYmbv3roHH0d54fx2e5lZ4l8VKQQv6+khErtkzW
hMQJpy4UUjst+vhn04KTyxFW6AvQLmCAzldy8NLWRVqaz8m9XzUjMkmLgF78L/m8
RtP7d5z9zskbbSz0XkbeVhNFIBbCXpU7hVDmRSUYXeYYMR60R/clk34u+MntO7RQ
ybaoQrauhtd8mR55ZIpvFojKFr/e/D3ZCkOWqYh7E50a/pUZkxt2QEgZK6IFhuIs
gv4AJTJguJ3ijnMclp4i6165vS5B/RE5Ruvw08e0K0tTaGY3Hzs3eYkVGWeDZvQd
Cjh4QlrQS048cFIR/8ARDShPsi0Y5wIRkjwgbuqNdDQ4s96TkZo=
=RxEB
-----END PGP SIGNATURE-----

--1H+1uPZlhx9jF8kT--
