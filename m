Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC20A6734C5
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 10:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjASJuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 04:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjASJt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 04:49:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09846B991;
        Thu, 19 Jan 2023 01:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n9ShCI5SqUuw0LHZza+w96OHBa8sMt5AxJi4PRDnQTo=; b=UXGyFKtdG5wDiGqOEE2A15YN/u
        rQhls/O6cIT0l6SE1oxkPh8IIcSwEyek1x73YYOM2NGkZeM8SpYoTC7NeHx9uwjAtuAj19B99iURg
        vED0oMbdfcojGVrp5cJ8MKfP2AGlkMTkoU83btDPXkK39S50qh1k6tPONoGQ1OfcnMNqrVbuN4qvD
        3NaWIFI5eMWx6+P/WLpcc7gRVO7rdTKMIFxyiBmvED7L1fF6LoSTChZEgGroH/S5oCunqDXVdzV9t
        ftzltF/Hw+/g2tGnwCRvFjofls8ABatbfllzUIxYDVS8l0SjlLypQgChKWsHUvemenQPewSfZeBBW
        ZP2FHVrA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIRY6-000qn4-6p; Thu, 19 Jan 2023 09:49:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9065F30012F;
        Thu, 19 Jan 2023 10:49:32 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5286B2011B922; Thu, 19 Jan 2023 10:49:32 +0100 (CET)
Date:   Thu, 19 Jan 2023 10:49:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 7/7] KVM: VMX: Handle NMI VM-Exits in noinstr region
Message-ID: <Y8kSLBwUuqzlcSEZ@hirez.programming.kicks-ass.net>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-8-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213060912.654668-8-seanjc@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 06:09:12AM +0000, Sean Christopherson wrote:

> @@ -7119,6 +7118,18 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  
>  	vmx_enable_fb_clear(vmx);
>  
> +	if (unlikely(vmx->fail))
> +		vmx->exit_reason.full = 0xdead;
> +	else
> +		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
> +
> +	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
> +	    is_nmi(vmx_get_intr_info(vcpu))) {
> +		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> +		vmx_do_nmi_irqoff();
> +		kvm_after_interrupt(vcpu);
> +	}
> +
>  	guest_state_exit_irqoff();
>  }

I think we're going to have to sprinkle __always_inline on the
kvm_{before,after}_interrupt() things (or I missed the earlier patches
doing this already), sometimes compilers are just weird.
