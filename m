Return-Path: <kvm+bounces-57606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC80B583DF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:42:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FE9C4882C8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8842C2341;
	Mon, 15 Sep 2025 17:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iyJkapcs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2790829BDBA;
	Mon, 15 Sep 2025 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757958144; cv=none; b=qGIqtfUxSo909GaHjYS2QD3svyRujWDv5HoDC9wrLQD9pXsWqlSGmWrBNMCZD84mwkSZLRWG+AiuSUp5mGpDio1zzCbmzP+aGpBlbm4GDAxVwpBcwre8qU4c3pNqPBD8YFQFbCI/8+mJ22QSQOczNhMGJesMaOa5bw7xA94zdio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757958144; c=relaxed/simple;
	bh=lveJTBhWcGibWV+U84fVnL1ymE572t9uInDOtZ3oLaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bsb+N5p3c9SK8WOLUcSxHbmG8TEv7KshdngNFzsuW+nmaSaQ6I1Qxj9/Zbhm9vUkQsL3q3wpUCUYcFuO/GfBwtADEFxPjIqzA91AyUkuRTa/nyGhiQrECOfcZxjSi5Ws5HJjS5GDM1Dt6FTfcFgzWldTolCccaqM53AaaWFOVCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iyJkapcs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F9AEAk031553;
	Mon, 15 Sep 2025 17:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JhXJu6
	ir11KpT+sS/XSzhY+3oje8j9jfdBWs7PnkAQI=; b=iyJkapcsCW2e+yp/90Fvqi
	WfextZ6fAoQVXdviaM9OfMmQq+cIkC5Jbg3R54bgcOgYRKHAsHgnRIocTWaZSvuQ
	FXQmqywaY2FGrUnQ8DQiz1z4UzS3whXM1Lygfqya8UEuF23JWorOuWSfx0XvurOn
	mQ6Z5N6d2Qlj9co2TCL9ZtdlOsMz1WKYKs3m+4zFZuvE4uljBajhIqglH3Gm2V1R
	xrXMSb7YeFFfoGJvBKGzqniJjJxu1viyc6zvby9AQdaIh4YWQYpcIH6vTvOG+yRd
	TpLA68hnthXwKrI0uf54U3+p+nO9Si33rPMFI60dWhdZk1S1V1OL1eUmg+nD+Geg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tbw94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 17:42:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FFAAKa022316;
	Mon, 15 Sep 2025 17:42:18 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxpfp00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 17:42:18 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FHgG3p18022992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 17:42:16 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87EB85805C;
	Mon, 15 Sep 2025 17:42:16 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A88E95805B;
	Mon, 15 Sep 2025 17:42:15 +0000 (GMT)
Received: from [9.61.244.242] (unknown [9.61.244.242])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 17:42:15 +0000 (GMT)
Message-ID: <f3a91866-3897-4872-8336-384bb8e568a4@linux.ibm.com>
Date: Mon, 15 Sep 2025 10:42:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/10] s390/pci: Restore IRQ unconditionally for the
 zPCI device
To: Niklas Schnelle <schnelle@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-6-alifm@linux.ibm.com>
 <d4ae1aede3a62ad60626e9706d11ed3c48f5a30a.camel@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <d4ae1aede3a62ad60626e9706d11ed3c48f5a30a.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c84ffa cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=PrEUJIRfXM-3lrLWsPsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Xc40oTrlQ4S-hynvkJgcYdzArThsAIFb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX/aXsx08njwwt
 lt7YE/llYTwyZk6ueEUlxYsDFD0u0MF5ZGE446nuKqk5xLuNOuwMN+vAasRGmCTJEXwIjqrVKb4
 eS/LVTaRWLWYf2Gky/6r3gCBjoSGxWxaBAIPW04or4nMIP2ppdzILuagxcjt8TVRIOWZnFuH9nt
 XdIGD4zFWMBbK4Cuj3srVxIaiWgG2BDJCE14eaj9P0WT6X2Y6tmRrUSJ+XgmLgk8kWa6tlb8AnE
 e4IfOMgPmqbG2g3OD+3rg568CXaHjF9c/KsNM3fiV5+P6omeaaEoL9kPjV/n3tWRTgIgRKnbbop
 zOX1s4xTSfIBqSEIWvibkXWL92mclSEq0ClA7Phc7R5LQzxrfojg4KXTL7VzklYF8iyAVn6al0U
 PJFntxM9
X-Proofpoint-GUID: Xc40oTrlQ4S-hynvkJgcYdzArThsAIFb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001


On 9/15/2025 1:39 AM, Niklas Schnelle wrote:
> On Thu, 2025-09-11 at 11:33 -0700, Farhan Ali wrote:
>> Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
>> introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
>> resetting a zPCI device.
>>
>> Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug slot"),
>> mentions zpci_clear_irq() being called in the path for zpci_hot_reset_device().
>> But that is not the case anymore and these functions are not called
>> outside of this file.
> If you're doing another version I think you could add a bit more
> information on why this still works for existing recovery based on my
> investigation in
> https://lore.kernel.org/lkml/052ebdbb6f2d38025ca4345ee51e4857e19bb0e4.camel@linux.ibm.com/
>
> Even if you don't add more explanations, I'd tend to just drop the
> above paragraph as it doesn't seem relevant and sounds like
> zpci_hot_reset_device() doesn't clear IRQs. As explained in the linked
> mail there really is no need to call zpci_clear_irq() in
> zpci_hot_reset_device() as the CLP disable does disable IRQs. It's
> really only the state tracking that can get screwed up but is also fine
> for drivers which end up doing the tear down.

I referenced commit da995d538d3a as that commit introduced the 
arch_restore_msi_irqs and describes the reasoning as to why we need it. 
It also mentions about zpci_clear_irq being called by 
zpci_hot_reset_device. IMHO the message was confusing as it took me my 
down the path of trying to identify any commit that changed the behavior 
since da995d538d3a. But that wasn't the case and it was an error in the 
commit message. I want to keep a reference here to at least clarify that.

I had tried to clarify that this only becomes an issue if a driver tries 
restoring state through pci_restore_state(), in the paragraph below. But 
should I change it to be more explicit about that it's not an issue for 
driver doing setup and tear down through arch_msi_irq_setup and 
arch_msi_irq_teardown functions?

>
>> However after a CLP disable/enable reset, the device's IRQ are
>> unregistered, but the flag zdev->irq_registered does not get cleared. It
>> creates an inconsistent state and so arch_restore_msi_irqs() doesn't
>> correctly restore the device's IRQ. This becomes a problem when a PCI
>> driver tries to restore the state of the device through
>> pci_restore_state(). Restore IRQ unconditionally for the device and remove
>> the irq_registered flag as its redundant.
> s/its/it's/

Thanks, will fix.

>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h | 1 -
>>   arch/s390/pci/pci_irq.c     | 9 +--------
>>   2 files changed, 1 insertion(+), 9 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 41f900f693d9..aed19a1aa9d7 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -145,7 +145,6 @@ struct zpci_dev {
>>   	u8		has_resources	: 1;
>>   	u8		is_physfn	: 1;
>>   	u8		util_str_avail	: 1;
>> -	u8		irqs_registered	: 1;
>>   	u8		tid_avail	: 1;
>>   	u8		rtr_avail	: 1; /* Relaxed translation allowed */
>>   	unsigned int	devfn;		/* DEVFN part of the RID*/
>> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
>> index 84482a921332..e73be96ce5fe 100644
>> --- a/arch/s390/pci/pci_irq.c
>> +++ b/arch/s390/pci/pci_irq.c
>> @@ -107,9 +107,6 @@ static int zpci_set_irq(struct zpci_dev *zdev)
>>   	else
>>   		rc = zpci_set_airq(zdev);
>>   
>> -	if (!rc)
>> -		zdev->irqs_registered = 1;
>> -
>>   	return rc;
>>   }
>>   
>> @@ -123,9 +120,6 @@ static int zpci_clear_irq(struct zpci_dev *zdev)
>>   	else
>>   		rc = zpci_clear_airq(zdev);
>>   
>> -	if (!rc)
>> -		zdev->irqs_registered = 0;
>> -
>>   	return rc;
>>   }
>>   
>> @@ -427,8 +421,7 @@ bool arch_restore_msi_irqs(struct pci_dev *pdev)
>>   {
>>   	struct zpci_dev *zdev = to_zpci(pdev);
>>   
>> -	if (!zdev->irqs_registered)
>> -		zpci_set_irq(zdev);
>> +	zpci_set_irq(zdev);
>>   	return true;
>>   }
>>   
> Code looks good to me. With or without my suggestions for the commit
> message:
>
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

Thanks for reviewing!

Thanks
Farhan



