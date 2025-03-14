Return-Path: <kvm+bounces-41026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD146A60AE8
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C26C1743D1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 08:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 820691A23BF;
	Fri, 14 Mar 2025 08:11:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273319644B;
	Fri, 14 Mar 2025 08:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741939890; cv=none; b=cEWDQmmBDmkzJjJfIxvCv3fDK+eiWxLDcND6ELWtid1cksNOCjYZBsx5KDAm/kjk2rEYOY9wTQYDT37AYPNB1vN5r0UZ6Rc6quQfYa5FEBr1ZfqXv4hGoqjT0Zd6ygj2VlfQXsHNAt8a/zw/ZSyXoUfU50r3U2lH9nrpuZHs8AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741939890; c=relaxed/simple;
	bh=cYLRd27LwxxnhKQhH3BhhGFa+yC1TVrMPzCfEId7PKI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ggU+nXHETdMr0zC/6BKAmKmkAb7jcfQXc2czz8L/QwrJYwDEM0HeRxCgHIKwOxna5vFpaq9Ir72HohgfLig97LhxG2onGJ1DRCXQrrCrOoBlWvLEvKYcg1STSNWL44Sd7dDAA9fTYOs3EETxyvS4F4RIlBurEz8hoYpfYKaFnLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZDcSG2kMsz6J7pL;
	Fri, 14 Mar 2025 16:08:14 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F8C31403D2;
	Fri, 14 Mar 2025 16:11:25 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Mar 2025 09:11:25 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 14 Mar 2025 09:11:25 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v5 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Topic: [PATCH v5 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Index: AQHbk+i60KhSVn4sokWhcM22rbK+SbNyR/ZA
Date: Fri, 14 Mar 2025 08:11:24 +0000
Message-ID: <53d0f91f3d8440bc91858dd4811b7170@huawei.com>
References: <20250313072010.57199-1-liulongfang@huawei.com>
 <20250313072010.57199-6-liulongfang@huawei.com>
In-Reply-To: <20250313072010.57199-6-liulongfang@huawei.com>
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
> Sent: Thursday, March 13, 2025 7:20 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v5 5/5] hisi_acc_vfio_pci: bugfix live migration function
> without VF device driver
>=20
> If the VF device driver is not loaded in the Guest OS and we attempt to
> perform device data migration, the address of the migrated data will
> be NULL.
> The live migration recovery operation on the destination side will
> access a null address value, which will cause access errors.
>=20
> Therefore, live migration of VMs without added VF device drivers
> does not require device data migration.
> In addition, when the queue address data obtained by the destination
> is empty, device queue recovery processing will not be performed.
>=20
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 25 +++++++++++++------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index cadc82419dca..44fa2d16bbcc 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -426,13 +426,6 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return -EINVAL;
>  	}
>=20
> -	ret =3D qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state,
> 1);
> -	if (ret) {
> -		dev_err(dev, "failed to write QM_VF_STATE\n");
> -		return ret;
> -	}
> -
> -	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
>  	hisi_acc_vdev->match_done =3D true;
>  	return 0;
>  }
> @@ -498,6 +491,13 @@ static int vf_qm_load_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < sizeof(struct acc_vf_data))
>  		return -EINVAL;
>=20
> +	ret =3D qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
> +	if (ret) {
> +		dev_err(dev, "failed to write QM_VF_STATE\n");
> +		return -EINVAL;
> +	}
> +	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
> +
>  	qm->eqe_dma =3D vf_data->eqe_dma;
>  	qm->aeqe_dma =3D vf_data->aeqe_dma;
>  	qm->sqc_dma =3D vf_data->sqc_dma;
> @@ -506,6 +506,12 @@ static int vf_qm_load_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	qm->qp_base =3D vf_data->qp_base;
>  	qm->qp_num =3D vf_data->qp_num;
>=20
> +	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
> +	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
> +		dev_err(dev, "resume dma addr is NULL!\n");
> +		return -EINVAL;
> +	}
> +
>  	ret =3D qm_set_regs(qm, vf_data);
>  	if (ret) {
>  		dev_err(dev, "set VF regs failed\n");
> @@ -726,8 +732,12 @@ static int hisi_acc_vf_load_state(struct
> hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
>  	struct device *dev =3D &hisi_acc_vdev->vf_dev->dev;
>  	struct hisi_acc_vf_migration_file *migf =3D hisi_acc_vdev-
> >resuming_migf;
> +	struct acc_vf_data *vf_data =3D &migf->vf_data;
>  	int ret;
>=20
> +	if (vf_data->vf_qm_state !=3D QM_READY)
> +		return 0;

I don't think we need to check the above. In vf_qm_satte_save(),=20
If  vf_qm_state !=3D  QM_READY, we set the
 migf->total_length =3D QM_MATCH_SIZE.

Hence it will return 0 in the below  vf_qm_load_data() anyway.

With that corrected,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> +
>  	/* Recover data to VF */
>  	ret =3D vf_qm_load_data(hisi_acc_vdev, migf);
>  	if (ret) {
> @@ -1531,6 +1541,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
> vfio_device *core_vdev)
>  	hisi_acc_vdev->vf_id =3D pci_iov_vf_id(pdev) + 1;
>  	hisi_acc_vdev->pf_qm =3D pf_qm;
>  	hisi_acc_vdev->vf_dev =3D pdev;
> +	hisi_acc_vdev->vf_qm_state =3D QM_NOT_READY;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
>  	mutex_init(&hisi_acc_vdev->open_mutex);
>=20
> --
> 2.24.0


