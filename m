Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F194F1BA9
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380799AbiDDVWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379284AbiDDQxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 12:53:12 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EBD3B032;
        Mon,  4 Apr 2022 09:51:14 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbPuw-0002t4-DU; Mon, 04 Apr 2022 18:51:02 +0200
Message-ID: <112c2108-7548-f5bd-493d-19b944701f1b@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 18:50:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-2-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
In-Reply-To: <20220402010903.727604-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2.04.2022 03:08, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> The next_rip field of a VMCB is *not* an output-only field for a VMRUN.
> This field value (instead of the saved guest RIP) in used by the CPU for
> the return address pushed on stack when injecting a software interrupt or
> INT3 or INTO exception.
> 
> Make sure this field gets synced from vmcb12 to vmcb02 when entering L2 or
> loading a nested state and NRIPS is exposed to L1.  If NRIPS is supported
> in hardware but not exposed to L1 (nrips=0 or hidden by userspace), stuff
> vmcb02's next_rip from the new L2 RIP to emulate a !NRIPS CPU (which
> saves RIP on the stack as-is).
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/nested.c | 22 +++++++++++++++++++---
>   arch/x86/kvm/svm/svm.h    |  1 +
>   2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 73b545278f5f..9a6dc2b38fcf 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -369,6 +369,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>   	to->nested_ctl          = from->nested_ctl;
>   	to->event_inj           = from->event_inj;
>   	to->event_inj_err       = from->event_inj_err;
> +	to->next_rip            = from->next_rip;
>   	to->nested_cr3          = from->nested_cr3;
>   	to->virt_ext            = from->virt_ext;
>   	to->pause_filter_count  = from->pause_filter_count;
> @@ -606,7 +607,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>   	}
>   }
>   
> -static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
> +static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> +					  unsigned long vmcb12_rip)
>   {
>   	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
>   	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
> @@ -660,6 +662,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>   	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
>   	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
>   
> +	/*
> +	 * next_rip is consumed on VMRUN as the return address pushed on the
> +	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
> +	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
> +	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
> +	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
> +	 * prior to injecting the event).
> +	 */
> +	if (svm->nrips_enabled)
> +		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> +	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> +		vmcb02->control.next_rip    = vmcb12_rip;
> +
>   	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
>   					      LBR_CTL_ENABLE_MASK;
>   	if (svm->lbrv_enabled)
> @@ -743,7 +758,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>   	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>   
>   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm);
> +	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
>   	nested_vmcb02_prepare_save(svm, vmcb12);
>   
>   	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> @@ -1422,6 +1437,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
>   	dst->nested_ctl           = from->nested_ctl;
>   	dst->event_inj            = from->event_inj;
>   	dst->event_inj_err        = from->event_inj_err;
> +	dst->next_rip             = from->next_rip;
>   	dst->nested_cr3           = from->nested_cr3;
>   	dst->virt_ext              = from->virt_ext;
>   	dst->pause_filter_count   = from->pause_filter_count;
> @@ -1606,7 +1622,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	nested_copy_vmcb_control_to_cache(svm, ctl);
>   
>   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm);
> +	nested_vmcb02_prepare_control(svm, save->rip);
>   

					   ^
I guess this should be "svm->vmcb->save.rip", since
KVM_{GET,SET}_NESTED_STATE "save" field contains vmcb01 data,
not vmcb{0,1}2 (in contrast to the "control" field).


Thanks,
Maciej
