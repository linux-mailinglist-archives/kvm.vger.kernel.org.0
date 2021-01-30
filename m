Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70E30962E
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 16:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhA3PRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 10:17:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbhA3O6A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 30 Jan 2021 09:58:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612018581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZFp68+hXAuEmHBHxHs0xnJpj2nuSUvXcHzQC9sPycWY=;
        b=UfiQT9GmqGhClUG5MOju0NCJjyNvMO7DQ5N2XN3OTYJMdbtRuAHVrz0xqAVoW5V/BQYMEY
        uev7fL0JnWbrGw96z3MIqEUEqlrHBapptVkH50wVeJFjrMItsJr5PQHbvmhRSSawxfOHiL
        UNV5rf/39pICg1tqFfQ6e4/evNtFmcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-UtSBVrZaPXyRfQR39RCWSA-1; Sat, 30 Jan 2021 09:56:18 -0500
X-MC-Unique: UtSBVrZaPXyRfQR39RCWSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 824F5802B45;
        Sat, 30 Jan 2021 14:56:17 +0000 (UTC)
Received: from localhost (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19E825C3E0;
        Sat, 30 Jan 2021 14:56:16 +0000 (UTC)
Date:   Sat, 30 Jan 2021 14:56:16 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RFC v2 0/4] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
Message-ID: <20210130145616.GA98016@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <cover.1611850290.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LZvS9be/3tNcYl/X
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
>=20
> TODOs:
> * Implement KVM_EXIT_IOREGIONFD_FAILURE
> * Add non-x86 arch support

This is an interesting topic for discussion with the KVM maintainers.
The ioctl(KVM_RUN) exit code is arch-specific in the sense that there is
no standard approach for PIO/MMIO accesses to return to userspace and
resume processing when ioctl(KVM_RUN) is called again.

This RFC series is x86-specific, but part of it can be made cross-arch
by introducing a core KVM ->complete_user_exit() function pointer that
MMIO/PIO and other users (EINTR?) can use to resume processing when
ioctl(KVM_RUN) is called again.

Maybe the benefit for a generic ->complete_user_exit() function is too
small so each arch open codes this behavior?

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAVc48ACgkQnKSrs4Gr
c8iUyAgAr0ZWuSRkE2EX/fY7t4zsLQzn022PCYKxdDW8yj7WZlBMyBTBFy2TWsiz
XysyrTalMK21LAUHDcAbxjGFr7Puq/mGuHV6nlaM0g1IaT2Or/0rBtp+VnmrbFDH
Coy3MQcm73oCCfe1YMB9HfMaaKN+b3R6BTlJqF9xs7PLlnmjFPLWO97hwLBMSgtB
B8eaSteiUyFix2XK7HQVJzHqtcgg8eFzFq2sXPVjEjvIpkUboI9GhXHlRkyAoyaF
meAAhW/UUGuXkoiTLC2dtT2wK8FuS9tW0pC0EID0pCBUXHEnnL0DHpW/cbpp8OVX
g4SdcnG2+hP1iRud3HVhYa4ocjoKHA==
=lpD+
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--

