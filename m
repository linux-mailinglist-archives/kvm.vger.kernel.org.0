Return-Path: <kvm+bounces-7000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCFD83BE89
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 11:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6371C20CE7
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 10:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61361CA94;
	Thu, 25 Jan 2024 10:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QDl9h4cW"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9E31CA80;
	Thu, 25 Jan 2024 10:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706178215; cv=none; b=uKlDWUmuv+iFQ/57TgnS+sbpGTYR5ReMEORagTLFKH8De72EqXm7nQwPa/0IJLJsRJZD6lJK4yb7eIctMB/CQe0t8YasWLQUkiOrY6oBkTuxi3J2eGNUrztYQDBdofDVMpVNCveKJYuBkikbjTZuo9g70lZuthET7mv+G6oYPI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706178215; c=relaxed/simple;
	bh=Ly0PqbW2oN2Opyh9CU4T7uFbAhstoUyNcMUmv9bejv0=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=dLLpP+knCj0Fo0EO+FTU1X1SkxsbpeDu+LfEVU+Tru1+LO+pDB6eqRblUIK9hjkClAvOUWQoshzP4wYHocIPqaxLyal5vpkO2d2yHw6ctEPb2dopQSubuYradwESUDA83BxiVnp5XjXMM9s/iJrhSmBmEjc+3j3H2tklDxJquSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QDl9h4cW; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240125102329euoutp0137eef922e1df916568b2d7683d0e2f8b~tkAqfmrpb1687616876euoutp01d;
	Thu, 25 Jan 2024 10:23:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240125102329euoutp0137eef922e1df916568b2d7683d0e2f8b~tkAqfmrpb1687616876euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706178209;
	bh=Ncm394Ii3OYDiiNg4FkBaNLChaaJ1n7sSj+vagiflN0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=QDl9h4cWUW3wnts/KO5svoxURrJQvmv+r+Wj+gGwxZd4vhuk3jSuKEi3VTgDl73t3
	 HO4xnWTHrYCfnsxIrkdKaHzbdulAMexZR2Ztf8bRKid8hlZQo7KXcLaHFRY3hJRCOM
	 fzxOmd0dE7V3BPf3pGcDGjpBRe7TwwtvuQcgfx4M=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240125102328eucas1p2f4be424c5e16ea6c48eef02eb1676f52~tkAqQUE0t2319823198eucas1p2b;
	Thu, 25 Jan 2024 10:23:28 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 59.33.09539.0A632B56; Thu, 25
	Jan 2024 10:23:28 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240125102328eucas1p288a2c65df13b1f60d60f363447bb8e5c~tkApwnWYS1923419234eucas1p2E;
	Thu, 25 Jan 2024 10:23:28 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240125102328eusmtrp13cbab7d9d9bccfe35f7e068ca9461055~tkApvjrdn1016510165eusmtrp1n;
	Thu, 25 Jan 2024 10:23:28 +0000 (GMT)
X-AuditID: cbfec7f2-52bff70000002543-78-65b236a0feab
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 26.C2.09146.0A632B56; Thu, 25
	Jan 2024 10:23:28 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240125102328eusmtip276b916752f476bcb1a639b8cb39af250~tkApik6bW1219912199eusmtip2Q;
	Thu, 25 Jan 2024 10:23:28 +0000 (GMT)
Received: from localhost (106.210.248.232) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 25 Jan 2024 10:23:27 +0000
Date: Thu, 25 Jan 2024 11:23:26 +0100
From: Joel Granados <j.granados@samsung.com>
To: Lu Baolu <baolu.lu@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin
	Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
	<kevin.tian@intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>, Yan
	Zhao <yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 04/16] iommu: Cleanup iopf data structure
 definitions
Message-ID: <20240125102326.rgos2wizh273rteq@localhost>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="g7md5qdsafvmcjsg"
Content-Disposition: inline
In-Reply-To: <20240122054308.23901-5-baolu.lu@linux.intel.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7djP87oLzDalGtyerGuxeeJWNotfXyws
	lh5cz2LRsPoCq8WVf3sYLWbOOMFo0Tl7A7vF0rdb2S3mTC20uLxrDpvFpoZki71PH7NZHPzw
	hNWi5Y6pxd0r9xgt5v68xuIg4PHk4DwmjzXz1jB6tBx5y+qxeM9LJo9NqzrZPO5c28PmMe9k
	oMeLzTMZPXqb37F5fN4k57H1822WAO4oLpuU1JzMstQifbsErozLPzrZCpo1K+4ecWlgnKXU
	xcjJISFgInFu+3d2EFtIYAWjxNN3El2MXED2F0aJ1f1bWSGcz4wSKybPY4HpWPR4MiNEx3JG
	iVuHpeCKtuybzQzhbGWUWHJ8DhNIFYuAqsSCdSfBdrAJ6Eicf3MHqIiDQ0RAXeLZlwCQemaB
	XhaJ5s0PwaYKC/hLTF16AKyeV8Bc4suEU2wQtqDEyZlPwK5gFqiQ+Lr8IQvIHGYBaYnl/zhA
	wpwCdhIfLtxggzhUWeL6zBdMEHatxKktt5hAdkkItHFJPL86gxEi4SKxrHsfVJGwxKvjW9gh
	bBmJ05N7WCAaJjNK7P/3gR3CWc0osazxK1SHtUTLlSdQHY4SVz8/ZwS5SEKAT+LGW0GIQ/kk
	Jm2bzgwR5pXoaBOCqFaTWH3vDcsERuVZSF6bheS1WQivQYR1JBbs/sSGIawtsWzha2YI21Zi
	3br3LAsY2VcxiqeWFuempxYb5qWW6xUn5haX5qXrJefnbmIEJtXT/45/2sE499VHvUOMTByM
	hxhVgJofbVh9gVGKJS8/L1VJhNfEdGOqEG9KYmVValF+fFFpTmrxIUZpDhYlcV7VFPlUIYH0
	xJLU7NTUgtQimCwTB6dUA1NW4t8D+1/K3hdutd2vZGQi9HNF+srlmquU5UJX9rutjn1WFdV1
	R+ufx8EIJdninD3+klaawlyNwd98L71fJtB+bp9HnRS3tnbpw4Nv2E9VxV7nu7amp+BHZdmP
	syLrZp+T/hT15b6Q6ZwfUVolumkcZrcb/qWridx4kemeZei/4fJhxXKftC0dPH/vzOW8/tAs
	sdzKkWXNMb4NB4Q8I/YYM/Qk2vw5ssOMYenHmAV6h7Y93bc+9PnzFZsfpB6vVoroLL0ZeLVm
	wSTRv2HMcfMu1K5Kc91lc+/BMqGPc9l3RTP0vn736nxVTfzS9TM2nFasXOi/dUWQjebNP1V6
	ndsMP8WsLi5clhW6qdutaZ4SS3FGoqEWc1FxIgDuZuJ5JQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t/xe7oLzDalGpzexm+xeeJWNotfXyws
	lh5cz2LRsPoCq8WVf3sYLWbOOMFo0Tl7A7vF0rdb2S3mTC20uLxrDpvFpoZki71PH7NZHPzw
	hNWi5Y6pxd0r9xgt5v68xuIg4PHk4DwmjzXz1jB6tBx5y+qxeM9LJo9NqzrZPO5c28PmMe9k
	oMeLzTMZPXqb37F5fN4k57H1822WAO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2Pz
	WCsjUyV9O5uU1JzMstQifbsEvYxZdxewFDRqVjycv5mlgXGGUhcjJ4eEgInEoseTGbsYuTiE
	BJYySmx50cACkZCR2PjlKiuELSzx51oXG0TRR0aJr6ufMUM4Wxkldm2azA5SxSKgKrFg3Ukw
	m01AR+L8mztARRwcIgLqEs++BIDUMwv0skg8mNkHtkFYwFfiSO8TJhCbV8Bc4suEU2wgtpBA
	ocSuvS9ZIeKCEidnPgGrZxYokziwbRU7yExmAWmJ5f84QMKcAnYSHy7cYIM4VFni+swXTBB2
	rcTnv88YJzAKz0IyaRaSSbMQJkGEtSRu/HvJhCGsLbFs4WtmCNtWYt269ywLGNlXMYqklhbn
	pucWG+oVJ+YWl+al6yXn525iBCaXbcd+bt7BOO/VR71DjEwcjIcYVYA6H21YfYFRiiUvPy9V
	SYTXxHRjqhBvSmJlVWpRfnxRaU5q8SFGU2AgTmSWEk3OB6a9vJJ4QzMDU0MTM0sDU0szYyVx
	Xs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGprTbedt/h0dbz7/DqZ6499HZ/qDn0u8tj3+bI5Y2
	g+HpsZd1hbF5k1KTI7ZwWjhrHcg4au4eWZU5ceuCADUl9bApHy6dvrbcbXW12mplo9ucB75N
	Obc5WKZ607bbfhnzpy6+LjFJWTTn4uKj2znO5y1+kKBvqtH27Wm63oT3S4uPynTK/TFoy6oI
	n3j+T9qqX9dPv+NdEj8noPjXFq5i7hvP3kqdEPXZLtUr/qzsQN1ct0OH11S2rL57Qo7f9MUl
	XpO/k8x2CjnuT4w6NEtVJWriFvnzC5fMaN/KJCxzQjN7SUok03u9qa8lj3y7ba2/5FmEQc/X
	htAp6r9WfGlR9Lup/zs//ssmztffXH2ZyhmVWIozEg21mIuKEwGcclQ2wwMAAA==
X-CMS-MailID: 20240125102328eucas1p288a2c65df13b1f60d60f363447bb8e5c
X-Msg-Generator: CA
X-RootMTR: 20240125102328eucas1p288a2c65df13b1f60d60f363447bb8e5c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240125102328eucas1p288a2c65df13b1f60d60f363447bb8e5c
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
	<20240122054308.23901-5-baolu.lu@linux.intel.com>
	<CGME20240125102328eucas1p288a2c65df13b1f60d60f363447bb8e5c@eucas1p2.samsung.com>

--g7md5qdsafvmcjsg
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 01:42:56PM +0800, Lu Baolu wrote:
> struct iommu_fault_page_request and struct iommu_page_response are not
> part of uAPI anymore. Convert them to data structures for kAPI.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  include/linux/iommu.h      | 27 +++++++++++----------------
>  drivers/iommu/io-pgfault.c |  1 -
>  drivers/iommu/iommu.c      |  4 ----
>  3 files changed, 11 insertions(+), 21 deletions(-)
>=20
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index c960c4fae3bc..829bcb5a8e23 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -71,12 +71,12 @@ struct iommu_fault_page_request {
>  #define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
>  #define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
>  #define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	perm;
> -	__u64	addr;
> -	__u64	private_data[2];
> +	u32	flags;
> +	u32	pasid;
> +	u32	grpid;
> +	u32	perm;
> +	u64	addr;
> +	u64	private_data[2];
>  };
> =20
>  /**
> @@ -85,7 +85,7 @@ struct iommu_fault_page_request {
>   * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
>   */
>  struct iommu_fault {
> -	__u32	type;
> +	u32 type;
>  	struct iommu_fault_page_request prm;
>  };
> =20
> @@ -106,8 +106,6 @@ enum iommu_page_response_code {
> =20
>  /**
>   * struct iommu_page_response - Generic page response information
> - * @argsz: User filled size of this data
> - * @version: API version of this structure
>   * @flags: encodes whether the corresponding fields are valid
>   *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
>   * @pasid: Process Address Space ID
> @@ -115,14 +113,11 @@ enum iommu_page_response_code {
>   * @code: response code from &enum iommu_page_response_code
>   */
>  struct iommu_page_response {
> -	__u32	argsz;
> -#define IOMMU_PAGE_RESP_VERSION_1	1
> -	__u32	version;
>  #define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	code;
> +	u32	flags;
> +	u32	pasid;
> +	u32	grpid;
> +	u32	code;
>  };
> =20
> =20
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index e5b8b9110c13..24b5545352ae 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -56,7 +56,6 @@ static int iopf_complete_group(struct device *dev, stru=
ct iopf_fault *iopf,
>  			       enum iommu_page_response_code status)
>  {
>  	struct iommu_page_response resp =3D {
> -		.version		=3D IOMMU_PAGE_RESP_VERSION_1,
>  		.pasid			=3D iopf->fault.prm.pasid,
>  		.grpid			=3D iopf->fault.prm.grpid,
>  		.code			=3D status,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 68e648b55767..b88dc3e0595c 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1494,10 +1494,6 @@ int iommu_page_response(struct device *dev,
>  	if (!param || !param->fault_param)
>  		return -EINVAL;
> =20
> -	if (msg->version !=3D IOMMU_PAGE_RESP_VERSION_1 ||
> -	    msg->flags & ~IOMMU_PAGE_RESP_PASID_VALID)
> -		return -EINVAL;
> -
I see that this function `iommu_page_response` eventually lands in
drivers/iommu/io-pgfault.c as `iopf_group_response`. But it seems that
the check for IOMMU_PAGE_RESP_PASID_VALID is dropped.

I see that after applying [1] and [2] there are only three places where
IOMMU_PAGE_RESP_PASID_VALID appears in the code: One is the definition
and the other two are just setting the value. We effectively dropped the
check. Is the drop intended? and if so, should we just get rid of
IOMMU_PAGE_RESP_PASID_VALID?

Best

[1] https://lore.kernel.org/all/20240122054308.23901-1-baolu.lu@linux.intel=
=2Ecom
[2] https://lore.kernel.org/all/20240122073903.24406-1-baolu.lu@linux.intel=
=2Ecom

>  	/* Only send response if there is a fault report pending */
>  	mutex_lock(&param->fault_param->lock);
>  	if (list_empty(&param->fault_param->faults)) {
> --=20
> 2.34.1
>=20

--=20

Joel Granados

--g7md5qdsafvmcjsg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWyNpsACgkQupfNUreW
QU+6hwv/TaKF2IQiTXor9rKsoUWbb18zSHY+9a6gb2JXmoq36LeghRmGq08Fqlhe
sfWpsfisZ1vQyMisJpmGYUjvADZAwz58CzPuJg5/mvYIQ92MzOdw9uuYtEhQ8NCn
2aBCirkZqnmgs9PT+LeOiZI27SqnJ20BYxHziHwKImO00xdF0ATVYJ0WPrC1bBrQ
2AyluVYBnJBf6eD1aBRyJhd2p+n+Vz5Khjwccg4gHD2wtlHhfaw+bxvHYG/LaTN2
GtPZlIxvszLugo10D0dJPvQT/UyWPok58qV0vs7j7n66xtQYRFC72aV2PgydIvy0
BlQd6ekUVDGKiJ3hCrelfmngenwkO7nEA3IMZizb5jFm7fJTshVyOKJ73cB9AKtr
BVfFbPV+D3a5q5hojISFuouMA0TCXjcbAVxD06LhPly6r6YqC6F2teQK2NzPmZwr
5FN7CR+oA8kYi/BNa7cjX0CWPorJZuJnNT+UEv38+EzuKfLZ3RjCpcN4iHDTorCf
ZknArIcN
=QScI
-----END PGP SIGNATURE-----

--g7md5qdsafvmcjsg--

