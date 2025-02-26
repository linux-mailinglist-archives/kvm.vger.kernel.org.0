Return-Path: <kvm+bounces-39273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C1FBA45D66
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9191894020
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 11:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345A121577D;
	Wed, 26 Feb 2025 11:41:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F0621505D;
	Wed, 26 Feb 2025 11:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570109; cv=none; b=uogbsB89HMoA0iEu/DdNGTMCZzP3+2Mu4twN5bmmM+YMGzdALx7IxDnzfDxp5JtWAPjMks+H74QgTnvkWRVhBPzbRdRl7YuSxY4dP0Z2MxVyKjGLcl6uq3jedcz2Lc3mfl4coEAlzQjmHfsd1Xp+biz56zicdnm9C5ofGCaUcdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570109; c=relaxed/simple;
	bh=KSwNl3A1mC+3ZEdgjSHwOe3ThOAVyqdt0JrcLju1qg8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Liv4B1LTWfgdrz8cW3SfWl831v+ibAYLnLpyj1pIctN8hBasJxfbdn5oknwCjWlW6pl2k0PsvzsG/8XCYxoPEgqjunCYMNBRJjSK2iqSQ++gIpz8MZhUYfc9ljGXFJ4Fsqu75YCcg5QWEmX3acFCNiyIiFJ1G+RECPbEhedZf/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Z2srN2P2Xz1GDh5;
	Wed, 26 Feb 2025 19:36:52 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B5821402C4;
	Wed, 26 Feb 2025 19:41:37 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 26 Feb 2025 19:41:36 +0800
Subject: Re: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Alex
 Williamson <alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20250225062757.19692-1-liulongfang@huawei.com>
 <20250225062757.19692-2-liulongfang@huawei.com>
 <20250225170941.46b0ede5.alex.williamson@redhat.com>
 <024fd8e2334141b688150650728699ba@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <2dd0cd4a-0b64-aa21-d82b-f1d506d42631@huawei.com>
Date: Wed, 26 Feb 2025 19:41:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <024fd8e2334141b688150650728699ba@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/2/26 16:11, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Wednesday, February 26, 2025 12:10 AM
>> To: liulongfang <liulongfang@huawei.com>
>> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
>> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
>> kernel@vger.kernel.org; linuxarm@openeuler.org
>> Subject: Re: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
>>
>> On Tue, 25 Feb 2025 14:27:53 +0800
>> Longfang Liu <liulongfang@huawei.com> wrote:
>>
>>> The dma addresses of EQE and AEQE are wrong after migration and
>>> results in guest kernel-mode encryption services  failure.
>>> Comparing the definition of hardware registers, we found that
>>> there was an error when the data read from the register was
>>> combined into an address. Therefore, the address combination
>>> sequence needs to be corrected.
>>>
>>> Even after fixing the above problem, we still have an issue
>>> where the Guest from an old kernel can get migrated to
>>> new kernel and may result in wrong data.
>>>
>>> In order to ensure that the address is correct after migration,
>>> if an old magic number is detected, the dma address needs to be
>>> updated.
>>>
>>> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
>> migration")
>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>> ---
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 40 ++++++++++++++++---
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
>>>  2 files changed, 46 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> index 451c639299eb..35316984089b 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> @@ -350,6 +350,31 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
>>>  	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
>>>  }
>>>
>>> +static int vf_qm_version_check(struct acc_vf_data *vf_data, struct device
>> *dev)
>>> +{
>>> +	switch (vf_data->acc_magic) {
>>> +	case ACC_DEV_MAGIC_V2:
>>> +		if (vf_data->major_ver < ACC_DRV_MAJOR_VER ||
>>> +		    vf_data->minor_ver < ACC_DRV_MINOR_VER)
>>> +			dev_info(dev, "migration driver version not
>> match!\n");
>>> +			return -EINVAL;
>>> +		break;
>>
>> What's your major/minor update strategy?
>>
>> Note that minor_ver is a u16 and ACC_DRV_MINOR_VER is defined as 0, so
>> testing less than 0 against an unsigned is useless.
>>
>> Arguably testing major and minor independently is pretty useless too.
>>
>> You're defining what a future "old" driver version will accept, which
>> is very nearly anything, so any breaking change *again* requires a new
>> magic, so we're accomplishing very little here.
>>
>> Maybe you want to consider a strategy where you'd increment the major
>> number for a breaking change and minor for a compatible feature.  In
>> that case you'd want to verify the major_ver matches
>> ACC_DRV_MAJOR_VER
>> exactly and minor_ver would be more of a feature level.
> 
> Agree. I think the above check should be just major_ver != ACC_DRV_MAJOR_VER
> and we can make use of minor version whenever we need a specific handling for
> a feature support.
>

Well, that's a good way.
We only use minor_ver to record important updates of the driver. When there is
an important update, minor_ver increases by 1.
Major_ver is used to distinguish migration versions. After major_ver is updated,
minor_ver returns to 0.

Therefore, we can change it to only check major_ver.

> Also I think it would be good to print the version info above in case of mismatch.
>

OK.
Thanks.
Longfang.

>>
>>> +	case ACC_DEV_MAGIC_V1:
>>> +		/* Correct dma address */
>>> +		vf_data->eqe_dma = vf_data-
>>> qm_eqc_dw[QM_XQC_ADDR_HIGH];
>>> +		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
>>> +		vf_data->eqe_dma |= vf_data-
>>> qm_eqc_dw[QM_XQC_ADDR_LOW];
>>> +		vf_data->aeqe_dma = vf_data-
>>> qm_aeqc_dw[QM_XQC_ADDR_HIGH];
>>> +		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
>>> +		vf_data->aeqe_dma |= vf_data-
>>> qm_aeqc_dw[QM_XQC_ADDR_LOW];
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static int vf_qm_check_match(struct hisi_acc_vf_core_device
>> *hisi_acc_vdev,
>>>  			     struct hisi_acc_vf_migration_file *migf)
>>>  {
>>> @@ -363,7 +388,8 @@ static int vf_qm_check_match(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev-
>>> match_done)
>>>  		return 0;
>>>
>>> -	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
>>> +	ret = vf_qm_version_check(vf_data, dev);
>>> +	if (ret) {
>>>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
>>>  		return -EINVAL;
>>>  	}
>>> @@ -418,7 +444,9 @@ static int vf_qm_get_match_data(struct
>> hisi_acc_vf_core_device *hisi_acc_vdev,
>>>  	int vf_id = hisi_acc_vdev->vf_id;
>>>  	int ret;
>>>
>>> -	vf_data->acc_magic = ACC_DEV_MAGIC;
>>> +	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
>>> +	vf_data->major_ver = ACC_DRV_MAR;
>>> +	vf_data->minor_ver = ACC_DRV_MIN;
>>
>> Where are "MAR" and "MIN" defined?  I can't see how this would even
>> compile.  Thanks,
> 
> Yes. Please  make sure to do a compile test and run basic sanity tested even if you
> think the changes are minor. Chances are there that you will miss out things like
> this.
> 
> Thanks,
> Shameer
>  
> .
> 

