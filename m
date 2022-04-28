Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B5C51307F
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 11:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiD1KCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 06:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiD1KB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 06:01:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44E92B369C
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 02:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651139326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DIrH32wTj1zd41+rFOog4cXSZoiSbCaczpxBCYmxL8w=;
        b=FwoGi+SKklS5P9FeDphP8p4jkpL2ioVyrnQQ93Epzi4KYCtuz6cqcNfVk9kkhrlWUscol8
        fb0uqTtw/i2gN8B2XYyjzCE7fadDTBILgeDByvavBDcUVlbA+aX+hS/l7IU05mUQrdi96k
        8XEGTJn7wT6qLyvRR1qy3vh5NlNOF/c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-QbaPfjsqP0eb9Fx7LTLIlA-1; Thu, 28 Apr 2022 05:48:43 -0400
X-MC-Unique: QbaPfjsqP0eb9Fx7LTLIlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85174281AF04;
        Thu, 28 Apr 2022 09:48:42 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 747551121314;
        Thu, 28 Apr 2022 09:48:40 +0000 (UTC)
Message-ID: <339842b37b50c922b94f609bc20bad3edc74dd1f.camel@redhat.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: Trace re-injected exceptions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Thu, 28 Apr 2022 12:48:39 +0300
In-Reply-To: <20220423021411.784383-8-seanjc@google.com>
References: <20220423021411.784383-1-seanjc@google.com>
         <20220423021411.784383-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
> Trace exceptions that are re-injected, not just those that KVM is
> injecting for the first time.  Debugging re-injection bugs is painful
> enough as is, not having visibility into what KVM is doing only makes
> things worse.
> 
> Delay propagating pending=>injected in the non-reinjection path so that
> the tracing can properly identify reinjected exceptions.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/trace.h | 12 ++++++++----
>  arch/x86/kvm/x86.c   | 16 +++++++++-------
>  2 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index de4762517569..d07428e660e3 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -358,25 +358,29 @@ TRACE_EVENT(kvm_inj_virq,
>   * Tracepoint for kvm interrupt injection:
>   */
>  TRACE_EVENT(kvm_inj_exception,
> -	TP_PROTO(unsigned exception, bool has_error, unsigned error_code),
> -	TP_ARGS(exception, has_error, error_code),
> +	TP_PROTO(unsigned exception, bool has_error, unsigned error_code,
> +		 bool reinjected),
> +	TP_ARGS(exception, has_error, error_code, reinjected),
>  
>  	TP_STRUCT__entry(
>  		__field(	u8,	exception	)
>  		__field(	u8,	has_error	)
>  		__field(	u32,	error_code	)
> +		__field(	bool,	reinjected	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->exception	= exception;
>  		__entry->has_error	= has_error;
>  		__entry->error_code	= error_code;
> +		__entry->reinjected	= reinjected;
>  	),
>  
> -	TP_printk("%s (0x%x)",
> +	TP_printk("%s (0x%x)%s",
>  		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
>  		  /* FIXME: don't print error_code if not present */
> -		  __entry->has_error ? __entry->error_code : 0)
> +		  __entry->has_error ? __entry->error_code : 0,
> +		  __entry->reinjected ? " [reinjected]" : "")
>  );
>  
>  /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 951d0a78ccda..c3ee8dc00d3a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9393,6 +9393,11 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
>  
>  static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  {
> +	trace_kvm_inj_exception(vcpu->arch.exception.nr,
> +				vcpu->arch.exception.has_error_code,
> +				vcpu->arch.exception.error_code,
> +				vcpu->arch.exception.injected);
> +
>  	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
>  		vcpu->arch.exception.error_code = false;
>  	static_call(kvm_x86_queue_exception)(vcpu);
> @@ -9450,13 +9455,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  
>  	/* try to inject new event if pending */
>  	if (vcpu->arch.exception.pending) {
> -		trace_kvm_inj_exception(vcpu->arch.exception.nr,
> -					vcpu->arch.exception.has_error_code,
> -					vcpu->arch.exception.error_code);
> -
> -		vcpu->arch.exception.pending = false;
> -		vcpu->arch.exception.injected = true;
> -
>  		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
>  			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
>  					     X86_EFLAGS_RF);
> @@ -9470,6 +9468,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  		}
>  
>  		kvm_inject_exception(vcpu);
> +
> +		vcpu->arch.exception.pending = false;
> +		vcpu->arch.exception.injected = true;
> +
>  		can_inject = false;
>  	}
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

