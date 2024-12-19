Return-Path: <kvm+bounces-34134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 905A09F791A
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A2D21897505
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD2222256B;
	Thu, 19 Dec 2024 10:01:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB72F221472;
	Thu, 19 Dec 2024 10:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602491; cv=none; b=CLPB0t1AnI+2cAJUty65TUPvtrBgeIKA2mwdm5bLOsPeLrCFSq7vEmBeZQbZ+3vng+x0tdnnSwikAsALjsow1oj9nKNrbmk60I568GMj/F2JrCeeUo1Y6UpS6Jc06ThBg+IgA1kZLQzm4NLCDgq8NrudAj8I9lGtxfNl6a6/nH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602491; c=relaxed/simple;
	bh=dCfOZndWJtiaD/FBQQbC6ZzQguKCfoQH0huMswBV//E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eOy5CO6exn1/Mx00jUHMKWxVq8cDwB0EmFou+3fJU1/tgn87WhngQvQqqG1EW21eTZyirTo1D8Pglqyp6GHuTlICfpjUN0xMAzniG8awoep7L7XwDGC1BCk8AfxWOakOyF7lZDGxg0AY0wF1glj232eUdt6zofxBoiSMbCmi8Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YDQvw3HqBz6HJg5;
	Thu, 19 Dec 2024 17:57:48 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id BC1E6140B55;
	Thu, 19 Dec 2024 18:01:26 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 11:01:26 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 19 Dec 2024 11:01:26 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 2/5] hisi_acc_vfio_pci: add eq and aeq interruption
 restore
Thread-Topic: [PATCH v2 2/5] hisi_acc_vfio_pci: add eq and aeq interruption
 restore
Thread-Index: AQHbUfcyVAyoYT4Iq0ShgGy0pOKikbLtT+ZQ
Date: Thu, 19 Dec 2024 10:01:26 +0000
Message-ID: <763ca52fc4f44f299188e8b678115089@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-3-liulongfang@huawei.com>
In-Reply-To: <20241219091800.41462-3-liulongfang@huawei.com>
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
> Subject: [PATCH v2 2/5] hisi_acc_vfio_pci: add eq and aeq interruption
> restore
>=20
> In order to ensure that the task packets of the accelerator
> device are not lost during the migration process, it is necessary
> to send an EQ and AEQ command to the device after the live migration
> is completed and to update the completion position of the task queue.
>=20
> Let the device recheck the completed tasks data and if there are
> uncollected packets, device resend a task completion interrupt
> to the software.
>=20
> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 8518efea3a52..4c8f1ae5b636 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -463,6 +463,19 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	return 0;
>  }
>=20
> +static void vf_qm_xeqc_save(struct hisi_qm *qm,
> +			    struct hisi_acc_vf_migration_file *migf)
> +{
> +	struct acc_vf_data *vf_data =3D &migf->vf_data;
> +	u16 eq_head, aeq_head;
> +
> +	eq_head =3D vf_data->qm_eqc_dw[0] & 0xFFFF;
> +	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, eq_head, 0);
> +
> +	aeq_head =3D vf_data->qm_aeqc_dw[0] & 0xFFFF;
> +	qm_db(qm, 0, QM_DOORBELL_CMD_AEQ, aeq_head, 0);
> +}
> +
>  static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev=
,
>  			   struct hisi_acc_vf_migration_file *migf)
>  {
> @@ -571,6 +584,9 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return -EINVAL;
>=20
>  	migf->total_length =3D sizeof(struct acc_vf_data);
> +	/* Save eqc and aeqc interrupt information */
> +	vf_qm_xeqc_save(vf_qm, migf);
> +
>  	return 0;
>  }

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer



