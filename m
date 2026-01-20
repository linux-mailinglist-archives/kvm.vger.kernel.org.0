Return-Path: <kvm+bounces-68555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9DFD3C09D
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7FC60407E43
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3F13A7F46;
	Tue, 20 Jan 2026 07:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="DJwdHE2a"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A73A1E87;
	Tue, 20 Jan 2026 07:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768894345; cv=none; b=AsHIAn/Ai3O/9c6nOPRf6tU7rUlJWdXXA9lElxMDLfK/3wDiujOXHOrLi7f1MFNvN0Wch/tZssW5J7iN9EFyO+rOAsEDoKHZ0V/9p7TqzlYgoh1BDAEGe+IFlqLrl4RenMPwbRKr7ej7VeUAWmFAra6XJldg0tvnteay2WCygpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768894345; c=relaxed/simple;
	bh=xvnz0xiAZyBn+W5ySqvsfS0ZemiVjbbTRC1k3SEHW08=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JOAT1xrscBdBaPcQj/NvS6QjM1PsXyHBW0wqrFQdiHTQ4LW5MqIQ7ZsmA83BudDhlrOHArZAdYaPDUb5F1G031e5pqL4qrKdhd7Ip0vBDfb+tBCMiiF7a/dyHsCbViKBRDly4YepMd+AtOFiA1kquqaPQmq47b+X4+bvqNgCzi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=DJwdHE2a; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LU7vj2FUQEwhYjwdT1gNWnRF9o4364+nbzv3hc0zWoc=;
	b=DJwdHE2aYEYHDTqcHV4EbfhnW4Cb8td7dOAb1HEwGU2wxc0G1NFbQ+67MNX/3PEuSFUOEB36M
	ZLTW/ghmYifTt1+C/uGeGk6JPozxN+26nu+vrIcG5opdDwdiYwNYnMyqcH6zR7kyl15twk7lPYD
	pOu29xVINOKPJsLU499Cv7Y=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dwJp63rfWz12LFx;
	Tue, 20 Jan 2026 15:28:14 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 84F5A40567;
	Tue, 20 Jan 2026 15:32:13 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 15:32:12 +0800
Subject: Re: [PATCH 1/4] hisi_acc_vfio_pci: fix VF reset timeout issue
To: Alex Williamson <alex@shazbot.org>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20260104070706.4107994-1-liulongfang@huawei.com>
 <20260104070706.4107994-2-liulongfang@huawei.com>
 <20260116094758.09fc60d8@shazbot.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <93a4e11e-7623-4c3d-673a-d4273b99bc61@huawei.com>
Date: Tue, 20 Jan 2026 15:32:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260116094758.09fc60d8@shazbot.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/1/17 0:47, Alex Williamson wrote:
> On Sun, 4 Jan 2026 15:07:03 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> From: Weili Qian <qianweili@huawei.com>
>>
>> If device error occurs during live migration, qemu will
>> reset the VF. At this time, VF reset and device reset are performed
>> simultaneously. The VF reset will timeout. Therefore, the QM_RESETTING
>> flag is used to ensure that VF reset and device reset are performed
>> serially.
>>
>> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
>> Signed-off-by: Weili Qian <qianweili@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 24 +++++++++++++++++++
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 ++
>>  2 files changed, 26 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> index fe2ffcd00d6e..d55365b21f78 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> @@ -1188,14 +1188,37 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>>  	return 0;
>>  }
>>  
>> +static void hisi_acc_vf_pci_reset_prepare(struct pci_dev *pdev)
>> +{
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>> +	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
>> +	struct device *dev = &qm->pdev->dev;
>> +	u32 delay = 0;
>> +
>> +	/* All reset requests need to be queued for processing */
>> +	while (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
>> +		msleep(1);
>> +		if (++delay > QM_RESET_WAIT_TIMEOUT) {
>> +			dev_err(dev, "reset prepare failed\n");
>> +			return;
>> +		}
>> +	}
>> +
>> +	hisi_acc_vdev->set_reset_flag = true;
>> +}
>> +
>>  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>>  {
>>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>> +	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
>>  
>>  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
>>  				VFIO_MIGRATION_STOP_COPY)
>>  		return;
>>  
>> +	if (hisi_acc_vdev->set_reset_flag)
>> +		clear_bit(QM_RESETTING, &qm->misc_ctl);
> 
> 
> .reset_prepare sets QM_RESETTING unconditionally, .reset_done clears
> QM_RESETTING conditionally based on the migration state.  In 2/ this
> becomes conditional on the device supporting migration ops.  Doesn't
> this enable a scenario where a device that does not support migration
> puts QM_RESETTING into an inconsistent state that is never cleared?
> Should the clear_bit() occur before the migration state/capability
> check?
>

Yes,  it makes more sense to move clear_bit() before the migration state
or capability check.

Thanks,
Longfang.

> Thanks,
> Alex
> 
>> +
>>  	mutex_lock(&hisi_acc_vdev->state_mutex);
>>  	hisi_acc_vf_reset(hisi_acc_vdev);
>>  	mutex_unlock(&hisi_acc_vdev->state_mutex);
>> @@ -1746,6 +1769,7 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
>>  MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
>>  
>>  static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
>> +	.reset_prepare = hisi_acc_vf_pci_reset_prepare,
>>  	.reset_done = hisi_acc_vf_pci_aer_reset_done,
>>  	.error_detected = vfio_pci_core_aer_err_detected,
>>  };
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> index cd55eba64dfb..a3d91a31e3d8 100644
>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>> @@ -27,6 +27,7 @@
>>  
>>  #define ERROR_CHECK_TIMEOUT		100
>>  #define CHECK_DELAY_TIME		100
>> +#define QM_RESET_WAIT_TIMEOUT  60000
>>  
>>  #define QM_SQC_VFT_BASE_SHIFT_V2	28
>>  #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
>> @@ -128,6 +129,7 @@ struct hisi_acc_vf_migration_file {
>>  struct hisi_acc_vf_core_device {
>>  	struct vfio_pci_core_device core_device;
>>  	u8 match_done;
>> +	bool set_reset_flag;
>>  	/*
>>  	 * io_base is only valid when dev_opened is true,
>>  	 * which is protected by open_mutex.
> 
> .
> 

