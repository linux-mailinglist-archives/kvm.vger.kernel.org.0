Return-Path: <kvm+bounces-7172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4289D83DBD6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 677BC1C23BA8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8C11D6A5;
	Fri, 26 Jan 2024 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uZHTa48E"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFE41D535;
	Fri, 26 Jan 2024 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279196; cv=none; b=sGcgI9fvPMXeeFAvec/nE60gNYmOFMY0MltgaoPZqtmTLms4WjIP/ThzGlOs7EVcsFuL1qjZ2dsZc9ALrmotennO6uU3PAdNNkJNDxpKyyQ+EX+OyWZXQ4sV01agZlFCoJUYuAZBqM70vAuAzAJzq0drVe5vMtkjLH0Cafs2s/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279196; c=relaxed/simple;
	bh=G2PhmLGC98EiARj7Dtek1UJ7RlcAx2g1L2bzRMsqHgk=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=Y02nzsH1nFY6dF7r7uTpPedU7pDI9rczmwLLiDDKkOV7bEbwjs2/rLTXh7AyiCRq1iz9GgU2GEsVhLLzvBuLedKu0aMHM3flX+vIIkUdfC/8ipL5dXPy/ecvTXO8rtZ9bEr0FX/taOFpjECZHHBO/MfqsUsOhm/F0sGpXR7+rmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uZHTa48E; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240126142632euoutp023ed9cc1e9f041986eb2f8019a0510b32~t6_K_JJLJ0059100591euoutp02j;
	Fri, 26 Jan 2024 14:26:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240126142632euoutp023ed9cc1e9f041986eb2f8019a0510b32~t6_K_JJLJ0059100591euoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706279192;
	bh=G2PhmLGC98EiARj7Dtek1UJ7RlcAx2g1L2bzRMsqHgk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=uZHTa48EQyVxbnhzXGg2se1NMizjrTELw0jspKXqNbkgG8sgYbOg40PqjU8DFXe3v
	 cnJdZ4uRedf8LiAhzrWD4zJen6UZq2rZiWKjiLMnbu1Yr/2fxxlT5M63FrNoWHx78+
	 9WEaTmJPr46Oye6Mg11tc8APXahQ0RNiDc9wR574=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240126142632eucas1p1e0e24ee5769474568123e0654afdafd3~t6_KxPAli0191701917eucas1p16;
	Fri, 26 Jan 2024 14:26:32 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id CF.CC.09814.811C3B56; Fri, 26
	Jan 2024 14:26:32 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240126142632eucas1p2bb5ce29b7e1d3010cfbbbc5bfac87d5c~t6_KM54tE1797917979eucas1p2k;
	Fri, 26 Jan 2024 14:26:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240126142632eusmtrp197cdadfdd4dc1da64f6b5924aa4e8cee~t6_KMMYch0459904599eusmtrp1S;
	Fri, 26 Jan 2024 14:26:32 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-0c-65b3c1182350
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 83.0B.10702.711C3B56; Fri, 26
	Jan 2024 14:26:32 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240126142631eusmtip23e649b5d8741ca8d101f43e689fd83d1~t6_J-p2Os2792127921eusmtip2l;
	Fri, 26 Jan 2024 14:26:31 +0000 (GMT)
Received: from localhost (106.210.248.232) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 26 Jan 2024 14:26:30 +0000
Date: Fri, 26 Jan 2024 15:26:26 +0100
From: Joel Granados <j.granados@samsung.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin
	Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
	<kevin.tian@intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>, Yan
	Zhao <yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 01/16] iommu: Move iommu fault data to linux/iommu.h
Message-ID: <20240126142626.4apu4wxmc3ypqmhz@localhost>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="kepxqkqwvuznsvic"
Content-Disposition: inline
In-Reply-To: <95ff904c-4731-46e2-ad3b-313811a3c2f2@linux.intel.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7djPc7oSBzenGvSfU7LYPHErm8WvLxYW
	Sw+uZ7FoWH2B1eLKvz2MFjNnnGC06Jy9gd1i6dut7BZzphZaXN41h81iU0Oyxd6nj9ksDn54
	wmrRcsfU4u6Ve4wWc39eY3EQ8HhycB6Tx5p5axg9Wo68ZfVYvOclk8emVZ1sHneu7WHzmHcy
	0OPF5pmMHr3N79g8Pm+S89j6+TZLAHcUl01Kak5mWWqRvl0CV8ajWawFK/krenZfYGtgnMrb
	xcjBISFgIvHqn00XIxeHkMAKRomD3x6xQjhfGCV6Js9jgnA+M0qsbPvM0sXICdbxfeocqMRy
	RokZR+6ywFX1PP4P1b+VUeLP7WdMIC0sAqoS588cBrPZBHQkzr+5wwxiiwioSzQ17mUDaWAW
	6GWRaN78kBEkISzgI/Fu10pWEJtXwFxixfyVLBC2oMTJmU/AbGaBColpk9Ywg3zBLCAtsfwf
	B0iYU8BZYvLVTWwQpypLXJ/5ggnCrpU4teUW2NkSAv84JXqmfGKESLhITHjxkR3CFpZ4dXwL
	lC0jcXpyDwtEw2RGif3/PrBDOKsZJZY1foUaay3RcuUJVIejRNPHQ6yQcOWTuPFWEOJQPolJ
	26YzQ4R5JTrahCCq1SRW33vDMoFReRaS12YheW0WwmsQYR2JBbs/sWEIa0ssW/iaGcK2lVi3
	7j3LAkb2VYziqaXFuempxUZ5qeV6xYm5xaV56XrJ+bmbGIGJ9fS/4192MC5/9VHvECMTB+Mh
	RhWg5kcbVl9glGLJy89LVRLhNTHdmCrEm5JYWZValB9fVJqTWnyIUZqDRUmcVzVFPlVIID2x
	JDU7NbUgtQgmy8TBKdXA1DQr36Ylouhq4id347JnkkmLX0+8qnD9zLGpe5Z5TOR8UiGvyqq4
	kbnYeM68ZU3JnfyzAx76PtKZeJv5a/atCLP3sq4lJYGvfrAZHJvgJv5reljZ83/Bzse23xDz
	mVI1gyc1Z1ryAWkOKznr5NNVe87GvpY/EZJpEbbvKm+9ml7aioMlbUuSipSnt5x87X+3bsbN
	pGNTO3UEXYVlbl56s66Xf0OIqav6Mbk5efud05Ikn1/+xaM+8yxryiFPNm1Df5mJQpNYt4ns
	j/i64u6Tx9Pd4qwZb7wId1o8PXx/1dHb1RdKS8LTlbzT1vHraSyxY5cwPaC0MeptRKTr/Wd3
	Yv64CjwuE1fxPfHU6JewEktxRqKhFnNRcSIAdH8KeicEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t/xe7oSBzenGsx9zWixeeJWNotfXyws
	lh5cz2LRsPoCq8WVf3sYLWbOOMFo0Tl7A7vF0rdb2S3mTC20uLxrDpvFpoZki71PH7NZHPzw
	hNWi5Y6pxd0r9xgt5v68xuIg4PHk4DwmjzXz1jB6tBx5y+qxeM9LJo9NqzrZPO5c28PmMe9k
	oMeLzTMZPXqb37F5fN4k57H1822WAO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2Pz
	WCsjUyV9O5uU1JzMstQifbsEvYzNT9azFyznr1i5+Rl7A+Nk3i5GTg4JAROJ71PnMIHYQgJL
	GSWudmRCxGUkNn65ygphC0v8udbF1sXIBVTzkVFi/ckPjBDOVkaJqWvPs4BUsQioSpw/cxhs
	EpuAjsT5N3eYQWwRAXWJpsa9YN3MAr0sEg9m9oE1CAv4SLzbtRJsBa+AucSK+StZIKauYZJo
	/T2ZBSIhKHFy5hMwm1mgTOLaqj9AqzmAbGmJ5f84QMKcAs4Sk69uYoM4VVni+swXTBB2rcTn
	v88YJzAKz0IyaRaSSbMQJkGEtSRu/HvJhCGsLbFs4WtmCNtWYt269ywLGNlXMYqklhbnpucW
	G+kVJ+YWl+al6yXn525iBKaXbcd+btnBuPLVR71DjEwcjIcYVYA6H21YfYFRiiUvPy9VSYTX
	xHRjqhBvSmJlVWpRfnxRaU5q8SFGU2AwTmSWEk3OBya+vJJ4QzMDU0MTM0sDU0szYyVxXs+C
	jkQhgfTEktTs1NSC1CKYPiYOTqkGJiWxLXOaCiwel96fuPFYaYF/o+Uulrg1cYJKHG4rRB93
	vprGy2dQfubzeUXfufxRL0OE43Wv62TWKEz/tzVPqKPKiGnm2y33pmYu7RVJib/Gv/m43aO9
	V6YcTtM/JBr1dvnOI8Fy5sv5ii0XxAe8+tUh9UMslM2s5z77c/Yn5gpMhkbZdrPP8/ZqrPv+
	V+rw/u2sxxuVPT/1JLIfDf2384e7z6c1thYTa98nW19gXjSL+63mEmN25438aw2MPi04tWSF
	+NyQr14Gqvunvg746/nz2VFpK60bR7V1Juev5zBsP5Gdx32seoEng4LelNwNK37+fx3AonNE
	2PZifQBXiqVSnstH29SdYScmf6lhVWIpzkg01GIuKk4EAC0w9IjEAwAA
X-CMS-MailID: 20240126142632eucas1p2bb5ce29b7e1d3010cfbbbc5bfac87d5c
X-Msg-Generator: CA
X-RootMTR: 20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
	<20240122054308.23901-2-baolu.lu@linux.intel.com>
	<CGME20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e@eucas1p2.samsung.com>
	<20240125091734.chekvxgof2d5zpcg@localhost>
	<95ff904c-4731-46e2-ad3b-313811a3c2f2@linux.intel.com>

--kepxqkqwvuznsvic
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 07:21:53PM +0800, Baolu Lu wrote:
> On 2024/1/25 17:17, Joel Granados wrote:
> > On Mon, Jan 22, 2024 at 01:42:53PM +0800, Lu Baolu wrote:
> >> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
> >> only used inside the iommu subsystem. Move it to linux/iommu.h, where =
it
> >> will be more accessible to kernel drivers.
> >>
> >> With this done, uapi/linux/iommu.h becomes empty and can be removed fr=
om
> >> the tree.
> > The reason for removing this [1] is that it is only being used by
> > internal code in the kernel. What happens with usespace code that have
> > used these definitions? Should we deprecate instead of just removing?
>=20
> The interfaces to deliver I/O page faults to user space have never been
> implemented in the Linux kernel before. Therefore, from a uAPI point of
> view, this definition is actually dead code.
thx for the explanation.
I was thinking it was something like that. Just wanted to make sure.

Best

--=20

Joel Granados

--kepxqkqwvuznsvic
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWzwRIACgkQupfNUreW
QU8AIAv/U/z6MVZy+cyG1NCYzxkxy8xooBuWMOZCurDu0a7SdV6un/4KU9r5sFyb
mdt3SKwOc86g9Zn0ZAGpxaXxAjCKCq67OqSp3sz3MPUeADEPGDYd0ousIF+W/ABq
R/NB6SF5ZGLad7tYNcbZPLtugUAz7piU75kPYY68L0/Oj4HkZ/oiXdeFYPJA4O1N
hm4Pv/4X73kq/EpWGcWGxDg7RVffwFFnaep5OFgB/39zNyZjfvT7VMMuacGAeZ0p
kCeqjKu+TsyKl+qaQJBv3oLvtSuFw6fqkPEASxRYX6Of+YI+Bx6Tqnkw/alpaWyA
tWR1U8pgunDIflngqdQN65gBhWSIJNRc4qHQP+fpG62Z2AxtzgZIJ3UMxsshA8F3
JOgewm/BMVQZBOGA5RwdidhHsgNlzDy/YkSP7e02U7dHmrwxAeb5am3QuBmxLkLQ
vgVM+k36EJGQmApfroICCsThRVsAkaeWWXUMimY11M71P0GzGiKs2ytL4t+rrWrR
mEQ5YGOe
=1qb4
-----END PGP SIGNATURE-----

--kepxqkqwvuznsvic--

