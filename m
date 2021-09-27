Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C04141906B
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 10:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhI0IL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 04:11:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233362AbhI0IL3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 04:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632730191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l5HpZigQlfyuuUZ5v+ofmgDie9ICzyMUm/Yd5LeQNgs=;
        b=Zl0pVuaBGhKjZ91cq4sV7i64vlKU3SjFTmY+OKJVP0FR1uH6ANNnc20s1MvT+8WdUik7E9
        03Shkqvm2JL7OJXhA9REv4VDHRXmrqDmbBzmdAJyN33qSIEIzLJgk/h93oWIXYspbLH3iR
        sDiwAB4iF08tRUETnwcNVcKptLRDA1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-_aKQvTj3OGGAeQFzAmzX2g-1; Mon, 27 Sep 2021 04:09:45 -0400
X-MC-Unique: _aKQvTj3OGGAeQFzAmzX2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4518010168C3;
        Mon, 27 Sep 2021 08:09:44 +0000 (UTC)
Received: from localhost (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4750C6B54F;
        Mon, 27 Sep 2021 08:09:41 +0000 (UTC)
Date:   Mon, 27 Sep 2021 10:09:40 +0200
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, oren@nvidia.com, nitzanc@nvidia.com,
        israelr@nvidia.com, hch@infradead.org, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 2/2] virtio-blk: set NUMA affinity for a tagset
Message-ID: <YVF8RBZSaJs9BScd@stefanha-x1.localdomain>
References: <20210926145518.64164-1-mgurtovoy@nvidia.com>
 <20210926145518.64164-2-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fF+gM4A/h2gK2jIm"
Content-Disposition: inline
In-Reply-To: <20210926145518.64164-2-mgurtovoy@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--fF+gM4A/h2gK2jIm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 26, 2021 at 05:55:18PM +0300, Max Gurtovoy wrote:
> To optimize performance, set the affinity of the block device tagset
> according to the virtio device affinity.
>=20
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/block/virtio_blk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 9b3bd083b411..1c68c3e0ebf9 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -774,7 +774,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
>  	vblk->tag_set.ops =3D &virtio_mq_ops;
>  	vblk->tag_set.queue_depth =3D queue_depth;
> -	vblk->tag_set.numa_node =3D NUMA_NO_NODE;
> +	vblk->tag_set.numa_node =3D virtio_dev_to_node(vdev);
>  	vblk->tag_set.flags =3D BLK_MQ_F_SHOULD_MERGE;
>  	vblk->tag_set.cmd_size =3D
>  		sizeof(struct virtblk_req) +

I implemented NUMA affinity in the past and could not demonstrate a
performance improvement:
https://lists.linuxfoundation.org/pipermail/virtualization/2020-June/048248=
=2Ehtml

The pathological case is when a guest with vNUMA has the virtio-blk-pci
device on the "wrong" host NUMA node. Then memory accesses should cross
NUMA nodes. Still, it didn't seem to matter.

Please share your benchmark results. If you haven't collected data yet
you could even combine our patches to see if it helps. Thanks!

Stefan

--fF+gM4A/h2gK2jIm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFRfEMACgkQnKSrs4Gr
c8ijxgf/WJsZGMwBy3P0wAF4J4oXhH44ONmgK3OJh5n9i3QtyVEG73LkgnD5Gf9M
9NZnRYgfeYce3jD3ymDS6xk/lqY205H+O1ZYUvFo4Kn/w3hJvpstwbgMKk6sm4XB
NXsaB+0M7gsAm0HVgWzkDqanzOSLMFJZpF0Lvtj6/+9NYyRvBXbFkP6vCfLQEoQw
0YB+df/mv5UMjUXg0BxiXrMalaQ6po2bNAhBe3PmMXsVIr3wG/gyyUxyugKyZFeK
KE/I4zTmsgqO/72E5c9On7mSF5zZvQNLA00K29ENsGZbprNodTcDhqdaNhwRdSCw
SOku06A0BIXyZlgMKBqTxm8nW5XX4A==
=sWXI
-----END PGP SIGNATURE-----

--fF+gM4A/h2gK2jIm--

