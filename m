Return-Path: <kvm+bounces-34580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D82A0236C
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 11:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97B29188550D
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 10:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0DF1DC1A7;
	Mon,  6 Jan 2025 10:49:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567631DACBE;
	Mon,  6 Jan 2025 10:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736160585; cv=none; b=IcfqyuVMnV9gxWgfvGYgvfYzb9PWxvSKPiJiKLTMthwnJ6K+fJUXm2WikcTpVcf/todoCuKzSW8orOfFJOuzEvyblzUW2NSqKmwVk2SarVRpei9p4AfqNT3lv4RHC/FHSgAyKppk3FDRMje1dcQ0afgWRUzd029MqAAUEw2P71U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736160585; c=relaxed/simple;
	bh=gMY7P4vJuP3BE3MB28YsOxXzHsou17iRneDjojqeXsA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tpyDREagER50gQuLF69MwSXB3SuA2pN25xJAS0U7J4v6wRPc+zDQLAPabdQNiW0fIyTSF9WUaMTW3PHcieK5qmxiil+Q1lP9K+PjpMvGQuROrZ/rBI61o0NbiZzDHBlwbH8n7HF6cuLkpdm0w/bYCV3toLxRkBfqhHhWi1igWr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YRW7v07STz2Dk4S;
	Mon,  6 Jan 2025 18:46:35 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id DCFF0140135;
	Mon,  6 Jan 2025 18:49:33 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 6 Jan 2025 18:49:33 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jan 2025 18:49:32 +0800
Subject: Re: [PATCH v3 1/5] hisi_acc_vfio_pci: fix XQE dma address error
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250102030729.34115-1-liulongfang@huawei.com>
 <20250102030729.34115-2-liulongfang@huawei.com>
 <20250102153545.5dce8d1e.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <e0069844-eca5-78e7-8d56-2fddd7981bf4@huawei.com>
Date: Mon, 6 Jan 2025 18:49:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250102153545.5dce8d1e.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2025/1/3 6:35, Alex Williamson wrote:
> On Thu, 2 Jan 2025 11:07:25 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
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
>> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live migration")
> 
> Please use the proper Fixes: tag layout throughout.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n145
> 
> (spaces are missing between fields)
>

OK.

Thanks.
Longfang.

> Thanks,
> Alex
> 
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++----
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
>>  2 files changed, 36 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
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
>> +		vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>> +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>> +		vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
>> +		vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>> +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>> +		vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  			     struct hisi_acc_vf_migration_file *migf)
>>  {
>> @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
>>  		return 0;
>>  
>> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
>> +	ret = vf_qm_magic_check(vf_data);
>> +	if (ret) {
>>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>>  		return -EINVAL;
>>  	}
>> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>  	int vf_id = hisi_acc_vdev->vf_id;
>>  	int ret;
>>  
>> -	vf_data->acc_magic = ACC_DEV_MAGIC;
>> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
>>  	/* Save device id */
>>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>>  
>> @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
>>  		return -EINVAL;
>>  
>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
>> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
>> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
>> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
>> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
>> +	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
>> +	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
>>  
>>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index 245d7537b2bc..d26eb751fb82 100644
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
>> +	ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECA0002,
>> +};
>> +
>>  struct acc_vf_data {
>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>  	/* QM match information */
>> -#define ACC_DEV_MAGIC	0XCDCDCDCDFEEDAACC
>>  	u64 acc_magic;
>>  	u32 qp_num;
>>  	u32 dev_id;
> 
> 
> .
> 

