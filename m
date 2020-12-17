Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152F82DD1C6
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 14:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgLQNBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 08:01:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbgLQNBK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 08:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608209982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hP9o8iBbJgcJqXSkMh+zWL+OzzVy5h8KfyvZRhgl3ZY=;
        b=iAwxX+q3nnTePutzYHGW6tLepX+NO+Ox2sJgjk0cln8gipH/k1WYY8xyCOHjsY0ezXPtEe
        KcA2NYzWW+ycN0PPM1KyExX17iFlhIQ9KeFbP4+CrdRaK4Y0oB7et1z2V4Wbl99EhYhq/d
        qvG2SvpeMF5tfDM3e4VotCb0gxs9IQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-8H7XtUbwM02c5-GiGs25Ww-1; Thu, 17 Dec 2020 07:59:40 -0500
X-MC-Unique: 8H7XtUbwM02c5-GiGs25Ww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A5E781DFB3;
        Thu, 17 Dec 2020 12:59:36 +0000 (UTC)
Received: from gondolin (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B20E460C7A;
        Thu, 17 Dec 2020 12:59:22 +0000 (UTC)
Date:   Thu, 17 Dec 2020 13:59:19 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
Message-ID: <20201217135919.46d5c43f.cohuck@redhat.com>
In-Reply-To: <a974c5cc-fc42-7bf0-66a6-df095da7105f@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
        <20201210133306.70d1a556.cohuck@redhat.com>
        <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
        <20201211153501.7767a603.cohuck@redhat.com>
        <6c9528f3-f012-ba15-1d68-7caefb942356@linux.ibm.com>
        <a974c5cc-fc42-7bf0-66a6-df095da7105f@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 10:04:43 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 12/11/20 10:01 AM, Matthew Rosato wrote:
> > On 12/11/20 9:35 AM, Cornelia Huck wrote: =20

> >> Let me summarize this to make sure I understand this new region
> >> correctly:
> >>
> >> - some devices may have relaxed alignment/length requirements for
> >> =C2=A0=C2=A0 pcistb (and friends?) =20
> >=20
> > The relaxed alignment bit is really specific to PCISTB behavior, so the=
=20
> > "and friends" doesn't apply there.

Ok.

> >  =20
> >> - some devices may actually require writes to be done in a large chunk
> >> =C2=A0=C2=A0 instead of being broken up (is that a strict subset of th=
e devices
> >> =C2=A0=C2=A0 above?) =20
> >=20
> > Yes, this is specific to ISM devices, which are always a relaxed=20
> > alignment/length device.
> >=20
> > The inverse is an interesting question though (relaxed alignment device=
s=20
> > that are not ISM, which you've posed as a possible future extension for=
=20
> > emulated devices).=C2=A0 I'm not sure that any (real devices) exist whe=
re=20
> > (relaxed_alignment && !ism), but 'what if' -- I guess the right approac=
h=20
> > would mean additional code in QEMU to handle relaxed alignment for the=
=20
> > vfio mmio path as well (seen as pcistb_default in my qemu patchset) and=
=20
> > being very specific in QEMU to only enable the region for an ism device=
. =20
>=20
> Let me be more precise there...  It would be additional code to handle=20
> relaxed alignment for the default pcistb path (pcistb_default) which=20
> would include BOTH emulated devices (should we ever surface the relaxed=20
> alignment CLP bit and the guest kernel honor it) as well as any s390x=20
> vfio-pci device that doesn't use this new I/O region described here.

Understood. Not sure if it is useful, but the important part is that we
could extend it if we wanted.

>=20
> >  =20
> >> - some devices do not support the new MIO instructions (is that a
> >> =C2=A0=C2=A0 subset of the relaxed alignment devices? I'm not familiar=
 with the
> >> =C2=A0=C2=A0 MIO instructions)
> >> =20
> >=20
> > The non-MIO requirement is again specific to ISM, which is a subset of=
=20
> > the relaxed alignment devices.=C2=A0 In this case, the requirement is n=
ot=20
> > limited to PCISTB, and that's why PCILG is also included here.=C2=A0 Th=
e ISM=20
> > driver does not use PCISTG, and the only PCISTG instructions coming fro=
m=20
> > the guest against an ISM device would be against the config space and=20
> > those are OK to go through vfio still; so what was provided via the=20
> > region is effectively the bare-minimum requirement to allow ISM to=20
> > function properly in the guest.
> >  =20
> >> The patchsets introduce a new region that (a) is used by QEMU to submit
> >> writes in one go, and (b) makes sure to call into the non-MIO
> >> instructions directly; it's basically killing two birds with one stone
> >> for ISM devices. Are these two requirements (large writes and non-MIO)
> >> always going hand-in-hand, or is ISM just an odd device? =20
> >=20
> > I would say that ISM is definitely a special-case device, even just=20
> > looking at the way it's implemented in the base kernel (interacting=20
> > directly with the s390 kernel PCI layer in order to avoid use of MIO=20
> > instructions -- no other driver does this).=C2=A0 But that said, having=
 the=20
> > two requirements hand-in-hand I think is not bad, though -- This=20
> > approach ensures the specific instruction the guest wanted (or in this=
=20
> > case, needed) is actually executed on the underlying host.

The basic question I have is whether it makes sense to specialcase the
ISM device (can we even find out that we're dealing with an ISM device
here?) to force the non-MIO instructions, as it is just a device with
some special requirements, or tie non-MIO to relaxed alignment. (Could
relaxed alignment devices in theory be served by MIO instructions as
well?)

Another thing that came to my mind is whether we consider the guest to
be using a pci device and needing weird instructions to do that because
it's on s390, or whether it is issuing instructions for a device that
happens to be a pci device (sorry if that sounds a bit meta :)

> >=20
> > That said, the ability to re-use the large write for other devices woul=
d=20
> > be nice -- but as hinted in the QEMU cover letter, this approach only=20
> > works because ISM does not support MSI-X; using this approach for=20
> > MSI-X-enabled devices breaks the MSI-X masking that vfio-pci does in=20
> > QEMU (I tried an approach that used this region approach for all 3=20
> > instructions as a test, PCISTG/PCISTB/PCILG, and threw it against mlx -=
-=20
> > any writes against an MSI-X enabled bar will miss the msi-x notifiers=20
> > since we aren't performing memory operations against the typical=20
> > vfio-pci bar).

Ugh. I wonder why ISM is so different from anything else.

> >  =20
> >>
> >> If there's an expectation that the new region will always use the
> >> non-MIO instructions (in addition to the changed write handling), it
> >> should be noted in the description for the region as well.
> >> =20
> >=20
> > Yes, this is indeed the expectation; I can clarify that.
> >  =20

Thanks!

