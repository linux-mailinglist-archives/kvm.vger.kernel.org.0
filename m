Return-Path: <kvm+bounces-35290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B6BA0B841
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 14:35:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CC2318856F5
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 13:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4BD235BE2;
	Mon, 13 Jan 2025 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bUEfEw40"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A432233138
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 13:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736775302; cv=none; b=ozEBjTL29ahDmuxTe6KZSSjFwCda0EgeeCZQa8yU7hq4JVBCn7ywb94IF7R1OD2e5vReNF/wB8qPTfbUKZzTQL7/bs8XJCB1/eqyhIyxMwXeCfp/+bNTZP7bhsdeH84JgHhxgUak7923Qx9Rlq2LYw0ry29rhZx2px9+FsoYev4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736775302; c=relaxed/simple;
	bh=tyY/mwl+w0TM6APM6p8YfZXtcSdDWEejjltd7q1H1o4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BaCBcqco8bLAQNRazteEo1wO3lwPowYXwe+0wu08kC+N9ypJeJ3N6PnpV0bl2/cGS9J0tKqTtcDSWy5kNslwMZ2+nvl7snNQmmR5zNbm98oV9bX71SFxvMELym6eUvW653WneToQl1tDC3JAsY3XGM4pz67+eXg+3K5dd7ob7tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bUEfEw40; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736775298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Wh+orv/LYf7JgyoDOHd4i4UK6ygNBWZmqX04TPWjF0=;
	b=bUEfEw40IPm/seO461iainJy3wQXhCRk5GB+s10VK2WzeeuKxPNGQJoeR/updLnj41YVc2
	fQEheQVsOr2LdhKCSu9mukJZeVK/JjQ1WM/s+YUx2fYg0nG6SzYgOKEfk6pSg13/3JFtiD
	tyFv+85zXwGRazzX8MemzvDDV0yAAe8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-6YnxhZjdMxC0wdj1t30_XQ-1; Mon, 13 Jan 2025 08:34:54 -0500
X-MC-Unique: 6YnxhZjdMxC0wdj1t30_XQ-1
X-Mimecast-MFC-AGG-ID: 6YnxhZjdMxC0wdj1t30_XQ
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844dc7004d8so18694739f.2
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 05:34:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736775294; x=1737380094;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Wh+orv/LYf7JgyoDOHd4i4UK6ygNBWZmqX04TPWjF0=;
        b=iT+eGCnKQC6rV9ExdbTyywwgwcCEct4eeJBsNmwR6NfOhbKii56IFaovqwAE1hdShf
         1cerpcCFghYeoFBOTHNmTi8Stgj2188YzczMR7AgFyQgkh4h4HTp1H1H5rnrk1K3y+Om
         TpJ0MZ3qvvexTjLfvHoP2Cid/LpZgJYOqNxTKplDwXXm4hcBGfMDsNs8AldsuE+mj7Mv
         2Ox2xVVX9sBSnj/eno0PXbVCR/Ydhgt/KXNSNJEjGMeJ5kqz7ITKMgO2ouyHnv8ZoNPQ
         JOvFlMHXzatwNhI3tH0+N7rj6v4WznuiJPIrww0aEawhSdS5Y0jQsIMeqwI84ZsP/PBl
         wSFg==
X-Forwarded-Encrypted: i=1; AJvYcCV0ckuHX/cVesFPNiB6527LUG55ZON/gGenKLtcwJUHS3M9mVI5uBg5jFbzJbVB3LrvilM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFn1BPAWXFtnKLZnUB+PvLDU2P08XM235l5RAFADKaq0oTnc4K
	rnjqLfi3/2JSDQM7/uVjTogDp51LrwMBEMkthZhOSJE0p6BqdySU7O3r+HoL+ELecrdcmfGjZou
	nLr2aqN82jGmIyJTGgR81LyUoyaN2Ci80PJJush6zg6XkZXJ4Vymrq+CZ7A==
X-Gm-Gg: ASbGnctYFv32op7306ZqfYNxACtrct/LUx5xKN0mVsk+UaLzUCsazMRfjl4iVOL9B+9
	aD96DCDcntvxTm+VqfBQujN34PBQouXif0ipNiaYiAM2jDbpj951Vv8A9hmEhaiKdYMTOsavehu
	UrVnpMm+nBBCCbmDtvxd6BURr26bM3SFcERDGCSAcsmNi+sO02gNjUPWIvq2BFMXrUcW2+vH20j
	pMkRPDoCGPy1oM9rr1or1yAFl37evKkilfpJ2rd/drb4N1ntiRNZjFhLl4w
X-Received: by 2002:a05:6602:27cb:b0:83a:e6b2:be3 with SMTP id ca18e2360f4ac-84cdfde7bc7mr529500939f.0.1736775293769;
        Mon, 13 Jan 2025 05:34:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjnk3QgDRJCgvEwyINp4QXsbEBSoc6YKN9QzOcCBG9wNe41jclREALhrCqtuAgkYV8fx2jyQ==
X-Received: by 2002:a05:6602:27cb:b0:83a:e6b2:be3 with SMTP id ca18e2360f4ac-84cdfde7bc7mr529499939f.0.1736775293426;
        Mon, 13 Jan 2025 05:34:53 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d61fa3d8asm261995839f.31.2025.01.13.05.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 05:34:52 -0800 (PST)
Date: Mon, 13 Jan 2025 08:34:41 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: liulongfang <liulongfang@huawei.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
 <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250113083441.0fb7afa3.alex.williamson@redhat.com>
In-Reply-To: <4d48db10-23e1-1bb4-54ea-4c659ab85f19@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
	<20241219091800.41462-2-liulongfang@huawei.com>
	<099e0e1215f34d64a4ae698b90ee372c@huawei.com>
	<20250102153008.301730f3.alex.williamson@redhat.com>
	<4d48db10-23e1-1bb4-54ea-4c659ab85f19@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 Jan 2025 17:43:09 +0800
liulongfang <liulongfang@huawei.com> wrote:

> On 2025/1/3 6:30, Alex Williamson wrote:
> > On Thu, 19 Dec 2024 10:01:03 +0000
> > Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
> >   
> >>> -----Original Message-----
> >>> From: liulongfang <liulongfang@huawei.com>
> >>> Sent: Thursday, December 19, 2024 9:18 AM
> >>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> >>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> >>> <jonathan.cameron@huawei.com>
> >>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> >>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> >>> Subject: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
> >>>
> >>> The dma addresses of EQE and AEQE are wrong after migration and
> >>> results in guest kernel-mode encryption services  failure.
> >>> Comparing the definition of hardware registers, we found that
> >>> there was an error when the data read from the register was
> >>> combined into an address. Therefore, the address combination
> >>> sequence needs to be corrected.
> >>>
> >>> Even after fixing the above problem, we still have an issue
> >>> where the Guest from an old kernel can get migrated to
> >>> new kernel and may result in wrong data.
> >>>
> >>> In order to ensure that the address is correct after migration,
> >>> if an old magic number is detected, the dma address needs to be
> >>> updated.
> >>>
> >>> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
> >>> migration")
> >>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >>> ---
> >>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++----
> >>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
> >>>  2 files changed, 36 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >>> index 451c639299eb..8518efea3a52 100644
> >>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >>> @@ -350,6 +350,27 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
> >>>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
> >>>  }
> >>>
> >>> +static int vf_qm_magic_check(struct acc_vf_data *vf_data)
> >>> +{
> >>> +	switch (vf_data->acc_magic) {
> >>> +	case ACC_DEV_MAGIC_V2:
> >>> +		break;
> >>> +	case ACC_DEV_MAGIC_V1:
> >>> +		/* Correct dma address */
> >>> +		vf_data->eqe_dma = vf_data-    
> >>>> qm_eqc_dw[QM_XQC_ADDR_HIGH];    
> >>> +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> >>> +		vf_data->eqe_dma |= vf_data-    
> >>>> qm_eqc_dw[QM_XQC_ADDR_LOW];    
> >>> +		vf_data->aeqe_dma = vf_data-    
> >>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];    
> >>> +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> >>> +		vf_data->aeqe_dma |= vf_data-    
> >>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];    
> >>> +		break;
> >>> +	default:
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>>  static int vf_qm_check_match(struct hisi_acc_vf_core_device
> >>> *hisi_acc_vdev,
> >>>  			     struct hisi_acc_vf_migration_file *migf)
> >>>  {
> >>> @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct
> >>> hisi_acc_vf_core_device *hisi_acc_vdev,
> >>>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-    
> >>>> match_done)    
> >>>  		return 0;
> >>>
> >>> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
> >>> +	ret = vf_qm_magic_check(vf_data);
> >>> +	if (ret) {
> >>>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
> >>>  		return -EINVAL;
> >>>  	}
> >>> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct
> >>> hisi_acc_vf_core_device *hisi_acc_vdev,
> >>>  	int vf_id = hisi_acc_vdev->vf_id;
> >>>  	int ret;
> >>>
> >>> -	vf_data->acc_magic = ACC_DEV_MAGIC;
> >>> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
> >>>  	/* Save device id */
> >>>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
> >>>
> >>> @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm
> >>> *vf_qm, struct acc_vf_data *vf_data)
> >>>  		return -EINVAL;
> >>>
> >>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> >>> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
> >>> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> >>>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> >>> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
> >>> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
> >>> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> >>> +	vf_data->aeqe_dma = vf_data-    
> >>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];    
> >>>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> >>> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
> >>> +	vf_data->aeqe_dma |= vf_data-    
> >>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];    
> >>>
> >>>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
> >>>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> >>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >>> index 245d7537b2bc..2afce68f5a34 100644
> >>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >>> @@ -39,6 +39,9 @@
> >>>  #define QM_REG_ADDR_OFFSET	0x0004
> >>>
> >>>  #define QM_XQC_ADDR_OFFSET	32U
> >>> +#define QM_XQC_ADDR_LOW	0x1
> >>> +#define QM_XQC_ADDR_HIGH	0x2
> >>> +
> >>>  #define QM_VF_AEQ_INT_MASK	0x0004
> >>>  #define QM_VF_EQ_INT_MASK	0x000c
> >>>  #define QM_IFC_INT_SOURCE_V	0x0020
> >>> @@ -50,10 +53,14 @@
> >>>  #define QM_EQC_DW0		0X8000
> >>>  #define QM_AEQC_DW0		0X8020
> >>>
> >>> +enum acc_magic_num {
> >>> +	ACC_DEV_MAGIC_V1 = 0XCDCDCDCDFEEDAACC,
> >>> +	ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECADEDE,    
> >>
> >>
> >> I think we have discussed this before that having some kind of 
> >> version info embed into magic_num will be beneficial going 
> >> forward. ie, may be use the last 4 bytes for denoting version.
> >>
> >> ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECA0002
> >>
> >> The reason being, otherwise we have to come up with a random
> >> magic each time when a fix like this is required in future.  
> > 
> > Overloading the magic value like this is a bit strange.  Typically
> > the magic value should be the cookie that identifies the data blob as
> > generated by this driver and a separate version field would identify
> > any content or format changes.  In the mtty driver I included a magic
> > field along with major and minor versions to provide this flexibility.
> > I wonder why we wouldn't do something similar here rather than create
> > this combination magic/version field.  It's easy enough to append a
> > couple fields onto the structure or redefine a v2 structure to use
> > going forward.  There's even a padding field in the structure already
> > that could be repurposed.
> >  
> 
> If we add the major and minor version numbers like mtty driver, the current
> data structure needs to be changed, and this change also needs to be compatible
> with the old and new versions.
> And the old version does not have this information. The new version cannot
> be adapted when it is imported.

Are you suggesting that we cannot use a different data structure based
on the magic value?  That's rather the point of the magic value.

> Now in this patch to fix this problem, we only need to update a magic number,
> and then the problem is corrected. Migration between old and new versions can
> also be fixed:
> 
> Old --> Old, wrong, but we can't stop it;
> Old --> New, corrected migrated incorrect data, recovery successful;
> New --> New, correct, recovery successful;
> New --> Old, correct, recovery successful.
> 
> As for the compatibility issues between old and new versions in the future,
> we do not need to reserve version numbers to deal with them now. Because
> before encountering specific problems, our design may be redundant.

A magic value + version number would prevent the need to replace the
magic value every time an issue is encountered, which I think was also
Shameer's commit, which is not addressed by forcing the formatting of a
portion of the magic value.  None of what you're trying to do here
precludes a new data structure for the new magic value or defining the
padding fields for different use cases.  Thanks,

Alex


