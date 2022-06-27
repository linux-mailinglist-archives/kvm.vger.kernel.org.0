Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3312455D58E
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbiF0QG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238243AbiF0QG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:06:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6584D122
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656345987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Et0fBT88jZFdIetfnOLa7eYQfFaPq0dKwFkCGFAcX7M=;
        b=Q+qWb1X74qJACt9pYJ2VKjG+Uark5F/IICGDll22mumk84f/8JPB1i1P7N+tAolLM9wu0O
        Tm1OOtVBYIzn+lKXEeP/wrLqt5kXJ+TbYUnoFP3SzMMWgkUOIDndPS4EEi2USmZcRlFzsX
        xpbqIMwDrUTekzjEI6DWH9ykV7M00BA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-9QEkrnpSNxum0L4WuHdHZg-1; Mon, 27 Jun 2022 12:06:24 -0400
X-MC-Unique: 9QEkrnpSNxum0L4WuHdHZg-1
Received: by mail-wm1-f70.google.com with SMTP id r65-20020a1c4444000000b003a02a3f0beeso5934939wma.3
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Et0fBT88jZFdIetfnOLa7eYQfFaPq0dKwFkCGFAcX7M=;
        b=gPGm7i3B6LHJMK1TfFkFX0xRtpSWTyWT5px1dwT3VFndww8O/7QkVE8LPIbqRBNwZc
         zxjAROq9KyrtQqZzDZCjeob7bru9ajqysEIxQ3Fx4nVmrAOSU03B0W57lYfxlD7Kmb88
         UX973omHp834Tj22eS6n57RttG0014LoGE+iEAn78/rv2w749qcK6aa/1mFqH3KvHcoE
         7Iy7SgcK1Yp4lpWw/fjjCiZmX4ZoDcItE8zPr4483LYJ34cjPhePQUFavlV75fzRxNF3
         z8pzyJwMEPze8VKIPlmsl/gRbqJLPn9J2PEJQ7EvAnTlYGkCKN43hi1yNcwbdbbdYflT
         xICA==
X-Gm-Message-State: AJIora84BdJTdh/22RTie4GL6yjhIAUvwlWKymydLFa+wSJZZB1SfOkU
        S1f22EOxVjxB24akW4ur1v0Qg+WEVM35v15ztbmR5AG7OaBimzt46syC9TlgkcSHW2Yg38Lyy86
        t81VRjBpLFlAy
X-Received: by 2002:a05:600c:4f08:b0:39c:9437:da06 with SMTP id l8-20020a05600c4f0800b0039c9437da06mr15904996wmq.181.1656345983673;
        Mon, 27 Jun 2022 09:06:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v+tzLlkmyLWgs6sbrQRofFBaYY7XIFbbta3ZJQIjl0O65OYMJ11jwxkV5OFeVW9JYuXDa+jw==
X-Received: by 2002:a05:600c:4f08:b0:39c:9437:da06 with SMTP id l8-20020a05600c4f0800b0039c9437da06mr15904963wmq.181.1656345983407;
        Mon, 27 Jun 2022 09:06:23 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z22-20020a05600c221600b003a0499df21asm5169981wml.25.2022.06.27.09.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 09:06:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 00/10] KVM: nVMX: Use vmcs_config for setting up
 nested VMX MSRs
In-Reply-To: <YrUF1Zj35BYvXrB6@google.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
 <YrUF1Zj35BYvXrB6@google.com>
Date:   Mon, 27 Jun 2022 18:06:21 +0200
Message-ID: <87tu86um4i.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jun 22, 2022, Vitaly Kuznetsov wrote:
>> vmcs_config is a sanitized version of host VMX MSRs where some controls are
>> filtered out (e.g. when Enlightened VMCS is enabled, some know bugs are 
>> discovered, some inconsistencies in controls are detected,...) but
>> nested_vmx_setup_ctls_msrs() uses raw host MSRs instead. This may end up
>> in exposing undesired controls to L1. Switch to using vmcs_config instead.
>> 
>> RFC part: vmcs_config's sanitization now is a mix of "what can't be enabled"
>> and "what KVM doesn't want" and we need to separate these as for nested VMX
>> MSRs only the first category makes sense. This gives vmcs_config a slightly
>> different meaning "controls which can be (theoretically) used". An alternative
>> approach would be to store sanitized host MSRs values separately, sanitize
>> them and and use in nested_vmx_setup_ctls_msrs() but currently I don't see
>> any benefits. Comments welcome!
>
> I like the idea overall, even though it's a decent amount of churn.  It seems
> easier to maintain than separate paths for nested.  The alternative would be to
> add common helpers to adjust the baseline configurations, but I don't see any
> way to programmatically make that approach more robust.
>
> An idea to further harden things.  Or: an excuse to extend macro shenanigans :-)
>
> If we throw all of the "opt" and "min" lists into macros, e.g. KVM_REQUIRED_*
> and KVM_OPTIONAL_*, and then use those to define a KVM_KNOWN_* field, we can
> prevent using the mutators to set/clear unknown bits at runtime via BUILD_BUG_ON().
> The core builders, e.g. vmx_exec_control(), can still set unknown bits, i.e. set
> bits that aren't enumerated to L1, but that's easier to audit and this would catch
> regressions for the issues fixed in patches.
>
> It'll required making add_atomic_switch_msr_special() __always_inline (or just
> open code it), but that's not a big deal.
>
> E.g. if we have
>
>   #define KVM_REQUIRED_CPU_BASED_VM_EXEC_CONTROL <blah blah blah>
>   #define KVM_OPTIONAL_CPU_BASED_VM_EXEC_CONTROL <blah blah blah>
>
> Then the builders for the controls shadows can do:
>
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 286c88e285ea..5eb75822a09e 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -468,6 +468,8 @@ static inline u8 vmx_get_rvi(void)
>  }
>  
>  #define BUILD_CONTROLS_SHADOW(lname, uname, bits)                              \
> +#define KVM_KNOWN_ ## uname                                                    \
> +       (KVM_REQUIRED_ ## uname | KVM_OPTIONAL_ ## uname)                       \

I'm certainly not a macro jedi and I failed to make this compile as gcc
hates when I put '#define's in macros but I made a simpler version with
(presumeably) the same outcome. v1 is out, thanks for the suggestion!

>  static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)     \
>  {                                                                              \
>         if (vmx->loaded_vmcs->controls_shadow.lname != val) {                   \
> @@ -485,10 +487,12 @@ static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)          \
>  }                                                                              \
>  static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)  \
>  {                                                                              \
> +       BUILD_BUG_ON(!(val & KVM_KNOWN_ ## uname));                             \
>         lname##_controls_set(vmx, lname##_controls_get(vmx) | val);             \
>  }                                                                              \
>  static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)        \
>  {                                                                              \
> +       BUILD_BUG_ON(!(val & KVM_KNOWN_ ## uname));                             \
>         lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);            \
>  }
>  BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
>
>
>
> Handling the controls that are restricted to CONFIG_X86_64=y will be midly annoying,
> but adding a base set isn't too bad, e.g.
>
> #define __KVM_REQUIRED_CPU_BASED_VM_EXEC_CONTROL <blah blah blah>
> #ifdef CONFIG_X86_64
> #define KVM_REQUIRED_CPU_BASED_VM_EXEC_CONTROL (__KVM_REQUIRED_CPU_BASED_VM_EXEC_CONTROL | \
> 						CPU_BASED_CR8_LOAD_EXITING |		   \
> 						CPU_BASED_CR8_STORE_EXITING)
> #else
> #define KVM_REQUIRED_CPU_BASED_VM_EXEC_CONTROL __KVM_REQUIRED_CPU_BASED_VM_EXEC_CONTROL
> #endif
>

-- 
Vitaly

