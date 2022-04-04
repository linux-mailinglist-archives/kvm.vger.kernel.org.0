Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109F74F1485
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 14:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241126AbiDDMQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 08:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbiDDMQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C28635F5C
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 05:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649074459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k11A/AZt+oc87Hz3W5TrMPkcAHCJtsmjAAnrVjuNJG4=;
        b=KG8KfuToKgm3QKpCZtqyD4d9m329X02yfOw4uXm2EjbPBcq/+Ezt/PsOhZqgwR8LKiKFQ6
        ssyO7+JBfrLewLQQyZ5R4LokPH6u2lzlJgFn7YGHCFbOosnARAVkW+BHv9/khy1NDiW+sa
        poUxutBpVtUVFBmlWJPes7fYT6Aasdg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-MSaBRzuKOOCwVdKK93OiZQ-1; Mon, 04 Apr 2022 08:14:17 -0400
X-MC-Unique: MSaBRzuKOOCwVdKK93OiZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C8F538035A2;
        Mon,  4 Apr 2022 12:14:11 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCA07202F2F1;
        Mon,  4 Apr 2022 12:14:03 +0000 (UTC)
Message-ID: <df8e53474fb161f83c8cb8b9816995b23798545b.camel@redhat.com>
Subject: Re: [PATCH 7/8] KVM: x86: Trace re-injected exceptions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Mon, 04 Apr 2022 15:14:01 +0300
In-Reply-To: <20220402010903.727604-8-seanjc@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
         <20220402010903.727604-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-02 at 01:09 +0000, Sean Christopherson wrote:
> Trace exceptions that are re-injected, not just those that KVM is
> injecting for the first time.  Debugging re-injection bugs is painful
> enough as is, not having visibility into what KVM is doing only makes
> things worse.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7a066cf92692..384091600bc2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9382,6 +9382,10 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
>  
>  static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  {
> +	trace_kvm_inj_exception(vcpu->arch.exception.nr,
> +				vcpu->arch.exception.has_error_code,
> +				vcpu->arch.exception.error_code);
> +

Can we use a {new tracepoint / new parameter for this tracepoint} for this to avoid confusion?

Best regards,
	Maxim Levitsky



>  	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
>  		vcpu->arch.exception.error_code = false;
>  	static_call(kvm_x86_queue_exception)(vcpu);
> @@ -9439,10 +9443,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  
>  	/* try to inject new event if pending */
>  	if (vcpu->arch.exception.pending) {
> -		trace_kvm_inj_exception(vcpu->arch.exception.nr,
> -					vcpu->arch.exception.has_error_code,
> -					vcpu->arch.exception.error_code);
> -
>  		vcpu->arch.exception.pending = false;
>  		vcpu->arch.exception.injected = true;
>  


