Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E622830C2E0
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 16:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhBBPCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 10:02:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234866AbhBBPBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 10:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612277998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=boBv4WGpof0FYgXpab1Tlyff1+sqYd9QdzyHJn+rW9o=;
        b=YSxJEafzdQ3sgBa5GbvYGxAKunQxtV6xoGBEPgmx9C9Po3yH3+1y2gEp7kl5exdP5GlkkP
        0rdCR6iHIM4oexGFZekZ8n5jarxbdDVQ2yRNfScYVl18ytho454eEnoe62tIMg7NsaILWg
        Um/V6twVsjffYhpqDxSSaF2sIbQXszM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-78jhszx4OquBDQL1UuiDNA-1; Tue, 02 Feb 2021 09:59:54 -0500
X-MC-Unique: 78jhszx4OquBDQL1UuiDNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7F2C1800D41;
        Tue,  2 Feb 2021 14:59:52 +0000 (UTC)
Received: from localhost (ovpn-115-185.ams2.redhat.com [10.36.115.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63A6A60C5F;
        Tue,  2 Feb 2021 14:59:49 +0000 (UTC)
Date:   Tue, 2 Feb 2021 14:59:34 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, "Michael S. Tsirkin" <mst@redhat.com>,
        jasowang@redhat.com, John Levon <john.levon@nutanix.com>,
        Elena Afanasova <eafanasova@gmail.com>
Subject: Re: [RFC v2 0/4] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
Message-ID: <20210202145934.GA35955@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <cover.1611850290.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28, 2021 at 09:32:19PM +0300, Elena Afanasova wrote:
> This patchset introduces a KVM dispatch mechanism which can be used=20
> for handling MMIO/PIO accesses over file descriptors without returning=20
> from ioctl(KVM_RUN). This allows device emulation to run in another task=
=20
> separate from the vCPU task.
>=20
> This is achieved through KVM vm ioctl for registering MMIO/PIO regions an=
d=20
> a wire protocol that KVM uses to communicate with a task handling an=20
> MMIO/PIO access.

Hi Paolo,
This patch series makes changes to the somewhat tricky x86 MMIO/PIO code
and introduces a new ioctl(KVM_RUN) EINTR case. Please take a look if
you have time!

Reviews from anyone else are appreciated too!

Thanks,
Stefan

>=20
> TODOs:
> * Implement KVM_EXIT_IOREGIONFD_FAILURE
> * Add non-x86 arch support
> * Add kvm-unittests
>=20
> Elena Afanasova (4):
>   KVM: add initial support for KVM_SET_IOREGION
>   KVM: x86: add support for ioregionfd signal handling
>   KVM: add support for ioregionfd cmds/replies serialization
>   KVM: enforce NR_IOBUS_DEVS limit if kmemcg is disabled
>=20
>  arch/x86/kvm/Kconfig          |   1 +
>  arch/x86/kvm/Makefile         |   1 +
>  arch/x86/kvm/x86.c            | 216 ++++++++++++++-
>  include/kvm/iodev.h           |  14 +
>  include/linux/kvm_host.h      |  34 +++
>  include/uapi/linux/ioregion.h |  32 +++
>  include/uapi/linux/kvm.h      |  23 ++
>  virt/kvm/Kconfig              |   3 +
>  virt/kvm/eventfd.c            |  25 ++
>  virt/kvm/eventfd.h            |  14 +
>  virt/kvm/ioregion.c           | 479 ++++++++++++++++++++++++++++++++++
>  virt/kvm/ioregion.h           |  15 ++
>  virt/kvm/kvm_main.c           |  68 ++++-
>  13 files changed, 905 insertions(+), 20 deletions(-)
>  create mode 100644 include/uapi/linux/ioregion.h
>  create mode 100644 virt/kvm/eventfd.h
>  create mode 100644 virt/kvm/ioregion.c
>  create mode 100644 virt/kvm/ioregion.h
>=20
> --=20
> 2.25.1
>=20

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAZaNQACgkQnKSrs4Gr
c8hDGgf+PqYuZL9PS4kqIX2XiRPppuDyv0aZpfYSEe6NrJ+ZmiDljRkfJPC+GQFu
Q9agBBNMnJBH8HR3sSigCNJxbqOHFJTBjmAk+yEsrUbcdbWIEjv4LYY29fY9HJZU
QPclAzyAtIuMPB1aZLITK4LzECaIuPTbgYhJqrzy43baNaT8Hqg5RqWrTKf0h8dw
e8L+WeClSAOGaXhyiymZCkqK2zcs+G68TrnSWwgRYM+VU8X2Trne7dC1hn1WAG/X
yKsBC4xoyboK8DYgbhYW2vlTxtdWFECJ19j6a9XlIKcWLoggP21ocFRB56BqAiSc
wvk+rt0aZFyQFGYcwDBszieYs3/vZg==
=q3hJ
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--

