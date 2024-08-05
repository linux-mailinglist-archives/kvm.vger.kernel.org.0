Return-Path: <kvm+bounces-23201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D969894780A
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 11:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07A401C212D5
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 09:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4C215383D;
	Mon,  5 Aug 2024 09:12:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCB41509AF;
	Mon,  5 Aug 2024 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722849172; cv=none; b=LxY8Wtk/3xNFMydg5fEnRYDe/RpD8qf51rAtgVY0/mbeomCn/4iy1YKc2n268NCN/QfzQIsnjhjmo1qpYpHGuutVFqQOZXSBgw5Jth+AxyZL/wrCMwelmmTDsHNUfIFvzTcI8UycV3LMeYdtMDNsHrO/1FucDDj0Ti16xjo95Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722849172; c=relaxed/simple;
	bh=ROYNhy1O+Y4xwzQZ3K2SkbPsu+gsRmnLP1wl4OVq9ks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ezA/olVnkiDRvzg7MSu+BBR1i8VrnqiCrMrNdzjYqqAs0DYMql7Pst3UKZJKhzJ0idbsagtr9ww+Bv4IFDiRt4s+7N9riWpOQl++OK42J5NoA01u4rvny+nM5I2r23wmfYcZXmqTLSSLwgOzV5NEeMMVtzpzebJCH7iAX62OtPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WcrHX5MTQz6K6K1;
	Mon,  5 Aug 2024 17:10:00 +0800 (CST)
Received: from lhrpeml100001.china.huawei.com (unknown [7.191.160.183])
	by mail.maildlp.com (Postfix) with ESMTPS id B4D83140D5A;
	Mon,  5 Aug 2024 17:12:47 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100001.china.huawei.com (7.191.160.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 10:12:47 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 5 Aug 2024 10:12:47 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v7 2/4] hisi_acc_vfio_pci: create subfunction for data
 reading
Thread-Topic: [PATCH v7 2/4] hisi_acc_vfio_pci: create subfunction for data
 reading
Thread-Index: AQHa4nsMt15UL+wOykqqUOzAbViVF7IYagOw
Date: Mon, 5 Aug 2024 09:12:47 +0000
Message-ID: <f096a1cd4f3b4f3681b4eebd9e61fbdb@huawei.com>
References: <20240730121438.58455-1-liulongfang@huawei.com>
 <20240730121438.58455-3-liulongfang@huawei.com>
In-Reply-To: <20240730121438.58455-3-liulongfang@huawei.com>
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
> Sent: Tuesday, July 30, 2024 1:15 PM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v7 2/4] hisi_acc_vfio_pci: create subfunction for data
> reading
>=20
> This patch generates the code for the operation of reading data from
> the device into a sub-function.
> Then, it can be called during the device status data saving phase of
> the live migration process and the device status data reading function
> in debugfs.
> Thereby reducing the redundant code of the driver.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---


LGTM,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 54 +++++++++++--------
>  1 file changed, 33 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 45351be8e270..a8c53952d82e 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -486,31 +486,11 @@ static int vf_qm_load_data(struct
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
>  	if (ret)
>  		return -EINVAL;
> @@ -536,6 +516,38 @@ static int vf_qm_state_save(struct
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
> +	struct device *dev =3D &vf_qm->pdev->dev;
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
> +	ret =3D vf_qm_cache_wb(vf_qm);
> +	if (ret) {
> +		dev_err(dev, "failed to writeback QM Cache!\n");
> +		return ret;
> +	}
> +
> +	ret =3D vf_qm_read_data(vf_qm, vf_data);
> +	if (ret)
> +		return -EINVAL;
> +
>  	migf->total_length =3D sizeof(struct acc_vf_data);
>  	return 0;
>  }
> --
> 2.24.0


