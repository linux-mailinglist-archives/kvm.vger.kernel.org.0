Return-Path: <kvm+bounces-34133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B719F7917
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20CB81895558
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CEC22256C;
	Thu, 19 Dec 2024 10:01:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBC81FAC26;
	Thu, 19 Dec 2024 10:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602470; cv=none; b=YrKsRCyifaw1kL4i+akPv+w8StrVbs03D3p/0PPvcVa902PSN+bQCK+1g71HcyGWk89qUzW7ZNzNXM8RNv3LISaLFOgyKTFXsSqvel6dvJjYES+XWOS0X3m+CKyerI+L/Y+uOIPrS9HesdlfckD8XIRYu8HX718uAE9brGhZ06s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602470; c=relaxed/simple;
	bh=T3ZozJVkkCgwG9LEgE7u+KgydVQgoGY5oEe5N/E2x4I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z+pkeCewX/M+ycFtKUb5K68V0dH65CHStqwqI3CEH5V11zcpRkAEPfRVQZbLfiDJzkX2608tfYv5mjGuOSDtFGO9ZsHSn2XoBnsxdPUDtgTBuDayh3EsoTHyz9120eBqnCMnI70CCXvSfgc9z3HKhS/UX648NDXyFPfWxV1FxcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YDQzd01WFz6K5vx;
	Thu, 19 Dec 2024 18:01:01 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A7381400DB;
	Thu, 19 Dec 2024 18:01:04 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 11:01:04 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 19 Dec 2024 11:01:04 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Topic: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Index: AQHbUfcgfa2nqn3uckGkS+OpvnEMM7LtTqLQ
Date: Thu, 19 Dec 2024 10:01:03 +0000
Message-ID: <099e0e1215f34d64a4ae698b90ee372c@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-2-liulongfang@huawei.com>
In-Reply-To: <20241219091800.41462-2-liulongfang@huawei.com>
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
> Subject: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
>=20
> The dma addresses of EQE and AEQE are wrong after migration and
> results in guest kernel-mode encryption services  failure.
> Comparing the definition of hardware registers, we found that
> there was an error when the data read from the register was
> combined into an address. Therefore, the address combination
> sequence needs to be corrected.
>=20
> Even after fixing the above problem, we still have an issue
> where the Guest from an old kernel can get migrated to
> new kernel and may result in wrong data.
>=20
> In order to ensure that the address is correct after migration,
> if an old magic number is detected, the dma address needs to be
> updated.
>=20
> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++----
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
>  2 files changed, 36 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 451c639299eb..8518efea3a52 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -350,6 +350,27 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>  }
>=20
> +static int vf_qm_magic_check(struct acc_vf_data *vf_data)
> +{
> +	switch (vf_data->acc_magic) {
> +	case ACC_DEV_MAGIC_V2:
> +		break;
> +	case ACC_DEV_MAGIC_V1:
> +		/* Correct dma address */
> +		vf_data->eqe_dma =3D vf_data-
> >qm_eqc_dw[QM_XQC_ADDR_HIGH];
> +		vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> +		vf_data->eqe_dma |=3D vf_data-
> >qm_eqc_dw[QM_XQC_ADDR_LOW];
> +		vf_data->aeqe_dma =3D vf_data-
> >qm_aeqc_dw[QM_XQC_ADDR_HIGH];
> +		vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> +		vf_data->aeqe_dma |=3D vf_data-
> >qm_aeqc_dw[QM_XQC_ADDR_LOW];
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int vf_qm_check_match(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
>  			     struct hisi_acc_vf_migration_file *migf)
>  {
> @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-
> >match_done)
>  		return 0;
>=20
> -	if (vf_data->acc_magic !=3D ACC_DEV_MAGIC) {
> +	ret =3D vf_qm_magic_check(vf_data);
> +	if (ret) {
>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>  		return -EINVAL;
>  	}
> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	int vf_id =3D hisi_acc_vdev->vf_id;
>  	int ret;
>=20
> -	vf_data->acc_magic =3D ACC_DEV_MAGIC;
> +	vf_data->acc_magic =3D ACC_DEV_MAGIC_V2;
>  	/* Save device id */
>  	vf_data->dev_id =3D hisi_acc_vdev->vf_dev->device;
>=20
> @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm
> *vf_qm, struct acc_vf_data *vf_data)
>  		return -EINVAL;
>=20
>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> -	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[1];
> +	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
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
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 245d7537b2bc..2afce68f5a34 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -39,6 +39,9 @@
>  #define QM_REG_ADDR_OFFSET	0x0004
>=20
>  #define QM_XQC_ADDR_OFFSET	32U
> +#define QM_XQC_ADDR_LOW	0x1
> +#define QM_XQC_ADDR_HIGH	0x2
> +
>  #define QM_VF_AEQ_INT_MASK	0x0004
>  #define QM_VF_EQ_INT_MASK	0x000c
>  #define QM_IFC_INT_SOURCE_V	0x0020
> @@ -50,10 +53,14 @@
>  #define QM_EQC_DW0		0X8000
>  #define QM_AEQC_DW0		0X8020
>=20
> +enum acc_magic_num {
> +	ACC_DEV_MAGIC_V1 =3D 0XCDCDCDCDFEEDAACC,
> +	ACC_DEV_MAGIC_V2 =3D 0xAACCFEEDDECADEDE,


I think we have discussed this before that having some kind of=20
version info embed into magic_num will be beneficial going=20
forward. ie, may be use the last 4 bytes for denoting version.

ACC_DEV_MAGIC_V2 =3D 0xAACCFEEDDECA0002

The reason being, otherwise we have to come up with a random
magic each time when a fix like this is required in future.

Thanks,
Shameer


