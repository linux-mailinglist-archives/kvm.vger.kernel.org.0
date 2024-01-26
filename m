Return-Path: <kvm+bounces-7171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFBD883DBD5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD9F81C23B7C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F501CF9A;
	Fri, 26 Jan 2024 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="skBFZIN8"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26BD1CF8A;
	Fri, 26 Jan 2024 14:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279163; cv=none; b=b5gCy1ED0RLf875wkM5pKeKbrWuprIDwHhaHhNNEX0dAapFFzMzDTvLXMtKbfNewuaBW+4u0M1YGqP1LhWGN3mpuWQNp8pkBCVmcBOlBnW46TBSGNst7AMdlFGlmdbX50xovdzF285Opuoeliv9MZtRgPAbUIi91Q1WCGIGAuIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279163; c=relaxed/simple;
	bh=MMWJOGLFyIv2HsMuUYdR7lGZ6WiuOxzTwoL3hj+H9yE=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=rQunvbLADDor40JSd2feyT63kMRPwTKsxp+wvNJVZL3Cfrvod+AiST2v/sMjO4tjIcy10b3SBI1taYcTu54Us4No7H/VbbR4JizNQqoAnok87Y240/srzkQx6mrZoVaWdEP6Em3oDqjkjgyPXAZwLe3ltlpDvASlL/gNyX10KRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=skBFZIN8; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240126142553euoutp0222ad5860ca0bebdac75173bbe1aca329~t69moWN6O0058000580euoutp02Q;
	Fri, 26 Jan 2024 14:25:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240126142553euoutp0222ad5860ca0bebdac75173bbe1aca329~t69moWN6O0058000580euoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706279153;
	bh=MMWJOGLFyIv2HsMuUYdR7lGZ6WiuOxzTwoL3hj+H9yE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=skBFZIN815o5BMntkpe5XDDKfAr1HK96bzp6ZPouv/LvSmIXaP4ZxSqkan7/nBt0R
	 LubEBhjChJM2NRm3GPVGNbe0lDKWC2HyDXo6m+JPD7TVI5FjEw3kISkcHuaDAmTx8g
	 Vc1VXSFNmL0UUMS0e/wnnOvrGxVhK+MFKdI/KZvQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240126142553eucas1p14693b78b6a8e3b179b1030451ce4526f~t69mZYd3R2159821598eucas1p1Q;
	Fri, 26 Jan 2024 14:25:53 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id AA.AC.09814.1F0C3B56; Fri, 26
	Jan 2024 14:25:53 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240126142553eucas1p25980a2cea2a1ab98527c132c58ae50d8~t69mBRXNX1893318933eucas1p2c;
	Fri, 26 Jan 2024 14:25:53 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240126142553eusmtrp13e5629c735b6f7a8f8d37d519441ce0a~t69mApptN0428804288eusmtrp1c;
	Fri, 26 Jan 2024 14:25:53 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-7d-65b3c0f1fc67
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id E7.EA.10702.1F0C3B56; Fri, 26
	Jan 2024 14:25:53 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240126142552eusmtip27b48e94cefa667d9c400994c93268e3a~t69luzxh33055030550eusmtip2X;
	Fri, 26 Jan 2024 14:25:52 +0000 (GMT)
Received: from localhost (106.210.248.232) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 26 Jan 2024 14:25:52 +0000
Date: Fri, 26 Jan 2024 15:25:50 +0100
From: Joel Granados <j.granados@samsung.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Kevin
	Tian <kevin.tian@intel.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>, Yi Liu
	<yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Longfang
	Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
	<iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 01/16] iommu: Move iommu fault data to linux/iommu.h
Message-ID: <20240126142550.jeq2fszun5xvjelf@localhost>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="cfolaexkjjaoso2l"
Content-Disposition: inline
In-Reply-To: <20240125134337.GN1455070@nvidia.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42LZduzned2PBzanGhyeoGSxeeJWNotfXyws
	lh5cz2LRsPoCq8WVf3sYLTpnb2C3WPp2K7vFnKmFFpd3zWGz2NSQbLH36WM2i4MfnrBatNwx
	tbh75R6jxdyf11gc+D2eHJzH5LFm3hpGj5Yjb1k9Fu95yeSxaVUnm8eda3vYPOadDPR4sXkm
	o0dv8zs2j8+b5AK4orhsUlJzMstSi/TtErgyDl3+zFTwQKBi+/0G1gbG+XxdjJwcEgImEjM+
	rmLtYuTiEBJYwSixbdFDZgjnC6PEo/WToTKfGSW2n5rDBNOy8NkLFojEckaJr883M8FV3bvS
	D9W/Fah/1yd2kBYWAVWJ1QeWMoPYbAI6Euff3AGzRQRUJE6cOMMO0sAs8IlZ4tmFo2ANwgI+
	Eu92rWQFsXkFzCX+XFsKZQtKnJz5hAXEZhaokHg06zBQnAPIlpZY/o8DJMwpYCRxsucFO8Sp
	yhLXZ76AOrtW4tSWW2CXSgi845RYeWEHK0TCRaJ9+iZmCFtY4tXxLVDNMhKnJ/ewQDRMZpTY
	/+8DO4SzmlFiWeNXqLHWEi1XnkB1OEo0fTwEdpGEAJ/EjbeCEIfySUzaNp0ZIswr0dEmBFGt
	JrH63huWCYzKs5C8NgvJa7MQXoMI60gs2P2JDUNYW2LZwtfMELatxLp171kWMLKvYhRPLS3O
	TU8tNspLLdcrTswtLs1L10vOz93ECEykp/8d/7KDcfmrj3qHGJk4GA8xqgA1P9qw+gKjFEte
	fl6qkgivienGVCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8qinyqUIC6YklqdmpqQWpRTBZJg5O
	qQam1XL/3k756LTh/8uTnRLa+b9POmbmbwj5dvETj9xp5eSQHeYGh045hi4zOM1z1eX4Op9V
	nvmP3xg4Hc2zq3zkfvq06op1mn8fm1y4tvqjlPg+oSqvZ+uUf2+aXxf/lqv/8tXZH3eUbgvU
	i9v+uzf86ERvtcYtk12+Pj4UN3nNyhPvpS5PFJjw9v3rO7+lJb+4fNqw+sjXxL7X6iJfD1pt
	F1+elKjFLlWmyKUUELndbX5dQ7/dq8c+aZvv1Oee5Tb109o9ccPrzEVzeF/UcZ41OzX/mM+J
	ZVMez970bXvM9AnHbKrr5YQ2s3jK1xjW7fgiLnn50zbvab53viQon4l7Ye5bVF1j9GCxspnW
	ljlzN2opsRRnJBpqMRcVJwIATHrsaB8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t/xe7ofD2xONWi5yG6xeeJWNotfXyws
	lh5cz2LRsPoCq8WVf3sYLTpnb2C3WPp2K7vFnKmFFpd3zWGz2NSQbLH36WM2i4MfnrBatNwx
	tbh75R6jxdyf11gc+D2eHJzH5LFm3hpGj5Yjb1k9Fu95yeSxaVUnm8eda3vYPOadDPR4sXkm
	o0dv8zs2j8+b5AK4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJz
	MstSi/TtEvQyju83LbgnUDFx5SLmBsa5fF2MnBwSAiYSC5+9YOli5OIQEljKKHHr/wEWiISM
	xMYvV1khbGGJP9e62CCKPjJK7Nr+ih3C2coosfXLTUaQKhYBVYnVB5Yyg9hsAjoS59/cAbNF
	BFQkTpw4A9bALPCBWeJ0zzl2kISwgI/Eu10rwVbwCpgDrVjKCjF1NpPEsxlP2CESghInZz4B
	u4lZoExi0tkuoG0cQLa0xPJ/HCBhTgEjiZM9L9ghTlWWuD7zBROEXSvx+e8zxgmMwrOQTJqF
	ZNIshEkQYS2JG/9eMmEIa0ssW/iaGcK2lVi37j3LAkb2VYwiqaXFuem5xUZ6xYm5xaV56XrJ
	+bmbGIGpZNuxn1t2MK589VHvECMTB+MhRhWgzkcbVl9glGLJy89LVRLhNTHdmCrEm5JYWZVa
	lB9fVJqTWnyI0RQYjBOZpUST84FJLq8k3tDMwNTQxMzSwNTSzFhJnNezoCNRSCA9sSQ1OzW1
	ILUIpo+Jg1OqgWm/v7/Pxh89OiIltue8fM5YeBq89tl1322mC7du+1PDT8VWKqacEneqrjwN
	PMez4lX6FvO663P3rIrOOKefzMz5W0hn2jc5dtdIg7D1sYG569Wy7MSrYjfIh1ccVRKJs179
	R3y2VGDx8Xl9i6oKeN26i73yJzDMTlvGZnpsZu/uWE1Zz+Lurfar9r2VKrGzeJM3b3e16J0V
	r2rEb1ZOV9vLNOHrou/v/H+t/c4dlitX9uZo995DryRbZlR87Xj1e+b0q5x8MScd5ou+jtZ+
	tumT8syOoMTcNdy3mZs9bqVwxKxxnet6ma1GZ9YZc9OZG3l/fXt92cpquVv+04jIaqdUW4aV
	2apX39QHVl29pcRSnJFoqMVcVJwIAD9VTmy6AwAA
X-CMS-MailID: 20240126142553eucas1p25980a2cea2a1ab98527c132c58ae50d8
X-Msg-Generator: CA
X-RootMTR: 20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
	<20240122054308.23901-2-baolu.lu@linux.intel.com>
	<CGME20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e@eucas1p2.samsung.com>
	<20240125091734.chekvxgof2d5zpcg@localhost>
	<20240125134337.GN1455070@nvidia.com>

--cfolaexkjjaoso2l
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 09:43:37AM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 25, 2024 at 10:17:34AM +0100, Joel Granados wrote:
> > On Mon, Jan 22, 2024 at 01:42:53PM +0800, Lu Baolu wrote:
> > > The iommu fault data is currently defined in uapi/linux/iommu.h, but =
is
> > > only used inside the iommu subsystem. Move it to linux/iommu.h, where=
 it
> > > will be more accessible to kernel drivers.
> > >=20
> > > With this done, uapi/linux/iommu.h becomes empty and can be removed f=
rom
> > > the tree.
> >=20
> > The reason for removing this [1] is that it is only being used by
> > internal code in the kernel. What happens with usespace code that have
> > used these definitions? Should we deprecate instead of just removing?
>=20
> There was never an in-tree kernel implementation. Any userspace that
> implemented this needs to decide on its own if it will continue to
> support the non-mainline kernel and provide a copy of the definitions
> itself..
>=20
> (it was a process mistake to merge a uapi header without a
> corresponding uapi implementation, sorry)
Thx.
This makes sense and its actually a good thing that we remove it.

Best
>=20
> Jason

--=20

Joel Granados

--cfolaexkjjaoso2l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWzwO4ACgkQupfNUreW
QU/0uAwAir1ZIFyTWLN4Gl6xuLdD715v4GjX2rIbKiuoopx8JXVvnFYNqNQ447CJ
miCjmXFZmCcaAzTdhkt8D7heb4jFbKPIvFB66z1ZUfWrapacs+/zDvFzBivwmFwR
0k43yQN/LkWuQq5hLZVPQ7ZXMeUJAeVz/tMTOZbORvoAGkIZBT/cWbXQIsmTGSNd
nY+dGerPPMBWPDk0XJCFDY52wTirS1IveWxUP21ZfFXEZWLxhrAuX8bSEMgC4zIA
8pi2HJX8it7fFAg4ZXf7ZaNKskzR77rxjSt6DYkTApj0lDukEcG6Y2oo1zvwCD5V
fc7nUcPQ65oIBEDgtBlIxK3y2XmFmUEQZOax11+S9qUuhxB3dnHFM62wtdz4kohW
N76R19C4+R3tEZngI1eC/FvfW6Izv+FDxOnLlC2S3roPopY2qhUHhVO3NrfAuThY
Qfdn3dYXrVjaxAooliArvF/Ut0+Ly8vOeDioeKmk5HG123kvGEPSytgEXzvjDdbi
a7pwsiZN
=VqiW
-----END PGP SIGNATURE-----

--cfolaexkjjaoso2l--

