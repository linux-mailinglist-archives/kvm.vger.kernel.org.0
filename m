Return-Path: <kvm+bounces-56386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B2EB3C9A5
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 11:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33C4E1C23ED9
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 09:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2356A257852;
	Sat, 30 Aug 2025 09:08:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE21BA4A;
	Sat, 30 Aug 2025 09:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756544902; cv=none; b=kTfUgjZ8VRULXIbfPlg2DcEIhi72P5N9fJlzXq6N3cOkkj2FDptPyphRWJdPaxttsXXhJvuv7+GX01FbpNVvdhWYx8D2SxE2DCKyZ8d2jM3PYjBLcSSquLEM8ogJOELKlFyw7HiWvmf2SK2xJPcGtQ3IF9w2Y7GG+JHmk67PHQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756544902; c=relaxed/simple;
	bh=Qz3ggoWbUKgrrXQcEKd/1O4/cEafzJQJ7chzmDYc/hU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kT67b/+PcUzECPiBq6KSe8K8ZROptO0TjYISd9cYnmRBz1WWCnUFkV7JCX+1DA1GV9kI4pgvvBj22tVyqgD2akLR1x4e3p782pg5R/1gxnT/P0MWnCURvvVVXl+EjupYXCjv+mzvnxmXC2ODAv5HIvDo/FlcJx0x73yR0sQrru4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cDTpf20tlz27jCl;
	Sat, 30 Aug 2025 17:09:14 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 22B041401F2;
	Sat, 30 Aug 2025 17:08:07 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 17:08:06 +0800
Subject: Re: [PATCH v8 3/3] hisi_acc_vfio_pci: adapt to new migration
 configuration
To: Shameer Kolothum <shameerkolothum@gmail.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250820072435.2854502-1-liulongfang@huawei.com>
 <20250820072435.2854502-4-liulongfang@huawei.com>
 <20250821120112.3e9599a4.alex.williamson@redhat.com>
 <f3617d78-e75e-378b-ad0f-4aa6c8ed61b9@huawei.com>
 <723cd569-b194-4876-9aea-d0bdd6861810@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <fd66f465-2f6e-8e4d-e010-7584ba43cdf7@huawei.com>
Date: Sat, 30 Aug 2025 17:08:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <723cd569-b194-4876-9aea-d0bdd6861810@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/22 15:03, Shameer Kolothum wrote:
> On 22/08/2025 03:44, liulongfang wrote:
>> On 2025/8/22 2:01, Alex Williamson wrote:
>>> On Wed, 20 Aug 2025 15:24:35 +0800
>>> Longfang Liu <liulongfang@huawei.com> wrote:
>>>
>>>> On new platforms greater than QM_HW_V3, the migration region has been
>>>> relocated from the VF to the PF. The driver must also be modified
>>>> accordingly to adapt to the new hardware device.
>>>>
>>>> On the older hardware platform QM_HW_V3, the live migration configuration
>>>> region is placed in the latter 32K portion of the VF's BAR2 configuration
>>>> space. On the new hardware platform QM_HW_V4, the live migration
>>>> configuration region also exists in the same 32K area immediately following
>>>> the VF's BAR2, just like on QM_HW_V3.
>>>>
>>>> However, access to this region is now controlled by hardware. Additionally,
>>>> a copy of the live migration configuration region is present in the PF's
>>>> BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
>>>> older version of the driver is loaded, it behaves like QM_HW_V3 and uses
>>>> the configuration region in the VF, ensuring that the live migration
>>>> function continues to work normally. When the new version of the driver is
>>>> loaded, it directly uses the configuration region in the PF. Meanwhile,
>>>> hardware configuration disables the live migration configuration region
>>>> in the VF's BAR2: reads return all 0xF values, and writes are silently
>>>> ignored.
>>>>
>>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>>> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
>>>> ---
>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 169 ++++++++++++------
>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  13 ++
>>>>  2 files changed, 130 insertions(+), 52 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>> index ddb3fd4df5aa..09893d143a68 100644
>>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>>> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>> +			   struct acc_vf_data *vf_data)
>>>> +{
>>>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>>> +	struct device *dev = &qm->pdev->dev;
>>>> +	u32 eqc_addr, aeqc_addr;
>>>> +	int ret;
>>>> +
>>>> +	if (hisi_acc_vdev->drv_mode == HW_V3_COMPAT) {
>>>> +		eqc_addr = QM_EQC_DW0;
>>>> +		aeqc_addr = QM_AEQC_DW0;
>>>> +	} else {
>>>> +		eqc_addr = QM_EQC_PF_DW0;
>>>> +		aeqc_addr = QM_AEQC_PF_DW0;
>>>> +	}
>>>> +
>>>> +	/* QM_EQC_DW has 7 regs */
>>>> +	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to read QM_EQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	/* QM_AEQC_DW has 7 regs */
>>>> +	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to read QM_AEQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>> +			   struct acc_vf_data *vf_data)
>>>> +{
>>>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>>> +	struct device *dev = &qm->pdev->dev;
>>>> +	u32 eqc_addr, aeqc_addr;
>>>> +	int ret;
>>>> +
>>>> +	if (hisi_acc_vdev->drv_mode == HW_V3_COMPAT) {
>>>> +		eqc_addr = QM_EQC_DW0;
>>>> +		aeqc_addr = QM_AEQC_DW0;
>>>> +	} else {
>>>> +		eqc_addr = QM_EQC_PF_DW0;
>>>> +		aeqc_addr = QM_AEQC_PF_DW0;
>>>> +	}
>>>> +
>>>> +	/* QM_EQC_DW has 7 regs */
>>>> +	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to write QM_EQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	/* QM_AEQC_DW has 7 regs */
>>>> +	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>>> +	if (ret) {
>>>> +		dev_err(dev, "failed to write QM_AEQC_DW\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>  {
>>>>  	struct device *dev = &qm->pdev->dev;
>>>> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>  		return ret;
>>>>  	}
>>>>  
>>>> -	/* QM_EQC_DW has 7 regs */
>>>> -	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to read QM_EQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>> -	/* QM_AEQC_DW has 7 regs */
>>>> -	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to read QM_AEQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>>  		return ret;
>>>>  	}
>>>>  
>>>> -	/* QM_EQC_DW has 7 regs */
>>>> -	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to write QM_EQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>> -	/* QM_AEQC_DW has 7 regs */
>>>> -	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>>> -	if (ret) {
>>>> -		dev_err(dev, "failed to write QM_AEQC_DW\n");
>>>> -		return ret;
>>>> -	}
>>>> -
>>>>  	return 0;
>>>>  }
>>>>  
>>>> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>  		return ret;
>>>>  	}
>>>>  
>>>> +	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>>  	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>>>>  	if (ret) {
>>>>  		dev_err(dev, "set sqc failed\n");
>>>> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>>  	vf_data->vf_qm_state = QM_READY;
>>>>  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>>>  
>>>> +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>>  	ret = vf_qm_read_data(vf_qm, vf_data);
>>>>  	if (ret)
>>>>  		return ret;
>>>> @@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>>  {
>>>>  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>>>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>>> +	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>>>>  	struct pci_dev *vf_dev = vdev->pdev;
>>>> +	u32 val;
>>>>  
>>>> -	/*
>>>> -	 * ACC VF dev BAR2 region consists of both functional register space
>>>> -	 * and migration control register space. For migration to work, we
>>>> -	 * need access to both. Hence, we map the entire BAR2 region here.
>>>> -	 * But unnecessarily exposing the migration BAR region to the Guest
>>>> -	 * has the potential to prevent/corrupt the Guest migration. Hence,
>>>> -	 * we restrict access to the migration control space from
>>>> -	 * Guest(Please see mmap/ioctl/read/write override functions).
>>>> -	 *
>>>> -	 * Please note that it is OK to expose the entire VF BAR if migration
>>>> -	 * is not supported or required as this cannot affect the ACC PF
>>>> -	 * configurations.
>>>> -	 *
>>>> -	 * Also the HiSilicon ACC VF devices supported by this driver on
>>>> -	 * HiSilicon hardware platforms are integrated end point devices
>>>> -	 * and the platform lacks the capability to perform any PCIe P2P
>>>> -	 * between these devices.
>>>> -	 */
>>>> +	val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
>>>> +	if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
>>>> +		hisi_acc_vdev->drv_mode = HW_V4_NEW;
>>>> +	else
>>>> +		hisi_acc_vdev->drv_mode = HW_V3_COMPAT;
>>>>  
>>>> -	vf_qm->io_base =
>>>> -		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>>> -			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>>> -	if (!vf_qm->io_base)
>>>> -		return -EIO;
>>>> +	if (hisi_acc_vdev->drv_mode == HW_V4_NEW) {
>>>> +		/*
>>>> +		 * On hardware platforms greater than QM_HW_V3, the migration function
>>>> +		 * register is placed in the BAR2 configuration region of the PF,
>>>> +		 * and each VF device occupies 8KB of configuration space.
>>>> +		 */
>>>> +		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
>>>> +				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
>>>> +	} else {
>>>> +		/*
>>>> +		 * ACC VF dev BAR2 region consists of both functional register space
>>>> +		 * and migration control register space. For migration to work, we
>>>> +		 * need access to both. Hence, we map the entire BAR2 region here.
>>>> +		 * But unnecessarily exposing the migration BAR region to the Guest
>>>> +		 * has the potential to prevent/corrupt the Guest migration. Hence,
>>>> +		 * we restrict access to the migration control space from
>>>> +		 * Guest(Please see mmap/ioctl/read/write override functions).
>>>> +		 *
>>>> +		 * Please note that it is OK to expose the entire VF BAR if migration
>>>> +		 * is not supported or required as this cannot affect the ACC PF
>>>> +		 * configurations.
>>>> +		 *
>>>> +		 * Also the HiSilicon ACC VF devices supported by this driver on
>>>> +		 * HiSilicon hardware platforms are integrated end point devices
>>>> +		 * and the platform lacks the capability to perform any PCIe P2P
>>>> +		 * between these devices.
>>>> +		 */
>>>>  
>>>> +		vf_qm->io_base =
>>>> +			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>>> +				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>>> +		if (!vf_qm->io_base)
>>>> +			return -EIO;
>>>> +	}
>>>>  	vf_qm->fun_type = QM_HW_VF;
>>>> +	vf_qm->ver = pf_qm->ver;
>>>>  	vf_qm->pdev = vf_dev;
>>>>  	mutex_init(&vf_qm->mailbox_lock);
>>>>  
>>>> @@ -1539,7 +1603,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>>>  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>>>>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>>>>  	hisi_acc_vdev->dev_opened = false;
>>>> -	iounmap(vf_qm->io_base);
>>>> +	if (hisi_acc_vdev->drv_mode == HW_V3_COMPAT)
>>>> +		iounmap(vf_qm->io_base);
>>>>  	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>>>  	vfio_pci_core_close_device(core_vdev);
>>>>  }
>>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>> index 91002ceeebc1..e7650f5ff0f7 100644
>>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>> @@ -59,6 +59,18 @@
>>>>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>>>>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>>>>  
>>>> +#define QM_MIG_REGION_OFFSET		0x180000
>>>> +#define QM_MIG_REGION_SIZE		0x2000
>>>> +
>>>> +#define QM_SUB_VERSION_ID		0x100210
>>>> +#define QM_EQC_PF_DW0			0x1c00
>>>> +#define QM_AEQC_PF_DW0			0x1c20
>>>> +
>>>> +enum hw_drv_mode {
>>>> +	HW_V3_COMPAT = 0,
>>>> +	HW_V4_NEW,
>>>> +};
>>>
>>> You might consider whether these names are going to make sense in the
>>> future if there a V5 and beyond, and why V3 hardware is going to use a
>>> "compat" name when that's it's native operating mode.
>>>
>>
>> If future versions such as V5 or higher emerge, we can still handle them by
>> simply updating the version number.
>> The use of "compat" naming is intended to ensure that newer hardware versions
>> remain compatible with older drivers.
>> For simplicity, we could alternatively rename them directly to HW_ACC_V3, HW_ACC_V4,
>> HW_ACC_V5, etc.
>>
>>> But also, patch 1/ is deciding whether to expose the full BAR based on
>>> the hardware version and here we choose whether to use the VF or PF
>>> control registers based on the hardware version and whether the new
>>> hardware feature is enabled.  Doesn't that leave V4 hardware exposing
>>> the full BAR regardless of whether the PF driver has disabled the
>>> migration registers within the BAR?  Thanks,
>>>
>>
>> Regarding V4 hardware: the migration registers within the PF's BAR are
>> accessible only by the host driver, just like other registers in the BAR.
>> When the VF's live migration configuration registers are enabled, the driver
>> can see the full BAR configuration space of the PF.However, at this point,
>> the PF's live migration configuration registers become read/write ineffective.
>> In other words, on V4 hardware, the VF's configuration domain and the PF's
>> configuration domain are mutually exclusive—only one of them is ever read/write
>> valid at any given time.
> 
> Sorry it is still not clear to me. My understanding was on V4 hardware,
> the VF's live migration config register will be inactive only when you
> set the PF's QM_MIG_REGION_SEL to QM_MIG_REGION_EN.
> 
> So, I think the question is whether you need to check the PF's
> QM_MIG_REGION_SEL has set to  QM_MIG_REGION_EN, in patch 1 before
> exposing the full VF BAR region or not. If yes, you need to reorganise
> the patch 1. Currently patch 1 only checks the hardware version to
> decide that.
>

You're absolutely right. Patch 1 should check its status using drv_mode,
just as done here, instead of relying on pf_qm->ver to determine its mode

Thanks.
Longfang.

> 
> Thanks,
> Shameer
> 
>> Thanks.
>> Longfang.
>>
>>> Alex
>>>
>>>> +
>>>>  struct acc_vf_data {
>>>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>>>  	/* QM match information */
>>>> @@ -125,6 +137,7 @@ struct hisi_acc_vf_core_device {
>>>>  	struct pci_dev *vf_dev;
>>>>  	struct hisi_qm *pf_qm;
>>>>  	struct hisi_qm vf_qm;
>>>> +	int drv_mode;
>>>>  	/*
>>>>  	 * vf_qm_state represents the QM_VF_STATE register value.
>>>>  	 * It is set by Guest driver for the ACC VF dev indicating
>>>
>>>
>>> .
>>>
> 
> .
> 

