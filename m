Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A303389ED3
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 09:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhETHWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 03:22:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44938 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhETHWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 03:22:46 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621495284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qqmyVIWAAm2Cj5GHyXknQl6bxyBJXy6YDxRpreKA3xk=;
        b=ml5djzl2nyTQz6MkOLRFP1bCQ7RaOMgJAYbvJI3UPj40TlxIf3ays7pYTfjybCFsskuizQ
        X9sybAooVjzIWJW/Y9kNPB6DeUoH6B1qiCW8qBr5J94Ns5CnPAg6PzAdVrE7f7UdTaWwBg
        0GjaG1RrlsZRLipvdFoz8ONWXDf+xKQOQwbGFgZ3arnP9g7r/qGVcyaufimEOEoaQFt59O
        cYs0h9Khn22GoZMU09he8wl8KdHcyGtPJOQK6FK5wWtHSxDkUbJ8CsKgcsWHPvDwUDFk48
        gh0uA20UVABISh/weZGIbDk4R1P5Oc3Xto94ftENStHZE9j/9i6FlktsxoGuzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621495284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qqmyVIWAAm2Cj5GHyXknQl6bxyBJXy6YDxRpreKA3xk=;
        b=H7iFbqGOGXYo7ItWW71QFiL7Ikj7LGEDD7K4rZQJBLybpyEX060Emzqhu09fmvipbjn2JX
        MA1EHhF76BIIaEBQ==
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com,
        Stefano De Venuto <stefano.devenuto99@gmail.com>,
        Dario Faggioli <dfaggioli@suse.com>
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the actual event
In-Reply-To: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
Date:   Thu, 20 May 2021 09:21:24 +0200
Message-ID: <875yzddg5n.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19 2021 at 20:23, Stefano De Venuto wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 05eca131eaf2..c77d4866e239 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3275,8 +3275,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	struct kvm_run *kvm_run = vcpu->run;
>  	u32 exit_code = svm->vmcb->control.exit_code;
>  
> -	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
> -
>  	/* SEV-ES guests must use the CR write traps to track CR registers. */
>  	if (!sev_es_guest(vcpu->kvm)) {
>  		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
> @@ -3707,6 +3705,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  
>  	kvm_guest_enter_irqoff();
>  
> +	trace_kvm_entry(vcpu);

No. This violates the noinstr rules and will make objtool complain on a
full validation run.

So this wants to be:

+       instrumentation_begin();
+	trace_kvm_entry(vcpu);
+       instrumentation_end();

  	kvm_guest_enter_irqoff();

and on the exit side the trace wants to be post kvm_guest_exit_irqoff().

Thanks,

        tglx
