Return-Path: <kvm+bounces-35319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3803FA0C1BA
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 267D01882815
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 19:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EF01CB332;
	Mon, 13 Jan 2025 19:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4wEZvYN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC21BB6BA
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 19:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736797534; cv=none; b=pueFppL+w48woGOxirc3RfLixHE3uw2L0Y+IYzyxlRss2RjT6jcxYZACKqjQoZ6TRSU011bYcqo+cmAuvj+Euy+UQq0JyD1SKft54CjEofcFEKVZwYq2FSh1pgta2LSvSvlI/TUcGnuZxnYGbKXZnKP9zuHUkuMB6tPD53hURvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736797534; c=relaxed/simple;
	bh=lZhv/eCTZJATYBK6XsdII1l+WVVcfkKTiR3I27ZqzTc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hReH3hjClWSGcj0AJ+M5U9LgUCz312tZ3fpih42WglPZppnmTyTC7eu4pewrwfZ4eX39P1x+NGNL1pYae0nDpHYtxQE3U2TJJ6YgsixGZMHIC0f0ah7zSmww4FyE5OD3p8sfS4oluhQFAeHcwwm+pzS7/65RrUPkf5YFcHA3jE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b4wEZvYN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736797530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++b0aKCTE2b+h8t8R0s+/qRtSGJnMvgkZc0dqXJRYeI=;
	b=b4wEZvYNRxiiirv9ISpHVfo1USAdUib3ppXKcRTlRw4LDBUJhBkL3UqbeQoDn1ES7zu5hp
	BTO28vAp1ToLDXkHk7R+08UH+7qPGcHH8WX4ThbWv1nqc6y1q6YdVG5TEO0kr3UIG66AGd
	JVmOuEx/J29X4Tk7OoXk7w0dHcXKMu4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-AIEEYkkRM12KdGdNOipnmA-1; Mon, 13 Jan 2025 14:45:29 -0500
X-MC-Unique: AIEEYkkRM12KdGdNOipnmA-1
X-Mimecast-MFC-AGG-ID: AIEEYkkRM12KdGdNOipnmA
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-84a3a4ec598so36100639f.2
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 11:45:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736797528; x=1737402328;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=++b0aKCTE2b+h8t8R0s+/qRtSGJnMvgkZc0dqXJRYeI=;
        b=nSVx0YZ5p+W1TBmKAk4DCxbi0RPV4mrJQg1F69J7q23fi/flNDqAhhILgABSvzYjJE
         3QjJzxZXU3Ag1QWWjiwujIfb9UFar3XGCm7pCNdWhID6P/qIEdVt4+rBc6KcVmMI9a23
         yy0ZysAZKTWhgfzCwIqiW8xLRKHAUMtYRTjF7WI8b2rbW7TcepIPcBMOEglwCvzlGpJG
         Y/GBoirTswrAWxylhL9W/Z/DgouIlWJeODHjfLmsg20rouPoDTpqH4MesMNi6oWfhcuY
         EHo21sFLhZeGSBYVCJNjXTaxCVJiEWWngfz4dQbDvZet9bbbVPMCD08pPCJQd2/2b3ty
         FTJg==
X-Forwarded-Encrypted: i=1; AJvYcCWc5TAw45Vjwt3HHvP1e+4V+l3Y4uAZ9Dy0cirAznBmGxiyZ52Iy8ugJbn3VEux7wwujGs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk5mXrvW1Rtm3GsNM6LnMKiUr0GGmemGY0v1psLePWISmNKl3/
	r0IVgAF116oUILY1289WMQq1Q/dzB4O//+Ejt2Noei2+HNt7HgRoMJFlS1NA8w73S078MLXrCcl
	yQuk+Hm11F5APp+/LHezyzvzi++UxBsuFBsA4grg2bU8ZrhM4jFw9XHCoUQ==
X-Gm-Gg: ASbGnctqVCbWCSgMUT06FlmGSoa3O3OTjOyTQjnGtK68D+C/2u7L9JmscJkbCW3nJnq
	r7iQDiUZpphRCz1vgPM4/JPk7p6K+TurkRLA9YciqFjxtGHFf+dLkP5EL+YFSEasARQK1Ldi87M
	4HtJE7RqiPTGXVQRclWeBGKFDc/54Uk41kF9+gxhT+l8PEeUDhLQKDWWE6E6p2+2xsPpz268vlb
	c+uFe++T4n3sYr5gld32x0V93r4ZOFxnMI7I3PlMOi26Mdk3LzVPV8GFBJy
X-Received: by 2002:a05:6e02:1fcb:b0:3a7:c5bd:a5f4 with SMTP id e9e14a558f8ab-3ce3a7ac820mr49200365ab.0.1736797528587;
        Mon, 13 Jan 2025 11:45:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrJQcDO1EpKXDuFv8EHKFo3rD5WNabr+q8xCpu19GG4NFXbGpHMk7mVblf7s8wCyWoJcOHng==
X-Received: by 2002:a05:6e02:1fcb:b0:3a7:c5bd:a5f4 with SMTP id e9e14a558f8ab-3ce3a7ac820mr49200335ab.0.1736797528300;
        Mon, 13 Jan 2025 11:45:28 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7458f8sm2915896173.137.2025.01.13.11.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 11:45:27 -0800 (PST)
Date: Mon, 13 Jan 2025 14:45:16 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: liulongfang <liulongfang@huawei.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
 <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250113144516.22a17af8.alex.williamson@redhat.com>
In-Reply-To: <20250113083441.0fb7afa3.alex.williamson@redhat.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
	<20241219091800.41462-2-liulongfang@huawei.com>
	<099e0e1215f34d64a4ae698b90ee372c@huawei.com>
	<20250102153008.301730f3.alex.williamson@redhat.com>
	<4d48db10-23e1-1bb4-54ea-4c659ab85f19@huawei.com>
	<20250113083441.0fb7afa3.alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jan 2025 08:34:41 -0500
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 13 Jan 2025 17:43:09 +0800
> liulongfang <liulongfang@huawei.com> wrote:
>=20
> > On 2025/1/3 6:30, Alex Williamson wrote: =20
> > > On Thu, 19 Dec 2024 10:01:03 +0000
> > > Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrot=
e:
> > >    =20
> > >>> -----Original Message-----
> > >>> From: liulongfang <liulongfang@huawei.com>
> > >>> Sent: Thursday, December 19, 2024 9:18 AM
> > >>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> > >>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> > >>> <jonathan.cameron@huawei.com>
> > >>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > >>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> > >>> Subject: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
> > >>>
> > >>> The dma addresses of EQE and AEQE are wrong after migration and
> > >>> results in guest kernel-mode encryption services  failure.
> > >>> Comparing the definition of hardware registers, we found that
> > >>> there was an error when the data read from the register was
> > >>> combined into an address. Therefore, the address combination
> > >>> sequence needs to be corrected.
> > >>>
> > >>> Even after fixing the above problem, we still have an issue
> > >>> where the Guest from an old kernel can get migrated to
> > >>> new kernel and may result in wrong data.
> > >>>
> > >>> In order to ensure that the address is correct after migration,
> > >>> if an old magic number is detected, the dma address needs to be
> > >>> updated.
> > >>>
> > >>> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
> > >>> migration")
> > >>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > >>> ---
> > >>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++=
----
> > >>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
> > >>>  2 files changed, 36 insertions(+), 7 deletions(-)
> > >>>
> > >>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > >>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > >>> index 451c639299eb..8518efea3a52 100644
> > >>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > >>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > >>> @@ -350,6 +350,27 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
> > >>>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
> > >>>  }
> > >>>
> > >>> +static int vf_qm_magic_check(struct acc_vf_data *vf_data)
> > >>> +{
> > >>> +	switch (vf_data->acc_magic) {
> > >>> +	case ACC_DEV_MAGIC_V2:
> > >>> +		break;
> > >>> +	case ACC_DEV_MAGIC_V1:
> > >>> +		/* Correct dma address */
> > >>> +		vf_data->eqe_dma =3D vf_data-     =20
> > >>>> qm_eqc_dw[QM_XQC_ADDR_HIGH];     =20
> > >>> +		vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> > >>> +		vf_data->eqe_dma |=3D vf_data-     =20
> > >>>> qm_eqc_dw[QM_XQC_ADDR_LOW];     =20
> > >>> +		vf_data->aeqe_dma =3D vf_data-     =20
> > >>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];     =20
> > >>> +		vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> > >>> +		vf_data->aeqe_dma |=3D vf_data-     =20
> > >>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];     =20
> > >>> +		break;
> > >>> +	default:
> > >>> +		return -EINVAL;
> > >>> +	}
> > >>> +
> > >>> +	return 0;
> > >>> +}
> > >>> +
> > >>>  static int vf_qm_check_match(struct hisi_acc_vf_core_device
> > >>> *hisi_acc_vdev,
> > >>>  			     struct hisi_acc_vf_migration_file *migf)
> > >>>  {
> > >>> @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct
> > >>> hisi_acc_vf_core_device *hisi_acc_vdev,
> > >>>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-     =20
> > >>>> match_done)     =20
> > >>>  		return 0;
> > >>>
> > >>> -	if (vf_data->acc_magic !=3D ACC_DEV_MAGIC) {
> > >>> +	ret =3D vf_qm_magic_check(vf_data);
> > >>> +	if (ret) {
> > >>>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
> > >>>  		return -EINVAL;
> > >>>  	}
> > >>> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct
> > >>> hisi_acc_vf_core_device *hisi_acc_vdev,
> > >>>  	int vf_id =3D hisi_acc_vdev->vf_id;
> > >>>  	int ret;
> > >>>
> > >>> -	vf_data->acc_magic =3D ACC_DEV_MAGIC;
> > >>> +	vf_data->acc_magic =3D ACC_DEV_MAGIC_V2;
> > >>>  	/* Save device id */
> > >>>  	vf_data->dev_id =3D hisi_acc_vdev->vf_dev->device;
> > >>>
> > >>> @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm
> > >>> *vf_qm, struct acc_vf_data *vf_data)
> > >>>  		return -EINVAL;
> > >>>
> > >>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> > >>> -	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[1];
> > >>> +	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> > >>>  	vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> > >>> -	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[0];
> > >>> -	vf_data->aeqe_dma =3D vf_data->qm_aeqc_dw[1];
> > >>> +	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> > >>> +	vf_data->aeqe_dma =3D vf_data-     =20
> > >>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];     =20
> > >>>  	vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> > >>> -	vf_data->aeqe_dma |=3D vf_data->qm_aeqc_dw[0];
> > >>> +	vf_data->aeqe_dma |=3D vf_data-     =20
> > >>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];     =20
> > >>>
> > >>>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
> > >>>  	ret =3D qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> > >>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > >>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > >>> index 245d7537b2bc..2afce68f5a34 100644
> > >>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > >>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > >>> @@ -39,6 +39,9 @@
> > >>>  #define QM_REG_ADDR_OFFSET	0x0004
> > >>>
> > >>>  #define QM_XQC_ADDR_OFFSET	32U
> > >>> +#define QM_XQC_ADDR_LOW	0x1
> > >>> +#define QM_XQC_ADDR_HIGH	0x2
> > >>> +
> > >>>  #define QM_VF_AEQ_INT_MASK	0x0004
> > >>>  #define QM_VF_EQ_INT_MASK	0x000c
> > >>>  #define QM_IFC_INT_SOURCE_V	0x0020
> > >>> @@ -50,10 +53,14 @@
> > >>>  #define QM_EQC_DW0		0X8000
> > >>>  #define QM_AEQC_DW0		0X8020
> > >>>
> > >>> +enum acc_magic_num {
> > >>> +	ACC_DEV_MAGIC_V1 =3D 0XCDCDCDCDFEEDAACC,
> > >>> +	ACC_DEV_MAGIC_V2 =3D 0xAACCFEEDDECADEDE,     =20
> > >>
> > >>
> > >> I think we have discussed this before that having some kind of=20
> > >> version info embed into magic_num will be beneficial going=20
> > >> forward. ie, may be use the last 4 bytes for denoting version.
> > >>
> > >> ACC_DEV_MAGIC_V2 =3D 0xAACCFEEDDECA0002
> > >>
> > >> The reason being, otherwise we have to come up with a random
> > >> magic each time when a fix like this is required in future.   =20
> > >=20
> > > Overloading the magic value like this is a bit strange.  Typically
> > > the magic value should be the cookie that identifies the data blob as
> > > generated by this driver and a separate version field would identify
> > > any content or format changes.  In the mtty driver I included a magic
> > > field along with major and minor versions to provide this flexibility.
> > > I wonder why we wouldn't do something similar here rather than create
> > > this combination magic/version field.  It's easy enough to append a
> > > couple fields onto the structure or redefine a v2 structure to use
> > > going forward.  There's even a padding field in the structure already
> > > that could be repurposed.
> > >   =20
> >=20
> > If we add the major and minor version numbers like mtty driver, the cur=
rent
> > data structure needs to be changed, and this change also needs to be co=
mpatible
> > with the old and new versions.
> > And the old version does not have this information. The new version can=
not
> > be adapted when it is imported. =20
>=20
> Are you suggesting that we cannot use a different data structure based
> on the magic value?  That's rather the point of the magic value.
>=20
> > Now in this patch to fix this problem, we only need to update a magic n=
umber,
> > and then the problem is corrected. Migration between old and new versio=
ns can
> > also be fixed:
> >=20
> > Old --> Old, wrong, but we can't stop it;
> > Old --> New, corrected migrated incorrect data, recovery successful;
> > New --> New, correct, recovery successful;
> > New --> Old, correct, recovery successful.

BTW, New->Old is not possible given the current old code and this
series doesn't enable it.  New magic is saved, old restore could should
reject it:

static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
                             struct hisi_acc_vf_migration_file *migf)
{      =20
...
        if (vf_data->acc_magic !=3D ACC_DEV_MAGIC) {=20
                dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
                return -EINVAL;=20
        }

=46rom this patch:

@@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core=
_device *hisi_acc_vdev,
 	int vf_id =3D hisi_acc_vdev->vf_id;
 	int ret;
=20
-	vf_data->acc_magic =3D ACC_DEV_MAGIC;
+	vf_data->acc_magic =3D ACC_DEV_MAGIC_V2;
 	/* Save device id */
 	vf_data->dev_id =3D hisi_acc_vdev->vf_dev->device;
=20
Thanks,
Alex

> >=20
> > As for the compatibility issues between old and new versions in the fut=
ure,
> > we do not need to reserve version numbers to deal with them now. Because
> > before encountering specific problems, our design may be redundant. =20
>=20
> A magic value + version number would prevent the need to replace the
> magic value every time an issue is encountered, which I think was also
> Shameer's commit, which is not addressed by forcing the formatting of a
> portion of the magic value.  None of what you're trying to do here
> precludes a new data structure for the new magic value or defining the
> padding fields for different use cases.  Thanks,
>=20
> Alex


