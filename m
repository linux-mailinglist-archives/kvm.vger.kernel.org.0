Return-Path: <kvm+bounces-41590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C998A6AC8D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F08C98268E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1CF22688C;
	Thu, 20 Mar 2025 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bQz9AiiA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A07E2628C;
	Thu, 20 Mar 2025 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742493305; cv=none; b=IEoIhgqYs3NMB42hMr++VKWcjKsaEHTVru+ZgM1vJ1GTM1lWp+iOyzGPXhjSaLaz+QzPWGem/vapn2JXwsTV3szRht4PXsh6GpbCRlWzIOtWkN/mSgMkQZZXUTp2TXNYvyQUmXxx6Qdi1ejvPlb5xPIRIb1nE+P/H9NZkV1wXY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742493305; c=relaxed/simple;
	bh=b7WPYVB4avkHvYlhsKX4r/4q1srYzQLdRV0HNGs3CTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PXG3gskdFzsc4FBqK8EpbfGmBArtRW9SSnQgRWXIt7O3hpnqVClA67S1vgJUjt85gx4a4SJ8KJSug5Pv1PPAq0rgfS47E2vLK1Ja2YHbgskn7cZG+FrK27Qn23n24KDMhuFSKb59X0EWu3kmsfn7adL/MTcPg6cb30YZxkPPZsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bQz9AiiA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KCS0Yt030296;
	Thu, 20 Mar 2025 17:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fdAJmg
	A8x/DyLgki6UGmCIKVDlIrxAcV/gCy52yibzM=; b=bQz9AiiAuGSrKdHEPcEB8f
	IABivnIpupqYJMsPlqaJaShNowYW6bXXdoLS5GH67i0yVgstu9pK/3ZC7B59CNep
	9WsEI37+uJ6BAmpgRf9tMvY+q4fW42QNS8PDjACylARHCB2BwAIjhArJr3P4m7Ah
	QsYxSiRbxhTGM+J2GP8sOrFW3UnY/506ae/dxLDkwfJSbnBw7LTR9WhOjNpkAYjo
	ZQdJGF3DXZ7RIh1uHfBiXuUQRFZWyzBZVcCWNgt3gAcpV/2cKQiV91D6bIQ53JoZ
	TIzzKUG6/hs5GvJHeLeljft3fUSGx+cS2evWOI4vTtDWYMmtHPClCNapKdjjVAFg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45gk21sv4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 17:54:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52KGXH8U020324;
	Thu, 20 Mar 2025 17:54:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45dncmh81k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 17:54:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52KHsqt441091458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 17:54:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37D8020043;
	Thu, 20 Mar 2025 17:54:52 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BD6920040;
	Thu, 20 Mar 2025 17:54:50 +0000 (GMT)
Received: from [9.124.213.75] (unknown [9.124.213.75])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Mar 2025 17:54:50 +0000 (GMT)
Message-ID: <9131d1be-d68e-48d6-afe3-af8949194b21@linux.ibm.com>
Date: Thu, 20 Mar 2025 23:24:49 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: pci: Advertise INTx only if LINE is connected
To: Alex Williamson <alex.williamson@redhat.com>
Cc: jgg@ziepe.ca, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yi.l.liu@intel.com, Yunxiang.Li@amd.com,
        pstanner@redhat.com, maddy@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
References: <174231895238.2295.12586708771396482526.stgit@linux.ibm.com>
 <20250318115832.04abbea7.alex.williamson@redhat.com>
Content-Language: en-US
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20250318115832.04abbea7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2ArvXWe6IanlGKcJBSbLAOIKEdIivx5Z
X-Proofpoint-GUID: 2ArvXWe6IanlGKcJBSbLAOIKEdIivx5Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_05,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503200111

On 3/18/25 11:28 PM, Alex Williamson wrote:
> On Tue, 18 Mar 2025 17:29:21 +0000
> Shivaprasad G Bhat <sbhat@linux.ibm.com> wrote:
>
>> On POWER systems, when the device is behind the io expander,
>> not all PCI slots would have the PCI_INTERRUPT_LINE connected.
>> The firmware assigns a valid PCI_INTERRUPT_PIN though. In such
>> configuration, the irq_info ioctl currently advertizes the
>> irq count as 1 as the PCI_INTERRUPT_PIN is valid.
>>
>> The patch adds the additional check[1] if the irq is assigned
>> for the PIN which is done iff the LINE is connected.
>>
>> [1]: https://lore.kernel.org/qemu-devel/20250131150201.048aa3bf.alex.williamson@redhat.com/
>>
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> Suggested-By: Alex Williamson <alex.williamson@redhat.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 586e49efb81b..4ce70f05b4a8 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -734,6 +734,10 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>>   			return 0;
>>   
>>   		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
>> +#if IS_ENABLED(CONFIG_PPC64)
>> +		if (!vdev->pdev->irq)
>> +			pin = 0;
>> +#endif
>>   
>>   		return pin ? 1 : 0;
>>   	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
>>
>>
> See:
>
> https://lore.kernel.org/all/20250311230623.1264283-1-alex.williamson@redhat.com/
>
> Do we need to expand that to test !vdev->pdev->irq in
> vfio_config_init()?

Yes. Looks to be the better option. I did try this and it works.


I see your patch has already got Reviewed-by. Are you planning

for v2 Or want me to post a separate patch with this new check?


> We don't allow a zero irq to be enabled in
> vfio_intx_enable(), so we might as well not report it as supported.

Yes. I agree.


Thank you!


Regards,

Shivaprasad



