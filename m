Return-Path: <kvm+bounces-40033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36DC8A4E102
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6A141889D27
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AB620A5F5;
	Tue,  4 Mar 2025 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RjblS/yI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6559920551D;
	Tue,  4 Mar 2025 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741098461; cv=none; b=RU/fZlvpxPfRwxnAGJvXGFRVpzYsVgzQFX+N4rjNdnqBVXru7Zb2+WxVe0ETrM5p/iksnUMYpSzWK6zTH7oaLDFXnwUdJZY7SVuXJlw+APUqxyLuFmDQv1FFrcLaf5hRWONKI9XI6hB+5rLfXext0O4bpw72SRPbjSHeLJqRSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741098461; c=relaxed/simple;
	bh=jL5unq9yErEo8MFJrjl8ofEg7uYG5FNHf00uFXTXyHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ze6Z64pTZ/kSocC7c2aDDfg4XuydraPbpOCKxNkWav/AwUk16+/cObygQk4/xqBvVg1HNGsjwpqb6JZ0tRznmjbPuQAlKkytJq44FRD2iYnhg8v7ImIx707RMR9h01/LrVctRCEGT9AFvkNVKc8TMZaHekgkozRuZERRGgawmwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RjblS/yI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524805xg026836;
	Tue, 4 Mar 2025 14:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HOWPQU
	NX7QomlPJQKK7TEaNAXDXHwcCY1bXmJ0RpVcg=; b=RjblS/yIsGZsrKlYx2X6uZ
	wuo566+ilsX2qS1l84R9Ylptesikhuz6rieBZZoK/+wTBpYp+QRc8yA8ZMS3743s
	ACEx6ASrGHTICgdMy9aDH+dtPvYfZVQP5MKNN/k0bprcOsAc4qRtHZXINKFu/TVh
	vfDVSTymzhnX5rQYS1jCTduNJON0AmZegVDSGSO1GDWmwsE4sSEFLwyqwz+fmAX6
	URycRK+STrocHnGk5w3UQZSbuj52pKzplCNd8eRdRsEDILjnuCZwaT/iCnFc7GAH
	dWT7uTrPyoK4PiSyoRRMmtL7fqE8axkIM4zN0pmz5eS67MXttIictxB+boSM/kNw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455kkpcbqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 14:27:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524AkF7L032216;
	Tue, 4 Mar 2025 14:27:08 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 454cjsx0ga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 14:27:08 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524ER6RF16843458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 14:27:06 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 73C9E58052;
	Tue,  4 Mar 2025 14:27:06 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79BBD58056;
	Tue,  4 Mar 2025 14:27:05 +0000 (GMT)
Received: from [9.61.107.75] (unknown [9.61.107.75])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 14:27:05 +0000 (GMT)
Message-ID: <d5308330-23f3-4f55-836c-0c6e884587b0@linux.ibm.com>
Date: Tue, 4 Mar 2025 09:27:05 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1] fixup! s390/vfio-ap: Notify userspace that guest's
 AP config changed when mdev removed
To: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
References: <20250303191158.49317-1-rreyes@linux.ibm.com>
 <4bf76371-43ea-4c1a-8a7f-500b0b0195b6@linux.ibm.com>
 <d8b34b34-1776-4bd9-bbde-8fe508166dfd@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <d8b34b34-1776-4bd9-bbde-8fe508166dfd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cWjAk7cCCobmfzFEcUtTtrQT-2HAvflo
X-Proofpoint-ORIG-GUID: cWjAk7cCCobmfzFEcUtTtrQT-2HAvflo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_06,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503040118




On 3/4/25 9:18 AM, Rorie Reyes wrote:
>
>
> On 3/4/25 8:36 AM, Anthony Krowiak wrote:
>>>     static void vfio_ap_mdev_update_guest_apcb(struct ap_matrix_mdev 
>>> *matrix_mdev)
>>> @@ -1870,7 +1870,6 @@ static void vfio_ap_mdev_unset_kvm(struct 
>>> ap_matrix_mdev *matrix_mdev)
>>>           get_update_locks_for_kvm(kvm);
>>>             kvm_arch_crypto_clear_masks(kvm);
>>> -        signal_guest_ap_cfg_changed(matrix_mdev);
>>>           vfio_ap_mdev_reset_queues(matrix_mdev);
>>>           kvm_put_kvm(kvm);
>>>           matrix_mdev->kvm = NULL;
>>> @@ -2057,6 +2056,14 @@ static void vfio_ap_mdev_request(struct 
>>> vfio_device *vdev, unsigned int count)
>>>         matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
>>>   +    if (matrix_mdev->kvm) {
>>> +        get_update_locks_for_kvm(matrix_mdev->kvm);
>>
>> I know we talked about this prior to submission of this patch, but 
>> looking at this again I think
>> you should use the get_update_locks_for_mdev() function for two reasons:
>>
>> 1. It is safer because it will take the matrix_dev->guests_lock which 
>> will prevent the matrix_mdev->kvm
>>     field from changing before you check it
>>
> So I'll replace *get_update_locks_for_kvm(matrix_mdev->kvm)* with 
> *get_update_locks_for_mdev(&matrix_dev->guests_lock)*

See code below:get_update_locks_for_mdev(matrix_mdev)
That function will take the guests_lock

>> 2. I will eliminate the need for the else
>>
>> get_update_locks_for_mdev(matrix_mdev)
>> if (matrix_mdev->kvm) {
>>     clear the masks
>>     signal guest config changed
>> }
>> ...
>> release_update_locks_for_mdev(matrix_mdev); Sorry about not seeing 
>> this before you posted this patch.
>>> + kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>> +        signal_guest_ap_cfg_changed(matrix_mdev);
>>> +    } else {
>>> +        mutex_lock(&matrix_dev->mdevs_lock);
>>> +    }
> So remove the else statement that contains the mutex function


