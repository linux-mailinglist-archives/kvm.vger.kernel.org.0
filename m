Return-Path: <kvm+bounces-16721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 375308BCD04
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 554CA1C20FAE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCA3143738;
	Mon,  6 May 2024 11:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HfAknvpI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75BC8493;
	Mon,  6 May 2024 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714995793; cv=none; b=d5b3jFGU5YBojZnwsZWS295w7RoQ+Eqenu8MVikmrcFkfZU0JqerzZdQhI+bIFExSaA6PgXv6XeKan0hhbmSCcBAqitOi7xQ2OD1D49GrKGYh/vnJ8BnUPeoOsZ147ycCH98jdMhx2ASPZvfS8DFb9d/Dc9rJ4EOCJL6SFGByDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714995793; c=relaxed/simple;
	bh=ZnWho8O6CZwmGdd/PoDJp4xFmkWqTSgehRiVSUyT19c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fXB8mldx9DJobDr/hZZhYOq438ZOfd/T3x8o/jiOwtLxE6i1gJAA2lD7n2KKd+u/Kkg+B1r1xULslI+369OP/w2vSEhJEvpltqP+tGwXTUH8PSK+I2a3wlVXjk3Qs66taZEdSOsQqVFcimHHu5HWupel0RwT/G3ZjIe9fusRcxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HfAknvpI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446B3dcP014160;
	Mon, 6 May 2024 11:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rgytEsbWqNR1bCJjGShVMzO/ql3G5tfwhj/K0Hlq5D4=;
 b=HfAknvpIlJYMnNKpBaiclkrJNtAecNT+hosdEaJB6bC6bIQl3ci5jvGxsJ1UNSyk1Rfo
 p6zHOlOM46APBC5inKh95vuui4lZWUmDYHbfN53ACnxg4oUBmlTPzZP4ieU9K4+cDyEm
 JmbHNhiDaNyoQmw/kLL6u30l+f3CokQQhD79XgQEYOEiILO6NY5PXgO43upVxJuq4VUj
 VEzyFu4TH2acFso+840Z4GVg3xNQbNPQSzU6+M3iFyxoUaPIZ6G8ay11ttYma227ZIPW
 MfdGUENWIiTc82q/45mKNXC+Dtmy05Zr+cdwCYN0HywZjN7iiX0aJgRlV1YCoplWl1P0 /A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xxx0eg2xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 11:42:07 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Bg63X005783;
	Mon, 6 May 2024 11:42:06 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xxx0eg2xb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 11:42:06 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446B7jXa004998;
	Mon, 6 May 2024 11:42:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx5ygx911-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 11:42:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446Bg09a54264182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 11:42:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54FF12004F;
	Mon,  6 May 2024 11:42:00 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BC262004E;
	Mon,  6 May 2024 11:41:59 +0000 (GMT)
Received: from [9.171.11.27] (unknown [9.171.11.27])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 11:41:59 +0000 (GMT)
Message-ID: <04255fea-c54b-4433-a488-069a86b69cfc@linux.ibm.com>
Date: Mon, 6 May 2024 13:41:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 1/3] KVM: setup empty irq routing when create vm
To: Yi Wang <up2wing@gmail.com>, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, foxywang@tencent.com, oliver.upton@linux.dev,
        maz@kernel.org, anup@brainfault.org, atishp@atishpatra.org,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
References: <20240506101751.3145407-1-foxywang@tencent.com>
 <20240506101751.3145407-2-foxywang@tencent.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240506101751.3145407-2-foxywang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T8lHiEttOGkYxWgiLoyVeExgr-RHk7PM
X-Proofpoint-GUID: TaNWE3iuEiNxaIRg6K9Fk9TFeJEIiZKk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_07,2024-05-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=923
 spamscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060080



Am 06.05.24 um 12:17 schrieb Yi Wang:
> From: Yi Wang <foxywang@tencent.com>
> 
> Add a new function to setup empty irq routing in kvm path, which
> can be invoded in non-architecture-specific functions. The difference
> compared to the kvm_setup_empty_irq_routing() is this function just
> alloc the empty irq routing and does not need synchronize srcu, as
> we will call it in kvm_create_vm().
> 
> Using the new adding function, we can setup empty irq routing when
> kvm_create_vm(), so that x86 and s390 no longer need to set
> empty/dummy irq routing when creating an IRQCHIP 'cause it avoid
> an synchronize_srcu.
> 
> Signed-off-by: Yi Wang <foxywang@tencent.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   include/linux/kvm_host.h |  2 ++
>   virt/kvm/irqchip.c       | 23 +++++++++++++++++++++++
>   virt/kvm/kvm_main.c      |  9 ++++++++-
>   3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 48f31dcd318a..a5f12b667ca5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2100,6 +2100,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   			const struct kvm_irq_routing_entry *entries,
>   			unsigned nr,
>   			unsigned flags);
> +int kvm_init_irq_routing(struct kvm *kvm);
>   int kvm_set_routing_entry(struct kvm *kvm,
>   			  struct kvm_kernel_irq_routing_entry *e,
>   			  const struct kvm_irq_routing_entry *ue);
> @@ -2108,6 +2109,7 @@ void kvm_free_irq_routing(struct kvm *kvm);
>   #else
>   
>   static inline void kvm_free_irq_routing(struct kvm *kvm) {}
> +int kvm_init_irq_routing(struct kvm *kvm) {}
>   
>   #endif
>   
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 1e567d1f6d3d..ec1fda7fffea 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -237,3 +237,26 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   
>   	return r;
>   }
> +
> +/*
> + * Alloc empty irq routing.
> + * Called only during vm creation, because we don't synchronize_srcu here.
> + */
> +int kvm_init_irq_routing(struct kvm *kvm)
> +{
> +	struct kvm_irq_routing_table *new;
> +	int chip_size;
> +
> +	new = kzalloc(struct_size(new, map, 1), GFP_KERNEL_ACCOUNT);
> +	if (!new)
> +		return -ENOMEM;
> +
> +	new->nr_rt_entries = 1;
> +
> +	chip_size = sizeof(int) * KVM_NR_IRQCHIPS * KVM_IRQCHIP_NUM_PINS;
> +	memset(new->chip, -1, chip_size);
> +
> +	RCU_INIT_POINTER(kvm->irq_routing, new);
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ff0a20565f90..4100ebdd14fe 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1233,6 +1233,11 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   		goto out_err_no_irq_srcu;
>   
>   	refcount_set(&kvm->users_count, 1);
> +
> +	r = kvm_init_irq_routing(kvm);
> +	if (r)
> +		goto out_err_no_irq_routing;
> +
>   	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
>   		for (j = 0; j < 2; j++) {
>   			slots = &kvm->__memslots[i][j];
> @@ -1308,9 +1313,11 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   out_err_no_disable:
>   	kvm_arch_destroy_vm(kvm);
>   out_err_no_arch_destroy_vm:
> -	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>   	for (i = 0; i < KVM_NR_BUSES; i++)
>   		kfree(kvm_get_bus(kvm, i));
> +	kvm_free_irq_routing(kvm);
> +out_err_no_irq_routing:
> +	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>   	cleanup_srcu_struct(&kvm->irq_srcu);
>   out_err_no_irq_srcu:
>   	cleanup_srcu_struct(&kvm->srcu);

