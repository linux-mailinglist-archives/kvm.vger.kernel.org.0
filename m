Return-Path: <kvm+bounces-55479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635AAB30FD9
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77A583BFDE0
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5142E3387;
	Fri, 22 Aug 2025 07:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHLXvmza"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF262236FD;
	Fri, 22 Aug 2025 07:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755846224; cv=none; b=gavRgyYcWJ5KN97MlMtfo69SxO3Nu1152xGIUq6i3OsJ0De7LxK6aZ6PQqGtTPXmk83YNVdTWOf1a6d7mSk7NpcosLV8rC+HWQFQige9e3kKeIfV6UHC7s6jWm51ZWoudhUjZallgW/W27rPbZmf9ptyElh0n37QosvECtgATDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755846224; c=relaxed/simple;
	bh=I7u3TWd+L4CBV9TosTMFziWydfwf9fqA/oBzR41luvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQg7WM7Pd6GcycwL20In5v2up/W5BIicGSWCgdQOqjli5/tQZ4Z72lzi9GfGgnmKMdr/1hJStaJy3TYa1Rk5vphvOnW6YH8ffohI710bg8sI48oiCkHgZrvHob5vsG+gd7zWyoAUzikxIHQs/7Ok3Ucs8K1PGHmggUyutqmyqbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHLXvmza; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c5e043c85bso192228f8f.1;
        Fri, 22 Aug 2025 00:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755846221; x=1756451021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6lm78bqENJSIgaA3raQ/Zxyiw2zd1AV2h04MLDFhhlk=;
        b=jHLXvmzameYeECEdyPoTjFP8aDt3avykouINAyGZfDuvlk+PeOVXKngfgU7nKEagPB
         ZBrKkBn8A75MwUum7XRVULfN0Fdbrk66hhxhIaijLRXCOHTJNdP9hsyDlAeRoDyq60yW
         Et9XrDV49aVe7AapPWFdjVGaIrcRZ/5LW1r4w/X+i8PyvPaeRR+aNAuOPefGvng+yV/A
         laz6GhyZnP445WThoMk6ZvXNGUYk573mKFR0qzWJGK2HQx4GkLR45orVxl92Oqzh2VOW
         rp8BIvGUSNfm2L4lyGj8N+kMUjHB+inEEp1A+JB9iXzPcy6eoTGnQNSVqwwFAVNVWbmT
         2mYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755846221; x=1756451021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6lm78bqENJSIgaA3raQ/Zxyiw2zd1AV2h04MLDFhhlk=;
        b=fxl3KRuTWsGyeejmwu4HKG7KqgAoodwHgildZik8IXQt7Q7kYUXhBnBxIRKfkqHU3A
         PyhU0ZyBelMC5XXelq4Ioa+0SFKwqnKhPrD61wHYol7NhUM7t++P3NP6V2/pOMUdTNLO
         r7BwwavBGXq7MHVp9eevPnUqAJf2vkrmj7PQCqlGF+X6M0weJtfv0qtBVOrlUjI0nEMc
         X+Kpy77bw2ii4yGuinC/jtD0h0K4TY0bsnUc5HFbERJxVpwNjl2nm75dt/i0qwDBkhoE
         diKcw5xw/UbLI1lCAA5EPi5spPx1ZjNJ9QvJ0RRwsoAhuCGqXmj8+ae1dP5mX7Ryn0To
         GIdg==
X-Forwarded-Encrypted: i=1; AJvYcCUPCj86yMNms3Ud7nM4PPe0eCvQmkfdxXa/YVdja1Y6ZwW7BVLrXhnf8G/BTnT13iTAQ14tuyga1H51Ge0D@vger.kernel.org, AJvYcCVhe2onwC/LMFo0dud4Zb9D4D/adVjQAoHWWIS2Ap54l8dq1EXVoOpbI4JxBoJ/rdAQAR4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy0zAT6a2LIj1ITKxfzZWsjZE0dXjB25ACAkmmfgE235ZYQCr6
	L63h4uXIoDhQ7kicQF+XBqGjYpkgL8CAd5HgstBvPsEfwB3VsKRWL0uK
X-Gm-Gg: ASbGnctaF6rIpqAXetMgxgVPou1yvxsdFr1CKhZJ0207RNfCYOi9DAs+ilwqmqBLXoR
	B57Re7708czNUwWtMVsIsUV32Jll2JdGpSwUypstwMQ3qG6Seo5GW4y0ss9T8qIo57GlRnzELNn
	5HCi/GHqCTDIFF8ORtRDh34KT2zS1mZwyZ7UynqGTV930L0JxuOPwxl5Q9FgIXmNwlTpHKJOhIm
	pz/E6TciZJkqwj0t7nasUIWvvPcUC6aAg+Sr0R6TgRY4UyIC5rIE9qMefRzmedHcjeBwvu74Op+
	kqmb22F23ELnFTaYr7+0+hIIfVDUZBTHLzzYB/J98ZXx4M3q8iTgMqzEQ8XGRIYd43xU/PN6X0B
	U6CF//fMcHkw5lctXqS9u6BVtMjOyvmSQGPVOaKnP/Bb62Wz++Qwbc8y6kIFYe9YnFJmGCF+nxv
	49khS2HIOu8iuHzi+aG5I+sfAkeIki3bKl
X-Google-Smtp-Source: AGHT+IF3Rz6EHeS/oXp3MalHMbTmrq3mcuDEk/0K1QjUtW0ZCZviaqhZ7oEa4EzoojHE9cpL3KxwYg==
X-Received: by 2002:a05:6000:2c09:b0:3c4:516:bf62 with SMTP id ffacd0b85a97d-3c4ae74f40dmr3994765f8f.6.1755846220591;
        Fri, 22 Aug 2025 00:03:40 -0700 (PDT)
Received: from [192.168.7.75] (cmbg-19-b2-v4wan-170160-cust1492.vm17.cable.virginm.net. [94.175.85.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dc4c55sm25424165e9.4.2025.08.22.00.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 00:03:40 -0700 (PDT)
Message-ID: <723cd569-b194-4876-9aea-d0bdd6861810@gmail.com>
Date: Fri, 22 Aug 2025 08:03:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/3] hisi_acc_vfio_pci: adapt to new migration
 configuration
To: liulongfang <liulongfang@huawei.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: jgg@nvidia.com, jonathan.cameron@huawei.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxarm@openeuler.org
References: <20250820072435.2854502-1-liulongfang@huawei.com>
 <20250820072435.2854502-4-liulongfang@huawei.com>
 <20250821120112.3e9599a4.alex.williamson@redhat.com>
 <f3617d78-e75e-378b-ad0f-4aa6c8ed61b9@huawei.com>
Content-Language: en-US
From: Shameer Kolothum <shameerkolothum@gmail.com>
In-Reply-To: <f3617d78-e75e-378b-ad0f-4aa6c8ed61b9@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 22/08/2025 03:44, liulongfang wrote:
> On 2025/8/22 2:01, Alex Williamson wrote:
>> On Wed, 20 Aug 2025 15:24:35 +0800
>> Longfang Liu <liulongfang@huawei.com> wrote:
>>
>>> On new platforms greater than QM_HW_V3, the migration region has been
>>> relocated from the VF to the PF. The driver must also be modified
>>> accordingly to adapt to the new hardware device.
>>>
>>> On the older hardware platform QM_HW_V3, the live migration configuration
>>> region is placed in the latter 32K portion of the VF's BAR2 configuration
>>> space. On the new hardware platform QM_HW_V4, the live migration
>>> configuration region also exists in the same 32K area immediately following
>>> the VF's BAR2, just like on QM_HW_V3.
>>>
>>> However, access to this region is now controlled by hardware. Additionally,
>>> a copy of the live migration configuration region is present in the PF's
>>> BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
>>> older version of the driver is loaded, it behaves like QM_HW_V3 and uses
>>> the configuration region in the VF, ensuring that the live migration
>>> function continues to work normally. When the new version of the driver is
>>> loaded, it directly uses the configuration region in the PF. Meanwhile,
>>> hardware configuration disables the live migration configuration region
>>> in the VF's BAR2: reads return all 0xF values, and writes are silently
>>> ignored.
>>>
>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>> Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
>>> ---
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 169 ++++++++++++------
>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  13 ++
>>>  2 files changed, 130 insertions(+), 52 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> index ddb3fd4df5aa..09893d143a68 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>>> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
>>>  	return 0;
>>>  }
>>>  
>>> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>> +			   struct acc_vf_data *vf_data)
>>> +{
>>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>> +	struct device *dev = &qm->pdev->dev;
>>> +	u32 eqc_addr, aeqc_addr;
>>> +	int ret;
>>> +
>>> +	if (hisi_acc_vdev->drv_mode == HW_V3_COMPAT) {
>>> +		eqc_addr = QM_EQC_DW0;
>>> +		aeqc_addr = QM_AEQC_DW0;
>>> +	} else {
>>> +		eqc_addr = QM_EQC_PF_DW0;
>>> +		aeqc_addr = QM_AEQC_PF_DW0;
>>> +	}
>>> +
>>> +	/* QM_EQC_DW has 7 regs */
>>> +	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>> +	if (ret) {
>>> +		dev_err(dev, "failed to read QM_EQC_DW\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	/* QM_AEQC_DW has 7 regs */
>>> +	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>> +	if (ret) {
>>> +		dev_err(dev, "failed to read QM_AEQC_DW\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>> +			   struct acc_vf_data *vf_data)
>>> +{
>>> +	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
>>> +	struct device *dev = &qm->pdev->dev;
>>> +	u32 eqc_addr, aeqc_addr;
>>> +	int ret;
>>> +
>>> +	if (hisi_acc_vdev->drv_mode == HW_V3_COMPAT) {
>>> +		eqc_addr = QM_EQC_DW0;
>>> +		aeqc_addr = QM_AEQC_DW0;
>>> +	} else {
>>> +		eqc_addr = QM_EQC_PF_DW0;
>>> +		aeqc_addr = QM_AEQC_PF_DW0;
>>> +	}
>>> +
>>> +	/* QM_EQC_DW has 7 regs */
>>> +	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
>>> +	if (ret) {
>>> +		dev_err(dev, "failed to write QM_EQC_DW\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	/* QM_AEQC_DW has 7 regs */
>>> +	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
>>> +	if (ret) {
>>> +		dev_err(dev, "failed to write QM_AEQC_DW\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>  {
>>>  	struct device *dev = &qm->pdev->dev;
>>> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>  		return ret;
>>>  	}
>>>  
>>> -	/* QM_EQC_DW has 7 regs */
>>> -	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>> -	if (ret) {
>>> -		dev_err(dev, "failed to read QM_EQC_DW\n");
>>> -		return ret;
>>> -	}
>>> -
>>> -	/* QM_AEQC_DW has 7 regs */
>>> -	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>> -	if (ret) {
>>> -		dev_err(dev, "failed to read QM_AEQC_DW\n");
>>> -		return ret;
>>> -	}
>>> -
>>>  	return 0;
>>>  }
>>>  
>>> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>>>  		return ret;
>>>  	}
>>>  
>>> -	/* QM_EQC_DW has 7 regs */
>>> -	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
>>> -	if (ret) {
>>> -		dev_err(dev, "failed to write QM_EQC_DW\n");
>>> -		return ret;
>>> -	}
>>> -
>>> -	/* QM_AEQC_DW has 7 regs */
>>> -	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
>>> -	if (ret) {
>>> -		dev_err(dev, "failed to write QM_AEQC_DW\n");
>>> -		return ret;
>>> -	}
>>> -
>>>  	return 0;
>>>  }
>>>  
>>> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>  		return ret;
>>>  	}
>>>  
>>> +	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>  	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>>>  	if (ret) {
>>>  		dev_err(dev, "set sqc failed\n");
>>> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>>>  	vf_data->vf_qm_state = QM_READY;
>>>  	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
>>>  
>>> +	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>  	ret = vf_qm_read_data(vf_qm, vf_data);
>>>  	if (ret)
>>>  		return ret;
>>> @@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>>>  {
>>>  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>>>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>>> +	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>>>  	struct pci_dev *vf_dev = vdev->pdev;
>>> +	u32 val;
>>>  
>>> -	/*
>>> -	 * ACC VF dev BAR2 region consists of both functional register space
>>> -	 * and migration control register space. For migration to work, we
>>> -	 * need access to both. Hence, we map the entire BAR2 region here.
>>> -	 * But unnecessarily exposing the migration BAR region to the Guest
>>> -	 * has the potential to prevent/corrupt the Guest migration. Hence,
>>> -	 * we restrict access to the migration control space from
>>> -	 * Guest(Please see mmap/ioctl/read/write override functions).
>>> -	 *
>>> -	 * Please note that it is OK to expose the entire VF BAR if migration
>>> -	 * is not supported or required as this cannot affect the ACC PF
>>> -	 * configurations.
>>> -	 *
>>> -	 * Also the HiSilicon ACC VF devices supported by this driver on
>>> -	 * HiSilicon hardware platforms are integrated end point devices
>>> -	 * and the platform lacks the capability to perform any PCIe P2P
>>> -	 * between these devices.
>>> -	 */
>>> +	val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
>>> +	if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
>>> +		hisi_acc_vdev->drv_mode = HW_V4_NEW;
>>> +	else
>>> +		hisi_acc_vdev->drv_mode = HW_V3_COMPAT;
>>>  
>>> -	vf_qm->io_base =
>>> -		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>> -			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>> -	if (!vf_qm->io_base)
>>> -		return -EIO;
>>> +	if (hisi_acc_vdev->drv_mode == HW_V4_NEW) {
>>> +		/*
>>> +		 * On hardware platforms greater than QM_HW_V3, the migration function
>>> +		 * register is placed in the BAR2 configuration region of the PF,
>>> +		 * and each VF device occupies 8KB of configuration space.
>>> +		 */
>>> +		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
>>> +				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
>>> +	} else {
>>> +		/*
>>> +		 * ACC VF dev BAR2 region consists of both functional register space
>>> +		 * and migration control register space. For migration to work, we
>>> +		 * need access to both. Hence, we map the entire BAR2 region here.
>>> +		 * But unnecessarily exposing the migration BAR region to the Guest
>>> +		 * has the potential to prevent/corrupt the Guest migration. Hence,
>>> +		 * we restrict access to the migration control space from
>>> +		 * Guest(Please see mmap/ioctl/read/write override functions).
>>> +		 *
>>> +		 * Please note that it is OK to expose the entire VF BAR if migration
>>> +		 * is not supported or required as this cannot affect the ACC PF
>>> +		 * configurations.
>>> +		 *
>>> +		 * Also the HiSilicon ACC VF devices supported by this driver on
>>> +		 * HiSilicon hardware platforms are integrated end point devices
>>> +		 * and the platform lacks the capability to perform any PCIe P2P
>>> +		 * between these devices.
>>> +		 */
>>>  
>>> +		vf_qm->io_base =
>>> +			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
>>> +				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
>>> +		if (!vf_qm->io_base)
>>> +			return -EIO;
>>> +	}
>>>  	vf_qm->fun_type = QM_HW_VF;
>>> +	vf_qm->ver = pf_qm->ver;
>>>  	vf_qm->pdev = vf_dev;
>>>  	mutex_init(&vf_qm->mailbox_lock);
>>>  
>>> @@ -1539,7 +1603,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>>>  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>>>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>>>  	hisi_acc_vdev->dev_opened = false;
>>> -	iounmap(vf_qm->io_base);
>>> +	if (hisi_acc_vdev->drv_mode == HW_V3_COMPAT)
>>> +		iounmap(vf_qm->io_base);
>>>  	mutex_unlock(&hisi_acc_vdev->open_mutex);
>>>  	vfio_pci_core_close_device(core_vdev);
>>>  }
>>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> index 91002ceeebc1..e7650f5ff0f7 100644
>>> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>> @@ -59,6 +59,18 @@
>>>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>>>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>>>  
>>> +#define QM_MIG_REGION_OFFSET		0x180000
>>> +#define QM_MIG_REGION_SIZE		0x2000
>>> +
>>> +#define QM_SUB_VERSION_ID		0x100210
>>> +#define QM_EQC_PF_DW0			0x1c00
>>> +#define QM_AEQC_PF_DW0			0x1c20
>>> +
>>> +enum hw_drv_mode {
>>> +	HW_V3_COMPAT = 0,
>>> +	HW_V4_NEW,
>>> +};
>>
>> You might consider whether these names are going to make sense in the
>> future if there a V5 and beyond, and why V3 hardware is going to use a
>> "compat" name when that's it's native operating mode.
>>
> 
> If future versions such as V5 or higher emerge, we can still handle them by
> simply updating the version number.
> The use of "compat" naming is intended to ensure that newer hardware versions
> remain compatible with older drivers.
> For simplicity, we could alternatively rename them directly to HW_ACC_V3, HW_ACC_V4,
> HW_ACC_V5, etc.
> 
>> But also, patch 1/ is deciding whether to expose the full BAR based on
>> the hardware version and here we choose whether to use the VF or PF
>> control registers based on the hardware version and whether the new
>> hardware feature is enabled.  Doesn't that leave V4 hardware exposing
>> the full BAR regardless of whether the PF driver has disabled the
>> migration registers within the BAR?  Thanks,
>>
> 
> Regarding V4 hardware: the migration registers within the PF's BAR are
> accessible only by the host driver, just like other registers in the BAR.
> When the VF's live migration configuration registers are enabled, the driver
> can see the full BAR configuration space of the PF.However, at this point,
> the PF's live migration configuration registers become read/write ineffective.
> In other words, on V4 hardware, the VF's configuration domain and the PF's
> configuration domain are mutually exclusive—only one of them is ever read/write
> valid at any given time.

Sorry it is still not clear to me. My understanding was on V4 hardware,
the VF's live migration config register will be inactive only when you
set the PF's QM_MIG_REGION_SEL to QM_MIG_REGION_EN.

So, I think the question is whether you need to check the PF's
QM_MIG_REGION_SEL has set to  QM_MIG_REGION_EN, in patch 1 before
exposing the full VF BAR region or not. If yes, you need to reorganise
the patch 1. Currently patch 1 only checks the hardware version to
decide that.


Thanks,
Shameer

> Thanks.
> Longfang.
> 
>> Alex
>>
>>> +
>>>  struct acc_vf_data {
>>>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>>>  	/* QM match information */
>>> @@ -125,6 +137,7 @@ struct hisi_acc_vf_core_device {
>>>  	struct pci_dev *vf_dev;
>>>  	struct hisi_qm *pf_qm;
>>>  	struct hisi_qm vf_qm;
>>> +	int drv_mode;
>>>  	/*
>>>  	 * vf_qm_state represents the QM_VF_STATE register value.
>>>  	 * It is set by Guest driver for the ACC VF dev indicating
>>
>>
>> .
>>


