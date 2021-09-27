Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A154A419022
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 09:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhI0HoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 03:44:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9240 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233223AbhI0HoW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 03:44:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6N7M9005443;
        Mon, 27 Sep 2021 03:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YFLMT0ds8B51YoPeiTDVIVA6vGyULsGli9Aks3m+P7c=;
 b=B/MtyVfQ4WIDN/zzCURgLgVrDgYib3Zxuyo3GM51rYg4xea0OrbdqC20W/C3T5yhHdik
 ceZWphfcImGMdWodNAemYg+uqjW8VgPX6QxGAbi/iTQ7Il8dsgqFkU4B/sB2GHtu9+mC
 gmVd/NTskUxt4s+CmKOUTJCsHu10xqbY/vWFhiowMFaQhPHgbA6GPEtk1bXdHi8vI1A5
 5pNqHgCcI9D/ZiJbVJ542nwsbSC6segvfrJ7cTu9I/fzcRLlU4LzkBBMQeQE2RWoOeId
 S11eDvHJw66OsiUrDvQ2nFzerS3aKjYxhdHPxcdWl8bSJYmyMurXnWfD2ihm9LznFnVL AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4n4mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 03:42:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R7LfeI006890;
        Mon, 27 Sep 2021 03:42:07 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4n4kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 03:42:07 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R7bGK0031905;
        Mon, 27 Sep 2021 07:42:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3b9ud9h2gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 07:42:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18R7g13h45547826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 07:42:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 065D85204E;
        Mon, 27 Sep 2021 07:42:01 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.4.236])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AAB4D5204F;
        Mon, 27 Sep 2021 07:41:59 +0000 (GMT)
Subject: Re: [PATCH 10/14] KVM: Split out a kvm_vcpu_block() helper from
 kvm_vcpu_halt()
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-11-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <16f057a7-5603-d4b1-266c-f9564b564f32@de.ibm.com>
Date:   Mon, 27 Sep 2021 09:41:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925005528.1145584-11-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fnFVhWWVIL3Czmll3D06Tgte64FqxA88
X-Proofpoint-ORIG-GUID: VjiGuiDIF0Z96qvd11e4c35K5QcdL-IE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_02,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 25.09.21 um 02:55 schrieb Sean Christopherson:
> Factor out the "block" part of kvm_vcpu_halt() so that x86 can emulate
> non-halt wait/sleep/block conditions that should not be subjected to
> halt-polling.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/kvm_main.c      | 50 ++++++++++++++++++++++++++++------------
>   2 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d2a8be3fb9ba..655c2b24db2d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -966,6 +966,7 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu);
>   void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>   
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
>   void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>   void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 280cf1dca7db..fe34457530c2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3199,6 +3199,34 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>   	return ret;
>   }
>   
> +/*
> + * Block the vCPU until the vCPU is runnable, an event arrives, or a signal is
> + * pending.  This is mostly used when halting a vCPU, but may also be used
> + * directly for other vCPU non-runnable states, e.g. x86's Wait-For-SIPI.
> + */
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
> +{
> +	bool waited = false;
> +
> +	kvm_arch_vcpu_blocking(vcpu);
> +
> +	prepare_to_rcuwait(&vcpu->wait);
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
> +		if (kvm_vcpu_check_block(vcpu) < 0)
> +			break;
> +
> +		waited = true;
> +		schedule();
> +	}
> +	finish_rcuwait(&vcpu->wait);
> +
> +	kvm_arch_vcpu_unblocking(vcpu);
> +
> +	return waited;
> +}
> +
>   static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   					  ktime_t end, bool success)
>   {
> @@ -3221,6 +3249,12 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   	}
>   }
>   
> +/*
> + * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
> + * polling is enabled, busy wait for a short time before blocking to avoid the
> + * expensive block+unblock sequence if a wake event arrives soon after the vCPU
> + * is halted.
> + */
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> @@ -3245,21 +3279,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   		} while (kvm_vcpu_can_poll(cur, stop));
>   	}
>   
> -	kvm_arch_vcpu_blocking(vcpu);
> -
> -	prepare_to_rcuwait(&vcpu->wait);
> -	for (;;) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -
> -		if (kvm_vcpu_check_block(vcpu) < 0)
> -			break;
> -
> -		waited = true;
> -		schedule();
> -	}
> -	finish_rcuwait(&vcpu->wait);
> -
> -	kvm_arch_vcpu_unblocking(vcpu);
> +	waited = kvm_vcpu_block(vcpu);
>   
>   	cur = ktime_get();
>   	if (waited) {
> 
