Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102EB365FBB
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhDTSt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:49:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233381AbhDTSt2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 14:49:28 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KIYQNa084070;
        Tue, 20 Apr 2021 14:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jB43vwtE+c8Q+af2HVrjbesBeEhh0d8P1nMdh1RQ8CA=;
 b=Uy6ngRLSykwccSAJzxP7fnc/1OfvjsemPsoyjXlBz1UHYjkW0qb1Gyo6yFoUwxtRxldY
 C6XEJfTNhTRtJZuVvBTrZsPsI8mhxeuP85oIyh+q8/6OXE6AQEoV9cPG3pnx/7lnobn4
 kMuTOQSclsDtQsM1SvVDB8cqJpuO5v0XwFhtKoBljBZU8G/gT7CmBSEnm2TKKqXHcbsN
 1Jp+o5ZJ6kn0G0MmzKi7aw6HV7FeEKYv313hk1gOAJc/De7bFbWbh+GkYlr5vkNtzu0v
 BX0Z5d1YbUPKpIFDXJm1xKHLZXs8YZFad2iI7QOT/Vvf7uklEcPh29cYD/HLjzi9T7xX 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3823ena0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 14:48:11 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13KIYgqD085523;
        Tue, 20 Apr 2021 14:48:11 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3823ena0c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 14:48:11 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KIkXp7023928;
        Tue, 20 Apr 2021 18:48:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 37yqa891uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 18:48:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KIm6HW33816840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 18:48:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D45FBAE059;
        Tue, 20 Apr 2021 18:48:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5387EAE051;
        Tue, 20 Apr 2021 18:48:06 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.21.211])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Apr 2021 18:48:06 +0000 (GMT)
Subject: Re: [PATCH v3 1/9] context_tracking: Move guest exit context tracking
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
 <20210415222106.1643837-2-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <b4e95ae2-abf7-0b06-1819-37fd8868d278@de.ibm.com>
Date:   Tue, 20 Apr 2021 20:48:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415222106.1643837-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NHQywQPkFYycgixdgPptEWZJ73P_hQmm
X-Proofpoint-ORIG-GUID: P-9eNqp9njeoLKOJDDPvoZGRIBM6bC8T
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_08:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.04.21 00:20, Sean Christopherson wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Provide separate context tracking helpers for guest exit, the standalone
> helpers will be called separately by KVM x86 in later patches to fix
> tick-based accounting.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Michael Tokarev <mjt@tls.msk.ru>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   include/linux/context_tracking.h | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index bceb06498521..200d30cb3a82 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -131,10 +131,15 @@ static __always_inline void guest_enter_irqoff(void)
>   	}
>   }
>   
> -static __always_inline void guest_exit_irqoff(void)
> +static __always_inline void context_tracking_guest_exit_irqoff(void)
>   {
>   	if (context_tracking_enabled())
>   		__context_tracking_exit(CONTEXT_GUEST);
> +}
> +
> +static __always_inline void guest_exit_irqoff(void)
> +{
> +	context_tracking_guest_exit_irqoff();
>   
>   	instrumentation_begin();
>   	if (vtime_accounting_enabled_this_cpu())
> @@ -159,6 +164,8 @@ static __always_inline void guest_enter_irqoff(void)
>   	instrumentation_end();
>   }
>   
> +static __always_inline void context_tracking_guest_exit_irqoff(void) { }
> +
>   static __always_inline void guest_exit_irqoff(void)
>   {
>   	instrumentation_begin();
> 
