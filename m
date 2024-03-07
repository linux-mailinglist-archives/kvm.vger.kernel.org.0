Return-Path: <kvm+bounces-11296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 689F1874E4E
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C11B4282A99
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 11:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7619112B149;
	Thu,  7 Mar 2024 11:52:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D93129A69;
	Thu,  7 Mar 2024 11:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709812322; cv=none; b=S3sjuiTQgrhUKHBhXA5mLSTupCJzD2RwzZCJKIXjnopsaPH1yIrQeA+UmcmqneDplPPpSS37vIOKYHFBlPtO5HQFTnF+oa9huGOlrgXj9sR0GtGpaSnCtlbyjEivloeXxIbkjBmXuFbtoyCDWjOitiNxWAxIKPnCMCY9RBUR9ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709812322; c=relaxed/simple;
	bh=gBRNuY+93eIjOMjnpY06QMUglsaAZpoaFQbwH9s9Ixw=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XeMRkow5ZEuX1UyCI2gUwqoVEptldGfdcaXpeGIYnagbX70RsFgkX6iQSPC5pyD3gDUgTq5+KUGyOPEWrSBMdCYciwJaQ7FqCYCttg/Lm1pajSC5raxTORr8HennBHOfkouaKrdHmVyDpkff95sT9HvInEPwoUjPRf/W/lqY1hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Tr6zL3DkGz1QB7D;
	Thu,  7 Mar 2024 19:49:34 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id CDD561A016C;
	Thu,  7 Mar 2024 19:51:56 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 19:51:56 +0800
Subject: Re: [PATCH v3 2/4] hisi_acc_vfio_pci: Create subfunction for data
 reading
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20240307060353.16095-1-liulongfang@huawei.com>
 <20240307060353.16095-3-liulongfang@huawei.com>
 <63cc4710dbb94b049bc1576f743b1729@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <1b0c7475-884c-4035-6e7a-c2f7ad4f6f95@huawei.com>
Date: Thu, 7 Mar 2024 19:51:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <63cc4710dbb94b049bc1576f743b1729@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/3/7 16:33, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Thursday, March 7, 2024 6:04 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v3 2/4] hisi_acc_vfio_pci: Create subfunction for data
>> reading
>>
>> During the live migration process. It needs to obtain various status
>> data of drivers and devices. In order to facilitate calling it in the
>> debugfs function. For all operations that read data from device registers,
>> the driver creates a subfunction.
>> Also fixed the location of address data.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 55 ++++++++++---------
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  3 +
>>  2 files changed, 33 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 45351be8e270..1881f3fa9266 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -486,42 +486,22 @@ static int vf_qm_load_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	return 0;
>>  }
>>
>> -static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>> -			    struct hisi_acc_vf_migration_file *migf)
>> +static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data
>> *vf_data)
>>  {
>> -	struct acc_vf_data *vf_data = &migf->vf_data;
>> -	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>  	struct device *dev = &vf_qm->pdev->dev;
>>  	int ret;
>>
>> -	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
>> -		/* Update state and return with match data */
>> -		vf_data->vf_qm_state = QM_NOT_READY;
>> -		hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>> -		migf->total_length = QM_MATCH_SIZE;
>> -		return 0;
>> -	}
>> -
>> -	vf_data->vf_qm_state = QM_READY;
>> -	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>> -
>> -	ret = vf_qm_cache_wb(vf_qm);
>> -	if (ret) {
>> -		dev_err(dev, "failed to writeback QM Cache!\n");
>> -		return ret;
>> -	}
>> -
>>  	ret = qm_get_regs(vf_qm, vf_data);
> 
> 
> So this doesn't need the qm_wait_dev_not_ready(vf_qm) check above for the
> debugfs ? What happens if you read when device is not ready?
>

There is still a call to qm_wait_dev_not_ready() in vf_qm_state_save.
Here is just the data reading operation of the new vf_qm_read_data() function.


>>  	if (ret)
>>  		return -EINVAL;
>>
>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
>> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
>> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> 
> Also since there is no serialization with core migration now, what will be the data
> returned in debugfs when there is a vf_qm_load_data() is in progress?
>> So I guess the intention or assumption here is that the debugfs data is only
> valid when the user knows that devices not under migration process.
> 
> Is that right?
>

The data read by debugfs is the data in the device when the read operation occurs.
As for whether the device is in the running state or the resuming state,
debugfs does not need to pay attention to it.

If the user wants to read the status data of the device in different states,
he can first query the device's state, and then read the save data based on
the state result.

Thanks,
Longfang.

> Thanks,
> Shameer
> 
>>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
>> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
>> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
>> +	vf_data->aeqe_dma = vf_data-
>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
>> +	vf_data->aeqe_dma |= vf_data-
>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];
>>
>>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>> @@ -536,6 +516,31 @@ static int vf_qm_state_save(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return -EINVAL;
>>  	}
>>
>> +	return 0;
>> +}
>> +
>> +static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>> +			    struct hisi_acc_vf_migration_file *migf)
>> +{
>> +	struct acc_vf_data *vf_data = &migf->vf_data;
>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>> +	int ret;
>> +
>> +	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
>> +		/* Update state and return with match data */
>> +		vf_data->vf_qm_state = QM_NOT_READY;
>> +		hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>> +		migf->total_length = QM_MATCH_SIZE;
>> +		return 0;
>> +	}
>> +
>> +	vf_data->vf_qm_state = QM_READY;
>> +	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>> +
>> +	ret = vf_qm_read_data(vf_qm, vf_data);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>>  	migf->total_length = sizeof(struct acc_vf_data);
>>  	return 0;
>>  }
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
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
>> --
>> 2.24.0
> 
> .
> 

