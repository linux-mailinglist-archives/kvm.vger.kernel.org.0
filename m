Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC85A7B53
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 12:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiHaKZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 06:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiHaKZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 06:25:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD34D647F9
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 03:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661941545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V8h8OUNTnDfV5oRnsul62c5hOJtBjcQSg6IQ5TZZYu0=;
        b=Oy3p62tqQz9Nfg4kmqvra1fUwqDgZiJP6hRjWiwsRHNNhtonR9es+VDduJ1J7gCQdJqjgV
        1f8NS1yHS5y1v6YTew0Xy8twnkgNWFfEfkwAvU+1e+ajsEK0hHZ6NyIhr4MoOv0VanjfTZ
        vGQHOPLD7pOm2WqUPm7Bkjl8++PKj2k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-BRZdk2DyOXShxloZ3yzLEQ-1; Wed, 31 Aug 2022 06:25:41 -0400
X-MC-Unique: BRZdk2DyOXShxloZ3yzLEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DC063803907;
        Wed, 31 Aug 2022 10:25:41 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E5531415133;
        Wed, 31 Aug 2022 10:25:39 +0000 (UTC)
Message-ID: <9144c9921bd46ba7c2b2e9427d053b1fc5abccf7.camel@redhat.com>
Subject: Re: [PATCH 11/19] KVM: SVM: Add helper to perform final AVIC "kick"
 of single vCPU
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 13:25:38 +0300
In-Reply-To: <20220831003506.4117148-12-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Add a helper to perform the final kick, two instances of the ICR decoding
> is one too many.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3959d4766911..2095ece70712 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -329,6 +329,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
>  	put_cpu();
>  }
>  
> +
> +static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
> +{
> +	vcpu->arch.apic->irr_pending = true;
> +	svm_complete_interrupt_delivery(vcpu,
> +					icrl & APIC_MODE_MASK,
> +					icrl & APIC_INT_LEVELTRIG,
> +					icrl & APIC_VECTOR_MASK);
> +}
> +
>  /*
>   * A fast-path version of avic_kick_target_vcpus(), which attempts to match
>   * destination APIC ID to vCPU without looping through all vCPUs.
> @@ -427,11 +437,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  	if (unlikely(!target_vcpu))
>  		return 0;
>  
> -	target_vcpu->arch.apic->irr_pending = true;
> -	svm_complete_interrupt_delivery(target_vcpu,
> -					icrl & APIC_MODE_MASK,
> -					icrl & APIC_INT_LEVELTRIG,
> -					icrl & APIC_VECTOR_MASK);
> +	avic_kick_vcpu(target_vcpu, icrl);
>  	return 0;
>  }
>  
> @@ -455,13 +461,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> -					dest, icrl & APIC_DEST_MASK)) {
> -			vcpu->arch.apic->irr_pending = true;
> -			svm_complete_interrupt_delivery(vcpu,
> -							icrl & APIC_MODE_MASK,
> -							icrl & APIC_INT_LEVELTRIG,
> -							icrl & APIC_VECTOR_MASK);
> -		}
> +					dest, icrl & APIC_DEST_MASK))
> +			avic_kick_vcpu(vcpu, icrl);
>  	}
>  }
>  

I don't know what I think about this, sometimes *minor* code duplication might actually
be a good thing, as it is easier to read the code, but I don't have much against this
as well.

I am not sure if before or after this code is more readable.

But anyway,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

