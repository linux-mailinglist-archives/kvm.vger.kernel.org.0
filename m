Return-Path: <kvm+bounces-7023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA52283C7D3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 17:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 408511F217A3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CDEB129A7F;
	Thu, 25 Jan 2024 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I4gFkLXV"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CC473177;
	Thu, 25 Jan 2024 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706199990; cv=none; b=mi41jn41+SVdRGyM1HGBeLan5LJTawtOT7qdQcmCAwtZdIHLJ34Rw7/t9zAyhPtAQ4wcbzvbOrZcGXuUNOKQzIaKSf4+DEUesW0AIXk3CQR5MCNJA9VEwMv8nH97ebDwvbTMH+ATvmr82OvmeTkljc6bbqERfL7nAjX9WdmlsNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706199990; c=relaxed/simple;
	bh=sq+vNpc2v1ZO7d5QyTR+p1F2qziyRKT0MaDvaF4xvyA=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=NF9n600ySrkPlm644BrBop51CkY6np9jWXPyG4q1D7mjC+yFcezG1dPF8wa44H0UQkNfksVusZ0ZZsG52lro73y2ZvHSCq7xP8a98qaCu0k71+hkfDwaW+zhsC5zoooitNdJuXGApBY1FdPB7RQMUHrVfMEdERFkHkqqXtG3/7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=I4gFkLXV; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240125162625euoutp02bcad8415000e019dd626c998a3aaf1fd~to9jm7gNJ1553615536euoutp02Y;
	Thu, 25 Jan 2024 16:26:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240125162625euoutp02bcad8415000e019dd626c998a3aaf1fd~to9jm7gNJ1553615536euoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706199985;
	bh=jQgmW0tn9JxAk4mAbCMC4wPWgplO6EBmkYnuedszZx8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=I4gFkLXV4n676pCx3we1jqZnm+sl2exyPxtMRG6APW+8EccjO/rPo2IxkKU47U717
	 uNGftNalEqJL5VQSF0t0QkyyxwAAXC9VNvQwvNpC0rge4TBjBjs87XXC9pe+ymAfh1
	 wuM6OzoJ5bWHh5tzj0ydoxgScsXEDD2x9i6iHDEM=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240125162625eucas1p28ac2681ef0c87b3cec3c4bb8c05cca0e~to9jZHI7J3029330293eucas1p2f;
	Thu, 25 Jan 2024 16:26:25 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 24.0D.09814.1BB82B56; Thu, 25
	Jan 2024 16:26:25 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240125162625eucas1p1e9ae0f7cc7ba63f88316552048e77401~to9jCiNEv2891428914eucas1p1J;
	Thu, 25 Jan 2024 16:26:25 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240125162625eusmtrp18e33393868a277cabfc3f14609194c8c~to9jB2pC50315003150eusmtrp18;
	Thu, 25 Jan 2024 16:26:25 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-96-65b28bb10877
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 39.87.10702.1BB82B56; Thu, 25
	Jan 2024 16:26:25 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240125162624eusmtip1d75c77e68d5eb6a247ab6490d25354ef~to9iw68HI2949529495eusmtip1W;
	Thu, 25 Jan 2024 16:26:24 +0000 (GMT)
Received: from localhost (106.210.248.232) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 25 Jan 2024 16:26:24 +0000
Date: Thu, 25 Jan 2024 17:26:23 +0100
From: Joel Granados <j.granados@samsung.com>
To: Lu Baolu <baolu.lu@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin
	Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
	<kevin.tian@intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>, Yan
	Zhao <yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 16/16] iommu: Make iommu_report_device_fault()
 reutrn void
Message-ID: <20240125162623.l3hg2i5k5kyh57cc@localhost>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="hgjoc62knflwjg6w"
Content-Disposition: inline
In-Reply-To: <20240122054308.23901-17-baolu.lu@linux.intel.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSfUwTdxjH87u73h0dbY7SxF9waAQVN5UxBtttTt0WFs9lGsiWvRCIXuxZ
	UFqgFYUFNwRm1opBXqaWQRUFMVBRW0rYYDPtKiAFYdA5gcpChy+8bWirsWQ043K4mey/z/d5
	vt/n9zzJj0RllXgYma4+wGnUbEYELsZaO/39G68eM3Mxts4VtKXMitPzPpqut13G6IKmARHt
	CnQA2nC6G9C6764QdP2slaCrv82mh36oxmlzwR76x7t/4LRtbkJEF7vj6TuuMUDX+G9h71DM
	hM2IMCajCTDFjlkRc75jEmHMjTqccd/qwBnjjSTmgcUAmONFf+KM17yCsXpHscQXksVvK7iM
	9IOc5pUtu8VpT0ZrQZZtc+7C5XlRARiP1YMgElJxsMxZiumBmJRRFwFs8/kJQfgANHVfWxJe
	AEd1XtGziLPNuBRpAHCmqEj0r+tkcx0QhBXA30csBB/BqDXwzCk9yjNObYD9M+5FJkk5FQXv
	+RJ5P0odx2CRZRzwnlDqY2i/147zLKHegN+P1CACh8AbhgmMZ5TKhf5HDxF+Dkothw0Bkscg
	ait86sgWFo2EvxkeIAIfhj0tIwj/FKQKxdBbOokJjQRoO+9BBQ6FU10thMAvQmdFCSYEKgC8
	FpgjBNEE4IUjj5fGboLFromlxLuwZ/wY4LeAlBTeng0R9pTC8tZTqFCWwG+OygT3Wtg0NoOd
	AJFVz11W9dxlVf9dJpQ3wLPtj/D/ldfDC7XTqMCbYXPzX9hZQDSCZVyOVqXktLFq7lC0llVp
	c9TK6D2ZKjNY/KzOQJevDTRMPYy2A4QEdrB6Mey50jQAwjB1ppqLkEvi4q9yMomCzfuC02Tu
	0uRkcFo7WE5iEcskaxQrORmlZA9w+zkui9M86yJkUFgBclQVntJXsaqktzzvdklyyFtPdpjj
	BqeHTrw57AAzNs92c37Cwk0TEbzrM2nCwXJtr9RQqEusOZfCUpfcZFlq/LrgrXsrh62yuLWH
	j/z8VEHYCj+Mj+3e7Y/5G/l0nfN0/VzzKhPujA1osmtXBt3XfODY2eVik9b3da2++SWRf+Yu
	6ylThisqPzIvbHEXy6OHHN7uYaMjpjNcNfd+kv7Xk5+8zqT2bts/1ee533pdnvd44+f7/Mrg
	+a8vvlbKdOgH6XPbW9D2IV2WOW8yHL00Kx/cxFnG7LkpUS6rrq5nunI8bK80Mjkq5qf86q/q
	Bgbfu96IKtL20amHQqV3Xkr/pT8C06axr76MarTsP2wM2egnBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t/xu7obuzelGqx+zWyxeeJWNotfXyws
	lh5cz2LRsPoCq8WVf3sYLWbOOMFo0Tl7A7vF0rdb2S3mTC20uLxrDpvFpoZki71PH7NZHPzw
	hNWi5Y6pxd0r9xgt5v68xuIg4PHk4DwmjzXz1jB6tBx5y+qxeM9LJo9NqzrZPO5c28PmMe9k
	oMeLzTMZPXqb37F5fN4k57H1822WAO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2Pz
	WCsjUyV9O5uU1JzMstQifbsEvYz9V4+zFOy3rVjz/TBTA+N9oy5GTg4JAROJ0zvmsXQxcnEI
	CSxllFh5dA4jREJGYuOXq6wQtrDEn2tdbBBFHxklVmzsZIRwtjJKPLt6hQWkikVAVWL+9C5m
	EJtNQEfi/Js7QDYHh4iAusSzLwEg9cwCvSwSD2b2gdULC4RILGzoANvAK2AusfPWXCaQeiGB
	IokPU8ohwoISJ2c+YQEJMwuUSXxeUQ1hSkss/8cBYnIK2Ev8OFIIcaWyxPWZL5gg7FqJz3+f
	MU5gFJ6FZM4shDmzEOaAVDALaEnc+PeSCUNYW2LZwtfMELatxLp171kWMLKvYhRJLS3OTc8t
	NtIrTswtLs1L10vOz93ECEwq24793LKDceWrj3qHGJk4GA8xqgB1Ptqw+gKjFEtefl6qkgiv
	ienGVCHelMTKqtSi/Pii0pzU4kOMpsAAnMgsJZqcD0x3eSXxhmYGpoYmZpYGppZmxkrivJ4F
	HYlCAumJJanZqakFqUUwfUwcnFINTArb1jOfcl65UHZG49V/xywa32z6cCNc1fCvYHKy+wq2
	owxv9D7uNQjMuch7fjVTccwK6XPXnnUfWbZ8usvX263Lj8a2eSXzTjt64+fxY0Epr1du7Pbo
	yj/2JzPr/tzV17Q//3nD8TtEY+KDE58iHhs9/MvKXLPGqDa+RNzpxjLfvjSV1JmKmndkTx5i
	C9FhsRWZrXPg7KYXxsFPlnyWfceW+ejIYpn2tUu/9j/VKjky+0FRkNvnxv+uTWIZvwLktnYd
	m/Y/otxt6meWHAt9hvKQVRY58vaq08Rm9L6b0BVseJuLz+Hsw506D3veL33pqakZ03soy85K
	Y+2CxRp8a8WefguyvfnZfunOCU9TqhYqsRRnJBpqMRcVJwIA5Tkqor8DAAA=
X-CMS-MailID: 20240125162625eucas1p1e9ae0f7cc7ba63f88316552048e77401
X-Msg-Generator: CA
X-RootMTR: 20240125162625eucas1p1e9ae0f7cc7ba63f88316552048e77401
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240125162625eucas1p1e9ae0f7cc7ba63f88316552048e77401
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
	<20240122054308.23901-17-baolu.lu@linux.intel.com>
	<CGME20240125162625eucas1p1e9ae0f7cc7ba63f88316552048e77401@eucas1p1.samsung.com>

--hgjoc62knflwjg6w
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 01:43:08PM +0800, Lu Baolu wrote:
> As the iommu_report_device_fault() has been converted to auto-respond a
> page fault if it fails to enqueue it, there's no need to return a code
> in any case. Make it return void.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h                       |  5 ++---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 ++--
>  drivers/iommu/intel/svm.c                   | 19 +++++++----------
>  drivers/iommu/io-pgfault.c                  | 23 +++++++--------------
>  4 files changed, 19 insertions(+), 32 deletions(-)
>=20
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index d7b6f4017254..1ccad10e8164 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -1549,7 +1549,7 @@ struct iopf_queue *iopf_queue_alloc(const char *nam=
e);
>  void iopf_queue_free(struct iopf_queue *queue);
>  int iopf_queue_discard_partial(struct iopf_queue *queue);
>  void iopf_free_group(struct iopf_group *group);
> -int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt=
);
> +void iommu_report_device_fault(struct device *dev, struct iopf_fault *ev=
t);
>  void iopf_group_response(struct iopf_group *group,
>  			 enum iommu_page_response_code status);
>  #else
> @@ -1587,10 +1587,9 @@ static inline void iopf_free_group(struct iopf_gro=
up *group)
>  {
>  }
> =20
> -static inline int
> +static inline void
>  iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
>  {
> -	return -ENODEV;
>  }
> =20
>  static inline void iopf_group_response(struct iopf_group *group,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 42eb59cb99f4..02580364acda 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1455,7 +1455,7 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, =
u32 sid)
>  /* IRQ and event handlers */
>  static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>  {
> -	int ret;
> +	int ret =3D 0;
>  	u32 perm =3D 0;
>  	struct arm_smmu_master *master;
>  	bool ssid_valid =3D evt[0] & EVTQ_0_SSV;
> @@ -1511,7 +1511,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_devi=
ce *smmu, u64 *evt)
>  		goto out_unlock;
>  	}
> =20
> -	ret =3D iommu_report_device_fault(master->dev, &fault_evt);
> +	iommu_report_device_fault(master->dev, &fault_evt);
>  out_unlock:
>  	mutex_unlock(&smmu->streams_mutex);
>  	return ret;
> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
> index 2f8716636dbb..b644d57da841 100644
> --- a/drivers/iommu/intel/svm.c
> +++ b/drivers/iommu/intel/svm.c
> @@ -561,14 +561,11 @@ static int prq_to_iommu_prot(struct page_req_dsc *r=
eq)
>  	return prot;
>  }
> =20
> -static int intel_svm_prq_report(struct intel_iommu *iommu, struct device=
 *dev,
> -				struct page_req_dsc *desc)
> +static void intel_svm_prq_report(struct intel_iommu *iommu, struct devic=
e *dev,
> +				 struct page_req_dsc *desc)
>  {
>  	struct iopf_fault event =3D { };
> =20
> -	if (!dev || !dev_is_pci(dev))
> -		return -ENODEV;
> -
>  	/* Fill in event data for device specific processing */
>  	event.fault.type =3D IOMMU_FAULT_PAGE_REQ;
>  	event.fault.prm.addr =3D (u64)desc->addr << VTD_PAGE_SHIFT;
> @@ -601,7 +598,7 @@ static int intel_svm_prq_report(struct intel_iommu *i=
ommu, struct device *dev,
>  		event.fault.prm.private_data[0] =3D ktime_to_ns(ktime_get());
>  	}
> =20
> -	return iommu_report_device_fault(dev, &event);
> +	iommu_report_device_fault(dev, &event);
>  }
> =20
>  static void handle_bad_prq_event(struct intel_iommu *iommu,
> @@ -704,12 +701,10 @@ static irqreturn_t prq_event_thread(int irq, void *=
d)
>  		if (!pdev)
>  			goto bad_req;
> =20
> -		if (intel_svm_prq_report(iommu, &pdev->dev, req))
> -			handle_bad_prq_event(iommu, req, QI_RESP_INVALID);
> -		else
> -			trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
> -					 req->priv_data[0], req->priv_data[1],
> -					 iommu->prq_seq_number++);
> +		intel_svm_prq_report(iommu, &pdev->dev, req);
> +		trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
> +				 req->priv_data[0], req->priv_data[1],
> +				 iommu->prq_seq_number++);
>  		pci_dev_put(pdev);
>  prq_advance:
>  		head =3D (head + sizeof(*req)) & PRQ_RING_MASK;
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index 6e63e5a02884..b64229dab976 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -179,23 +179,21 @@ static struct iopf_group *iopf_group_alloc(struct i=
ommu_fault_param *iopf_param,
>   *
>   * Return: 0 on success and <0 on error.
>   */
Should you remove the documentation that describes the return also?

> -int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
> +void iommu_report_device_fault(struct device *dev, struct iopf_fault *ev=
t)
>  {
>  	struct iommu_fault *fault =3D &evt->fault;
>  	struct iommu_fault_param *iopf_param;
>  	struct iopf_group abort_group =3D {};
>  	struct iopf_group *group;
> -	int ret;
> =20
>  	iopf_param =3D iopf_get_dev_fault_param(dev);
>  	if (WARN_ON(!iopf_param))
> -		return -ENODEV;
> +		return;
> =20
>  	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
> -		ret =3D report_partial_fault(iopf_param, fault);
> +		report_partial_fault(iopf_param, fault);
>  		iopf_put_dev_fault_param(iopf_param);
>  		/* A request that is not the last does not need to be ack'd */
> -		return ret;
>  	}
> =20
>  	/*
> @@ -207,25 +205,21 @@ int iommu_report_device_fault(struct device *dev, s=
truct iopf_fault *evt)
>  	 * leaving, otherwise partial faults will be stuck.
>  	 */
>  	group =3D iopf_group_alloc(iopf_param, evt, &abort_group);
> -	if (group =3D=3D &abort_group) {
> -		ret =3D -ENOMEM;
> +	if (group =3D=3D &abort_group)
>  		goto err_abort;
> -	}
> =20
>  	group->domain =3D get_domain_for_iopf(dev, fault);
> -	if (!group->domain) {
> -		ret =3D -EINVAL;
> +	if (!group->domain)
>  		goto err_abort;
> -	}
> =20
>  	/*
>  	 * On success iopf_handler must call iopf_group_response() and
>  	 * iopf_free_group()
>  	 */
> -	ret =3D group->domain->iopf_handler(group);
> -	if (ret)
> +	if (group->domain->iopf_handler(group))
>  		goto err_abort;
> -	return 0;
> +
> +	return;
> =20
>  err_abort:
>  	iopf_group_response(group, IOMMU_PAGE_RESP_FAILURE);
> @@ -233,7 +227,6 @@ int iommu_report_device_fault(struct device *dev, str=
uct iopf_fault *evt)
>  		__iopf_free_group(group);
>  	else
>  		iopf_free_group(group);
> -	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_report_device_fault);
> =20
> --=20
> 2.34.1
>=20

--=20

Joel Granados

--hgjoc62knflwjg6w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWyi60ACgkQupfNUreW
QU/cXwv/WTYpxuukYeG1ULXhsDflDlE9WKL3NptK5ter/s3pTuIn84oUoimE8JSW
3kOtDV2Eepa9MtZ4wvm8ZeXzf4XXnitUnZTL3hdAxOexe6YuzDwIVKhyXLSTAfI2
C2jkaEKBT3UfREjzmsA7Ku7XTmzjKGuTwcwmJOdF5zI3SHPMcDD4cPDG/siWrt+Y
rI49Q4olNhoaO4OfCygFKgZqTRPO2fnYz+p5L932Yk3cETYunxw7IqBWL+cVfWvX
GhGxrul9DyTdczJs0ZuYooG9rHnij/XpkNyl9QrcWc9S4m6o9taVEq/H1Sf4C3fO
zEBuyjmH1Mlr1mcQ4ANFls8GZiMzUamJw3RW8jGooEjH9pgF5UeDTMdtdAT8Bxtj
ifUiQurIAqbhxA+2Ea3qZQG/hfl/KLn/EtSRz3HsGkGLSi7S/+NM/wHC63mFzCtc
XSjgwI73labQHTg1rJn3Rcmxlu5TqmjB/C+vrqzlWf4yj725ZjCwn8rpicpO/Lf1
mCOfum9j
=qbta
-----END PGP SIGNATURE-----

--hgjoc62knflwjg6w--

