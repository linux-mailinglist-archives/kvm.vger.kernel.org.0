Return-Path: <kvm+bounces-37484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E88A2AAD1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BE881888D95
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 14:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC531FECB9;
	Thu,  6 Feb 2025 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o5tn02Wp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AAB1C6FE0;
	Thu,  6 Feb 2025 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738851155; cv=none; b=fF0PAXYuGHtlLdoCEIAa71G4tvw9319WNCaSzLkzU9Is3B6RethBOGi9Men4Ak6O1qmUwGBoPpTaFNd4Kq48yN+XtvzrO6mxxWCcbcEk/iYDsay8Qo632HvhIf5v0lr6okk857Wc9oglLogCNo5rxE8443HDPn987BiIZhe6g1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738851155; c=relaxed/simple;
	bh=f9xA7XWmR1We7sDj+xor/lbZ7RmI0r/FRir2tEAOjkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DCAWYz2eNIhplzkcpQqyQenZGz9ERZdCpFnx+yXlpVk5YviHPIbVNQRmaEU+4k5ItFbkU+shF8Gwxht5xZ54H6hrqQsYI+J5lNpQxPK1DkT4rb7ps4CiWYtDdAKBCmALAGiNO6CL7mpUKMR7Z2hs4lw/MbfNrg8mWlPWqlh7uFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o5tn02Wp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 516C7a0v024426;
	Thu, 6 Feb 2025 14:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=f9xA7X
	WmR1We7sDj+xor/lbZ7RmI0r/FRir2tEAOjkA=; b=o5tn02Wp3wpRVP9tx40Cnr
	nh/1KQgf57b5pIRO0uH27Icpe4p3w9hEKLph+BfWKNZJ9Tce2eX3QR6lKuKit86P
	C1ohyOs+WOevlDZ4wFzHcnp1NL42oRsCWuRTES0P8Ke9DnY5YuV+g55ZWNmLc2yB
	8RvI6fatvtNB/y6XlyPBhtk7CKcd+VzztlobCn44f9sc6Q18PL9cGYH2lFqnw+0O
	cL4GsR/v8BRxDmxtrQhbrTSllU5eW5cZOLSIC3WpOQapdsfUD6/JfmRTC5WQSi8o
	vFHbyxjQIk+c3ipBNfQlq+wSr7yTj8EfswReMszUqCy8/dAN0gQbRJtUPdTYcJLQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44mattdwru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 14:12:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 516AgmWg007127;
	Thu, 6 Feb 2025 14:12:30 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxayxs6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 14:12:30 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 516ECTLj22938308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 14:12:29 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5556B58062;
	Thu,  6 Feb 2025 14:12:29 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 558A358055;
	Thu,  6 Feb 2025 14:12:28 +0000 (GMT)
Received: from [9.61.248.214] (unknown [9.61.248.214])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Feb 2025 14:12:28 +0000 (GMT)
Message-ID: <02675184-0ce5-4f08-9d5d-f42987b77b5b@linux.ibm.com>
Date: Thu, 6 Feb 2025 09:12:27 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Anthony Krowiak <akrowiak@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, alex.williamson@redhat.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
 <f1af50b3-f966-445d-ab89-3d213f55b93a@linux.ibm.com>
 <Z6RnfwawWop0v1CW@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Language: en-US
From: Rorie Reyes <rreyes@linux.ibm.com>
In-Reply-To: <Z6RnfwawWop0v1CW@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dypPC_fK1VqygqcN5e7E83RU4fwU1aQ9
X-Proofpoint-ORIG-GUID: dypPC_fK1VqygqcN5e7E83RU4fwU1aQ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_03,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502060115


On 2/6/25 2:40 AM, Alexander Gordeev wrote:
> On Wed, Feb 05, 2025 at 12:47:55PM -0500, Anthony Krowiak wrote:
>>>> How this patch is synchronized with the mentioned QEMU series?
>>>> What is the series status, especially with the comment from Cédric
>>>> Le Goater [1]?
>>>>
>>>> 1. https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
> ...
>>> Hey Alex, sorry for the long delay. This patch is synchronized with the
>>> QEMU series by registering an event notifier handler to process AP
>>> configuration
>>>
>>> change events. This is done by queuing the event and generating a CRW.
>>> The series status is currently going through a v2 RFC after implementing
>>> changes
>>>
>>> requested by Cedric and Tony.
>>>
>>> Let me know if there's anything else you're concerned with
>>>
>>> Thanks!
>> I don't think that is what Alex was asking. I believe he is asking how the
>> QEMU and kernel patch series are going to be synchronized.
>> Given the kernel series changes a value in vfio.h which is used by QEMU, the
>> two series need to be coordinated since the vfio.h file
>> used by QEMU can not be updated until the kernel code is available. So these
>> two sets of code have
>> to be merged upstream during a merge window. which is different for the
>> kernel and QEMU. At least I think that is what Alex is asking.
> Correct.
> Thanks for the clarification, Anthony!

Tony, thank you for the back up!

Alexander, is there anything else you need from my end for clarification?


