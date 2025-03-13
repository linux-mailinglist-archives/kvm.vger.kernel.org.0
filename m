Return-Path: <kvm+bounces-40918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8751CA5F231
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 12:19:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43C6B1890E81
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 11:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7DA1D7984;
	Thu, 13 Mar 2025 11:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ax9II8Fu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8153526563B;
	Thu, 13 Mar 2025 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741864741; cv=none; b=dM6A+aaXCVrm8svT3bIrEaQ2qHPBIyMxWLlv/JXjSrR3z5gUNyCJR5czcru8fMcn2Bys2cBYzsLs0ujaMpx+07c5d7oVjNE3pCFdB7wz2orp7VVO3E7nZ3kEvjNnlUlcZ1FNXFAuntDoGiOuh2E6f50EfFEF6GsWengrf02FKRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741864741; c=relaxed/simple;
	bh=exJvKtRGcNtxJCGx3dcAmTVLZlX/d0FQIWwfznTTjj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ff4NRvxJrWLFOz2cESFjWkVLSVgx3Dew0cNoj8fzc6esqzJskRnBSTwBc0ZPxURsAEJc2RbMP38EkIGoeTgNj6Facr1bLNlrc7Oe1jIlTibzvVxNrqivTMsLDQapXQX8KdLkMtxIosMAZSHmpr9BXMwHMyjF8RvZIQpwOPp6AgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ax9II8Fu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D8RtsJ009903;
	Thu, 13 Mar 2025 11:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=030sz2
	TtLqOkQj6aFfSS41uI8Fof4nW8LclT1zGrP5I=; b=ax9II8FuyVkJEuEmEm384K
	PDvyET2yePVbUU/NacXu8uZqSy8naHEgZrQ4wwJg4w8DrNAdf4ewkmvcaMZwtvSl
	/xfoZaOaOiJs5vygDatkeO5DgHFG2P2dhkaK57YAvcfNhxvRMDIzmGdZNWSZdtx1
	Q5XcnBwJxo6qdRQUYhw0Td06U2sGboc66r2Vypdn83S+mBdJl1iDQI/ti5qm6RoO
	3vEQ7RJFWNYHbkS2fg4uZpS/Y+Z+KeNdXtbU3HGGUSZoh3a7gQ5aLxM30urPl3rP
	ut7wuPp0e5HEONoPhugfAFfufSJ20vQePTH0Lk1xUJU6MCppnjVL9TIuaBsThw8A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45bhg0bage-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 11:18:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52D8Vd2S003181;
	Thu, 13 Mar 2025 11:18:56 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 45atstser1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 11:18:56 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52DBItju22217366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 11:18:55 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6592158058;
	Thu, 13 Mar 2025 11:18:55 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86FB558057;
	Thu, 13 Mar 2025 11:18:54 +0000 (GMT)
Received: from [9.61.127.211] (unknown [9.61.127.211])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Mar 2025 11:18:54 +0000 (GMT)
Message-ID: <ff21c2cd-2999-4507-b5bc-26da5333e955@linux.ibm.com>
Date: Thu, 13 Mar 2025 07:18:54 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: lock mdev object when handling mdev remove
 request
To: Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@linux.ibm.com,
        alex.williamson@redhat.com, clg@redhat.com, stable@vger.kernel.org
References: <20250221153238.3242737-1-akrowiak@linux.ibm.com>
 <b763cd33-fb89-498a-841d-1a5423b7ef9b@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <b763cd33-fb89-498a-841d-1a5423b7ef9b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tbIH2omU48pJZLZxUWBWYAPMeXPIca9q
X-Proofpoint-ORIG-GUID: tbIH2omU48pJZLZxUWBWYAPMeXPIca9q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_05,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=919 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 phishscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503130087




On 3/12/25 11:19 AM, Matthew Rosato wrote:
> On 2/21/25 10:32 AM, Anthony Krowiak wrote:
>> The vfio_ap_mdev_request function in drivers/s390/crypto/vfio_ap_ops.c
>> accesses fields of an ap_matrix_mdev object without ensuring that the
>> object is accessed by only one thread at a time. This patch adds the lock
>> necessary to secure access to the ap_matrix_mdev object.
>>
>> Fixes: 2e3d8d71e285 ("s390/vfio-ap: wire in the vfio_device_ops request callback")
>> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
>> Cc: <stable@vger.kernel.org>
> The new code itself seems sane.
>
> But besides this area of code, there are 2 other paths that touch matrix_mdev->req_trigger:
>
> the one via vfio_ap_set_request_irq will already hold the lock via vfio_ap_mdev_ioctl (OK).

I have plans to create a patch to insert a call to lockdep_assert_held() 
in functions that require a lock,
such as the one you mentioned

>
> However the other one in vfio_ap_mdev_probe acquires mdevs_lock a few lines -after- initializing req_trigger and cfg_chg_trigger to NULL.  Should the lock also be held there since we would have already registered the vfio device above?  We might be protected by circumstance because we are in .probe() but I'm not sure, and we bother getting the lock already to protect mdev_list...

While it may have been reasonable to include the initialization of those 
fields inside the lock, it really isn't
necessary. These two fields are used to signal events to userspace, so 
these fields will not be used until the
mdev - which is in the process of being created - is attached to a guest 
and the VFIO_DEVICE_SET_IRQS ioctl
is subsequently invoked.

>


