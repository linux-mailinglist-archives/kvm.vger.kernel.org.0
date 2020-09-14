Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A0C2696F0
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgINUqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:46:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgINUqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:46:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EKeG8R111737;
        Mon, 14 Sep 2020 20:45:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hNuujluzU2RRINi9JfoY0YiABW6y/9GNCHBiA8is/6I=;
 b=b+Rj8MSRAqqLmix8qstCVU8qsr8XpCSND84wHUFByL4WNjbYd9sTw4QJnR+b6tHEj+b4
 O2vHXCCMrRbq2VeBfQm+1TCag3h8/0BvFXMJr0r75RM/iUlgd1T3EzbbCY8DNZ0e2zo5
 2LSoowSzohvrDXahPaaQXKib3Vfa60ebOnBVuozvyQmtKDCTxTiD+982+IUf+8FlSD8j
 u6+EFN2i92JpmhyFJ44sbZC1tCl62L+xIvyq8RytvOLa2AoYO/gJywyzX+tA3NAiSGXZ
 RayYfQXA0h9WFQeRbKxfeo2rvHX2w9HKKWgDl4qYplpfLjQYFHiiT0wiu8Ae4lUwB7b2 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dan7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Sep 2020 20:45:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EKdspO037283;
        Mon, 14 Sep 2020 20:43:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wmu0yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 20:43:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08EKhFN2004026;
        Mon, 14 Sep 2020 20:43:15 GMT
Received: from localhost.localdomain (/10.159.129.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Sep 2020 20:43:15 +0000
Subject: Re: [PATCH] KVM: SVM: Analyze is_guest_mode() in svm_vcpu_run()
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1600066548-4343-1-git-send-email-wanpengli@tencent.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <b39b1599-9e1e-8ef6-1b97-a4910d9c3784@oracle.com>
Date:   Mon, 14 Sep 2020 13:43:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600066548-4343-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/13/20 11:55 PM, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Analyze is_guest_mode() in svm_vcpu_run() instead of svm_exit_handlers_fastpath()
> in conformity with VMX version.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kvm/svm/svm.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3da5b2f..009035a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3393,8 +3393,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>   
>   static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>   {
> -	if (!is_guest_mode(vcpu) &&
> -	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
> +	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
>   	    to_svm(vcpu)->vmcb->control.exit_info_1)
>   		return handle_fastpath_set_msr_irqoff(vcpu);
>   
> @@ -3580,6 +3579,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   		svm_handle_mce(svm);
>   
>   	svm_complete_interrupts(svm);
> +
> +	if (is_guest_mode(vcpu))
> +		return EXIT_FASTPATH_NONE;
> +
>   	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
>   	return exit_fastpath;

Not related to your changes, but should we get rid of the variable 
'exit_fastpath' and just do,

         return svm_exit_handler_fastpath(vcpu);

It seems the variable isn't used anywhere else and svm_vcpu_run() 
doesn't return from anywhere else either.

Also, svm_exit_handlers_fastpath() doesn't have any other caller.  
Should we get rid of it as well ?


For your changes,

     Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

>   }
