Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F3A1E869B
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 20:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgE2S2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 14:28:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34894 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgE2S2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 14:28:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TIIxgN027628;
        Fri, 29 May 2020 18:27:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NnBhVkik+DPjxPNgherj6ybw5/R0wr5vT5i5/UWWsqY=;
 b=z4CGYlD6baoYOD1TzwdUW77pHp7Nua3J5PPrMFyyouDKpELHZ43Mxeiy2KT6Rbse0SmM
 HIHArTEPOibKStlmc2eONgPzXNbO9nLlIofScJo8Uk7MbUjZHRanWeRpZJdwmh/KDLYB
 wR/MaZP/j/P5dtwbOjbFDtbBLg67WNK16FHyVcq/CdY6iZBpG06yysdIIo2Y4rikPs7D
 qu7EJHrQYk0cJTyaDU+F4MShkjQXbljg49Ay1WavdKod35GQx9ez7GxYJDFcMmTgdSA7
 x+Wk2dg/3pGai+OtCtekINr4/g1xUs+KzHEBJyMIw4d5c8rqPhUoEoobJ/e5ofdTdfUT uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 318xe1uugn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 18:27:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TIJBtZ113228;
        Fri, 29 May 2020 18:27:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 317ddus6tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 18:27:57 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04TIRuhG016282;
        Fri, 29 May 2020 18:27:56 GMT
Received: from localhost.localdomain (/10.159.246.35)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 11:27:56 -0700
Subject: Re: [PATCH 10/30] KVM: nSVM: extract preparation of VMCB for nested
 run
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-11-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <bf123ad6-3313-351c-a7b8-e55cefb53f63@oracle.com>
Date:   Fri, 29 May 2020 11:27:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200529153934.11694-11-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/20 8:39 AM, Paolo Bonzini wrote:
> Split out filling svm->vmcb.save and svm->vmcb.control before VMRUN.
> Only the latter will be useful when restoring nested SVM state.
>
> This patch introduces no semantic change, so the MMU setup is still
> done in nested_prepare_vmcb_save.  The next patch will clean up things.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 40 +++++++++++++++++++++++----------------
>   1 file changed, 24 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index fc0c6d1678eb..73be7af79453 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -245,21 +245,8 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
>   	svm->vcpu.arch.tsc_offset += control->tsc_offset;
>   }
>   
> -void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> -			  struct vmcb *nested_vmcb)
> +static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)


Not a big deal, but I feel that it helps a lot in readability if we keep 
the names symmetric. This one could be named prepare_nested_vmcb_save to 
match load_nested_vmcb_control that you created in the previous patch. 
Or load_nested_vmcb_control could be renamed to nested_load_vmcb_control 
to match the name here.

>   {
> -	bool evaluate_pending_interrupts =
> -		is_intercept(svm, INTERCEPT_VINTR) ||
> -		is_intercept(svm, INTERCEPT_IRET);
> -
> -	svm->nested.vmcb = vmcb_gpa;
> -	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
> -		svm->vcpu.arch.hflags |= HF_HIF_MASK;
> -	else
> -		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
> -
> -	load_nested_vmcb_control(svm, &nested_vmcb->control);
> -
>   	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
>   		nested_svm_init_mmu_context(&svm->vcpu);
>   
> @@ -291,7 +278,10 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
>   	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
>   	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
> +}
>   
> +static void nested_prepare_vmcb_control(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
> +{
>   	svm_flush_tlb(&svm->vcpu);
>   	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
>   		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
> @@ -321,6 +311,26 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	 */
>   	recalc_intercepts(svm);
>   
> +	mark_all_dirty(svm->vmcb);
> +}
> +
> +void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
> +			  struct vmcb *nested_vmcb)
> +{
> +	bool evaluate_pending_interrupts =
> +		is_intercept(svm, INTERCEPT_VINTR) ||
> +		is_intercept(svm, INTERCEPT_IRET);
> +
> +	svm->nested.vmcb = vmcb_gpa;
> +	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
> +		svm->vcpu.arch.hflags |= HF_HIF_MASK;
> +	else
> +		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
> +
> +	load_nested_vmcb_control(svm, &nested_vmcb->control);
> +	nested_prepare_vmcb_save(svm, nested_vmcb);
> +	nested_prepare_vmcb_control(svm, nested_vmcb);
> +
>   	/*
>   	 * If L1 had a pending IRQ/NMI before executing VMRUN,
>   	 * which wasn't delivered because it was disallowed (e.g.
> @@ -336,8 +346,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   	enable_gif(svm);
>   	if (unlikely(evaluate_pending_interrupts))
>   		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> -
> -	mark_all_dirty(svm->vmcb);
>   }
>   
>   int nested_svm_vmrun(struct vcpu_svm *svm)
