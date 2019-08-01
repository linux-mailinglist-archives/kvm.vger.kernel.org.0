Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 066117E4E0
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 23:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389212AbfHAVjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 17:39:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51290 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389271AbfHAVjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 17:39:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71LY1II104448;
        Thu, 1 Aug 2019 21:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LUtX7pBhHZfsgp7r0OheG59VIw+dCJxYfKI4K2OdooM=;
 b=m9lrReYJkWWi9heHpCLNN++GRGEAshPIkE3IkSr39RFyK2mEk0XKPLZthhaz88ya0+xH
 hT7scQxOq7bnEzOQ7MhadvXLPKp5MIPu7gmt8I0wTfp4zR+jsPcCh9lWrVpDEQj8Zjf0
 KmppReF76YcfcIVAgE7IaMAy9O0vNt7srWnZtahhkoGpXlSliZnimUtwUFulGQwSnQGz
 7gnjfcXPqxTKH0O+iGpsLA1oLfADHjH2/6Th8iI6ixPafwBBVTPCFlV6MJTDERyD0J/o
 4rXKWJkT3Ub9VHKZr8QQqdXq397o/6KwXuqcpLYFthhAEQ25U8jYG0wkrSZOSW+8kGh9 +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u0e1u6kws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 21:39:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71LXL0l183979;
        Thu, 1 Aug 2019 21:39:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u2jp6kvym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 21:39:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x71LddYJ015405;
        Thu, 1 Aug 2019 21:39:39 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 14:39:38 -0700
Subject: Re: [PATCH] KVM: x86: Unconditionally call x86 ops that are always
 implemented
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190801164606.20777-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <3337d56f-de99-6879-96c2-0255db68541d@oracle.com>
Date:   Thu, 1 Aug 2019 14:39:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190801164606.20777-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=676
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010228
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=728 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010228
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/01/2019 09:46 AM, Sean Christopherson wrote:
> Remove two stale checks for non-NULL ops now that they're implemented by
> both VMX and SVM.
>
> Fixes: 74f169090b6f ("kvm/svm: Setup MCG_CAP on AMD properly")
> Fixes: b31c114b82b2 ("KVM: X86: Provide a capability to disable PAUSE intercepts")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/x86.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 01e18caac825..2c25a19d436f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3506,8 +3506,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>   	for (bank = 0; bank < bank_num; bank++)
>   		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
>   
> -	if (kvm_x86_ops->setup_mce)
> -		kvm_x86_ops->setup_mce(vcpu);
> +	kvm_x86_ops->setup_mce(vcpu);
>   out:
>   	return r;
>   }
> @@ -9313,10 +9312,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_page_track_init(kvm);
>   	kvm_mmu_init_vm(kvm);
>   
> -	if (kvm_x86_ops->vm_init)
> -		return kvm_x86_ops->vm_init(kvm);
> -
> -	return 0;
> +	return kvm_x86_ops->vm_init(kvm);
>   }
>   
>   static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)

The following two ops are also implemented by both VMX and SVM:

         update_cr8_intercept
         update_pi_irte
