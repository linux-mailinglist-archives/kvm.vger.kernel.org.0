Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465E7366613
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 09:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhDUHLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 03:11:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234052AbhDUHLq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 03:11:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L74UOa162380;
        Wed, 21 Apr 2021 03:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TyQ8DTTBNGPAwhh7dm6C/SIyjekoH+6/1xxpdKr330M=;
 b=B04rcvipuuEfxbV3Nc4SK1g3KYd2LPmOUP4ldmYd2yAL3peATvCLM0YqUfOLlj0HhcRQ
 JhhWtDqOODap6qwJQJLiqEqMt48VH7/vFGdo8Rz5Z7aeMqfemfqr4W8f/MLOgrbftrxr
 OEzLrGwQm6633aVbEIDKHLpB/AG5SQfFfBMO940vIhmzclPjO/IVPZZgFv79sgAyAajO
 tSfsNo7Ilfs8uIbpxekZJJXuKBp9vzrJPKomv+bNfewUN3Ff7IMSIwwbhEoLPMXXPitW
 ac6Mvu845zq2G0+8TVXgkIhjXZU9qfRetUGq5qh2UMwLw2ySXBJU4TXqSfa6H+zGwcmf Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3829y3y45b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 03:10:27 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13L755Pk164853;
        Wed, 21 Apr 2021 03:10:27 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3829y3y43r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 03:10:27 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13L78GSB015028;
        Wed, 21 Apr 2021 07:10:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 37yqa895pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 07:10:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13L7AMKt16908774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 07:10:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D49E511C04A;
        Wed, 21 Apr 2021 07:10:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BF1311C04C;
        Wed, 21 Apr 2021 07:10:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.39.90])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Apr 2021 07:10:22 +0000 (GMT)
Subject: Re: [PATCH v3 7/9] context_tracking: KVM: Move guest enter/exit
 wrappers to KVM's domain
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Frederic Weisbecker <frederic@kernel.org>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-8-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <b89a1ed1-bbdc-db92-769e-4179e2e06b7a@de.ibm.com>
Date:   Wed, 21 Apr 2021 09:10:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415222106.1643837-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M3nKoxWxkpbnG2FACgqWEOOnnQ7Ziv0n
X-Proofpoint-ORIG-GUID: BVvs1hCf3Zfc8iXCMgWGe3FsCIbg03jV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.04.21 00:21, Sean Christopherson wrote:
> Move the guest enter/exit wrappers to kvm_host.h so that KVM can manage
> its context tracking vs. vtime accounting without bleeding too many KVM
> details into the context tracking code.
> 
> No functional change intended.

Funny story. This used to be in kvm code and it was moved to context_tracking by
commit 521921bad1192fb1b8f9b6a5aa673635848b8b5f
     kvm: Move guest entry/exit APIs to context_tracking

I think with all your cleanup it can now move back as it no longer deals with
context tracking.


> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   include/linux/context_tracking.h | 45 --------------------------------
>   include/linux/kvm_host.h         | 45 ++++++++++++++++++++++++++++++++
>   2 files changed, 45 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index e172a547b2d0..d4dc9c4d79aa 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -118,49 +118,4 @@ extern void context_tracking_init(void);
>   static inline void context_tracking_init(void) { }
>   #endif /* CONFIG_CONTEXT_TRACKING_FORCE */
>   
> -/* must be called with irqs disabled */
> -static __always_inline void guest_enter_irqoff(void)
> -{
> -	/*
> -	 * This is running in ioctl context so its safe to assume that it's the
> -	 * stime pending cputime to flush.
> -	 */
> -	instrumentation_begin();
> -	vtime_account_guest_enter();
> -	instrumentation_end();
> -
> -	/*
> -	 * KVM does not hold any references to rcu protected data when it
> -	 * switches CPU into a guest mode. In fact switching to a guest mode
> -	 * is very similar to exiting to userspace from rcu point of view. In
> -	 * addition CPU may stay in a guest mode for quite a long time (up to
> -	 * one time slice). Lets treat guest mode as quiescent state, just like
> -	 * we do with user-mode execution.
> -	 */
> -	if (!context_tracking_guest_enter_irqoff()) {
> -		instrumentation_begin();
> -		rcu_virt_note_context_switch(smp_processor_id());
> -		instrumentation_end();
> -	}
> -}
> -
> -static __always_inline void guest_exit_irqoff(void)
> -{
> -	context_tracking_guest_exit_irqoff();
> -
> -	instrumentation_begin();
> -	/* Flush the guest cputime we spent on the guest */
> -	vtime_account_guest_exit();
> -	instrumentation_end();
> -}
> -
> -static inline void guest_exit(void)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	guest_exit_irqoff();
> -	local_irq_restore(flags);
> -}
> -
>   #endif
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3b06d12ec37e..444d5f0225cb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -332,6 +332,51 @@ struct kvm_vcpu {
>   	struct kvm_dirty_ring dirty_ring;
>   };
>   
> +/* must be called with irqs disabled */
> +static __always_inline void guest_enter_irqoff(void)
> +{
> +	/*
> +	 * This is running in ioctl context so its safe to assume that it's the
> +	 * stime pending cputime to flush.
> +	 */
> +	instrumentation_begin();
> +	vtime_account_guest_enter();
> +	instrumentation_end();
> +
> +	/*
> +	 * KVM does not hold any references to rcu protected data when it
> +	 * switches CPU into a guest mode. In fact switching to a guest mode
> +	 * is very similar to exiting to userspace from rcu point of view. In
> +	 * addition CPU may stay in a guest mode for quite a long time (up to
> +	 * one time slice). Lets treat guest mode as quiescent state, just like
> +	 * we do with user-mode execution.
> +	 */
> +	if (!context_tracking_guest_enter_irqoff()) {
> +		instrumentation_begin();
> +		rcu_virt_note_context_switch(smp_processor_id());
> +		instrumentation_end();
> +	}
> +}
> +
> +static __always_inline void guest_exit_irqoff(void)
> +{
> +	context_tracking_guest_exit_irqoff();
> +
> +	instrumentation_begin();
> +	/* Flush the guest cputime we spent on the guest */
> +	vtime_account_guest_exit();
> +	instrumentation_end();
> +}
> +
> +static inline void guest_exit(void)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	guest_exit_irqoff();
> +	local_irq_restore(flags);
> +}
> +
>   static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>   {
>   	/*
> 
