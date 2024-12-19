Return-Path: <kvm+bounces-34135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5CF79F7918
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6D387A29EB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B8F222D61;
	Thu, 19 Dec 2024 10:01:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61DF222589;
	Thu, 19 Dec 2024 10:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602497; cv=none; b=YLJJhgmfqyQTMzFBTwAp5LZ+9wmrhDomlC01V767xmBT2RdfaMwXl7jOHDpcW/5gQCN9JphCDUXcV26d6GwDsFtprmo2JpMIQ5L+5/kFKrXsFBZ2N00pPG7kFNvfuUCA+2wDGeAZ/2FhGeM8W/Jn96/MliO6FKEykCw/AFqwmS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602497; c=relaxed/simple;
	bh=OiSyrSZTpKDgaDTb9un3tPnD+sA2yjM4vYGqCBSTxhA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D2qXuWBka1DrVek1ubwUAomL6P05Y4G9u0eZssCULUzdquEd2nTBjTH47tQkKAZijC43cILHUBphVHfcsLgeM5CywOjl1prA1VhbWjwHjJdbUXM5qXrIB00hZuN4B05Lsk3QuFG83zoQUsmwFXjbiJ+3cSzDOGKwmUoOSnzzy1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YDQyx5fCcz6LD4Z;
	Thu, 19 Dec 2024 18:00:25 +0800 (CST)
Received: from frapeml500006.china.huawei.com (unknown [7.182.85.219])
	by mail.maildlp.com (Postfix) with ESMTPS id E2CAE1400D4;
	Thu, 19 Dec 2024 18:01:31 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 11:01:31 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 19 Dec 2024 11:01:31 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 3/5] hisi_acc_vfio_pci: bugfix cache write-back issue
Thread-Topic: [PATCH v2 3/5] hisi_acc_vfio_pci: bugfix cache write-back issue
Thread-Index: AQHbUfdEKw7IfmglvEKrb7XHq+s4N7LtUMRw
Date: Thu, 19 Dec 2024 10:01:31 +0000
Message-ID: <6e905c2baf9f4dafaa2d1f2e9113252b@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-4-liulongfang@huawei.com>
In-Reply-To: <20241219091800.41462-4-liulongfang@huawei.com>
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
> Subject: [PATCH v2 3/5] hisi_acc_vfio_pci: bugfix cache write-back issue
>=20
> At present, cache write-back is placed in the device data
> copy stage after stopping the device operation.
> Writing back to the cache at this stage will cause the data
> obtained by the cache to be written back to be empty.
>=20
> In order to ensure that the cache data is written back
> successfully, the data needs to be written back into the
> stop device stage.
>=20
> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 4c8f1ae5b636..c057c0e24693 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -559,7 +559,6 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  {
>  	struct acc_vf_data *vf_data =3D &migf->vf_data;
>  	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> -	struct device *dev =3D &vf_qm->pdev->dev;
>  	int ret;
>=20
>  	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
> @@ -573,12 +572,6 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	vf_data->vf_qm_state =3D QM_READY;
>  	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
>=20
> -	ret =3D vf_qm_cache_wb(vf_qm);
> -	if (ret) {
> -		dev_err(dev, "failed to writeback QM Cache!\n");
> -		return ret;
> -	}
> -
>  	ret =3D vf_qm_read_data(vf_qm, vf_data);
>  	if (ret)
>  		return -EINVAL;
> @@ -1005,6 +998,13 @@ static int hisi_acc_vf_stop_device(struct
> hisi_acc_vf_core_device *hisi_acc_vdev
>  		dev_err(dev, "failed to check QM INT state!\n");
>  		return ret;
>  	}
> +
> +	ret =3D vf_qm_cache_wb(vf_qm);
> +	if (ret) {
> +		dev_err(dev, "failed to writeback QM cache!\n");
> +		return ret;
> +	}
> +
>  	return 0;
>  }

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer



