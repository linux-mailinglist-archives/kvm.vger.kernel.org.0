Return-Path: <kvm+bounces-34510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 356A5A00138
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 23:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3704C1883DC5
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 22:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D501B6D0B;
	Thu,  2 Jan 2025 22:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Au4FnoQU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7503E2AF1D
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735857352; cv=none; b=iUvJc5qqkEKnfCv7GkplXO/wbFgvR+5oOxLiwg3fopbncKI81RVtzzCZUK8mQpcvKwMyJoIVsI4quTD5aKv0SAMlGPtB4R2RHFkX3tu0UlFvSH2YxfyJx2TMxqXe3EY5MB7vO2nTkme4aUbdM0znek+4/bPzxdF650SEdo1LTQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735857352; c=relaxed/simple;
	bh=dGV20YCThfDBQrtv7hlpmIZHYagZtxFpi8s6kRZ7pN0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DqbV4/XrGRDYLehY0napBY5UPKCUeZoLHQ5wRA2HKgg6i6wTW0BQai8pVMUXO9gIf4Wa4g8+1OdanV+jswpnOMaauQlr/DjYIVgqMam/l5qOahiWi6ywUOGAsja+4d65/bk1GD8oej3TB/bBnKIGXhsDugw4BtaWIybijlhsGxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Au4FnoQU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735857349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MzKRjlveAbiYMATYEwaUD1WfheCnJ/JGFG4rwLPCkvI=;
	b=Au4FnoQUvN6wQUZC9BSr6qQPywNgAAsOAF+bN+/eBshVNRZmcXO/1OMDR6cs5iNCk5LAQ+
	Uu8DYU5Kz3LrPrSn3BYz9SKxEHGrtGztjK4VXenkH9nmEExb0q6P9biKQlEIx8yjU0Vwf/
	mFv+6/cpT65jzIiroJjIlI6qMIjE75Y=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-zVm3kiDrNBKbcS5hCTudeg-1; Thu, 02 Jan 2025 17:35:48 -0500
X-MC-Unique: zVm3kiDrNBKbcS5hCTudeg-1
X-Mimecast-MFC-AGG-ID: zVm3kiDrNBKbcS5hCTudeg
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a9d431dd89so16276675ab.0
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2025 14:35:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735857347; x=1736462147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzKRjlveAbiYMATYEwaUD1WfheCnJ/JGFG4rwLPCkvI=;
        b=voQgxOo0u9ubtc1tWSVmfsHF3w8VWmEDYDpmAh+MHxuo0AL+tVGSVLLWaNjiT8IXHM
         KrZQNFRhqJ2caDO4VZMCbgguoImOPktFWOCjX9etC9vhq0MTR5dvGfbszB1Lw0KZQEwX
         YPcNe11r3GPbo6BUb7JFGS/p73IOEVcV5xtC/BogOKiZjb5/Ahab9BQGghwKHA9AHTXL
         wlwqkdVA1ewsPS1LxMb8pW0OQZ8nOSU7YCKFphnIlYMJ53BFXWB2yuFyjN6m56BAoHz2
         vncH2xq1267XiPYqeys4n0bJ6LOpMDoeGM5yGrC2n+IFaNa/BPLYnKrW9VX5nrhwqSI4
         SKyw==
X-Forwarded-Encrypted: i=1; AJvYcCWfDiIpTeTt7rdCGEI6a+iXWOE8oAabF8ZVzwhLIcSduBqWD7XFDlceXaoyEoE475XHMCU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy6EqajXdui4Wwesmwc7gCWTytSb4jWaezn1OJekwPvcNmoXHL
	whth2yS7X9TlRafus2H+6M8rxXJByAgMF2i07tmnaLJETpTP8ZdfsnVP5hKKa5vcmrLIZNMeHJW
	oaFbPqyzeq6KwtkNKbgUt+z0Le4Uw/eWteE3wXQZqmrKcpsuhxA==
X-Gm-Gg: ASbGnctaU0uDXDzC+/KnvpMOxB/13o+9kTmgAhvQXqXUvnikM89oV1pFew2MGO1bJ2I
	ou5Fq4GmoUOKnHHaVZhNl4cT4LgYO7et3AFqFdoQQoga7awyS9Gyv+3lmiOXIXudBd4/Otb2aZq
	H6V6hGA04oYMDc2EM5jFIUYTP12KTQv0YEqzk3Ps066ZcGFuL3KWF+6FylkzNruClRFuT3k29An
	BdjrMJlUsugbQjpB8A3sVtWB14cmGkNLtqKvDJnyZmd5Suv6Dj8JyNRgvW4
X-Received: by 2002:a05:6e02:1a66:b0:3a7:de79:4bae with SMTP id e9e14a558f8ab-3c2d591aba1mr106124245ab.6.1735857346961;
        Thu, 02 Jan 2025 14:35:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEb+Y4kOZXRVpqZx0JlxT290QAPUTZyIF0BVLxHu1mIFJW7OreZP55bkR7pbKdAnSwVIZOT4g==
X-Received: by 2002:a05:6e02:1a66:b0:3a7:de79:4bae with SMTP id e9e14a558f8ab-3c2d591aba1mr106124175ab.6.1735857346628;
        Thu, 02 Jan 2025 14:35:46 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0deccf34fsm76638435ab.30.2025.01.02.14.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 14:35:46 -0800 (PST)
Date: Thu, 2 Jan 2025 15:35:45 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v3 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250102153545.5dce8d1e.alex.williamson@redhat.com>
In-Reply-To: <20250102030729.34115-2-liulongfang@huawei.com>
References: <20250102030729.34115-1-liulongfang@huawei.com>
	<20250102030729.34115-2-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 2 Jan 2025 11:07:25 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> The dma addresses of EQE and AEQE are wrong after migration and
> results in guest kernel-mode encryption services  failure.
> Comparing the definition of hardware registers, we found that
> there was an error when the data read from the register was
> combined into an address. Therefore, the address combination
> sequence needs to be corrected.
> 
> Even after fixing the above problem, we still have an issue
> where the Guest from an old kernel can get migrated to
> new kernel and may result in wrong data.
> 
> In order to ensure that the address is correct after migration,
> if an old magic number is detected, the dma address needs to be
> updated.
> 
> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live migration")

Please use the proper Fixes: tag layout throughout.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n145

(spaces are missing between fields)

Thanks,
Alex

> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++----
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
>  2 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 451c639299eb..8518efea3a52 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -350,6 +350,27 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>  }
>  
> +static int vf_qm_magic_check(struct acc_vf_data *vf_data)
> +{
> +	switch (vf_data->acc_magic) {
> +	case ACC_DEV_MAGIC_V2:
> +		break;
> +	case ACC_DEV_MAGIC_V1:
> +		/* Correct dma address */
> +		vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> +		vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> +		vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
> +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> +		vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  			     struct hisi_acc_vf_migration_file *migf)
>  {
> @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
>  		return 0;
>  
> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
> +	ret = vf_qm_magic_check(vf_data);
> +	if (ret) {
>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>  		return -EINVAL;
>  	}
> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	int vf_id = hisi_acc_vdev->vf_id;
>  	int ret;
>  
> -	vf_data->acc_magic = ACC_DEV_MAGIC;
> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
>  	/* Save device id */
>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>  
> @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
>  		return -EINVAL;
>  
>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> +	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
> +	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
>  
>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 245d7537b2bc..d26eb751fb82 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -39,6 +39,9 @@
>  #define QM_REG_ADDR_OFFSET	0x0004
>  
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
>  
> +enum acc_magic_num {
> +	ACC_DEV_MAGIC_V1 = 0XCDCDCDCDFEEDAACC,
> +	ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECA0002,
> +};
> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */
> -#define ACC_DEV_MAGIC	0XCDCDCDCDFEEDAACC
>  	u64 acc_magic;
>  	u32 qp_num;
>  	u32 dev_id;


