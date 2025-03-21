Return-Path: <kvm+bounces-41648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32411A6B6A4
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 10:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64B5F3B1D1F
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 09:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E90C1F0E4D;
	Fri, 21 Mar 2025 09:09:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716C18BEE;
	Fri, 21 Mar 2025 09:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742548186; cv=none; b=lKkXbK25oTMtcCbmFD3hBFtzUoyceVrqD9mSlnJyLn8hbsFmJkyOUjuyuNQqRAlahFidR8yN/9gEqpvYeCX24YLcWyon54lIUNGlFI4It4yewcdWGYmRNiAuX/7DyIYqAfv18g0t5Fmbau7uSrLow+aPcuIKybDcrdITk4Z0RUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742548186; c=relaxed/simple;
	bh=2v+lA3zOEELM/COQfmiYSRjZAJvI16Nu1Zgv3fJoHU4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rqE7Pp3oPwpfRT+vKiDRpTLaPtnD6Y7WnnvoaIBUoL3m2aPLcLJtV+xZQ6YRX/AoBdYkFrsW/y8FOhTsCNZowC8U1pOV/5hO25/wD7WebxyKM6L087TOLiGGeI6sM80ayarD+WjzWFzinNizt6yy0TJXxhK40X0NAb+9SXBl0oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZJxRw3GwQz1c0RN;
	Fri, 21 Mar 2025 17:07:56 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CF8714010C;
	Fri, 21 Mar 2025 17:09:41 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Mar 2025 17:09:41 +0800
Subject: Re: [PATCH v6 1/5] hisi_acc_vfio_pci: fix XQE dma address error
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20250318064548.59043-1-liulongfang@huawei.com>
 <20250318064548.59043-2-liulongfang@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <d04df7e6-468e-6e44-97a7-8dd371226289@huawei.com>
Date: Fri, 21 Mar 2025 17:09:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250318064548.59043-2-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/3/18 14:45, Longfang Liu wrote:
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
> 
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---

Hello, Alex.
Could you spend some time helping me review this patchset?
It has already undergone internal review and revisions.

Thank you.
Longfang.

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
> 

