Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194E056877E
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiGFL6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiGFL6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:58:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4C7228E33
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4P8KrHne1io7bX9wNZuVosBVJFtgbIsc0V2WyZxxxYo=;
        b=UdaSxN3qG57GVB4gZYcwhDflxY7vmC0HVl3HAF3K6+7+m8VpRlAotcjp4Tt+3pnMdcoI5/
        hIqqhNFtA740dlfSc63nFHDZXavV4s8RHSE7CL8bhrN/+IIegEDCNl3rlfvgL4xfXYnxQb
        eF2dsfhuFsSG+G5phMFI9RIO3exUdcA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-L6UNEjjKPlqt_gB-VNVWPA-1; Wed, 06 Jul 2022 07:58:03 -0400
X-MC-Unique: L6UNEjjKPlqt_gB-VNVWPA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D07738164C5;
        Wed,  6 Jul 2022 11:58:03 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 097CCC44CC4;
        Wed,  6 Jul 2022 11:58:00 +0000 (UTC)
Message-ID: <e55a0591a7fc19ab06529dd1e1e6ad94daaa68f0.camel@redhat.com>
Subject: Re: [PATCH v2 06/21] KVM: x86: Treat #DBs from the emulator as
 fault-like (code and DR7.GD=1)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:57:59 +0300
In-Reply-To: <20220614204730.3359543-7-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-7-seanjc@google.com>
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
> Add a dedicated "exception type" for #DBs, as #DBs can be fault-like or
> trap-like depending the sub-type of #DB, and effectively defer the
> decision of what to do with the #DB to the caller.
> 
> For the emulator's two calls to exception_type(), treat the #DB as
> fault-like, as the emulator handles only code breakpoint and general
> detect #DBs, both of which are fault-like.
> 
> For event injection, which uses exception_type() to determine whether to
> set EFLAGS.RF=1 on the stack, keep the current behavior of not setting
> RF=1 for #DBs.  Intel and AMD explicitly state RF isn't set on code #DBs,
> so exempting by failing the "== EXCPT_FAULT" check is correct.  The only
> other fault-like #DB is General Detect, and despite Intel and AMD both
> strongly implying (through omission) that General Detect #DBs should set
> RF=1, hardware (multiple generations of both Intel and AMD), in fact does
> not.  Through insider knowledge, extreme foresight, sheer dumb luck, or
> some combination thereof, KVM correctly handled RF for General Detect #DBs.
> 
> Fixes: 38827dbd3fb8 ("KVM: x86: Do not update EFLAGS on faulting emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5db31b4bd6f..7c3ce601bdcc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -529,6 +529,7 @@ static int exception_class(int vector)
>  #define EXCPT_TRAP		1
>  #define EXCPT_ABORT		2
>  #define EXCPT_INTERRUPT		3
> +#define EXCPT_DB		4
>  
>  static int exception_type(int vector)
>  {
> @@ -539,8 +540,14 @@ static int exception_type(int vector)
>  
>  	mask = 1 << vector;
>  
> -	/* #DB is trap, as instruction watchpoints are handled elsewhere */
> -	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
> +	/*
> +	 * #DBs can be trap-like or fault-like, the caller must check other CPU
> +	 * state, e.g. DR6, to determine whether a #DB is a trap or fault.
> +	 */
> +	if (mask & (1 << DB_VECTOR))
> +		return EXCPT_DB;
> +
> +	if (mask & ((1 << BP_VECTOR) | (1 << OF_VECTOR)))
>  		return EXCPT_TRAP;
>  
>  	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
> @@ -8632,6 +8639,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
>  		toggle_interruptibility(vcpu, ctxt->interruptibility);
>  		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
> +
> +		/*
> +		 * Note, EXCPT_DB is assumed to be fault-like as the emulator
> +		 * only supports code breakpoints and general detect #DB, both
> +		 * of which are fault-like.
> +		 */
>  		if (!ctxt->have_exception ||
>  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
>  			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
> @@ -9546,6 +9559,16 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  
>  	/* try to inject new event if pending */
>  	if (vcpu->arch.exception.pending) {
> +		/*
> +		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS
> +		 * value pushed on the stack.  Trap-like exception and all #DBs
> +		 * leave RF as-is (KVM follows Intel's behavior in this regard;
> +		 * AMD states that code breakpoint #DBs excplitly clear RF=0).
> +		 *
> +		 * Note, most versions of Intel's SDM and AMD's APM incorrectly
> +		 * describe the behavior of General Detect #DBs, which are
> +		 * fault-like.  They do _not_ set RF, a la code breakpoints.
> +		 */
>  		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
>  			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
>  					     X86_EFLAGS_RF);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

