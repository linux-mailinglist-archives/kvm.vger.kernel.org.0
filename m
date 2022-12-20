Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C6E651BF7
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiLTHsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiLTHsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:48:12 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD61704E;
        Mon, 19 Dec 2022 23:48:08 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ay2-20020a05600c1e0200b003d22e3e796dso8116952wmb.0;
        Mon, 19 Dec 2022 23:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/W+7qwDTFMzyJkTT4aws3iV4KSX3CQLUUP12KT8As2U=;
        b=ocO3/HR5PP3aS3Hjb6yvhkh/I/y+GocuwL5lfD/x5uVSyPmJYWCfKxjyVcGhncJErb
         AsmskngYcjtuRCJoZzo9sm/kQbO02qlD+knbstxqhyE0EbYUMT9ZI+CFiMnL+fDgDJUS
         2biy76OyP1X6lQLogUui5iIQuL+/MQdFjIuQg2kgojAEP2dhhjm6xSE+98D2OWB62J7w
         iR6MzD8NVcwkRhZDnvqUqSBB/1jS+ScVaENWYS8f3YOwuug0qyfv9AjqJn8CVYk/aRll
         ec3L7Lyko32F1NcLGdY3Yp5GUBTmxVFekJw9KpJOmfTXKThTMjWXlIrCCRzxOkkiXiJP
         ZxPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/W+7qwDTFMzyJkTT4aws3iV4KSX3CQLUUP12KT8As2U=;
        b=8ATtUg6rL9HRoie4dJbyG4g2l611uB/ah970t4oXA5+zYmcymRX6w6sXos5rBQjL71
         mxyzTcAZbWu0X4g/JD10F145OMVwdSeohsN1SZtDraDl4TtcogaKM22HG0nTyIExN2vy
         kMNtV2d+fYPi0lXdL3iL6O1NMiVGHdkQbDxLxlVdy7czJHX7cv134peC4tlMf304NyQt
         NvxWrTfNRBXyLbFd05B7YstqycWr2XCTeegE9dDtA27JO5xcqOogZaFbTNFPHe8SyH9T
         l1rEwHBqIuWtdLF5Xscq6AkFVseAL/G1x7zUz4AjjhDqtrJ8Co8QsptnlJX29V7Xrb6E
         b/GQ==
X-Gm-Message-State: AFqh2kpTiGIl0fH1d44wCtrdJwNli7Spen2i9nvQs3lBqMXzsJwW/GqC
        vkAMEEL4MwZU9tfENcxkfuV80crPAScA4bksy8d5DWP7H/E=
X-Google-Smtp-Source: AMrXdXsaX1J+fWzoZS4b0P7qEteVNK/pu2LIVapLbzXM9MjnC5klkGN7ndXqgXLIeRkkOgsworFOVxjzbqWllZUWcOc=
X-Received: by 2002:a7b:cc17:0:b0:3d3:56ce:56a0 with SMTP id
 f23-20020a7bcc17000000b003d356ce56a0mr406779wmh.45.1671522486911; Mon, 19 Dec
 2022 23:48:06 -0800 (PST)
MIME-Version: 1.0
References: <CAPm50aJTh7optC=gBXfj+1HKVu+9U0165mYH0sjj3Jqgf8Aivg@mail.gmail.com>
 <Y5KNvgzakT1Vvxy4@google.com>
In-Reply-To: <Y5KNvgzakT1Vvxy4@google.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 20 Dec 2022 15:47:55 +0800
Message-ID: <CAPm50aJv2_6321BgLXB6SWH1CcoYM4733fsovtB_5zhoP_7x+Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: use unified srcu interface function
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 9, 2022 at 9:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 08, 2022, Hao Peng wrote:
> > From: Peng Hao <flyingpeng@tencent.com>
> >
> > kvm->irq_routing is protected by kvm->irq_srcu.
> >
> > Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> > ---
> >  virt/kvm/irqchip.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> > index 1e567d1f6d3d..90f54f04e37c 100644
> > --- a/virt/kvm/irqchip.c
> > +++ b/virt/kvm/irqchip.c
> > @@ -216,7 +216,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
> >         }
> >
> >         mutex_lock(&kvm->irq_lock);
> > -       old = rcu_dereference_protected(kvm->irq_routing, 1);
> > +       old = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
> > +                                       lockdep_is_held(&kvm->irq_lock));
>
> Readers of irq_routing are protected via kvm->irq_srcu, but this writer is never
> called with kvm->irq_srcu held.  I do like the of replacing '1' with
> lockdep_is_held(&kvm->irq_lock) to document the protection, so what about just
> doing that?  I.e.
>

Sorry for the long delay in replying. Although kvm->irq_srcu is not required
to protect irq_routing here, this interface function srcu_dereference_check
indicates that irq_routing is protected by kvm->irq_srcu in the kvm subsystem.
Thanks.

> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 1e567d1f6d3d..77a18b4dc103 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -216,7 +216,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
>         }
>
>         mutex_lock(&kvm->irq_lock);
> -       old = rcu_dereference_protected(kvm->irq_routing, 1);
> +       old = rcu_dereference_protected(kvm->irq_routing,
> +                                       lockdep_is_held(&kvm->irq_lock));
>         rcu_assign_pointer(kvm->irq_routing, new);
>         kvm_irq_routing_update(kvm);
>         kvm_arch_irq_routing_update(kvm);
>
>
> >         rcu_assign_pointer(kvm->irq_routing, new);
> >         kvm_irq_routing_update(kvm);
> >         kvm_arch_irq_routing_update(kvm);
> > --
> > 2.27.0
