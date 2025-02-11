Return-Path: <kvm+bounces-37915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A87E1A3168C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 21:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B40E9188337B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 20:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA765263889;
	Tue, 11 Feb 2025 20:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ag8bOZsM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506151D8DF6;
	Tue, 11 Feb 2025 20:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739305455; cv=none; b=pYwMrAt47qfk7MfCOUe5cjxI4vnXEsub2xUl0pck6xxquPpJ3mi3ssC9Fq7umlc/IxDDJZGuWM8ITQCzBRkvQKdzQeX1OcrVsAMf+agKu57gw8VhoIMCA4yPudSxR3B3xawlO4QLeVlIIN8gCzmAOqvI7d2lLL+op8znXu8ZE14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739305455; c=relaxed/simple;
	bh=Ir2UudtV6I465P9Aa7pDJyhOnf4s7mtZg1nWmBWTRJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJuTnLf3g5jHCprYMJ8wwM6v29kUgaJt3kyE1PBsrGKQ+IERwUgmXFptWq4+lHT6gYz9tNbORUMIGtvMc2O+l0C9Lf1K8d+vcGjTz0ODuHtfInUrZoS5Oy5Tc9izZNdN+nGribqK8JuQs7SOqOnu/kju0M+l9PIe44jXnx49U98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ag8bOZsM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51BFdTFe020555;
	Tue, 11 Feb 2025 20:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=yDwtqZ
	R3wgrNCTyWYFInDho8NUYYvchbqe2t1EngQGo=; b=Ag8bOZsMuvoS0NMcwai3m+
	pHPY0RUasde4txUNfLlH6/7SitMJTUotXgGzjR5xAbN3a8L1Xo++IRP6B+opelJu
	+X8fI/k6zT94U0DMfIN+xDEDtSGVoFzxBYU5F62zXOJtBYNr/17jDKwzQ1WLGcA0
	97k9KTjymAJc0vNt2bKKJLc/TKsMT6CrEl79R7s6SzsxfvEEDkR87BIst8+FB5HL
	YGpE3I7pVhGJMR/tCnTXQdq7W2cUDuDTB/QvxYaFaPzyQb4D137XfCO2eOmzmsDT
	vLba1sGdYwoNjlY9vE+5TDCsYWC6CnSdQYDazlStydTZMflRWXfBZ1No6QQPvDlg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44r9cu9f9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 20:24:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51BI6Q4E011642;
	Tue, 11 Feb 2025 20:24:08 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44pktjvvee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 20:24:08 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51BKO7Pr35128062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 20:24:07 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B24D5805A;
	Tue, 11 Feb 2025 20:24:07 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 208CC58054;
	Tue, 11 Feb 2025 20:24:06 +0000 (GMT)
Received: from [9.61.140.79] (unknown [9.61.140.79])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Feb 2025 20:24:06 +0000 (GMT)
Message-ID: <8767c6ce-28cf-4e23-baf8-e6c9ec854c60@linux.ibm.com>
Date: Tue, 11 Feb 2025 15:24:05 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Rorie Reyes <rreyes@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, alex.williamson@redhat.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
 <f1af50b3-f966-445d-ab89-3d213f55b93a@linux.ibm.com>
 <Z6RnfwawWop0v1CW@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <02675184-0ce5-4f08-9d5d-f42987b77b5b@linux.ibm.com>
 <Z6sDKeA6WzAgagiZ@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <e5ca9a2c-ec7d-4e0e-ad06-2d312b511b90@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <e5ca9a2c-ec7d-4e0e-ad06-2d312b511b90@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2yBjJfi0Hs_7QlpoZV7hXrW8-fSlAiEA
X-Proofpoint-GUID: 2yBjJfi0Hs_7QlpoZV7hXrW8-fSlAiEA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_08,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 impostorscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502110130




On 2/11/25 10:02 AM, Rorie Reyes wrote:
>
> On 2/11/25 2:58 AM, Alexander Gordeev wrote:
>> On Thu, Feb 06, 2025 at 09:12:27AM -0500, Rorie Reyes wrote:
>>
>> Hi Rorie,
>>
>>> On 2/6/25 2:40 AM, Alexander Gordeev wrote:
>>>> On Wed, Feb 05, 2025 at 12:47:55PM -0500, Anthony Krowiak wrote:
>>>>>>> How this patch is synchronized with the mentioned QEMU series?
>>>>>>> What is the series status, especially with the comment from Cédric
>>>>>>> Le Goater [1]?
>>>>>>>
>>>>>>> 1. 
>>>>>>> https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
>> ...
>>>>> I don't think that is what Alex was asking. I believe he is asking 
>>>>> how the
>>>>> QEMU and kernel patch series are going to be synchronized.
>>>>> Given the kernel series changes a value in vfio.h which is used by 
>>>>> QEMU, the
>>>>> two series need to be coordinated since the vfio.h file
>>>>> used by QEMU can not be updated until the kernel code is 
>>>>> available. So these
>>>>> two sets of code have
>>>>> to be merged upstream during a merge window. which is different 
>>>>> for the
>>>>> kernel and QEMU. At least I think that is what Alex is asking.
>>>> Correct.
>>>> Thanks for the clarification, Anthony!
>>> Tony, thank you for the back up!
>>>
>>> Alexander, is there anything else you need from my end for 
>>> clarification?
>> The original question still stays - is it safe to pull this patch now,
>> before the corresponding QEMU change is integrated?

Alexander,

This patch has to be pulled before the QEMU patches are integrated. The 
change to the
include/uapi/linux/vfio.h file needs to be merged before the QEMU 
version of that file
can be generated for a QEMU build. I have given my r-b for this patch, 
so I think it is
safe to pull it now.


>>
>> Thanks!
>
> If there are no other concerns from anyone else, and Tony is ok to 
> sign off, then I would say it's safe to pull the patch.
>
> I do have a v2 of my QEMU changes that need to be reviewed so it would 
> probably ok to pull the kernel patches now.
>
> QEMU v2 patches: [RFC PATCH v2 0/5] Report vfio-ap configuration changes
>
> Unless someone else has any concerns with my kernal changes?
>
> Thanks!
>
>


