Return-Path: <kvm+bounces-41676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BF0A6BEBF
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D2533BAC84
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B93214A98;
	Fri, 21 Mar 2025 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3Jhtxbq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9A1F12F8
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742572312; cv=none; b=h2fP7LfIdWKNDCGzvAJvaJ1GlrVEWBDn3cP5TLH1BD69wKnLVztUxbXJim4pmxo712mtWSeUB7JLy4PPkkdMsA+/8h8l4PKyfY3e4SZVn891PR0RC8Sgjq6Ajpgyaozlmsa5GVYgGUfgW15IbSIRC9lbNsUj0RHPjZtrXocE+/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742572312; c=relaxed/simple;
	bh=D5wQp+y87cFEGIIFtzeEjHJ1AvVoWSQAaS+75QijfuU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FYfpicU1J9lW7dW71NVX13fWBoF+aEOWF6UV0r7//W2IUk4j54rdYw9lHtu3v7E33RORd8/i06UkeCDWDzExIuKNlfaGvapY+fmYRSY+cpH20yaOdA789s1YZZAokryZLlM09HxlvyAtdpldhMeG11QekGqrEB1bs+UpWoDfttg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3Jhtxbq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742572308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aVvJxnVOM+4g0nW5DzYaF/8j9kkNztTiJz1Id17pXhc=;
	b=A3Jhtxbq9gwfkjQ1vi0JgOYs3KNH/fnvNe5jWX6nN2En23ZJUXSfS4KP0u7AOfUqPH/Szi
	h5mNCApNuOkSn7SF1wBvcxsO6eNLFEPiMq5VZU1Wy16vAhrKDdub/qILK4JmfORkj/cVdN
	B5Jqf8LxYHhFt8+AXHpgKNDB7W3fi14=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-vq-zuYDPPGuGk420PlolFA-1; Fri, 21 Mar 2025 11:51:47 -0400
X-MC-Unique: vq-zuYDPPGuGk420PlolFA-1
X-Mimecast-MFC-AGG-ID: vq-zuYDPPGuGk420PlolFA_1742572306
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85b5c68c390so38795239f.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 08:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742572306; x=1743177106;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aVvJxnVOM+4g0nW5DzYaF/8j9kkNztTiJz1Id17pXhc=;
        b=vRoQjdU/U6lv7XiVU48CbU0byHTCLihSO4JOiCMQVY7IloihiudGsNZEwuNN8TSb7a
         2eIp2Alqk4UGfFrTjVM4jQosZdeBte50MfW8EEs7pRkYPDRpNwisk7gUfVjny90bSSXX
         ijPEypbRNM/7oHrnEYi4/zHgfGFJjjCVDVMqR5HBDt/b391hWIXqJph4hRCAZybRgWV5
         zYkeA6nPBeXU+PDEmdkM11RO/RQjSEWLrD8CIK6jZGiJmPPd7Vwo2BUAuCSASf65/e6w
         R/T03R5FxMaQUYH5k3/DY0xYJ4+qMsGLn1tNT3I1PE/RsxGZXSen1Z/rTSc26Xh/xe2P
         1Yiw==
X-Forwarded-Encrypted: i=1; AJvYcCWTTavhWtkLXvWd7aLvGYW2N8mMCZm8+8IX0lrHmzxLZjIafIgtDTnC2wGvlHsMwRT0pBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQpI2SPi7Bh9lcrHjw8lyDd77/3lCJsIlPOdgnNRVYNLPOLFh+
	WsGv10ZxOX7CEvTzxfnstKgmWqEFPE4SE1R60ZbhRI0CjBB88Fk/ESE1ZoLFsfsD93kpE2ECdV5
	8QlvycZihpmfucZhAb92UNbD3DvnSiDRnDH0+gqzFQulPiMCy0A==
X-Gm-Gg: ASbGncsObsTWnEXrD5n5vfTTBkmwYCzI6WDKQbhCzDYq1pSDCnNsYaO9qmmhBBvJI71
	IIm71e+5e3Qf5OfNEVP2tVqYgvbizUAXbEPNAJuDHX5Jz/C7iQ/yutQL/jnkWy+o7TgWHpuR6+I
	HaP+qgWdeSCc+Eaal98TiYrQQAjEfs84HTjHdT8AikvDb8LVBO+SZmRqfYZZIk6lrdTcGVKXT/D
	wbI81l87XjuQpdiLqkjexAKNoaXXYhDpotdTd3f/eIJu/ar2uNgBfmnlB6FBx4prehlz/3f7HRE
	FCbNx/sPRBuDqcqdRPI=
X-Received: by 2002:a05:6e02:3908:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3d59c5c5d76mr470795ab.6.1742572306118;
        Fri, 21 Mar 2025 08:51:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEICZz//aI4MhMSuht0f4r4u1gmPhsTRLZjzCajhNPtN14NstIPHs5XrW/dfGsvTM1hmoA0g==
X-Received: by 2002:a05:6e02:3908:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3d59c5c5d76mr470675ab.6.1742572305638;
        Fri, 21 Mar 2025 08:51:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d59607eabdsm5079995ab.27.2025.03.21.08.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 08:51:43 -0700 (PDT)
Date: Fri, 21 Mar 2025 09:51:40 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250321095140.4980c7c0.alex.williamson@redhat.com>
In-Reply-To: <20250318064548.59043-2-liulongfang@huawei.com>
References: <20250318064548.59043-1-liulongfang@huawei.com>
	<20250318064548.59043-2-liulongfang@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Mar 2025 14:45:44 +0800
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
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 41 ++++++++++++++++---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
>  2 files changed, 47 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 451c639299eb..304dbdfa0e95 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -350,6 +350,32 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>  }
>  
> +static int vf_qm_version_check(struct acc_vf_data *vf_data, struct device *dev)
> +{
> +	switch (vf_data->acc_magic) {
> +	case ACC_DEV_MAGIC_V2:
> +		if (vf_data->major_ver != ACC_DRV_MAJOR_VER) {
> +			dev_info(dev, "migration driver version<%u.%u> not match!\n",
> +				 vf_data->major_ver, vf_data->minor_ver);
> +			return -EINVAL;
> +		}
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
> @@ -363,7 +389,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
>  		return 0;
>  
> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
> +	ret = vf_qm_version_check(vf_data, dev);
> +	if (ret) {
>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>  		return -EINVAL;
>  	}

Nit, we store the return value here, but never use it beyond testing
non-zero.  This is a pattern throughout this driver that should be
fixed (maybe in a future series).  We should return the errno from the
sub-function rather than overriding it unless we have a specific reason
to do otherwise.  Thanks,

Alex

> @@ -418,7 +445,9 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	int vf_id = hisi_acc_vdev->vf_id;
>  	int ret;
>  
> -	vf_data->acc_magic = ACC_DEV_MAGIC;
> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
> +	vf_data->major_ver = ACC_DRV_MAJOR_VER;
> +	vf_data->minor_ver = ACC_DRV_MINOR_VER;
>  	/* Save device id */
>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>  
> @@ -496,12 +525,12 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
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


