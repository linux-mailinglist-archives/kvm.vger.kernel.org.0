Return-Path: <kvm+bounces-42171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EACFFA7455E
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 09:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5149F18938CC
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 08:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E8E212FAB;
	Fri, 28 Mar 2025 08:28:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8E62F30;
	Fri, 28 Mar 2025 08:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743150521; cv=none; b=dgVSVxE3BoNsjNTTWPrRaqwMtScw5w2kOSG0Zg2w5bVo496wtUeuuAlhSdyuSXUtOE2o57JQJx+XGUq6QUaCp/V9pajOMgr9rwhe5m/+c3baA1SDUUieHBcy685+oops+lswZGfeLws3L0D8iPmzrftXbgmZlG+ELHSxmjBE3m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743150521; c=relaxed/simple;
	bh=+7f36zh2YmV73APuA9i2NpMvoGc/2rspVzmVxr+RyqY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=U2usz4mfdMqdkGXWwSRQ0lv9Yk3/PECNds6zvJmv/J/iVGUcE6Ol/GrjDhaRIlUMojgFuPTUM9Ic8j6T7YhN7q4WdUwNLRbLBY2ZGo4OnahSJRyu/MPtaXHA+YG8jvupI7tV+XTeFkYkUy+ERmyDzxKOXnH2zev1XxBGyFQFGGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZPDG10YpBz27hVk;
	Fri, 28 Mar 2025 16:29:13 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id F118F1400F4;
	Fri, 28 Mar 2025 16:28:34 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 28 Mar 2025 16:28:34 +0800
Subject: Re: [PATCH v6 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250318064548.59043-1-liulongfang@huawei.com>
 <20250318064548.59043-6-liulongfang@huawei.com>
 <20250321095240.40bf55ec.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <96c36c66-37a6-7bdb-75b8-dd7d6f63bb35@huawei.com>
Date: Fri, 28 Mar 2025 16:28:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250321095240.40bf55ec.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/3/21 23:52, Alex Williamson wrote:
> On Tue, 18 Mar 2025 14:45:48 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
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
>> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 21 ++++++++++++-------
>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index cadc82419dca..68b1c7204cad 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -426,13 +426,6 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return -EINVAL;
>>  	}
>>  
>> -	ret = qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
>> -	if (ret) {
>> -		dev_err(dev, "failed to write QM_VF_STATE\n");
>> -		return ret;
>> -	}
>> -
>> -	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>  	hisi_acc_vdev->match_done = true;
>>  	return 0;
>>  }
>> @@ -498,6 +491,13 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
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
>> @@ -506,6 +506,12 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	qm->qp_base = vf_data->qp_base;
>>  	qm->qp_num = vf_data->qp_num;
>>  
>> +	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
>> +	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
>> +		dev_err(dev, "resume dma addr is NULL!\n");
>> +		return -EINVAL;
>> +	}
>> +
> 
> I'm not sure how this fits in based on the commit log.  IIUC, we're
> actually rejecting the migration data here, which will cause a
> migration failure.  We're also testing the validity of the data *after*
> we've actually applied it to the hisi_qm object, which seems backwards.
> 
> Are we just not processing the migration data because there's no driver
> or are we failing the migration?  There shouldn't be a requirement on
> the state of the guest driver for a successful migration.  Thanks,
>

Therefore, this shouldn't be about exiting the migration operation,
but rather continuing the migration process while skipping these empty
address write operations.
Consequently, this shouldn't return an error,
it should simply return 0.

Thanks.
Longfang.

> Alex
> 
>>  	ret = qm_set_regs(qm, vf_data);
>>  	if (ret) {
>>  		dev_err(dev, "set VF regs failed\n");
>> @@ -1531,6 +1537,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
>>  	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
>>  	hisi_acc_vdev->pf_qm = pf_qm;
>>  	hisi_acc_vdev->vf_dev = pdev;
>> +	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
>>  	mutex_init(&hisi_acc_vdev->state_mutex);
>>  	mutex_init(&hisi_acc_vdev->open_mutex);
>>  
> 
> 
> 
> .
> 

