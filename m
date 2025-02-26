Return-Path: <kvm+bounces-39231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E9C7A457C8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:12:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71D5D3A5D79
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 08:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C73224235;
	Wed, 26 Feb 2025 08:11:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450AE258CFF;
	Wed, 26 Feb 2025 08:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740557483; cv=none; b=KUDnwMs45yzvTAoAjVt+uM5MjO8ii+Nu1537weIaSozfxDbJbKXzYdGVAWmjASNHnDRUsEo+1DR8XzDy1hnxIdXWEpbJcYyTehRXw/E842ut+o0xV1G/sZVrzjQJ5OTFBGB8R9CRFmaFBhOKVyumG69hic8+bU7YzagdsOY/6p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740557483; c=relaxed/simple;
	bh=qxUdhJkVIB6SLeGgiDylBRaBCfS4l0Y42J9ivJk76xA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mnea0fNSl0mqebNnnh2P5A708GRsb7J4bpLNQL3R22U7Be1SMkn497whxEmoYAc4xvOQEk/5WZTSxbwcDp2v8nLz/jWW7h7W5xpEKfxWm4N4MVDINRDNQzA4hM3L6gQL1sin/LGFCDb9FrbkXvGTHf15slg4lIO5cnDLmdU4QrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Z2nCz2Z3yz6M4NX;
	Wed, 26 Feb 2025 16:08:31 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id B6ACD140A86;
	Wed, 26 Feb 2025 16:11:17 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Feb 2025 09:11:17 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Wed, 26 Feb 2025 09:11:17 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>, liulongfang
	<liulongfang@huawei.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Topic: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Index: AQHbh054pIF9zpUAW0yvk2GszOMCbbNYphWAgACVU3A=
Date: Wed, 26 Feb 2025 08:11:17 +0000
Message-ID: <024fd8e2334141b688150650728699ba@huawei.com>
References: <20250225062757.19692-1-liulongfang@huawei.com>
	<20250225062757.19692-2-liulongfang@huawei.com>
 <20250225170941.46b0ede5.alex.williamson@redhat.com>
In-Reply-To: <20250225170941.46b0ede5.alex.williamson@redhat.com>
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
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, February 26, 2025 12:10 AM
> To: liulongfang <liulongfang@huawei.com>
> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxarm@openeuler.org
> Subject: Re: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
>=20
> On Tue, 25 Feb 2025 14:27:53 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
>=20
> > The dma addresses of EQE and AEQE are wrong after migration and
> > results in guest kernel-mode encryption services  failure.
> > Comparing the definition of hardware registers, we found that
> > there was an error when the data read from the register was
> > combined into an address. Therefore, the address combination
> > sequence needs to be corrected.
> >
> > Even after fixing the above problem, we still have an issue
> > where the Guest from an old kernel can get migrated to
> > new kernel and may result in wrong data.
> >
> > In order to ensure that the address is correct after migration,
> > if an old magic number is detected, the dma address needs to be
> > updated.
> >
> > Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > ---
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 40 ++++++++++++++++---
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
> >  2 files changed, 46 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > index 451c639299eb..35316984089b 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > @@ -350,6 +350,31 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
> >  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
> >  }
> >
> > +static int vf_qm_version_check(struct acc_vf_data *vf_data, struct dev=
ice
> *dev)
> > +{
> > +	switch (vf_data->acc_magic) {
> > +	case ACC_DEV_MAGIC_V2:
> > +		if (vf_data->major_ver < ACC_DRV_MAJOR_VER ||
> > +		    vf_data->minor_ver < ACC_DRV_MINOR_VER)
> > +			dev_info(dev, "migration driver version not
> match!\n");
> > +			return -EINVAL;
> > +		break;
>=20
> What's your major/minor update strategy?
>=20
> Note that minor_ver is a u16 and ACC_DRV_MINOR_VER is defined as 0, so
> testing less than 0 against an unsigned is useless.
>=20
> Arguably testing major and minor independently is pretty useless too.
>=20
> You're defining what a future "old" driver version will accept, which
> is very nearly anything, so any breaking change *again* requires a new
> magic, so we're accomplishing very little here.
>=20
> Maybe you want to consider a strategy where you'd increment the major
> number for a breaking change and minor for a compatible feature.  In
> that case you'd want to verify the major_ver matches
> ACC_DRV_MAJOR_VER
> exactly and minor_ver would be more of a feature level.

Agree. I think the above check should be just major_ver !=3D ACC_DRV_MAJOR_=
VER
and we can make use of minor version whenever we need a specific handling f=
or
a feature support.

Also I think it would be good to print the version info above in case of mi=
smatch.

>=20
> > +	case ACC_DEV_MAGIC_V1:
> > +		/* Correct dma address */
> > +		vf_data->eqe_dma =3D vf_data-
> >qm_eqc_dw[QM_XQC_ADDR_HIGH];
> > +		vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> > +		vf_data->eqe_dma |=3D vf_data-
> >qm_eqc_dw[QM_XQC_ADDR_LOW];
> > +		vf_data->aeqe_dma =3D vf_data-
> >qm_aeqc_dw[QM_XQC_ADDR_HIGH];
> > +		vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> > +		vf_data->aeqe_dma |=3D vf_data-
> >qm_aeqc_dw[QM_XQC_ADDR_LOW];
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int vf_qm_check_match(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
> >  			     struct hisi_acc_vf_migration_file *migf)
> >  {
> > @@ -363,7 +388,8 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
> >  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-
> >match_done)
> >  		return 0;
> >
> > -	if (vf_data->acc_magic !=3D ACC_DEV_MAGIC) {
> > +	ret =3D vf_qm_version_check(vf_data, dev);
> > +	if (ret) {
> >  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
> >  		return -EINVAL;
> >  	}
> > @@ -418,7 +444,9 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
> >  	int vf_id =3D hisi_acc_vdev->vf_id;
> >  	int ret;
> >
> > -	vf_data->acc_magic =3D ACC_DEV_MAGIC;
> > +	vf_data->acc_magic =3D ACC_DEV_MAGIC_V2;
> > +	vf_data->major_ver =3D ACC_DRV_MAR;
> > +	vf_data->minor_ver =3D ACC_DRV_MIN;
>=20
> Where are "MAR" and "MIN" defined?  I can't see how this would even
> compile.  Thanks,

Yes. Please  make sure to do a compile test and run basic sanity tested eve=
n if you
think the changes are minor. Chances are there that you will miss out thing=
s like
this.

Thanks,
Shameer
=20

