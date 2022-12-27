Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7587D656E97
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 21:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiL0UUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 15:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiL0UUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 15:20:22 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A08CB35
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:20:20 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id b192so7377239iof.8
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oUdac+MaBje7dX/XEq6/cPZiPaJDSdQLf+a0j0f0Qqs=;
        b=H6vvZyL1skdR13RvGEshUaU8gUIScSnwMf3TGZ6LIUQCjoVdwDNOD8cjd7ALF0m3hz
         HtJDrnlnBlorNyxICsJfwlgL91qpBG+rXe9NYupt4qAehTEqtRUjW8Eh92/6N6EVOhM6
         4EiwtdcdRSl0T5NkiAdWwQ8SXiWyIgmxTqaT1sxAuXk9npXkczgTlvoxJDYi1YnNYKqZ
         eWGU90oL3qgHk/5Rjz9xHGETlWWYZEitZyMyZfw/25Fv261NyDDYoI5i4OKZQ2uJnCNg
         v2+Dd0eDxPvZJmmc8Vk48QZAA8bLLuuzATPixi6n8lTckyjWHZZhmTdWrstrdzt6jqBU
         ho3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oUdac+MaBje7dX/XEq6/cPZiPaJDSdQLf+a0j0f0Qqs=;
        b=uGW0v1NKFTdCCe1UgCwnXRQI+ntSY6Creb+m6It+WWcXwIiy+WbxypaPUSw/YMVUx2
         /Dy25uZR04nj8wc9TcBxw8ckG0MWNW6CjjoIIvac2+quN8RTFlTb2t/vT3EyX2LEJbzf
         ictPojo4/mIrWgveWeB8M/aZvN6+E8JX1g7tQXwpUFEeZZ55gSYLsMqR+7uUL43ajsnT
         MFSYmNAmbPxgwvhQ0y/oJy6Kj68gWg/j4fkEllnZjLWFQSDwaVOSs31pcWBLPDx5strX
         pSxuCgLMJ47jnyhyt53IzlQEM59xzwGzSOQPM6T0GtvjOHgXYubNMFyIR+7y9tdlBUxu
         LPxA==
X-Gm-Message-State: AFqh2kqepHSGq8EO5VkGteV/fAAvmqBsKUP5chbC6jyMjxVZlbEtXUwl
        wFsGQr4PFgooYrNol6oQlPPhpsLC7yQdQvhKZepD8Q==
X-Google-Smtp-Source: AMrXdXs4LQM1m7FgXjaY8gGUH1zxONsQeP5eBG3gk7IFl8MKFT+TJ3hPwJyZ7yEfUyWs3ni8d1UZgbvOe0kRgu/3i1U=
X-Received: by 2002:a02:340b:0:b0:38a:2499:c04b with SMTP id
 x11-20020a02340b000000b0038a2499c04bmr1852258jae.72.1672172419223; Tue, 27
 Dec 2022 12:20:19 -0800 (PST)
MIME-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com> <20221212183720.4062037-3-vipinsh@google.com>
In-Reply-To: <20221212183720.4062037-3-vipinsh@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 27 Dec 2022 20:20:08 +0000
Message-ID: <CAAAPnDH3sg4rmHi7uirOB5oYwr-Ub+O0+fxdg5XiO5oCU0i1OQ@mail.gmail.com>
Subject: Re: [Patch v4 02/13] KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 6:37 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> CPUID_8000_0007_EDX may come handy when X86_FEATURE_CONSTANT_TSC
> needs to be checked.
>
> No functional change intended.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c         | 8 ++++++--
>  arch/x86/kvm/reverse_cpuid.h | 7 +++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 723502181a3a..42913695fedd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -701,6 +701,10 @@ void kvm_set_cpu_caps(void)
>         if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
>                 kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
>
> +       kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
> +               SF(CONSTANT_TSC)
> +       );
> +
>         kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>                 F(CLZERO) | F(XSAVEERPTR) |
>                 F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> @@ -1153,8 +1157,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 entry->edx &= ~GENMASK(17, 16);
>                 break;
>         case 0x80000007: /* Advanced power management */
> -               /* invariant TSC is CPUID.80000007H:EDX[8] */
> -               entry->edx &= (1 << 8);
> +               cpuid_entry_override(entry, CPUID_8000_0007_EDX);
> +
>                 /* mask against host */
>                 entry->edx &= boot_cpu_data.x86_power;
>                 entry->eax = entry->ebx = entry->ecx = 0;
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 203fdad07bae..25b9b51abb20 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -14,6 +14,7 @@
>  enum kvm_only_cpuid_leafs {
>         CPUID_12_EAX     = NCAPINTS,
>         CPUID_7_1_EDX,
> +       CPUID_8000_0007_EDX,
>         NR_KVM_CPU_CAPS,
>
>         NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> @@ -42,6 +43,9 @@ enum kvm_only_cpuid_leafs {
>  #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
>  #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
>
> +/* CPUID level 0x80000007 (EDX). */
> +#define KVM_X86_FEATURE_CONSTANT_TSC   KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
> +
>  struct cpuid_reg {
>         u32 function;
>         u32 index;
> @@ -67,6 +71,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>         [CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
>         [CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
>         [CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
> +       [CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
>  };
>
>  /*
> @@ -97,6 +102,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
>                 return KVM_X86_FEATURE_SGX1;
>         else if (x86_feature == X86_FEATURE_SGX2)
>                 return KVM_X86_FEATURE_SGX2;
> +       else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
> +               return KVM_X86_FEATURE_CONSTANT_TSC;
>
>         return x86_feature;
>  }
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>

I believe this version of the patch should have been taken instead of:
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?h=queue&id=42b76c1ae40b89716c7a804cb575a4b52eb4e12f

I think it should be kvm_cpu_cap_init_kvm_defined() rather than
kvm_cpu_cap_init_scattered().

I'm getting this:
arch/x86/kvm/cpuid.c:705:2: error: call to undeclared function
'kvm_cpu_cap_init_scattered'; ISO C99 and later do not support
implicit function declarations [-Wimplicit-function-declaration]
        kvm_cpu_cap_init_scattered(CPUID_8000_0007_EDX,
        ^
arch/x86/kvm/cpuid.c:705:2: note: did you mean 'kvm_cpu_cap_init_kvm_defined'?
arch/x86/kvm/cpuid.c:553:6: note: 'kvm_cpu_cap_init_kvm_defined' declared here
void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
     ^
1 error generated.
