Return-Path: <kvm+bounces-37877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD16A30F13
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:03:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F9373A8689
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679142512C7;
	Tue, 11 Feb 2025 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BJhbuZ83"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09B01F9ED2;
	Tue, 11 Feb 2025 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739286156; cv=none; b=roE/IaBj1KCAgm5zw22yPr91WKelCTzC0sTcza4YL8TxbOLCTD45cXWDMJxHV5YLqt0ATYd6TITh1oUha4zlO7SwuOPv7rOfWO0n01lANUIvA+kHcZW2iaFUD5cnBc8kkHFk1fhC0/Gpa41n+F+RPiNV0BqEN/JsGan1dSyvrFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739286156; c=relaxed/simple;
	bh=iU3UXr58kiiQAoh2LCXTPFFO47tqLfuoMZ4ANShnnhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAUAi6IZoXYNz+vbyRI+pSlLlLcYMnqLZpbmeJdnBlMEG7SLpTmt1sejBDewJq+r+rpjJXbGpSul7QwCAs7XuQ8ZwKE+2auQ9iVVmXFCQ90S73CrGLDc0F5Omc5+Ql18+uZQBNdJ7GqS3r3Keh6WUXEr0TSsUSKTSlf3riLmxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BJhbuZ83; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51BDxaJp021613;
	Tue, 11 Feb 2025 15:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XtVxv8
	uayeOQPpY2VGV3WMS8dQJbNqXyl/Qmv7QvjPg=; b=BJhbuZ83cDOxXmKrYstVCz
	9kVG3MwWtIKh/E+LT4/5k8JE779nPv7RxObbq3HHC4vWzqNff+F1b8rJ4nItPLv8
	+FqMjTuLfQxGJYoLuWGopyjb8hNjWyWKK3v9WhJ4xav0vdLOrQOt9pHkWGvwpVfj
	Afu8gmO0Be7ye+18iFxsUzxbh5yaEy+dI9rLAJvrJk9AFvRquthkFIfRQk17PhWk
	jC/0UHgwNH/OEfODcPuPQreo4nAtTqPd4fdWFgNoRqtagwavZt9zUjiCm4Y2Q2i7
	QafT6NZ1tnPfM8Z1E25BURt95EFkq4TJROG9xgzJZpU5wv9ATudwiNDPuyoMNQTQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44qwd1b4s3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 15:02:25 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51BEnmk1011677;
	Tue, 11 Feb 2025 15:02:24 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44pktjujjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 15:02:24 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51BF2N4b23462526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 15:02:23 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6B8658055;
	Tue, 11 Feb 2025 15:02:23 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2176158043;
	Tue, 11 Feb 2025 15:02:23 +0000 (GMT)
Received: from [9.12.79.21] (unknown [9.12.79.21])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Feb 2025 15:02:23 +0000 (GMT)
Message-ID: <e5ca9a2c-ec7d-4e0e-ad06-2d312b511b90@linux.ibm.com>
Date: Tue, 11 Feb 2025 10:02:22 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Anthony Krowiak <akrowiak@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
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
Content-Language: en-US
From: Rorie Reyes <rreyes@linux.ibm.com>
In-Reply-To: <Z6sDKeA6WzAgagiZ@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E-WnUjyJWL3aFF9DY6I6dNCAiQw_U9gy
X-Proofpoint-ORIG-GUID: E-WnUjyJWL3aFF9DY6I6dNCAiQw_U9gy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_06,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 spamscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502110100


On 2/11/25 2:58 AM, Alexander Gordeev wrote:
> On Thu, Feb 06, 2025 at 09:12:27AM -0500, Rorie Reyes wrote:
>
> Hi Rorie,
>
>> On 2/6/25 2:40 AM, Alexander Gordeev wrote:
>>> On Wed, Feb 05, 2025 at 12:47:55PM -0500, Anthony Krowiak wrote:
>>>>>> How this patch is synchronized with the mentioned QEMU series?
>>>>>> What is the series status, especially with the comment from Cédric
>>>>>> Le Goater [1]?
>>>>>>
>>>>>> 1. https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
> ...
>>>> I don't think that is what Alex was asking. I believe he is asking how the
>>>> QEMU and kernel patch series are going to be synchronized.
>>>> Given the kernel series changes a value in vfio.h which is used by QEMU, the
>>>> two series need to be coordinated since the vfio.h file
>>>> used by QEMU can not be updated until the kernel code is available. So these
>>>> two sets of code have
>>>> to be merged upstream during a merge window. which is different for the
>>>> kernel and QEMU. At least I think that is what Alex is asking.
>>> Correct.
>>> Thanks for the clarification, Anthony!
>> Tony, thank you for the back up!
>>
>> Alexander, is there anything else you need from my end for clarification?
> The original question still stays - is it safe to pull this patch now,
> before the corresponding QEMU change is integrated?
>
> Thanks!

If there are no other concerns from anyone else, and Tony is ok to sign 
off, then I would say it's safe to pull the patch.

I do have a v2 of my QEMU changes that need to be reviewed so it would 
probably ok to pull the kernel patches now.

QEMU v2 patches: [RFC PATCH v2 0/5] Report vfio-ap configuration changes

Unless someone else has any concerns with my kernal changes?

Thanks!


