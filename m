Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0AB6C722B
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjCWVLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjCWVKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:10:51 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9FF28E58
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:10:39 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-544b959a971so383267337b3.3
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679605838;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CTuJZ0t6kkLEzOcpMSkFKQLOB74i8t08EnfPgoWLaPY=;
        b=Mavz590BYHQhPHBkS9clIFRT9th6iaVGMG45bjCdWKJOkzu/gE6guj8WZO0PZY/icE
         PN8KYOy8VM5sHtnbz1+pSZ43YTK+ahuHTf8cZg52GPkeXC02ZY8omwVZb7gpm6swDUvD
         X/vAxx68d9EIHz17x/SR5XYtWf3cRUu1cdQCwAA4kMsK4I09aj4M+ZOPoBsVxuV2Pa63
         6n530DZbDyFGxFdJpfiDAyYcZh/tq8hOgzRo0RKcMQkyvdZJ49MTHB4CwGyjcgJfOJXP
         pnY4+CixPU8nhFpKjFlGNKFhlUL34RbZE6ne3DmSSL5dtNdKFawR/QZl3DNKK1MNzsDH
         g4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679605838;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CTuJZ0t6kkLEzOcpMSkFKQLOB74i8t08EnfPgoWLaPY=;
        b=5Ej+N4nztFnJOMWi8YZW5hPD+hIDeILOwXB1PZjVEiz4fDkWSpmqcIaY0rW/aNqvl4
         F1rCq85MHCD7Mj07/XqDFdNnHX+q3sKJ8Na10LgmIOEj5uI0wmEHkSJLz45L9cpTo7It
         RjE5V+fjb8Slg6GrL6YQXTQno15FgcgE/2a1Tp+pr67k6Fa5NO+8Vcgb9gnYvvPc2Hka
         DVNWKc7IbSvb/pT6oW5twf3T75zMnRGbJTmPw7wqUbK3A0hWI0IQKoj5Q/NFGHGQzcpZ
         afhDRL8tLW3WTv3sN0LZTD6UzgZHGtat825npm+UBfsgk9teAFjR8mXz0DjhUfsUneFJ
         KL1w==
X-Gm-Message-State: AAQBX9fSkMAIFoQdV3QJi8mjHjF3z36aheLCRb61ROQJrrzZlQ0P3bgo
        BIBKWSsbDFay5einmr6WGHdUb3f+ophi8DzLOKt/SQ==
X-Google-Smtp-Source: AKy350ZRMwDkoNv1ZADY5+qwp5lkSf5geRNq9EuK0grOzLp/Wr2QlgqGqxzRNyWjyJiasC98odfZ8ottfLO7Ng7j/Mg=
X-Received: by 2002:a81:b70a:0:b0:541:a0cc:2a09 with SMTP id
 v10-20020a81b70a000000b00541a0cc2a09mr2579300ywh.7.1679605838258; Thu, 23 Mar
 2023 14:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-3-aaronlewis@google.com> <ZBy2tcQzERBpsoxz@google.com>
In-Reply-To: <ZBy2tcQzERBpsoxz@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 23 Mar 2023 14:10:02 -0700
Message-ID: <CAL715WKX6FXugfCYLqyoT4UKCYha7g_izvy2Djvg5zPkxa7JwQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> Aaron and/or Mingwei, can you give the attached patches a spin?  Patch 1 is a
> slightly reworked version of Aaron's patch 1, and patch 2 implements what I just
> described (guts of patch 2 also pasted below).  If things look good, I'll post a v4
> of this series.

Overall I don't have a strong opinion. Extending the sanitization from
AMX to AVX512 and MPX does seem to slightly change the purpose from
permission adjustment to hw feature sanitization. So, it is ok for me
to see the push for AVX512 and MPX as a different motivation, thus
peeling them off from this series.

>
> [0] https://lore.kernel.org/all/Y7R36wsXn3JqwfEv@google.com
> [1] https://lore.kernel.org/all/CALMp9eQD8EpS50A0iAxsoaW-_yFmWERWw6rbAh9VSEJjDrMkNQ@mail.gmail.com
>
I can take a look but in general [1] the whole series should fix the
problem. Let me check the following code.

>
> ---
>  arch/x86/kvm/x86.h | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index b6c6988d99b5..ae235bc2b9bc 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -3,6 +3,7 @@
>  #define ARCH_X86_KVM_X86_H
>
>  #include <linux/kvm_host.h>
> +#include <asm/fpu/xstate.h>
>  #include <asm/mce.h>
>  #include <asm/pvclock.h>
>  #include "kvm_cache_regs.h"
> @@ -325,7 +326,22 @@ extern bool enable_pmu;
>   */
>  static inline u64 kvm_get_filtered_xcr0(void)
>  {
> -       return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> +       u64 supported_xcr0 = kvm_caps.supported_xcr0;
> +
> +       BUILD_BUG_ON(XFEATURE_MASK_USER_DYNAMIC != XFEATURE_MASK_XTILE_DATA);
> +
> +       if (supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC) {
> +               supported_xcr0 &= xstate_get_guest_group_perm();
> +
> +               /*
> +                * Treat XTILE_CFG as unsupported if the current process isn't
> +                * allowed to use XTILE_DATA, as attempting to set XTILE_CFG in
> +                * XCR0 without setting XTILE_DATA is architecturally illegal.
> +                */
> +               if (!(supported_xcr0 & XFEATURE_MASK_XTILE_DATA))
> +                       supported_xcr0 &= XFEATURE_MASK_XTILE_CFG;

should be this? supported_xcr0 &= ~XFEATURE_MASK_XTILE_CFG;


> +       }
> +       return supported_xcr0;
>  }
>
>  static inline bool kvm_mpx_supported(void)
> --
>
