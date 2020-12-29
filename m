Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DED2E704B
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 13:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgL2MB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 07:01:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725964AbgL2MBz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Dec 2020 07:01:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609243228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ms4RXgdiNzYYLLtXPEJc7J5N06UtTw+28+1cWl1Rbw=;
        b=RuOh9OBRwV9baaYzgzBrnP4Zm/aTks9lSwgvqXObtZs5eZ9v0NCDQRW4gw1dXv9YM26JMG
        Sur2r2MF71738uJzlIFCzBm0vWk2B+Kzc7vlO1150VPjFiY/FvwP70/5JRL6HnY8Ljv831
        aG7RLuLfPNu95NXIQ8o3MoszkuW9SAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-1tg-Q8saMhuNXT2tH0LnCg-1; Tue, 29 Dec 2020 07:00:25 -0500
X-MC-Unique: 1tg-Q8saMhuNXT2tH0LnCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7577110054FF;
        Tue, 29 Dec 2020 12:00:24 +0000 (UTC)
Received: from localhost (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 156E35D9DC;
        Tue, 29 Dec 2020 12:00:23 +0000 (UTC)
Date:   Tue, 29 Dec 2020 12:00:23 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RFC 2/2] KVM: add initial support for ioregionfd blocking
 read/write operations
Message-ID: <20201229120023.GC55616@stefanha-x1.localdomain>
References: <cover.1609231373.git.eafanasova@gmail.com>
 <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 29, 2020 at 01:02:44PM +0300, Elena Afanasova wrote:
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
>  virt/kvm/ioregion.c | 157 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 157 insertions(+)
>=20
> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> index a200c3761343..8523f4126337 100644
> --- a/virt/kvm/ioregion.c
> +++ b/virt/kvm/ioregion.c
> @@ -4,6 +4,33 @@
>  #include <kvm/iodev.h>
>  #include "eventfd.h"
> =20
> +/* Wire protocol */
> +struct ioregionfd_cmd {
> +=09__u32 info;
> +=09__u32 padding;
> +=09__u64 user_data;
> +=09__u64 offset;
> +=09__u64 data;
> +};
> +
> +struct ioregionfd_resp {
> +=09__u64 data;
> +=09__u8 pad[24];
> +};
> +
> +#define IOREGIONFD_CMD_READ    0
> +#define IOREGIONFD_CMD_WRITE   1
> +
> +#define IOREGIONFD_SIZE_8BIT   0
> +#define IOREGIONFD_SIZE_16BIT  1
> +#define IOREGIONFD_SIZE_32BIT  2
> +#define IOREGIONFD_SIZE_64BIT  3
> +
> +#define IOREGIONFD_SIZE_OFFSET 4
> +#define IOREGIONFD_RESP_OFFSET 6
> +#define IOREGIONFD_SIZE(x) ((x) << IOREGIONFD_SIZE_OFFSET)
> +#define IOREGIONFD_RESP(x) ((x) << IOREGIONFD_RESP_OFFSET)

These belong in the uapi header so userspace also has struct
ioregionfd_cmd, struct ioregionfd_resp, etc.

> +
>  void
>  kvm_ioregionfd_init(struct kvm *kvm)
>  {
> @@ -38,10 +65,100 @@ ioregion_release(struct ioregion *p)
>  =09kfree(p);
>  }
> =20
> +static bool
> +pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, int opt, bool =
resp,
> +=09 u64 user_data, const void *val)
> +{
> +=09u64 size =3D 0;
> +
> +=09switch (len) {
> +=09case 1:
> +=09=09size =3D IOREGIONFD_SIZE_8BIT;
> +=09=09*((u8 *)&cmd->data) =3D val ? *(u8 *)val : 0;
> +=09=09break;
> +=09case 2:
> +=09=09size =3D IOREGIONFD_SIZE_16BIT;
> +=09=09*((u16 *)&cmd->data) =3D val ? *(u16 *)val : 0;
> +=09=09break;
> +=09case 4:
> +=09=09size =3D IOREGIONFD_SIZE_32BIT;
> +=09=09*((u32 *)&cmd->data) =3D val ? *(u32 *)val : 0;
> +=09=09break;
> +=09case 8:
> +=09=09size =3D IOREGIONFD_SIZE_64BIT;
> +=09=09*((u64 *)&cmd->data) =3D val ? *(u64 *)val : 0;
> +=09=09break;
> +=09default:
> +=09=09return false;
>

The assignments and casts can be replaced with a single memcpy after the
switch statement. This is also how KVM_EXIT_MMIO and Coalesced MMIO do
it:

  memcpy(cmd->data, val, len);

However, we need to make sure that cmd has been zeroed so that kernel
memory is not accidentally exposed to userspace.

 +=09}
> +=09cmd->user_data =3D user_data;
> +=09cmd->offset =3D offset;
> +=09cmd->info |=3D opt;
> +=09cmd->info |=3D IOREGIONFD_SIZE(size);
> +=09cmd->info |=3D IOREGIONFD_RESP(resp);
> +
> +=09return true;
> +}
> +
>  static int
>  ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t a=
ddr,
>  =09      int len, void *val)
>  {
> +=09struct ioregion *p =3D to_ioregion(this);
> +=09struct ioregionfd_cmd *cmd;
> +=09struct ioregionfd_resp *resp;
> +=09size_t buf_size;
> +=09void *buf;
> +=09int ret =3D 0;
> +
> +=09if ((p->rf->f_flags & O_NONBLOCK) || (p->wf->f_flags & O_NONBLOCK))
> +=09=09return -EINVAL;

Another CPU could change file descriptor flags while we are running.
Therefore it might be simplest to handle kernel_write() and
kernel_read() -EAGAIN return values instead of trying to check.

> +=09if ((addr + len - 1) > (p->paddr + p->size - 1))
> +=09=09return -EINVAL;
> +
> +=09buf_size =3D max_t(size_t, sizeof(*cmd), sizeof(*resp));
> +=09buf =3D kzalloc(buf_size, GFP_KERNEL);
> +=09if (!buf)
> +=09=09return -ENOMEM;
> +=09cmd =3D (struct ioregionfd_cmd *)buf;
> +=09resp =3D (struct ioregionfd_resp *)buf;

I think they are small enough to declare them on the stack:

  union {
      struct ioregionfd_cmd cmd;
      struct ioregionfd_resp resp;
  } buf;

  memset(&buf, 0, sizeof(buf));

> +=09if (!pack_cmd(cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
> +=09=09      1, p->user_data, NULL)) {
> +=09=09kfree(buf);
> +=09=09return -EOPNOTSUPP;
> +=09}
> +
> +=09ret =3D kernel_write(p->wf, cmd, sizeof(*cmd), 0);
> +=09if (ret !=3D sizeof(*cmd)) {
> +=09=09kfree(buf);
> +=09=09return (ret < 0) ? ret : -EIO;
> +=09}
> +=09memset(buf, 0, buf_size);
> +=09ret =3D kernel_read(p->rf, resp, sizeof(*resp), 0);
> +=09if (ret !=3D sizeof(*resp)) {
> +=09=09kfree(buf);
> +=09=09return (ret < 0) ? ret : -EIO;
> +=09}
> +
> +=09switch (len) {
> +=09case 1:
> +=09=09*(u8 *)val =3D (u8)resp->data;
> +=09=09break;
> +=09case 2:
> +=09=09*(u16 *)val =3D (u16)resp->data;
> +=09=09break;
> +=09case 4:
> +=09=09*(u32 *)val =3D (u32)resp->data;
> +=09=09break;
> +=09case 8:
> +=09=09*(u64 *)val =3D (u64)resp->data;
> +=09=09break;
> +=09default:
> +=09=09break;
> +=09}

This looks inconsistent. cmd->data is treated as a packed u8/u16/u32/864
whereas resp->data is treated as u64?

I was expecting memcpy(val, &resp->data, len) here not the u64 ->
u8/u16/u32/u64 conversion.

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/rGlcACgkQnKSrs4Gr
c8iRxQgAv7RtyvrVwiziibBV21NGM6PGmaFr4GYaxgGmzKIrdqJsgR44BS0blTkp
zci9bU6skiZ8c0nzLJ6r3xBxgoXvW2gh9EPvHjuFdcPuAaqLs1yDC1mLi1MnL474
noEYliyybktcHf47OPQ4hcxgxX0lnOSP9nT0NvRp1OBJr7p1ar0GOxrpvmLYwwvI
M83tBwfb23J6CKHJvX0m66R598Bi07v32LHz3frbAXLqS9qYB5v7CMrm7HaECwyW
Z4Uws71ghPfQcpyKeEtUrmHk+2D83PsEKvuQfIeFFe6JbXsPU/J2HJxZgCyDk96j
iERHQRCS+5J23pjTqsm2JCzZjWnl+g==
=M8xv
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--

