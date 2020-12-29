Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1272E707E
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 13:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgL2MIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 07:08:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgL2MIK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Dec 2020 07:08:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609243603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nievrR+qFpmtLdj81Q1R9ZwD8AXq2E9kmEUtq2V5Rc8=;
        b=FZS+7rLUnC0yzDv3Xzc1HMEG0xX3+LzIfQyF0B+gk3m/PGO4MUdH87Y/m51BplyxAXeEQv
        oR0iyPp/4LRK+YaG9Sh1UpAfXneIRHmqkFmqBxpSsJ1B8SG64s/w4hn/McfnxCtJrixueb
        J7GX4Nd/Ru++QSvE14H/FtSR6cHipQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-g5LlFgNXN_2fbHrREZEcig-1; Tue, 29 Dec 2020 07:06:41 -0500
X-MC-Unique: g5LlFgNXN_2fbHrREZEcig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1206C107ACE4;
        Tue, 29 Dec 2020 12:06:40 +0000 (UTC)
Received: from localhost (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B64B960CD1;
        Tue, 29 Dec 2020 12:06:36 +0000 (UTC)
Date:   Tue, 29 Dec 2020 12:06:35 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, "Michael S. Tsirkin" <mst@redhat.com>,
        jasowang@redhat.com
Subject: Re: [RFC 0/2] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
Message-ID: <20201229120635.GD55616@stefanha-x1.localdomain>
References: <cover.1609231373.git.eafanasova@gmail.com>
MIME-Version: 1.0
In-Reply-To: <cover.1609231373.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 29, 2020 at 01:02:42PM +0300, Elena Afanasova wrote:
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
> ioregionfd relies on kmemcg in order to limit the amount of kernel memory=
=20
> that userspace can consume. Can NR_IOBUS_DEVS hardcoded limit be enforced=
=20
> only in case kmemcg is disabled?

Thanks for sharing this! Can you describe the todos? I noticed some in
Patch 1 and highlighted them. In addition:
 * Signal handling when the vCPU thread is interrupted in
   kernel_read()/kernel_write()

> Elena Afanasova (2):
>   KVM: add initial support for KVM_SET_IOREGION
>   KVM: add initial support for ioregionfd blocking read/write operations
>=20
>  arch/x86/kvm/Kconfig     |   1 +
>  arch/x86/kvm/Makefile    |   1 +
>  arch/x86/kvm/x86.c       |   1 +
>  include/linux/kvm_host.h |  17 ++
>  include/uapi/linux/kvm.h |  23 +++
>  virt/kvm/Kconfig         |   3 +
>  virt/kvm/eventfd.c       |  25 +++
>  virt/kvm/eventfd.h       |  14 ++
>  virt/kvm/ioregion.c      | 390 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/ioregion.h      |  15 ++
>  virt/kvm/kvm_main.c      |  20 +-
>  11 files changed, 507 insertions(+), 3 deletions(-)
>  create mode 100644 virt/kvm/eventfd.h
>  create mode 100644 virt/kvm/ioregion.c
>  create mode 100644 virt/kvm/ioregion.h
>=20
> --=20
> 2.25.1
>=20

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/rG8sACgkQnKSrs4Gr
c8hZ+wf/Q7lAY0agLF7owCLg6r7Pa9oY3D1fWzxX47paZ74kdGwXULpFioQ8KKhm
+D7aL12WYFCdlmPWTjLdB74E5rq2x684nMNfWENMW5uEVvRdgtq3cVHJ9vvqSbYv
O2UcDFnB2hpQTjx4ieVI2heBzSWY775NCAsoGZpxFHMMw7gNosEVmvUWX/iYQV/p
naLGVWXFG5n7btEkPSfAXFxfwI3N2V5Hur6jK0NtZvdUZS2S8f9zYhD/5zqIX7FE
0I2BKA1SLYqPEbi7gYvUSutNlgNWyzBCWUmO7AqWJTpr7eLIp51DzWLV+XJUZZ5V
a07KAYvF2vvLnzaAH4hdetparLT5fA==
=k7Yg
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--

