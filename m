Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1757940AD76
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 14:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhINMYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 08:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232554AbhINMYN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 08:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631622175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=crCMDIQfbcqlNNuWe8wMVzG0binTQZ+93JYNDaWlRUQ=;
        b=KH7Vml8bFo6kt7Fr8VHfkZMT8ehjI7s00CCICT65AWHCULNgEc1j3pojlmz4t9aCFA2muQ
        HK2NWuoAj4d0LUK/MAdsX+NSr1+o7m5yWNLWMH39699fSXd8jw69/7fMuh8qaJWlmJX5cx
        /E1oMFhSYytOHjeQrBompDyyg699QgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-A_E-DCZaMKK9c-ke32RRYw-1; Tue, 14 Sep 2021 08:22:54 -0400
X-MC-Unique: A_E-DCZaMKK9c-ke32RRYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0ED355074C;
        Tue, 14 Sep 2021 12:22:53 +0000 (UTC)
Received: from localhost (unknown [10.39.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FA1F60C7F;
        Tue, 14 Sep 2021 12:22:48 +0000 (UTC)
Date:   Tue, 14 Sep 2021 13:22:47 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
Message-ID: <YUCUF7co94CRGkGU@stefanha-x1.localdomain>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
 <692f8e81-8585-1d39-e7a4-576ae01438a1@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aGmDvTLAe56x7DHM"
Content-Disposition: inline
In-Reply-To: <692f8e81-8585-1d39-e7a4-576ae01438a1@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--aGmDvTLAe56x7DHM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 13, 2021 at 05:50:21PM +0300, Max Gurtovoy wrote:
>=20
> On 9/6/2021 6:09 PM, Stefan Hajnoczi wrote:
> > On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
> > > No need to pre-allocate a big buffer for the IO SGL anymore. If a dev=
ice
> > > has lots of deep queues, preallocation for the sg list can consume
> > > substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
> > > can be 64 or 128 and each queue's depth might be 128. This means the
> > > resulting preallocation for the data SGLs is big.
> > >=20
> > > Switch to runtime allocation for SGL for lists longer than 2 entries.
> > > This is the approach used by NVMe drivers so it should be reasonable =
for
> > > virtio block as well. Runtime SGL allocation has always been the case
> > > for the legacy I/O path so this is nothing new.
> > >=20
> > > The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
> > > support SG_CHAIN, use only runtime allocation for the SGL.
> > >=20
> > > Re-organize the setup of the IO request to fit the new sg chain
> > > mechanism.
> > >=20
> > > No performance degradation was seen (fio libaio engine with 16 jobs a=
nd
> > > 128 iodepth):
> > >=20
> > > IO size      IOPs Rand Read (before/after)         IOPs Rand Write (b=
efore/after)
> > > --------     ---------------------------------    -------------------=
---------------
> > > 512B          318K/316K                                    329K/325K
> > >=20
> > > 4KB           323K/321K                                    353K/349K
> > >=20
> > > 16KB          199K/208K                                    250K/275K
> > >=20
> > > 128KB         36K/36.1K                                    39.2K/41.7K
> > I ran fio randread benchmarks with 4k, 16k, 64k, and 128k at iodepth 1,
> > 8, and 64 on two vCPUs. The results look fine, there is no significant
> > regression.
> >=20
> > iodepth=3D1 and iodepth=3D64 are very consistent. For some reason the
> > iodepth=3D8 has significant variance but I don't think it's the fault of
> > this patch.
> >=20
> > Fio results and the Jupyter notebook export are available here (check
> > out benchmark.html to see the graphs):
> >=20
> > https://gitlab.com/stefanha/virt-playbooks/-/tree/virtio-blk-sgl-alloca=
tion-benchmark/notebook
> >=20
> > Guest:
> > - Fedora 34
> > - Linux v5.14
> > - 2 vCPUs (pinned), 4 GB RAM (single host NUMA node)
> > - 1 IOThread (pinned)
> > - virtio-blk aio=3Dnative,cache=3Dnone,format=3Draw
> > - QEMU 6.1.0
> >=20
> > Host:
> > - RHEL 8.3
> > - Linux 4.18.0-240.22.1.el8_3.x86_64
> > - Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz
> > - Intel Optane DC P4800X
> >=20
> > Stefan
>=20
> Thanks, Stefan.
>=20
> Would you like me to add some of the results in my commit msg ? or Tested=
-By
> sign ?

Thanks, there's no need to change the commit description.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Tested-by: Stefan Hajnoczi <stefanha@redhat.com>

--aGmDvTLAe56x7DHM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFAlBcACgkQnKSrs4Gr
c8irGwgAifRcb8J6P8Ki4ql4+nWOw59zpPqBsh8+wmslHwj+5Sj5x040BOGESY6V
peZCMYgqgdWV7Ckgyd/4Er+L85wo41zn7+ylsi/NqkRVnZBg7HgRTiLL7GbBX8Zz
eLYIqr4aFpRE93y/RAFbnPTU4cEGK8GnhdbLgODHrnmg+VQ8DT9Lb0Ov/1UqcB5i
+EWw4mLhlDAHOcuz0YQpiGTbKe9kvTnwTjZh+DmMi4FjH6xnyEYCq4JfFmkVLC3Q
H7TgCz5EQ5QzXDVsMR7HmYPcU0s0Fofq1dlexF2Fx7riubX7oIn6+UZnSh+XxLlL
2lswIFATfoBLB4VfjgimVUD51zOt2w==
=QoZd
-----END PGP SIGNATURE-----

--aGmDvTLAe56x7DHM--

