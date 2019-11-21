Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB1B105CC5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 23:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKUWn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 17:43:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36270 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKUWn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 17:43:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALMcxMS001533;
        Thu, 21 Nov 2019 22:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=NTYsdsHLjefwHTGvRqZPp6Ky346UtXVJa6by7yTGYtw=;
 b=b68IyDa5VK8JKY8pV1XZsegADtMQQhhOiMEow1QclHGMA8wPWhcIMn1RR2rM2fQkzIif
 vqa7SDXC7IKDgUwoWUlQ8WMk6pZPYukaY/nMSSOa7C8+ax1Qgc60hGUFDiyrBzMYllcU
 8VcmvIjvcuTgvVvQvgMF1PLz/IZht8xeMrxp31MHavYjVWlGCv465T4kLw+P6o4MH4eN
 +F7O7ri5JsNh0ASCxQORRg/QycDyy7yx4QpGrCgj2rAI3p678F2lEMSqLQ0YgY7mMiLQ
 XpbDuhxSDY+SFwf9la9v9n59DsZVj0IRgdyoOhuMyh05j/wKYLvv9Phq8dKq6uq7nP/Q XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8hu7cr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 22:43:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALMdUvG039833;
        Thu, 21 Nov 2019 22:43:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wd47xsqh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 22:43:18 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xALMhHQ3027093;
        Thu, 21 Nov 2019 22:43:17 GMT
Received: from dhcp-10-132-95-157.usdhcp.oraclecorp.com (/10.132.95.157)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 14:43:17 -0800
Subject: Re: [PATCH 1/2] KVM x86: Move kvm cpuid support out of svm
To:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191121203344.156835-1-pgonda@google.com>
 <20191121203344.156835-2-pgonda@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <8024bbe3-8390-ebca-8b49-be733ae8c048@oracle.com>
Date:   Thu, 21 Nov 2019 14:43:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20191121203344.156835-2-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210190
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/2019 12:33 PM, Peter Gonda wrote:
> Memory encryption support does not have module parameter dependencies
> and can be moved into the general x86 cpuid __do_cpuid_ent function.
> This changes maintains current behavior of passing through all of
> CPUID.8000001F.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 5 +++++
>   arch/x86/kvm/svm.c   | 7 -------
>   2 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f68c0c753c38..946fa9cb9dd6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -778,6 +778,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>   	case 0x8000001a:
>   	case 0x8000001e:
>   		break;
> +	/* Support memory encryption cpuid if host supports it */
> +	case 0x8000001F:
> +		if (!boot_cpu_has(X86_FEATURE_SEV))
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +		break;
>   	/*Add support for Centaur's CPUID instruction*/
>   	case 0xC0000000:
>   		/*Just support up to 0xC0000004 now*/
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c5673bda4b66..79842329ebcd 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5936,13 +5936,6 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
>   		if (npt_enabled)
>   			entry->edx |= F(NPT);
>   
> -		break;
> -	case 0x8000001F:
> -		/* Support memory encryption cpuid if host supports it */
> -		if (boot_cpu_has(X86_FEATURE_SEV))
> -			cpuid(0x8000001f, &entry->eax, &entry->ebx,
> -				&entry->ecx, &entry->edx);
> -
>   	}
>   }
>   
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
