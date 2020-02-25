Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBE516EBAC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgBYQpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:45:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59363 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729536AbgBYQpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 11:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582649143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dsTaB9hKIrEiNoSwzjYUhx+xFsKlEUT0BiAXa6WZb64=;
        b=GaK+1zLWHf5Mf0V0uaoP5r11MJheRwsfFHXr69bUYHYI2djP44YtIjx+fIb/f56clkLe/z
        dgJoXnlnYYcRsorgSj96c2k7OMDODvXxQF/FB76WbSB/UBlhT74qhSdMHEeu2G93N330yk
        xgfYc8KG1oTyhSaXGY6vT0/8uTeNqj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-tCslVCs7N4OisKzessLRlA-1; Tue, 25 Feb 2020 11:45:41 -0500
X-MC-Unique: tCslVCs7N4OisKzessLRlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9ABD8010CA;
        Tue, 25 Feb 2020 16:45:39 +0000 (UTC)
Received: from localhost (unknown [10.36.118.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3383D811F8;
        Tue, 25 Feb 2020 16:45:33 +0000 (UTC)
Date:   Tue, 25 Feb 2020 16:45:33 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Felipe Franciosi <felipe@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "slp@redhat.com" <slp@redhat.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        "robert.bradford@intel.com" <robert.bradford@intel.com>,
        Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200225164533.GD41287@stefanha-x1.localdomain>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
 <62FEFA1E-0D75-4AFB-860A-59CF5B9B45F7@nutanix.com>
MIME-Version: 1.0
In-Reply-To: <62FEFA1E-0D75-4AFB-860A-59CF5B9B45F7@nutanix.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2020 at 12:19:55PM +0000, Felipe Franciosi wrote:
> Hi,
>=20
> This looks amazing, Stefan. The lack of such a mechanism troubled us
> during the development of MUSER and resulted in the slow-path we have
> today for MMIO with register semantics (when writes cannot be
> overwritten before the device emulator has a chance to process them).
>=20
> I have added some comments inline, but wanted to first link your
> proposal with an idea that I discussed with Maxim Levitsky back in
> Lyon and evolve on it a little bit. IIRC/IIUC Maxim was keen on a VT-x
> extension where a CPU could IPI another to handle events which would
> normally cause a VMEXIT. That is probably more applicable to the
> standard ioeventfd model, but it got me thinking about PML.
>=20
> Bear with me. :)
>=20
> In addition to an fd, which could be used for notifications only, the
> wire protocol could append "struct ioregionfd_cmd"s (probably renamed
> to drop "fd") to one or more pages (perhaps a ring buffer of sorts).
>=20
> That would only work for writes; reads would still be synchronous.
>=20
> The device emulator therefore doesn't have to respond to each write
> command. It could process the whole lot whenever it gets around to it.

Yes, the design supports that as follows:

1. Set the KVM_IOREGIONFD_POSTED_WRITES flag on regions that require
   asynchronous writes.
2. Use io_uring IORING_OP_READ with N * sizeof(struct ioregionfd_cmd)
   where N is the maximum number of commands to be processed in a batch.
   Also make sure the socket sndbuf is at least this large if you're
   using a socket fd.
3. Poll on the io_uring cq ring from userspace.  No syscalls are
   required on the fd.  If io_uring sq polling is also enabled then no
   syscalls may be required at all.

If the fd ceases to be writeable because the device emulation program is
not reading struct ioregionfd_cmds quickly enough then the vCPU will be
blocked until the fd becomes writeable again.  But this shouldn't be an
issue for a poll mode device emulation program.

> Most importantly (and linking back to the VT-x extension idea), maybe
> we can avoid the VMEXIT altogether if the CPU could take care of
> appending writes to that buffer. Thoughts?

A VT-x extension would be nice.  It would probably need to be much
simpler in terms of memory region data structures and complexity though
(because of the hardware implementation of this feature).  For example,
just a single buffer for *all* MMIO/PIO accesses made by a vCPU.  That
becomes difficult to use efficiently when there are multiple device
emulation processes.  It's an interesting idea though.

Stefan

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5VTywACgkQnKSrs4Gr
c8hCHwgAvfIkZ9C3/R7fbWAjD8r12xmF4P1aRK2KnBCecWtQt2pyT3rX8xQYyBqD
BoFR35IRFFGfRgPKhA7nK0k6qtnBVCDUFXL0rrhsyP3L9SsrniiihbCSd+ziCij0
E29KxipevsCEAqyFC5XjRH5Ce5MqAo/XJo9glXfJ029nX5vmPkNDxcmKk42CSOGS
qNDKHjmzxDMTnstT9bHcEj3TrD/vR0VNUV040xzCoeq2VPjwW4XyIWIprOrkJvT/
+WRwxLJIJnBBYGyGvbCwTi72qTa9RiR6cFTU19FyuqClsEe/Y/tXhJrujYgwGZf3
evxcD79u4Z/aCNlo3cPJkvA2Kk+ApQ==
=ojvh
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--

