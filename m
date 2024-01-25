Return-Path: <kvm+bounces-7024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC3E83C7E0
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 17:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A96E1C24F33
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64DA129A7F;
	Thu, 25 Jan 2024 16:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fhTyWONQ"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2CD74E06;
	Thu, 25 Jan 2024 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706200050; cv=none; b=icgnS1DIfFj6cRpIonBRv/5X3p59zW/fBh7BqIeloFpWM0aWphz+wT17br9wQsUZs2lIl/pLMoZg9sHCoAzWblk1iOJrdj8QjnZxCsAwXWbDNouXv+DDwAXZ4h0fi5UCKNOk9W5qU86EVexTkNVJUL8E34bSof9xnF8llVtcJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706200050; c=relaxed/simple;
	bh=++9GCsWuYrrdfLGqpF5/T+IlA8Ir5+6Icu8xCPBNl/Q=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=UdZW5C4gb+yel9rPWRAnD/3V0LObx5CYIBC+sm4z+L8iCqJvSll5sjmIV55r+rlOb6YNg3I9HxjhCL7Q25bOZcryN8MA7ZwIJWS00lL/nIeKPuNxESFsXewEmH5CzR1KQy5LQkxs0Irsa4s7rzKTHnJF7qNxKKk81MahXk8eDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fhTyWONQ; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240125162724euoutp02665e622e80206c9a4acfae42f2a8aa0c~to_aP91Km1513015130euoutp02o;
	Thu, 25 Jan 2024 16:27:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240125162724euoutp02665e622e80206c9a4acfae42f2a8aa0c~to_aP91Km1513015130euoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706200044;
	bh=G6aUBS8M5a4fPWsBXXJ7z6P16dUedsvnc88Bcd1faw4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=fhTyWONQ/ngSOHrJNgOjULeEZFHWWUWJWSGC7562nY2ps2DAYUcwGntcUPYqfq0gF
	 SSdbvYDQw6SAhc5yZTSdPwy53TOhQ81C8tsFCBYFQYU09V8opRVo3y4lfaxfZkbIcA
	 1Z2uaO63ZQt8lLBK7lRJugowy0EG/u7ENAxqdx7A=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240125162724eucas1p10cab7b32d097dd19a3da38c2c4d10c98~to_Z_REIs2578225782eucas1p1m;
	Thu, 25 Jan 2024 16:27:24 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 02.F4.09539.CEB82B56; Thu, 25
	Jan 2024 16:27:24 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240125162723eucas1p2cc7562a22b8af9b46076e1c7b616531b~to_Zjz50V3235132351eucas1p29;
	Thu, 25 Jan 2024 16:27:23 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240125162723eusmtrp1a527cf104fbbaf9c3d7f987941879dd1~to_Zi82MA0378203782eusmtrp1H;
	Thu, 25 Jan 2024 16:27:23 +0000 (GMT)
X-AuditID: cbfec7f2-515ff70000002543-7e-65b28bec04cb
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 6B.A7.10702.BEB82B56; Thu, 25
	Jan 2024 16:27:23 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240125162723eusmtip11b780a14fc8393e1eb53ccbf84b26a5c~to_ZSxYVt2956329563eusmtip1X;
	Thu, 25 Jan 2024 16:27:23 +0000 (GMT)
Received: from localhost (106.210.248.232) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 25 Jan 2024 16:27:22 +0000
Date: Thu, 25 Jan 2024 17:27:21 +0100
From: Joel Granados <j.granados@samsung.com>
To: Lu Baolu <baolu.lu@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin
	Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
	<kevin.tian@intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>, Yan
	Zhao <yan.y.zhao@intel.com>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 15/16] iommu: Make iopf_group_response() return void
Message-ID: <20240125162721.yd2xejowbri5fg5r@localhost>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="4s4v2pmzby236ugh"
Content-Disposition: inline
In-Reply-To: <20240122054308.23901-16-baolu.lu@linux.intel.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7djPc7pvujelGrTdZbXYPHErm8WvLxYW
	Sw+uZ7FoWH2B1eLKvz2MFjNnnGC06Jy9gd1i6dut7BZzphZaXN41h81iU0Oyxd6nj9ksDn54
	wmrRcsfU4u6Ve4wWc39eY3EQ8HhycB6Tx5p5axg9Wo68ZfVYvOclk8emVZ1sHneu7WHzmHcy
	0OPF5pmMHr3N79g8Pm+S89j6+TZLAHcUl01Kak5mWWqRvl0CV8beRQuZCu40MVbcb9FoYDyQ
	1cXIySEhYCKxaed8li5GLg4hgRWMEnObPjFCOF8YJXqWLWGCcD4zSux4P5u9i5EDrOXgaQuI
	+HJGiRcfZyIUNWw4xwzhbGWUWDhtAiPIEhYBVYlLu96zg9hsAjoS59/cYQaZJCKgLvHsSwBI
	PbNAL4tE8+aHYPXCAj4Sb67eZwKxeQXMJX5ePgllC0qcnPmEBcRmFqiQeH/xAgvIHGYBaYnl
	/zhAwpwC9hKbP09hhvhNWeL6zBdMEHatxKktt6DsJi6Jt3t8IJ5xkdjdwgkRFpZ4dXwLO4Qt
	I3F6cg84WCQEJjNK7P/3gR3CWc0osazxK9Qga4mWK0+gOhwlVtw9ywwxlE/ixltBiDP5JCZt
	mw4V5pXoaBOCqFaTWH3vDcsERuVZSB6bheSxWQiPQYR1JBbs/sSGIawtsWzha2YI21Zi3br3
	LAsY2VcxiqeWFuempxYb5qWW6xUn5haX5qXrJefnbmIEJtXT/45/2sE499VHvUOMTByMhxhV
	gJofbVh9gVGKJS8/L1VJhNfEdGOqEG9KYmVValF+fFFpTmrxIUZpDhYlcV7VFPlUIYH0xJLU
	7NTUgtQimCwTB6dUA1NquVv6m+s3jj368ZUv9+xm5dPd/C/s/nobBQRsP8yy7FzI4akbHkSZ
	Vx3+vVn6S9xB2e5c+9uvJ7EKrOgtufUmweaJX88W7U2HY3Wbil/yczdcDUqMC7+exFzmUTv/
	013JhHBli0OPT55bdu1ZTIHq1hW1x927b9YGXIzQcLRNPNyyf96i0pR13Mu0nHX3mXV3SZl6
	t7xb6qjRKqNy0Kz4YEpuofUnO/MZl3OmNaXK/BWfHsx7bqPqpsh49/UtyosndP9U7KoQn7Mn
	TIRpX7MDu13o/kMB0o4TOT9zLq1UL1F5ca7/T5hRkinvascG/UmLxRjn7ZfZt1jiUlOK/QE3
	1xkZ/xtkri2Jm19VrMRSnJFoqMVcVJwIAMPCXpklBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t/xu7qvuzelGhydpGKxeeJWNotfXyws
	lh5cz2LRsPoCq8WVf3sYLWbOOMFo0Tl7A7vF0rdb2S3mTC20uLxrDpvFpoZki71PH7NZHPzw
	hNWi5Y6pxd0r9xgt5v68xuIg4PHk4DwmjzXz1jB6tBx5y+qxeM9LJo9NqzrZPO5c28PmMe9k
	oMeLzTMZPXqb37F5fN4k57H1822WAO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2Pz
	WCsjUyV9O5uU1JzMstQifbsEvYzbT++xFdxqYqyYu6mFsYFxX1YXIweHhICJxMHTFl2MXBxC
	AksZJf7dPsfSxcgJFJeR2PjlKiuELSzx51oXG0TRR0aJhvbzjCAJIYGtjBItzYYgNouAqsSl
	Xe/ZQWw2AR2J82/uMIMsEBFQl3j2JQCkl1mgl0Xiwcw+sAXCAj4Sb67eZwKxeQXMJX5ePskE
	MbNIouPfHHaIuKDEyZlPwOqZBcokvs04wAoyk1lAWmL5Pw6QMKeAvcTmz1OYIe5Ulrg+8wUT
	hF0r8fnvM8YJjMKzkEyahWTSLIRJEGEtiRv/XjJhCGtLLFv4mhnCtpVYt+49ywJG9lWMIqml
	xbnpucVGesWJucWleel6yfm5mxiBqWXbsZ9bdjCufPVR7xAjEwfjIUYVoM5HG1ZfYJRiycvP
	S1US4TUx3ZgqxJuSWFmVWpQfX1Sak1p8iNEUGIgTmaVEk/OBSS+vJN7QzMDU0MTM0sDU0sxY
	SZzXs6AjUUggPbEkNTs1tSC1CKaPiYNTqoHJs7w8XL/q5Y2dfissvjUWZa6a8bd2YdXTZVwf
	5v8qVZJY7n/0aW4zV8+OsH9FXfPNf8qn+73+dL/e5sjM10e2Xa+21lHpNZCSyfVs2bwl75l9
	cNLBjf73yoM7zxpLL1+zW+fzxvilK5uPqCwQTr/N8DLtw5N41onux5/ePiF5/R17S8HVirnH
	+XjurJ1q/0j3v8wMoa96Jg/O/CpK13Yx+zZtwj2fqxpGzmk/m8INJsStjFQN84q3+7za20d8
	mdVPy+vvs8KFFeMXZKm0L7m5XLI2K4l3eqVgsZ1E52SbM9blqYw8kZVzfY7wGTh2PzXSfSLW
	q2vRyR6wuUTpZJSEo8pUm1NGSn7hEiz/WpVYijMSDbWYi4oTAcoNAtLCAwAA
X-CMS-MailID: 20240125162723eucas1p2cc7562a22b8af9b46076e1c7b616531b
X-Msg-Generator: CA
X-RootMTR: 20240125162723eucas1p2cc7562a22b8af9b46076e1c7b616531b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240125162723eucas1p2cc7562a22b8af9b46076e1c7b616531b
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
	<20240122054308.23901-16-baolu.lu@linux.intel.com>
	<CGME20240125162723eucas1p2cc7562a22b8af9b46076e1c7b616531b@eucas1p2.samsung.com>

--4s4v2pmzby236ugh
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 01:43:07PM +0800, Lu Baolu wrote:
> The iopf_group_response() should return void, as nothing can do anything
> with the failure. This implies that ops->page_response() must also return
> void; this is consistent with what the drivers do. The failure paths,
> which are all integrity validations of the fault, should be WARN_ON'd,
> not return codes.
>=20
> If the iommu core fails to enqueue the fault, it should respond the fault
> directly by calling ops->page_response() instead of returning an error
> number and relying on the iommu drivers to do so. Consolidate the error
> fault handling code in the core.
>=20
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h                       |  14 +--
>  drivers/iommu/intel/iommu.h                 |   4 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  50 +++-----
>  drivers/iommu/intel/svm.c                   |  18 +--
>  drivers/iommu/io-pgfault.c                  | 132 +++++++++++---------
>  5 files changed, 99 insertions(+), 119 deletions(-)
>=20
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 48196efc9327..d7b6f4017254 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -578,9 +578,8 @@ struct iommu_ops {
>  	int (*dev_enable_feat)(struct device *dev, enum iommu_dev_features f);
>  	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
> =20
> -	int (*page_response)(struct device *dev,
> -			     struct iopf_fault *evt,
> -			     struct iommu_page_response *msg);
> +	void (*page_response)(struct device *dev, struct iopf_fault *evt,
> +			      struct iommu_page_response *msg);
> =20
>  	int (*def_domain_type)(struct device *dev);
>  	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
> @@ -1551,8 +1550,8 @@ void iopf_queue_free(struct iopf_queue *queue);
>  int iopf_queue_discard_partial(struct iopf_queue *queue);
>  void iopf_free_group(struct iopf_group *group);
>  int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt=
);
> -int iopf_group_response(struct iopf_group *group,
> -			enum iommu_page_response_code status);
> +void iopf_group_response(struct iopf_group *group,
> +			 enum iommu_page_response_code status);
>  #else
>  static inline int
>  iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
> @@ -1594,10 +1593,9 @@ iommu_report_device_fault(struct device *dev, stru=
ct iopf_fault *evt)
>  	return -ENODEV;
>  }
> =20
> -static inline int iopf_group_response(struct iopf_group *group,
> -				      enum iommu_page_response_code status)
> +static inline void iopf_group_response(struct iopf_group *group,
> +				       enum iommu_page_response_code status)
>  {
> -	return -ENODEV;
>  }
>  #endif /* CONFIG_IOMMU_IOPF */
>  #endif /* __LINUX_IOMMU_H */
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index 696d95293a69..cf9a28c7fab8 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -1079,8 +1079,8 @@ struct iommu_domain *intel_nested_domain_alloc(stru=
ct iommu_domain *parent,
>  void intel_svm_check(struct intel_iommu *iommu);
>  int intel_svm_enable_prq(struct intel_iommu *iommu);
>  int intel_svm_finish_prq(struct intel_iommu *iommu);
> -int intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
> -			    struct iommu_page_response *msg);
> +void intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
> +			     struct iommu_page_response *msg);
>  struct iommu_domain *intel_svm_domain_alloc(void);
>  void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
>  void intel_drain_pasid_prq(struct device *dev, u32 pasid);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 4e93e845458c..42eb59cb99f4 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -920,31 +920,29 @@ static int arm_smmu_cmdq_batch_submit(struct arm_sm=
mu_device *smmu,
>  	return arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmds, cmds->num, true);
>  }
> =20
> -static int arm_smmu_page_response(struct device *dev,
> -				  struct iopf_fault *unused,
> -				  struct iommu_page_response *resp)
> +static void arm_smmu_page_response(struct device *dev, struct iopf_fault=
 *unused,
> +				   struct iommu_page_response *resp)
>  {
>  	struct arm_smmu_cmdq_ent cmd =3D {0};
>  	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
>  	int sid =3D master->streams[0].id;
> =20
> -	if (master->stall_enabled) {
> -		cmd.opcode		=3D CMDQ_OP_RESUME;
> -		cmd.resume.sid		=3D sid;
> -		cmd.resume.stag		=3D resp->grpid;
> -		switch (resp->code) {
> -		case IOMMU_PAGE_RESP_INVALID:
> -		case IOMMU_PAGE_RESP_FAILURE:
> -			cmd.resume.resp =3D CMDQ_RESUME_0_RESP_ABORT;
> -			break;
> -		case IOMMU_PAGE_RESP_SUCCESS:
> -			cmd.resume.resp =3D CMDQ_RESUME_0_RESP_RETRY;
> -			break;
> -		default:
> -			return -EINVAL;
> -		}
> -	} else {
> -		return -ENODEV;
> +	if (WARN_ON(!master->stall_enabled))
> +		return;
> +
> +	cmd.opcode		=3D CMDQ_OP_RESUME;
> +	cmd.resume.sid		=3D sid;
> +	cmd.resume.stag		=3D resp->grpid;
> +	switch (resp->code) {
> +	case IOMMU_PAGE_RESP_INVALID:
> +	case IOMMU_PAGE_RESP_FAILURE:
> +		cmd.resume.resp =3D CMDQ_RESUME_0_RESP_ABORT;
> +		break;
> +	case IOMMU_PAGE_RESP_SUCCESS:
> +		cmd.resume.resp =3D CMDQ_RESUME_0_RESP_RETRY;
> +		break;
> +	default:
> +		break;
>  	}
> =20
>  	arm_smmu_cmdq_issue_cmd(master->smmu, &cmd);
> @@ -954,8 +952,6 @@ static int arm_smmu_page_response(struct device *dev,
>  	 * terminated... at some point in the future. PRI_RESP is fire and
>  	 * forget.
>  	 */
> -
> -	return 0;
>  }
> =20
>  /* Context descriptor manipulation functions */
> @@ -1516,16 +1512,6 @@ static int arm_smmu_handle_evt(struct arm_smmu_dev=
ice *smmu, u64 *evt)
>  	}
> =20
>  	ret =3D iommu_report_device_fault(master->dev, &fault_evt);
> -	if (ret && flt->type =3D=3D IOMMU_FAULT_PAGE_REQ) {
> -		/* Nobody cared, abort the access */
> -		struct iommu_page_response resp =3D {
> -			.pasid		=3D flt->prm.pasid,
> -			.grpid		=3D flt->prm.grpid,
> -			.code		=3D IOMMU_PAGE_RESP_FAILURE,
> -		};
> -		arm_smmu_page_response(master->dev, &fault_evt, &resp);
> -	}
> -
>  out_unlock:
>  	mutex_unlock(&smmu->streams_mutex);
>  	return ret;
> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
> index e1cbcb9515f0..2f8716636dbb 100644
> --- a/drivers/iommu/intel/svm.c
> +++ b/drivers/iommu/intel/svm.c
> @@ -740,9 +740,8 @@ static irqreturn_t prq_event_thread(int irq, void *d)
>  	return IRQ_RETVAL(handled);
>  }
> =20
> -int intel_svm_page_response(struct device *dev,
> -			    struct iopf_fault *evt,
> -			    struct iommu_page_response *msg)
> +void intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
> +			     struct iommu_page_response *msg)
>  {
>  	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
>  	struct intel_iommu *iommu =3D info->iommu;
> @@ -751,7 +750,6 @@ int intel_svm_page_response(struct device *dev,
>  	bool private_present;
>  	bool pasid_present;
>  	bool last_page;
> -	int ret =3D 0;
>  	u16 sid;
> =20
>  	prm =3D &evt->fault.prm;
> @@ -760,16 +758,6 @@ int intel_svm_page_response(struct device *dev,
>  	private_present =3D prm->flags & IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA;
>  	last_page =3D prm->flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
> =20
> -	if (!pasid_present) {
> -		ret =3D -EINVAL;
> -		goto out;
> -	}
> -
> -	if (prm->pasid =3D=3D 0 || prm->pasid >=3D PASID_MAX) {
> -		ret =3D -EINVAL;
> -		goto out;
> -	}
> -
>  	/*
>  	 * Per VT-d spec. v3.0 ch7.7, system software must respond
>  	 * with page group response if private data is present (PDP)
> @@ -798,8 +786,6 @@ int intel_svm_page_response(struct device *dev,
> =20
>  		qi_submit_sync(iommu, &desc, 1, 0);
>  	}
> -out:
> -	return ret;
>  }
> =20
>  static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index c22e13df84c2..6e63e5a02884 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -39,7 +39,7 @@ static void iopf_put_dev_fault_param(struct iommu_fault=
_param *fault_param)
>  		kfree_rcu(fault_param, rcu);
>  }
> =20
> -void iopf_free_group(struct iopf_group *group)
> +static void __iopf_free_group(struct iopf_group *group)
>  {
>  	struct iopf_fault *iopf, *next;
> =20
> @@ -50,6 +50,11 @@ void iopf_free_group(struct iopf_group *group)
> =20
>  	/* Pair with iommu_report_device_fault(). */
>  	iopf_put_dev_fault_param(group->fault_param);
> +}
> +
> +void iopf_free_group(struct iopf_group *group)
> +{
> +	__iopf_free_group(group);
>  	kfree(group);
>  }
>  EXPORT_SYMBOL_GPL(iopf_free_group);
> @@ -97,14 +102,49 @@ static int report_partial_fault(struct iommu_fault_p=
aram *fault_param,
>  	return 0;
>  }
> =20
> +static struct iopf_group *iopf_group_alloc(struct iommu_fault_param *iop=
f_param,
> +					   struct iopf_fault *evt,
> +					   struct iopf_group *abort_group)
> +{
> +	struct iopf_fault *iopf, *next;
> +	struct iopf_group *group;
> +
> +	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> +	if (!group) {
> +		/*
> +		 * We always need to construct the group as we need it to abort
> +		 * the request at the driver if it cfan't be handled.
> +		 */
> +		group =3D abort_group;
> +	}
> +
> +	group->fault_param =3D iopf_param;
> +	group->last_fault.fault =3D evt->fault;
> +	INIT_LIST_HEAD(&group->faults);
> +	INIT_LIST_HEAD(&group->pending_node);
> +	list_add(&group->last_fault.list, &group->faults);
> +
> +	/* See if we have partial faults for this group */
> +	mutex_lock(&iopf_param->lock);
> +	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
> +		if (iopf->fault.prm.grpid =3D=3D evt->fault.prm.grpid)
> +			/* Insert *before* the last fault */
> +			list_move(&iopf->list, &group->faults);
> +	}
> +	list_add(&group->pending_node, &iopf_param->faults);
> +	mutex_unlock(&iopf_param->lock);
> +
> +	return group;
> +}
> +
>  /**
>   * iommu_report_device_fault() - Report fault event to device driver
>   * @dev: the device
>   * @evt: fault event data
>   *
>   * Called by IOMMU drivers when a fault is detected, typically in a thre=
aded IRQ
> - * handler. When this function fails and the fault is recoverable, it is=
 the
> - * caller's responsibility to complete the fault.
> + * handler. If this function fails then ops->page_response() was called =
to
> + * complete evt if required.
>   *
>   * This module doesn't handle PCI PASID Stop Marker; IOMMU drivers must =
discard
>   * them before reporting faults. A PASID Stop Marker (LRW =3D 0b100) doe=
sn't
> @@ -143,22 +183,18 @@ int iommu_report_device_fault(struct device *dev, s=
truct iopf_fault *evt)
>  {
>  	struct iommu_fault *fault =3D &evt->fault;
>  	struct iommu_fault_param *iopf_param;
> -	struct iopf_fault *iopf, *next;
> -	struct iommu_domain *domain;
> +	struct iopf_group abort_group =3D {};
>  	struct iopf_group *group;
>  	int ret;
> =20
> -	if (fault->type !=3D IOMMU_FAULT_PAGE_REQ)
> -		return -EOPNOTSUPP;
> -
>  	iopf_param =3D iopf_get_dev_fault_param(dev);
> -	if (!iopf_param)
> +	if (WARN_ON(!iopf_param))
>  		return -ENODEV;
> =20
>  	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
>  		ret =3D report_partial_fault(iopf_param, fault);
>  		iopf_put_dev_fault_param(iopf_param);
> -
> +		/* A request that is not the last does not need to be ack'd */
>  		return ret;
>  	}
> =20
> @@ -170,56 +206,33 @@ int iommu_report_device_fault(struct device *dev, s=
truct iopf_fault *evt)
>  	 * will send a response to the hardware. We need to clean up before
>  	 * leaving, otherwise partial faults will be stuck.
>  	 */
> -	domain =3D get_domain_for_iopf(dev, fault);
> -	if (!domain) {
> +	group =3D iopf_group_alloc(iopf_param, evt, &abort_group);
> +	if (group =3D=3D &abort_group) {
> +		ret =3D -ENOMEM;
> +		goto err_abort;
> +	}
> +
> +	group->domain =3D get_domain_for_iopf(dev, fault);
> +	if (!group->domain) {
>  		ret =3D -EINVAL;
> -		goto cleanup_partial;
> +		goto err_abort;
>  	}
> =20
> -	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> -	if (!group) {
> -		ret =3D -ENOMEM;
> -		goto cleanup_partial;
> -	}
> -
> -	group->fault_param =3D iopf_param;
> -	group->last_fault.fault =3D *fault;
> -	INIT_LIST_HEAD(&group->faults);
> -	INIT_LIST_HEAD(&group->pending_node);
> -	group->domain =3D domain;
> -	list_add(&group->last_fault.list, &group->faults);
> -
> -	/* See if we have partial faults for this group */
> -	mutex_lock(&iopf_param->lock);
> -	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
> -		if (iopf->fault.prm.grpid =3D=3D fault->prm.grpid)
> -			/* Insert *before* the last fault */
> -			list_move(&iopf->list, &group->faults);
> -	}
> -	list_add(&group->pending_node, &iopf_param->faults);
> -	mutex_unlock(&iopf_param->lock);
> +	/*
> +	 * On success iopf_handler must call iopf_group_response() and
> +	 * iopf_free_group()
> +	 */
> +	ret =3D group->domain->iopf_handler(group);
> +	if (ret)
> +		goto err_abort;
> +	return 0;
> =20
> -	ret =3D domain->iopf_handler(group);
> -	if (ret) {
> -		mutex_lock(&iopf_param->lock);
> -		list_del_init(&group->pending_node);
> -		mutex_unlock(&iopf_param->lock);
> +err_abort:
> +	iopf_group_response(group, IOMMU_PAGE_RESP_FAILURE);
> +	if (group =3D=3D &abort_group)
> +		__iopf_free_group(group);
> +	else
>  		iopf_free_group(group);
> -	}
> -
> -	return ret;
> -
> -cleanup_partial:
> -	mutex_lock(&iopf_param->lock);
> -	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
> -		if (iopf->fault.prm.grpid =3D=3D fault->prm.grpid) {
> -			list_del(&iopf->list);
> -			kfree(iopf);
> -		}
> -	}
> -	mutex_unlock(&iopf_param->lock);
> -	iopf_put_dev_fault_param(iopf_param);
> -
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_report_device_fault);
> @@ -262,8 +275,8 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
>   *
>   * Return 0 on success and <0 on error.
>   */
Should you adjust the docs as well?

> -int iopf_group_response(struct iopf_group *group,
> -			enum iommu_page_response_code status)
> +void iopf_group_response(struct iopf_group *group,
> +			 enum iommu_page_response_code status)
>  {
>  	struct iommu_fault_param *fault_param =3D group->fault_param;
>  	struct iopf_fault *iopf =3D &group->last_fault;
> @@ -274,7 +287,6 @@ int iopf_group_response(struct iopf_group *group,
>  		.grpid =3D iopf->fault.prm.grpid,
>  		.code =3D status,
>  	};
> -	int ret =3D -EINVAL;
> =20
>  	if ((iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) &&
>  	    (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID))
> @@ -283,12 +295,10 @@ int iopf_group_response(struct iopf_group *group,
>  	/* Only send response if there is a fault report pending */
>  	mutex_lock(&fault_param->lock);
>  	if (!list_empty(&group->pending_node)) {
> -		ret =3D ops->page_response(dev, &group->last_fault, &resp);
> +		ops->page_response(dev, &group->last_fault, &resp);
>  		list_del_init(&group->pending_node);
>  	}
>  	mutex_unlock(&fault_param->lock);
> -
> -	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iopf_group_response);
> =20
> --=20
> 2.34.1
>=20

--=20

Joel Granados

--4s4v2pmzby236ugh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmWyi+kACgkQupfNUreW
QU8MhQv+LZ+TI6iQ5minlh6NuBV/4F1W8Gdc9iC7p1bY3CYll3M1WPhJdMtD5gGm
gn1a0aezlzabCGN2qRVKkSs0y/jIItmcFyIpodcrsjlh1P/aLamvoNqn4lNOAIap
GIUCqdB32HWjgOUU0e+0jUQ14mfT4aG4cDqniOYzoCjawSSxQwwO8SKFMACFR1K9
91x8JNOYBGa7UCQ7CEwWmBp6UkxY/KjA/pwrcVOT78YoeaEehqoGHouilrcRtm66
96zouNAicPTtGu/pfOP1XLKn/BO6ikaEfnCPJTw9/8A1i6SaABSUIJbGy1Tj7WKb
ghuw6Y36CLhU21uMMcQ6KHmE0gSrOKSDIRsqj5Woicj9cSsqpvtu5eaqhRdZ4Jkj
AEHNuzDmVhU5CnoXyd9Qz1CPEKzggAYt45dVG8ng/HBmcnCGZogM+TmqMQdCl+SJ
iLgA5fkk0U5vm9VbAIYr7Q9Q5gq/UAhD0Ge2R//ZxWv2kly5ZjoTi7CkVEdv8Sck
EnYv0psO
=xiQr
-----END PGP SIGNATURE-----

--4s4v2pmzby236ugh--

