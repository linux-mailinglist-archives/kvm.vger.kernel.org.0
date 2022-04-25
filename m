Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE2650EC59
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbiDYXCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiDYXCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:02:53 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44C83A5FE;
        Mon, 25 Apr 2022 15:59:46 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nj7g4-0002Ba-SS; Tue, 26 Apr 2022 00:59:32 +0200
Message-ID: <5e02efaa-b4d0-5a60-68e3-fe70f183ad4e@maciej.szmigiero.name>
Date:   Tue, 26 Apr 2022 00:59:27 +0200
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
 <20220423021411.784383-6-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2 05/11] KVM: SVM: Re-inject INT3/INTO instead of
 retrying the instruction
In-Reply-To: <20220423021411.784383-6-seanjc@google.com>
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
> Re-inject INT3/INTO instead of retrying the instruction if the CPU
> encountered an intercepted exception while vectoring the software
> exception, e.g. if vectoring INT3 encounters a #PF and KVM is using
> shadow paging.  Retrying the instruction is architecturally wrong, e.g.
> will result in a spurious #DB if there's a code breakpoint on the INT3/O,
> and lack of re-injection also breaks nested virtualization, e.g. if L1
> injects a software exception and vectoring the injected exception
> encounters an exception that is intercepted by L0 but not L1.
> 
> Due to, ahem, deficiencies in the SVM architecture, acquiring the next
> RIP may require flowing through the emulator even if NRIPS is supported,
> as the CPU clears next_rip if the VM-Exit is due to an exception other
> than "exceptions caused by the INT3, INTO, and BOUND instructions".  To
> deal with this, "skip" the instruction to calculate next_rip (if it's
> not already known), and then unwind the RIP write and any side effects
> (RFLAGS updates).
> 
> Save the computed next_rip and use it to re-stuff next_rip if injection
> doesn't complete.  This allows KVM to do the right thing if next_rip was
> known prior to injection, e.g. if L1 injects a soft event into L2, and
> there is no backing INTn instruction, e.g. if L1 is injecting an
> arbitrary event.
> 
> Note, it's impossible to guarantee architectural correctness given SVM's
> architectural flaws.  E.g. if the guest executes INTn (no KVM injection),
> an exit occurs while vectoring the INTn, and the guest modifies the code
> stream while the exit is being handled, KVM will compute the incorrect
> next_rip due to "skipping" the wrong instruction.  A future enhancement
> to make this less awful would be for KVM to detect that the decoded
> instruction is not the correct INTn and drop the to-be-injected soft
> event (retrying is a lesser evil compared to shoving the wrong RIP on the
> exception stack).
> 
> Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/nested.c |  28 +++++++-
>   arch/x86/kvm/svm/svm.c    | 140 +++++++++++++++++++++++++++-----------
>   arch/x86/kvm/svm/svm.h    |   6 +-
>   3 files changed, 130 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 461c5f247801..0163238aa198 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -609,6 +609,21 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>   	}
>   }
>   
> +static inline bool is_evtinj_soft(u32 evtinj)
> +{
> +	u32 type = evtinj & SVM_EVTINJ_TYPE_MASK;
> +	u8 vector = evtinj & SVM_EVTINJ_VEC_MASK;
> +
> +	if (!(evtinj & SVM_EVTINJ_VALID))
> +		return false;
> +
> +	/*
> +	 * Intentionally return false for SOFT events, SVM doesn't yet support
> +	 * re-injecting soft interrupts.
> +	 */
> +	return type == SVM_EVTINJ_TYPE_EXEPT && kvm_exception_is_soft(vector);
> +}
> +
>   static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   					  unsigned long vmcb12_rip)
>   {
> @@ -677,6 +692,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   	else if (boot_cpu_has(X86_FEATURE_NRIPS))
>   		vmcb02->control.next_rip    = vmcb12_rip;
>   
> +	if (is_evtinj_soft(vmcb02->control.event_inj)) {
> +		svm->soft_int_injected = true;
> +		svm->soft_int_csbase = svm->vmcb->save.cs.base;
> +		svm->soft_int_old_rip = vmcb12_rip;
> +		if (svm->nrips_enabled)
> +			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> +		else
> +			svm->soft_int_next_rip = vmcb12_rip;

The above branch can be actually reduced to simply
"svm->soft_int_next_rip = vmcb02->control.next_rip" if NRIPS is required
for (at least) nSVM.

Thanks,
Maciej
