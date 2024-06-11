Return-Path: <kvm+bounces-19311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB6F903B3F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 13:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA87D1F215E3
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 11:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60FD17C237;
	Tue, 11 Jun 2024 11:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kd7aSeuI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD01317997D;
	Tue, 11 Jun 2024 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718107086; cv=none; b=XdZyTQn90QVD/xtgJb/AcDheg3VZ3qoK2ih+hZkBzC6lgX5j+xFOk7hcdPbKirBz4xi/EBvr1wDZ9mkIdmIFAuPtZhzbb2NsnzT7WNjgN04gCXg/4xr7mXqouFDfkr2FzILJSIHCymCat3FXXORTk0pCQVzKpQMyDhtLSdEbf04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718107086; c=relaxed/simple;
	bh=Tv7OLKSK83Mq5dlQVd7OKap0aeF6gI8Ag8/q/WPOlUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sIF7kWsrLVRqeCg9fKZM65l39MDUW3XKms3cezCvn/gSxVrwgcNMLtSEHq0f9cmXfNeGKyBdnePoWaku9PhmavlrBGvFhz8awh3PkyuTJ8XLPJnT1CvEs/n6u1Wp/VgNIeHdRTfySl9umSAwq9W1r9nEO6DkB0SLeakeqE+PQOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kd7aSeuI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BBRIl3012967;
	Tue, 11 Jun 2024 11:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=B
	VDD+SHnGM8xPmCxFaRJQGaImXlzhSHBBAzgtsLhu88=; b=kd7aSeuI9AgI6BZUm
	DqzUGU56OAh7gtpZ8F5eXiJ+Aa/ox4KQ3Z4RclJeFMVpxsCROidNROoajIdmHsur
	zrm5aDdWuogqLo9jqKnq/pScocgZmw5lrRUsBDlkNV0BWCl98iRXMxn0rcZgepLJ
	tBkhV5LHdt1JUpsiB2HdJDRvYT7gxMH0emgFKeL5cJDCGjg3t3baRhvbV+EtbPdc
	avGuSKDvKn6rCPyq41LqOjYG+I2TOWBfrcrKi5kGJW4tXerdsLeWRRTrE6bNymcU
	xiEjv76yUQiWn1KZW3WVbm7NQxIWnaMT2LjOT2okTb9+I08hqz9Gm9GLzO1KLKz7
	/2o0g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypmv4861t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 11:57:12 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BBvB2G022708;
	Tue, 11 Jun 2024 11:57:11 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypmv485xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 11:57:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45B9wWfk027246;
	Tue, 11 Jun 2024 11:53:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn210nqx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 11:53:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BBr7Lb55509402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 11:53:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BAD5F2004B;
	Tue, 11 Jun 2024 11:53:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 351B220049;
	Tue, 11 Jun 2024 11:53:07 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 11:53:07 +0000 (GMT)
Message-ID: <4f52b7a1-e289-4a55-ac2c-b3b453a73f30@linux.ibm.com>
Date: Tue, 11 Jun 2024 13:53:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 3/3] KVM: s390: don't setup dummy routing when
 KVM_CREATE_IRQCHIP
To: Sean Christopherson <seanjc@google.com>, Yi Wang <up2wing@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, foxywang@tencent.com, oliver.upton@linux.dev,
        maz@kernel.org, anup@brainfault.org, atishp@atishpatra.org,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
References: <20240506101751.3145407-1-foxywang@tencent.com>
 <20240506101751.3145407-4-foxywang@tencent.com> <ZmcnlPcplno-toU4@google.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <ZmcnlPcplno-toU4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rsPaGb5rD6UdPoFa-ruBIV7Sl-sTVwVc
X-Proofpoint-GUID: RjB1sVNrrivPZoReTF3WFZNKAQMBjY4z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=918
 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406110089



Am 10.06.24 um 18:19 schrieb Sean Christopherson:
> On Mon, May 06, 2024, Yi Wang wrote:
>> From: Yi Wang <foxywang@tencent.com>
>>
>> As we have setup empty irq routing in kvm_create_vm(), there's
>> no need to setup dummy routing when KVM_CREATE_IRQCHIP.
>>
>> Signed-off-by: Yi Wang <foxywang@tencent.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 9 +--------
>>   1 file changed, 1 insertion(+), 8 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 5147b943a864..ba7fd39bcbf4 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2998,14 +2998,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>   		break;
>>   	}
>>   	case KVM_CREATE_IRQCHIP: {
>> -		struct kvm_irq_routing_entry routing;
>> -
>> -		r = -EINVAL;
>> -		if (kvm->arch.use_irqchip) {
>> -			/* Set up dummy routing. */
>> -			memset(&routing, 0, sizeof(routing));
>> -			r = kvm_set_irq_routing(kvm, &routing, 0, 0);
>> -		}
>> +		r = 0;
> 
> This is wrong, KVM_CREATE_IRQCHIP should fail with -EINVAL if kvm->arch.use_irqchip
> is false.
> 
> There's also a functional change here, though I highly doubt it negatively affects
> userspace.  Nothing in s390 prevents invoking KVM_CREATE_IRQCHIP after
> KVM_SET_GSI_ROUTING, so userspace could very theoretically use KVM_CREATE_IRQCHIP
> to reset to empty IRQ routing.
> 
> Christian, if it works for you, I'll massage it to this when applying.

Oops. Yes please do so.

