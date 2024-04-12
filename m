Return-Path: <kvm+bounces-14374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E008A242C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 441831C2204E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97EE1799F;
	Fri, 12 Apr 2024 03:07:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E44134B2;
	Fri, 12 Apr 2024 03:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712891226; cv=none; b=rdvlG0TfR8pHbLQPrJn9Bypw7li4m5Mviey3PYoF7uC4heuNZEmTdWw2dgwY1ukc3uPTFPIQIjCZcLiK5xfVUzyuoKst2EYRAv4FeRtNFGTJASll/pLxmGuZPwqENg7Ijg5sRmoJWR3AuMKDAuDRhmt0q5tUyReWUmf2vTYoTl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712891226; c=relaxed/simple;
	bh=WeQV3etAK0C96I94xGlBbd9Uo4UsxU5yT6PWfCgir+Y=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=b6wvYhfC3+3xKzghEvRWMr/tjGCupdDUB6kbnPbtBlwZuo0MhgXBkUKEJH8ZD2p9gHap2/qTF7RUqZ/KAT6IFjbnzfRLEfX9+FLhnp9uznJZ94LTFFXCzLudRcVUWUH3qVA5uTSeREFS4aZccIS8b9bMO69S1CIBq2ifCux6Esg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VG1cb4bnqztSdR;
	Fri, 12 Apr 2024 11:04:15 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 41B30140124;
	Fri, 12 Apr 2024 11:07:01 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 11:07:00 +0800
Subject: Re: [PATCH v4 2/4] hisi_acc_vfio_pci: Create subfunction for data
 reading
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	=?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
References: <20240402032432.41004-1-liulongfang@huawei.com>
 <20240402032432.41004-3-liulongfang@huawei.com>
 <20240404140731.2b75cb80.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <f1ffdcc6-e74b-bf6c-bddb-73debd78900b@huawei.com>
Date: Fri, 12 Apr 2024 11:07:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240404140731.2b75cb80.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/4/5 4:07, Alex Williamson wrote:
> On Tue, 2 Apr 2024 11:24:30 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> During the live migration process. It needs to obtain various status
>> data of drivers and devices. In order to facilitate calling it in the
>> debugfs function. For all operations that read data from device registers,
>> the driver creates a subfunction.
>> Also fixed the location of address data.
> 
> Cédric noted privately and I agree, 1) fixes should be provided in
> separate patches with a Fixes: tag rather than subtly included in a
> minor refactoring, and 2) what does this imply about the existing
> functionality of migration?  This would seem to suggest existing
> migration data is bogus if we're offset by a register reading the DMA
> address.  The commit log for the Fixes patch should describe this.
>

Okay, the modification of the DMA address offset part is split into
a new patch, and the modification of this part is explained clearly.

Thanks,
Longfang.

>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 56 +++++++++++--------
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  3 +
>>  2 files changed, 37 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 45351be8e270..bf358ba94b5d 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -486,6 +486,39 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	return 0;
>>  }
>>  
>> +static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
>> +{
>> +	struct device *dev = &vf_qm->pdev->dev;
>> +	int ret;
>> +
>> +	ret = qm_get_regs(vf_qm, vf_data);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>> +	/* Every reg is 32 bit, the dma address is 64 bit. */
>> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>> +	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
>> +	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>> +	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>> +	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
>> +
>> +	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>> +	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>> +	if (ret) {
>> +		dev_err(dev, "failed to read SQC addr!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = qm_get_cqc(vf_qm, &vf_data->cqc_dma);
>> +	if (ret) {
>> +		dev_err(dev, "failed to read CQC addr!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  			    struct hisi_acc_vf_migration_file *migf)
>>  {
>> @@ -511,31 +544,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return ret;
>>  	}
>>  
>> -	ret = qm_get_regs(vf_qm, vf_data);
>> +	ret = vf_qm_read_data(vf_qm, vf_data);
>>  	if (ret)
>>  		return -EINVAL;
>>  
>> -	/* Every reg is 32 bit, the dma address is 64 bit. */
>> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
>> -	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
>> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
>> -	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
>> -
>> -	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>> -	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>> -	if (ret) {
>> -		dev_err(dev, "failed to read SQC addr!\n");
>> -		return -EINVAL;
>> -	}
>> -
>> -	ret = qm_get_cqc(vf_qm, &vf_data->cqc_dma);
>> -	if (ret) {
>> -		dev_err(dev, "failed to read CQC addr!\n");
>> -		return -EINVAL;
>> -	}
>> -
>>  	migf->total_length = sizeof(struct acc_vf_data);
>>  	return 0;
>>  }
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index 5bab46602fad..7a9dc87627cd 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -38,6 +38,9 @@
>>  #define QM_REG_ADDR_OFFSET	0x0004
>>  
>>  #define QM_XQC_ADDR_OFFSET	32U
>> +#define QM_XQC_ADDR_LOW		0x1
>> +#define QM_XQC_ADDR_HIGH	0x2
>> +
>>  #define QM_VF_AEQ_INT_MASK	0x0004
>>  #define QM_VF_EQ_INT_MASK	0x000c
>>  #define QM_IFC_INT_SOURCE_V	0x0020
> 
> .
> 

