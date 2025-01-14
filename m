Return-Path: <kvm+bounces-35354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A80A101BD
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:08:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 289F7169501
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E972284A44;
	Tue, 14 Jan 2025 08:08:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8E2500D0;
	Tue, 14 Jan 2025 08:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736842087; cv=none; b=ClI+RfeDw85iGeVN9Lfi3RxxG0FWpMGjU8F4pVo6HfWtDIMj9RulLoaegvchPl81P5BGawfnZYuXgOZJj5tyuU5hTB82/mTIB8aX4gtoelkFde4CLi6vc7bbZgpvc1rQe2L3FrtxEE0t36Dw/ga3+4tgSA5JLUYeHE19ozgU/Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736842087; c=relaxed/simple;
	bh=aj1UQ4PK8usMFk8jnJDJm7sPgISLnAPSCoc1xmHMKiQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pMNSAtk8djjhXhG9G2THG7Y8a2xXbKG/AgchZT2sf66TgUak71bZguh8WKY/t0NqIFtKHIqZCzVEEB6hgggnR2mJBa3lBAGae2IamwoLybPItYQlRKfcWM7+dAz0utp95FYW8rDCnuLy61W60GIIKJAUFnp7+5wsE4cOGiPRKwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YXMBw13JTz6LDKR;
	Tue, 14 Jan 2025 16:06:00 +0800 (CST)
Received: from frapeml500006.china.huawei.com (unknown [7.182.85.219])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E8D414022E;
	Tue, 14 Jan 2025 16:07:43 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 14 Jan 2025 09:07:43 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 14 Jan 2025 09:07:43 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Topic: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Thread-Index: AQHbUfcgfa2nqn3uckGkS+OpvnEMM7LtTqLQgBbIbQCAEHNagIAAQLGAgABnigCAAH5ngIAAXs8w
Date: Tue, 14 Jan 2025 08:07:43 +0000
Message-ID: <8225389dd537497c9753cf0a321964e4@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-2-liulongfang@huawei.com>
 <099e0e1215f34d64a4ae698b90ee372c@huawei.com>
 <20250102153008.301730f3.alex.williamson@redhat.com>
 <4d48db10-23e1-1bb4-54ea-4c659ab85f19@huawei.com>
 <20250113083441.0fb7afa3.alex.williamson@redhat.com>
 <20250113144516.22a17af8.alex.williamson@redhat.com>
 <80a4e398-ad29-cce8-4a52-ce2a5f6a308c@huawei.com>
In-Reply-To: <80a4e398-ad29-cce8-4a52-ce2a5f6a308c@huawei.com>
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
> Sent: Tuesday, January 14, 2025 3:18 AM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; jgg@nvidia.com; Jonathan
> Cameron <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxarm@openeuler.org
> Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
>=20

[...]

> > @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
> >  	int vf_id =3D hisi_acc_vdev->vf_id;
> >  	int ret;
> >
> > -	vf_data->acc_magic =3D ACC_DEV_MAGIC;
> > +	vf_data->acc_magic =3D ACC_DEV_MAGIC_V2;
> >  	/* Save device id */
> >  	vf_data->dev_id =3D hisi_acc_vdev->vf_dev->device;
> >
> > Thanks,
> > Alex
> >
> >>>
> >>> As for the compatibility issues between old and new versions in the
> >>> future, we do not need to reserve version numbers to deal with them
> >>> now. Because before encountering specific problems, our design may
> be redundant.
> >>
> >> A magic value + version number would prevent the need to replace the
> >> magic value every time an issue is encountered, which I think was
> >> also Shameer's commit, which is not addressed by forcing the
> >> formatting of a portion of the magic value.  None of what you're
> >> trying to do here precludes a new data structure for the new magic
> >> value or defining the padding fields for different use cases.
> >> Thanks,
> >>
> >> Alex
> >
>=20
> If we want to use the original magic number, we also need to add the majo=
r
> and minor version numbers. It does not cause compatibility issues and can
> only reuse the original u64 memory space.
>=20
> This is also Shameerali's previous plan. Do you accept this plan?

The suggestion here is to improve my previous plan.. ie, instead of overloa=
ding
the V2 MAGIC with version info, introduce version(major:minor) separately.

Something like,

Rename old MAGIC as MAGIC_V1

Introduce new MAGIC as MAGIC_V2

Repurpose any padding or reserved fields in struct vf_data for major:minor
version  fields. The idea of introducing these major:minor is for future us=
e
where instead of coming up with a  new MAGIC data every time we can
increment the version for bug fixes and features if required.=20

Hope this is clear now.

Thanks,
Shameer



