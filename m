Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E3C16EB8B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgBYQhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:37:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30357 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728051AbgBYQhB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 11:37:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582648619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9nQAi2XHIrODqGKVtyEpFTnQmWX4p+hHiW5GzjVK14k=;
        b=Rri8Sk4aOOJnUkloBEzHI/fV5C5QBB6jdGEkA4WeFHSLyCuFne8yLCD7fHVSO68OqFrAQl
        jUuYVkzU5QY1xuXLT0DbWfG12cr1zclCCj7ZYgorDOwchffFYROreFYaSXrHG3C30a7Cuk
        Hk6WrWJSl9c2FwNB8kb6CfVSuJt5IsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-YyGFKtmMM_CqoerDVfd-8w-1; Tue, 25 Feb 2020 11:36:54 -0500
X-MC-Unique: YyGFKtmMM_CqoerDVfd-8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C581A13EA;
        Tue, 25 Feb 2020 16:36:52 +0000 (UTC)
Received: from localhost (unknown [10.36.118.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A214909F6;
        Tue, 25 Feb 2020 16:36:46 +0000 (UTC)
Date:   Tue, 25 Feb 2020 16:36:45 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, jasowang@redhat.com, cohuck@redhat.com,
        slp@redhat.com, felipe@nutanix.com, john.g.johnson@oracle.com,
        robert.bradford@intel.com, Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200225163645.GC41287@stefanha-x1.localdomain>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
 <20200224120522-mutt-send-email-mst@kernel.org>
 <20200225092434.GD4178@stefanha-x1.localdomain>
 <20200225065034-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20200225065034-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2020 at 06:57:18AM -0500, Michael S. Tsirkin wrote:
> On Tue, Feb 25, 2020 at 09:24:34AM +0000, Stefan Hajnoczi wrote:
> > On Mon, Feb 24, 2020 at 12:10:25PM -0500, Michael S. Tsirkin wrote:
> > > On Sat, Feb 22, 2020 at 08:19:16PM +0000, Stefan Hajnoczi wrote:
> > > > The KVM_IOREGIONFD_POSTED_WRITES flag
> > > > skips waiting for an acknowledgement on write accesses.  This is
> > > > suitable for accesses that do not require synchronous emulation, su=
ch as
> > > > doorbell register writes.
> > >=20
> > > I would avoid hacks like this until we understand this better.
> > > Specificlly one needs to be very careful since memory ordering semant=
ics
> > > can differ between a write into an uncacheable range and host writes =
into
> > > a data structure. Reads from one region are also assumed to be ordere=
d with
> > > writes to another region, and drivers are known to make assumptions
> > > like this.
> > >=20
> > > Memory ordering being what it is, this isn't a field I'd be comfortab=
le
> > > device writes know what they are doing.
> >=20
> > Unlike PCI Posted Writes the idea is not to let the write operations si=
t
> > in a cache.  They will be sent immediately just like ioeventfd is
> > signalled immediately before re-entering the guest.
>=20
> But ioeventfd sits in the cache: the internal counter. The fact it's
> signalled does not force a barrier on the signalling thread.  It looks
> like the same happens here: value is saved with the file descriptor,
> other accesses of the same device can bypass the write.

See below.

> > The purpose of this feature is to let the device emulation program
> > handle these writes asynchronously (without holding up the vCPU for a
> > response from the device emulation program) but the order of
> > reads/writes remains unchanged.
> >=20
> > Stefan
>=20
> I don't see how this can be implemented without guest changes though.
> For example, how do you make sure two writes to such regions are ordered
> just like they are on PCI?

Register both regions with the same fd.  This way the write accesses
will be read out by the device emulation program in serialized order.

The purpose of the region_id field is to allow device emulation programs
that register multiple regions with the same fd to identify which one is
being accessed.

QEMU would only need 1 fd.  Each VFIO userspace device (muser) would
need 1 fd.

Stefan

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5VTR0ACgkQnKSrs4Gr
c8g5nggAjtnP08xbmwR0yyPRyuXCJyjLJa9ulqv2ThVvmrZZukcnuFUNoKSBxbJX
iL7RTg/g1Y9Ntavz+Nv5iqPqg+qTaMnOh7jcIZJilicJy15gsImRIJN3t1dUC+k/
g2SC0LgNsvJfgCZ+vgWOzmBiDXW1mnxZ1N0rzefPAqKvkN4y39HfvUYnN4KFfmJm
g8IhLXYB8bl7lL8lz2QPUUhjIAv5z6u+hl/ZFU36EBv+DszU+NBvuCSGtmAY3coG
jtO0CK5WZdzxru0aEdjP6awZ0b2pvdX3IKAB51MceLYb057yigG3KwoHMd4AdJAX
ggsxSOnLvhulVpK3TLrAot/+EWLayA==
=cHQP
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--

