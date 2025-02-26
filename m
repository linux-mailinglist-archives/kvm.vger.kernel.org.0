Return-Path: <kvm+bounces-39275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1870AA45DDF
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49300164C86
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 11:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D1521770C;
	Wed, 26 Feb 2025 11:53:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6D21578A;
	Wed, 26 Feb 2025 11:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570817; cv=none; b=JaYiili+qd7dYJ9Lbkz0hfPDlLtwXXVu6ADuw1xse5THlh5+apf7KSdCOSxDSmFLKfBjUHdHRRsWBYDokE/blKz0C8xrBanxo7KOoI+DdyTQvQeapVIEhPjuJ2cFPmPz9FaAwbwirY/HETEa+S18nifut5L5Qf5pGfHZWh3qQgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570817; c=relaxed/simple;
	bh=mUlXyOOWmrxe5qVaC3E1M1onSSumuLhQddRrlpnnRPY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ij1g3X/TtgAiMhbTxXArVsse5ed64C2cq0gDiRcT2VErGWeyMs3j1qjiq6GuDqKU0UEgqOB1Qb5rnknfYfJlU9XUYD04O+D78oxqDSL8VBBj253OoOvf+84zeVhLyA39XdK8b1Og+o4EA6JYU8sRrHZWQSHZ+kEbhNU+cuieILM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Z2t6v2XBVz1ltbG;
	Wed, 26 Feb 2025 19:49:27 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id E793F140113;
	Wed, 26 Feb 2025 19:53:30 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 26 Feb 2025 19:53:30 +0800
Subject: Re: [PATCH v4 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250225062757.19692-1-liulongfang@huawei.com>
 <20250225062757.19692-6-liulongfang@huawei.com>
 <fa8cd8c1cdbe4849b445ffd8f4894515@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <a9f2c601-5bfe-9774-17f5-3b5647d4a689@huawei.com>
Date: Wed, 26 Feb 2025 19:53:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <fa8cd8c1cdbe4849b445ffd8f4894515@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/2/26 17:26, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Tuesday, February 25, 2025 6:28 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v4 5/5] hisi_acc_vfio_pci: bugfix live migration function
>> without VF device driver
>>
>> If the driver of the VF device is not loaded in the Guest OS,
>> then perform device data migration. The migrated data address will
>> be NULL.
> 
> May be rephrase:
> 
> If the VF device driver is not loaded in the Guest OS and we attempt to
> perform device data migration, the address of the migrated data will
> be NULL.
>

OK.

>> The live migration recovery operation on the destination side will
>> access a null address value, which will cause access errors.
>  
>> Therefore, live migration of VMs without added VF device drivers
>> does not require device data migration.
>> In addition, when the queue address data obtained by the destination
>> is empty, device queue recovery processing will not be performed.
>>
>> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
>> migration")
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 3f0bcd855839..77872fc4cd34 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -440,6 +440,7 @@ static int vf_qm_get_match_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  				struct acc_vf_data *vf_data)
>>  {
>>  	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>  	struct device *dev = &pf_qm->pdev->dev;
>>  	int vf_id = hisi_acc_vdev->vf_id;
>>  	int ret;
>> @@ -466,6 +467,13 @@ static int vf_qm_get_match_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return ret;
>>  	}
>>
>> +	/* Get VF driver insmod state */
>> +	ret = qm_read_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state,
>> 1);
> 
> We already have qm_wait_dev_not_ready() function that checks the QM_VF_STATE. 
> Why can't we use that here?
>

Here we need to compare with the passed state vf_qm_state. qm_wait_dev_not_ready()
is to check whether the current VM has loaded the driver.
The two functions are different

> Also we are getting this vf_qm_state already in vf_qm_state_save(). And you don't
> seem to check the vf_qm_state in vf_qm_check_match(). So why it is read 
> early in this function?
>

There is no need to check whether the driver is loaded in vf_qm_check_match().
Loading the driver or not does not affect live migration recovery.
When the driver is loaded, the xqc address data needs to be restored.
If it is not loaded, there is no need to restore the data,then we only
need to restore the VM status.

Thanks.
Longfang.

> 
> Thanks,
> Shameer
> 
>> +	if (ret) {
>> +		dev_err(dev, "failed to read QM_VF_STATE!\n");
>> +		return ret;
>> +	}
>> +
>>  	return 0;
>>  }
>>
>> @@ -505,6 +513,12 @@ static int vf_qm_load_data(struct
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
>> @@ -727,6 +741,9 @@ static int hisi_acc_vf_load_state(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev)
>>  	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev-
>>> resuming_migf;
>>  	int ret;
>>
>> +	if (hisi_acc_vdev->vf_qm_state != QM_READY)
>> +		return 0;
>> +
>>  	/* Recover data to VF */
>>  	ret = vf_qm_load_data(hisi_acc_vdev, migf);
>>  	if (ret) {
>> @@ -1530,6 +1547,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
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

