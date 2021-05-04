Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49780372F58
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhEDSEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 14:04:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231635AbhEDSEu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 14:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620151434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=crIjxSKc9RicXz5uU0iWJNjyfJ75605vwRv4rA88bAc=;
        b=gpHXQycL4j1chUFogkUq3N3XYM51I0LG5ZdwWX48Dko7I3NabRp6/taOl6StPF0HX8x6C5
        XSH7sSZm7qvFLMfppTaOkjF2+mlpSe6pyKJrVzhb5u8HomiNge0XTT1ZE5B7Dir4tc6MKo
        O8Gr3kxW2y6wLmNaY0/qiEoM7lQJuWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-UeGCIxtyO5OSuVhwk3SZ8A-1; Tue, 04 May 2021 14:03:51 -0400
X-MC-Unique: UeGCIxtyO5OSuVhwk3SZ8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE4AA107ACED;
        Tue,  4 May 2021 18:03:49 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F9921002388;
        Tue,  4 May 2021 18:03:49 +0000 (UTC)
Date:   Tue, 4 May 2021 12:03:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Vikram Sethi <vsethi@nvidia.com>
Cc:     Mark Kettenis <mark.kettenis@xs4all.nl>,
        Marc Zyngier <maz@kernel.org>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210504120348.2eec075b@redhat.com>
In-Reply-To: <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
        <20210429162906.32742-2-sdonthineni@nvidia.com>
        <20210429122840.4f98f78e@redhat.com>
        <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
        <20210429134659.321a5c3c@redhat.com>
        <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
        <87czucngdc.wl-maz@kernel.org>
        <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
        <878s4zokll.wl-maz@kernel.org>
        <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
        <87eeeqvm1d.wl-maz@kernel.org>
        <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
        <87bl9sunnw.wl-maz@kernel.org>
        <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
        <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
        <20210503084432.75e0126d@x1.home.shazbot.org>
        <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 May 2021 22:03:59 +0000
Vikram Sethi <vsethi@nvidia.com> wrote:

> Hi Alex,
> > From: Alex Williamson <alex.williamson@redhat.com>
> > On Mon, 3 May 2021 13:59:43 +0000
> > Vikram Sethi <vsethi@nvidia.com> wrote: =20
> > > > From: Mark Kettenis <mark.kettenis@xs4all.nl> =20
> > > > > From: Marc Zyngier <maz@kernel.org> =20
> > >
> > > snip =20
> > > > > If, by enumerating the properties of Prefetchable, you can show
> > > > > that they are a strict superset of Normal_NC, I'm on board. I
> > > > > haven't seen such an enumeration so far.
> > > > > =20
> > > snip =20
> > > > > Right, so we have made a small step in the direction of mapping
> > > > > "prefetchable" onto "Normal_NC", thanks for that. What about all
> > > > > the other properties (unaligned accesses, ordering, gathering)? =
=20
> > > > =20
> > > Regarding gathering/write combining, that is also allowed to
> > > prefetchable per PCI spec =20
> >=20
> > As others have stated, gather/write combining itself is not well define=
d.
> >  =20
> > > From 1.3.2.2 of 5/0 base spec:
> > > A PCI Express Endpoint requesting memory resources through a BAR must
> > > set the BAR's Prefetchable bit unless the range contains locations
> > > with read side-effects or locations in which the Function does not to=
lerate =20
> > write merging.
> >=20
> > "write merging"  This is a very specific thing, per PCI 3.0, 3.2.6:
> >=20
> >   Byte Merging =E2=80=93 occurs when a sequence of individual memory wr=
ites
> >   (bytes or words) are merged into a single DWORD.
> >=20
> > The semantics suggest quadword support in addition to dword, but don't
> > require it.  Writes to bytes within a dword can be merged, but duplicate
> > writes cannot.
> >=20
> > It seems like an extremely liberal application to suggest that this one=
 write
> > semantic encompasses full write combining semantics, which itself is not
> > clearly defined.
> > =20
> Talking to our PCIe SIG representative, PCIe switches are not allowed do =
any of the byte
> Merging/combining etc as defined in the PCI spec, and per a rather poorly
> worded Implementation note in the spec says that no known PCIe Host Bridd=
ges/Root=20
> ports do it either.=20
> So for PCIe we don't think believe there is any byte merging that happens=
 in the PCIe
> fabric so it's really a matter of what happens in the CPU core and interc=
onnect
> before it gets to the PCIe hierarchy.

Yes, but merged writes, no matter where they happen, are still the only
type of write combining that a prefetchable BAR on an endpoint is
required to support.

> Stepping back from this patchset, do you agree that it is desirable to su=
pport
> Write combining as understood by ioremap_wc to work in all ISA guests inc=
luding
> ARMv8?

Yes, a userspace vfio driver should be able to take advantage of the
hardware capabilities.  I think where we disagree is whether it's
universally safe to assume write combining based on the PCI
prefetchable capability of a BAR.  If that's something that can be
assumed universally for ARMv8 based on the architecture specification
compatibility with the PCI definition of a prefetchable BAR, then I
would expect a helper somewhere in arch code that returns the right
page protection flags, so that arch maintainers don't need to scour
device drivers for architecture hacks.  Otherwise, it needs to be
exposed through the vfio uAPI to allow the userspace device driver
itself to select these semantics.

> You note that x86 virtualization doesn't have this issue, but KVM-ARM does
> because KVM maps all device BARs as Device Memory type nGnRE which=20
> doesn't allow ioremap_wc from within the guest to get the actual semantic=
s desired.
>=20
> Marc and others have suggested that userspace should provide the hints. B=
ut the
> question is how would qemu vfio do this either? We would be stuck in the =
same
> arguments as here, as to what is the correct way to determine the desired=
 attributes
> for a given BAR such that eventually when a driver in the guest asks for
> ioremap_wc it actually has a chance of working in the guest, in all ISAs.=
=20
> Do you have any suggestions on how to make progress here?

We do need some way for userspace drivers to also make use of WC
semantics, there were some discussions in the past, I think others have
referenced them as well, but nothing has been proposed for a vfio API.

If we had that API, QEMU deciding to universally enable WC for all
vfio prefetchable BARs seems only marginally better than this approach.
Ultimately the mapping should be based on the guest driver semantics,
and if you don't have any visibility to that on KVM/arm like we have on
KVM/x86, then it seems like there's nothing to trigger a vfio API here
anyway.

If that's the case, I'd probably go back to letting the arch/arm64 folks
declare that WC is compatible with the definition of PCI prefetchable
and export some sort of pgprot_pci_prefetchable() helper where the
default would be to #define it as pgproc_noncached() #ifndef by the
arch.

> A device specific list of which BARs are OK to allow ioremap_wc for seems=
 terrible
> and I'm not sure if a commandline qemu option is any better. Is the user =
of device=20
> assignment/sysadmin supposed to know which BAR of which device is OK to a=
llow=20
> ioremap_wc for?

No, a device specific userspace driver should know such device
semantics, but QEMU is not such a driver.  Burdening the hypervisor
user/admin is not a good solution either.  I'd lean on KVM/arm64 folks
to know how the guest driver semantics can be exposed to the
hypervisor.  Thanks,

Alex

