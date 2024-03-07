Return-Path: <kvm+bounces-11276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BE6B8749AB
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12342283FD5
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82BC82871;
	Thu,  7 Mar 2024 08:33:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1513611B;
	Thu,  7 Mar 2024 08:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709800417; cv=none; b=nGZJOJI1r5YKxYSzJCh/lO01cCya/672nkGaRJg+1zjQp9kLfGgtRjCpfAZNrNrp48iUXK/PefsxLys0h2t7xriyi0DHa+xfNtl6/+AXi7aC2C1PI7im+H1rbJEPPw/ZkJqRGaJFZaDfJ7asy5n6jo33N/nF1j4qm3YU/jOyxOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709800417; c=relaxed/simple;
	bh=lLg7JIU1Vi+awB9HeY60TEEw6wU3YSZhO/DqWX24Jno=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zwxh+oeS+XyNqnNDb9iM1eibomd3peF2OKfzRzYbQ3WGAOmwB6SXo5KlHplmy8vIXBrmiwzKhrWBY/PjxTxxIPE3CnrqlATAd+L54GxfImY/W2ZEvAjZmOZkgCZs1feKfk7m9T3n+E+Xno5lvSQOf95Qe6aDHfO6XNYAtucy/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tr2XY5T89z6K980;
	Thu,  7 Mar 2024 16:29:33 +0800 (CST)
Received: from lhrpeml100003.china.huawei.com (unknown [7.191.160.210])
	by mail.maildlp.com (Postfix) with ESMTPS id D030F14058E;
	Thu,  7 Mar 2024 16:33:31 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100003.china.huawei.com (7.191.160.210) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 08:33:31 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Thu, 7 Mar 2024 08:33:31 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v3 2/4] hisi_acc_vfio_pci: Create subfunction for data
 reading
Thread-Topic: [PATCH v3 2/4] hisi_acc_vfio_pci: Create subfunction for data
 reading
Thread-Index: AQHacFYBNSLENy+FB0aT6yRD2YInZLEr8Mmg
Date: Thu, 7 Mar 2024 08:33:31 +0000
Message-ID: <63cc4710dbb94b049bc1576f743b1729@huawei.com>
References: <20240307060353.16095-1-liulongfang@huawei.com>
 <20240307060353.16095-3-liulongfang@huawei.com>
In-Reply-To: <20240307060353.16095-3-liulongfang@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



> -----Original Message-----
> From: liulongfang <liulongfang@huawei.com>
> Sent: Thursday, March 7, 2024 6:04 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v3 2/4] hisi_acc_vfio_pci: Create subfunction for data
> reading
>=20
> During the live migration process. It needs to obtain various status
> data of drivers and devices. In order to facilitate calling it in the
> debugfs function. For all operations that read data from device registers=
,
> the driver creates a subfunction.
> Also fixed the location of address data.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 55 ++++++++++---------
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  3 +
>  2 files changed, 33 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 45351be8e270..1881f3fa9266 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -486,42 +486,22 @@ static int vf_qm_load_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	return 0;
>  }
>=20
> -static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vde=
v,
> -			    struct hisi_acc_vf_migration_file *migf)
> +static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data
> *vf_data)
>  {
> -	struct acc_vf_data *vf_data =3D &migf->vf_data;
> -	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>  	struct device *dev =3D &vf_qm->pdev->dev;
>  	int ret;
>=20
> -	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
> -		/* Update state and return with match data */
> -		vf_data->vf_qm_state =3D QM_NOT_READY;
> -		hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
> -		migf->total_length =3D QM_MATCH_SIZE;
> -		return 0;
> -	}
> -
> -	vf_data->vf_qm_state =3D QM_READY;
> -	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
> -
> -	ret =3D vf_qm_cache_wb(vf_qm);
> -	if (ret) {
> -		dev_err(dev, "failed to writeback QM Cache!\n");
> -		return ret;
> -	}
> -
>  	ret =3D qm_get_regs(vf_qm, vf_data);


So this doesn't need the qm_wait_dev_not_ready(vf_qm) check above for the
debugfs ? What happens if you read when device is not ready?

>  	if (ret)
>  		return -EINVAL;
>=20
>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> -	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[1];
> +	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];

Also since there is no serialization with core migration now, what will be =
the data
returned in debugfs when there is a vf_qm_load_data() is in progress?

So I guess the intention or assumption here is that the debugfs data is onl=
y
valid when the user knows that devices not under migration process.

Is that right?

Thanks,
Shameer

>  	vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> -	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[0];
> -	vf_data->aeqe_dma =3D vf_data->qm_aeqc_dw[1];
> +	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> +	vf_data->aeqe_dma =3D vf_data-
> >qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>  	vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> -	vf_data->aeqe_dma |=3D vf_data->qm_aeqc_dw[0];
> +	vf_data->aeqe_dma |=3D vf_data-
> >qm_aeqc_dw[QM_XQC_ADDR_LOW];
>=20
>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>  	ret =3D qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> @@ -536,6 +516,31 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return -EINVAL;
>  	}
>=20
> +	return 0;
> +}
> +
> +static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vde=
v,
> +			    struct hisi_acc_vf_migration_file *migf)
> +{
> +	struct acc_vf_data *vf_data =3D &migf->vf_data;
> +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> +	int ret;
> +
> +	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
> +		/* Update state and return with match data */
> +		vf_data->vf_qm_state =3D QM_NOT_READY;
> +		hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
> +		migf->total_length =3D QM_MATCH_SIZE;
> +		return 0;
> +	}
> +
> +	vf_data->vf_qm_state =3D QM_READY;
> +	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
> +
> +	ret =3D vf_qm_read_data(vf_qm, vf_data);
> +	if (ret)
> +		return -EINVAL;
> +
>  	migf->total_length =3D sizeof(struct acc_vf_data);
>  	return 0;
>  }
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 5bab46602fad..7a9dc87627cd 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -38,6 +38,9 @@
>  #define QM_REG_ADDR_OFFSET	0x0004
>=20
>  #define QM_XQC_ADDR_OFFSET	32U
> +#define QM_XQC_ADDR_LOW		0x1
> +#define QM_XQC_ADDR_HIGH	0x2
> +
>  #define QM_VF_AEQ_INT_MASK	0x0004
>  #define QM_VF_EQ_INT_MASK	0x000c
>  #define QM_IFC_INT_SOURCE_V	0x0020
> --
> 2.24.0


