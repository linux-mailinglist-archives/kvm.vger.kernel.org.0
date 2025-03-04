Return-Path: <kvm+bounces-40035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF78AA4E106
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7CC717C788
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AD424CEE1;
	Tue,  4 Mar 2025 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IGgGnYiv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46623209677;
	Tue,  4 Mar 2025 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741098577; cv=none; b=sp2xOfFF8X0TWP08TpPM8MCSg+m9SxEZqozOR9RmTwTQitKufmKcF/+atMvsYcK97CPl8EyudRO+OcmLfKiNFZoC3uPlJ8VpiMRw0/SvsO3fFtuZImUwaXsG9BYosKIPZJ72i6cizjWlMrFBrKDMsfjp7zPjlL3cSUiD/OactDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741098577; c=relaxed/simple;
	bh=sRleM5i9+imnSNNtlP0rnRld4FeupSLxMKXqWikcqfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dv9z9Jfi7kSLl3ZT0L0zjgiejMTvtfUqrTK92PuaE6uyjr23Mrya1eInBofvVTquiFGpyKiBhxGUd/fwDHy6jC6v3wH9Cc7/vmhH+iLwfNzPxhd/8nJIxoESE2y72IbSnxbrjCr1jToirW8/Nzgtw2n7WVZcVZHax9XghPdVvBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IGgGnYiv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524E3Jx5018993;
	Tue, 4 Mar 2025 14:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CoyLMz
	q7f68ni1KSj9q2zqo4jj4SD/mBR1J2ilCNiqQ=; b=IGgGnYivfeychtAGYZpHQZ
	CMQS2Hn4vqCSD6hW26s0N6kl+Yr9na3WqGmEX0qQvUPdPJzhIq1VBAuaRIBwRn3m
	vZEdrVmtVGxNbHq1qTs5x/U9EhsQdsKdmYH2ivx9aosatRMb9jJCiA24TpBJiCUR
	e+FunNTDfcerurI7m0Dfe2mViTbXxKNfYwool2abyTvh//IxbXRpMsGBX1OKjy19
	bohgqUY3PmXQkKZHPXGxQlxFpW94GEpCbsinCZ8l6Y6HnOkK0tQVTDNALetDTSUI
	9wmpxMmBkDEPH72l7/RGKg6fzCa+7zOPaWhWmM7oisQl7FzIBWw+RAC1tXgRB8Fg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4562xpg403-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 14:29:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524CIFlK013743;
	Tue, 4 Mar 2025 14:29:32 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 454e2knpvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 14:29:32 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524ETUvv20841190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 14:29:31 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B80E458053;
	Tue,  4 Mar 2025 14:29:30 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C16B05805D;
	Tue,  4 Mar 2025 14:29:29 +0000 (GMT)
Received: from [9.61.254.150] (unknown [9.61.254.150])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 14:29:29 +0000 (GMT)
Message-ID: <48221e73-4ea2-4b23-aa7d-53f485e42b12@linux.ibm.com>
Date: Tue, 4 Mar 2025 09:29:29 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1] fixup! s390/vfio-ap: Notify userspace that guest's
 AP config changed when mdev removed
To: Anthony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
References: <20250303191158.49317-1-rreyes@linux.ibm.com>
 <4bf76371-43ea-4c1a-8a7f-500b0b0195b6@linux.ibm.com>
 <d8b34b34-1776-4bd9-bbde-8fe508166dfd@linux.ibm.com>
 <d5308330-23f3-4f55-836c-0c6e884587b0@linux.ibm.com>
Content-Language: en-US
From: Rorie Reyes <rreyes@linux.ibm.com>
In-Reply-To: <d5308330-23f3-4f55-836c-0c6e884587b0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fSDRrBtSSzkKgpTP-t4tzSrjeL5n-OgU
X-Proofpoint-GUID: fSDRrBtSSzkKgpTP-t4tzSrjeL5n-OgU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_06,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503040118


On 3/4/25 9:27 AM, Anthony Krowiak wrote:
>
>
>
> On 3/4/25 9:18 AM, Rorie Reyes wrote:
>>
>>
>> On 3/4/25 8:36 AM, Anthony Krowiak wrote:
>>>>     static void vfio_ap_mdev_update_guest_apcb(struct 
>>>> ap_matrix_mdev *matrix_mdev)
>>>> @@ -1870,7 +1870,6 @@ static void vfio_ap_mdev_unset_kvm(struct 
>>>> ap_matrix_mdev *matrix_mdev)
>>>>           get_update_locks_for_kvm(kvm);
>>>>             kvm_arch_crypto_clear_masks(kvm);
>>>> -        signal_guest_ap_cfg_changed(matrix_mdev);
>>>>           vfio_ap_mdev_reset_queues(matrix_mdev);
>>>>           kvm_put_kvm(kvm);
>>>>           matrix_mdev->kvm = NULL;
>>>> @@ -2057,6 +2056,14 @@ static void vfio_ap_mdev_request(struct 
>>>> vfio_device *vdev, unsigned int count)
>>>>         matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
>>>>   +    if (matrix_mdev->kvm) {
>>>> +        get_update_locks_for_kvm(matrix_mdev->kvm);
>>>
>>> I know we talked about this prior to submission of this patch, but 
>>> looking at this again I think
>>> you should use the get_update_locks_for_mdev() function for two 
>>> reasons:
>>>
>>> 1. It is safer because it will take the matrix_dev->guests_lock 
>>> which will prevent the matrix_mdev->kvm
>>>     field from changing before you check it
>>>
>> So I'll replace *get_update_locks_for_kvm(matrix_mdev->kvm)* with 
>> *get_update_locks_for_mdev(&matrix_dev->guests_lock)*
>
> See code below:get_update_locks_for_mdev(matrix_mdev)
> That function will take the guests_lock
>
Ah ok, I see now. I'll make those changes. Thank you!
>>> 2. I will eliminate the need for the else
>>>
>>> get_update_locks_for_mdev(matrix_mdev)
>>> if (matrix_mdev->kvm) {
>>>     clear the masks
>>>     signal guest config changed
>>> }
>>> ...
>>> release_update_locks_for_mdev(matrix_mdev); Sorry about not seeing 
>>> this before you posted this patch.
>>>> + kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>>> +        signal_guest_ap_cfg_changed(matrix_mdev);
>>>> +    } else {
>>>> +        mutex_lock(&matrix_dev->mdevs_lock);
>>>> +    }
>> So remove the else statement that contains the mutex function
>

