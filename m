Return-Path: <kvm+bounces-54687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4173B26CBC
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 18:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDA5A7BD29B
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 16:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA9C2FD7C2;
	Thu, 14 Aug 2025 16:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dkeBm/uL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249872FD1C5;
	Thu, 14 Aug 2025 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755189772; cv=none; b=LA8e3NYhlrqhPk3tYa6IkJ0ka+R/L+wAoOwKTurMo6lniWOCKGzJs8Fj5ZQGaPcrlfWvfJr8k5Plvjt9eWWuWBVHABFeCP3FqOwpVv6fxbYWq6Y5DO4WP5R+0fXfaKrSKIjfDbNlSlL3LjfbhUPEGYORsUA++Y0DvCUXYcMG748=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755189772; c=relaxed/simple;
	bh=mz/mOnaDhT7y0ngD1XogLRyEVbazfE/YHYJwfy6l0M0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tXDUEpyF0mvDIiJMB7KgK7eHpY5pBp7de+yNtogCO58qVWwIbmOVLBf4CavZvOWhjzNeQxIjpqnaw2bI0Mxy1eLMrOKNgxcOTbD/2zrTIKqgAW24Q/n/fM5A53D5hmLiBhFEXkgeQDdJ/rV7qSDIpGe9WaU1/1dVIqQ5bRMHtDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dkeBm/uL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EEVShC008500;
	Thu, 14 Aug 2025 16:42:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=uSXMND
	ExphsDWE2GsTVMwbcsqCwYtMA9TmOm6X9QdDY=; b=dkeBm/uLQgPxXY0gB52vhH
	eQXxEUclCtlxG++ZMgIZG77BwOrW6BP2dchCvrYWmoxb8wh72G6knXLvnIDq2EPs
	AMxtonSarl58h1zjjp+bgQXIj3bHK30aFsqhKhpkSnLbqMpEKjUTZAHFe4u2s1I4
	X4dBNkE31QqmoYSpdV2YWYR1sf/YqGgwe826vEHf5YHIAAU2U3RoE9vDPREoCTSW
	6F2n8m/94q30TgRb8u52yYRvCk0CoBePWFQI92f6rNRVXEldz/yFJFCS2y9/Fzn2
	Vd2xCVDP6YxDme/Hc/vdAuyl7XS7WGn3Le9wQQTEcT5vVV+FirAqZOhNubjPxrPg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48ehaafhxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 16:42:48 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57EE84MB020615;
	Thu, 14 Aug 2025 16:42:47 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ehnq5225-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 16:42:47 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57EGgk9J10356146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 16:42:46 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4643F58055;
	Thu, 14 Aug 2025 16:42:46 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 770A85803F;
	Thu, 14 Aug 2025 16:42:45 +0000 (GMT)
Received: from [9.61.254.71] (unknown [9.61.254.71])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Aug 2025 16:42:45 +0000 (GMT)
Message-ID: <be3a05c6-a016-4fdb-a3c4-d23ccd13b9c9@linux.ibm.com>
Date: Thu, 14 Aug 2025 09:42:43 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/6] s390/pci: Restore airq unconditionally for the
 zPCI device
To: Niklas Schnelle <schnelle@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mjrosato@linux.ibm.com, alex.williamson@redhat.com
References: <20250813170821.1115-1-alifm@linux.ibm.com>
 <20250813170821.1115-2-alifm@linux.ibm.com>
 <94289b685aae2c329ecae06a56e3648375841ab4.camel@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <94289b685aae2c329ecae06a56e3648375841ab4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KPRaDEFo c=1 sm=1 tr=0 ts=689e1208 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=D9-VrTiXSDm16sDqG5AA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: RFaKqugRyjIO3NiEbudubJ40HmQhFNG2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfXzZSy92PXPReE
 5p/l3qDK3JXm0qvwhoZNutrf6un6GJym+ekV8XN1Ooj1DAkBFBq/A1GwTaytffzP2P0stywkfpC
 EQzZySJWfJx4YLvpSbfk42zUfanfcWnqhs7wKYDZ1JuCpYi9sooJpQscvZFFJrk/X48w8GXMAf7
 h99t1BI5yl2rrkHE08gmhZp8/Bah3yK4qoeBFszYourc3iF+awycaUx//SNB4woFNLYexJHnUnW
 HoGs1Lj0gQKVYCtYUNe3QPJR2ygeOR3m9aOgk+v/geJTcJrv3NVgj/TIIeylWSjI8ydwAkEVWyu
 EnLlO675U9CLkM1+FfmftJV/7KrWMqXVsQCdH9AFSQ4qAWZf8ufD4TVdnC680EwdVVQIwsbnhVI
 /wZMihTS
X-Proofpoint-GUID: RFaKqugRyjIO3NiEbudubJ40HmQhFNG2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120224


On 8/14/2025 4:32 AM, Niklas Schnelle wrote:
> On Wed, 2025-08-13 at 10:08 -0700, Farhan Ali wrote:
>> Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
>> introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
>> resetting a zPCI device.
>>
>> Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug slot"),
>> mentions zpci_clear_irq() being called in the path for zpci_hot_reset_device().
>> But that is not the case anymore and these functions are not called
>> outside of this file.
>>
>> However after a CLP disable/enable reset (zpci_hot_reset_device),
>> the airq setup of the device will need to be restored. Since we
>> are no longer calling zpci_clear_airq() in the reset path, we should
>> restore the airq for device unconditionally.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   arch/s390/pci/pci_irq.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
>> index 84482a921332..8b5493f0dee0 100644
>> --- a/arch/s390/pci/pci_irq.c
>> +++ b/arch/s390/pci/pci_irq.c
>> @@ -427,8 +427,7 @@ bool arch_restore_msi_irqs(struct pci_dev *pdev)
>>   {
>>   	struct zpci_dev *zdev = to_zpci(pdev);
>>   
>> -	if (!zdev->irqs_registered)
>> -		zpci_set_irq(zdev);
>> +	zpci_set_irq(zdev);
>>   	return true;
>>   }
>>   
> This would make zdev->irqs_registered effectively without function so
> the patch should remove that field from struct zpci_dev and
> zpci_set_irq()/zpci_clear_irq(). Alternatively you could also clear
> zdev->irqs_registed in zpci_disable_device(). I think the former is
> cleaner though.
>
> Thanks,
> Niklas
Yeah agreed, will remove the irqs_registered from zdev as its not needed 
anymore.

Thanks
Farhan

