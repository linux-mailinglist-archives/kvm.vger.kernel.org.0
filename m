Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD447BA3C2
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbjJEP6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 11:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbjJEP5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 11:57:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250D955A6
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 06:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696513987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wFXkRm4gY14hMhsAT8GvHSV1B4LV0i4em53ilYk8fI=;
        b=O5asuzo/L7CvWaX5LM6KF9c+cYbf28m/pD2URjh28va9QcCYp40gnonJiONNzYWlTXs/Xv
        uKeToyvuWbeEbpU3CVov06qBdg9Hrq+htxyD1yRuvB+ytagsPoH+OSOebQodIfyMwj1RoO
        AIgFohcQRs1vxF2bHFDbt4QbWtdCphY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-axoP1cdiMvCxza6at-y2rw-1; Thu, 05 Oct 2023 08:51:29 -0400
X-MC-Unique: axoP1cdiMvCxza6at-y2rw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32480c0ad52so809107f8f.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510288; x=1697115088;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/wFXkRm4gY14hMhsAT8GvHSV1B4LV0i4em53ilYk8fI=;
        b=FvFKbFNYVOGBtb0zIFMySMgMcgg9DBkulB689lpGesTgnRddMlGPgly2lRlYjkz2/s
         /HvcIGPLWIHGgtpoK3FYuxc5bvyqeEQj2xBf8JiYM1hNmqxzMgixyC4DXEn+11Kb3dW0
         RKGHUrMwSHCAxKfaATFXjU2MfAY4rKsppjLMeLwbmO9VDveGCYhd9lqY0EpVs0fAu0eo
         ypHQ0pITgtMLB3YGRW0JWWHhZDezz6mhxVNa7k0pKXQj1nMBY7ZARxdY6KHvh7PedMMI
         Gdl1RAfHl/zd70HsjfrXJ5Ac946hD7HFqDt575C3c9T5iEOJ4oSNwHsbPOe/HIYxzyI+
         xG3w==
X-Gm-Message-State: AOJu0Yz5JBzcsmGYM91fXBAOdfaug7zZIudhFt6QfotIhJopUgKfi2Zz
        OEO9utYdycEQ+jO0EN7jRe4Q0NYO/JnTrltpvT+BRkfOFBddNv7vTwW4cY5mTvAFlW5KLhDySeB
        4vRnYtEg9wW/G
X-Received: by 2002:a05:6000:108d:b0:31f:a62d:264 with SMTP id y13-20020a056000108d00b0031fa62d0264mr4737275wrw.37.1696510288051;
        Thu, 05 Oct 2023 05:51:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXTzdXlNC9fz+PgD6KTMShrngrXbnyjvf54XpsWr2w2xQiZBM3CY1iJbVUEVIYWDGQd06vjw==
X-Received: by 2002:a05:6000:108d:b0:31f:a62d:264 with SMTP id y13-20020a056000108d00b0031fa62d0264mr4737259wrw.37.1696510287743;
        Thu, 05 Oct 2023 05:51:27 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id b2-20020a5d5502000000b00323330edbc7sm1730082wrv.20.2023.10.05.05.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:51:27 -0700 (PDT)
Message-ID: <08a44cace7c5da396b5b81415a66eaa1737c2a8b.camel@redhat.com>
Subject: Re: [PATCH 07/10] KVM: SVM: Inhibit AVIC if ID is too big instead
 of rejecting vCPU creation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:51:25 +0300
In-Reply-To: <20230815213533.548732-8-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Inhibit AVIC with a new "ID too big" flag if userspace creates a vCPU with
> an ID that is too big, but otherwise allow vCPU creation to succeed.
> Rejecting KVM_CREATE_VCPU with EINVAL violates KVM's ABI as KVM advertises
> that the max vCPU ID is 4095, but disallows creating vCPUs with IDs bigger
> than 254 (AVIC) or 511 (x2AVIC).
> 
> Alternatively, KVM could advertise an accurate value depending on which
> AVIC mode is in use, but that wouldn't really solve the underlying problem,
> e.g. would be a breaking change if KVM were to ever try and enable AVIC or
> x2AVIC by default.
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/svm/avic.c         | 16 ++++++++++++++--
>  arch/x86/kvm/svm/svm.h          |  3 ++-
>  3 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 60d430b4650f..4c2d659a1269 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1243,6 +1243,12 @@ enum kvm_apicv_inhibit {
>  	 * mapping between logical ID and vCPU.
>  	 */
>  	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
> +
> +	/*
> +	 * AVIC is disabled because the vCPU's APIC ID is beyond the max
> +	 * supported by AVIC/x2AVIC, i.e. the vCPU is unaddressable.
> +	 */
> +	APICV_INHIBIT_REASON_ID_TOO_BIG,

I prefer APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG

>  };
>  
>  struct kvm_arch {
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index bd81e3517838..522feaa711b4 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -284,9 +284,21 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	/*
> +	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> +	 * hardware.  Do so immediately, i.e. don't defer the update via a
> +	 * request, as avic_vcpu_load() expects to be called if and only if the
> +	 * vCPU has fully initialized AVIC.  Bypass all of the helpers and just
> +	 * clear apicv_active directly, the vCPU isn't reachable and the VMCB
> +	 * isn't even initialized at this point, i.e. there is no possibility
> +	 * of needing to deal with the n

Which helpers do you bypass? I see a call to normal kvm_set_apicv_inhibit() as it should be.

Note that userspace can add vCPUs at will so this can happen any time during 
the guest's lifetime so I don't think that this code can bypass anything.

> +	 */
>  	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
> -	    (id > X2AVIC_MAX_PHYSICAL_ID))
> -		return -EINVAL;
> +	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
> +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_ID_TOO_BIG);
> +		vcpu->arch.apic->apicv_active = false;
> +		return 0;
> +	}
>  
>  	if (!vcpu->arch.apic->regs)
>  		return -EINVAL;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a9fde1bb85ee..8b798982e5d0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -632,7 +632,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
>  	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
>  	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
> -	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
> +	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
> +	BIT(APICV_INHIBIT_REASON_ID_TOO_BIG)		\

>  )
>  
>  bool avic_hardware_setup(void);


Best regards,
	Maxim Levitsky



