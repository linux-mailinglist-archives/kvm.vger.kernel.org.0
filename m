Return-Path: <kvm+bounces-57921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EEAB813B2
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 19:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42FA4467458
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82B02FE56E;
	Wed, 17 Sep 2025 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iZgOCoNi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9E02FE56B;
	Wed, 17 Sep 2025 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131469; cv=none; b=M95HAL1e5+1xjbVIsRiTZwCaOWvryW3notThhbIKfqFwiuo/D3hpcG3yEBgT5T/yf6VeoxW9i5dVLpX+FWs5NWNv1dXvs1UpBNzJt3lBhmlIRKXdWYSABEH4TlWmUU71zKAvJbftyuKyA8p5hZrhRI7naFej8nM0uAQMZRs0jWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131469; c=relaxed/simple;
	bh=brl3rUJ7PHhbScsa8OjzCWBMtqQju8gphFm/i7O0YIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GAKuhOHC3pZCaNHGwiydf+M0lqtbDGKjPtT7HLUoogSjiPmVEiNvVO3tCSqHUzu4ye6KLqRd8+IRC9oUXY9CLH7KFPNY282ftjzGH8Lm+Qq7fpy7XHj26okJyjRIrZGvK/4cRjOIVuMMGD6rL/GoymGtrUD3i7KFrto6e6yh6yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iZgOCoNi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HB47Op031401;
	Wed, 17 Sep 2025 17:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VSb8bE
	4XA/Ua9GKH9sL1VLxuwv8W4LaMgmb1OJHJR6w=; b=iZgOCoNiSdWEsGhANdLOOg
	/5Az7NYqZoSEkMvNVukXsxy8MiHEftUehCzoIoo0yovfQx/vcnlW54+WZU90IDmY
	lDwZnzhFMQeFcqDvvCofSZql2zPleME3E2qU7urZ9eCOTRCF/gh/IMeXQTIIQqdf
	qhOJpQjqQu4rtyUwLiTuYkn8YjzjgqAgfr5GVdQBiO3cPxBC6+GKVWf77NPKVAq/
	0ar9pyQ6RJWsok9SPwS04SVJPGEeVCXF79IJbN1RhrebKZFjlTao0OuYl9mOGDcq
	ouFKWhDtobft57qcYO6QgUlbNydGBWRDuoS7/aoUprawKBh5B6Pw4oAPLveu0pcQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4hndde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:51:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HHR1db022297;
	Wed, 17 Sep 2025 17:50:59 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxptj9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 17:50:59 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HHowjB63176996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 17:50:58 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C5B75805C;
	Wed, 17 Sep 2025 17:50:58 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC28058051;
	Wed, 17 Sep 2025 17:50:56 +0000 (GMT)
Received: from [9.61.250.96] (unknown [9.61.250.96])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 17:50:56 +0000 (GMT)
Message-ID: <28a56c75-9e45-4855-b555-49237cacba3a@linux.ibm.com>
Date: Wed, 17 Sep 2025 10:50:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] PCI: Allow per function PCI slots
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-4-alifm@linux.ibm.com>
 <07205677-09f0-464b-b31c-0fb5493a1d81@redhat.com>
 <e86caff6-8af0-48c9-9058-c1991e23160f@linux.ibm.com>
 <f6f59318-c462-404b-bf4f-ae121950be8c@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <f6f59318-c462-404b-bf4f-ae121950be8c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nkD6okS8y5FMS1TA12UjqrsOPnxcqlL6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXyrUpHLqs3GpL
 xCHsiRpSr6M/vGiYHrUDiU/3T8aVW3wZJXoxPP39XRhF16wr21ZVeNCcTU8ZDE3NQtoNz1wAIec
 gWscSNOojQzJ1Q8pBvn5k6um6MyEJf95ktFQVBs/+qjUfMq6I29xW3yFz6iOipFywHbaeZx/6tZ
 aAzf5miXquFt8x8YSB8MWmdT1Y1vKpVI6g1QO9YGPM6/9FnLzUbCF7NHzpzoV6nTDV+PHwe8BIo
 QOJeZdqPB5Xbu861mqiJbMb6UIXqmg9/+dxw0sy7ZVwav1D0PBe9+2TGjDjZtNCmGuk1tT3PgxV
 sgWt3ozaq3FFXycfW5SE0Z3TsIpdC+ID46Sr5+TM9tKSr9IoyfhYeKZ9jKXV7PtMCBuJfA8iNYW
 EaMqw7FT
X-Proofpoint-GUID: nkD6okS8y5FMS1TA12UjqrsOPnxcqlL6
X-Authority-Analysis: v=2.4 cv=co2bk04i c=1 sm=1 tr=0 ts=68caf505 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=NEAV23lmAAAA:8 a=3iO8Xu5d0OMkKlL8vZAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509160204


On 9/16/2025 11:21 PM, Cédric Le Goater wrote:
> Hi Farhan,
>
>> Hi Cedric,
>>
>> Thanks for pointing this out. I missed that dev->slot could be NULL 
>> and so the per_func_slot check should be done after the check for 
>> !dev->slot. I tried this change on top of the patch in an x86_64 VM 
>> and was able to boot the VM without the oops.
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 70296d3b1cfc..3631f7faa0cf 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -5061,10 +5061,9 @@ static int pci_reset_hotplug_slot(struct 
>> hotplug_slot *hotplug, bool probe)
>>
>>   static int pci_dev_reset_slot_function(struct pci_dev *dev, bool 
>> probe)
>>   {
>> -       if (dev->multifunction && !dev->slot->per_func_slot)
>> -               return -ENOTTY;
>>          if (dev->subordinate || !dev->slot ||
>> -           dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
>> +           dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
>> +           (dev->multifunction && !dev->slot->per_func_slot))
>>                  return -ENOTTY;
> All good.
>
> I have pushed the Linux branch I use for vfio :
>
>    https://github.com/legoater/linux/commits/vfio/
>
> These commits have small changes :
>
>     PCI: Allow per function PCI slots
>     vfio-pci/zdev: Add a device feature for error information
>
> Thanks,
>
> C.
>
>
Hi Cedric,

Thanks again for your help in reviewing the patches.

Thanks
Farhan



