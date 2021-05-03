Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6063716D9
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhECOpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:45:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229703AbhECOpc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620053079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bl56Zu7+zy9TZvZXab3dG9cf65Q5oyc9UzIYD23qD4o=;
        b=D2fF/HEL+1ciYXkZ2MJ6BsOMG3EPFK0N0qDpEhwk7oFCOp5ojLWognEzpYMRkDbXagtws3
        Q4UnHsNpXdd98K5SZVex2kucRdz/vsfgIWpipquinR9PqkUhUEK4zyJxrv6pie6gHeusN0
        5U0jH9bTVL/fA+j8WUaMcKnWc92Q3MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-5OtKC6mePom9ceq1518erg-1; Mon, 03 May 2021 10:44:35 -0400
X-MC-Unique: 5OtKC6mePom9ceq1518erg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A85E100A24D;
        Mon,  3 May 2021 14:44:33 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8BF95C1D0;
        Mon,  3 May 2021 14:44:32 +0000 (UTC)
Date:   Mon, 3 May 2021 08:44:32 -0600
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
Message-ID: <20210503084432.75e0126d@x1.home.shazbot.org>
In-Reply-To: <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 May 2021 13:59:43 +0000
Vikram Sethi <vsethi@nvidia.com> wrote:

> > From: Mark Kettenis <mark.kettenis@xs4all.nl> =20
> > > From: Marc Zyngier <maz@kernel.org> =20
>=20
> snip
> > > If, by enumerating the properties of Prefetchable, you can show that
> > > they are a strict superset of Normal_NC, I'm on board. I haven't seen
> > > such an enumeration so far.
> > > =20
> snip
> > > Right, so we have made a small step in the direction of mapping
> > > "prefetchable" onto "Normal_NC", thanks for that. What about all the
> > > other properties (unaligned accesses, ordering, gathering)? =20
> >  =20
> Regarding gathering/write combining, that is also allowed to prefetchable=
 per PCI spec

As others have stated, gather/write combining itself is not well
defined.

> From 1.3.2.2 of 5/0 base spec:
> A PCI Express Endpoint requesting memory resources through a BAR must set=
 the BAR's Prefetchable bit unless
> the range contains locations with read side-effects or locations in which=
 the Function does not tolerate write
> merging.

"write merging"  This is a very specific thing, per PCI 3.0, 3.2.6:

  Byte Merging =E2=80=93 occurs when a sequence of individual memory writes
  (bytes or words) are merged into a single DWORD.

The semantics suggest quadword support in addition to dword, but don't
require it.  Writes to bytes within a dword can be merged, but
duplicate writes cannot.

It seems like an extremely liberal application to suggest that this one
write semantic encompasses full write combining semantics, which itself
is not clearly defined.

> Further 7.5.1.2.1 says " A Function is permitted
> to mark a range as prefetchable if there are no side effects on reads, th=
e Function returns all bytes on reads regardless of
> the byte enables, and host bridges can merge processor writes into this r=
ange139 without causing errors"
>=20
> The "regardless of byte enables" suggests to me that unaligned is OK, as =
only=20
> certain byte enables may be set, what do you think?
>=20
> So to me prefetchable in PCIe spec allows for write combining, read witho=
ut

Ironically here, the above PCI spec section defining write merging has
separate sections for "combining", "merging", and "collapsing".  Only
merging is indicated as a requirement for prefetchable resources.

> sideeffect (prefetch/speculative as long as uncached), and unaligned. Reg=
arding
> ordering I didn't find a statement one way or other in PCIe prefetchable =
definition, but
> I think that goes beyond what PCIe says or doesn't say anyway since reord=
ering can=20
> also happen in the CPU, and since driver must be aware of correctness iss=
ues in its=20
> producer/consumer models it will need the right barriers where they are r=
equired=20
> for correctness anyway (required for the driver/userspace to work on host=
 w/ ioremap_wc).

A lot of hand waving here, imo.  Thanks,

Alex

