Return-Path: <kvm+bounces-41361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF07CA66A55
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:20:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE677189C50A
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB031DE2DA;
	Tue, 18 Mar 2025 06:20:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831A742A83;
	Tue, 18 Mar 2025 06:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742278838; cv=none; b=BsXzvgzFCJxG9a/t2FAKcAzcO/3pF+WB6uv5BAcWa3KKUYBrpJrYb5bq6yItZJmPLm9wYo7mM1T8Mj4pZE+tbm7APHyO8VEOcUnH4XYzPMnrVFC6NhheT4f7Kqj4ytL5K+ISGmrK0t34k7S23KvcjnsKmYAzl7TBAC0M/WzeCtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742278838; c=relaxed/simple;
	bh=JzXyaXcy650eMpJNgaYCrDvYqDRVK3fLIBCQZ8xEcqI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=d4peu3u/5plVp1w+RUH7RmFFrNXEKLE4nGFKzfrMj33DYOkJGWRHQFC5CKG7OT1hRaGwz2z3h0dZz+YXI58BKwyUu0mvXAE0xjp/LThouXnHxaG3FagVq/Zczg57gKc47OdXUV/0m1V4tkzA/HpM9W03nLQC5OzMIDDLPCPs6LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZH1rL4V7QztQyd;
	Tue, 18 Mar 2025 14:18:58 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id BA2C2140367;
	Tue, 18 Mar 2025 14:20:26 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Mar 2025 14:20:26 +0800
Subject: Re: [PATCH v5 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250313072010.57199-1-liulongfang@huawei.com>
 <20250313072010.57199-6-liulongfang@huawei.com>
 <53d0f91f3d8440bc91858dd4811b7170@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <4c7aa4c8-433e-49e2-b499-1ca47d1cc7ce@huawei.com>
Date: Tue, 18 Mar 2025 14:20:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <53d0f91f3d8440bc91858dd4811b7170@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/3/14 16:11, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Thursday, March 13, 2025 7:20 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v5 5/5] hisi_acc_vfio_pci: bugfix live migration function
>> without VF device driver
>>
>> If the VF device driver is not loaded in the Guest OS and we attempt to
>> perform device data migration, the address of the migrated data will
>> be NULL.
>> The live migration recovery operation on the destination side will
>> access a null address value, which will cause access errors.
>>
>> Therefore, live migration of VMs without added VF device drivers
>> does not require device data migration.
>> In addition, when the queue address data obtained by the destination
>> is empty, device queue recovery processing will not be performed.
>>
>> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
>> migration")
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 25 +++++++++++++------
>>  1 file changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index cadc82419dca..44fa2d16bbcc 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -426,13 +426,6 @@ static int vf_qm_check_match(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return -EINVAL;
>>  	}
>>
>> -	ret = qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state,
>> 1);
>> -	if (ret) {
>> -		dev_err(dev, "failed to write QM_VF_STATE\n");
>> -		return ret;
>> -	}
>> -
>> -	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>  	hisi_acc_vdev->match_done = true;
>>  	return 0;
>>  }
>> @@ -498,6 +491,13 @@ static int vf_qm_load_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	if (migf->total_length < sizeof(struct acc_vf_data))
>>  		return -EINVAL;
>>
>> +	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
>> +	if (ret) {
>> +		dev_err(dev, "failed to write QM_VF_STATE\n");
>> +		return -EINVAL;
>> +	}
>> +	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>> +
>>  	qm->eqe_dma = vf_data->eqe_dma;
>>  	qm->aeqe_dma = vf_data->aeqe_dma;
>>  	qm->sqc_dma = vf_data->sqc_dma;
>> @@ -506,6 +506,12 @@ static int vf_qm_load_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	qm->qp_base = vf_data->qp_base;
>>  	qm->qp_num = vf_data->qp_num;
>>
>> +	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
>> +	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
>> +		dev_err(dev, "resume dma addr is NULL!\n");
>> +		return -EINVAL;
>> +	}
>> +
>>  	ret = qm_set_regs(qm, vf_data);
>>  	if (ret) {
>>  		dev_err(dev, "set VF regs failed\n");
>> @@ -726,8 +732,12 @@ static int hisi_acc_vf_load_state(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev)
>>  {
>>  	struct device *dev = &hisi_acc_vdev->vf_dev->dev;
>>  	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev-
>>> resuming_migf;
>> +	struct acc_vf_data *vf_data = &migf->vf_data;
>>  	int ret;
>>
>> +	if (vf_data->vf_qm_state != QM_READY)
>> +		return 0;
> 
> I don't think we need to check the above. In vf_qm_satte_save(), 
> If  vf_qm_state !=  QM_READY, we set the
>  migf->total_length = QM_MATCH_SIZE.
> 
> Hence it will return 0 in the below  vf_qm_load_data() anyway.
>

After removing this judgment code, the live migration function works normally
without loading the VM driver.
I will remove this judgment in the next version.

Thanks.
Longfang.

> With that corrected,
> 
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> Thanks,
> Shameer
> 
>> +
>>  	/* Recover data to VF */
>>  	ret = vf_qm_load_data(hisi_acc_vdev, migf);
>>  	if (ret) {
>> @@ -1531,6 +1541,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
>> vfio_device *core_vdev)
>>  	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
>>  	hisi_acc_vdev->pf_qm = pf_qm;
>>  	hisi_acc_vdev->vf_dev = pdev;
>> +	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
>>  	mutex_init(&hisi_acc_vdev->state_mutex);
>>  	mutex_init(&hisi_acc_vdev->open_mutex);
>>
>> --
>> 2.24.0
> 
> .
> 

