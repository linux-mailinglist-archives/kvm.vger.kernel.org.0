Return-Path: <kvm+bounces-39198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B01A4513C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AA2F189C713
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 00:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B25E33DF;
	Wed, 26 Feb 2025 00:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Flgr8DQX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D810815C0
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 00:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740528591; cv=none; b=bacez3nL/bwmcDxJ/t9u2dXiOrw/V9COsaJlnOIeZFmCY0Dol+0aPsMYtvFI1cajtM8C+tNCXgmNRVS0QZ198+ytN383YhdLWsCsHWZlM2lEONBKKMRh9U7unSmS1chVDOGG/rD5cs4AeXoE/g4yY+HPCqv4YDZFxkpE26HiaAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740528591; c=relaxed/simple;
	bh=lZamrSsGv9Z9ghAOvXWWndmC2l/mBnm0JWrDtyH/wWo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PepcKQSat1PiKNXjrK0zG8XtL6yEXGsZxtCjjV+2jg6ZvGAerU2uWshMokrriZEsQ22yfkdiLdfhfYpAh3bcRP1/n/sNd474lSgM09mJnN+QUdrM+sKSOjqaPlKwZ9ULrtuiqZlPzzdwIoQ3tsukzKgkcEpEckZbNFpYa+GSoD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Flgr8DQX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740528588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WvqmHgGnSFRx07z0UMtdElqTCRlmCU7bL9uMczD40q8=;
	b=Flgr8DQX46YDreJHBpUre/DvF6fwt5hHsPT1qI4UyHlVgBMa//g7QWMEWCVlkTLNh7k+3g
	c+wZcJZy2JOGvHz/ZFrXQRt/C8zfKrrB5zDwbN/iomzt7xY8IGetifEQqJCGIEkKVMgSvq
	PjmMQS0HB3R5sXKcGNaN3OoFhyjwJ50=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-tnrJKjESNwK0tQ5Hi73n5g-1; Tue, 25 Feb 2025 19:09:47 -0500
X-MC-Unique: tnrJKjESNwK0tQ5Hi73n5g-1
X-Mimecast-MFC-AGG-ID: tnrJKjESNwK0tQ5Hi73n5g_1740528587
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8558f34d430so43245139f.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 16:09:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740528586; x=1741133386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WvqmHgGnSFRx07z0UMtdElqTCRlmCU7bL9uMczD40q8=;
        b=o6mPyutMnUthD/CJmuUbPEyCjvykpolqbPi5uut+EfkeBpu/RNg8WNnISlQU09qjSV
         oC8/fwqpolPS1mRu2n5t2poDJfCdG8EltaKaXUGA+1Yii47S/dl7pUwFpsdyHCJLcalN
         T1SYltvFWpshEXNMWzJzNTLhrqxjxI8vqNBZq4p1AbFXcOQUTqSkP2W4q5ejBTK0EAd9
         u/nAhvRvEXPyYWGO/d937/HSSUsGDLa+izJbFHmdabKxQb/A1kxM2hHntG0+9uTmH8Vg
         qIaMc6COtZr204zUgWix0NpYhXD+Pq/vSECgfd+HxoHMtYEzprJ6wQil027vJkM88lCA
         seVw==
X-Forwarded-Encrypted: i=1; AJvYcCU5knAi7x8U9xRUGQsunAKapDzhhgNNxPDlpzYwo00aARfwuIaeTIq3IGmWPRQE81W3W18=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgYPsLvPvER90PqJSo/JXUsjxwav9e1T8+2F2wF+fvY8ciCaLT
	sD4EINuu2o56zPkqOoCaXjVi89pJPmvLUy15AchiIOv8RyA6AJhrMTqHTnvIqHpbMhD6C9UpW1D
	5GhLM8lfdDZgRbQF/n7yFX8X0qocQosDlLemubmcw9b6sAfjCzA==
X-Gm-Gg: ASbGncs7kaAdW8S387NWBL0vvRk5Vrb5RrTzYsgP50fB1d7sTkUOjNH3DtHsd4CU8Ah
	Bcd574mB0/+UzbSvIJXdvq+FPgLnsuDsfUFVQl8bs6+kbScqUV0k1ogAU0h6VNuUo0c56X7e1dy
	1Ogl1xyyctjA7b6PYQ/EjtdOnzmxj/yQKAfpugJEfphgmBgYt2eLgo5oxpZXrTa3Hd8W1D57qoc
	oOpuypYRHgw6Yu7RjgmKGGMvXgipt9Kms4xly7mBWlNDTIs6pLkcvF3pLM7s5I0zZNpslfY4H1+
	oB0HdQooq3EJoNHR+2o=
X-Received: by 2002:a05:6602:13c9:b0:855:c259:70e1 with SMTP id ca18e2360f4ac-855da7da6c4mr565629939f.0.1740528586498;
        Tue, 25 Feb 2025 16:09:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHj7V49VWlK2xWFWGBqc0chA+wdh0Eo55U6utoe2zahVoDrPEaaayl6qqcLTHLVXXf+aOFXRg==
X-Received: by 2002:a05:6602:13c9:b0:855:c259:70e1 with SMTP id ca18e2360f4ac-855da7da6c4mr565629139f.0.1740528586061;
        Tue, 25 Feb 2025 16:09:46 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85620a18c09sm51883639f.15.2025.02.25.16.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 16:09:44 -0800 (PST)
Date: Tue, 25 Feb 2025 17:09:41 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250225170941.46b0ede5.alex.williamson@redhat.com>
In-Reply-To: <20250225062757.19692-2-liulongfang@huawei.com>
References: <20250225062757.19692-1-liulongfang@huawei.com>
	<20250225062757.19692-2-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Feb 2025 14:27:53 +0800
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
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 40 ++++++++++++++++---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
>  2 files changed, 46 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 451c639299eb..35316984089b 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -350,6 +350,31 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>  }
>  
> +static int vf_qm_version_check(struct acc_vf_data *vf_data, struct device *dev)
> +{
> +	switch (vf_data->acc_magic) {
> +	case ACC_DEV_MAGIC_V2:
> +		if (vf_data->major_ver < ACC_DRV_MAJOR_VER ||
> +		    vf_data->minor_ver < ACC_DRV_MINOR_VER)
> +			dev_info(dev, "migration driver version not match!\n");
> +			return -EINVAL;
> +		break;

What's your major/minor update strategy?

Note that minor_ver is a u16 and ACC_DRV_MINOR_VER is defined as 0, so
testing less than 0 against an unsigned is useless.

Arguably testing major and minor independently is pretty useless too.

You're defining what a future "old" driver version will accept, which
is very nearly anything, so any breaking change *again* requires a new
magic, so we're accomplishing very little here.

Maybe you want to consider a strategy where you'd increment the major
number for a breaking change and minor for a compatible feature.  In
that case you'd want to verify the major_ver matches ACC_DRV_MAJOR_VER
exactly and minor_ver would be more of a feature level.

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
> @@ -363,7 +388,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
>  		return 0;
>  
> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
> +	ret = vf_qm_version_check(vf_data, dev);
> +	if (ret) {
>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>  		return -EINVAL;
>  	}
> @@ -418,7 +444,9 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	int vf_id = hisi_acc_vdev->vf_id;
>  	int ret;
>  
> -	vf_data->acc_magic = ACC_DEV_MAGIC;
> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
> +	vf_data->major_ver = ACC_DRV_MAR;
> +	vf_data->minor_ver = ACC_DRV_MIN;

Where are "MAR" and "MIN" defined?  I can't see how this would even
compile.  Thanks,

Alex

>  	/* Save device id */
>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>  
> @@ -496,12 +524,12 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
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
> index 245d7537b2bc..91002ceeebc1 100644
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
> @@ -50,10 +53,15 @@
>  #define QM_EQC_DW0		0X8000
>  #define QM_AEQC_DW0		0X8020
>  
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
>  
>  	/* QM RW regs */
>  	u32 aeq_int_mask;


