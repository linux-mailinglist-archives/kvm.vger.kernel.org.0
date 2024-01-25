Return-Path: <kvm+bounces-6993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D64C83BD0B
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 10:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2F5E1F24441
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7DB1BDED;
	Thu, 25 Jan 2024 09:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nFtekYtH"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7D91BDCA;
	Thu, 25 Jan 2024 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706174262; cv=none; b=j2xtw1vGu+YWfZbBDU1dPKFRgLxn4dNeHwS/3s/w2zlVh0DRA8hZOKMZrG91zFH2KmMhnbi7hGlZx8sLDer04qAvBkNXmMC1y4y0RPglA6+vSmaXikMNIi1xDIaQ7x4El+2kQ1I2o27BCrjwdlOvNuhYl+9KCnhG89H1k6QFiao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706174262; c=relaxed/simple;
	bh=LkFw2lQ2MhR9ap42XqcCer8OoGdAQl+p5jk0VN/bJeU=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=UKFc8HAlfRxijZU/UlwGueFaqsmbQs/7rd12I6BVu1GmNNawYK1ok3aYmv/harM7EZAx+7UhHUHFurhY4oqxffPGxGQtvfXi6bSWnOBbZnHW4yG4hEaa3zw7GsrS/VuaVElOAnPS4RZ7uuF6Y0eat8zATT7cO/2WTMFCBYCTJ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nFtekYtH; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240125091737euoutp0105d5b147dd13b28f401bac0746a4fcde~tjHKoEvum0752507525euoutp01k;
	Thu, 25 Jan 2024 09:17:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240125091737euoutp0105d5b147dd13b28f401bac0746a4fcde~tjHKoEvum0752507525euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706174257;
	bh=teHYgSCUooWBrEnHdqZGBMyyh6RTtlFQfLjVtNOf0/A=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=nFtekYtHt0C4M7GrVDsjltvKYLd4UPvwM+q/ERytuLQFQBJf54oTePzKyaiFQOJuG
	 tr+lJ1lgOsZhPhwWwws0H+KI0kJhmE5RaLMk0z0CmY433L3HbqYPZP4itAuIOXF3Ot
	 7ySakTRm3UkIoOQ1n0MrbHoF8B3bR3puHD7NFtho=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240125091737eucas1p2da7319fdae412a206899c70e16e9b8ad~tjHKZIowp0307703077eucas1p29;
	Thu, 25 Jan 2024 09:17:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 90.82.09539.13722B56; Thu, 25
	Jan 2024 09:17:37 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e~tjHJ7zA-A3072330723eucas1p2L;
	Thu, 25 Jan 2024 09:17:37 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240125091737eusmtrp160254e50628dda9db36b687e5a0ddd0d~tjHJ69--m0309303093eusmtrp1f;
	Thu, 25 Jan 2024 09:17:37 +0000 (GMT)
X-AuditID: cbfec7f2-52bff70000002543-a6-65b22731f0ad
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id D2.06.09146.13722B56; Thu, 25
	Jan 2024 09:17:37 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240125091736eusmtip25c933dc01bb433bf29b24c1773bc95d5~tjHJt6dr40935209352eusmtip2J;
	Thu, 25 Jan 2024 09:17:36 +0000 (GMT)
Received: from localhost (106.210.248.232) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 25 Jan 2024 09:17:36 +0000
Date: Thu, 25 Jan 2024 10:17:34 +0100
From: Joel Granados <j.granados@samsung.com>
To: Lu Baolu <baolu.lu@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
	<kevin.tian@intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, <iommu@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Jason Gunthorpe
	<jgg@nvidia.com>
Subject: Re: [PATCH v10 01/16] iommu: Move iommu fault data to linux/iommu.h
Message-ID: <20240125091734.chekvxgof2d5zpcg@localhost>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="km2m7ceiswbggakg"
Content-Disposition: inline
In-Reply-To: <20240122054308.23901-2-baolu.lu@linux.intel.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42LZduzneV1D9U2pBnNWKFpsnriVzeLXFwuL
	pQfXs1g0rL7AanHl3x5Gi5kzTjBadM7ewG6x9O1Wdos5UwstLu+aw2axqSHZYu/Tx2wWBz88
	YbVouWNqcffKPUaLuT+vsTgIeDw5OI/JY828NYweLUfesnos3vOSyWPTqk42jzvX9rB5zDsZ
	6PFi80xGj97md2wenzfJeWz9fJslgDuKyyYlNSezLLVI3y6BK+P6tassBW/yK+69us/YwLgg
	qouRk0NCwESi6+gsNhBbSGAFo8TqNdFdjFxA9hdGibtd19khEp8ZJd5vt4VpWPn9NQtE0XJG
	iSenjyAUnb8vAZHYyihx6+J0oAQHB4uAqsT1iUEgNWwCOhLn39xhBgmLCKhLPPsSAFLOLDCZ
	ReLTg6lgVwgL+Ei827WSFcTmFTCXODvxMJQtKHFy5hMWkF5mgQqJD4vqIExpieX/OEAqOAXs
	JHbcns8McaayxPWZL5gg7FqJU1tuMYGskhD4xylx5upENoiEi8TlhZ/ZIWxhiVfHt0DZMhKn
	J/ewQDRMZpTY/+8DO4SzmlFiWeNXqLHWEi1XnkB1OEo0fTzECnKRhACfxI23giBhZiBz0rbp
	zBBhXomONiGIajWJ1ffesExgVJ6F5LNZCJ/NQvhsFtgcHYkFuz+xYQhrSyxb+JoZwraVWLfu
	PcsCRvZVjOKppcW56anFhnmp5XrFibnFpXnpesn5uZsYgen09L/jn3Ywzn31Ue8QIxMH4yFG
	FaDmRxtWX2CUYsnLz0tVEuE1Md2YKsSbklhZlVqUH19UmpNafIhRmoNFSZxXNUU+VUggPbEk
	NTs1tSC1CCbLxMEp1cDk6ftF7/8lZ85PQjJZ7dxKEUECISZXmk5aBIiZNR24s5g7UCc96+ej
	NL9fBRoLP18PLJvlyblkxx0O69W/Vl3JU7TdOXu+eXJeh/fsQ1/Nm5X2fJSanPbqeOr5wn2m
	P1/bfEqJbRW9Ez1Ncofta9+P/g7zDtzKCXr+SUbe8tWl8CKev5KbHmpdq1mSacf556+OzgvW
	YJkN8RP+dD5uVE3P/ea8ZXWTrmuMA+ezCyqcmm5nzn/f/Lf5+7FgfiuO73JFVq9+5jwvCvJo
	OvFS/sn8D0c0bstd+r54zt0501ptNsX4ys+rnVko829W71/ZpbtExZ6+MxYQndlaICDp8T4r
	T+JF/EzVteyq2oE7uEqUWIozEg21mIuKEwEsOfiUIgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t/xe7qG6ptSDc5dYbHYPHErm8WvLxYW
	Sw+uZ7FoWH2B1eLKvz2MFjNnnGC06Jy9gd1i6dut7BZzphZaXN41h81iU0Oyxd6nj9ksDn54
	wmrRcsfU4u6Ve4wWc39eY3EQ8HhycB6Tx5p5axg9Wo68ZfVYvOclk8emVZ1sHneu7WHzmHcy
	0OPF5pmMHr3N79g8Pm+S89j6+TZLAHeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5
	rJWRqZK+nU1Kak5mWWqRvl2CXsaZk/fYC17lV6xc1sDcwDgvqouRk0NCwERi5ffXLCC2kMBS
	RonXh3gg4jISG79cZYWwhSX+XOti62LkAqr5yCgxtecElLOVUWLdiZfMXYwcHCwCqhLXJwaB
	NLAJ6Eicf3MHLCwioC7x7EsASDmzwEQWif237jCC1AgL+Ei827USbAGvgLnE2YmHWSGOKJT4
	3jqPESIuKHFy5hOw45gFyiTmH/vFAjKTWUBaYvk/DpAwp4CdxI7b85kh7lSWuD7zBROEXSvx
	+e8zxgmMwrOQTJqFZNIshEkQYS2JG/9eMmEIa0ssW/iaGcK2lVi37j3LAkb2VYwiqaXFuem5
	xYZ6xYm5xaV56XrJ+bmbGIGJZduxn5t3MM579VHvECMTB+MhRhWgzkcbVl9glGLJy89LVRLh
	NTHdmCrEm5JYWZValB9fVJqTWnyI0RQYhhOZpUST84EpL68k3tDMwNTQxMzSwNTSzFhJnNez
	oCNRSCA9sSQ1OzW1ILUIpo+Jg1Oqgam9uepKH1955HKX09tyDgQ9Y/3p/qPLc+LCsw6sjMau
	Z2Syqlscp7V8nZp5LE99La+IfwenoSujzIkPa6MWN7K5NkqtkfNQMUjtWdrPtOLchev7S1Of
	eJ95/KVL8bxKBav6DhveSQqNiYXfs/V65yyabDBhlfD1ggfLJsnOiXuX9fZ09Tat+FvtXnN/
	6/9QFi40uB6X5e5czHz91hq7Iv1j82RKsqxEbvuvDmTzkZLSVA2rsVr37c0kv3PaZZrT1il2
	c2m2frG+Jex/Jjnk0ecyw46gX7w3LzFKHlgeNev1xWNHZFLSJrgqWkjrcJYs4eKWX2KSVqV8
	5kZz0N0d3Xo6YkemaO7zWWcRb/VYiaU4I9FQi7moOBEAyLEP08EDAAA=
X-CMS-MailID: 20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e
X-Msg-Generator: CA
X-RootMTR: 20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
	<20240122054308.23901-2-baolu.lu@linux.intel.com>
	<CGME20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e@eucas1p2.samsung.com>

--km2m7ceiswbggakg
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 01:42:53PM +0800, Lu Baolu wrote:
> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
> only used inside the iommu subsystem. Move it to linux/iommu.h, where it
> will be more accessible to kernel drivers.
>=20
> With this done, uapi/linux/iommu.h becomes empty and can be removed from
> the tree.

The reason for removing this [1] is that it is only being used by
internal code in the kernel. What happens with usespace code that have
used these definitions? Should we deprecate instead of just removing?

Best

[1] https://lore.kernel.org/all/20230711010642.19707-2-baolu.lu@linux.intel=
=2Ecom/
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  include/linux/iommu.h      | 152 +++++++++++++++++++++++++++++++++-
>  include/uapi/linux/iommu.h | 161 -------------------------------------
>  MAINTAINERS                |   1 -
>  3 files changed, 151 insertions(+), 163 deletions(-)
>  delete mode 100644 include/uapi/linux/iommu.h
>=20
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 1ea2a820e1eb..472a8ce029b1 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -14,7 +14,6 @@
>  #include <linux/err.h>
>  #include <linux/of.h>
>  #include <linux/iova_bitmap.h>
> -#include <uapi/linux/iommu.h>
> =20
>  #define IOMMU_READ	(1 << 0)
>  #define IOMMU_WRITE	(1 << 1)
> @@ -44,6 +43,157 @@ struct iommu_sva;
>  struct iommu_fault_event;
>  struct iommu_dma_cookie;
> =20
> +#define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
> +#define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> +#define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */
> +#define IOMMU_FAULT_PERM_PRIV	(1 << 3) /* privileged */
> +
> +/* Generic fault types, can be expanded IRQ remapping fault */
> +enum iommu_fault_type {
> +	IOMMU_FAULT_DMA_UNRECOV =3D 1,	/* unrecoverable fault */
> +	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
> +};
> +
> +enum iommu_fault_reason {
> +	IOMMU_FAULT_REASON_UNKNOWN =3D 0,
> +
> +	/* Could not access the PASID table (fetch caused external abort) */
> +	IOMMU_FAULT_REASON_PASID_FETCH,
> +
> +	/* PASID entry is invalid or has configuration errors */
> +	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
> +
> +	/*
> +	 * PASID is out of range (e.g. exceeds the maximum PASID
> +	 * supported by the IOMMU) or disabled.
> +	 */
> +	IOMMU_FAULT_REASON_PASID_INVALID,
> +
> +	/*
> +	 * An external abort occurred fetching (or updating) a translation
> +	 * table descriptor
> +	 */
> +	IOMMU_FAULT_REASON_WALK_EABT,
> +
> +	/*
> +	 * Could not access the page table entry (Bad address),
> +	 * actual translation fault
> +	 */
> +	IOMMU_FAULT_REASON_PTE_FETCH,
> +
> +	/* Protection flag check failed */
> +	IOMMU_FAULT_REASON_PERMISSION,
> +
> +	/* access flag check failed */
> +	IOMMU_FAULT_REASON_ACCESS,
> +
> +	/* Output address of a translation stage caused Address Size fault */
> +	IOMMU_FAULT_REASON_OOR_ADDRESS,
> +};
> +
> +/**
> + * struct iommu_fault_unrecoverable - Unrecoverable fault data
> + * @reason: reason of the fault, from &enum iommu_fault_reason
> + * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
> + * @pasid: Process Address Space ID
> + * @perm: requested permission access using by the incoming transaction
> + *        (IOMMU_FAULT_PERM_* values)
> + * @addr: offending page address
> + * @fetch_addr: address that caused a fetch abort, if any
> + */
> +struct iommu_fault_unrecoverable {
> +	__u32	reason;
> +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
> +	__u32	flags;
> +	__u32	pasid;
> +	__u32	perm;
> +	__u64	addr;
> +	__u64	fetch_addr;
> +};
> +
> +/**
> + * struct iommu_fault_page_request - Page Request data
> + * @flags: encodes whether the corresponding fields are valid and whethe=
r this
> + *         is the last page in group (IOMMU_FAULT_PAGE_REQUEST_* values).
> + *         When IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID is set, the page r=
esponse
> + *         must have the same PASID value as the page request. When it i=
s clear,
> + *         the page response should not have a PASID.
> + * @pasid: Process Address Space ID
> + * @grpid: Page Request Group Index
> + * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
> + * @addr: page address
> + * @private_data: device-specific private information
> + */
> +struct iommu_fault_page_request {
> +#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
> +#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
> +#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
> +#define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
> +	__u32	flags;
> +	__u32	pasid;
> +	__u32	grpid;
> +	__u32	perm;
> +	__u64	addr;
> +	__u64	private_data[2];
> +};
> +
> +/**
> + * struct iommu_fault - Generic fault data
> + * @type: fault type from &enum iommu_fault_type
> + * @padding: reserved for future use (should be zero)
> + * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
> + * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
> + * @padding2: sets the fault size to allow for future extensions
> + */
> +struct iommu_fault {
> +	__u32	type;
> +	__u32	padding;
> +	union {
> +		struct iommu_fault_unrecoverable event;
> +		struct iommu_fault_page_request prm;
> +		__u8 padding2[56];
> +	};
> +};
> +
> +/**
> + * enum iommu_page_response_code - Return status of fault handlers
> + * @IOMMU_PAGE_RESP_SUCCESS: Fault has been handled and the page tables
> + *	populated, retry the access. This is "Success" in PCI PRI.
> + * @IOMMU_PAGE_RESP_FAILURE: General error. Drop all subsequent faults f=
rom
> + *	this device if possible. This is "Response Failure" in PCI PRI.
> + * @IOMMU_PAGE_RESP_INVALID: Could not handle this fault, don't retry the
> + *	access. This is "Invalid Request" in PCI PRI.
> + */
> +enum iommu_page_response_code {
> +	IOMMU_PAGE_RESP_SUCCESS =3D 0,
> +	IOMMU_PAGE_RESP_INVALID,
> +	IOMMU_PAGE_RESP_FAILURE,
> +};
> +
> +/**
> + * struct iommu_page_response - Generic page response information
> + * @argsz: User filled size of this data
> + * @version: API version of this structure
> + * @flags: encodes whether the corresponding fields are valid
> + *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
> + * @pasid: Process Address Space ID
> + * @grpid: Page Request Group Index
> + * @code: response code from &enum iommu_page_response_code
> + */
> +struct iommu_page_response {
> +	__u32	argsz;
> +#define IOMMU_PAGE_RESP_VERSION_1	1
> +	__u32	version;
> +#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
> +	__u32	flags;
> +	__u32	pasid;
> +	__u32	grpid;
> +	__u32	code;
> +};
> +
> +
>  /* iommu fault flags */
>  #define IOMMU_FAULT_READ	0x0
>  #define IOMMU_FAULT_WRITE	0x1
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> deleted file mode 100644
> index 65d8b0234f69..000000000000
> --- a/include/uapi/linux/iommu.h
> +++ /dev/null
> @@ -1,161 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/*
> - * IOMMU user API definitions
> - */
> -
> -#ifndef _UAPI_IOMMU_H
> -#define _UAPI_IOMMU_H
> -
> -#include <linux/types.h>
> -
> -#define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
> -#define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> -#define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */
> -#define IOMMU_FAULT_PERM_PRIV	(1 << 3) /* privileged */
> -
> -/* Generic fault types, can be expanded IRQ remapping fault */
> -enum iommu_fault_type {
> -	IOMMU_FAULT_DMA_UNRECOV =3D 1,	/* unrecoverable fault */
> -	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
> -};
> -
> -enum iommu_fault_reason {
> -	IOMMU_FAULT_REASON_UNKNOWN =3D 0,
> -
> -	/* Could not access the PASID table (fetch caused external abort) */
> -	IOMMU_FAULT_REASON_PASID_FETCH,
> -
> -	/* PASID entry is invalid or has configuration errors */
> -	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
> -
> -	/*
> -	 * PASID is out of range (e.g. exceeds the maximum PASID
> -	 * supported by the IOMMU) or disabled.
> -	 */
> -	IOMMU_FAULT_REASON_PASID_INVALID,
> -
> -	/*
> -	 * An external abort occurred fetching (or updating) a translation
> -	 * table descriptor
> -	 */
> -	IOMMU_FAULT_REASON_WALK_EABT,
> -
> -	/*
> -	 * Could not access the page table entry (Bad address),
> -	 * actual translation fault
> -	 */
> -	IOMMU_FAULT_REASON_PTE_FETCH,
> -
> -	/* Protection flag check failed */
> -	IOMMU_FAULT_REASON_PERMISSION,
> -
> -	/* access flag check failed */
> -	IOMMU_FAULT_REASON_ACCESS,
> -
> -	/* Output address of a translation stage caused Address Size fault */
> -	IOMMU_FAULT_REASON_OOR_ADDRESS,
> -};
> -
> -/**
> - * struct iommu_fault_unrecoverable - Unrecoverable fault data
> - * @reason: reason of the fault, from &enum iommu_fault_reason
> - * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
> - * @pasid: Process Address Space ID
> - * @perm: requested permission access using by the incoming transaction
> - *        (IOMMU_FAULT_PERM_* values)
> - * @addr: offending page address
> - * @fetch_addr: address that caused a fetch abort, if any
> - */
> -struct iommu_fault_unrecoverable {
> -	__u32	reason;
> -#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
> -#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
> -#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	perm;
> -	__u64	addr;
> -	__u64	fetch_addr;
> -};
> -
> -/**
> - * struct iommu_fault_page_request - Page Request data
> - * @flags: encodes whether the corresponding fields are valid and whethe=
r this
> - *         is the last page in group (IOMMU_FAULT_PAGE_REQUEST_* values).
> - *         When IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID is set, the page r=
esponse
> - *         must have the same PASID value as the page request. When it i=
s clear,
> - *         the page response should not have a PASID.
> - * @pasid: Process Address Space ID
> - * @grpid: Page Request Group Index
> - * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
> - * @addr: page address
> - * @private_data: device-specific private information
> - */
> -struct iommu_fault_page_request {
> -#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
> -#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
> -#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
> -#define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	perm;
> -	__u64	addr;
> -	__u64	private_data[2];
> -};
> -
> -/**
> - * struct iommu_fault - Generic fault data
> - * @type: fault type from &enum iommu_fault_type
> - * @padding: reserved for future use (should be zero)
> - * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
> - * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
> - * @padding2: sets the fault size to allow for future extensions
> - */
> -struct iommu_fault {
> -	__u32	type;
> -	__u32	padding;
> -	union {
> -		struct iommu_fault_unrecoverable event;
> -		struct iommu_fault_page_request prm;
> -		__u8 padding2[56];
> -	};
> -};
> -
> -/**
> - * enum iommu_page_response_code - Return status of fault handlers
> - * @IOMMU_PAGE_RESP_SUCCESS: Fault has been handled and the page tables
> - *	populated, retry the access. This is "Success" in PCI PRI.
> - * @IOMMU_PAGE_RESP_FAILURE: General error. Drop all subsequent faults f=
rom
> - *	this device if possible. This is "Response Failure" in PCI PRI.
> - * @IOMMU_PAGE_RESP_INVALID: Could not handle this fault, don't retry the
> - *	access. This is "Invalid Request" in PCI PRI.
> - */
> -enum iommu_page_response_code {
> -	IOMMU_PAGE_RESP_SUCCESS =3D 0,
> -	IOMMU_PAGE_RESP_INVALID,
> -	IOMMU_PAGE_RESP_FAILURE,
> -};
> -
> -/**
> - * struct iommu_page_response - Generic page response information
> - * @argsz: User filled size of this data
> - * @version: API version of this structure
> - * @flags: encodes whether the corresponding fields are valid
> - *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
> - * @pasid: Process Address Space ID
> - * @grpid: Page Request Group Index
> - * @code: response code from &enum iommu_page_response_code
> - */
> -struct iommu_page_response {
> -	__u32	argsz;
> -#define IOMMU_PAGE_RESP_VERSION_1	1
> -	__u32	version;
> -#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
> -	__u32	flags;
> -	__u32	pasid;
> -	__u32	grpid;
> -	__u32	code;
> -};
> -
> -#endif /* _UAPI_IOMMU_H */
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8d1052fa6a69..97846088d34d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11239,7 +11239,6 @@ F:	drivers/iommu/
>  F:	include/linux/iommu.h
>  F:	include/linux/iova.h
>  F:	include/linux/of_iommu.h
> -F:	include/uapi/linux/iommu.h
> =20
>  IOMMUFD
>  M:	Jason Gunthorpe <jgg@nvidia.com>
> --=20
> 2.34.1
>=20

--=20

Joel Granados

--km2m7ceiswbggakg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWyJywACgkQupfNUreW
QU8bZQv/YwYuNXDBmh2LJqlvJvBEfut1XLiboLDc54poDAeI7BwvHwIWY8rQlihN
ZXt5cozK+aldFClX8Fm5sUJkubAb0KetWI/CtxArI0sW7FoBNZHjin9vhgYDS1Lp
6tiK3Vc2wD2gocwRakSeYfC84wqDhV2Hr1bbfaqc5neVreZWUBLWQeCo4nKiFaWn
mU3Dh70OsVlyZp5Ydwy93uTwK24GE01RbQppjOEkkVvpPXdmR6W8Hp0u66nV4YQ7
31QyRuauWfs+O42HKr/RS5UUtkSGPtgjJVWbzc4PkEzdhTOA7lJWbdXHRjIx3Z8D
IhZ5sNAOksE/vTnZ6WG6oRiEMXSWeMM9hObWhm6GcvbTprZpD+Iaq5cz/tehREid
eBgnqAp/OrZTsWJgEfSZ5xgmN574aZvdlP4MiovIBNYvmsAisur/YKFQTHFksa3G
Yn9PiUx1O44SM1Qg5f2y1bjXOghgrqmpm0MGOg9qEbLaOqPobwlm65jz744F53FM
CHe4C/zd
=aenK
-----END PGP SIGNATURE-----

--km2m7ceiswbggakg--

