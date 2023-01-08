Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628A16616C8
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 17:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjAHQl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 11:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjAHQlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 11:41:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952BFE02B
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 08:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673196042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t7OjNeHz+NEQ3CmjYfEiQoiIMQeUbAFEabOhpJDH948=;
        b=X0yjikOf99ZLEHbyPbCv4+In9Uo/i2rMJ0k/fr4LehZ0J0GDh+ISuBfOfDBrZ2NZWys5q3
        lNJlTuOxMuULQtV8ELhjoKv5KzK/vpzcc0M2tpllXabCV/EmgWvd/5E7wuUbzHqFG22fV0
        Qt1AjMnQ/bW9c8O4/CbHfFunnKE0MeI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-395-wq2yIFOfO-6jNPzh-R7x2g-1; Sun, 08 Jan 2023 11:40:41 -0500
X-MC-Unique: wq2yIFOfO-6jNPzh-R7x2g-1
Received: by mail-ej1-f69.google.com with SMTP id qb2-20020a1709077e8200b00842b790008fso4039756ejc.21
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 08:40:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t7OjNeHz+NEQ3CmjYfEiQoiIMQeUbAFEabOhpJDH948=;
        b=WADQMEiqZZo5WzHrSYf49H2UdFFy90nUOwEulWGfIVPw5gOMnyK8icynZTW5Wk0Xke
         4h/8lhHw3CmuUdBitr7f0t0k2EabtmhxDX8va5JLew6Pe2ZSntjmEMZYHUG1YyCm3Eb9
         PR1Ii1lktBjqd6KDqlwQ+hBBjLGdKPqDxkF8RXQyq8HUBqI4/l+SbQDDYQfGp7irTDVx
         U1Gu1xYq0vhFYG/AavkSt5vIyUG5v5e6HUSMzzTa4kd5Bm18xaev5wYoufJE8n0mD3om
         xkuvrUu/20QCQ8etI2ZeK+FyMXrb2CwwVR945k8goLxmCI5wTtTHxt8pg5qyd/PC/8Yq
         l/fA==
X-Gm-Message-State: AFqh2kp61RuXlmwFeXNL1LdxMdS+g+xfL5hQ/xQy+v0fAdE/19K7DNZG
        WfxqidT05D/B88MPFMXgwduAVwwIM+YYblTc+6Y/e3qoZZn7SsTn23aLnHLa65P9WZ73krq5eto
        arh9GAHkVU24A
X-Received: by 2002:a05:6402:448f:b0:498:1f8:5378 with SMTP id er15-20020a056402448f00b0049801f85378mr5032180edb.16.1673196040279;
        Sun, 08 Jan 2023 08:40:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs2xEWkswfQMyoaNba5bnrW+TRvuUeNNEzA7IbriOaeFE5wtKM03Paig5Lh5oJMG/aj1gZHlg==
X-Received: by 2002:a05:6402:448f:b0:498:1f8:5378 with SMTP id er15-20020a056402448f00b0049801f85378mr5032166edb.16.1673196040116;
        Sun, 08 Jan 2023 08:40:40 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906318900b0080c433a9eeesm2649452ejy.182.2023.01.08.08.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 08:40:39 -0800 (PST)
Message-ID: <ab0e5d5b7f69416d8e39068bbec930dbeafc979e.camel@redhat.com>
Subject: Re: [PATCH 1/6] KVM: x86: Inject #GP if WRMSR sets reserved bits in
 APIC Self-IPI
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Sun, 08 Jan 2023 18:40:37 +0200
In-Reply-To: <20230107011025.565472-2-seanjc@google.com>
References: <20230107011025.565472-1-seanjc@google.com>
         <20230107011025.565472-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 01:10 +0000, Sean Christopherson wrote:
> Inject a #GP if the guest attempts to set reserved bits in the x2APIC-only
> Self-IPI register.  Bits 7:0 hold the vector, all other bits are reserved.
> 
> Reported-by: Marc Orr <marcorr@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Venkatesh Srinivas <venkateshs@chromium.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 80f92cbc4029..f77da92c6ea6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2315,10 +2315,14 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		break;
>  
>  	case APIC_SELF_IPI:
> -		if (apic_x2apic_mode(apic))
> -			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
> -		else
> +		/*
> +		 * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
> +		 * the vector, everything else is reserved.
> +		 */
> +		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK))
>  			ret = 1;
> +		else
> +			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
>  		break;
>  	default:
>  		ret = 1;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

