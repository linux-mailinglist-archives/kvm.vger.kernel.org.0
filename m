Return-Path: <kvm+bounces-34509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B85A0012F
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 23:30:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6C316316C
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 22:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889811BD9EA;
	Thu,  2 Jan 2025 22:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RX8XGvWC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEBE1BD504
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 22:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735857016; cv=none; b=aBo7WCDWGX6CE++fSdfaH8YROR+eoCdPwUjWiuibyqQVQoxcq1Pjv5LcwEW7UjrSwy/icRSgD6C9+sBNN8l9aijyzAVdUgAI/RTofxgYvtWUIMfUAyO+fPJRw/PbUUqQwE0ZJTX4VbAVr5S4mXmRAJpEO5Y2jwvBM2OqJcDyiNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735857016; c=relaxed/simple;
	bh=hMSNwlRgNE/L7bMLE5kvRjjZbQ5lbZsTS2EvxU5bg0A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LlSE2qJc9A9BB0mB26Os3POHjY5we7pisuNBTEP9dxz8NpwOD/o+kHmOyfiyE+OFhjleoAG+6IO/oCGQBx4HVCnd7RdIxM57Xm//iIAwJzIuNfX38rsO7Rzf4QRfYZ5miKp7BXTXtLc4XmWMqh2OJd0z3WFeV0pw9AzhsD+BeSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RX8XGvWC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735857012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ppthJ8pAwyxfIkRpsIYKpDcDgPdS4EZir8kbY1qAI8=;
	b=RX8XGvWCURBEHIaux9LUw+7zXRnv8JWiuSz1D+A4QrvX16UudD55GR6CHWEZhOqIwCaxJu
	F2p0Co+aqxSsA4aYlHWEspvyQ5in3L4RLXX5nxtBe/PAtAp/xjQq5IFX9VvyxiXlKnEhf+
	zvLk3JEGEnB/TueeJewL4n/oFz2tdu4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-m5hgKCYIMHmnGdeYEuyaKw-1; Thu, 02 Jan 2025 17:30:11 -0500
X-MC-Unique: m5hgKCYIMHmnGdeYEuyaKw-1
X-Mimecast-MFC-AGG-ID: m5hgKCYIMHmnGdeYEuyaKw
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-84990d44b31so30334539f.3
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2025 14:30:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735857011; x=1736461811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ppthJ8pAwyxfIkRpsIYKpDcDgPdS4EZir8kbY1qAI8=;
        b=B0i0BCp2Msksel6JaUncGgxDfNO/9twH36VWYiZ8MzpDK3f2493XmTcSSmRUZylwiD
         MC3tG3edA5nOSfVh44U5IkMo4qZ3IS9JaeTFOcf91cKHWIZgXnJcCHwhmgXFpdEtv+NK
         ombsKE9LN0cArMRquQS3Kdv6jc31pTb9YtdRjOuXSEh37/Bjj0Po1uxQ9gBxQZ7Y74oW
         njIEoM3Mt6m6tf4S3ajKUIsxeagdFrLmhYRWuioQA3lL3zgVlutXTDPrW7riA2Bl2mRW
         OtleqCKBxAnDGtfTrm1t2O2rw6e/JMmg2W07e++5+BRUjhEUA9gHbUCs7a60fOrUBafH
         djgw==
X-Forwarded-Encrypted: i=1; AJvYcCX4R04pJOLkfpVh1cFiNjyPZ8K2hZ+9EaLvHZkz90UAxxBaOuMaQ1Rc6FeAv5bF+r4/XGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtJ9XGb2xNWOLih1+yT6lmzHVnxhiuw3yF6KrMW4uNomF37u0a
	aj7k/4UawiO/3BWOPC6On4oqg4leLYPjk9OsV5G5zzCiATVE8GR5IvndeV0bylcx4aIEciJZ+6X
	dQ05RnUwKJTCsDlaIxQCu9r1EZWe35xFDjaAw+h5LyTE68NdLGg==
X-Gm-Gg: ASbGncu3t78qqYMsI7baxneDaXtRu08zZ7BHSrY79nyf8gSTqM1Ob4ksV6/HdlVtjex
	yMlCKVF4OzGCxmK89s+TYEkNs9sTbIRc3sDIjeHg7vE0ZezBwxwGnuDXs4MNK4CLXOUVwcZQijk
	y1BdkuPi1Aw0pA3aVnbPLlfP1LxRtiJ47bGygrG92pJp5Jp7IuT+g9M36YL1sbNx8wNunmap/yc
	ikhkiGnWdiobQ3g51qTEwh/jTQlY7DyOiVbjwh8Spy6Zi2a9FLIOU5hHfNb
X-Received: by 2002:a05:6e02:3882:b0:3a7:be5c:1422 with SMTP id e9e14a558f8ab-3c2d479cd10mr114585215ab.3.1735857010839;
        Thu, 02 Jan 2025 14:30:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFf9jv7Iv+7P0Jwzyi8R0s6ylOlwCQGbJ3sK5sdytj6nlWH/jJpR3jV/czJGVg1XMsOpKNbQ==
X-Received: by 2002:a05:6e02:3882:b0:3a7:be5c:1422 with SMTP id e9e14a558f8ab-3c2d479cd10mr114585115ab.3.1735857010375;
        Thu, 02 Jan 2025 14:30:10 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0deccf405sm79134065ab.29.2025.01.02.14.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 14:30:09 -0800 (PST)
Date: Thu, 2 Jan 2025 15:30:08 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: liulongfang <liulongfang@huawei.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "Jonathan Cameron" <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linuxarm@openeuler.org"
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250102153008.301730f3.alex.williamson@redhat.com>
In-Reply-To: <099e0e1215f34d64a4ae698b90ee372c@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
	<20241219091800.41462-2-liulongfang@huawei.com>
	<099e0e1215f34d64a4ae698b90ee372c@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Dec 2024 10:01:03 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: liulongfang <liulongfang@huawei.com>
> > Sent: Thursday, December 19, 2024 9:18 AM
> > To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> > Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> > Subject: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
> > 
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
> > Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
> > migration")
> > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > ---
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++----
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
> >  2 files changed, 36 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > index 451c639299eb..8518efea3a52 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > @@ -350,6 +350,27 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
> >  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
> >  }
> > 
> > +static int vf_qm_magic_check(struct acc_vf_data *vf_data)
> > +{
> > +	switch (vf_data->acc_magic) {
> > +	case ACC_DEV_MAGIC_V2:
> > +		break;
> > +	case ACC_DEV_MAGIC_V1:
> > +		/* Correct dma address */
> > +		vf_data->eqe_dma = vf_data-  
> > >qm_eqc_dw[QM_XQC_ADDR_HIGH];  
> > +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> > +		vf_data->eqe_dma |= vf_data-  
> > >qm_eqc_dw[QM_XQC_ADDR_LOW];  
> > +		vf_data->aeqe_dma = vf_data-  
> > >qm_aeqc_dw[QM_XQC_ADDR_HIGH];  
> > +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> > +		vf_data->aeqe_dma |= vf_data-  
> > >qm_aeqc_dw[QM_XQC_ADDR_LOW];  
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int vf_qm_check_match(struct hisi_acc_vf_core_device
> > *hisi_acc_vdev,
> >  			     struct hisi_acc_vf_migration_file *migf)
> >  {
> > @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct
> > hisi_acc_vf_core_device *hisi_acc_vdev,
> >  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-  
> > >match_done)  
> >  		return 0;
> > 
> > -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
> > +	ret = vf_qm_magic_check(vf_data);
> > +	if (ret) {
> >  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
> >  		return -EINVAL;
> >  	}
> > @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct
> > hisi_acc_vf_core_device *hisi_acc_vdev,
> >  	int vf_id = hisi_acc_vdev->vf_id;
> >  	int ret;
> > 
> > -	vf_data->acc_magic = ACC_DEV_MAGIC;
> > +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
> >  	/* Save device id */
> >  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
> > 
> > @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm
> > *vf_qm, struct acc_vf_data *vf_data)
> >  		return -EINVAL;
> > 
> >  	/* Every reg is 32 bit, the dma address is 64 bit. */
> > -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
> > +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> >  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> > -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
> > -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
> > +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> > +	vf_data->aeqe_dma = vf_data-  
> > >qm_aeqc_dw[QM_XQC_ADDR_HIGH];  
> >  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> > -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
> > +	vf_data->aeqe_dma |= vf_data-  
> > >qm_aeqc_dw[QM_XQC_ADDR_LOW];  
> > 
> >  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
> >  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > index 245d7537b2bc..2afce68f5a34 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > @@ -39,6 +39,9 @@
> >  #define QM_REG_ADDR_OFFSET	0x0004
> > 
> >  #define QM_XQC_ADDR_OFFSET	32U
> > +#define QM_XQC_ADDR_LOW	0x1
> > +#define QM_XQC_ADDR_HIGH	0x2
> > +
> >  #define QM_VF_AEQ_INT_MASK	0x0004
> >  #define QM_VF_EQ_INT_MASK	0x000c
> >  #define QM_IFC_INT_SOURCE_V	0x0020
> > @@ -50,10 +53,14 @@
> >  #define QM_EQC_DW0		0X8000
> >  #define QM_AEQC_DW0		0X8020
> > 
> > +enum acc_magic_num {
> > +	ACC_DEV_MAGIC_V1 = 0XCDCDCDCDFEEDAACC,
> > +	ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECADEDE,  
> 
> 
> I think we have discussed this before that having some kind of 
> version info embed into magic_num will be beneficial going 
> forward. ie, may be use the last 4 bytes for denoting version.
> 
> ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECA0002
> 
> The reason being, otherwise we have to come up with a random
> magic each time when a fix like this is required in future.

Overloading the magic value like this is a bit strange.  Typically
the magic value should be the cookie that identifies the data blob as
generated by this driver and a separate version field would identify
any content or format changes.  In the mtty driver I included a magic
field along with major and minor versions to provide this flexibility.
I wonder why we wouldn't do something similar here rather than create
this combination magic/version field.  It's easy enough to append a
couple fields onto the structure or redefine a v2 structure to use
going forward.  There's even a padding field in the structure already
that could be repurposed.

I see v3 went on to modify the v2 magic as described here, but there's
nothing to suggest the use of these latter bytes as anything other than
a slightly different random magic value.  Minimally the suggestion
should have resulted in 6-bytes of magic and 2-bytes of version (iiuc),
but there's no code to support that nor would I recommend that layout
versus the alternatives above.  Thanks,

Alex


