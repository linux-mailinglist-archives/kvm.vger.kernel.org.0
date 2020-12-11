Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80BC2D779D
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 15:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405426AbgLKOQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 09:16:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405927AbgLKOQO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 09:16:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607696087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qKvxuuhvHVvh0V5S7TpPuQeAITPbX3w3Fo6XsWdrtcw=;
        b=WkoW1OgQ36psBr0zeFhkSyQDsUdRR67gkOoVa0bX9zB9ENWJfv8O1YDhYh3oWnmBbbcYPK
        mnXoMh5jfhwJBbaUGa87Ex3muph7GxwYXqO4tfuak6SABxD/NnnygEC63yZxlxKG9s/77m
        /LvwugKdViJ1mthMkcRTDkmmWJwYAkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-KR9Iu5P_PrWoRMwPFJaeiw-1; Fri, 11 Dec 2020 09:14:42 -0500
X-MC-Unique: KR9Iu5P_PrWoRMwPFJaeiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D9C3CE651;
        Fri, 11 Dec 2020 14:14:40 +0000 (UTC)
Received: from gondolin (ovpn-112-240.ams2.redhat.com [10.36.112.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73C0319C78;
        Fri, 11 Dec 2020 14:14:34 +0000 (UTC)
Date:   Fri, 11 Dec 2020 15:14:31 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
Message-ID: <20201211151431.75a4a3f4.cohuck@redhat.com>
In-Reply-To: <7bce88b2-8c7d-c0f4-89a0-b1e8f511ad0b@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
        <20201210133306.70d1a556.cohuck@redhat.com>
        <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
        <7bce88b2-8c7d-c0f4-89a0-b1e8f511ad0b@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Dec 2020 17:14:24 +0100
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> On 12/10/20 4:51 PM, Matthew Rosato wrote:
> > On 12/10/20 7:33 AM, Cornelia Huck wrote: =20
> >> On Wed,=C2=A0 9 Dec 2020 15:27:46 -0500
> >> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >> =20
> >>> Today, ISM devices are completely disallowed for vfio-pci passthrough=
 as
> >>> QEMU will reject the device due to an (inappropriate) MSI-X check.
> >>> However, in an effort to enable ISM device passthrough, I realized th=
at the
> >>> manner in which ISM performs block write operations is highly incompa=
tible
> >>> with the way that QEMU s390 PCI instruction interception and
> >>> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- =
ISM
> >>> devices have particular requirements in regards to the alignment, siz=
e and
> >>> order of writes performed.=C2=A0 Furthermore, they require that legac=
y/non-MIO
> >>> s390 PCI instructions are used, which is also not guaranteed when the=
 I/O
> >>> is passed through the typical userspace channels. =20
> >>
> >> The part about the non-MIO instructions confuses me. How can MIO
> >> instructions be generated with the current code, and why does changing=
 =20
> >=20
> > So to be clear, they are not being generated at all in the guest as the=
 necessary facility is reported as unavailable.
> >=20
> > Let's talk about Linux in LPAR / the host kernel:=C2=A0 When hardware t=
hat supports MIO instructions is available, all userspace I/O traffic is go=
ing to be routed through the MIO variants of the s390 PCI instructions.=C2=
=A0 This is working well for other device types, but does not work for ISM =
which does not support these variants.=C2=A0 However, the ISM driver also d=
oes not invoke the userspace I/O routines for the kernel, it invokes the s3=
90 PCI layer directly, which in turn ensures the proper PCI instructions ar=
e used -- This approach falls apart when the guest ISM driver invokes those=
 routines in the guest -- we (qemu) pass those non-MIO instructions from th=
e guest as memory operations through vfio-pci, traversing through the vfio =
I/O layer in the guest (vfio_pci_bar_rw and friends), where we then arrive =
in the host s390 PCI layer -- where the MIO variant is used because the fac=
ility is available. =20
>=20
> Slight clarification since I think the word "userspace" is a bit overload=
ed as
> KVM folks often use it to talk about the guest even when that calls throu=
gh vfio.
> Application userspace (i.e. things like DPDK) can use PCI MIO Load/Stores
> directly on mmap()ed/ioremap()ed memory these don't go through the Kernel=
 at
> all.
> QEMU while also in userspace on the other hand goes through the vfio_bar_=
rw()
> region which uses the common code _Kernel_ ioread()/iowrite() API. This K=
ernel
> ioread()/iowrite() API uses PCI MIO Load/Stores by default on machines th=
at
> support them (z15 currently).  The ISM driver, knowing that its device do=
es not
> support MIO, goes around this API and directly calls zpci_store()/zpci_lo=
ad().

Ok, thanks for the explanation.

>=20
>=20
> >=20
> > Per conversations with Niklas (on CC), it's not trivial to decide by th=
e time we reach the s390 PCI I/O layer to switch gears and use the non-MIO =
instruction set. =20
>=20
> Yes, we have some ideas about dynamically switching to legacy PCI stores =
in
> ioread()/iowrite() for devices that are set up for it but since that only=
 gets
> an ioremap()ed address, a value and a size it would evolve such nasty thi=
ngs as
> looking at this virtual address to determine if it includes a ZPCI_ADDR()
> cookie that we use to get to the function handle needed for the legacy PCI
> Load/Stores, while MIO PCI Load/Stores directly work on virtual addresses.
>=20
> Now purely for the Kernel API we think this could work since that always
> allocates between VMALLOC_START and VMALLOC_END and we control where we p=
ut the
> ZPCI_ADDR() cookie but I'm very hesitant to add something like that.
>=20
> As for application userspace (DPDK) we do have a syscall
> (arch/s390/pci/pci_mmio.c) API that had a similar problem but we could ma=
ke use
> of the fact that our Architecture is pretty nifty with address spaces and=
 just
> execute the MIO PCI Load/Store in the syscall _as if_ by the calling user=
space
> application.

Is ISM (currently) the only device that needs to use the non-MIO
instructions, or are there others as well? Is there any characteristic
that a meta driver like vfio could discover, or is it a device quirk
you just need to know about?

