Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E45A7F10
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 15:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiHaNlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 09:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHaNlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 09:41:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8FEB1BB7
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661953274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XePm1Wn2C5/PBB4+9S1ZWyXG7aF1Sv9dsHs+vGwb/7g=;
        b=D8oPGlm7w+vUC91lIqvs6P5Hbc5VLRmkbChMHafpWzxVP8CD7Gx9l6TKspLPay1GTUJ4xT
        l/SYrabW4E9I2E6GF5SEtiID6HeeBl26KRVaKMrbiifmB93EWp0FAZ+sewKhE9V5pJQa52
        suV50xV66yvTgFExNbogVs940423LF8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-3eaY7tqSMqSrKr5UneepmA-1; Wed, 31 Aug 2022 09:41:11 -0400
X-MC-Unique: 3eaY7tqSMqSrKr5UneepmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 750443C0D86F;
        Wed, 31 Aug 2022 13:41:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2F0D403344;
        Wed, 31 Aug 2022 13:41:07 +0000 (UTC)
Message-ID: <0459cd1568afdbb451190518c2bdaa5a821987df.camel@redhat.com>
Subject: Re: [PATCH 15/19] KVM: x86: Explicitly skip optimized logical map
 setup if vCPU's LDR==0
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 16:41:06 +0300
In-Reply-To: <20220831003506.4117148-16-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-16-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> Explicitly skip the optimized map setup if the vCPU's LDR is '0', i.e. if
> the vCPU will never response to logical mode interrupts.  KVM already
> skips setup in this case, but relies on kvm_apic_map_get_logical_dest()
> to generate mask==0.  KVM still needs the mask=0 check as a non-zero LDR
> can yield mask==0 depending on the mode, but explicitly handling the LDR
> will make it simpler to clean up the logical mode tracking in the future.

If I am not mistaken, the commit description is a bit misleading - in this case we just don't add
the vCPU to the map since it is unreachable, but we do continue creating the map.

Best regards,
	MaxiM Levitsky

> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c224b5c7cd92..8209caffe3ab 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -318,10 +318,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  			continue;
>  
>  		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
> +		if (!ldr)
> +			continue;
>  
>  		if (apic_x2apic_mode(apic)) {
>  			new->mode |= KVM_APIC_MODE_X2APIC;
> -		} else if (ldr) {
> +		} else {
>  			ldr = GET_APIC_LOGICAL_ID(ldr);
>  			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
>  				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;


