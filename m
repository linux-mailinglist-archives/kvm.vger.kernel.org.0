Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2495155A7C3
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 09:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiFYHhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jun 2022 03:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiFYHhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jun 2022 03:37:15 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732593FBE8;
        Sat, 25 Jun 2022 00:37:14 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id q4so7741009qvq.8;
        Sat, 25 Jun 2022 00:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n076zfNtrFt4ClI+VpxbjGuUJqmrwLV6wB/3U1mSuGo=;
        b=BmMdfS+7eSR1K4fQrgjpu2zcV9MKpoAOS/jKT6x+fcTlvDFw7STH8vfDI9Iskd4Z6u
         eyy/g2WQQtYe/4hXxuxmYqdJL3ldSQum9pCiysx+SKn62FBKNzdi68fQjNdOHcAfvKcp
         dg4MRNztUJISwwePtxRfoaZ2z97Eus7oXJXIO5wovQlqshKtQyBAtq7CENoVLz+cJqzh
         N6+hwxLmZpSMh0jEOEBOzS7sDNW1DrPzVDTDJvvaPr66ClqrrwNKfWWZVkRHScivimbj
         DrGQgUGIvCtgfeH/jGFwLJ32T1xCTcSVaJjDQ5IQeuAMSnPOydqy44L/ntr4HCyx1y6P
         OtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n076zfNtrFt4ClI+VpxbjGuUJqmrwLV6wB/3U1mSuGo=;
        b=QafUkt3DqFK+kl7VhlV/jb132n7qv0TonUnvyjpLf7aud48PlqHMZSrgTUYkY6O6gf
         nwpa34jPEVF5b6/7uBvWXuRMJQ85S322+WOIjBIkgS3A6zKRlmIDImrGWwrYYocwipIv
         cF+Awh6CRIKm0QyShvO5M9pUuiSv1Y/Tc0JDhdoyPIav+EXpQYCehzBowvMbVKOs0+kp
         SwWgltXBtE7e1TvloASj7escsn6w7qUrjvabHvueTmEugK2B7SwAqqAODB4RxX6Tl3RJ
         H6TSDwT7/egeLgAcHInbbI6waUIi3cCTy92+AXhowBeiiGGPXswWcUP/s2Z+TLXTcKbe
         o63A==
X-Gm-Message-State: AJIora8In38s5kxS+tDmM+xUWDYaY5j/ytDcoL4pLvVqhIWR51NCoro1
        LqgprhFAD+J+6WKrFzs57OLM4nCE8S4/jtBYUK4JszE8BOU=
X-Google-Smtp-Source: AGRyM1sEYGHWEIW7bganmQ8aPPlyneCzmFMt+8uGbMt70k8oDNPkmPyv7GKLue2Rt1ddCHnCrUd+meclsHD7GDzDGOM=
X-Received: by 2002:a05:6214:248b:b0:470:4ef5:7159 with SMTP id
 gi11-20020a056214248b00b004704ef57159mr2231107qvb.48.1656142633541; Sat, 25
 Jun 2022 00:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220624154552.2736417-1-pbonzini@redhat.com>
In-Reply-To: <20220624154552.2736417-1-pbonzini@redhat.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Sat, 25 Jun 2022 09:37:19 +0200
Message-ID: <CAFULd4byUDS6U527qLuh78KmvM2OWbtappDfxLSiT_iMUz8Ghw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: clean up posted interrupt descriptor try_cmpxchg
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
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

On Fri, Jun 24, 2022 at 5:45 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Rely on try_cmpxchg64 for re-reading the PID on failure, using READ_ONCE
> only right before the first iteration.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 73f60aa480fe..1b56c5e5c9fb 100644
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
> -       if (!try_cmpxchg64(&pi_desc->control, &old, new))
> +       if (!try_cmpxchg64(&pi_desc->control, pold, new))
>                 return -EBUSY;
>
>         return 0;
> @@ -96,8 +96,9 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>         if (!x2apic_mode)
>                 dest = (dest << 8) & 0xFF00;
>
> +       old.control = READ_ONCE(pi_desc->control);
>         do {
> -               old.control = new.control = READ_ONCE(pi_desc->control);
> +               new.control = old.control;
>
>                 /*
>                  * Clear SN (as above) and refresh the destination APIC ID to
> @@ -111,7 +112,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>                  * descriptor was modified on "put" to use the wakeup vector.
>                  */
>                 new.nv = POSTED_INTR_VECTOR;
> -       } while (pi_try_set_control(pi_desc, old.control, new.control));
> +       } while (pi_try_set_control(pi_desc, &old.control, new.control));
>
>         local_irq_restore(flags);
>
> @@ -156,12 +157,12 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>
>         WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
>
> +       old.control = READ_ONCE(pi_desc->control);
>         do {
> -               old.control = new.control = READ_ONCE(pi_desc->control);
> -
>                 /* set 'NV' to 'wakeup vector' */
> +               new.control = old.control;

This assignment should be above the comment, similar to vmx_vcpu_pi_load.

Uros.
>                 new.nv = POSTED_INTR_WAKEUP_VECTOR;
> -       } while (pi_try_set_control(pi_desc, old.control, new.control));
> +       } while (pi_try_set_control(pi_desc, &old.control, new.control));
>
>         /*
>          * Send a wakeup IPI to this CPU if an interrupt may have been posted
> --
> 2.31.1
>
