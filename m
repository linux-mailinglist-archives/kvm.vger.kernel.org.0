Return-Path: <kvm+bounces-42173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD01A74C04
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 15:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B1CF16B22D
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 14:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BE6189919;
	Fri, 28 Mar 2025 14:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVPDCuIk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434917A304
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743170634; cv=none; b=uV9h48vfkRQOuyT8p4Jlzd5fLxXVYcHnb34eXlGNYSi8C62IJfwJTjIk7aTgkZfLYjOlm/jmepGeFE2TAKtEA7by68mqlI87QlOR/uTan1HjTvbWqB15QPJqV4kRDiYPF1IeUHc3W6dpoJ6D5A9geU7enFxGdl/f+Uk49CGBCto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743170634; c=relaxed/simple;
	bh=40aQCT4O8fEvX6ZHUOSbqQHr8x+W1Av6fkZgp7Bd9Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qOIjeWgRIMvezllIfdMeLR+Ztm1xqa4dFQvkBejm3zrjT6nte9P0ONpZYHhP286RzBkOL3Ijlz32s2v8WtnZ7fCAyAtzS90q6RqYC/v/EvgELx2CJsymCj7Q4M0dMF0Z3wx9bqVcI+zGryxOjZPC7iZRDm/QsgNU4ry4nsspHfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hVPDCuIk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743170631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=75wYxT3IroHLlrMDZKWsJPHcaRpOEmpxaKWKNfx9sEA=;
	b=hVPDCuIk+anBFnAfrVNV0FiBInLOTTeCYB4Hv+RaLTn6WYggZSKECQAYlWpw9farcaDsKa
	WW7BpxgI83aEY+fK3xKiHhoqSEdzt0FgaaWQm+VmOvUMvh45ytrLr1/oMGpXKZXGI9/Xpi
	M6IY3N4PAw/eSl/TC+TiUcyw4T+MH+Q=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-zR8yUEueM9WBqOqyql8Ktg-1; Fri, 28 Mar 2025 10:03:50 -0400
X-MC-Unique: zR8yUEueM9WBqOqyql8Ktg-1
X-Mimecast-MFC-AGG-ID: zR8yUEueM9WBqOqyql8Ktg_1743170629
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d48e11525fso803735ab.0
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 07:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743170629; x=1743775429;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=75wYxT3IroHLlrMDZKWsJPHcaRpOEmpxaKWKNfx9sEA=;
        b=SdOuMhc+fVQp21rAWvztJ8pOE5CbyJ6rF+rWjCCBK85aJ/cQ3ltNKN2GazKxhv6fKy
         UoEPBuURBYpQtaDNpem4kWUcrrrCKYvfuVyqWUEewhLoEkADDWDaEg/rH3U6hcyWWOvf
         CjVAjl5nMyDJ2swSzrzEwxnYVA53yZ3zAhJm7XX/1O5GSDb/Ygd1BzS0su+H2RjB6dam
         TwYgjgYxAyBFUhlHIwGjCCi3OEljFWuZg7z9xQBl+o1Z/EkbweIfxqjehRAOH2uQUfxH
         zuGBW5H/RXpd9oKFdZ978/ZiAM7v4QMO71snLz1VK0jRrS/Yh1Q7qCfKJ169NyABZIi2
         sZfw==
X-Forwarded-Encrypted: i=1; AJvYcCU36Z+2yXAHsqSBE4jKuvoSZiPXVdoHzpYFeJNbkzTtlent8cbFopspYklZ+ok6cFdksiI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4c7LTbgQBr2vClPXPSjPaiknpEwuUm0BDGvJ9mlHbrFLwlwgM
	wFnI4t1MfCOPR++jXwsAd/uOO2q0Xwsy2novnxuO8qZYsCuMT34MTcrCJyHNqXbgFlmIwOnQZry
	ljPdWxC/sdPtzxkp7DPkzjhGuaz5gFI2AoYVrCMlymZ8pTobPQw==
X-Gm-Gg: ASbGncsQDK8lPkZNYljgf9xo8Oizv0f5dAidEPAhubpNzd5DZtb/YHQ+6lA2CHiusy5
	tKCytC/kJRbechW+dfeAEg8wSoQS2sLrAkcgQwX2Gwm/WxFSkEnqDZv4unb0A5VL3XgF0QRFWZG
	+K77gAsRn+9lLmUmwIVWip9jAyMOJi+RZNUPYSJDV2F+AbOCr4ZYRdZln8YnbCL64R8xrSb9TZQ
	H9YY/yc36gm/wkGegwOrMqwKT/0/cXnhHwUjHmq1JJs/pFwL/RpKPJpZOB5T6sXPuupJuGP9j/y
	BVXFIGHgpjOkpGSCLrQ=
X-Received: by 2002:a05:6e02:3309:b0:3d4:3fbf:967f with SMTP id e9e14a558f8ab-3d5ce2379d6mr22848465ab.7.1743170629384;
        Fri, 28 Mar 2025 07:03:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2yhoc9K+rOe3eFD1M2GGgLaXgUCMXwvTcs9i8ZSO2bSdARCXsSVRM8GpdG/TKPqPqUbl0rA==
X-Received: by 2002:a05:6e02:3309:b0:3d4:3fbf:967f with SMTP id e9e14a558f8ab-3d5ce2379d6mr22848155ab.7.1743170628693;
        Fri, 28 Mar 2025 07:03:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d5a6c645sm4784945ab.19.2025.03.28.07.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 07:03:46 -0700 (PDT)
Date: Fri, 28 Mar 2025 08:03:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: liulongfang <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <20250328080343.2bfb6fdf.alex.williamson@redhat.com>
In-Reply-To: <f72a87ed-5884-2a6f-02e1-b0bcd172a4e8@huawei.com>
References: <20250318064548.59043-1-liulongfang@huawei.com>
	<20250318064548.59043-2-liulongfang@huawei.com>
	<20250321095140.4980c7c0.alex.williamson@redhat.com>
	<f72a87ed-5884-2a6f-02e1-b0bcd172a4e8@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Mar 2025 16:04:17 +0800
liulongfang <liulongfang@huawei.com> wrote:

> on 2025/3/21 23:51, Alex Williamson wrote:
> > On Tue, 18 Mar 2025 14:45:44 +0800
> > Longfang Liu <liulongfang@huawei.com> wrote:
> >   
> >> The dma addresses of EQE and AEQE are wrong after migration and
> >> results in guest kernel-mode encryption services  failure.
> >> Comparing the definition of hardware registers, we found that
> >> there was an error when the data read from the register was
> >> combined into an address. Therefore, the address combination
> >> sequence needs to be corrected.
> >>
> >> Even after fixing the above problem, we still have an issue
> >> where the Guest from an old kernel can get migrated to
> >> new kernel and may result in wrong data.
> >>
> >> In order to ensure that the address is correct after migration,
> >> if an old magic number is detected, the dma address needs to be
> >> updated.
> >>
> >> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> >> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> >> ---
> >>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 41 ++++++++++++++++---
> >>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
> >>  2 files changed, 47 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> index 451c639299eb..304dbdfa0e95 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> @@ -350,6 +350,32 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
> >>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
> >>  }
> >>  
> >> +static int vf_qm_version_check(struct acc_vf_data *vf_data, struct device *dev)
> >> +{
> >> +	switch (vf_data->acc_magic) {
> >> +	case ACC_DEV_MAGIC_V2:
> >> +		if (vf_data->major_ver != ACC_DRV_MAJOR_VER) {
> >> +			dev_info(dev, "migration driver version<%u.%u> not match!\n",
> >> +				 vf_data->major_ver, vf_data->minor_ver);
> >> +			return -EINVAL;
> >> +		}
> >> +		break;
> >> +	case ACC_DEV_MAGIC_V1:
> >> +		/* Correct dma address */
> >> +		vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> >> +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> >> +		vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> >> +		vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
> >> +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> >> +		vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
> >> +		break;
> >> +	default:
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>  			     struct hisi_acc_vf_migration_file *migf)
> >>  {
> >> @@ -363,7 +389,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
> >>  		return 0;
> >>  
> >> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
> >> +	ret = vf_qm_version_check(vf_data, dev);
> >> +	if (ret) {
> >>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
> >>  		return -EINVAL;
> >>  	}  
> > 
> > Nit, we store the return value here, but never use it beyond testing
> > non-zero.  This is a pattern throughout this driver that should be
> > fixed (maybe in a future series).  We should return the errno from the
> > sub-function rather than overriding it unless we have a specific reason
> > to do otherwise.  Thanks,
> >  
> 
> You've raised a point that seems to apply in multiple places.
> Could this be addressed in a future bugfix patch?

Yes, I've noted that above.  Thanks,

Alex

> >> @@ -418,7 +445,9 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> >>  	int vf_id = hisi_acc_vdev->vf_id;
> >>  	int ret;
> >>  
> >> -	vf_data->acc_magic = ACC_DEV_MAGIC;
> >> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
> >> +	vf_data->major_ver = ACC_DRV_MAJOR_VER;
> >> +	vf_data->minor_ver = ACC_DRV_MINOR_VER;
> >>  	/* Save device id */
> >>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
> >>  
> >> @@ -496,12 +525,12 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
> >>  		return -EINVAL;
> >>  
> >>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> >> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
> >> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> >>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
> >> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
> >> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
> >> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> >> +	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
> >>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
> >> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
> >> +	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
> >>  
> >>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
> >>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> index 245d7537b2bc..91002ceeebc1 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> @@ -39,6 +39,9 @@
> >>  #define QM_REG_ADDR_OFFSET	0x0004
> >>  
> >>  #define QM_XQC_ADDR_OFFSET	32U
> >> +#define QM_XQC_ADDR_LOW	0x1
> >> +#define QM_XQC_ADDR_HIGH	0x2
> >> +
> >>  #define QM_VF_AEQ_INT_MASK	0x0004
> >>  #define QM_VF_EQ_INT_MASK	0x000c
> >>  #define QM_IFC_INT_SOURCE_V	0x0020
> >> @@ -50,10 +53,15 @@
> >>  #define QM_EQC_DW0		0X8000
> >>  #define QM_AEQC_DW0		0X8020
> >>  
> >> +#define ACC_DRV_MAJOR_VER 1
> >> +#define ACC_DRV_MINOR_VER 0
> >> +
> >> +#define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
> >> +#define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
> >> +
> >>  struct acc_vf_data {
> >>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
> >>  	/* QM match information */
> >> -#define ACC_DEV_MAGIC	0XCDCDCDCDFEEDAACC
> >>  	u64 acc_magic;
> >>  	u32 qp_num;
> >>  	u32 dev_id;
> >> @@ -61,7 +69,9 @@ struct acc_vf_data {
> >>  	u32 qp_base;
> >>  	u32 vf_qm_state;
> >>  	/* QM reserved match information */
> >> -	u32 qm_rsv_state[3];
> >> +	u16 major_ver;
> >> +	u16 minor_ver;
> >> +	u32 qm_rsv_state[2];
> >>  
> >>  	/* QM RW regs */
> >>  	u32 aeq_int_mask;  
> > 
> > 
> > 
> > .
> >   
> 


