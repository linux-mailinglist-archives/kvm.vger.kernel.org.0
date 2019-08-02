Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D2C802F4
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 00:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437301AbfHBWsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 18:48:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47646 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbfHBWsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 18:48:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x72Md8x4121869;
        Fri, 2 Aug 2019 22:48:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=mCFctRTrxm2INaI4uhpxN6vq8Vz/RUrEy5pSxrJu8dg=;
 b=QYXyQ8j1Y0OFt1ThNE5S4kVcVnDlp4FS7fxUhCX0nsVL5v7uBaRUcRzEBTy2aYO0fydY
 DYtXDaYIN8ZUln+lsN8Yfj+bPRJbn+r+8d7QySp8HfWzAh0gSvfH3luYTOG2U54yF7mF
 FRDzszsHKaU96bYpJOQKp2o/OFzgSSmDzT85i/FBOVjaAjxCSFGefaVldwSoZbWnnorn
 qIL44xY/SaH4MVoZ7mKQmIrbN3hPNACW1ST4bOS6K2yC4QVc+9XFO7U60+O1t55W0GGO
 SnaFJLPUjl4lnwpufqDmHFAAFKo+TuGyECtXivQFLMGAuCsUVll7NMQGDcDpWx4QZh7v CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u0e1ud02b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Aug 2019 22:48:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x72Mbf9T046556;
        Fri, 2 Aug 2019 22:48:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u38fcgxyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Aug 2019 22:48:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x72MmS4h026236;
        Fri, 2 Aug 2019 22:48:29 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Aug 2019 15:48:28 -0700
Subject: Re: [PATCH v2] KVM: x86: Unconditionally call x86 ops that are always
 implemented
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190802220617.10869-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c2ebed86-9342-ab88-3751-318d2a256173@oracle.com>
Date:   Fri, 2 Aug 2019 15:48:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190802220617.10869-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9337 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=849
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908020238
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9337 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=891 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908020238
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/02/2019 03:06 PM, Sean Christopherson wrote:
> Remove a few stale checks for non-NULL ops now that the ops in question
> are implemented by both VMX and SVM.
>
> Note, this is **not** stable material, the Fixes tags are there purely
> to show when a particular op was first supported by both VMX and SVM.
>
> Fixes: 74f169090b6f ("kvm/svm: Setup MCG_CAP on AMD properly")
> Fixes: b31c114b82b2 ("KVM: X86: Provide a capability to disable PAUSE intercepts")
> Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> v2: Give update_pi_iret the same treatment [Krish].
>
>   arch/x86/kvm/x86.c | 13 +++----------
>   1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 01e18caac825..e7c993f0cbed 100644
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
> @@ -9992,7 +9988,7 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
>   
>   bool kvm_arch_has_irq_bypass(void)

Now that this is returning true always and that this is called only in 
kvm_irqfd_assign(), this can perhaps be removed altogether ?

>   {
> -	return kvm_x86_ops->update_pi_irte != NULL;
> +	return true;
>   }
>   
>   int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
> @@ -10032,9 +10028,6 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>   int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
>   				   uint32_t guest_irq, bool set)
>   {
> -	if (!kvm_x86_ops->update_pi_irte)
> -		return -EINVAL;
> -
>   	return kvm_x86_ops->update_pi_irte(kvm, host_irq, guest_irq, set);
>   }
>   

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
