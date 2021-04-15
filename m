Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256A0361467
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 23:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbhDOV7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 17:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236187AbhDOV7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 17:59:15 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96B5C061756
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 14:58:51 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id a2-20020a0568300082b029028d8118b91fso5512094oto.2
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 14:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TS/T6BhQTib7rhqu+BkkOlINUb8326KpIVMIZIBfyRs=;
        b=Uk+6Z/v7I1+QPVozlnRfwxkdFxgIRoz0Ks6iwhFGDjAT/wm66qj1hDI67/z8f9w9D0
         Ll1HqqfDw4cGQIzPAR4PfRzkAH6rELzC7gp6A0pMEB61tOLXInvabrFujzLviCF1xEH5
         DbS+DAkfUAi4vfAIp8V6UQFalhVnxCHAyzostoGpvgEAdQaCCuDStYPngZqUm41bgE2G
         faC64Chg8HFACqviUSUEboKjQJlzlHdq4GU3he045WOAxjUZf2o0BqJI2wlKrYqkPMB4
         BzX1z6fr6AObpeuKT2GBuj7/mF+cfdUyx8We8lf9uS+P8j1oJRMuYoa4zs70owIUNAUx
         HqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TS/T6BhQTib7rhqu+BkkOlINUb8326KpIVMIZIBfyRs=;
        b=sMKYBTKCGrfjDGZMQN2Ax7iqpMmwbNtLMOaQNisp4TjQdmGjTLYgENZblIjywUljl+
         u/6OLuYFty67i+ur5B+TW3ni1h3+duUBWwqb6BpvtJ0Qk42Qs8e6Qhu8CD1huktAr+8d
         jih6rlLpVYt41dXqQSQaoc0fGsYOqZVmffF77YJKQJd5B0nzFYDYsLt0vDlRtf1hvmbW
         ueQg8pFKOsiux/yz+wLe2G+mZ29NJ5RwDmOa9pX9k12iXlSiBYQaBK8VXy3uHmULZwZg
         Ia+HqrdBTuZO7UmUQsnbl765xQQdAkM+Rjdu/zxe/4F6k0o9HcNfdp58dApKA6Hda6Ty
         4E+A==
X-Gm-Message-State: AOAM530PKrJqBRmm6gwpdgM9R8hvvFP8X7tgWKPHEoMjLQ7CE5lIXtPz
        t2dhROrD9/jjlxioP94aY247PfifuxL7GQeg8cDuog==
X-Google-Smtp-Source: ABdhPJzCgZ9EkYnkd7FsmrKt+LBuBwVNbW9sg5zrNYIsNaphOJoqPRKqun/xV8h0fHvxDpnchA6eDUK2nyz+Y2ndux0=
X-Received: by 2002:a9d:aa4:: with SMTP id 33mr1021366otq.295.1618523930945;
 Thu, 15 Apr 2021 14:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210412222050.876100-1-seanjc@google.com> <20210412222050.876100-4-seanjc@google.com>
In-Reply-To: <20210412222050.876100-4-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Apr 2021 14:58:39 -0700
Message-ID: <CALMp9eRmpm3HPUjizYXp27drY0xtWhSrsec51W7QkSHWADayNQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: Add proper lockdep assertion in I/O bus unregister
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hao Sun <sunhao.th@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 3:23 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Convert a comment above kvm_io_bus_unregister_dev() into an actual
> lockdep assertion, and opportunistically add curly braces to a multi-line
> for-loop.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ab1fa6f92c82..ccc2ef1dbdda 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4485,21 +4485,23 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>         return 0;
>  }
>
> -/* Caller must hold slots_lock. */
>  int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>                               struct kvm_io_device *dev)
>  {
>         int i, j;
>         struct kvm_io_bus *new_bus, *bus;
>
> +       lockdep_assert_held(&kvm->slots_lock);
> +
>         bus = kvm_get_bus(kvm, bus_idx);
>         if (!bus)
>                 return 0;
>
> -       for (i = 0; i < bus->dev_count; i++)
> +       for (i = 0; i < bus->dev_count; i++) {
>                 if (bus->range[i].dev == dev) {
>                         break;
>                 }
> +       }
Per coding-style.rst, neither the for loop nor the if-block should have braces.

"Do not unnecessarily use braces where a single statement will do."

Stylistic nits aside,

Reviewed-by: Jim Mattson <jmattson@google.com>
