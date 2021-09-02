Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B092C3FEEF0
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 15:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345276AbhIBNsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 09:48:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345226AbhIBNsD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 09:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630590424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fNCtS0KdZQb1B+CbwtzJg7He2oOCTmFUj9S0sz1v7Nk=;
        b=TRo01cLgz3qiJ7Kxcv5+y749p7f+uKoXI712I0Ndy0KDBSQIf3qJbRhomPLOWlbhecRkD0
        +Cpnr1R0fOCLWILThZrwSjook7/u5t3J8VKp/pM+74tNXzADYA8JteeBpe4K0+elymkVuo
        EGJhmcd8VLkwTXE1mw3L1i76+E+srSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-Jr-IF8qhOO2RLTAWFXNFiw-1; Thu, 02 Sep 2021 09:45:58 -0400
X-MC-Unique: Jr-IF8qhOO2RLTAWFXNFiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AB2F8145EE;
        Thu,  2 Sep 2021 13:45:56 +0000 (UTC)
Received: from localhost (unknown [10.39.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 480795C3DF;
        Thu,  2 Sep 2021 13:45:53 +0000 (UTC)
Date:   Thu, 2 Sep 2021 14:45:52 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <YTDVkDIr5WLdlRsK@stefanha-x1.localdomain>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vesxpy2vj8JazjFf"
Content-Disposition: inline
In-Reply-To: <20210831135035.6443-1-mgurtovoy@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vesxpy2vj8JazjFf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 31, 2021 at 04:50:35PM +0300, Max Gurtovoy wrote:
> Sometimes a user would like to control the amount of IO queues to be
> created for a block device. For example, for limiting the memory
> footprint of virtio-blk devices.
>=20
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>=20
> changes from v1:
>  - use param_set_uint_minmax (from Christoph)
>  - added "Should > 0" to module description
>=20
> Note: This commit apply on top of Jens's branch for-5.15/drivers
> ---
>  drivers/block/virtio_blk.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 4b49df2dfd23..9332fc4e9b31 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -24,6 +24,22 @@
>  /* The maximum number of sg elements that fit into a virtqueue */
>  #define VIRTIO_BLK_MAX_SG_ELEMS 32768
> =20
> +static int virtblk_queue_count_set(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	return param_set_uint_minmax(val, kp, 1, nr_cpu_ids);
> +}
> +
> +static const struct kernel_param_ops queue_count_ops =3D {
> +	.set =3D virtblk_queue_count_set,
> +	.get =3D param_get_uint,
> +};
> +
> +static unsigned int num_io_queues;
> +module_param_cb(num_io_queues, &queue_count_ops, &num_io_queues, 0644);
> +MODULE_PARM_DESC(num_io_queues,
> +		 "Number of IO virt queues to use for blk device. Should > 0");
> +
>  static int major;
>  static DEFINE_IDA(vd_index_ida);
> =20
> @@ -501,7 +517,9 @@ static int init_vq(struct virtio_blk *vblk)
>  	if (err)
>  		num_vqs =3D 1;
> =20
> -	num_vqs =3D min_t(unsigned int, nr_cpu_ids, num_vqs);
> +	num_vqs =3D min_t(unsigned int,
> +			min_not_zero(num_io_queues, nr_cpu_ids),
> +			num_vqs);

If you respin, please consider calling them request queues. That's the
terminology from the VIRTIO spec and it's nice to keep it consistent.
But the purpose of num_io_queues is clear, so:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--vesxpy2vj8JazjFf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmEw1ZAACgkQnKSrs4Gr
c8ilgwgAlIOafEmW7i5SZAO2+Ms/0rz8GU5rO5BZfriDJF+tb2PTi80awwHdmw1K
L9criCNflNxb/LT6eBcdW/2xczmSQkeHLUTyA5xEvsmb940rIoSgNjrEEEajvTk8
nUS0BNUezEciYxAWaxIZcDn+0ev/WZyZKJxuokLVmJNd1aPUKg+pN694/paIKdY8
kGnIrBByZK+4ihd9VRb1zY44EVSAdPGsW3F/ko7lklIRlbEO/TKX00dEgfpscWy9
SnSaCPLvqON7/s9GZDOFetH8sCCnewa1fhAMmHWvM4jYufwJCxzE6eEDZssTAZgK
Ytb0LAQrUDnz5vMNUPRiZMH+4mqwIw==
=aE7d
-----END PGP SIGNATURE-----

--vesxpy2vj8JazjFf--

