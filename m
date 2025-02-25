Return-Path: <kvm+bounces-39106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB1FA43FC8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A38053B64E5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 12:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1D5268C72;
	Tue, 25 Feb 2025 12:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="je5JKm3C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4316267AE1;
	Tue, 25 Feb 2025 12:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740488189; cv=none; b=Ayq02xfWtmfhCF/Z2SfKW4o942QwUSpxunWLVqGkQufEH/c7CDekM6ztCNw79cibGLYlu2T4VT/dDMAWF97B64lNE97I2BQ/pwFMhkikmBwkoZGlBCjEgpEDd64lWGXQiS4RKUTkDNB0HFGqgKMM7xPi9DtGB9FrTiG5IvctLdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740488189; c=relaxed/simple;
	bh=0oT5shLnbtbhNDJ7D3AgCbSwDUFlzk9PgtUkpEfpxPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+GcWjTO5XKFgMbG5HUkoxoh0QgLg1TdnnFHvuKJUzXVEUooecDWvUT9o0hUHvxvTcdUbXHtxfi3CTRjOgRhrwLDUnx+k6mJf1uY96joJF+A9G9nBgiEfQgbTQ4QasA1iX9tAyO5nsYgCJYEz0tCRVDcv/ieKnH+bVuGvRwX5Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=je5JKm3C; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PCY3Vn011208;
	Tue, 25 Feb 2025 12:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=piYoMX
	DdaY+TU9E18vFRAcZoLdOWB0ePhiobWmf10uk=; b=je5JKm3Cvt4SNBH4kt6GCP
	BCergyn9VoVVqo5edSKmjdIWLh5J9rIrPSSMcAKuo8pM2PGrhiIARIKNEBcIXU5z
	qBw643xPXKH8jxVRBuCnzUJ/KyOXArBHZY024u0iXMYbTIqpTeWmA9wFEAa5zQ2H
	9dX1EZvwrI5Py/j6YOx9gjXu0rUVGxvPRw85jXI1AYaCWI/1YTi7M3HEmrb15rrI
	kFHsIyhD99qQIeErhJnINUqHVPFTX6qijSLqy8a+ivlII1Z5KWIJhnFt2NvVbWgg
	fzxoL/y+xeYesfNYYNKI4YxZqbtIt5Auy4TPoQp2SJFUENYZaFuxSOnU1FXCQa/A
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4513x9twsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 12:56:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51PBRO59002545;
	Tue, 25 Feb 2025 12:56:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yu4jmn38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 12:56:13 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51PCuA8i11338002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 12:56:10 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CBB020040;
	Tue, 25 Feb 2025 12:56:10 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C6BC2004B;
	Tue, 25 Feb 2025 12:56:10 +0000 (GMT)
Received: from [9.152.224.140] (unknown [9.152.224.140])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Feb 2025 12:56:09 +0000 (GMT)
Message-ID: <5ac2dda6-a9ac-449a-bb7c-0f9eb90614f5@linux.ibm.com>
Date: Tue, 25 Feb 2025 13:56:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: s390: Don't use %pK through debug printing
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250217-restricted-pointers-s390-v1-0-0e4ace75d8aa@linutronix.de>
 <20250217-restricted-pointers-s390-v1-2-0e4ace75d8aa@linutronix.de>
From: Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20250217-restricted-pointers-s390-v1-2-0e4ace75d8aa@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _mwJdslvPc5QLXsfDPi8-Q7J-DAJwtjM
X-Proofpoint-GUID: _mwJdslvPc5QLXsfDPi8-Q7J-DAJwtjM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_04,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=944 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502100000 definitions=main-2502250088



On 17.02.25 14:13, Thomas Weißschuh wrote:
> Restricted pointers ("%pK") are only meant to be used when directly
> printing to a file from task context.
> Otherwise it can unintentionally expose security sensitive,
> raw pointer values.
> 
> Use regular pointer formatting instead.
> 
> Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>


I sucessfully ran our test suite after applying this patch.

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Tested-by: Michael Mueller <mimu@linux.ibm.com>

> ---
>   arch/s390/kvm/intercept.c |  2 +-
>   arch/s390/kvm/interrupt.c |  8 ++++----
>   arch/s390/kvm/kvm-s390.c  | 10 +++++-----
>   3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 610dd44a948b22945b0a35b760ded64bd44ef7cb..a06a000f196ce0066bfd21b0d914492a1796819a 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -95,7 +95,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
>   
>   	vcpu->stat.exit_validity++;
>   	trace_kvm_s390_intercept_validity(vcpu, viwhy);
> -	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
> +	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%p)", viwhy,
>   		  current->pid, vcpu->kvm);
>   
>   	/* do not warn on invalid runtime instrumentation mode */
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 07ff0e10cb7f5c0294bf85f1d65d1eb124698705..c0558f05400732b2fe6911c1ef58f86b62364770 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3161,7 +3161,7 @@ void kvm_s390_gisa_clear(struct kvm *kvm)
>   	if (!gi->origin)
>   		return;
>   	gisa_clear_ipm(gi->origin);
> -	VM_EVENT(kvm, 3, "gisa 0x%pK cleared", gi->origin);
> +	VM_EVENT(kvm, 3, "gisa 0x%p cleared", gi->origin);
>   }
>   
>   void kvm_s390_gisa_init(struct kvm *kvm)
> @@ -3178,7 +3178,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>   	gi->timer.function = gisa_vcpu_kicker;
>   	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
>   	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
> -	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
> +	VM_EVENT(kvm, 3, "gisa 0x%p initialized", gi->origin);
>   }
>   
>   void kvm_s390_gisa_enable(struct kvm *kvm)
> @@ -3219,7 +3219,7 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>   		process_gib_alert_list();
>   	hrtimer_cancel(&gi->timer);
>   	gi->origin = NULL;
> -	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
> +	VM_EVENT(kvm, 3, "gisa 0x%p destroyed", gisa);
>   }
>   
>   void kvm_s390_gisa_disable(struct kvm *kvm)
> @@ -3468,7 +3468,7 @@ int __init kvm_s390_gib_init(u8 nisc)
>   		}
>   	}
>   
> -	KVM_EVENT(3, "gib 0x%pK (nisc=%d) initialized", gib, gib->nisc);
> +	KVM_EVENT(3, "gib 0x%p (nisc=%d) initialized", gib, gib->nisc);
>   	goto out;
>   
>   out_unreg_gal:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ebecb96bacce7d75563bd3a130a7cc31869dc254..9e427ba3aed42edf617d6625b5bcaba8f43dc464 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1020,7 +1020,7 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
>   		}
>   		mutex_unlock(&kvm->lock);
>   		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
> -		VM_EVENT(kvm, 3, "New guest asce: 0x%pK",
> +		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
>   			 (void *) kvm->arch.gmap->asce);
>   		break;
>   	}
> @@ -3464,7 +3464,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   		kvm_s390_gisa_init(kvm);
>   	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
>   	kvm->arch.pv.set_aside = NULL;
> -	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
> +	KVM_EVENT(3, "vm 0x%p created by pid %u", kvm, current->pid);
>   
>   	return 0;
>   out_err:
> @@ -3527,7 +3527,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_s390_destroy_adapters(kvm);
>   	kvm_s390_clear_float_irqs(kvm);
>   	kvm_s390_vsie_destroy(kvm);
> -	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
> +	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
>   }
>   
>   /* Section: vcpu related */
> @@ -3648,7 +3648,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
>   
>   	free_page((unsigned long)old_sca);
>   
> -	VM_EVENT(kvm, 2, "Switched to ESCA (0x%pK -> 0x%pK)",
> +	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
>   		 old_sca, kvm->arch.sca);
>   	return 0;
>   }
> @@ -4025,7 +4025,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   			goto out_free_sie_block;
>   	}
>   
> -	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK",
> +	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%p, sie block at 0x%p",
>   		 vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
>   	trace_kvm_s390_create_vcpu(vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
>   
> 


