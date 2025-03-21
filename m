Return-Path: <kvm+bounces-41678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53197A6BEE1
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78C3716C3E7
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D13822C34A;
	Fri, 21 Mar 2025 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XAMKgAws"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596A6224253
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742572369; cv=none; b=Ol2h7e5SVYxBZHfbtDVRwPpr/5SRIaNivUD9mQt6OrfkkUf8hyCdFddju+GRWSawDa6uqlSDAyWmCBT5U5T2LLFDU3IrKcHSw2JKJEEkn/VAnUEy9OQqjiFF/pyQ/PIZtzq2DxR8+AWzoWwUcF8ZZamtyDoszMeCzbqBnGRoUIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742572369; c=relaxed/simple;
	bh=GnYJNN30ArioqBq84YCpxjxypr/yQcxXAVwcizPHgMw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NlsBcyuELVp9dlVQI0WWMs8uq6Z698SR5BOYfDJMTn4pNVj80r0pPtN28/z36WX3CrsNjW7p5BQnX51WvnbaGBFdb9onx2rvf8wjrMymk18ajKWn5fzbK2whgNlEgreOFbROSp3hycs2QIcIQtQ0Ze34ytD1yt0MmONxP9JP4Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XAMKgAws; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742572366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lw4tIV8t2velBqSGDFXs1U2au71hmJlMHn//DKDjNqU=;
	b=XAMKgAwsCNExPs85uOmLskerZi5Tj/NiMAgvpCMmvCEI8CZRl9xT0xzhA3iHdQM87YvILX
	6A8kA3tN7/Idy+L2oLt06g9JWmj8GJ1pDMAqC4wi/NZcSljot+LQr4WXoOPq18ccjtDfaS
	WJ9Px7Xi5jeO7EqtEfifFEYsMgzMOpY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-xLfC95OMOLu108sQMNwGzw-1; Fri, 21 Mar 2025 11:52:44 -0400
X-MC-Unique: xLfC95OMOLu108sQMNwGzw-1
X-Mimecast-MFC-AGG-ID: xLfC95OMOLu108sQMNwGzw_1742572364
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85da07ce5cbso31231939f.2
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 08:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742572364; x=1743177164;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lw4tIV8t2velBqSGDFXs1U2au71hmJlMHn//DKDjNqU=;
        b=PRk9ZMIgKY2DYht9/tq1GdHywZHqjdhiBGtj+p3KiwHA14uk38EkVYotVHLhtCnDiF
         5RfoMvR8RIqj+7H/SUfq53Qf56etl2Z4VZ87eZ7B82wzA/xwxjtBEtNdb3VZZejJ6PYC
         itzLJGFxnvmKzYKsg3eMp69QaDiKKpt5u9jffITQne2Bij9LVXMKDhMhWIOkri8PM9dP
         mOKXdyic7uJAoA9rwfJ8TTEA62eMONUDEOE2HfmJqq2rcI2Ng7MwuA128Ff+KhYCoCbl
         Id7sDPDI8extyMypWp9Erh0VoPEw1NvanoLT9puPP6+1pP5V8tseMinkV3588YMYrho7
         NZng==
X-Forwarded-Encrypted: i=1; AJvYcCXkldjst+dPz/XXwHocGq60+76nAgw3V+yO3VPpy2UUUUOWlEp4kBMnIgthI8pfgAfQb4U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxmO06cwCc47AS/AxK0AhtH4vESG34A2sS8cBY8bqu+exuuzX5
	hvGr7I3QCv+6sApFaNqMzY/gZRPgpw8RBv2y0Ec7RJ0bpdtAk4+y/9Q+l8/MwN4vuvG0554bXqh
	o6mQIDXDJUPrsua5mWk1p4IvI/GFcxVLK9H1yFpPkxVhcfIhzdw==
X-Gm-Gg: ASbGnctYpwlzG7QhOj0yoo9JpT3k3AIbPBNLqMWFYFkZQsn8AEbDhD0jr59AekUegUe
	2zmSIl3AmPJtVbhvOdJJWMqgCmRjlb4nXF50muG5RWEC1mwN5+nKd1c8Ro11LPaSzniRIO+g+Aq
	7sddDgavXREkpF5A6Xo1IknZuRqXzoUj8p8OXLW93TdhHdB0neUktat47V1inyWGng+ZL8ao1jE
	hd40mW18D/2w9HhqbBN56mKUImIDGMG+K4LllDu54hcJFZN71L/lZYGWcDsa1zLbT1rQYssixel
	YNPOz98w3qvQArjh5fY=
X-Received: by 2002:a92:cd87:0:b0:3d3:d187:7481 with SMTP id e9e14a558f8ab-3d59c331683mr416375ab.1.1742572363833;
        Fri, 21 Mar 2025 08:52:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNF0rfCObrqaWNyBO2CmHGiB8P4GBb5NFORtVt9K+hAaNEXXDIxgqmXZW65xMhulGgmm8UVA==
X-Received: by 2002:a92:cd87:0:b0:3d3:d187:7481 with SMTP id e9e14a558f8ab-3d59c331683mr416305ab.1.1742572363420;
        Fri, 21 Mar 2025 08:52:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdb3befsm493367173.24.2025.03.21.08.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 08:52:42 -0700 (PDT)
Date: Fri, 21 Mar 2025 09:52:40 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 5/5] hisi_acc_vfio_pci: bugfix live migration
 function without VF device driver
Message-ID: <20250321095240.40bf55ec.alex.williamson@redhat.com>
In-Reply-To: <20250318064548.59043-6-liulongfang@huawei.com>
References: <20250318064548.59043-1-liulongfang@huawei.com>
	<20250318064548.59043-6-liulongfang@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Mar 2025 14:45:48 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> If the VF device driver is not loaded in the Guest OS and we attempt to
> perform device data migration, the address of the migrated data will
> be NULL.
> The live migration recovery operation on the destination side will
> access a null address value, which will cause access errors.
> 
> Therefore, live migration of VMs without added VF device drivers
> does not require device data migration.
> In addition, when the queue address data obtained by the destination
> is empty, device queue recovery processing will not be performed.
> 
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index cadc82419dca..68b1c7204cad 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -426,13 +426,6 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return -EINVAL;
>  	}
>  
> -	ret = qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
> -	if (ret) {
> -		dev_err(dev, "failed to write QM_VF_STATE\n");
> -		return ret;
> -	}
> -
> -	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>  	hisi_acc_vdev->match_done = true;
>  	return 0;
>  }
> @@ -498,6 +491,13 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < sizeof(struct acc_vf_data))
>  		return -EINVAL;
>  
> +	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
> +	if (ret) {
> +		dev_err(dev, "failed to write QM_VF_STATE\n");
> +		return -EINVAL;
> +	}
> +	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
> +
>  	qm->eqe_dma = vf_data->eqe_dma;
>  	qm->aeqe_dma = vf_data->aeqe_dma;
>  	qm->sqc_dma = vf_data->sqc_dma;
> @@ -506,6 +506,12 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	qm->qp_base = vf_data->qp_base;
>  	qm->qp_num = vf_data->qp_num;
>  
> +	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
> +	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
> +		dev_err(dev, "resume dma addr is NULL!\n");
> +		return -EINVAL;
> +	}
> +

I'm not sure how this fits in based on the commit log.  IIUC, we're
actually rejecting the migration data here, which will cause a
migration failure.  We're also testing the validity of the data *after*
we've actually applied it to the hisi_qm object, which seems backwards.

Are we just not processing the migration data because there's no driver
or are we failing the migration?  There shouldn't be a requirement on
the state of the guest driver for a successful migration.  Thanks,

Alex

>  	ret = qm_set_regs(qm, vf_data);
>  	if (ret) {
>  		dev_err(dev, "set VF regs failed\n");
> @@ -1531,6 +1537,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
>  	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
>  	hisi_acc_vdev->pf_qm = pf_qm;
>  	hisi_acc_vdev->vf_dev = pdev;
> +	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
>  	mutex_init(&hisi_acc_vdev->open_mutex);
>  


