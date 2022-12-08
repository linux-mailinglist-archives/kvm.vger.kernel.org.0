Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED7E647835
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLHVsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiLHVsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:48:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4DF4A5B8
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PUn88kset4HAzJbUXBNIH/b2J7ZZibM+Mo4PtkGwqW4=;
        b=htbBk2Z8l+87utzcGTvWoMjwN+K+pOdB6KM+mvLmov65U+lSF1aNlxcIkDdi85USL+Z4tG
        kh+6FJE+hXbfrxMDUSF8tDJw1oyCs0aVvg2CTwDFkhKC3JCvRQNlMFOEp5M3th10MTQX3f
        QDVcnmVmeI0aDL3rt/16AG891Cm1/Y8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-fr63VZaSPwC-AUW6Y1p4Ng-1; Thu, 08 Dec 2022 16:47:17 -0500
X-MC-Unique: fr63VZaSPwC-AUW6Y1p4Ng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A2773C0F7F2;
        Thu,  8 Dec 2022 21:47:17 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9998540C2065;
        Thu,  8 Dec 2022 21:47:15 +0000 (UTC)
Message-ID: <5419dc450ddc835296ffcffe871e404d0f9d52f6.camel@redhat.com>
Subject: Re: [PATCH v4 02/32] KVM: x86: Purge "highest ISR" cache when
 updating APICv state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:47:14 +0200
In-Reply-To: <20221001005915.2041642-3-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Purge the "highest ISR" cache when updating APICv state on a vCPU.  The
> cache must not be used when APICv is active as hardware may emulate EOIs
> (and other operations) without exiting to KVM.
> 
> This fixes a bug where KVM will effectively block IRQs in perpetuity due
> to the "highest ISR" never getting reset if APICv is activated on a vCPU
> while an IRQ is in-service.  Hardware emulates the EOI and KVM never gets
> a chance to update its cache.
> 
> Fixes: b26a695a1d78 ("kvm: lapic: Introduce APICv update helper function")
> Cc: stable@vger.kernel.org
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 05d079fc2c66..5de1c7aa1ce9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2424,6 +2424,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
>  		 */
>  		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
>  	}
> +	apic->highest_isr_cache = -1;
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
>  
> @@ -2480,7 +2481,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
>  	}
>  	kvm_apic_update_apicv(vcpu);
> -	apic->highest_isr_cache = -1;
>  	update_divide_count(apic);
>  	atomic_set(&apic->lapic_timer.pending, 0);
>  
> @@ -2767,7 +2767,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	__start_apic_timer(apic, APIC_TMCCT);
>  	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>  	kvm_apic_update_apicv(vcpu);
> -	apic->highest_isr_cache = -1;
>  	if (apic->apicv_active) {
>  		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
>  		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

