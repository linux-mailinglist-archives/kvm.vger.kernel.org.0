Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D5750EC5B
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 01:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiDYXDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbiDYXDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:03:07 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A68A1B9;
        Mon, 25 Apr 2022 16:00:00 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nj7gP-0002Bz-VA; Tue, 26 Apr 2022 00:59:53 +0200
Message-ID: <08d0cbcd-14dd-b9c6-82cf-a0d11c5cccd9@maciej.szmigiero.name>
Date:   Tue, 26 Apr 2022 00:59:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220423021411.784383-1-seanjc@google.com>
 <20220423021411.784383-10-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2 09/11] KVM: x86: Differentiate Soft vs. Hard IRQs vs.
 reinjected in tracepoint
In-Reply-To: <20220423021411.784383-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.04.2022 04:14, Sean Christopherson wrote:
> In the IRQ injection tracepoint, differentiate between Hard IRQs and Soft
> "IRQs", i.e. interrupts that are reinjected after incomplete delivery of
> a software interrupt from an INTn instruction.  Tag reinjected interrupts
> as such, even though the information is usually redundant since soft
> interrupts are only ever reinjected by KVM.  Though rare in practice, a
> hard IRQ can be reinjected.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/svm/svm.c          |  5 +++--
>   arch/x86/kvm/trace.h            | 16 +++++++++++-----
>   arch/x86/kvm/vmx/vmx.c          |  4 ++--
>   arch/x86/kvm/x86.c              |  4 ++--
>   5 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f164c6c1514a..ae088c6fb287 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1400,7 +1400,7 @@ struct kvm_x86_ops {
>   	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>   	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
>   				unsigned char *hypercall_addr);
> -	void (*inject_irq)(struct kvm_vcpu *vcpu);
> +	void (*inject_irq)(struct kvm_vcpu *vcpu, bool reinjected);
>   	void (*inject_nmi)(struct kvm_vcpu *vcpu);
>   	void (*queue_exception)(struct kvm_vcpu *vcpu);
>   	void (*cancel_injection)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b8fb07eeeca5..4a912623b961 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3427,7 +3427,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>   	++vcpu->stat.nmi_injections;
>   }
>   
> -static void svm_inject_irq(struct kvm_vcpu *vcpu)
> +static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	u32 type;
> @@ -3442,7 +3442,8 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
>   		type = SVM_EVTINJ_TYPE_INTR;
>   	}
>   
> -	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
> +	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
> +			   vcpu->arch.interrupt.soft, reinjected);
>   	++vcpu->stat.irq_injections;
>   
>   	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 385436d12024..e1b089285c55 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -333,18 +333,24 @@ TRACE_EVENT_KVM_EXIT(kvm_exit);
>    * Tracepoint for kvm interrupt injection:
>    */
>   TRACE_EVENT(kvm_inj_virq,
> -	TP_PROTO(unsigned int irq),
> -	TP_ARGS(irq),
> +	TP_PROTO(unsigned int vector, bool soft, bool reinjected),
> +	TP_ARGS(vector, soft, reinjected),
>   
>   	TP_STRUCT__entry(
> -		__field(	unsigned int,	irq		)
> +		__field(	unsigned int,	vector		)
> +		__field(	bool,		soft		)
> +		__field(	unsigned int,	reinjected	)

The "reinjected" field was probably supposed to be bool, just like
in the trace function prototype.

Thanks,
Maciej

