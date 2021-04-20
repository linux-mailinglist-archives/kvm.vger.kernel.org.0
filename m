Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D61365FBC
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhDTSta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:49:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233672AbhDTSt3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 14:49:29 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KIibUC017605;
        Tue, 20 Apr 2021 14:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D47ltguYZM05WjXNq39R9t+s6CuLCxg4my9ltrMlT5g=;
 b=A0FdOANIr4ec33KMBXLKCRb1hCsgDymxhnEMY+LNIcO2DOWmmoS+v4MqhYSBIc5xKtjL
 XnESurljV7Hy8m+vQXzR8k20ZAqNiMpk6VNr12OlpAQo1pJ4fcLCIkkxtXHtN2QN1Tas
 HUCGN8sQIUFp3qz2Oc+V80afA0wh7pzsStaZ/ah43a5Of4xyVpEee1nGgCa1TEVH7bYM
 VIyR9Kttba2leGWqXmNxS2KYUtoA+vXNJHhi42bFZb+iVgFfFl0PzIbnO7miE/N+G6RF
 LNQc5mF4ctyfQ7gI6O8UqCugSnWiG7OCOJzz3QNxyzvU0/Nh/o4teHHGSbx9qDkUyCj9 fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3824gc03ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 14:48:28 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13KIkRDj023511;
        Tue, 20 Apr 2021 14:48:27 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3824gc039m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 14:48:27 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KImQwS001082;
        Tue, 20 Apr 2021 18:48:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 37yqa891rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 18:48:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KImNio62587266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 18:48:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 717ACAE055;
        Tue, 20 Apr 2021 18:48:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5DFEAE051;
        Tue, 20 Apr 2021 18:48:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.21.211])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Apr 2021 18:48:22 +0000 (GMT)
Subject: Re: [PATCH v3 2/9] context_tracking: Move guest exit vtime accounting
 to separate helpers
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-3-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <cca590ee-ade6-dd17-aed8-c927a4f02ec0@de.ibm.com>
Date:   Tue, 20 Apr 2021 20:48:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415222106.1643837-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ks4ctYvy-pW--QAL67-fcZgMXj_vfdhF
X-Proofpoint-GUID: Pd4TECqTO_6XhgXkaK7Tg9lFAsFg3fOh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_08:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.04.21 00:20, Sean Christopherson wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Provide separate vtime accounting functions for guest exit instead of
> open coding the logic within the context tracking code.  This will allow
> KVM x86 to handle vtime accounting slightly differently when using
> tick-based accounting.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Michael Tokarev <mjt@tls.msk.ru>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   include/linux/context_tracking.h | 24 +++++++++++++++++-------
>   1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index 200d30cb3a82..7cf03a8e5708 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -137,15 +137,20 @@ static __always_inline void context_tracking_guest_exit_irqoff(void)
>   		__context_tracking_exit(CONTEXT_GUEST);
>   }
>   
> -static __always_inline void guest_exit_irqoff(void)
> +static __always_inline void vtime_account_guest_exit(void)
>   {
> -	context_tracking_guest_exit_irqoff();
> -
> -	instrumentation_begin();
>   	if (vtime_accounting_enabled_this_cpu())
>   		vtime_guest_exit(current);
>   	else
>   		current->flags &= ~PF_VCPU;
> +}
> +
> +static __always_inline void guest_exit_irqoff(void)
> +{
> +	context_tracking_guest_exit_irqoff();
> +
> +	instrumentation_begin();
> +	vtime_account_guest_exit();
>   	instrumentation_end();
>   }
>   
> @@ -166,12 +171,17 @@ static __always_inline void guest_enter_irqoff(void)
>   
>   static __always_inline void context_tracking_guest_exit_irqoff(void) { }
>   
> -static __always_inline void guest_exit_irqoff(void)
> +static __always_inline void vtime_account_guest_exit(void)
>   {
> -	instrumentation_begin();
> -	/* Flush the guest cputime we spent on the guest */
>   	vtime_account_kernel(current);
>   	current->flags &= ~PF_VCPU;
> +}
> +
> +static __always_inline void guest_exit_irqoff(void)
> +{
> +	instrumentation_begin();
> +	/* Flush the guest cputime we spent on the guest */
> +	vtime_account_guest_exit();
>   	instrumentation_end();
>   }
>   #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
> 
