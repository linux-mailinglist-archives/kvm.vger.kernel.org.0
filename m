Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF62A3982F4
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhFBHbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 03:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhFBHbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 03:31:02 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2858DC061574;
        Wed,  2 Jun 2021 00:29:18 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fw0yh1dWlz9sT6; Wed,  2 Jun 2021 17:29:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622618956;
        bh=WkghBk3sWr/G7PUSSX6LHGTw3eQf5ZrEkkgeZbHv8vA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H6jkNjaC6+QhJXJQOysoB6szUHSLao71jEWPXtYx/qDcolXVxlk/dD/GFsTqL4ksd
         8ScLDxdpdS1nxnRZpp9t0pQIHj33oK5IBkuYpZGyIcgwuRZnt+NTCOda9Cv7IM8c59
         nGRjnQOhxEBp8sBbWjn4oyvF4DUTbEFbS8Hnzyj4=
Date:   Wed, 2 Jun 2021 16:15:07 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YLch6zbbYqV4PyVf@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Z+d6l3b+qmRmGdjE"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Z+d6l3b+qmRmGdjE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> /dev/ioasid provides an unified interface for managing I/O page tables fo=
r=20
> devices assigned to userspace. Device passthrough frameworks (VFIO, vDPA,=
=20
> etc.) are expected to use this interface instead of creating their own lo=
gic to=20
> isolate untrusted device DMAs initiated by userspace.=20
>=20
> This proposal describes the uAPI of /dev/ioasid and also sample sequences=
=20
> with VFIO as example in typical usages. The driver-facing kernel API prov=
ided=20
> by the iommu layer is still TBD, which can be discussed after consensus i=
s=20
> made on this uAPI.
>=20
> It's based on a lengthy discussion starting from here:
> 	https://lore.kernel.org/linux-iommu/20210330132830.GO2356281@nvidia.com/=
=20
>=20
> It ends up to be a long writing due to many things to be summarized and
> non-trivial effort required to connect them into a complete proposal.
> Hope it provides a clean base to converge.

Thanks for the writeup.  I'm giving this a first pass review, note
that I haven't read all the existing replies in detail yet.

>=20
> TOC
> =3D=3D=3D=3D
> 1. Terminologies and Concepts
> 2. uAPI Proposal
>     2.1. /dev/ioasid uAPI
>     2.2. /dev/vfio uAPI
>     2.3. /dev/kvm uAPI
> 3. Sample structures and helper functions
> 4. PASID virtualization
> 5. Use Cases and Flows
>     5.1. A simple example
>     5.2. Multiple IOASIDs (no nesting)
>     5.3. IOASID nesting (software)
>     5.4. IOASID nesting (hardware)
>     5.5. Guest SVA (vSVA)
>     5.6. I/O page fault
>     5.7. BIND_PASID_TABLE
> =3D=3D=3D=3D
>=20
> 1. Terminologies and Concepts
> -----------------------------------------
>=20
> IOASID FD is the container holding multiple I/O address spaces. User=20
> manages those address spaces through FD operations. Multiple FD's are=20
> allowed per process, but with this proposal one FD should be sufficient f=
or=20
> all intended usages.
>=20
> IOASID is the FD-local software handle representing an I/O address space.=
=20
> Each IOASID is associated with a single I/O page table. IOASIDs can be=20
> nested together, implying the output address from one I/O page table=20
> (represented by child IOASID) must be further translated by another I/O=
=20
> page table (represented by parent IOASID).

Is there a compelling reason to have all the IOASIDs handled by one
FD?  Simply on the grounds that handles to kernel internal objects are
usualy fds, having an fd per ioasid seems like an obvious alternative.
In that case plain open() would replace IOASID_ALLOC.  Nested could be
handled either by 1) having a CREATED_NESTED on the parent fd which
spawns a new fd or 2) opening /dev/ioasid again for a new fd and doing
a SET_PARENT before doing anything else.

I may be bikeshedding here..

> I/O address space can be managed through two protocols, according to=20
> whether the corresponding I/O page table is constructed by the kernel or=
=20
> the user. When kernel-managed, a dma mapping protocol (similar to=20
> existing VFIO iommu type1) is provided for the user to explicitly specify=
=20
> how the I/O address space is mapped. Otherwise, a different protocol is=
=20
> provided for the user to bind an user-managed I/O page table to the=20
> IOMMU, plus necessary commands for iotlb invalidation and I/O fault=20
> handling.=20
>=20
> Pgtable binding protocol can be used only on the child IOASID's, implying=
=20
> IOASID nesting must be enabled. This is because the kernel doesn't trust=
=20
> userspace. Nesting allows the kernel to enforce its DMA isolation policy=
=20
> through the parent IOASID.

To clarify, I'm guessing that's a restriction of likely practice,
rather than a fundamental API restriction.  I can see a couple of
theoretical future cases where a user-managed pagetable for a "base"
IOASID would be feasible:

  1) On some fancy future MMU allowing free nesting, where the kernel
     would insert an implicit extra layer translating user addresses
     to physical addresses, and the userspace manages a pagetable with
     its own VAs being the target AS
  2) For a purely software virtual device, where its virtual DMA
     engine can interpet user addresses fine

> IOASID nesting can be implemented in two ways: hardware nesting and
> software nesting. With hardware support the child and parent I/O page=20
> tables are walked consecutively by the IOMMU to form a nested translation=
=2E=20
> When it's implemented in software, the ioasid driver is responsible for=
=20
> merging the two-level mappings into a single-level shadow I/O page table.=
=20
> Software nesting requires both child/parent page tables operated through=
=20
> the dma mapping protocol, so any change in either level can be captured=
=20
> by the kernel to update the corresponding shadow mapping.

As Jason also said, I don't think you need to restrict software
nesting to only kernel managed L2 tables - you already need hooks for
cache invalidation, and you can use those to trigger reshadows.

> An I/O address space takes effect in the IOMMU only after it is attached=
=20
> to a device. The device in the /dev/ioasid context always refers to a=20
> physical one or 'pdev' (PF or VF).=20

What you mean by "physical" device here isn't really clear - VFs
aren't really physical devices, and the PF/VF terminology also doesn't
extent to non-PCI devices (which I think we want to consider for the
API, even if we're not implemenenting it any time soon).

Now, it's clear that we can't program things into the IOMMU before
attaching a device - we might not even know which IOMMU to use.
However, I'm not sure if its wise to automatically make the AS "real"
as soon as we attach a device:

 * If we're going to attach a whole bunch of devices, could we (for at
   least some IOMMU models) end up doing a lot of work which then has
   to be re-done for each extra device we attach?
  =20
 * With kernel managed IO page tables could attaching a second device
   (at least on some IOMMU models) require some operation which would
   require discarding those tables?  e.g. if the second device somehow
   forces a different IO page size

For that reason I wonder if we want some sort of explicit enable or
activate call.  Device attaches would only be valid before, map or
attach pagetable calls would only be valid after.

> One I/O address space could be attached to multiple devices. In this case=
,=20
> /dev/ioasid uAPI applies to all attached devices under the specified IOAS=
ID.
>=20
> Based on the underlying IOMMU capability one device might be allowed=20
> to attach to multiple I/O address spaces, with DMAs accessing them by=20
> carrying different routing information. One of them is the default I/O=20
> address space routed by PCI Requestor ID (RID) or ARM Stream ID. The=20
> remaining are routed by RID + Process Address Space ID (PASID) or=20
> Stream+Substream ID. For simplicity the following context uses RID and
> PASID when talking about the routing information for I/O address spaces.

I'm not really clear on how this interacts with nested ioasids.  Would
you generally expect the RID+PASID IOASes to be children of the base
RID IOAS, or not?

If the PASID ASes are children of the RID AS, can we consider this not
as the device explicitly attaching to multiple IOASIDs, but instead
attaching to the parent IOASID with awareness of the child ones?

> Device attachment is initiated through passthrough framework uAPI (use
> VFIO for simplicity in following context). VFIO is responsible for identi=
fying=20
> the routing information and registering it to the ioasid driver when call=
ing=20
> ioasid attach helper function. It could be RID if the assigned device is=
=20
> pdev (PF/VF) or RID+PASID if the device is mediated (mdev). In addition,=
=20
> user might also provide its view of virtual routing information (vPASID) =
in=20
> the attach call, e.g. when multiple user-managed I/O address spaces are=
=20
> attached to the vfio_device. In this case VFIO must figure out whether=20
> vPASID should be directly used (for pdev) or converted to a kernel-
> allocated one (pPASID, for mdev) for physical routing (see section 4).
>=20
> Device must be bound to an IOASID FD before attach operation can be
> conducted. This is also through VFIO uAPI. In this proposal one device=20
> should not be bound to multiple FD's. Not sure about the gain of=20
> allowing it except adding unnecessary complexity. But if others have=20
> different view we can further discuss.
>=20
> VFIO must ensure its device composes DMAs with the routing information
> attached to the IOASID. For pdev it naturally happens since vPASID is=20
> directly programmed to the device by guest software. For mdev this=20
> implies any guest operation carrying a vPASID on this device must be=20
> trapped into VFIO and then converted to pPASID before sent to the=20
> device. A detail explanation about PASID virtualization policies can be=
=20
> found in section 4.=20
>=20
> Modern devices may support a scalable workload submission interface=20
> based on PCI DMWr capability, allowing a single work queue to access
> multiple I/O address spaces. One example is Intel ENQCMD, having=20
> PASID saved in the CPU MSR and carried in the instruction payload=20
> when sent out to the device. Then a single work queue shared by=20
> multiple processes can compose DMAs carrying different PASIDs.=20

Is the assumption here that the processes share the IOASID FD
instance, but not memory?

> When executing ENQCMD in the guest, the CPU MSR includes a vPASID=20
> which, if targeting a mdev, must be converted to pPASID before sent
> to the wire. Intel CPU provides a hardware PASID translation capability=
=20
> for auto-conversion in the fast path. The user is expected to setup the=
=20
> PASID mapping through KVM uAPI, with information about {vpasid,=20
> ioasid_fd, ioasid}. The ioasid driver provides helper function for KVM=20
> to figure out the actual pPASID given an IOASID.
>=20
> With above design /dev/ioasid uAPI is all about I/O address spaces.=20
> It doesn't include any device routing information, which is only=20
> indirectly registered to the ioasid driver through VFIO uAPI. For=20
> example, I/O page fault is always reported to userspace per IOASID,=20
> although it's physically reported per device (RID+PASID). If there is a=
=20
> need of further relaying this fault into the guest, the user is responsib=
le=20
> of identifying the device attached to this IOASID (randomly pick one if=
=20
> multiple attached devices) and then generates a per-device virtual I/O=20
> page fault into guest. Similarly the iotlb invalidation uAPI describes th=
e=20
> granularity in the I/O address space (all, or a range), different from th=
e=20
> underlying IOMMU semantics (domain-wide, PASID-wide, range-based).
>=20
> I/O page tables routed through PASID are installed in a per-RID PASID=20
> table structure. Some platforms implement the PASID table in the guest=20
> physical space (GPA), expecting it managed by the guest. The guest
> PASID table is bound to the IOMMU also by attaching to an IOASID,=20
> representing the per-RID vPASID space.

Do we need to consider two management modes here, much as we have for
the pagetables themsleves: either kernel managed, in which we have
explicit calls to bind a vPASID to a parent PASID, or user managed in
which case we register a table in some format.

> We propose the host kernel needs to explicitly track  guest I/O page=20
> tables even on these platforms, i.e. the same pgtable binding protocol=20
> should be used universally on all platforms (with only difference on who=
=20
> actually writes the PASID table). One opinion from previous discussion=20
> was treating this special IOASID as a container for all guest I/O page=20
> tables i.e. hiding them from the host. However this way significantly=20
> violates the philosophy in this /dev/ioasid proposal. It is not one IOASI=
D=20
> one address space any more. Device routing information (indirectly=20
> marking hidden I/O spaces) has to be carried in iotlb invalidation and=20
> page faulting uAPI to help connect vIOMMU with the underlying=20
> pIOMMU. This is one design choice to be confirmed with ARM guys.
>=20
> Devices may sit behind IOMMU's with incompatible capabilities. The
> difference may lie in the I/O page table format, or availability of an us=
er
> visible uAPI (e.g. hardware nesting). /dev/ioasid is responsible for=20
> checking the incompatibility between newly-attached device and existing
> devices under the specific IOASID and, if found, returning error to user.
> Upon such error the user should create a new IOASID for the incompatible
> device.=20
>=20
> There is no explicit group enforcement in /dev/ioasid uAPI, due to no=20
> device notation in this interface as aforementioned. But the ioasid drive=
r=20
> does implicit check to make sure that devices within an iommu group=20
> must be all attached to the same IOASID before this IOASID starts to
> accept any uAPI command. Otherwise error information is returned to=20
> the user.

An explicit ENABLE call might make this checking simpler.

> There was a long debate in previous discussion whether VFIO should keep=
=20
> explicit container/group semantics in its uAPI. Jason Gunthorpe proposes=
=20
> a simplified model where every device bound to VFIO is explicitly listed=
=20
> under /dev/vfio thus a device fd can be acquired w/o going through legacy
> container/group interface. In this case the user is responsible for=20
> understanding the group topology and meeting the implicit group check=20
> criteria enforced in /dev/ioasid. The use case examples in this proposal=
=20
> are based on the new model.
>=20
> Of course for backward compatibility VFIO still needs to keep the existin=
g=20
> uAPI and vfio iommu type1 will become a shim layer connecting VFIO=20
> iommu ops to internal ioasid helper functions.
>=20
> Notes:
> -   It might be confusing as IOASID is also used in the kernel (drivers/
>     iommu/ioasid.c) to represent PCI PASID or ARM substream ID. We need
>     find a better name later to differentiate.
>=20
> -   PPC has not be considered yet as we haven't got time to fully underst=
and
>     its semantics. According to previous discussion there is some general=
ity=20
>     between PPC window-based scheme and VFIO type1 semantics. Let's=20
>     first make consensus on this proposal and then further discuss how to=
=20
>     extend it to cover PPC's requirement.

=46rom what I've seen so far, it seems ok to me.  Note that at this
stage I'm only familiar with existing PPC IOMMUs, which don't have
PASID or anything similar.  I'm not sure what IBM's future plans are
for IOMMUs, so there will be more checking to be done.

> -   There is a protocol between vfio group and kvm. Needs to think about
>     how it will be affected following this proposal.

I think that's only used on PPC, as an optimization for PAPR's
paravirt IOMMU with a small default IOVA window.  I think we can do
something equivalent for IOASIDs from what I've seen so far.

> -   mdev in this context refers to mediated subfunctions (e.g. Intel SIOV=
)=20
>     which can be physically isolated in-between through PASID-granular
>     IOMMU protection. Historically people also discussed one usage by=20
>     mediating a pdev into a mdev. This usage is not covered here, and is=
=20
>     supposed to be replaced by Max's work which allows overriding various=
=20
>     VFIO operations in vfio-pci driver.

I think there are a couple of different mdev cases, so we'll need to
be careful of that and clarify our terminology a bit, I think.

> 2. uAPI Proposal
> ----------------------
>=20
> /dev/ioasid uAPI covers everything about managing I/O address spaces.
>=20
> /dev/vfio uAPI builds connection between devices and I/O address spaces.
>=20
> /dev/kvm uAPI is optional required as far as ENQCMD is concerned.
>=20
>=20
> 2.1. /dev/ioasid uAPI
> +++++++++++++++++
>=20
> /*
>   * Check whether an uAPI extension is supported.=20
>   *
>   * This is for FD-level capabilities, such as locked page pre-registrati=
on.=20
>   * IOASID-level capabilities are reported through IOASID_GET_INFO.
>   *
>   * Return: 0 if not supported, 1 if supported.
>   */
> #define IOASID_CHECK_EXTENSION	_IO(IOASID_TYPE, IOASID_BASE + 0)
>=20
>=20
> /*
>   * Register user space memory where DMA is allowed.
>   *
>   * It pins user pages and does the locked memory accounting so sub-
>   * sequent IOASID_MAP/UNMAP_DMA calls get faster.
>   *
>   * When this ioctl is not used, one user page might be accounted
>   * multiple times when it is mapped by multiple IOASIDs which are
>   * not nested together.
>   *
>   * Input parameters:
>   *	- vaddr;
>   *	- size;
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_REGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 1)
> #define IOASID_UNREGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 2)

AIUI PPC is the main user of the current pre-registration API, though
it could have value in any vIOMMU case to avoid possibly costly
accounting on every guest map/unmap.

I wonder if there's a way to model this using a nested AS rather than
requiring special operations.  e.g.

	'prereg' IOAS
	|
	\- 'rid' IOAS
	   |
	   \- 'pasid' IOAS (maybe)

'prereg' would have a kernel managed pagetable into which (for
example) qemu platform code would map all guest memory (using
IOASID_MAP_DMA).  qemu's vIOMMU driver would then mirror the guest's
IO mappings into the 'rid' IOAS in terms of GPA.

This wouldn't quite work as is, because the 'prereg' IOAS would have
no devices.  But we could potentially have another call to mark an
IOAS as a purely "preregistration" or pure virtual IOAS.  Using that
would be an alternative to attaching devices.

> /*
>   * Allocate an IOASID.=20
>   *
>   * IOASID is the FD-local software handle representing an I/O address=20
>   * space. Each IOASID is associated with a single I/O page table. User=
=20
>   * must call this ioctl to get an IOASID for every I/O address space tha=
t is
>   * intended to be enabled in the IOMMU.
>   *
>   * A newly-created IOASID doesn't accept any command before it is=20
>   * attached to a device. Once attached, an empty I/O page table is=20
>   * bound with the IOMMU then the user could use either DMA mapping=20
>   * or pgtable binding commands to manage this I/O page table.
>   *
>   * Device attachment is initiated through device driver uAPI (e.g. VFIO)
>   *
>   * Return: allocated ioasid on success, -errno on failure.
>   */
> #define IOASID_ALLOC	_IO(IOASID_TYPE, IOASID_BASE + 3)
> #define IOASID_FREE	_IO(IOASID_TYPE, IOASID_BASE + 4)
>=20
>=20
> /*
>   * Get information about an I/O address space
>   *
>   * Supported capabilities:
>   *	- VFIO type1 map/unmap;
>   *	- pgtable/pasid_table binding
>   *	- hardware nesting vs. software nesting;
>   *	- ...
>   *
>   * Related attributes:
>   * 	- supported page sizes, reserved IOVA ranges (DMA mapping);

Can I request we represent this in terms of permitted IOVA ranges,
rather than reserved IOVA ranges.  This works better with the "window"
model I have in mind for unifying the restrictions of the POWER IOMMU
with Type1 like mapping.

>   *	- vendor pgtable formats (pgtable binding);
>   *	- number of child IOASIDs (nesting);
>   *	- ...
>   *
>   * Above information is available only after one or more devices are
>   * attached to the specified IOASID. Otherwise the IOASID is just a
>   * number w/o any capability or attribute.
>   *
>   * Input parameters:
>   *	- u32 ioasid;
>   *
>   * Output parameters:
>   *	- many. TBD.
>   */
> #define IOASID_GET_INFO	_IO(IOASID_TYPE, IOASID_BASE + 5)
>=20
>=20
> /*
>   * Map/unmap process virtual addresses to I/O virtual addresses.
>   *
>   * Provide VFIO type1 equivalent semantics. Start with the same=20
>   * restriction e.g. the unmap size should match those used in the=20
>   * original mapping call.=20
>   *
>   * If IOASID_REGISTER_MEMORY has been called, the mapped vaddr
>   * must be already in the preregistered list.
>   *
>   * Input parameters:
>   *	- u32 ioasid;
>   *	- refer to vfio_iommu_type1_dma_{un}map
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)

I'm assuming these would be expected to fail if a user managed
pagetable has been bound?

> /*
>   * Create a nesting IOASID (child) on an existing IOASID (parent)
>   *
>   * IOASIDs can be nested together, implying that the output address=20
>   * from one I/O page table (child) must be further translated by=20
>   * another I/O page table (parent).
>   *
>   * As the child adds essentially another reference to the I/O page table=
=20
>   * represented by the parent, any device attached to the child ioasid=20
>   * must be already attached to the parent.
>   *
>   * In concept there is no limit on the number of the nesting levels.=20
>   * However for the majority case one nesting level is sufficient. The
>   * user should check whether an IOASID supports nesting through=20
>   * IOASID_GET_INFO. For example, if only one nesting level is allowed,
>   * the nesting capability is reported only on the parent instead of the
>   * child.
>   *
>   * User also needs check (via IOASID_GET_INFO) whether the nesting=20
>   * is implemented in hardware or software. If software-based, DMA=20
>   * mapping protocol should be used on the child IOASID. Otherwise,=20
>   * the child should be operated with pgtable binding protocol.
>   *
>   * Input parameters:
>   *	- u32 parent_ioasid;
>   *
>   * Return: child_ioasid on success, -errno on failure;
>   */
> #define IOASID_CREATE_NESTING	_IO(IOASID_TYPE, IOASID_BASE + 8)
>=20
>=20
> /*
>   * Bind an user-managed I/O page table with the IOMMU
>   *
>   * Because user page table is untrusted, IOASID nesting must be enabled=
=20
>   * for this ioasid so the kernel can enforce its DMA isolation policy=20
>   * through the parent ioasid.
>   *
>   * Pgtable binding protocol is different from DMA mapping. The latter=20
>   * has the I/O page table constructed by the kernel and updated=20
>   * according to user MAP/UNMAP commands. With pgtable binding the=20
>   * whole page table is created and updated by userspace, thus different=
=20
>   * set of commands are required (bind, iotlb invalidation, page fault, e=
tc.).
>   *
>   * Because the page table is directly walked by the IOMMU, the user=20
>   * must  use a format compatible to the underlying hardware. It can=20
>   * check the format information through IOASID_GET_INFO.
>   *
>   * The page table is bound to the IOMMU according to the routing=20
>   * information of each attached device under the specified IOASID. The
>   * routing information (RID and optional PASID) is registered when a=20
>   * device is attached to this IOASID through VFIO uAPI.=20
>   *
>   * Input parameters:
>   *	- child_ioasid;
>   *	- address of the user page table;
>   *	- formats (vendor, address_width, etc.);
>   *=20
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
> #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)

I'm assuming that UNBIND would return the IOASID to a kernel-managed
pagetable?

For debugging and certain hypervisor edge cases it might be useful to
have a call to allow userspace to lookup and specific IOVA in a guest
managed pgtable.


> /*
>   * Bind an user-managed PASID table to the IOMMU
>   *
>   * This is required for platforms which place PASID table in the GPA spa=
ce.
>   * In this case the specified IOASID represents the per-RID PASID space.
>   *
>   * Alternatively this may be replaced by IOASID_BIND_PGTABLE plus a
>   * special flag to indicate the difference from normal I/O address space=
s.
>   *
>   * The format info of the PASID table is reported in IOASID_GET_INFO.
>   *
>   * As explained in the design section, user-managed I/O page tables must
>   * be explicitly bound to the kernel even on these platforms. It allows
>   * the kernel to uniformly manage I/O address spaces cross all platforms.
>   * Otherwise, the iotlb invalidation and page faulting uAPI must be hack=
ed
>   * to carry device routing information to indirectly mark the hidden I/O
>   * address spaces.
>   *
>   * Input parameters:
>   *	- child_ioasid;

Wouldn't this be the parent ioasid, rather than one of the potentially
many child ioasids?

>   *	- address of PASID table;
>   *	- formats (vendor, size, etc.);
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define IOASID_BIND_PASID_TABLE	_IO(IOASID_TYPE, IOASID_BASE + 11)
> #define IOASID_UNBIND_PASID_TABLE	_IO(IOASID_TYPE, IOASID_BASE + 12)
>=20
>=20
> /*
>   * Invalidate IOTLB for an user-managed I/O page table
>   *
>   * Unlike what's defined in include/uapi/linux/iommu.h, this command=20
>   * doesn't allow the user to specify cache type and likely support only
>   * two granularities (all, or a specified range) in the I/O address spac=
e.
>   *
>   * Physical IOMMU have three cache types (iotlb, dev_iotlb and pasid
>   * cache). If the IOASID represents an I/O address space, the invalidati=
on
>   * always applies to the iotlb (and dev_iotlb if enabled). If the IOASID
>   * represents a vPASID space, then this command applies to the PASID
>   * cache.
>   *
>   * Similarly this command doesn't provide IOMMU-like granularity
>   * info (domain-wide, pasid-wide, range-based), since it's all about the
>   * I/O address space itself. The ioasid driver walks the attached
>   * routing information to match the IOMMU semantics under the
>   * hood.=20
>   *
>   * Input parameters:
>   *	- child_ioasid;

And couldn't this be be any ioasid, not just a child one, depending on
whether you want PASID scope or RID scope invalidation?

>   *	- granularity
>   *=20
>   * Return: 0 on success, -errno on failure
>   */
> #define IOASID_INVALIDATE_CACHE	_IO(IOASID_TYPE, IOASID_BASE + 13)
>=20
>=20
> /*
>   * Page fault report and response
>   *
>   * This is TBD. Can be added after other parts are cleared up. Likely it=
=20
>   * will be a ring buffer shared between user/kernel, an eventfd to notif=
y=20
>   * the user and an ioctl to complete the fault.
>   *
>   * The fault data is per I/O address space, i.e.: IOASID + faulting_addr
>   */
>=20
>=20
> /*
>   * Dirty page tracking=20
>   *
>   * Track and report memory pages dirtied in I/O address spaces. There=20
>   * is an ongoing work by Kunkun Jiang by extending existing VFIO type1.=
=20
>   * It needs be adapted to /dev/ioasid later.
>   */
>=20
>=20
> 2.2. /dev/vfio uAPI
> ++++++++++++++++
>=20
> /*
>   * Bind a vfio_device to the specified IOASID fd
>   *
>   * Multiple vfio devices can be bound to a single ioasid_fd, but a singl=
e=20
>   * vfio device should not be bound to multiple ioasid_fd's.=20
>   *
>   * Input parameters:
>   *	- ioasid_fd;
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define VFIO_BIND_IOASID_FD		_IO(VFIO_TYPE, VFIO_BASE + 22)
> #define VFIO_UNBIND_IOASID_FD	_IO(VFIO_TYPE, VFIO_BASE + 23)
>=20
>=20
> /*
>   * Attach a vfio device to the specified IOASID
>   *
>   * Multiple vfio devices can be attached to the same IOASID, and vice=20
>   * versa.=20
>   *
>   * User may optionally provide a "virtual PASID" to mark an I/O page=20
>   * table on this vfio device. Whether the virtual PASID is physically us=
ed=20
>   * or converted to another kernel-allocated PASID is a policy in vfio de=
vice=20
>   * driver.
>   *
>   * There is no need to specify ioasid_fd in this call due to the assumpt=
ion=20
>   * of 1:1 connection between vfio device and the bound fd.
>   *
>   * Input parameter:
>   *	- ioasid;
>   *	- flag;
>   *	- user_pasid (if specified);

Wouldn't the PASID be communicated by whether you give a parent or
child ioasid, rather than needing an extra value?

>   * Return: 0 on success, -errno on failure.
>   */
> #define VFIO_ATTACH_IOASID		_IO(VFIO_TYPE, VFIO_BASE + 24)
> #define VFIO_DETACH_IOASID		_IO(VFIO_TYPE, VFIO_BASE + 25)
>=20
>=20
> 2.3. KVM uAPI
> ++++++++++++
>=20
> /*
>   * Update CPU PASID mapping
>   *
>   * This is necessary when ENQCMD will be used in the guest while the
>   * targeted device doesn't accept the vPASID saved in the CPU MSR.
>   *
>   * This command allows user to set/clear the vPASID->pPASID mapping
>   * in the CPU, by providing the IOASID (and FD) information representing
>   * the I/O address space marked by this vPASID.
>   *
>   * Input parameters:
>   *	- user_pasid;
>   *	- ioasid_fd;
>   *	- ioasid;
>   */
> #define KVM_MAP_PASID	_IO(KVMIO, 0xf0)
> #define KVM_UNMAP_PASID	_IO(KVMIO, 0xf1)
>=20
>=20
> 3. Sample structures and helper functions
> --------------------------------------------------------
>=20
> Three helper functions are provided to support VFIO_BIND_IOASID_FD:
>=20
> 	struct ioasid_ctx *ioasid_ctx_fdget(int fd);
> 	int ioasid_register_device(struct ioasid_ctx *ctx, struct ioasid_dev *de=
v);
> 	int ioasid_unregister_device(struct ioasid_dev *dev);
>=20
> An ioasid_ctx is created for each fd:
>=20
> 	struct ioasid_ctx {
> 		// a list of allocated IOASID data's
> 		struct list_head		ioasid_list;
> 		// a list of registered devices
> 		struct list_head		dev_list;
> 		// a list of pre-registered virtual address ranges
> 		struct list_head		prereg_list;
> 	};
>=20
> Each registered device is represented by ioasid_dev:
>=20
> 	struct ioasid_dev {
> 		struct list_head		next;
> 		struct ioasid_ctx	*ctx;
> 		// always be the physical device

Again "physical" isn't really clearly defined here.

> 		struct device 		*device;
> 		struct kref		kref;
> 	};
>=20
> Because we assume one vfio_device connected to at most one ioasid_fd,=20
> here ioasid_dev could be embedded in vfio_device and then linked to=20
> ioasid_ctx->dev_list when registration succeeds. For mdev the struct
> device should be the pointer to the parent device. PASID marking this
> mdev is specified later when VFIO_ATTACH_IOASID.
>=20
> An ioasid_data is created when IOASID_ALLOC, as the main object=20
> describing characteristics about an I/O page table:
>=20
> 	struct ioasid_data {
> 		// link to ioasid_ctx->ioasid_list
> 		struct list_head		next;
>=20
> 		// the IOASID number
> 		u32			ioasid;
>=20
> 		// the handle to convey iommu operations
> 		// hold the pgd (TBD until discussing iommu api)
> 		struct iommu_domain *domain;
>=20
> 		// map metadata (vfio type1 semantics)
> 		struct rb_node		dma_list;

Why do you need this?  Can't you just store the kernel managed
mappings in the host IO pgtable?

> 		// pointer to user-managed pgtable (for nesting case)
> 		u64			user_pgd;

> 		// link to the parent ioasid (for nesting)
> 		struct ioasid_data	*parent;
>=20
> 		// cache the global PASID shared by ENQCMD-capable
> 		// devices (see below explanation in section 4)
> 		u32			pasid;
>=20
> 		// a list of device attach data (routing information)
> 		struct list_head		attach_data;
>=20
> 		// a list of partially-attached devices (group)
> 		struct list_head		partial_devices;
>=20
> 		// a list of fault_data reported from the iommu layer
> 		struct list_head		fault_data;
>=20
> 		...
> 	}
>=20
> ioasid_data and iommu_domain have overlapping roles as both are=20
> introduced to represent an I/O address space. It is still a big TBD how=
=20
> the two should be corelated or even merged, and whether new iommu=20
> ops are required to handle RID+PASID explicitly. We leave this as open=20
> for now as this proposal is mainly about uAPI. For simplification=20
> purpose the two objects are kept separate in this context, assuming an=20
> 1:1 connection in-between and the domain as the place-holder=20
> representing the 1st class object in the iommu ops.=20
>=20
> Two helper functions are provided to support VFIO_ATTACH_IOASID:
>=20
> 	struct attach_info {
> 		u32	ioasid;
> 		// If valid, the PASID to be used physically
> 		u32	pasid;

Again shouldn't the choice of a parent or child ioasid inform whether
there is a pasid, and if so which one?

> 	};
> 	int ioasid_device_attach(struct ioasid_dev *dev,=20
> 		struct attach_info info);
> 	int ioasid_device_detach(struct ioasid_dev *dev, u32 ioasid);
>=20
> The pasid parameter is optionally provided based on the policy in vfio
> device driver. It could be the PASID marking the default I/O address=20
> space for a mdev, or the user-provided PASID marking an user I/O page
> table, or another kernel-allocated PASID backing the user-provided one.
> Please check next section for detail explanation.
>=20
> A new object is introduced and linked to ioasid_data->attach_data for=20
> each successful attach operation:
>=20
> 	struct ioasid_attach_data {
> 		struct list_head		next;
> 		struct ioasid_dev	*dev;
> 		u32 			pasid;
> 	}
>=20
> As explained in the design section, there is no explicit group enforcement
> in /dev/ioasid uAPI or helper functions. But the ioasid driver does
> implicit group check - before every device within an iommu group is=20
> attached to this IOASID, the previously-attached devices in this group are
> put in ioasid_data->partial_devices. The IOASID rejects any command if
> the partial_devices list is not empty.
>=20
> Then is the last helper function:
> 	u32 ioasid_get_global_pasid(struct ioasid_ctx *ctx,=20
> 		u32 ioasid, bool alloc);
>=20
> ioasid_get_global_pasid is necessary in scenarios where multiple devices=
=20
> want to share a same PASID value on the attached I/O page table (e.g.=20
> when ENQCMD is enabled, as explained in next section). We need a=20
> centralized place (ioasid_data->pasid) to hold this value (allocated when
> first called with alloc=3Dtrue). vfio device driver calls this function (=
alloc=3D
> true) to get the global PASID for an ioasid before calling ioasid_device_
> attach. KVM also calls this function (alloc=3Dfalse) to setup PASID trans=
lation=20
> structure when user calls KVM_MAP_PASID.
>=20
> 4. PASID Virtualization
> ------------------------------
>=20
> When guest SVA (vSVA) is enabled, multiple GVA address spaces are=20
> created on the assigned vfio device. This leads to the concepts of=20
> "virtual PASID" (vPASID) vs. "physical PASID" (pPASID). vPASID is assigne=
d=20
> by the guest to mark an GVA address space while pPASID is the one=20
> selected by the host and actually routed in the wire.
>=20
> vPASID is conveyed to the kernel when user calls VFIO_ATTACH_IOASID.
>=20
> vfio device driver translates vPASID to pPASID before calling ioasid_atta=
ch_
> device, with two factors to be considered:
>=20
> -    Whether vPASID is directly used (vPASID=3D=3DpPASID) in the wire, or=
=20
>      should be instead converted to a newly-allocated one (vPASID!=3D
>      pPASID);
>=20
> -    If vPASID!=3DpPASID, whether pPASID is allocated from per-RID PASID
>      space or a global PASID space (implying sharing pPASID cross devices,
>      e.g. when supporting Intel ENQCMD which puts PASID in a CPU MSR
>      as part of the process context);
>=20
> The actual policy depends on pdev vs. mdev, and whether ENQCMD is
> supported. There are three possible scenarios:
>=20
> (Note: /dev/ioasid uAPI is not affected by underlying PASID virtualizatio=
n=20
> policies.)
>=20
> 1)  pdev (w/ or w/o ENQCMD): vPASID=3D=3DpPASID
>=20
>      vPASIDs are directly programmed by the guest to the assigned MMIO=20
>      bar, implying all DMAs out of this device having vPASID in the packe=
t=20
>      header. This mandates vPASID=3D=3DpPASID, sort of delegating the ent=
ire=20
>      per-RID PASID space to the guest.
>=20
>      When ENQCMD is enabled, the CPU MSR when running a guest task
>      contains a vPASID. In this case the CPU PASID translation capability=
=20
>      should be disabled so this vPASID in CPU MSR is directly sent to the
>      wire.
>=20
>      This ensures consistent vPASID usage on pdev regardless of the=20
>      workload submitted through a MMIO register or ENQCMD instruction.
>=20
> 2)  mdev: vPASID!=3DpPASID (per-RID if w/o ENQCMD, otherwise global)
>=20
>      PASIDs are also used by kernel to mark the default I/O address space=
=20
>      for mdev, thus cannot be delegated to the guest. Instead, the mdev=
=20
>      driver must allocate a new pPASID for each vPASID (thus vPASID!=3D
>      pPASID) and then use pPASID when attaching this mdev to an ioasid.
>=20
>      The mdev driver needs cache the PASID mapping so in mediation=20
>      path vPASID programmed by the guest can be converted to pPASID=20
>      before updating the physical MMIO register. The mapping should
>      also be saved in the CPU PASID translation structure (via KVM uAPI),=
=20
>      so the vPASID saved in the CPU MSR is auto-translated to pPASID=20
>      before sent to the wire, when ENQCMD is enabled.=20
>=20
>      Generally pPASID could be allocated from the per-RID PASID space
>      if all mdev's created on the parent device don't support ENQCMD.
>=20
>      However if the parent supports ENQCMD-capable mdev, pPASIDs
>      must be allocated from a global pool because the CPU PASID=20
>      translation structure is per-VM. It implies that when an guest I/O=
=20
>      page table is attached to two mdevs with a single vPASID (i.e. bind=
=20
>      to the same guest process), a same pPASID should be used for=20
>      both mdevs even when they belong to different parents. Sharing
>      pPASID cross mdevs is achieved by calling aforementioned ioasid_
>      get_global_pasid().
>=20
> 3)  Mix pdev/mdev together
>=20
>      Above policies are per device type thus are not affected when mixing=
=20
>      those device types together (when assigned to a single guest). Howev=
er,=20
>      there is one exception - when both pdev/mdev support ENQCMD.
>=20
>      Remember the two types have conflicting requirements on whether=20
>      CPU PASID translation should be enabled. This capability is per-VM,=
=20
>      and must be enabled for mdev isolation. When enabled, pdev will=20
>      receive a mdev pPASID violating its vPASID expectation.
>=20
>      In previous thread a PASID range split scheme was discussed to suppo=
rt
>      this combination, but we haven't worked out a clean uAPI design yet.
>      Therefore in this proposal we decide to not support it, implying the=
=20
>      user should have some intelligence to avoid such scenario. It could =
be
>      a TODO task for future.
>=20
> In spite of those subtle considerations, the kernel implementation could
> start simple, e.g.:
>=20
> -    v=3D=3Dp for pdev;
> -    v!=3Dp and always use a global PASID pool for all mdev's;
>=20
> Regardless of the kernel policy, the user policy is unchanged:
>=20
> -    provide vPASID when calling VFIO_ATTACH_IOASID;
> -    call KVM uAPI to setup CPU PASID translation if ENQCMD-capable mdev;
> -    Don't expose ENQCMD capability on both pdev and mdev;
>=20
> Sample user flow is described in section 5.5.
>=20
> 5. Use Cases and Flows
> -------------------------------
>=20
> Here assume VFIO will support a new model where every bound device
> is explicitly listed under /dev/vfio thus a device fd can be acquired w/o=
=20
> going through legacy container/group interface. For illustration purpose
> those devices are just called dev[1...N]:
>=20
> 	device_fd[1...N] =3D open("/dev/vfio/devices/dev[1...N]", mode);

Minor detail, but I'd suggest /dev/vfio/pci/DDDD:BB:SS.F for the
filenames for actual PCI functions.  Maybe /dev/vfio/mdev/something
for mdevs.  That leaves other subdirs of /dev/vfio free for future
non-PCI device types, and /dev/vfio itself for the legacy group
devices.

> As explained earlier, one IOASID fd is sufficient for all intended use ca=
ses:
>=20
> 	ioasid_fd =3D open("/dev/ioasid", mode);
>=20
> For simplicity below examples are all made for the virtualization story.
> They are representative and could be easily adapted to a non-virtualizati=
on
> scenario.
>=20
> Three types of IOASIDs are considered:
>=20
> 	gpa_ioasid[1...N]: 	for GPA address space
> 	giova_ioasid[1...N]:	for guest IOVA address space
> 	gva_ioasid[1...N]:	for guest CPU VA address space
>=20
> At least one gpa_ioasid must always be created per guest, while the other=
=20
> two are relevant as far as vIOMMU is concerned.
>=20
> Examples here apply to both pdev and mdev, if not explicitly marked out
> (e.g. in section 5.5). VFIO device driver in the kernel will figure out t=
he=20
> associated routing information in the attaching operation.
>=20
> For illustration simplicity, IOASID_CHECK_EXTENSION and IOASID_GET_
> INFO are skipped in these examples.
>=20
> 5.1. A simple example
> ++++++++++++++++++
>=20
> Dev1 is assigned to the guest. One gpa_ioasid is created. The GPA address
> space is managed through DMA mapping protocol:
>=20
> 	/* Bind device to IOASID fd */
> 	device_fd =3D open("/dev/vfio/devices/dev1", mode);
> 	ioasid_fd =3D open("/dev/ioasid", mode);
> 	ioctl(device_fd, VFIO_BIND_IOASID_FD, ioasid_fd);
>=20
> 	/* Attach device to IOASID */
> 	gpa_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
> 	at_data =3D { .ioasid =3D gpa_ioasid};
> 	ioctl(device_fd, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* Setup GPA mapping */
> 	dma_map =3D {
> 		.ioasid	=3D gpa_ioasid;
> 		.iova	=3D 0;		// GPA
> 		.vaddr	=3D 0x40000000;	// HVA
> 		.size	=3D 1GB;
> 	};
> 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
>=20
> If the guest is assigned with more than dev1, user follows above sequence
> to attach other devices to the same gpa_ioasid i.e. sharing the GPA=20
> address space cross all assigned devices.
>=20
> 5.2. Multiple IOASIDs (no nesting)
> ++++++++++++++++++++++++++++
>=20
> Dev1 and dev2 are assigned to the guest. vIOMMU is enabled. Initially
> both devices are attached to gpa_ioasid.

Doesn't really affect your example, but note that the PAPR IOMMU does
not have a passthrough mode, so devices will not initially be attached
to gpa_ioasid - they will be unusable for DMA until attached to a
gIOVA ioasid.

> After boot the guest creates=20
> an GIOVA address space (giova_ioasid) for dev2, leaving dev1 in pass
> through mode (gpa_ioasid).
>=20
> Suppose IOASID nesting is not supported in this case. Qemu need to
> generate shadow mappings in userspace for giova_ioasid (like how
> VFIO works today).
>=20
> To avoid duplicated locked page accounting, it's recommended to pre-
> register the virtual address range that will be used for DMA:
>=20
> 	device_fd1 =3D open("/dev/vfio/devices/dev1", mode);
> 	device_fd2 =3D open("/dev/vfio/devices/dev2", mode);
> 	ioasid_fd =3D open("/dev/ioasid", mode);
> 	ioctl(device_fd1, VFIO_BIND_IOASID_FD, ioasid_fd);
> 	ioctl(device_fd2, VFIO_BIND_IOASID_FD, ioasid_fd);
>=20
> 	/* pre-register the virtual address range for accounting */
> 	mem_info =3D { .vaddr =3D 0x40000000; .size =3D 1GB };
> 	ioctl(ioasid_fd, IOASID_REGISTER_MEMORY, &mem_info);
> 	/* Attach dev1 and dev2 to gpa_ioasid */
> 	gpa_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
> 	at_data =3D { .ioasid =3D gpa_ioasid};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* Setup GPA mapping */
> 	dma_map =3D {
> 		.ioasid	=3D gpa_ioasid;
> 		.iova	=3D 0; 		// GPA
> 		.vaddr	=3D 0x40000000;	// HVA
> 		.size	=3D 1GB;
> 	};
> 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
>=20
> 	/* After boot, guest enables an GIOVA space for dev2 */

Again, doesn't break the example, but this need not happen after guest
boot.  On the PAPR vIOMMU, the guest IOVA spaces (known as "logical IO
bus numbers" / liobns) and which devices are in each are fixed at
guest creation time and advertised to the guest via firmware.

> 	giova_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
>=20
> 	/* First detach dev2 from previous address space */
> 	at_data =3D { .ioasid =3D gpa_ioasid};
> 	ioctl(device_fd2, VFIO_DETACH_IOASID, &at_data);
>=20
> 	/* Then attach dev2 to the new address space */
> 	at_data =3D { .ioasid =3D giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* Setup a shadow DMA mapping according to vIOMMU
> 	  * GIOVA (0x2000) -> GPA (0x1000) -> HVA (0x40001000)
> 	  */
> 	dma_map =3D {
> 		.ioasid	=3D giova_ioasid;
> 		.iova	=3D 0x2000; 	// GIOVA
> 		.vaddr	=3D 0x40001000;	// HVA
> 		.size	=3D 4KB;
> 	};
> 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
>=20
> 5.3. IOASID nesting (software)
> +++++++++++++++++++++++++
>=20
> Same usage scenario as 5.2, with software-based IOASID nesting=20
> available. In this mode it is the kernel instead of user to create the
> shadow mapping.

In this case, I feel like the preregistration is redundant with the
GPA level mapping.  As long as the gIOVA mappings (which might be
frequent) can piggyback on the accounting done for the GPA mapping we
accomplish what we need from preregistration.

> The flow before guest boots is same as 5.2, except one point. Because=20
> giova_ioasid is nested on gpa_ioasid, locked accounting is only=20
> conducted for gpa_ioasid. So it's not necessary to pre-register virtual=
=20
> memory.
>=20
> To save space we only list the steps after boots (i.e. both dev1/dev2
> have been attached to gpa_ioasid before guest boots):
>=20
> 	/* After boots */
> 	/* Make GIOVA space nested on GPA space */
> 	giova_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
>=20
> 	/* Attach dev2 to the new address space (child)
> 	  * Note dev2 is still attached to gpa_ioasid (parent)
> 	  */
> 	at_data =3D { .ioasid =3D giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* Setup a GIOVA->GPA mapping for giova_ioasid, which will be=20
> 	  * merged by the kernel with GPA->HVA mapping of gpa_ioasid
> 	  * to form a shadow mapping.
> 	  */
> 	dma_map =3D {
> 		.ioasid	=3D giova_ioasid;
> 		.iova	=3D 0x2000;	// GIOVA
> 		.vaddr	=3D 0x1000;	// GPA
> 		.size	=3D 4KB;
> 	};
> 	ioctl(ioasid_fd, IOASID_DMA_MAP, &dma_map);
>=20
> 5.4. IOASID nesting (hardware)
> +++++++++++++++++++++++++
>=20
> Same usage scenario as 5.2, with hardware-based IOASID nesting
> available. In this mode the pgtable binding protocol is used to=20
> bind the guest IOVA page table with the IOMMU:
>=20
> 	/* After boots */
> 	/* Make GIOVA space nested on GPA space */
> 	giova_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
>=20
> 	/* Attach dev2 to the new address space (child)
> 	  * Note dev2 is still attached to gpa_ioasid (parent)
> 	  */
> 	at_data =3D { .ioasid =3D giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* Bind guest I/O page table  */
> 	bind_data =3D {
> 		.ioasid	=3D giova_ioasid;
> 		.addr	=3D giova_pgtable;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
>=20
> 	/* Invalidate IOTLB when required */
> 	inv_data =3D {
> 		.ioasid	=3D giova_ioasid;
> 		// granular information
> 	};
> 	ioctl(ioasid_fd, IOASID_INVALIDATE_CACHE, &inv_data);
>=20
> 	/* See 5.6 for I/O page fault handling */
> =09
> 5.5. Guest SVA (vSVA)
> ++++++++++++++++++
>=20
> After boots the guest further create a GVA address spaces (gpasid1) on=20
> dev1. Dev2 is not affected (still attached to giova_ioasid).
>=20
> As explained in section 4, user should avoid expose ENQCMD on both
> pdev and mdev.
>=20
> The sequence applies to all device types (being pdev or mdev), except
> one additional step to call KVM for ENQCMD-capable mdev:
>=20
> 	/* After boots */
> 	/* Make GVA space nested on GPA space */
> 	gva_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);

I'm not clear what gva_ioasid is representing.  Is it representing a
single vPASID's address space, or a whole bunch of vPASIDs address
spaces?

> 	/* Attach dev1 to the new address space and specify vPASID */
> 	at_data =3D {
> 		.ioasid		=3D gva_ioasid;
> 		.flag 		=3D IOASID_ATTACH_USER_PASID;
> 		.user_pasid	=3D gpasid1;
> 	};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* if dev1 is ENQCMD-capable mdev, update CPU PASID=20
> 	  * translation structure through KVM
> 	  */
> 	pa_data =3D {
> 		.ioasid_fd	=3D ioasid_fd;
> 		.ioasid		=3D gva_ioasid;
> 		.guest_pasid	=3D gpasid1;
> 	};
> 	ioctl(kvm_fd, KVM_MAP_PASID, &pa_data);
>=20
> 	/* Bind guest I/O page table  */
> 	bind_data =3D {
> 		.ioasid	=3D gva_ioasid;
> 		.addr	=3D gva_pgtable1;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
>=20
> 	...
>=20
>=20
> 5.6. I/O page fault
> +++++++++++++++
>=20
> (uAPI is TBD. Here is just about the high-level flow from host IOMMU driv=
er
> to guest IOMMU driver and backwards).
>=20
> -   Host IOMMU driver receives a page request with raw fault_data {rid,=
=20
>     pasid, addr};
>=20
> -   Host IOMMU driver identifies the faulting I/O page table according to
>     information registered by IOASID fault handler;
>=20
> -   IOASID fault handler is called with raw fault_data (rid, pasid, addr)=
, which=20
>     is saved in ioasid_data->fault_data (used for response);
>=20
> -   IOASID fault handler generates an user fault_data (ioasid, addr), lin=
ks it=20
>     to the shared ring buffer and triggers eventfd to userspace;
>=20
> -   Upon received event, Qemu needs to find the virtual routing informati=
on=20
>     (v_rid + v_pasid) of the device attached to the faulting ioasid. If t=
here are=20
>     multiple, pick a random one. This should be fine since the purpose is=
 to
>     fix the I/O page table on the guest;
>=20
> -   Qemu generates a virtual I/O page fault through vIOMMU into guest,
>     carrying the virtual fault data (v_rid, v_pasid, addr);
>=20
> -   Guest IOMMU driver fixes up the fault, updates the I/O page table, and
>     then sends a page response with virtual completion data (v_rid, v_pas=
id,=20
>     response_code) to vIOMMU;
>=20
> -   Qemu finds the pending fault event, converts virtual completion data=
=20
>     into (ioasid, response_code), and then calls a /dev/ioasid ioctl to=
=20
>     complete the pending fault;
>=20
> -   /dev/ioasid finds out the pending fault data {rid, pasid, addr} saved=
 in=20
>     ioasid_data->fault_data, and then calls iommu api to complete it with
>     {rid, pasid, response_code};
>=20
> 5.7. BIND_PASID_TABLE
> ++++++++++++++++++++
>=20
> PASID table is put in the GPA space on some platform, thus must be updated
> by the guest. It is treated as another user page table to be bound with t=
he=20
> IOMMU.
>=20
> As explained earlier, the user still needs to explicitly bind every user =
I/O=20
> page table to the kernel so the same pgtable binding protocol (bind, cach=
e=20
> invalidate and fault handling) is unified cross platforms.
>=20
> vIOMMUs may include a caching mode (or paravirtualized way) which, once=
=20
> enabled, requires the guest to invalidate PASID cache for any change on t=
he=20
> PASID table. This allows Qemu to track the lifespan of guest I/O page tab=
les.
>=20
> In case of missing such capability, Qemu could enable write-protection on
> the guest PASID table to achieve the same effect.
>=20
> 	/* After boots */
> 	/* Make vPASID space nested on GPA space */
> 	pasidtbl_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);

I think this time pasidtbl_ioasid is representing multiple vPASID
address spaces, yes?  In which case I don't think it should be treated
as the same sort of object as a normal IOASID, which represents a
single address space IIUC.

> 	/* Attach dev1 to pasidtbl_ioasid */
> 	at_data =3D { .ioasid =3D pasidtbl_ioasid};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* Bind PASID table */
> 	bind_data =3D {
> 		.ioasid	=3D pasidtbl_ioasid;
> 		.addr	=3D gpa_pasid_table;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PASID_TABLE, &bind_data);
>=20
> 	/* vIOMMU detects a new GVA I/O space created */
> 	gva_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> 				gpa_ioasid);
>=20
> 	/* Attach dev1 to the new address space, with gpasid1 */
> 	at_data =3D {
> 		.ioasid		=3D gva_ioasid;
> 		.flag 		=3D IOASID_ATTACH_USER_PASID;
> 		.user_pasid	=3D gpasid1;
> 	};
> 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
>=20
> 	/* Bind guest I/O page table. Because SET_PASID_TABLE has been
> 	  * used, the kernel will not update the PASID table. Instead, just
> 	  * track the bound I/O page table for handling invalidation and
> 	  * I/O page faults.
> 	  */
> 	bind_data =3D {
> 		.ioasid	=3D gva_ioasid;
> 		.addr	=3D gva_pgtable1;
> 		// and format information
> 	};
> 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);

Hrm.. if you still have to individually bind a table for each vPASID,
what's the point of BIND_PASID_TABLE?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Z+d6l3b+qmRmGdjE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC3IekACgkQbDjKyiDZ
s5KCjw//aKus5jyN/lmlJPmFpyv78C381iF9xlc27rErpzeFId3kPAjrV6lNlRUp
n467eArwJtUWkICrnCp5MGv3WjfdSYn+jwChADIVAqbeqnm1ArF/86wSqxkaqTfR
TWOz0Kn+NFElEPoi7nNOf/npPVkzWd4EiQYCGdsqzF7R0g53y6QlrlpcVWdloQqp
m9uaOcCNaTkKHWtY/MM9KXKtkmSNYkMedqlyFFJp36qUOFi17EdKMietpODQVT49
homuXMLF7Mi4yw1/LE4uJfd5php4tQXeYQN9fOBcpYa1yc2WTP2maPYW1oVEw9fo
zrwyoUjHlWJiVoBJIXxWISZCVe/53VhfoXC+zrsWhRwUmEUsbzIIGfvKGxUUjLK0
reolXd7e1+8MYM7C/iTK0Czc/ZsQ9JjoJGCqHAB6HW/D9Uyi2NhS4QSxkMMuhjes
zN1EB4bbTVI52+xwEmlvnuN6ENJt+BUHDHj53Z+l1LnrLxc3EDnDKlhfmCoH5yaH
C3YX3t6OH9C7aq9jUtqSwF2X+xV1jsXBBqh3rBWfd7Q6tMRG9EciLPLacSWq/BjR
9OYi+vhbGjzQ8rzujUvHVYZ3ogJk6Mu1C8ZZ0xjclZvPnC9j/XZAq9PhLn1drS+x
sOQayBAnkQfxvoJ4jD6Q+NhZo59kmTD0wcJyPMSkwhmmj46HXpw=
=DQxN
-----END PGP SIGNATURE-----

--Z+d6l3b+qmRmGdjE--
