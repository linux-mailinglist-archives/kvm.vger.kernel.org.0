Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD3E568700
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiGFLoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbiGFLoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:44:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAE2027FD8
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657107843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4qBFj/falt5wlCjO0QFUH2Aq6wUuCp0x5wyiWtRWTgE=;
        b=cDzKrx46TFr6478dvE3ZIf9QioxSMsHrIzlR+YLU1b+ggcvf0ZaHhhpr8v1AJH6eucKnoS
        LIHkxAGwXjf9ntpYqyGLXrqR6VF7IBk5nE496zkzYnW3FIoSwsLvK+EDWPL8rFVd2LNbz1
        2sRObZSOdVuGV7SgCWWGCgNEiiYRU7o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-wz1CfbnbPyyqiRDfP0ZL_Q-1; Wed, 06 Jul 2022 07:43:59 -0400
X-MC-Unique: wz1CfbnbPyyqiRDfP0ZL_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57FB8805AF5;
        Wed,  6 Jul 2022 11:43:59 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07231C44AE3;
        Wed,  6 Jul 2022 11:43:56 +0000 (UTC)
Message-ID: <bfe5ccd26f1b09df2ac1bfbf7c5a4cf20cc5c8d0.camel@redhat.com>
Subject: Re: [PATCH v2 03/21] KVM: x86: Don't check for code breakpoints
 when emulating on exception
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:43:55 +0300
In-Reply-To: <20220614204730.3359543-4-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Don't check for code breakpoints during instruction emulation if the
> emulation was triggered by exception interception.  Code breakpoints are
> the highest priority fault-like exception, and KVM only emulates on
> exceptions that are fault-like.  Thus, if hardware signaled a different
> exception, then the vCPU is already passed the stage of checking for
> hardware breakpoints.
> 
> This is likely a glorified nop in terms of functionality, and is more for
> clarification and is technically an optimization.  Intel's SDM explicitly
> states vmcs.GUEST_RFLAGS.RF on exception interception is the same as the
> value that would have been saved on the stack had the exception not been
> intercepted, i.e. will be '1' due to all fault-like exceptions setting RF
> to '1'.  AMD says "guest state saved ... is the processor state as of the
> moment the intercept triggers", but that begs the question, "when does
> the intercept trigger?".
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2318a99139fa..c5db31b4bd6f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8364,8 +8364,24 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
>  
> -static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu, int *r)
> +static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
> +					   int emulation_type, int *r)
>  {
> +	WARN_ON_ONCE(emulation_type & EMULTYPE_NO_DECODE);
> +
> +	/*
> +	 * Do not check for code breakpoints if hardware has already done the
> +	 * checks, as inferred from the emulation type.  On NO_DECODE and SKIP,
> +	 * the instruction has passed all exception checks, and all intercepted
> +	 * exceptions that trigger emulation have lower priority than code
> +	 * breakpoints, i.e. the fact that the intercepted exception occurred
> +	 * means any code breakpoints have already been serviced.
> +	 */
> +	if (emulation_type & (EMULTYPE_NO_DECODE | EMULTYPE_SKIP |
> +			      EMULTYPE_TRAP_UD | EMULTYPE_TRAP_UD_FORCED |
> +			      EMULTYPE_VMWARE_GP | EMULTYPE_PF))
> +		return false;
> +
>  	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
>  	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
>  		struct kvm_run *kvm_run = vcpu->run;
> @@ -8487,8 +8503,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		 * are fault-like and are higher priority than any faults on
>  		 * the code fetch itself.
>  		 */
> -		if (!(emulation_type & EMULTYPE_SKIP) &&
> -		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
> +		if (kvm_vcpu_check_code_breakpoint(vcpu, emulation_type, &r))
>  			return r;
>  
>  		r = x86_decode_emulated_instruction(vcpu, emulation_type,


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

