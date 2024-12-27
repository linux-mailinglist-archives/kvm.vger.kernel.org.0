Return-Path: <kvm+bounces-34386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EFD9FD109
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 08:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C42F418829BA
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 07:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB674145B16;
	Fri, 27 Dec 2024 07:24:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B5B143C63;
	Fri, 27 Dec 2024 07:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735284270; cv=none; b=jHPuMuBnb2LTCedyD7vzfRd1YJYDS1lwtTtqFN2ktqmIlXEhmSZtPhEJRnMntOVgfnA/hllLmLIqlEf3WPbqf7hszLqw+92PjessG/Bp9WbvA5zksgfKJUGYH3oUkyBEsjCuO+iVjIip0VfCTT1cuDefo3FyJWUuMJJe9KYkZyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735284270; c=relaxed/simple;
	bh=A2m5yJlhJLjVopIYv1a74LbGWcVvFAGS9/Gfqzru4Fs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jcYd0fDh7knDMzDpKACS8YX+c5bQM50DitxkcFvgBCxyxT6rJyjM8gkYxEFy1sPVvU4AaVekv0vYYNh+afuy48QK59yi4M0Whc0SHrfAzdewsCQGTplz0heN0oLoiSwpbYzfwrWkxJ43EZcuxg4ArTqZMm5RhQLbIhzUE8qtq9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YKH3846LVzxWlq;
	Fri, 27 Dec 2024 15:20:52 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id F362C140381;
	Fri, 27 Dec 2024 15:24:18 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 27 Dec 2024 15:24:18 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Dec 2024 15:24:18 +0800
Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-2-liulongfang@huawei.com>
 <099e0e1215f34d64a4ae698b90ee372c@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <73fbb369-1bd7-db91-9868-a8ac42f5dd68@huawei.com>
Date: Fri, 27 Dec 2024 15:24:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <099e0e1215f34d64a4ae698b90ee372c@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/12/19 18:01, Shameerali Kolothum Thodi wrote:
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
>> Subject: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
>>
>> The dma addresses of EQE and AEQE are wrong after migration and
>> results in guest kernel-mode encryption services  failure.
>> Comparing the definition of hardware registers, we found that
>> there was an error when the data read from the register was
>> combined into an address. Therefore, the address combination
>> sequence needs to be corrected.
>>
>> Even after fixing the above problem, we still have an issue
>> where the Guest from an old kernel can get migrated to
>> new kernel and may result in wrong data.
>>
>> In order to ensure that the address is correct after migration,
>> if an old magic number is detected, the dma address needs to be
>> updated.
>>
>> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
>> migration")
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++----
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
>>  2 files changed, 36 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index 451c639299eb..8518efea3a52 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -350,6 +350,27 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>>  }
>>
>> +static int vf_qm_magic_check(struct acc_vf_data *vf_data)
>> +{
>> +	switch (vf_data->acc_magic) {
>> +	case ACC_DEV_MAGIC_V2:
>> +		break;
>> +	case ACC_DEV_MAGIC_V1:
>> +		/* Correct dma address */
>> +		vf_data->eqe_dma = vf_data-
>>> qm_eqc_dw[QM_XQC_ADDR_HIGH];
>> +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>> +		vf_data->eqe_dma |= vf_data-
>>> qm_eqc_dw[QM_XQC_ADDR_LOW];
>> +		vf_data->aeqe_dma = vf_data-
>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>> +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>> +		vf_data->aeqe_dma |= vf_data-
>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int vf_qm_check_match(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev,
>>  			     struct hisi_acc_vf_migration_file *migf)
>>  {
>> @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-
>>> match_done)
>>  		return 0;
>>
>> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
>> +	ret = vf_qm_magic_check(vf_data);
>> +	if (ret) {
>>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>>  		return -EINVAL;
>>  	}
>> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	int vf_id = hisi_acc_vdev->vf_id;
>>  	int ret;
>>
>> -	vf_data->acc_magic = ACC_DEV_MAGIC;
>> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
>>  	/* Save device id */
>>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>>
>> @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm
>> *vf_qm, struct acc_vf_data *vf_data)
>>  		return -EINVAL;
>>
>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
>> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
>> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
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
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index 245d7537b2bc..2afce68f5a34 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -39,6 +39,9 @@
>>  #define QM_REG_ADDR_OFFSET	0x0004
>>
>>  #define QM_XQC_ADDR_OFFSET	32U
>> +#define QM_XQC_ADDR_LOW	0x1
>> +#define QM_XQC_ADDR_HIGH	0x2
>> +
>>  #define QM_VF_AEQ_INT_MASK	0x0004
>>  #define QM_VF_EQ_INT_MASK	0x000c
>>  #define QM_IFC_INT_SOURCE_V	0x0020
>> @@ -50,10 +53,14 @@
>>  #define QM_EQC_DW0		0X8000
>>  #define QM_AEQC_DW0		0X8020
>>
>> +enum acc_magic_num {
>> +	ACC_DEV_MAGIC_V1 = 0XCDCDCDCDFEEDAACC,
>> +	ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECADEDE,
> 
> 
> I think we have discussed this before that having some kind of 
> version info embed into magic_num will be beneficial going 
> forward. ie, may be use the last 4 bytes for denoting version.
> 
> ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECA0002
>

OK, so the subsequent magic number no longer needs a random value,
but a predictable and certain value.

Thanks,
Longfang.

> The reason being, otherwise we have to come up with a random
> magic each time when a fix like this is required in future.
> 
> Thanks,
> Shameer
> 
> .
> 

