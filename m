Return-Path: <kvm+bounces-59086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F12BABB71
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 080651C19E6
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB22929AB05;
	Tue, 30 Sep 2025 07:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5hxzxqjp"
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DE922172D;
	Tue, 30 Sep 2025 07:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759215696; cv=none; b=B1qkHuFRenfMNyZZRQsneOSp8ETc6olPJdGKAJtDHFZjNCE6l7+nMmvyk+5pKso2dXlVecMBkAESYDWGAkuaotfFxL8dUTeglC2UwlEp1CM+GB2xp0mvsZwQIJdUv7qds7Fzso3jvqGGG7QjQa8aoDI7t2Y8pk/gPY7MtqlV8pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759215696; c=relaxed/simple;
	bh=v4TbixYXHomQ0MmXMylTe/NBDzyiStw4r194sAjCwHg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hkJE7+6rupaUoTeOQ+BoGoFBu3ymGtT42FVZWGjok6xPZrzUK1qGvBFUHlEc4LwxHVBDo/I26tuIOtBgq2x7c2ytKTQEwBFs53YGcqLoyPtoIzXNjkmoTC6MhlUO6Z2yIS2B7Vh2G95rW5d6L9gFjj66MlIZrC3q2lhSsTK0SLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5hxzxqjp; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from canpmsgout03.his.huawei.com (unknown [172.19.92.159])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cbTPX3F02zJsX7;
	Tue, 30 Sep 2025 14:56:48 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AEiUzXgRfeRRBN/awzdVLWjJkvQ1WmzGFz2MEA4n4OU=;
	b=5hxzxqjpHarqsL6027rmYOMZJXwiRNsFzikthqUK48vbHftPmgC5z3CHweJ2MZwKh80MzAC5W
	/Mn29wGk5fz2vwYeG9SWPorYNP//SZ7HkoO4nMOSgfW25Wabd1GITiBz9Xz3XN7SR+LPuXLqD03
	fmXqfNkIVoLZAtEXvFizfcc=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cbTVF2XgSzpStY;
	Tue, 30 Sep 2025 15:00:53 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FEBB180464;
	Tue, 30 Sep 2025 15:01:22 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Sep 2025 15:01:21 +0800
Subject: Re: [PATCH v9 2/2] hisi_acc_vfio_pci: adapt to new migration
 configuration
To: Shameer Kolothum <shameerkolothum@gmail.com>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250902022505.2034408-1-liulongfang@huawei.com>
 <20250902022505.2034408-3-liulongfang@huawei.com>
 <CAHy=t2_0X4_wqc+zm3Zk8aUPXmsOR57wiGmzR65PFHSa=gTrPA@mail.gmail.com>
 <bb9f8f5a-0cf0-98ef-d7b0-be132b8ce63f@huawei.com>
 <b9448065-f2ca-899d-e68a-c17e46546b40@huawei.com>
 <CAHy=t29buypWspUjZLHfFjnbixSENfo4we5Q5h_yrSKXJgc2QA@mail.gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <8f0af3b1-2cad-c80b-ef46-9f0eea2157d6@huawei.com>
Date: Tue, 30 Sep 2025 15:01:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAHy=t29buypWspUjZLHfFjnbixSENfo4we5Q5h_yrSKXJgc2QA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)


On 2025/9/18 15:06, Shameer Kolothum wrote:
> On Thu, 18 Sept 2025 at 02:29, liulongfang <liulongfang@huawei.com> wrote:
>>
>> On 2025/9/11 19:30, liulongfang wrote:
>>> On 2025/9/11 16:05, Shameer Kolothum wrote:
>>>> On Tue, 2 Sept 2025 at 03:26, Longfang Liu <liulongfang@huawei.com> wrote:
>>>>>
>>>>> On new platforms greater than QM_HW_V3, the migration region has been
>>>>> relocated from the VF to the PF. The VF's own configuration space is
>>>>> restored to the complete 64KB, and there is no need to divide the
>>>>> size of the BAR configuration space equally. The driver should be
>>>>> modified accordingly to adapt to the new hardware device.
>>>>>
>>>>> On the older hardware platform QM_HW_V3, the live migration configuration
>>>>> region is placed in the latter 32K portion of the VF's BAR2 configuration
>>>>> space. On the new hardware platform QM_HW_V4, the live migration
>>>>> configuration region also exists in the same 32K area immediately following
>>>>> the VF's BAR2, just like on QM_HW_V3.
>>>>>
>>>>> However, access to this region is now controlled by hardware. Additionally,
>>>>> a copy of the live migration configuration region is present in the PF's
>>>>> BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
>>>>> older version of the driver is loaded, it behaves like QM_HW_V3 and uses
>>>>> the configuration region in the VF, ensuring that the live migration
>>>>> function continues to work normally. When the new version of the driver is
>>>>> loaded, it directly uses the configuration region in the PF. Meanwhile,
>>>>> hardware configuration disables the live migration configuration region
>>>>> in the VF's BAR2: reads return all 0xF values, and writes are silently
>>>>> ignored.
>>>>>
>>>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>>>> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
>>>>> ---
>>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
>>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  13 ++
>>>>>  2 files changed, 157 insertions(+), 61 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>>> index 397f5e445136..fcf692a7bd4c 100644
>>>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>>> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
>>>>>         return 0;
>>>>>  }
>>>>>
>>>>> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>> +                          struct acc_vf_data *vf_data)
>>>>> +{
>>>>> +       struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>>>> +       struct device *dev = &qm->pdev->dev;
>>>>> +       u32 eqc_addr, aeqc_addr;
>>>>> +       int ret;
>>>>> +
>>>>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3) {
>>>>> +               eqc_addr = QM_EQC_DW0;
>>>>> +               aeqc_addr = QM_AEQC_DW0;
>>>>> +       } else {
>>>>> +               eqc_addr = QM_EQC_PF_DW0;
>>>>> +               aeqc_addr = QM_AEQC_PF_DW0;
>>>>> +       }
>>>>> +
>>>>> +       /* QM_EQC_DW has 7 regs */
>>>>> +       ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>>>> +       if (ret) {
>>>>> +               dev_err(dev, "failed to read QM_EQC_DW\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       /* QM_AEQC_DW has 7 regs */
>>>>> +       ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>>>> +       if (ret) {
>>>>> +               dev_err(dev, "failed to read QM_AEQC_DW\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>> +                          struct acc_vf_data *vf_data)
>>>>> +{
>>>>> +       struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>>>> +       struct device *dev = &qm->pdev->dev;
>>>>> +       u32 eqc_addr, aeqc_addr;
>>>>> +       int ret;
>>>>> +
>>>>> +       if (hisi_acc_vdev->drv_mode == HW_ACC_V3) {
>>>>> +               eqc_addr = QM_EQC_DW0;
>>>>> +               aeqc_addr = QM_AEQC_DW0;
>>>>> +       } else {
>>>>> +               eqc_addr = QM_EQC_PF_DW0;
>>>>> +               aeqc_addr = QM_AEQC_PF_DW0;
>>>>> +       }
>>>>> +
>>>>> +       /* QM_EQC_DW has 7 regs */
>>>>> +       ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>>>> +       if (ret) {
>>>>> +               dev_err(dev, "failed to write QM_EQC_DW\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       /* QM_AEQC_DW has 7 regs */
>>>>> +       ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>>>> +       if (ret) {
>>>>> +               dev_err(dev, "failed to write QM_AEQC_DW\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>>  {
>>>>>         struct device *dev = &qm->pdev->dev;
>>>>> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>>                 return ret;
>>>>>         }
>>>>>
>>>>> -       /* QM_EQC_DW has 7 regs */
>>>>> -       ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>>>> -       if (ret) {
>>>>> -               dev_err(dev, "failed to read QM_EQC_DW\n");
>>>>> -               return ret;
>>>>> -       }
>>>>> -
>>>>> -       /* QM_AEQC_DW has 7 regs */
>>>>> -       ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>>>> -       if (ret) {
>>>>> -               dev_err(dev, "failed to read QM_AEQC_DW\n");
>>>>> -               return ret;
>>>>> -       }
>>>>> -
>>>>>         return 0;
>>>>>  }
>>>>>
>>>>> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>>                 return ret;
>>>>>         }
>>>>>
>>>>> -       /* QM_EQC_DW has 7 regs */
>>>>> -       ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>>>> -       if (ret) {
>>>>> -               dev_err(dev, "failed to write QM_EQC_DW\n");
>>>>> -               return ret;
>>>>> -       }
>>>>> -
>>>>> -       /* QM_AEQC_DW has 7 regs */
>>>>> -       ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>>>> -       if (ret) {
>>>>> -               dev_err(dev, "failed to write QM_AEQC_DW\n");
>>>>> -               return ret;
>>>>> -       }
>>>>> -
>>>>>         return 0;
>>>>>  }
>>>>>
>>>>> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>>                 return ret;
>>>>>         }
>>>>>
>>>>> +       ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
>>>>> +       if (ret)
>>>>> +               return ret;
>>>>> +
>>>>>         ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>>>>>         if (ret) {
>>>>>                 dev_err(dev, "set sqc failed\n");
>>>>> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>>         vf_data->vf_qm_state = QM_READY;
>>>>>         hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>>>>
>>>>> +       ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
>>>>> +       if (ret)
>>>>> +               return ret;
>>>>> +
>>>>>         ret = vf_qm_read_data(vf_qm, vf_data);
>>>>>         if (ret)
>>>>>                 return ret;
>>>>> @@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>>>  {
>>>>>         struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>>>>>         struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>>>> +       struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>>>>>         struct pci_dev *vf_dev = vdev->pdev;
>>>>> +       u32 val;
>>>>>
>>>>> -       /*
>>>>> -        * ACC VF dev BAR2 region consists of both functional register space
>>>>> -        * and migration control register space. For migration to work, we
>>>>> -        * need access to both. Hence, we map the entire BAR2 region here.
>>>>> -        * But unnecessarily exposing the migration BAR region to the Guest
>>>>> -        * has the potential to prevent/corrupt the Guest migration. Hence,
>>>>> -        * we restrict access to the migration control space from
>>>>> -        * Guest(Please see mmap/ioctl/read/write override functions).
>>>>> -        *
>>>>> -        * Please note that it is OK to expose the entire VF BAR if migration
>>>>> -        * is not supported or required as this cannot affect the ACC PF
>>>>> -        * configurations.
>>>>> -        *
>>>>> -        * Also the HiSilicon ACC VF devices supported by this driver on
>>>>> -        * HiSilicon hardware platforms are integrated end point devices
>>>>> -        * and the platform lacks the capability to perform any PCIe P2P
>>>>> -        * between these devices.
>>>>> -        */
>>>>> +       val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
>>>>> +       if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
>>>>> +               hisi_acc_vdev->drv_mode = HW_ACC_V4;
>>>>> +       else
>>>>> +               hisi_acc_vdev->drv_mode = HW_ACC_V3;
>>>>
>>>> The check is for > QM_HW_V3 and drv_mode is set to HW_ACC_V4. From our
>>>> previous discussions I think the expectation is that future hardware will follow
>>>> this same behaviour. If that is the case, it is better to rename HW_ACC_  to
>>>> something more specific to this change than use the V3/V4 name.
>>>>
>>>
>>> If the goal is merely to reflect the context of this change, it would be better to add
>>> a comment describing this change directly at the variable's declaration.
>>>
>>
>> Hi, Shameer:
>> If there are no further issues, I will continue using the current naming convention and
>> add comments at the declaration sites.
> 
> I would still prefer naming it differently than just adding comments.
> Maybe something like
> below + comments in the header.
> 
> if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
>      hisi_acc_vdev->mig_ctrl_mode = HW_ACC_MIG_PF_CTRL;
> else
>     hisi_acc_vdev->mig_ctrl_mode = HW_ACC_MIG_VF_CTRL;
> 
> Also please don't respin just for this yet. Please wait for Alex to take a look.
>

Hi,Alex:
Could you please take a look at this review comment? What's your opinion on it?

Thanks.
Longfang.

> Thanks,
> Shameer
> .
> 

