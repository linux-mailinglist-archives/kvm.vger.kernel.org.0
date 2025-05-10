Return-Path: <kvm+bounces-46103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36015AB21B4
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 09:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 635A13B3DE0
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 07:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF071E51F5;
	Sat, 10 May 2025 07:41:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D660BA27;
	Sat, 10 May 2025 07:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746862887; cv=none; b=QGb0ha0jNmgYfmDu5mCNEZMr2f1bylViSSVR2MgXvt8/QmpgO0g/OhqR/d5Nu04IT0ayfQLt7s8fcMimwnMV2xTScwmn3bo+UPow4rIoMZya8R6eaYRVFMRt5pgvFvrLiV2Ktg+LEsJLJiJLLRes9HRpYz+W+JRl3XxsV02lPoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746862887; c=relaxed/simple;
	bh=XIa1zMHZSqTZnNTmX3xxSHcICoLv7ngOW0oVLcEIz8A=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JQ5QOxZElYhR2U3Hb8uC/eWnewWEDXLm34ligoDwRnCOgD+igZDexzqRFCc0vdaBqH0ZMq/NI8o/QCOpbm5OfyezFYU+4UAyLHbQsoQKu44keaVioISOKJr9Xq7TNpuehDeAr7FcWuH4TDMl5rnaN3/IsbZfc3sOBTHOrSqGOaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Zvd823ZTFzsStT;
	Sat, 10 May 2025 15:40:34 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 5AFAE140143;
	Sat, 10 May 2025 15:41:13 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 May 2025 15:41:12 +0800
Subject: Re: [PATCH v7 5/6] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250411035907.57488-1-liulongfang@huawei.com>
 <20250411035907.57488-6-liulongfang@huawei.com>
 <937a11b53cca42ef94d8383608a10f59@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <460f52a8-7a4a-96f7-b0db-299d3cfc244c@huawei.com>
Date: Sat, 10 May 2025 15:41:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <937a11b53cca42ef94d8383608a10f59@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/4/15 16:45, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Friday, April 11, 2025 4:59 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v7 5/6] hisi_acc_vfio_pci: bugfix live migration function
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
>> Reviewed-by: Shameer Kolothum
>> <shameerali.kolothum.thodi@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 22 +++++++++++++------
>>  1 file changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index cadc82419dca..d12a350440d3 100644
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
>> @@ -498,6 +491,20 @@ static int vf_qm_load_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	if (migf->total_length < sizeof(struct acc_vf_data))
>>  		return -EINVAL;
>>
>> +	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
>> +	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
>> +		dev_info(dev, "resume dma addr is NULL!\n");
>> +		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
>> +		return 0;
>> +	}
> 
> 
> I am still not fully understood why we need the above check. The only case as
> far as I can think of where this will happen is when the source VM Guest has
> not loaded the ACC driver. And we do take care of that already using vf_qm_state and
> checking total_length == QM_MATCH_SIZE.
> 
> Have you seen this happening in any other scenario during your tests?
>

This is a problem that was discovered and fixed in previous abnormal scenario tests.
In the abnormal tests, abnormal error handling was performed and real-time migration
was executed. However, due to the lack of this check, the device became abnormal
after migration.

Thanks,
Longfang.

> Thanks,
> Shameer
> 
>> +
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
>> @@ -1531,6 +1538,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
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

