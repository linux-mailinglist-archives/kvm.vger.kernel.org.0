Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F243251F45F
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 08:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiEIGND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 02:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiEIGGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 02:06:14 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C95D1683E0
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 23:02:20 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4KxVtw71lFz4ySZ; Mon,  9 May 2022 16:02:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1652076136;
        bh=Vhs7ysslA9UJHARNrh8tSTfwREaGgY1qUBh6JyGJ84k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aWAKm4ul6nu2TAfqHtKaimZilcpVfeUVVTDOW1ahacZ4uic71xMBoqIzEhyEqhBFS
         s2v+MxVWYf+AnGjdBI1dtVKNQ07WnwzCn3FIBJR/g+ypytBiVdODqQoPdWC3v89BOu
         x+u7DhvhF6PxsTxzL2ZcVYFCIqvnQjQellSX2b2E=
Date:   Mon, 9 May 2022 16:01:52 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <YniuUMCBjy0BaJC6@yekko>
References: <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
 <YnSxL5KxwJvQzd2Q@yekko>
 <20220506124837.GB49344@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3wd1CRtMeCjI53mC"
Content-Disposition: inline
In-Reply-To: <20220506124837.GB49344@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3wd1CRtMeCjI53mC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 06, 2022 at 09:48:37AM -0300, Jason Gunthorpe wrote:
> On Fri, May 06, 2022 at 03:25:03PM +1000, David Gibson wrote:
> > On Thu, May 05, 2022 at 04:07:28PM -0300, Jason Gunthorpe wrote:
>=20
> > > When the iommu_domain is created I want to have a
> > > iommu-driver-specific struct, so PPC can customize its iommu_domain
> > > however it likes.
> >=20
> > This requires that the client be aware of the host side IOMMU model.
> > That's true in VFIO now, and it's nasty; I was really hoping we could
> > *stop* doing that.
>=20
> iommufd has two modes, the 'generic interface' which what this patch
> series shows that does not require any device specific knowledge.

Right, and I'm speaking specifically to that generic interface.  But
I'm thinking particularly about the qemu case where we do have
specific knowledge of the *guest* vIOMMU, but we want to avoid having
specific knowledge of the host IOMMU, because they might not be the same.

It would be good to have a way of seeing if the guest vIOMMU can be
emulated on this host IOMMU without qemu having to have separate
logic for every host IOMMU.

> The default iommu_domain that the iommu driver creates will be used
> here, it is up to the iommu driver to choose something reasonable for
> use by applications like DPDK. ie PPC should probably pick its biggest
> x86-like aperture.

So, using the big aperture means a very high base IOVA
(1<<59)... which means that it won't work at all if you want to attach
any devices that aren't capable of 64-bit DMA.  Using the maximum
possible window size would mean we either potentially waste a lot of
kernel memory on pagetables, or we use unnecessarily large number of
levels to the pagetable.

Basically we don't have enough information to make a good decision
here.

More generally, the problem with the interface advertising limitations
and it being up to userspace to work out if those are ok or not is
that it's fragile.  It's pretty plausible that some future IOMMU model
will have some new kind of limitation that can't be expressed in the
query structure we invented now.  That means that to add support for
that we need some kind of gate to prevent old userspace using the new
IOMMU (e.g. only allowing the new IOMMU to be used if userspace uses
newly added queries to get the new limitations).  That's true even if
what userspace was actually doing with the IOMMU would fit just fine
into those new limitations.

But if userspace requests the capabilities it wants, and the kernel
acks or nacks that, we can support the new host IOMMU with existing
software just fine.  They won't be able to use any *new* features or
capabilities of the new hardware, of course, but they'll be able to
use what it does that overlaps with what they needed before.

ppc - or more correctly, the POWER and PAPR IOMMU models - is just
acting here as an example of an IOMMU with limitations and
capabilities that don't fit into the current query model.

> The iommu-driver-specific struct is the "advanced" interface and
> allows a user-space IOMMU driver to tightly control the HW with full
> HW specific knowledge. This is where all the weird stuff that is not
> general should go.

Right, but forcing anything more complicated than "give me some IOVA
region" to go through the advanced interface means that qemu (or any
hypervisor where the guest platform need not identically match the
host) has to have n^2 complexity to match each guest IOMMU model to
each host IOMMU model.

> > Note that I'm talking here *purely* about the non-optimized case where
> > all updates to the host side IO pagetables are handled by IOAS_MAP /
> > IOAS_COPY, with no direct hardware access to user or guest managed IO
> > pagetables.  The optimized case obviously requires end-to-end
> > agreement on the pagetable format amongst other domain properties.
>=20
> Sure, this is how things are already..
>=20
> > What I'm hoping is that qemu (or whatever) can use this non-optimized
> > as a fallback case where it does't need to know the properties of
> > whatever host side IOMMU models there are.  It just requests what it
> > needs based on the vIOMMU properties it needs to replicate and the
> > host kernel either can supply it or can't.
>=20
> There aren't really any negotiable vIOMMU properties beyond the
> ranges, and the ranges are not *really* negotiable.

Errr.. how do you figure?  On ppc the ranges and pagesizes are
definitely negotiable.  I'm not really familiar with other models, but
anything which allows *any* variations in the pagetable structure will
effectively have at least some negotiable properties.

Even if any individual host IOMMU doesn't have negotiable properties
(which ppc demonstrates is false), there's still a negotiation here in
the context that userspace doesn't know (and doesn't care) what
specific host IOMMU model it has.

> There are lots of dragons with the idea we can actually negotiate
> ranges - because asking for the wrong range for what the HW can do
> means you don't get anything. Which is completely contrary to the idea
> of easy generic support for things like DPDK.
>
> So DPDK can't ask for ranges, it is not generic.

Which is why I'm suggesting that the base address be an optional
request.  DPDK *will* care about the size of the range, so it just
requests that and gets told a base address.

Qemu emulating a vIOMMU absolutely does care about the ranges, and if
the HW can't do it, failing outright is the correct behaviour.

> This means we are really talking about a qemu-only API,

Kind of, yes.  I can't immediately think of anything which would need
this fine gained control over the IOMMU capabilities other than an
emulator/hypervisor emulating a different vIOMMU than the host IOMMU.
qemu is by far the most prominent example of this.

> and IMHO, qemu
> is fine to have a PPC specific userspace driver to tweak this PPC
> unique thing if the default windows are not acceptable.

Not really, because it's the ppc *target* (guest) side which requires
the specific properties, but selecting the "advanced" interface
requires special knowledge on the *host* side.

> IMHO it is no different from imagining an Intel specific userspace
> driver that is using userspace IO pagetables to optimize
> cross-platform qemu vIOMMU emulation.

I'm not quite sure what you have in mind here.  How is it both Intel
specific and cross-platform?

> We should be comfortable with
> the idea that accessing the full device-specific feature set requires
> a HW specific user space driver.
>=20
> > Admittedly those are pretty niche cases, but allowing for them gives
> > us flexibility for the future.  Emulating an ARM SMMUv3 guest on an
> > ARM SMMU v4 or v5 or v.whatever host is likely to be a real case in
> > the future, and AFAICT, ARM are much less conservative that x86 about
> > maintaining similar hw interfaces over time.  That's why I think
> > considering these ppc cases will give a more robust interface for
> > other future possibilities as well.
>=20
> I don't think so - PPC has just done two things that are completely
> divergent from eveything else - having two IO page tables for the same
> end point, and using map/unmap hypercalls instead of a nested page
> table.
>=20
> Everyone else seems to be focused on IOPTEs that are similar to CPU
> PTEs, particularly to enable SVA and other tricks, and CPU's don't
> have either of this weirdness.

Well, you may have a point there.  Though, my experience makes me
pretty reluctant to ever bet on hw designers *not* inserting some
weird new constraint and assuming sw can just figure it out somehow.

Note however, that having multiple apertures isn't really ppc specific.
Anything with an IO hole effectively has separate apertures above and
below the hole.  They're much closer together in address than POWER's
two apertures, but I don't see that makes any fundamental difference
to the handling of them.

> > You can consider that a map/unmap hypercall, but the size of the
> > mapping is fixed (the IO pagesize which was previously set for the
> > aperture).
>=20
> Yes, I would consider that a map/unmap hypercall vs a nested translation.
> =20
> > > Assuming yes, I'd expect that:
> > >=20
> > > The iommu_domain for nested PPC is just a log of map/unmap hypervsior
> > > calls to make. Whenever a new PE is attached to that domain it gets
> > > the logged map's replayed to set it up, and when a PE is detached the
> > > log is used to unmap everything.
> >=20
> > And likewise duplicate every H_PUT_TCE to all the PEs in the domain.
> > Sure.  It means the changes won't be atomic across the domain, but I
> > guess that doesn't matter.  I guess you could have the same thing on a
> > sufficiently complex x86 or ARM system, if you put two devices into
> > the IOAS that were sufficiently far from each other in the bus
> > topology that they use a different top-level host IOMMU.
>=20
> Yes, strict atomicity is not needed.

Ok, good to know.

> > > It is not perfectly memory efficient - and we could perhaps talk about
> > > a API modification to allow re-use of the iommufd datastructure
> > > somehow, but I think this is a good logical starting point.
> >=20
> > Because the map size is fixed, a "replay log" is effectively
> > equivalent to a mirror of the entire IO pagetable.
>=20
> So, for virtualized PPC the iommu_domain is an xarray of mapped PFNs
> and device attach/detach just sweeps the xarray and does the
> hypercalls. Very similar to what we discussed for S390.
>=20
> It seems OK, this isn't even really overhead in most cases as we
> always have to track the mapped PFNs anyhow.

Fair enough, I think that works.

> > > Once a domain is created and attached to a group the aperture should
> > > be immutable.
> >=20
> > I realize that's the model right now, but is there a strong rationale
> > for that immutability?
>=20
> I have a strong preference that iommu_domains have immutable
> properties once they are created just for overall sanity. Otherwise
> everything becomes a racy mess.
>=20
> If the iommu_domain changes dynamically then things using the aperture
> data get all broken - it is complicated to fix. So it would need a big
> reason to do it, I think.

Ok, that makes sense.  I'm pretty ok with the iommu_domain having
static apertures.  We can't optimally implement ddw that way, but I
think we can do it well enough by creating new domains and copying the
mappings, as you suggested.

> > Come to that, IIUC that's true for the iommu_domain at the lower
> > level, but not for the IOAS at a higher level.  You've stated that's
> > *not* immutable, since it can shrink as new devices are added to the
> > IOAS.  So I guess in that case the IOAS must be mapped by multiple
> > iommu_domains?
>=20
> Yes, thats right. The IOAS is expressly mutable because it its on
> multiple domains and multiple groups each of which contribute to the
> aperture. The IOAS aperture is the narrowest of everything, and we
> have semi-reasonable semantics here. Here we have all the special code
> to juggle this, but even in this case we can't handle an iommu_domain
> or group changing asynchronously.

Ok.

So at the IOAS level, the apertures are already dynamic.  Arguably the
main point of my proposal is that it makes any changes in IOAS
apertures explicit, rather than implicit.  Typically userspace
wouldn't need to rely on the aperture information from a query,
because they know it will never shrink below the parameters they
specified.

Another approach would be to give the required apertures / pagesizes
in the initial creation of the domain/IOAS.  In that case they would
be static for the IOAS, as well as the underlying iommu_domains: any
ATTACH which would be incompatible would fail.

That makes life hard for the DPDK case, though.  Obviously we can
still make the base address optional, but for it to be static the
kernel would have to pick it immediately, before we know what devices
will be attached, which will be a problem on any system where there
are multiple IOMMUs with different constraints.

> > Right but that aperture is coming only from the hardware.  What I'm
> > suggesting here is that userspace can essentially opt into a *smaller*
> > aperture (or apertures) than the hardware permits.  The value of this
> > is that if the effective hardware aperture shrinks due to adding
> > devices, the kernel has the information it needs to determine if this
> > will be a problem for the userspace client or not.
>=20
> We can do this check in userspace without more kernel APIs, userspace
> should fetch the ranges and confirm they are still good after
> attaching devices.

Well, yes, but I always think an API which stops you doing the wrong
thing is better than one which requires you take a bunch of extra
steps to use safely.  Plus, as noted above, this breaks down if some
future IOMMU has a new constraint not expressed in the current query
API.

> In general I have no issue with limiting the IOVA allocator in the
> kernel, I just don't have a use case of an application that could use
> the IOVA allocator (like DPDK) and also needs a limitation..

Well, I imagine DPDK has at least the minimal limitation that it needs
the aperture to be a certain minimum size (I'm guessing at least the
size of its pinned hugepage working memory region).  That's a
limitation that's unlikely to fail on modern hardware, but it's there.

> > > >   * A newly created kernel-managed IOAS has *no* IOVA windows
> > >=20
> > > Already done, the iommufd IOAS has no iommu_domains inside it at
> > > creation time.
> >=20
> > That.. doesn't seem like the same thing at all.  If there are no
> > domains, there are no restrictions from the hardware, so there's
> > effectively an unlimited aperture.
>=20
> Yes.. You wanted a 0 sized window instead?

Yes.  Well.. since I'm thinking in terms of multiple windows, I was
thinking of it as "0 windows" rather than a 0-sized window, but
whatever.  Starting with no permitted IOVAs is the relevant point.

> Why?

To force the app to declare its windows with CREATE_WINDOW before
using them.

> That breaks what I'm
> trying to do to make DPDK/etc portable and dead simple.

It doesn't break portability at all.  As for simplicity, yes it adds
an extra required step, but the payoff is that it's now impossible to
subtly screw up by failing to recheck your apertures after an ATTACH.
That is, it's taking a step which was implicitly required and
replacing it with one that's explicitly required.

> > > >   * A CREATE_WINDOW operation is added
> > > >       * This takes a size, pagesize/granularity, optional base addr=
ess
> > > >         and optional additional attributes=20
> > > >       * If any of the specified attributes are incompatible with the
> > > >         underlying hardware, the operation fails
> > >=20
> > > iommu layer has nothing called a window. The closest thing is a
> > > domain.
> >=20
> > Maybe "window" is a bad name.  You called it "aperture" above (and
> > I've shifted to that naming) and implied it *was* part of the IOMMU
> > domain.=20
>=20
> It is but not as an object that can be mutated - it is just a
> property.
>=20
> You are talking about a window object that exists somehow, I don't
> know this fits beyond some creation attribute of the domain..

At the domain layer, I think we can manage it that way, albeit
suboptimally.

> > That said, it doesn't need to be at the iommu layer - as I
> > said I'm consdiering this primarily a software concept and it could be
> > at the IOAS layer.  The linkage would be that every iommufd operation
> > which could change either the user-selected windows or the effective
> > hardware apertures must ensure that all the user windows (still) lie
> > within the hardware apertures.
>=20
> As Kevin said, we need to start at the iommu_domain layer first -
> when we understand how that needs to look then we can imagine what the
> uAPI should be.

Hm, ok.  I'm looking in the other direction - what uAPIs are needed to
do the things I'm considering in userspace, given the constraints of
the hardware I know about.  I'm seeing what layer we match one to the
other at as secondary.

> I don't want to create something in iommufd that is wildly divergent
> from what the iommu_domain/etc can support.

Fair enough.

> > > The only thing the kernel can do is rely a notification that something
> > > happened to a PE. The kernel gets an event on the PE basis, I would
> > > like it to replicate it to all the devices and push it through the
> > > VFIO device FD.
> >=20
> > Again: it's not about the notifications (I don't even really know how
> > those work in EEH).
>=20
> Well, then I don't know what we are talking about - I'm interested in
> what uAPI is needed to support this, as far as can I tell that is a
> notification something bad happened and some control knobs?

As far as I remember that's basically right, but the question is the
granularity at which those control knobs operate, given that some of
the knobs can be automatically flipped in case of a hardware error.

> As I said, I'd prefer this to be on the vfio_device FD vs on iommufd
> and would like to find a way to make that work.

It probably does belong on the device FD, but we need to consider the
IOMMU, because these things are operating at the granularity of (at
least) an IOMMU group.

> > expects that to happen at the (virtual) hardware level.  So if a guest
> > trips an error on one device, it expects IO to stop for every other
> > device in the PE.  But if hardware's notion of the PE is smaller than
> > the guest's the host hardware won't accomplish that itself.
>=20
> So, why do that to the guest? Shouldn't the PE in the guest be
> strictly a subset of the PE in the host, otherwise you hit all these
> problems you are talking about?

Ah.. yes, I did leave that out.  It's moderately complicated

- The guest PE can never be a (strict) subset of the host PE.  A PE
  is an IOMMU group in Linux terms, so if a host PE were split
  amongst guest PEs we couldn't supply the isolation semantics that
  the guest kernel will expect.  So one guest PE must always consist
  of 1 or more host PEs.

- We can't choose the guest PE boundaries completely arbitrarily.  The
  PAPR interfaces tie the PE boundaries to (guest) PCI(e) topology in a
  pretty confusing way that comes from the history of IBM hardware.

- To keep things simple, qemu makes the choice that each guest PCI
  Host Bridge (vPHB) is a single (guest) PE.  (Having many independent
  PHBs is routine on POWER systems.)

- So, where the guest PEs lie depends on how the user/configuration
  assigns devices to PHBs in the guest topology.

- We enforce (as we must) that devices from a single host PE can't be
  split across guest PEs.  I think qemu has specific checks for this
  in order to give better errors, but it will also be enforced by
  VFIO: we have one container per PHB (guest PE) so we can't attach
  the same group (host PE) to two of them.

- We don't enforce that we have at *most* one host PE per PHB - and
  that's useful, because lots of scripts / management tools / whatever
  designed for x86 just put all PCI devices onto the same vPHB,
  regardless of how they're grouped on the host.

- There are some additional complications because of the possibility
  of qemu emulated devices, which don't have *any* host PE.

> > used this in anger, I think a better approach is to just straight up
> > fail any attempt to do any EEH operation if there's not a 1 to 1
> > mapping from guest PE (domain) to host PE (group).
>=20
> That makes sense

Short of a time machine to murd^H^H^H^Heducate the people who wrote
the EEH interfaces, I think it's the best we have.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--3wd1CRtMeCjI53mC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJ4rkgACgkQgypY4gEw
YSLV5hAAxtYLmajbDNgEO6yg1SuIY2TqzXN+CJaFalCBRjc7eOK9uuA403kZwJ1x
jySts+PzAe9eerAlaSKHzER61JE4nnTLe2xAz1ajVJATN6/g+AVmz7i63RLrpvWI
47W2bX458XZ4IQ/zUPQc2S6d9vRdTZhfToylnvdqhofMWtomNUh2j8HZhU5q0I2P
TRGlSg3O+H+FbrXr5wvbMlGZgI7J1UsKLShfrWBTMFvLA8ku2LZFfph01dBPL3v4
hqc30XXrJ4VjJ98nIymsXHvGZezVtcmwuKaE9SJKYKhDkcqYd3znd/Fk9im45ayN
zUlMZxMLxqr+Tlkaa+q/yl+RssvICOgmqZbe+nJp3IW7eAZkjGtQOLJU6LWN9gQ3
Gbbd8Rm8uqnh7xXsIK0jrhvzXgbQkaKVpsXEN+gp8xCH0NM1SFp9J3LK4K9Utii2
VOyo+iBAzk0SnEgmf5AzexQfpeJOEKRKPpbRj98FDLmJskYtZActPU08CE6t2gEU
y6Jq+1HtwXelXwJKqAtCZdCrVJkIPDrx072GpJ0QE1jjb0WvTHqnKZj4YbFVSyTk
/SV+LygEkq5rwxOFg1Yn3NrteA0niUaDapdx9UJO+6iTQ/Kz/7WwD+C+AEBOtx7K
B3gIoGXBnlugSvFNN6MnDi8xwIRw1hgmJ/eg70aokRLd3KBrvm8=
=TFIO
-----END PGP SIGNATURE-----

--3wd1CRtMeCjI53mC--
