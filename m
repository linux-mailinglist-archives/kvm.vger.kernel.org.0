Return-Path: <kvm+bounces-5902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEE8828AA4
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 18:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D0D9285AA4
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12F53A8F1;
	Tue,  9 Jan 2024 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O1ANif+B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FB63A1C2;
	Tue,  9 Jan 2024 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 409Gs88L013291;
	Tue, 9 Jan 2024 17:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GL00We/Hj++zFV7T+/pO2MmICizRy/fFVj5pNPe+LG0=;
 b=O1ANif+BpBMG6dJ5AkY6O5NAAbwd8rMxFxrmCA30NWznd6Eqfts9MvxwnrBeiuI0mXf5
 Dk63jYwwnIZJRd8zWibDsUBEWVsD4PcefKTlt54a3HghlQOji6tV+GxZ5cEtb80qaQNd
 hJgLLCoVf4C7b5A6Pb5ChGbZMTeQN15Zxf5cVRF4F2cyGNPRDu7rfY+u0aNmjojSekLy
 UWcJqBXjl9IE132WKvpiNxhUvzechX68EJY0ay+s61XeYhiINjEEitExhPtmkQiCNjzW
 dVNhP8daT9tKyviJq0rK7ufKmh3Jy6bUacu4UvUzV/4+0mO24oiWF3+aLqrkSrRlea6q 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh9f11d25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 17:02:28 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 409Gbv77028529;
	Tue, 9 Jan 2024 17:02:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh9f11d1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 17:02:28 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 409GhI2N022952;
	Tue, 9 Jan 2024 17:02:27 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfj6nfvvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 17:02:27 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 409H2PfU41026230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jan 2024 17:02:26 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC56A5805D;
	Tue,  9 Jan 2024 17:02:25 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9157B58053;
	Tue,  9 Jan 2024 17:02:24 +0000 (GMT)
Received: from [9.61.76.57] (unknown [9.61.76.57])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Jan 2024 17:02:24 +0000 (GMT)
Message-ID: <24039c50-9079-4ca5-b7b0-867c64d70630@linux.ibm.com>
Date: Tue, 9 Jan 2024 12:02:23 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Content-Language: en-US
To: Halil Pasic <pasic@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com, kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
 <20231204131045.217586a3.pasic@linux.ibm.com>
 <7c0d0ad2-b814-47b1-80e9-28ad62af6476@linux.ibm.com>
 <20231204230529.07bf7b79.pasic@linux.ibm.com>
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20231204230529.07bf7b79.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EKTpzFenP7RQVItR8gAewm7M5tGDlGK2
X-Proofpoint-ORIG-GUID: FLQqTuYp54GV8gCG2C8IuFn5uHNLUNjs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-09_08,2024-01-09_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxlogscore=786 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2401090138


On 12/4/23 5:05 PM, Halil Pasic wrote:
> On Mon, 4 Dec 2023 12:51:49 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>> s/if\/when/at latest before/
>>>
>>> I would argue that some of the cleanups need to happen before even 01 is
>>> reflected...
>> To what cleanups are you referring?
> Event notification and interruption disablement for starters. Otherwise
> OS has no way to figure out when is GISA and NIB safe to deallocate.
> Those actions are part of the reset process. I.e. some of the reset stuff
> can be deferred at most until the queue is made accessible again, some
> not so much.


How do you propose we disable interrupts if the PQAP(AQIC) will likely 
fail with response code 01 which is the subject of this patch? Do you 
think we should not free up the AQIC resources as we do in this patch?


>   
>
> Regards,
> Halil

