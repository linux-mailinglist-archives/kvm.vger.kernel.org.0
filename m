Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73F016BD31
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 10:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgBYJYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 04:24:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29879 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726764AbgBYJYt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 04:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582622687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ruxLn3R0zhJjq1rAdj53inodrwnQ9ng3rg6aMUy7rw0=;
        b=gXcmIpJdOzCwjzZJelQuJfAaIDklBDQikdKQYONrAAuSAMRO8eOrwpjTEC2gGkkcfVk/vl
        FYIXG5TpM1pagO7pseDSx9ZZX4NH6vOQH2VrvrrjWdtYwv0WZNaySh9svCWqwU+UJWR1mI
        QLO7bGta3WDPX1bh0iUERNrgzTLnHgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-GGgedTOBPdKaKo_VZAUtOA-1; Tue, 25 Feb 2020 04:24:43 -0500
X-MC-Unique: GGgedTOBPdKaKo_VZAUtOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE237DB20;
        Tue, 25 Feb 2020 09:24:41 +0000 (UTC)
Received: from localhost (ovpn-117-159.ams2.redhat.com [10.36.117.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E2F3620D8;
        Tue, 25 Feb 2020 09:24:35 +0000 (UTC)
Date:   Tue, 25 Feb 2020 09:24:34 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, jasowang@redhat.com, cohuck@redhat.com,
        slp@redhat.com, felipe@nutanix.com, john.g.johnson@oracle.com,
        robert.bradford@intel.com, Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200225092434.GD4178@stefanha-x1.localdomain>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
 <20200224120522-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20200224120522-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2020 at 12:10:25PM -0500, Michael S. Tsirkin wrote:
> On Sat, Feb 22, 2020 at 08:19:16PM +0000, Stefan Hajnoczi wrote:
> > The KVM_IOREGIONFD_POSTED_WRITES flag
> > skips waiting for an acknowledgement on write accesses.  This is
> > suitable for accesses that do not require synchronous emulation, such a=
s
> > doorbell register writes.
>=20
> I would avoid hacks like this until we understand this better.
> Specificlly one needs to be very careful since memory ordering semantics
> can differ between a write into an uncacheable range and host writes into
> a data structure. Reads from one region are also assumed to be ordered wi=
th
> writes to another region, and drivers are known to make assumptions
> like this.
>=20
> Memory ordering being what it is, this isn't a field I'd be comfortable
> device writes know what they are doing.

Unlike PCI Posted Writes the idea is not to let the write operations sit
in a cache.  They will be sent immediately just like ioeventfd is
signalled immediately before re-entering the guest.

The purpose of this feature is to let the device emulation program
handle these writes asynchronously (without holding up the vCPU for a
response from the device emulation program) but the order of
reads/writes remains unchanged.

Stefan

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5U59IACgkQnKSrs4Gr
c8gDkQgAluBpnRzj3ZgjLol6WD/ABCR3wWmteEdo7yyGUuP6lxh/3x2OJK4AQ0WE
R60EXPhc43Fnbh3we9W5aEzi6ygoZiDL8Yw4jT36wK4X6wjuNQyYKvYu8MsvP+HS
dJRCiZH2ZqhnfOj+WRkO+Q5pGk/xC5ky1S75dbFaXzqVC8IOtILkGI+FvPxi8q2o
+Gs2eMmNOjlMyAIZbK3jXWyz4QVrqyDTvN2OS2oxGF4LQYWrLYHanyn7uegWeO03
YDTbfmmaGlDTTgv+VjsVbI44hU8L0dQhHo4th98rqEq62S8UKVRT85YoT76TMGlm
xdQy4OQIsm+IJg0R3AOvCxuT2QsqYQ==
=ugGc
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--

