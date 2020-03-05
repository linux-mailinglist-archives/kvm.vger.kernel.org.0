Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA617A35A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgCEKrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:47:04 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:39663 "EHLO lizzard.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEKrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:47:04 -0500
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by lizzard.sbs.de (8.15.2/8.15.2) with ESMTPS id 025AkuBR031175
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Mar 2020 11:46:56 +0100
Received: from [167.87.9.24] ([167.87.9.24])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id 025AktVZ007783;
        Thu, 5 Mar 2020 11:46:55 +0100
Subject: Re: [PATCH 4/4] KVM: nSVM: avoid loss of pending IRQ/NMI before
 entering L2
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     cavery@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com
References: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
 <1583403227-11432-5-git-send-email-pbonzini@redhat.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <fd74cfac-9b29-9710-0266-6aa743b9f9a7@siemens.com>
Date:   Thu, 5 Mar 2020 11:46:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1583403227-11432-5-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.03.20 11:13, Paolo Bonzini wrote:
> This patch reproduces for nSVM the change that was made for nVMX in
> commit b5861e5cf2fc ("KVM: nVMX: Fix loss of pending IRQ/NMI before
> entering L2").  While I do not have a test that breaks without it, I
> cannot see why it would not be necessary since all events are unblocked
> by VMRUN's setting of GIF back to 1.

I suspect, running Jailhouse enable/disable in a tight loop as KVM guest 
can stress this fairly well. At least that was the case last time I 
tried (4 years ago, or so) - it broke it.

Unfortunately, we have no up-to-date configuration for such a setup. 
Some old pieces are lying around here, could try to hand them over if 
someone is interested and has the time I lack ATM.

Jan

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 0d773406f7ac..3df62257889a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3574,6 +3574,10 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
>   static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   				 struct vmcb *nested_vmcb, struct kvm_host_map *map)
>   {
> +	bool evaluate_pending_interrupts =
> +		is_intercept(svm, INTERCEPT_VINTR) ||
> +		is_intercept(svm, INTERCEPT_IRET);
> +
>   	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
>   		svm->vcpu.arch.hflags |= HF_HIF_MASK;
>   	else
> @@ -3660,7 +3664,21 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>   
>   	svm->nested.vmcb = vmcb_gpa;
>   
> +	/*
> +	 * If L1 had a pending IRQ/NMI before executing VMRUN,
> +	 * which wasn't delivered because it was disallowed (e.g.
> +	 * interrupts disabled), L0 needs to evaluate if this pending
> +	 * event should cause an exit from L2 to L1 or be delivered
> +	 * directly to L2.
> +	 *
> +	 * Usually this would be handled by the processor noticing an
> +	 * IRQ/NMI window request.  However, VMRUN can unblock interrupts
> +	 * by implicitly setting GIF, so force L0 to perform pending event
> +	 * evaluation by requesting a KVM_REQ_EVENT.
> +	 */
>   	enable_gif(svm);
> +	if (unlikely(evaluate_pending_interrupts))
> +		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>   
>   	mark_all_dirty(svm->vmcb);
>   }
> 

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
