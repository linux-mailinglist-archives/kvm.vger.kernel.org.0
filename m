Return-Path: <kvm+bounces-34137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF609F791F
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:03:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BB5216E09E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AA422258E;
	Thu, 19 Dec 2024 10:02:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBF6221DB1;
	Thu, 19 Dec 2024 10:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602530; cv=none; b=u46NajBzSDLOQ3qRKU4uHUuVN7mPP2a9xiuaStwaU/7PsdqUcAK3XLNs5X7PDgF38cM6+vFgNTiVyWDDD+I0eaxuhyfmNk/0EhauOwf+iwqbDGKK4bg1hBfhWJ2YRXxFkVm9QC7BHjMxHh5W3/mLtpQPZS+FMozNbCdzL8wrHzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602530; c=relaxed/simple;
	bh=ofxL27DVbZHsz37vNL6uYIhVtWYLNzPsb3/EqgL/2hY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UaHpDRjI0wgQePwUz6q05EN1xFwVCtKXq4DBsZQuId9mfwVpk6eHyqZbvR6BFvbaVek9D+Iaf2shqAv2C6nIngesEaWef5LTD+0nmASMaSOs+RRPcf4wI9zVSuc1URNaT6soJq+BpDfSndElHvnZSVGUQOM6Xxl33zT6MieZrGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YDQzb3gCrz6LDFf;
	Thu, 19 Dec 2024 18:00:59 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F0D01400D4;
	Thu, 19 Dec 2024 18:02:05 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 11:02:05 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 19 Dec 2024 11:02:05 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Topic: [PATCH v2 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Index: AQHbUfdpaoWs/QPcLkOOam77+OpMRbLtUYjQ
Date: Thu, 19 Dec 2024 10:02:05 +0000
Message-ID: <a39f57190a46497e816eefa6b649b583@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-6-liulongfang@huawei.com>
In-Reply-To: <20241219091800.41462-6-liulongfang@huawei.com>
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
> Sent: Thursday, December 19, 2024 9:18 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v2 5/5] hisi_acc_vfio_pci: bugfix live migration function
> without VF device driver
>=20
> If the driver of the VF device is not loaded in the Guest OS,
> then perform device data migration. The migrated data address will
> be NULL.
> The live migration recovery operation on the destination side will
> access a null address value, which will cause access errors.
>=20
> Therefore, live migration of VMs without added VF device drivers
> does not require device data migration.
> In addition, when the queue address data obtained by the destination
> is empty, device queue recovery processing will not be performed.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>

Why this doesn't need a Fixes tag?

> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 8d9e07ebf4fd..9a5f7e9bc695 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -436,6 +436,7 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  				struct acc_vf_data *vf_data)
>  {
>  	struct hisi_qm *pf_qm =3D hisi_acc_vdev->pf_qm;
> +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>  	struct device *dev =3D &pf_qm->pdev->dev;
>  	int vf_id =3D hisi_acc_vdev->vf_id;
>  	int ret;
> @@ -460,6 +461,13 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return ret;
>  	}
>=20
> +	/* Get VF driver insmod state */
> +	ret =3D qm_read_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state,
> 1);
> +	if (ret) {
> +		dev_err(dev, "failed to read QM_VF_STATE!\n");
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>=20
> @@ -499,6 +507,12 @@ static int vf_qm_load_data(struct
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

So this is to cover the corner case where the Guest has loaded the driver
(QM_READY set) but not configured the DMA address? When this will happen?
I thought we are setting QM_READY in guest after all configurations.

Thanks,
Shameer



