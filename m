Return-Path: <kvm+bounces-34385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 485619FD0FD
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 08:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD9CE3A05B3
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 07:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF8D1459F6;
	Fri, 27 Dec 2024 07:21:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064C01DA4E;
	Fri, 27 Dec 2024 07:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735284082; cv=none; b=Kf8jTZTThB95gBcB+vFEh6R9iJ1aTnEoLal/5YmxheI9t8gkvtaQI4AaKVbbN/e1xSTWflAuZG16wksoNwwgdVOWG/y6QT/EmP0osKfo3hrejise5N/hL9461DHXRin2tl5WsStX7dCUmXexOvEKXUVZBVgwAHEflLhx6MLekPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735284082; c=relaxed/simple;
	bh=7CWKJG4AHNNfDG0iusfHb1mnElQ7DxjIwM03c7fgCvs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=r6dWLQ9hyKwRU/7icWBY0alyhkoJ6ZNBaukyDBoB99Cy76azJ8+V30ci24sAYVdF9vDoXMWD/sgxqUCqW/hvRkHlhPPTmaH4BdHPFyFgJOCMeN6c6g1sE7OrIUJLOUdW9777F8C0sNByySmDY1Bj/aDTnS6ahxYLSUoz4lKxf3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YKH0J4ysTz1kwwM;
	Fri, 27 Dec 2024 15:18:24 +0800 (CST)
Received: from dggemv703-chm.china.huawei.com (unknown [10.3.19.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 793741A0188;
	Fri, 27 Dec 2024 15:21:10 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 27 Dec 2024 15:21:10 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Dec 2024 15:21:09 +0800
Subject: Re: [PATCH v2 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-6-liulongfang@huawei.com>
 <a39f57190a46497e816eefa6b649b583@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <98722fb2-fd84-9c2f-b080-31c1bb8f9aea@huawei.com>
Date: Fri, 27 Dec 2024 15:20:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a39f57190a46497e816eefa6b649b583@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/12/19 18:02, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: liulongfang <liulongfang@huawei.com>
>> Sent: Thursday, December 19, 2024 9:18 AM
>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>> Subject: [PATCH v2 5/5] hisi_acc_vfio_pci: bugfix live migration function
>> without VF device driver
>>
>> If the driver of the VF device is not loaded in the Guest OS,
>> then perform device data migration. The migrated data address will
>> be NULL.
>> The live migration recovery operation on the destination side will
>> access a null address value, which will cause access errors.
>>
>> Therefore, live migration of VMs without added VF device drivers
>> does not require device data migration.
>> In addition, when the queue address data obtained by the destination
>> is empty, device queue recovery processing will not be performed.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> 
> Why this doesn't need a Fixes tag?
>

If we need to synchronize to the stable branch, we can add the Fixes tag here.

>> ---
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 8d9e07ebf4fd..9a5f7e9bc695 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -436,6 +436,7 @@ static int vf_qm_get_match_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  				struct acc_vf_data *vf_data)
>>  {
>>  	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>  	struct device *dev = &pf_qm->pdev->dev;
>>  	int vf_id = hisi_acc_vdev->vf_id;
>>  	int ret;
>> @@ -460,6 +461,13 @@ static int vf_qm_get_match_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  		return ret;
>>  	}
>>
>> +	/* Get VF driver insmod state */
>> +	ret = qm_read_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state,
>> 1);
>> +	if (ret) {
>> +		dev_err(dev, "failed to read QM_VF_STATE!\n");
>> +		return ret;
>> +	}
>> +
>>  	return 0;
>>  }
>>
>> @@ -499,6 +507,12 @@ static int vf_qm_load_data(struct
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
> 
> So this is to cover the corner case where the Guest has loaded the driver
> (QM_READY set) but not configured the DMA address? When this will happen?
> I thought we are setting QM_READY in guest after all configurations.
>

When performing remote live migration, there are abnormal scenarios where the dma
value received through the network is empty.
The driver needs to prevent this null DMA address data from being sent to the hardware.

Thanks.
Longfang.

> Thanks,
> Shameer
> 
> 
> .
> 

