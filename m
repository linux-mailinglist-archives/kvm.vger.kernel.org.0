Return-Path: <kvm+bounces-16804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2564D8BDD2F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D43B02814F6
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3751E13D2B3;
	Tue,  7 May 2024 08:31:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D913D26B;
	Tue,  7 May 2024 08:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715070660; cv=none; b=ilBTcR2rB7AHIigrPXIwZ8Lc8THFZWIijZJdkdwGRvSH8pG43hVgVqHOQu5EM+a96UHtESaqea+E0Cx9aEZQFZ89r1dcL1m4rQpV5F7Tt3EjzQvJFH5rqt7I7zRbAzrN5Z8olxi/Oe7q0GP9Nd795VVG2j9sN4TQWEEGD73L0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715070660; c=relaxed/simple;
	bh=GYtaM+tCrLAnsNRMA8561Tg5jtwIwouA1R/o8fttqbo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AWnExb6yxinZeAY/BAFQf6K0+gI8yIPBn39z9seWXXFpxU2wL92LBxPzt8OXiEHlFN0j3PuvclF4+Jf3EQxmTIxr3fZiQENSwL+vQjgCv8D0JOnlLnPqB4DGrmGfG22Tt48ry7/WuHgylefLRyr4jHpxirdZ/GbuovXpcRdIaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VYWbZ1gYlzYsnK;
	Tue,  7 May 2024 16:27:06 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EF3F180AA0;
	Tue,  7 May 2024 16:30:55 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 16:30:52 +0800
Subject: Re: [PATCH v6 3/5] hisi_acc_vfio_pci: create subfunction for data
 reading
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20240425132322.12041-1-liulongfang@huawei.com>
 <20240425132322.12041-4-liulongfang@huawei.com>
 <20240503102506.5b7a41ef.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <77e776eb-bc46-0a07-217c-e3bf385c7502@huawei.com>
Date: Tue, 7 May 2024 16:30:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240503102506.5b7a41ef.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/5/4 0:25, Alex Williamson wrote:
> On Thu, 25 Apr 2024 21:23:20 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> During the live migration process.
> 
> This is not a complete sentence.
> 
>> It needs to obtain various status
>> data of drivers and devices.
> 
> What's "It" describing here?
> 
>> In order to facilitate calling it in the
>> debugfs function.
> 
> Also not a complete sentence.
> 
>> For all operations that read data from device registers,
>> the driver creates a subfunction.
> 
> There's only one sub-function.
> 
>> Also fixed the location of address data.
> 
> I think this is addressed in the previous patch now?  Thanks,
> 

OK, I'll update the descriptions again.

> Alex
>

Thanks,
Longfang.

>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 54 +++++++++++--------
>>  1 file changed, 33 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 0c7e31076ff4..bf358ba94b5d 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -486,31 +486,11 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	return 0;
>>  }
>>  
>> -static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>> -			    struct hisi_acc_vf_migration_file *migf)
>> +static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
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
>>  	if (ret)
>>  		return -EINVAL;
>> @@ -536,6 +516,38 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
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
>> +	struct device *dev = &vf_qm->pdev->dev;
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
>> +	ret = vf_qm_cache_wb(vf_qm);
>> +	if (ret) {
>> +		dev_err(dev, "failed to writeback QM Cache!\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = vf_qm_read_data(vf_qm, vf_data);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>>  	migf->total_length = sizeof(struct acc_vf_data);
>>  	return 0;
>>  }
> 
> .
> 

