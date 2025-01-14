Return-Path: <kvm+bounces-35347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1A3A0FF1E
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 04:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 066DE168C9A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 03:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED32231A3A;
	Tue, 14 Jan 2025 03:17:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417452309A4;
	Tue, 14 Jan 2025 03:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736824671; cv=none; b=sGF29Pt97/FzdxJMQ/kmVsP9yQ53YD2NIR/vv9gY8JpsSnse9Wi6MIMOUdQGw7b8qOhvptWDRSbvvqzwvQdtuYRllACIPQtAHthaI7pivyF0ZydVjGqXI5FKjNeXwi7/JZTc1ZYJdIh5dQitvkUefEZngYuaVPtuUtkwPQABfxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736824671; c=relaxed/simple;
	bh=sUrYQ0lZ4MnvKWNRNpNY5YqLPstSKx15KTSdieSJbKo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Djbxqtd5VqSVItZR2v64eig+gzGt+fSO62dIwxNzRWUQJUEKiKhOQvHExjCSoGk9maRDcXddHFk42r6t6Ac4DVFopdYnYoYFA7snhjksPItottff34sbPs9s7VRZeOev4mcsLtKyMnG2XS2Y1UWApVWRSkJyCpF6e/4n2zw9ZMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YXDpm0vxXz2YPk2;
	Tue, 14 Jan 2025 11:18:08 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id 53441180042;
	Tue, 14 Jan 2025 11:17:44 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 14 Jan 2025 11:17:44 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Jan 2025 11:17:43 +0800
Subject: Re: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
To: Alex Williamson <alex.williamson@redhat.com>
CC: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-2-liulongfang@huawei.com>
 <099e0e1215f34d64a4ae698b90ee372c@huawei.com>
 <20250102153008.301730f3.alex.williamson@redhat.com>
 <4d48db10-23e1-1bb4-54ea-4c659ab85f19@huawei.com>
 <20250113083441.0fb7afa3.alex.williamson@redhat.com>
 <20250113144516.22a17af8.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <80a4e398-ad29-cce8-4a52-ce2a5f6a308c@huawei.com>
Date: Tue, 14 Jan 2025 11:17:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250113144516.22a17af8.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2025/1/14 3:45, Alex Williamson wrote:
> On Mon, 13 Jan 2025 08:34:41 -0500
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Mon, 13 Jan 2025 17:43:09 +0800
>> liulongfang <liulongfang@huawei.com> wrote:
>>
>>> On 2025/1/3 6:30, Alex Williamson wrote:  
>>>> On Thu, 19 Dec 2024 10:01:03 +0000
>>>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
>>>>     
>>>>>> -----Original Message-----
>>>>>> From: liulongfang <liulongfang@huawei.com>
>>>>>> Sent: Thursday, December 19, 2024 9:18 AM
>>>>>> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
>>>>>> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>>>>>> <jonathan.cameron@huawei.com>
>>>>>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>>>> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
>>>>>> Subject: [PATCH v2 1/5] hisi_acc_vfio_pci: fix XQE dma address error
>>>>>>
>>>>>> The dma addresses of EQE and AEQE are wrong after migration and
>>>>>> results in guest kernel-mode encryption services  failure.
>>>>>> Comparing the definition of hardware registers, we found that
>>>>>> there was an error when the data read from the register was
>>>>>> combined into an address. Therefore, the address combination
>>>>>> sequence needs to be corrected.
>>>>>>
>>>>>> Even after fixing the above problem, we still have an issue
>>>>>> where the Guest from an old kernel can get migrated to
>>>>>> new kernel and may result in wrong data.
>>>>>>
>>>>>> In order to ensure that the address is correct after migration,
>>>>>> if an old magic number is detected, the dma address needs to be
>>>>>> updated.
>>>>>>
>>>>>> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
>>>>>> migration")
>>>>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>>>>> ---
>>>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 34 +++++++++++++++----
>>>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 ++++-
>>>>>>  2 files changed, 36 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>>>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>>>> index 451c639299eb..8518efea3a52 100644
>>>>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>>>> @@ -350,6 +350,27 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>>>>>>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>>>>>>  }
>>>>>>
>>>>>> +static int vf_qm_magic_check(struct acc_vf_data *vf_data)
>>>>>> +{
>>>>>> +	switch (vf_data->acc_magic) {
>>>>>> +	case ACC_DEV_MAGIC_V2:
>>>>>> +		break;
>>>>>> +	case ACC_DEV_MAGIC_V1:
>>>>>> +		/* Correct dma address */
>>>>>> +		vf_data->eqe_dma = vf_data-      
>>>>>>> qm_eqc_dw[QM_XQC_ADDR_HIGH];      
>>>>>> +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>>>>>> +		vf_data->eqe_dma |= vf_data-      
>>>>>>> qm_eqc_dw[QM_XQC_ADDR_LOW];      
>>>>>> +		vf_data->aeqe_dma = vf_data-      
>>>>>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];      
>>>>>> +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>>>>>> +		vf_data->aeqe_dma |= vf_data-      
>>>>>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];      
>>>>>> +		break;
>>>>>> +	default:
>>>>>> +		return -EINVAL;
>>>>>> +	}
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>>  static int vf_qm_check_match(struct hisi_acc_vf_core_device
>>>>>> *hisi_acc_vdev,
>>>>>>  			     struct hisi_acc_vf_migration_file *migf)
>>>>>>  {
>>>>>> @@ -363,7 +384,8 @@ static int vf_qm_check_match(struct
>>>>>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>>>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-      
>>>>>>> match_done)      
>>>>>>  		return 0;
>>>>>>
>>>>>> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
>>>>>> +	ret = vf_qm_magic_check(vf_data);
>>>>>> +	if (ret) {
>>>>>>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>>>>>>  		return -EINVAL;
>>>>>>  	}
>>>>>> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct
>>>>>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>>>  	int vf_id = hisi_acc_vdev->vf_id;
>>>>>>  	int ret;
>>>>>>
>>>>>> -	vf_data->acc_magic = ACC_DEV_MAGIC;
>>>>>> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
>>>>>>  	/* Save device id */
>>>>>>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>>>>>>
>>>>>> @@ -496,12 +518,12 @@ static int vf_qm_read_data(struct hisi_qm
>>>>>> *vf_qm, struct acc_vf_data *vf_data)
>>>>>>  		return -EINVAL;
>>>>>>
>>>>>>  	/* Every reg is 32 bit, the dma address is 64 bit. */
>>>>>> -	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
>>>>>> +	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
>>>>>>  	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>>>>>> -	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
>>>>>> -	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
>>>>>> +	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
>>>>>> +	vf_data->aeqe_dma = vf_data-      
>>>>>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];      
>>>>>>  	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>>>>>> -	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
>>>>>> +	vf_data->aeqe_dma |= vf_data-      
>>>>>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];      
>>>>>>
>>>>>>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
>>>>>>  	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>>>>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>>>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>>>> index 245d7537b2bc..2afce68f5a34 100644
>>>>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>>>> @@ -39,6 +39,9 @@
>>>>>>  #define QM_REG_ADDR_OFFSET	0x0004
>>>>>>
>>>>>>  #define QM_XQC_ADDR_OFFSET	32U
>>>>>> +#define QM_XQC_ADDR_LOW	0x1
>>>>>> +#define QM_XQC_ADDR_HIGH	0x2
>>>>>> +
>>>>>>  #define QM_VF_AEQ_INT_MASK	0x0004
>>>>>>  #define QM_VF_EQ_INT_MASK	0x000c
>>>>>>  #define QM_IFC_INT_SOURCE_V	0x0020
>>>>>> @@ -50,10 +53,14 @@
>>>>>>  #define QM_EQC_DW0		0X8000
>>>>>>  #define QM_AEQC_DW0		0X8020
>>>>>>
>>>>>> +enum acc_magic_num {
>>>>>> +	ACC_DEV_MAGIC_V1 = 0XCDCDCDCDFEEDAACC,
>>>>>> +	ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECADEDE,      
>>>>>
>>>>>
>>>>> I think we have discussed this before that having some kind of 
>>>>> version info embed into magic_num will be beneficial going 
>>>>> forward. ie, may be use the last 4 bytes for denoting version.
>>>>>
>>>>> ACC_DEV_MAGIC_V2 = 0xAACCFEEDDECA0002
>>>>>
>>>>> The reason being, otherwise we have to come up with a random
>>>>> magic each time when a fix like this is required in future.    
>>>>
>>>> Overloading the magic value like this is a bit strange.  Typically
>>>> the magic value should be the cookie that identifies the data blob as
>>>> generated by this driver and a separate version field would identify
>>>> any content or format changes.  In the mtty driver I included a magic
>>>> field along with major and minor versions to provide this flexibility.
>>>> I wonder why we wouldn't do something similar here rather than create
>>>> this combination magic/version field.  It's easy enough to append a
>>>> couple fields onto the structure or redefine a v2 structure to use
>>>> going forward.  There's even a padding field in the structure already
>>>> that could be repurposed.
>>>>    
>>>
>>> If we add the major and minor version numbers like mtty driver, the current
>>> data structure needs to be changed, and this change also needs to be compatible
>>> with the old and new versions.
>>> And the old version does not have this information. The new version cannot
>>> be adapted when it is imported.  
>>
>> Are you suggesting that we cannot use a different data structure based
>> on the magic value?  That's rather the point of the magic value.
>>
>>> Now in this patch to fix this problem, we only need to update a magic number,
>>> and then the problem is corrected. Migration between old and new versions can
>>> also be fixed:
>>>
>>> Old --> Old, wrong, but we can't stop it;
>>> Old --> New, corrected migrated incorrect data, recovery successful;
>>> New --> New, correct, recovery successful;
>>> New --> Old, correct, recovery successful.
> 
> BTW, New->Old is not possible given the current old code and this
> series doesn't enable it.  New magic is saved, old restore could should
> reject it:
> 
> static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>                              struct hisi_acc_vf_migration_file *migf)
> {       
> ...
>         if (vf_data->acc_magic != ACC_DEV_MAGIC) { 
>                 dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>                 return -EINVAL; 
>         }
> 
>>From this patch:

Yes, New->Old will be rejected when matching like this.

> 
> @@ -418,7 +440,7 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	int vf_id = hisi_acc_vdev->vf_id;
>  	int ret;
>  
> -	vf_data->acc_magic = ACC_DEV_MAGIC;
> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
>  	/* Save device id */
>  	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>  
> Thanks,
> Alex
> 
>>>
>>> As for the compatibility issues between old and new versions in the future,
>>> we do not need to reserve version numbers to deal with them now. Because
>>> before encountering specific problems, our design may be redundant.  
>>
>> A magic value + version number would prevent the need to replace the
>> magic value every time an issue is encountered, which I think was also
>> Shameer's commit, which is not addressed by forcing the formatting of a
>> portion of the magic value.  None of what you're trying to do here
>> precludes a new data structure for the new magic value or defining the
>> padding fields for different use cases.  Thanks,
>>
>> Alex
> 

If we want to use the original magic number, we also need to add the major
and minor version numbers. It does not cause compatibility issues and can
only reuse the original u64 memory space.

This is also Shameerali's previous plan. Do you accept this plan?

Thanks.
Longfang.

> 
> .
> 

