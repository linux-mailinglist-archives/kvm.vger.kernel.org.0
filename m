Return-Path: <kvm+bounces-42170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EE6A74500
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 09:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7023817BDE6
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 08:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A56213232;
	Fri, 28 Mar 2025 08:06:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6847A213220;
	Fri, 28 Mar 2025 08:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743149207; cv=none; b=c8VLy5yFBGO1/dTVUVvhQL6QKjPjla88EIt9vEmngUtB6BqDyofdtZne/NGK+r35y3x9KhslI/zCVZ6/zge4W2Fs0g6tnVSA+FuGbx+PHHzwqwtipR50Iyx+1Dl9ldWD2/sidzKue4ghxtRHOMP05eGDh/QpAifuDQgIhPNdnWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743149207; c=relaxed/simple;
	bh=dTp4hx+NaY9SL+selOKBbyCVLSC+R9qDMdSgD2SIHLw=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=k7HqOM/PerGOgrbjopWTqNBrFYol3NAFHlpYLtWpfcUMNu5/CULglnXBZLuvC2v+V3x1kK+iqc77ks3D3muGByanwuunL9DL6NZqKY5KwJWQzREla8TVUWaunWBEL8C69PgoUmfkWV+qTtChvI6h/5AKZqEf7h1D1b7cRuVDNJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZPCmn088rz27hQt;
	Fri, 28 Mar 2025 16:07:21 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id E6D411402DB;
	Fri, 28 Mar 2025 16:06:42 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 28 Mar 2025 16:06:42 +0800
Subject: Re: [PATCH v6 4/5] hisi_acc_vfio_pci: bugfix the problem of
 uninstalling driver
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250318064548.59043-1-liulongfang@huawei.com>
 <20250318064548.59043-5-liulongfang@huawei.com>
 <20250321095150.7fe81186.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <d2141649-bda0-a980-4932-e01f79d03b9c@huawei.com>
Date: Fri, 28 Mar 2025 16:06:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250321095150.7fe81186.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On 2025/3/21 23:51, Alex Williamson wrote:
> On Tue, 18 Mar 2025 14:45:47 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> In a live migration scenario. If the number of VFs at the
>> destination is greater than the source, the recovery operation
>> will fail and qemu will not be able to complete the process and
>> exit after shutting down the device FD.
>>
>> This will cause the driver to be unable to be unloaded normally due
>> to abnormal reference counting of the live migration driver caused
>> by the abnormal closing operation of fd.
> 
> "Therefore, make sure the migration file descriptor references are
>  always released when the device is closed."
> 
> The commit log identifies the problem, but it's generally also useful
> to describe the resolution of the problem as well.  Thanks,
>

Okay, I will add these descriptions in the next release patchset.

Thanks.
Longfang.

> Alex
> 
>> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>> ---
>>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index d96446f499ed..cadc82419dca 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -1508,6 +1508,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>  
>> +	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>>  	hisi_acc_vdev->dev_opened = false;
>>  	iounmap(vf_qm->io_base);
> 
> 
> .
> 

