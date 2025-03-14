Return-Path: <kvm+bounces-41025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D7CA60AAA
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3318E7A88A8
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 08:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9398918D634;
	Fri, 14 Mar 2025 08:01:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328188635C;
	Fri, 14 Mar 2025 08:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741939274; cv=none; b=Q9bnvKMk2Ya+yUKjj8cz5ksczVO0gu3xG1GAhUXbFlTmpWXv96ebAOyMHgYVLPZlky4fGItNcsKUeIS29XCtkoLHIsle+14wy/hGHdSyQgKtQdN3NdT9PWNOAwD3XYvkXarj7sFBKkGD164uVib9pbaY2NvnlG0iF0c8oiA96Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741939274; c=relaxed/simple;
	bh=2B/5aN05eoZTgzN63W3uqYpO0do2ss6MxpkDWINcgyQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qWZ2v2DlVr9dlQH1Jdh9zPZKGKrgoucLuF4/x1WgTn1FJTYalqn49h1OuwlSA3MzhcNepbCd3Q0urkoiPU08VblvPsJN6VeXacE8d6ZlC5vJe3kPbz009XLe2BkK9ALJMHO6ku+F+al7h/sEJr/ShnM7Iqw6P19W5Rdii4vzoAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZDcBh0cGrz6K67D;
	Fri, 14 Mar 2025 15:56:28 +0800 (CST)
Received: from frapeml100006.china.huawei.com (unknown [7.182.85.201])
	by mail.maildlp.com (Postfix) with ESMTPS id 61C4B140CF4;
	Fri, 14 Mar 2025 16:01:02 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100006.china.huawei.com (7.182.85.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Mar 2025 09:01:02 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 14 Mar 2025 09:01:02 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v5 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Topic: [PATCH v5 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Index: AQHbk+hwQlAvr1GEvUSLyFLIJayo4bNyRZ+Q
Date: Fri, 14 Mar 2025 08:01:02 +0000
Message-ID: <a1bd053262dc44dab40e9946a651e718@huawei.com>
References: <20250313072010.57199-1-liulongfang@huawei.com>
 <20250313072010.57199-2-liulongfang@huawei.com>
In-Reply-To: <20250313072010.57199-2-liulongfang@huawei.com>
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
> Subject: [PATCH v5 1/5] hisi_acc_vfio_pci: fix XQE dma address error
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
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>

LGTM,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 41 ++++++++++++++++---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
>  2 files changed, 47 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 451c639299eb..304dbdfa0e95 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -350,6 +350,32 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>  }
>=20
> +static int vf_qm_version_check(struct acc_vf_data *vf_data, struct devic=
e
> *dev)
> +{
> +	switch (vf_data->acc_magic) {
> +	case ACC_DEV_MAGIC_V2:
> +		if (vf_data->major_ver !=3D ACC_DRV_MAJOR_VER) {
> +			dev_info(dev, "migration driver version<%u.%u> not
> match!\n",
> +				 vf_data->major_ver, vf_data->minor_ver);
> +			return -EINVAL;
> +		}
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
> @@ -363,7 +389,8 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-
> >match_done)
>  		return 0;
>=20
> -	if (vf_data->acc_magic !=3D ACC_DEV_MAGIC) {
> +	ret =3D vf_qm_version_check(vf_data, dev);
> +	if (ret) {
>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>  		return -EINVAL;
>  	}
> @@ -418,7 +445,9 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	int vf_id =3D hisi_acc_vdev->vf_id;
>  	int ret;
>=20
> -	vf_data->acc_magic =3D ACC_DEV_MAGIC;
> +	vf_data->acc_magic =3D ACC_DEV_MAGIC_V2;
> +	vf_data->major_ver =3D ACC_DRV_MAJOR_VER;
> +	vf_data->minor_ver =3D ACC_DRV_MINOR_VER;
>  	/* Save device id */
>  	vf_data->dev_id =3D hisi_acc_vdev->vf_dev->device;
>=20
> @@ -496,12 +525,12 @@ static int vf_qm_read_data(struct hisi_qm
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
> index 245d7537b2bc..91002ceeebc1 100644
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
> @@ -50,10 +53,15 @@
>  #define QM_EQC_DW0		0X8000
>  #define QM_AEQC_DW0		0X8020
>=20
> +#define ACC_DRV_MAJOR_VER 1
> +#define ACC_DRV_MINOR_VER 0
> +
> +#define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
> +#define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */
> -#define ACC_DEV_MAGIC	0XCDCDCDCDFEEDAACC
>  	u64 acc_magic;
>  	u32 qp_num;
>  	u32 dev_id;
> @@ -61,7 +69,9 @@ struct acc_vf_data {
>  	u32 qp_base;
>  	u32 vf_qm_state;
>  	/* QM reserved match information */
> -	u32 qm_rsv_state[3];
> +	u16 major_ver;
> +	u16 minor_ver;
> +	u32 qm_rsv_state[2];
>=20
>  	/* QM RW regs */
>  	u32 aeq_int_mask;
> --
> 2.24.0


