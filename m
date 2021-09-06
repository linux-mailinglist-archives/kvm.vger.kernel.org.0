Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1539D401D67
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 17:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242065AbhIFPK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 11:10:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229748AbhIFPK6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 11:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630940993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LtzKtGWwneehAKg1xWNa623mlHCBRfhPPDg8mcw7gGc=;
        b=Vx641pYmlMsSHDUnzpXFiK4EHl8t8V1UN9V5M8G/uoTIPWKJPbOXiSGdeoDaWFFJi5IBTz
        R4Gog/8cAuXip4+7ipZofE0ZAKzsVC6TNanuswSfgFTY9BtZSysjlNiFd5sX1dgdnlLfUW
        E4TByBs3Chq+5GnRN1oDGLiTWXNZaBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-6mgB8yRaOjSX0P74duZTvw-1; Mon, 06 Sep 2021 11:09:52 -0400
X-MC-Unique: 6mgB8yRaOjSX0P74duZTvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0DB0107ACCA;
        Mon,  6 Sep 2021 15:09:50 +0000 (UTC)
Received: from localhost (unknown [10.39.194.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB8CE60861;
        Mon,  6 Sep 2021 15:09:46 +0000 (UTC)
Date:   Mon, 6 Sep 2021 16:09:45 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
Message-ID: <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="csgk6nvMjmlrDHYP"
Content-Disposition: inline
In-Reply-To: <20210901131434.31158-1-mgurtovoy@nvidia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--csgk6nvMjmlrDHYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
> No need to pre-allocate a big buffer for the IO SGL anymore. If a device
> has lots of deep queues, preallocation for the sg list can consume
> substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
> can be 64 or 128 and each queue's depth might be 128. This means the
> resulting preallocation for the data SGLs is big.
>=20
> Switch to runtime allocation for SGL for lists longer than 2 entries.
> This is the approach used by NVMe drivers so it should be reasonable for
> virtio block as well. Runtime SGL allocation has always been the case
> for the legacy I/O path so this is nothing new.
>=20
> The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
> support SG_CHAIN, use only runtime allocation for the SGL.
>=20
> Re-organize the setup of the IO request to fit the new sg chain
> mechanism.
>=20
> No performance degradation was seen (fio libaio engine with 16 jobs and
> 128 iodepth):
>=20
> IO size      IOPs Rand Read (before/after)         IOPs Rand Write (befor=
e/after)
> --------     ---------------------------------    -----------------------=
-----------
> 512B          318K/316K                                    329K/325K
>=20
> 4KB           323K/321K                                    353K/349K
>=20
> 16KB          199K/208K                                    250K/275K
>=20
> 128KB         36K/36.1K                                    39.2K/41.7K

I ran fio randread benchmarks with 4k, 16k, 64k, and 128k at iodepth 1,
8, and 64 on two vCPUs. The results look fine, there is no significant
regression.

iodepth=3D1 and iodepth=3D64 are very consistent. For some reason the
iodepth=3D8 has significant variance but I don't think it's the fault of
this patch.

Fio results and the Jupyter notebook export are available here (check
out benchmark.html to see the graphs):

https://gitlab.com/stefanha/virt-playbooks/-/tree/virtio-blk-sgl-allocation=
-benchmark/notebook

Guest:
- Fedora 34
- Linux v5.14
- 2 vCPUs (pinned), 4 GB RAM (single host NUMA node)
- 1 IOThread (pinned)
- virtio-blk aio=3Dnative,cache=3Dnone,format=3Draw
- QEMU 6.1.0

Host:
- RHEL 8.3
- Linux 4.18.0-240.22.1.el8_3.x86_64
- Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz
- Intel Optane DC P4800X

Stefan

--csgk6nvMjmlrDHYP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmE2LzkACgkQnKSrs4Gr
c8h0BwgAnbP4VYJvt1ymf6H3ou32GEjNCtPjI7bpZsFivdUH3cKc8D40PTEQpNdH
2IN5O1F+JbNjqckTcJO5RtUZujOiGC3wgb5SQC9rZ6Tvle5z9Hkm/wQLcEKGPKxC
bM6p2ZRqItdlIbmNzPxclcFfq9Xd9mSlhKIysn0qcc11fRPgK2PKyKk5TZDsm5fu
BoIp38N9hPv9s2MdwXqxESc0RAQPOXSDxM/oj+Kf1ExFWqYCMlvvvpKodQNox4V7
wxO6Tri40eHD2naacYZZkgTErx2ZTWgbTKuOnUh/0h9+Q6SP+JELQ1BJ3aOp0y8b
L6ksEBt6PDlMsUM3pgtGapKP0Q+5Dw==
=yo6I
-----END PGP SIGNATURE-----

--csgk6nvMjmlrDHYP--

