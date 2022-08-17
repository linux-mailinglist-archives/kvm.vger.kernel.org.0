Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D245970B5
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 16:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbiHQOLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 10:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbiHQOKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 10:10:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5588F2C65D
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660745453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOZ/Fo5+tFsXrRp7V2JvhBrlq1tRQEPA6tmtYxa2xsw=;
        b=GdbIvlZgklcmkEvC8kLM/27YvTfwktxY5wkMlh1/PFL3tUvsWF+y1JTobO47aoqvsGseRA
        tZXod+9KxtqJRSNs1YstgLFl2l/WfAB/jqp1L6meARfEEs8GixOi5jSSULAAVTbbBmE5Si
        BocZ0IdImsLXbae9U8vG73zxzkzXfcE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-53-6bltjH58MmuPEwdubIQk1Q-1; Wed, 17 Aug 2022 10:10:52 -0400
X-MC-Unique: 6bltjH58MmuPEwdubIQk1Q-1
Received: by mail-wm1-f71.google.com with SMTP id 203-20020a1c02d4000000b003a5f5bce876so1134724wmc.2
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=qOZ/Fo5+tFsXrRp7V2JvhBrlq1tRQEPA6tmtYxa2xsw=;
        b=mD3VpQ4Je35U33mA5/Stja4T9i1PxcjQc3UD2IAp6DzPyUHJjt3/hg7HGLIVCG9+1C
         UcuNpvFe4neT23e7KAR2/Km7cKvOCizsDPiBn9PwOmjn5Qr5p1MvC72FmSjpQ6IT8gqa
         pZtP/uVXqvuZseb76jYDbc6c1ve6DoLN4CZ73SJvw1cp2eztUHRVyCsGmhkuj1N298v3
         NeilKFuslM1D7eMpgzXLsk6uqxsAKv2zqtqDs5QVfhVtvBX5DVxj2cGvlog/KmFuyOcQ
         0ZQfho+WaUcikFb72X9HLDPR45qD4yWt9EHEMbnf0SzlHIPud8wzEB3ez4ltUgkIvrX4
         Vhxw==
X-Gm-Message-State: ACgBeo30eOG1Zq4MbChRRZBgVAEHQrjq4FeU1BEBK4DRqalmca6feY3X
        zaofb7D+QxRCkOLaSuCFNaCiQMDQ3oY6q9Qfzerkf2h2Zs1lc+D/0BS0OiuqxDGSKiT3H1qAPuv
        IEUBUfbHp3gMQ
X-Received: by 2002:a05:600c:3551:b0:3a5:dcf3:1001 with SMTP id i17-20020a05600c355100b003a5dcf31001mr2276958wmq.58.1660745450684;
        Wed, 17 Aug 2022 07:10:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR58G0ucipVG1zoomQ54t6Q4CZWMYLkuIME2kcebAMM2iKXur0xYInRpdAoww212mcGvD+xi/g==
X-Received: by 2002:a05:600c:3551:b0:3a5:dcf3:1001 with SMTP id i17-20020a05600c355100b003a5dcf31001mr2276941wmq.58.1660745450441;
        Wed, 17 Aug 2022 07:10:50 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id p22-20020a05600c359600b003a35516ccc3sm3147241wmq.26.2022.08.17.07.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:10:49 -0700 (PDT)
Message-ID: <f1c5988b5a7c7ef95fa190e27ff48c7a84b3363a.camel@redhat.com>
Subject: Re: [PATCH v2 6/9] KVM: x86: make vendor code check for all nested
 events
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com
Date:   Wed, 17 Aug 2022 17:10:48 +0300
In-Reply-To: <20220811210605.402337-7-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
         <20220811210605.402337-7-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-11 at 17:06 -0400, Paolo Bonzini wrote:
> Interrupts, NMIs etc. sent while in guest mode are already handled
> properly by the *_interrupt_allowed callbacks, but other events can
> cause a vCPU to be runnable that are specific to guest mode.
> 
> In the case of VMX there are two, the preemption timer and the
> monitor trap.  The VMX preemption timer is already special cased via
> the hv_timer_pending callback, but the purpose of the callback can be
> easily extended to MTF or in fact any other event that can occur only
> in guest mode.

I am just curious, can this happen with MTF? I see that 'vmx->nested.mtf_pending'
is only set from 'vmx_update_emulated_instruction' and that should only
in turn be called when we emulate an instruction, which implies that the
guest is not halted.

> 
> Rename the callback and add an MTF check; kvm_arch_vcpu_runnable()
> now will return true if an MTF is pending, without relying on
> kvm_vcpu_running()'s call to kvm_check_nested_events().  Until that call
> is removed, however, the patch introduces no functional change.
> 
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/nested.c       | 9 ++++++++-
>  arch/x86/kvm/x86.c              | 8 ++++----
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5ffa578cafe1..293ff678fff5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1636,7 +1636,7 @@ struct kvm_x86_nested_ops {
>         int (*check_events)(struct kvm_vcpu *vcpu);
>         bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
>                                              struct x86_exception *fault);
> -       bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
> +       bool (*has_events)(struct kvm_vcpu *vcpu);
>         void (*triple_fault)(struct kvm_vcpu *vcpu);
>         int (*get_state)(struct kvm_vcpu *vcpu,
>                          struct kvm_nested_state __user *user_kvm_nested_state,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ddd4367d4826..9631cdcdd058 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3876,6 +3876,13 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
>                to_vmx(vcpu)->nested.preemption_timer_expired;
>  }
>  
> +static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +       return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
> +}
> +
>  static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -6816,7 +6823,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
>         .leave_nested = vmx_leave_nested,
>         .check_events = vmx_check_nested_events,
>         .handle_page_fault_workaround = nested_vmx_handle_page_fault_workaround,
> -       .hv_timer_pending = nested_vmx_preemption_timer_pending,
> +       .has_events = vmx_has_nested_events,
>         .triple_fault = nested_vmx_triple_fault,
>         .get_state = vmx_get_nested_state,
>         .set_state = vmx_set_nested_state,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7f084613fac8..0f9f24793b8a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9789,8 +9789,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>         }
>  
>         if (is_guest_mode(vcpu) &&
> -           kvm_x86_ops.nested_ops->hv_timer_pending &&
> -           kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
> +           kvm_x86_ops.nested_ops->has_events &&
> +           kvm_x86_ops.nested_ops->has_events(vcpu))
>                 *req_immediate_exit = true;
>  
>         WARN_ON(vcpu->arch.exception.pending);
> @@ -12562,8 +12562,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>                 return true;
>  
>         if (is_guest_mode(vcpu) &&
> -           kvm_x86_ops.nested_ops->hv_timer_pending &&
> -           kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
> +           kvm_x86_ops.nested_ops->has_events &&
> +           kvm_x86_ops.nested_ops->has_events(vcpu))
>                 return true;
>  
>         if (kvm_xen_has_pending_events(vcpu))

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



