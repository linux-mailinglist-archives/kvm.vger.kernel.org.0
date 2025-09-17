Return-Path: <kvm+bounces-57918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DA0B81283
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 19:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9526175572
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE01E2FD7DE;
	Wed, 17 Sep 2025 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DbjFiY/p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8612FB0BD;
	Wed, 17 Sep 2025 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758129778; cv=none; b=dyEopMp9ErSiy91VWyE4Ggvj+EsF1TVEDSI2rDzpEo70uYUwrdPHxdYZd1bF0kLtig7N4+JJtvO5qnzAlIZ4Pb4OnyXmipVSxTNz+G87mwERrnPNelscnvXAw1u3nHseETPRNNzQFOVwy7HO/kYus3ENR68GFulljXK15ktlCus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758129778; c=relaxed/simple;
	bh=6u5yCDpxgZcRpHUP/o01jDSAR/oGcHsCFMjWoUic5aU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrhSds+4qJyByv9N29b9BcOGLL5Guy81fc/0hq3ny4+ErM1qpCmxr31c0NaE9Z7Ok0udKJ3c8f+0xaCaYTf+/QLRX1vsWIMiSiAopH3XAu61/vbtbMtSVYUQNMU8Fq8f9EfEBkBkl9Wapt8jjXR8UiK6qwuPFlwNVRgW2mk021E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DbjFiY/p; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HApUho024725;
	Wed, 17 Sep 2025 17:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=E0yeZg
	eyKldbjjNHfOTs/54fnst08q29uA1nwy+ZVjY=; b=DbjFiY/ppWVpYBrrkPFUAR
	UTvnNEUiq51O6Ja+bd5ZyMpcHnMQySOzXAB+QbDfXaMyg+979MlNPizBNXiV3x6S
	wAa04FEJMByeINYq5zK/SyjsWmjMez8h4KJgAIv6zBxfc5nXlLcYfskDXNAbeo8P
	v6kUZuGQbQ7A7jL6SwUydgaTO81E4Hj51MzXm2Hdlfa2htvAIb0g/rHouBgNW20H
	bpN5qwqK2oHdsEtzqPGLER1tkSWobEx8dNeRmoyU0tsJg1sVOpTdhdzmWhC+W6ds
	5mJtohrGFiAIwyS+h5LxcQfVM8Zum8IUfzVh2Zt5pLqlyX+LlAPJDEKIRxTH/qQA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qmyau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:22:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HFSYva009363;
	Wed, 17 Sep 2025 17:22:44 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3j3xs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:22:44 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HHMhW231720100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 17:22:43 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94A685805F;
	Wed, 17 Sep 2025 17:22:43 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0389E5805A;
	Wed, 17 Sep 2025 17:22:42 +0000 (GMT)
Received: from [9.61.250.96] (unknown [9.61.250.96])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 17:22:41 +0000 (GMT)
Message-ID: <cf65139b-4141-439f-ad9f-3ef9d01a63ee@linux.ibm.com>
Date: Wed, 17 Sep 2025 10:22:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] s390/pci: Add architecture specific resource/bus
 address translation
To: Niklas Schnelle <schnelle@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-5-alifm@linux.ibm.com>
 <f60b86d08a4ad0feef32dc8e478f3bd3a8d26019.camel@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <f60b86d08a4ad0feef32dc8e478f3bd3a8d26019.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zZnedLKpgbsinD-hxbTZ_JWEvYFxqaMg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXzxNSGewR7n0u
 kgC1uBT9Pd8vwoYvfTgQUFaX0S1qJcFO9kpKQb2qQ15+uNSmAzVHw9Apmx3YKr/GPSZMi0RvU26
 3BEfrWJQS9/nTPyFLaorKMe0uHwgHFEzMLGOvFczh70rvIWTuGQEVMw+vhqNDkUgKe114WTsDxJ
 xPp+cbC+gcj9x6veoVgVs/LXe0NSFmogE2GvHc60/lGUA7fn2//LDsF+/jkE57iVnHfY8yNKjdD
 7knL2ZyqlSEQVPyvEY8MLzKIUWzVIAj8gHy5g8Bq7YS2/kqQjP7JPUjUn+L/yKO+zlbJ1Cft4ZH
 DaSdGGNMQpkOuMhUwO/PDiVO8O87ulc24ytwjZlkJivpE5+wzhf5bACeJIlMyVkdPGbdn2ubfV7
 t9k6MKzW
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68caee65 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=PeAeElh3kjYzBj7VUaQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: zZnedLKpgbsinD-hxbTZ_JWEvYFxqaMg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204


On 9/17/2025 7:48 AM, Niklas Schnelle wrote:
> On Thu, 2025-09-11 at 11:33 -0700, Farhan Ali wrote:
>> On s390 today we overwrite the PCI BAR resource address to either an
>> artificial cookie address or MIO address. However this address is different
>> from the bus address of the BARs programmed by firmware. The artificial
>> cookie address was created to index into an array of function handles
>> (zpci_iomap_start). The MIO (mapped I/O) addresses are provided by firmware
>> but maybe different from the bus address. This creates an issue when trying
>> to convert the BAR resource address to bus address using the generic
>> pcibios_resource_to_bus.
>>
> Nit: I'd prefer referring to functions with e.g.
> pcibios_resource_to_bus() to make them easier to distinguish. Same also
> below.
>
>> Implement an architecture specific pcibios_resource_to_bus function to
>> correctly translate PCI BAR resource address to bus address for s390.
> Nit: I'd use the plural "addresses" above as we're dealing with a whole
> range.
>
>> Similarly add architecture specific pcibios_bus_to_resource function to do
>> the reverse translation.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   arch/s390/pci/pci.c       | 73 +++++++++++++++++++++++++++++++++++++++
>>   drivers/pci/host-bridge.c |  4 +--
>>   2 files changed, 75 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>> index cd6676c2d602..5baeb5f6f674 100644
>> --- a/arch/s390/pci/pci.c
>> +++ b/arch/s390/pci/pci.c
>> @@ -264,6 +264,79 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>>   	return 0;
>>   }
>>   
>> +void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
>> +			     struct resource *res)
>> +{
>> +	struct zpci_bus *zbus = bus->sysdata;
>> +	struct zpci_bar_struct *zbar;
>> +	struct zpci_dev *zdev;
>> +
>> +	region->start = res->start;
>> +	region->end = res->end;
>> +
>> +	for (int i = 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
>> +		int j = 0;
>> +
>> +		zbar = NULL;
>> +		zdev = zbus->function[i];
>> +		if (!zdev)
>> +			continue;
>> +
>> +		for (j = 0; j < PCI_STD_NUM_BARS; j++) {
>> +			if (zdev->bars[j].res->start == res->start &&
>> +			    zdev->bars[j].res->end == res->end) {
>> +				zbar = &zdev->bars[j];
>> +				break;
>> +			}
>> +		}
>> +
>> +		if (zbar) {
>> +			/* only MMIO is supported */
> Should the code that sets zbar check IORESOURCE_MEM on the res->flags
> to ensure the above comment? Though zpci_setup_bus_resources() only
> creates IORESOURCE_MEM resources so this would only be relevant if
> someone uses a resource from some other source.

I don't think it hurts to add the check. I don't think we support any 
PCI devices on the platform with IORESOURCE_IO.


>
>> +			region->start = zbar->val & PCI_BASE_ADDRESS_MEM_MASK;
>> +			if (zbar->val & PCI_BASE_ADDRESS_MEM_TYPE_64)
>> +				region->start |= (u64)zdev->bars[j + 1].val << 32;
>> +
>> +			region->end = region->start + (1UL << zbar->size) - 1;
>> +			return;
>> +		}
>> +	}
>> +}
>> +
>> +void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
>> +			     struct pci_bus_region *region)
>> +{
>> +	struct zpci_bus *zbus = bus->sysdata;
>> +	struct zpci_dev *zdev;
>> +	resource_size_t start, end;
>> +
>> +	res->start = region->start;
>> +	res->end = region->end;
>> +
>> +	for (int i = 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
>> +		zdev = zbus->function[i];
>> +		if (!zdev || !zdev->has_resources)
>> +			continue;
>> +
>> +		for (int j = 0; j < PCI_STD_NUM_BARS; j++) {
>> +			if (!zdev->bars[j].val && !zdev->bars[j].size)
>> +				continue;
> Shouldn't the above be '||'? I think both a 0 size and an unset bars
> value would indicate invalid. zpci_setup_bus_resources() only checks 0
> size so I think that would be enoug, no?

Right, architecturally both size 0 and unset BAR value would indicate 
invalid and this check was meant for that. But I think just changing 
this to !zdev->bars[j].size should also be enough, as we already handle 
the 64bit BAR case below. Will change this.

Thanks Farhan

>
>> +
>> +			/* only MMIO is supported */
>> +			start = zdev->bars[j].val & PCI_BASE_ADDRESS_MEM_MASK;
>> +			if (zdev->bars[j].val & PCI_BASE_ADDRESS_MEM_TYPE_64)
>> +				start |= (u64)zdev->bars[j + 1].val << 32;
>> +
>> +			end = start + (1UL << zdev->bars[j].size) - 1;
>> +
>> +			if (start == region->start && end == region->end) {
>> +				res->start = zdev->bars[j].res->start;
>> +				res->end = zdev->bars[j].res->end;
>> +				return;
>> +			}
>> +		}
>> +	}
>> +}
>> +
>>
> Overall the code makes sense to me. I think this hasn't caused issues
> so far only because firmware has usually already set up the BAR
> addresses for us.
>
> Thanks,
> Niklas

