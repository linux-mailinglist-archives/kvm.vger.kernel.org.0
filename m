Return-Path: <kvm+bounces-16722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B108BCD18
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EF281F210AD
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A0214386A;
	Mon,  6 May 2024 11:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bt0Ema8W"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB94142E84;
	Mon,  6 May 2024 11:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714996008; cv=none; b=P6RKSi4eB2RCcGOpI7hi/uLm89pprF+QA1SDiJdbY8X+czIs4OcsNkpFsYN8CKyZCUkWMq3KCb6GrnxxF1Wiq4FCKSq1KuGPqrIYbMsTzL/L/xOEV/Y4M639XFjGp0H/9xBF8tCHf2YVqOopx+nr/5BY9IxYIH9HjPU5y+SX2Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714996008; c=relaxed/simple;
	bh=8gm94IPzY1EllvpEzmwfNcxaM9/OizDp+WJ8cyXqxqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qocmFeYRq8Oox4aj2Xm5qukdmgGykZZp5VSdgdisKo8eWOm2mCkBokOixK2WHvwvxZQ5igetoLZeehexS1JRuf1wZAW8N8OihwQuwhwJko2xLCq35XQDFmBU/ZzFEYbRWRQKEBU5d0RawJ0f055oZmJgK4czq+f3b2RjNDa8AGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bt0Ema8W; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446AtZSO009763;
	Mon, 6 May 2024 11:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ssVYx8DFLRCYEqKw7BBLusisPSbLDkbjoF3ZQ+pP1Lo=;
 b=bt0Ema8W6jNpuPBPkfC0ojbVdvYrny4j6YLC96b7XN3XfeuVhTTsY4u+ljVeERXNYQQR
 1DU+YMQXDv85IbpJrd7EQ1EtB9T9qUdKo1tO/IsjYPsi0ypv8AipivCm6tOICYlFe1Ac
 05APv1DpmN7fsZpz042FuoOQv6XPIZ+wGlph17d9gRajHm9FIuDLKOMocL0HhnncQNZe
 EHohrx977i79z11KsoXe72MvEzX/2zekillafRwzcSMJ0ldh/wxCm1CbiqgGcMzImcu2
 DMcNEE+wkPpUCN11kuOK2nv/Jj3Dc+0darIwb65T6//ABMhvPuiZpkA+jNQsjmBtkHEd Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xxw8pg5tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 11:46:04 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Bk4Zb022505;
	Mon, 6 May 2024 11:46:04 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xxw8pg5sy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 11:46:04 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446BfBst030855;
	Mon, 6 May 2024 11:42:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xwybtqw2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 11:42:18 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446BgCIt50987286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 11:42:14 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0C4220040;
	Mon,  6 May 2024 11:42:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7ACF2004F;
	Mon,  6 May 2024 11:42:11 +0000 (GMT)
Received: from [9.171.11.27] (unknown [9.171.11.27])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 11:42:11 +0000 (GMT)
Message-ID: <5f586a9e-2982-497a-8674-cd788f2e8308@linux.ibm.com>
Date: Mon, 6 May 2024 13:42:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 3/3] KVM: s390: don't setup dummy routing when
 KVM_CREATE_IRQCHIP
To: Yi Wang <up2wing@gmail.com>, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, foxywang@tencent.com, oliver.upton@linux.dev,
        maz@kernel.org, anup@brainfault.org, atishp@atishpatra.org,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
References: <20240506101751.3145407-1-foxywang@tencent.com>
 <20240506101751.3145407-4-foxywang@tencent.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240506101751.3145407-4-foxywang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -3rVY9e6HKMibw3KM8wRM2As9cVhC9ek
X-Proofpoint-ORIG-GUID: A5QC-S3BEL0a3wBsNlOlErSe1WfvT42r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_07,2024-05-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060081



Am 06.05.24 um 12:17 schrieb Yi Wang:
> From: Yi Wang <foxywang@tencent.com>
> 
> As we have setup empty irq routing in kvm_create_vm(), there's
> no need to setup dummy routing when KVM_CREATE_IRQCHIP.
> 
> Signed-off-by: Yi Wang <foxywang@tencent.com>

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> ---
>   arch/s390/kvm/kvm-s390.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5147b943a864..ba7fd39bcbf4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2998,14 +2998,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   		break;
>   	}
>   	case KVM_CREATE_IRQCHIP: {
> -		struct kvm_irq_routing_entry routing;
> -
> -		r = -EINVAL;
> -		if (kvm->arch.use_irqchip) {
> -			/* Set up dummy routing. */
> -			memset(&routing, 0, sizeof(routing));
> -			r = kvm_set_irq_routing(kvm, &routing, 0, 0);
> -		}
> +		r = 0;
>   		break;
>   	}
>   	case KVM_SET_DEVICE_ATTR: {

