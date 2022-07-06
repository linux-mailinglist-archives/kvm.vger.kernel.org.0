Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB8C5687BF
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiGFMFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiGFMFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:05:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B942729C9A
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657109099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3n3kg3o2B5nWwM7ZG/qWhzB4HjUo/XQlyxdpJa1Hq3k=;
        b=CQx+cUIBeVY3+ilW+/38F84fRIUmHwN5t4exWcxDImzahcVNS5vgsU+BpPLHxwBax82N6f
        JT1I0TfGHFI4XulcxGFXrDHv9zDicQSdioOr6bVgoHcweheHa0qzgZsE1ZKoK03OAeBcEk
        LhyE+y28zsMqb+PUt+rc5RDk/YnBP+k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-CbAS9K72MrepWRKCA7RIiA-1; Wed, 06 Jul 2022 08:04:49 -0400
X-MC-Unique: CbAS9K72MrepWRKCA7RIiA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58E66802D1C;
        Wed,  6 Jul 2022 12:04:49 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0855FC04482;
        Wed,  6 Jul 2022 12:04:46 +0000 (UTC)
Message-ID: <5f77a21bd64c2a1f6bc717e823725d62a694ea34.camel@redhat.com>
Subject: Re: [PATCH v2 14/21] KVM: x86: Use kvm_queue_exception_e() to queue
 #DF
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:04:45 +0300
In-Reply-To: <20220614204730.3359543-15-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-15-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Queue #DF by recursing on kvm_multiple_exception() by way of
> kvm_queue_exception_e() instead of open coding the behavior.  This will
> allow KVM to Just Work when a future commit moves exception interception
> checks (for L2 => L1) into kvm_multiple_exception().

Typo: You mean Just Work (tm) ;-) 

> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 511c0c8af80e..e45465075005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -663,25 +663,22 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>  	}
>  	class1 = exception_class(prev_nr);
>  	class2 = exception_class(nr);
> -	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
> -		|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
> +	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY) ||
> +	    (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
>  		/*
> -		 * Generate double fault per SDM Table 5-5.  Set
> -		 * exception.pending = true so that the double fault
> -		 * can trigger a nested vmexit.
> +		 * Synthesize #DF.  Clear the previously injected or pending
> +		 * exception so as not to incorrectly trigger shutdown.
>  		 */
> -		vcpu->arch.exception.pending = true;
>  		vcpu->arch.exception.injected = false;
> -		vcpu->arch.exception.has_error_code = true;
> -		vcpu->arch.exception.vector = DF_VECTOR;
> -		vcpu->arch.exception.error_code = 0;
> -		vcpu->arch.exception.has_payload = false;
> -		vcpu->arch.exception.payload = 0;
> -	} else
> +		vcpu->arch.exception.pending = false;
> +
> +		kvm_queue_exception_e(vcpu, DF_VECTOR, 0);
> +	} else {
>  		/* replace previous exception with a new one in a hope
>  		   that instruction re-execution will regenerate lost
>  		   exception */
>  		goto queue;
> +	}
>  }
>  
>  void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

