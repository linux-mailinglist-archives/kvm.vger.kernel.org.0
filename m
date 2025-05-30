Return-Path: <kvm+bounces-48081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1EBAC8929
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 09:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF0F016A7C5
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 07:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BDE20E32F;
	Fri, 30 May 2025 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AWBnHOO8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A650B1A0728;
	Fri, 30 May 2025 07:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748590786; cv=none; b=TetqeMW4fvSF7KCx+z+zp/WI+Cb/POvqNFfWSBkgnVBGf714MkU8CGu0fqbxg1GnCDR4NRhIOZCpmen3u0Ue1lYQggYunQ/86BUMD4n1Dih9Dltpyu4eSkVm/MJPEjp+eEcOdIF1Fz3o02dlerC1wafcvuPUW4jE/dc6QBYenNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748590786; c=relaxed/simple;
	bh=wB1SE95KN7NJHuM8MAkkQhq66vP7wmN6W0MbPCDarbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o1VFfAnaDb7q3oUgWsRaHxs5UrUXrmBlZuWypMWDYe61QSM4jS1ywDOQIzJ7wucWGARB1napNWN2kjR8geXV3Yj2pKpuovZil7Cgpk0gJQeUuVEDxWKM7NZ7tWqosXbsqbNzDheoOB/K3AAXFtjcfgy5OT9d3S9U0eCd9sKZfgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AWBnHOO8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54U3moaa025476;
	Fri, 30 May 2025 07:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BqFfgN
	VCREIIj9Mnd2DOPwtUGsL8Sf0vQL1t8Nt/4cg=; b=AWBnHOO8moonQCMhZo2Dgz
	A+ho15PnbvtE4f1PfcfmHZQb3MocCwM+3lBPgTy/XXskJBvwTB9eWyygA2l17M4b
	uK3Lr9SvpxF5j8/RFcIY+EQjZWa8r/ml0VAOAferELC2tEnUFVtD4gYNGnVeTAji
	gxH9xNQZ8v3xY90jQeTySfQXedHmHYYjIow9zTR0ao9xwJ9RUAwzSr2xG4HmJlyf
	ZLlWdToXlUHp1H/h9QL2wb0tIPyb/8yL0bHYaFEhzV/lPxbctg+01190qvVNEYhG
	Xs2GFj+gEUBOb0X7dXjpmCBUoBMKso+HRYACOlewzQdARfNdFeFLLiVK5MNy1PmQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40k25xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 May 2025 07:39:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54U6meBe030849;
	Fri, 30 May 2025 07:39:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46uru10eqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 May 2025 07:39:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54U7dZ6t26935870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 May 2025 07:39:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64EF02004B;
	Fri, 30 May 2025 07:39:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C487E20043;
	Fri, 30 May 2025 07:39:34 +0000 (GMT)
Received: from [9.111.57.132] (unknown [9.111.57.132])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 30 May 2025 07:39:34 +0000 (GMT)
Message-ID: <2b9f0a39-2a97-45ab-a59e-bba0e1e3b2f0@linux.ibm.com>
Date: Fri, 30 May 2025 09:39:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] KVM: s390: Set KVM_MAX_VCPUS to 256
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com>
 <20250522-rm-bsca-v3-1-51d169738fcf@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250522-rm-bsca-v3-1-51d169738fcf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=SdL3duRu c=1 sm=1 tr=0 ts=683960bc cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=t99LfBpkyTFO0i67b_EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Gxc3jkhqxxu33ty6JLajp9yWTIVLYHNs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTMwMDA2MiBTYWx0ZWRfX7lTbV55hRShX OtwnQTG4dapiDAQItYPMBXFEjmilQPk6H61kYNp3AjwCU3tzKaab4jl8b5DgEsRfWNlqVkpFTPI LUotv1XPZAx9M59OUgnHprBYaCvFVjecD/t5/v+8QMkkBHu3dEOnYl2g7oy38QAX4wInJ40iycG
 W4vckehjVsZ7b+YgqX8N6P7MN7BUpUsbAspZtMKpjMgQ6I/V2IIiIY35MbxcUJdu5AOMLzmN23f KpmpFELP5oBzpIabhpGww4y/gowukHgHM84VxenvhjL+YlyfY83QR5jODaeKp2CemoTc4HItIoK aOYwl1tQdlNo3GNAPPzEdSJXdds1zwAOhYD5n5cKXyh8ULnvgKRGUViJVuR2aTa4LBMCAaYJg2C
 yB7atsGivd3fGMjum4fimfsGSTvyjH9QfzY4YuOkW5rybOyAi6G0b6n0WPHrzbFiXqiO34pn
X-Proofpoint-ORIG-GUID: Gxc3jkhqxxu33ty6JLajp9yWTIVLYHNs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-30_03,2025-05-29_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 spamscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505300062

On 5/22/25 11:31 AM, Christoph Schlameuss wrote:
> The s390x architecture allows for 256 vCPUs with a max CPUID of 255.
> The current KVM implementation limits this to 248 when using the
> extended system control area (ESCA). So this correction should not cause
> any real world problems but actually correct the values returned by the
> ioctls:
> 
> * KVM_CAP_NR_VCPUS
> * KVM_CAP_MAX_VCPUS
> * KVM_CAP_MAX_VCPU_ID
> 
> KVM_MAX_VCPUS is also moved to kvm_host_types to allow using this in
> future type definitions.
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h       | 2 --
>   arch/s390/include/asm/kvm_host_types.h | 2 ++
>   arch/s390/kvm/kvm-s390.c               | 2 ++
>   3 files changed, 4 insertions(+), 2 deletions(-)

[...]

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 3f3175193fd7a7a26658eb2e2533d8037447a0b4..b65e4cbe67cf70a7d614607ebdd679060e7d31f4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -638,6 +638,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   			r = KVM_S390_ESCA_CPU_SLOTS;
>   		if (ext == KVM_CAP_NR_VCPUS)
>   			r = min_t(unsigned int, num_online_cpus(), r);
> +		else if (ext == KVM_CAP_MAX_VCPU_ID)
> +			r -= 1;

I went on a wild goose chase since this change broke the max vcpu 
selftest. Turns out that KVM_CAP_MAX_VCPU_ID is actually 
KVM_CAP_MAX_VCPU_ID_S_ but we can't rename it since it's part of the API 
(sigh). Have a look at the KVM changes and it will make a bit more sense.



