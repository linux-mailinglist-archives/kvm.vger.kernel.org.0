Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73E252DF60
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 23:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiESVeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 17:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiESVeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 17:34:13 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9CBED79B;
        Thu, 19 May 2022 14:34:12 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id s5so5504190qvo.12;
        Thu, 19 May 2022 14:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p8xG7LyzvoLsqWRIt05A/RRoP7JvL+EY8T+e8+G7D88=;
        b=QATfFzwatNmcFxZ1yMtUvP76LiR7E4HhyAeR1bCORLSwGdDwQ95aZdNdXgoB04/J1Z
         aXgwTNUqax7HudGboOkPuflwSdYuj6Ute3/dmzJD7e9RCsKrG42R3PU6fLjonBWHCVGI
         PWujclySN7W1UHWICCr6x2pWVuIg9PHCkT8blfcs6HiSBkMEs/HglXmYS6uSmqRUZNGT
         gx39yRe4rLPclATIfEILNeTKLvOWZ3tnUvR8bb6USBz7bhVfT1BLW2Wr4wjfUEbbdrAp
         a4sdVb0L0Z/IdPnaydl9ITYvZrMHQHgmE4o14e26Z88MxEVeQhilbA2yfe6QS5ebRa8Y
         zv0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8xG7LyzvoLsqWRIt05A/RRoP7JvL+EY8T+e8+G7D88=;
        b=zNN6v7BRs6fr8ikxFZlmb5WilLVB5Dmbxmeo8zux2sNv5lFw2R4xEan5qta7UqTrVW
         H9HZA7U5VX+0meN9aY/CNnJDAbE+7pzDo81kkO3wQnjQ6GsOFkdG77H4YspunSx5EOxL
         TkeOS/Sv30dinyFDy2pasaGPQAc5YQIxGbkbzEe/1uFapA5VgVEbAAZDJp/HqQSGYJCj
         B1o06dgeSK1qkO3RGFcchqBOdE8CxygYemR4bSv4R4CYWX2XlTSRaGUltGkI+/BDxpKN
         ZYGdvH4CO7r9xdigvWvcv2lNXxHI5Xtww+L0H3A0Nu8SGL13X63WeARbwOvYJLcC+6kJ
         wlng==
X-Gm-Message-State: AOAM533YlscTTTx2EYke3zondRJ3ZAl+D6qw1im67fL1PuzoNrH4x7/b
        eAFnnEKmqK9BOVwqzaRSR28gVB4PLbD+2CYpWwEqalArH+c=
X-Google-Smtp-Source: ABdhPJz6BvRJeKHlG9alz96xnE2MawkN09ASEZxjC4VhFLosw6SpKKI9bz7FhATcsmg8+7IbNXIIJNLO/lmVQCHZSCY=
X-Received: by 2002:ad4:4e86:0:b0:461:c6f7:fc5b with SMTP id
 dy6-20020ad44e86000000b00461c6f7fc5bmr5729356qvb.31.1652996051163; Thu, 19
 May 2022 14:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220518134550.2358-1-ubizjak@gmail.com>
In-Reply-To: <20220518134550.2358-1-ubizjak@gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 19 May 2022 23:34:00 +0200
Message-ID: <CAFULd4Y3ZSfBtx3ZbLcT3DtorGxPqyWeOmrMxHS4b3AKH2cxVw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
To:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022 at 3:46 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> Use try_cmpxchg64 instead of cmpxchg64 (*ptr, old, new) != old
> in pi_try_set_control.  cmpxchg returns success in ZF flag, so this
> change saves a compare after cmpxchg (and related move instruction
> in front of cmpxchg):
>
>   b9:   88 44 24 60             mov    %al,0x60(%rsp)
>   bd:   48 89 c8                mov    %rcx,%rax
>   c0:   c6 44 24 62 f2          movb   $0xf2,0x62(%rsp)
>   c5:   48 8b 74 24 60          mov    0x60(%rsp),%rsi
>   ca:   f0 49 0f b1 34 24       lock cmpxchg %rsi,(%r12)
>   d0:   48 39 c1                cmp    %rax,%rcx
>   d3:   75 cf                   jne    a4 <vmx_vcpu_pi_load+0xa4>
>
> patched:
>
>   c1:   88 54 24 60             mov    %dl,0x60(%rsp)
>   c5:   c6 44 24 62 f2          movb   $0xf2,0x62(%rsp)
>   ca:   48 8b 54 24 60          mov    0x60(%rsp),%rdx
>   cf:   f0 48 0f b1 13          lock cmpxchg %rdx,(%rbx)
>   d4:   75 d5                   jne    ab <vmx_vcpu_pi_load+0xab>
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
> Patch requires commits 0aa7be05d83cc584da0782405e8007e351dfb6cc
> and c2df0a6af177b6c06a859806a876f92b072dc624 from tip.git
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 3834bb30ce54..4d41d5994a26 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -34,7 +34,7 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>         return &(to_vmx(vcpu)->pi_desc);
>  }
>
> -static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
> +static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
>  {
>         /*
>          * PID.ON can be set at any time by a different vCPU or by hardware,
> @@ -42,7 +42,7 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
>          * update must be retried with a fresh snapshot an ON change causes
>          * the cmpxchg to fail.
>          */
> -       if (cmpxchg64(&pi_desc->control, old, new) != old)
> +       if (!try_cmpxchg64(&pi_desc->control, pold, new))

Actually, we can just use the address of local variable &old here, no
need to change function arguments.

Patch v2 incoming...

Uros.
