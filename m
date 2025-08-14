Return-Path: <kvm+bounces-54694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFD9B27082
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 23:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75F951BC7091
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 21:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652612741BC;
	Thu, 14 Aug 2025 21:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dqPEtk6t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CB9247287;
	Thu, 14 Aug 2025 21:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755205336; cv=none; b=YP9SabzfML671b1L0JWMq6ke3Iqgjab5NmxhNPWKY9AiaN6WnNLWEG0i9cubgdV/yal+gYCMYOBmZYytZabcRghFvGBDeE2Y9Fw09G72GouoNF/yqLDiTD3JXKAdSq9rowl5Cvuj3ZNu17sV+rkW445eCHf0xQo6X7lMvuDP2WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755205336; c=relaxed/simple;
	bh=+j3KbxhIaA0ZH7cjICsJlGmmwNiVxxLhYjCvVfa/ckQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hQaCgHx93BtjyF4tw2u24C4Vw2FKx53Q0DVIdzM3YvPhj6W4/ewxUNnQdesTm5tjPCXY+Y76aKPzzAXjEXcHZB/AhRsKfEO/mRhYmiYrmP087FP8uUDc476QQRw46SYHl9ifwRotJxxnS/ueQ9gou6uP/qGOoqe17VtNxUQwEZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dqPEtk6t; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EEVRje009755;
	Thu, 14 Aug 2025 21:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xzTKJS
	w+5NSfhYSifQkvy6p6Bc0axDUXRlLgVx2ggNo=; b=dqPEtk6tUaSrQhhNkNY9Cz
	r6PzNHwVmcXtKobjvIbw2jx+i7qmbdhyT4VFerNf/YyLiuPXV0r8+tPHdHUHwbZJ
	eRtJp12+EDOlWdZSKQ8+skx2OluE4ysZigpztD5rxaDnmRCwashRDW/AwlBUsl37
	jSoLW/9vot4L7daApqZ0geuXBRLF6YdFIyQkyR7F0XKZQTsQEz+i10U9uvfIPv+L
	h/4NP9VFmXwRO/U/howyhd0vrhYHHr+u31PBwifCAf4+g/Lmhpz5LlAj/Qkkid9G
	YDKsbLYMrfxJ81wIYUtj8wv367CBNE29XTXFlOCsmLBknljpysSo8/tVGcukr0+A
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwudmkj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 21:02:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHq9SC020623;
	Thu, 14 Aug 2025 21:02:09 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ehnq60t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 21:02:09 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57EL27OE27460202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 21:02:07 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C13E58059;
	Thu, 14 Aug 2025 21:02:07 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB71558043;
	Thu, 14 Aug 2025 21:02:06 +0000 (GMT)
Received: from [9.61.244.230] (unknown [9.61.244.230])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Aug 2025 21:02:06 +0000 (GMT)
Message-ID: <60855b41-a1ad-4966-aa5e-325256692279@linux.ibm.com>
Date: Thu, 14 Aug 2025 14:02:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 6/6] vfio: Allow error notification and recovery for
 ISM device
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com
References: <20250814204850.GA346571@bhelgaas>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250814204850.GA346571@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfXy6AJH8waoyaD
 Z6jvlIW0gaN8a8Ar1GfnEH5bWz7t/vX00PK2lLDYGXfKx8kFb7AGwGMpQHzGtW5nkAlzP0ND5d2
 JbagKhgFMlFeb5cep3m6jlUFrgW4dWUX9wHZZfYsKU3VMbKP9KAwRG4IoRkzFh2V7w5JG0uj3Xo
 xvdfQaGmD24qktzNSpjXSwiPiHWt0qCPcllsBQqRFcs4j0EM86fQI/n+ramBIvDwB7Zi/oDp/u+
 Ofxntciq7LpqnySStR3avePOHZ80OPtwTfCOClm2lhmmSPCnUO81UWPL1kJYeAuzJwfksre5CjQ
 +lqGjEKtBFDxCj32KrIVlAqjcMIgVkOU4DW2uZU3betYGp8izn4ucD4nP+10Bk54FJleDZidQlk
 RaAsEvhM
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=689e4ed2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=c3_NMMW06mFj85baJVsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: MjgQMatlesc9X1y3s6KrtvLeat5wO813
X-Proofpoint-ORIG-GUID: MjgQMatlesc9X1y3s6KrtvLeat5wO813
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224


On 8/14/2025 1:48 PM, Bjorn Helgaas wrote:
> On Wed, Aug 13, 2025 at 10:08:20AM -0700, Farhan Ali wrote:
>> VFIO allows error recovery and notification for devices that
>> are PCIe (and thus AER) capable. But for PCI devices on IBM
>> s390 error recovery involves platform firmware and
>> notification to operating system is done by architecture
>> specific way. The Internal Shared Memory(ISM) device is a legacy
>> PCI device (so not PCIe capable), but can still be recovered
>> when notified of an error.
> "PCIe (and thus AER) capable" reads as though AER is required for all
> PCIe devices, but AER is optional.
>
> I don't know the details of VFIO and why it tests for PCIe instead of
> AER.  Maybe AER is not relevant here and you don't need to mention
> AER above at all?

The original change that introduced this commit dad9f89 "VFIO-AER: 
Vfio-pci driver changes for supporting AER" was adding the support for 
AER for vfio. My assumption is the author thought if the device is AER 
capable the pcie check should be sufficient? I can remove the AER 
references in commit message. Thanks Farhan



>
>> Relax the PCIe only requirement for ISM devices, so passthrough
>> ISM devices can be notified and recovered on error.
> Nit: it looks like all your commit logs could be rewrapped to fill
> about 75 columns (to leave space for "git log" to indent them and
> still fit in 80 columns).  IMHO not much value in using a smaller
> width than that.
>
Sure, will fix this.
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c  | 18 ++++++++++++++++--
>>   drivers/vfio/pci/vfio_pci_intrs.c |  2 +-
>>   drivers/vfio/pci/vfio_pci_priv.h  |  3 +++
>>   3 files changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 7220a22135a9..1faab80139c6 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -723,6 +723,20 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
>>   }
>>   EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
>>   
>> +bool vfio_pci_device_can_recover(struct vfio_pci_core_device *vdev)
>> +{
>> +	struct pci_dev *pdev = vdev->pdev;
>> +
>> +	if (pci_is_pcie(pdev))
>> +		return true;
>> +
>> +	if (pdev->vendor == PCI_VENDOR_ID_IBM &&
>> +			pdev->device == PCI_DEVICE_ID_IBM_ISM)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>   static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
>>   {
>>   	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
>> @@ -749,7 +763,7 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>>   			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
>>   		}
>>   	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
>> -		if (pci_is_pcie(vdev->pdev))
>> +		if (vfio_pci_device_can_recover(vdev))
>>   			return 1;
>>   	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
>>   		return 1;
>> @@ -1150,7 +1164,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>>   	case VFIO_PCI_REQ_IRQ_INDEX:
>>   		break;
>>   	case VFIO_PCI_ERR_IRQ_INDEX:
>> -		if (pci_is_pcie(vdev->pdev))
>> +		if (vfio_pci_device_can_recover(vdev))
>>   			break;
>>   		fallthrough;
>>   	default:
>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 123298a4dc8f..f5384086ac45 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -838,7 +838,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>>   	case VFIO_PCI_ERR_IRQ_INDEX:
>>   		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>>   		case VFIO_IRQ_SET_ACTION_TRIGGER:
>> -			if (pci_is_pcie(vdev->pdev))
>> +			if (vfio_pci_device_can_recover(vdev))
>>   				func = vfio_pci_set_err_trigger;
>>   			break;
>>   		}
>> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>> index 5288577b3170..93c1e29fbbbb 100644
>> --- a/drivers/vfio/pci/vfio_pci_priv.h
>> +++ b/drivers/vfio/pci/vfio_pci_priv.h
>> @@ -36,6 +36,9 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>   ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>   			size_t count, loff_t *ppos, bool iswrite);
>>   
>> +bool vfio_pci_device_can_recover(struct vfio_pci_core_device *vdev);
>> +
>> +
>>   #ifdef CONFIG_VFIO_PCI_VGA
>>   ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>>   			size_t count, loff_t *ppos, bool iswrite);
>> -- 
>> 2.43.0
>>

