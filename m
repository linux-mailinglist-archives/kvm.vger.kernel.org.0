Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383663E9988
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 22:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhHKUPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 16:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbhHKUPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 16:15:16 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4718AC0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 13:14:52 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h2so6619818lji.6
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 13:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=STTvyQTPDqPTwSq4yPQLXMtO/hnbb3N8JMjKK+d9C6o=;
        b=h7YbLMCqKyBO6zJ/mL+v4BZzhflWpxGE016/oPXXm1DR6Qj8ggN8AYHfy8nx8lDn9O
         sCR+JssxKLZpfQB4x2V9Afa17wgItuRLoO0CbFBKz+1POS4SdahpCwfpNzMW9EYdtrj3
         8Puc3njMu9V6LK0pS85YEbV9LQENqk0HSNuF56FRhSX3/t7c0Wi472rXHJfC21/knoPT
         mKRF1uXxOYlbA6jJY5dnhKTUip/nhgk0U1dxO7teRXo2M/04xRzDGDIjKay0waotJjRX
         fa8mitYu6Ffn7F9lA1C1hJA/JqQ04SQNjr41q95ygImXsOznEwTuvpa8Aoji4mbpxu+4
         JF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=STTvyQTPDqPTwSq4yPQLXMtO/hnbb3N8JMjKK+d9C6o=;
        b=qzbiyvnOfjQTUk4tdtA1pDcJKqdP6VkEnKoxgoR/wASbBvEVswRf4f9xpie43b2rUQ
         NaSlyZ3motmYpeqWhvYzdQXGg85kVQhHa87D/fB5Udb19M8IlVKykEzhwLMxRQpHsGTS
         m8gzxtBYuxLxHYvCmfntvHAe16rRy3n94/gx3R3TFJ6TpNuJotvvNpOc++h39g4VNU1N
         QhdsbOUjb6JaPMR1i+AEkWaiLajsaQFV9E2deE8jG10cY1LSad1xtq2JG4IV62UmGlh0
         jkiFqAkEHZN6NStSAzg+J77VCdwch96LZWoR0JQxRg6UCf1LWVkstK8xcV07D3dij9Hv
         MUPA==
X-Gm-Message-State: AOAM533YwXPB9E1knDVJEVYqJ0tXoGsS62BkE/guNZs+P7h4hlwHGkCC
        VatUK65EPjaajEeNHZ6GaabHzwBn5FYfEN0JXuTdDw==
X-Google-Smtp-Source: ABdhPJxBITOhrqJizc8CGnpoOm8c3WwDghKYwq38ia9y6hC8MBRhAP/QTCixTBv42J3rvt/XdK37xCTyBFF6Ljkdgx0=
X-Received: by 2002:a05:651c:626:: with SMTP id k38mr296065lje.304.1628712890286;
 Wed, 11 Aug 2021 13:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210810223238.979194-1-jingzhangos@google.com>
 <CAOQ_QshcSQWhEUt9d7OV58V=3WrL34xfpFYS-wp6H4rzy_r_4w@mail.gmail.com> <5183cb08-f739-e6a6-f645-3ccbe92d04d8@redhat.com>
In-Reply-To: <5183cb08-f739-e6a6-f645-3ccbe92d04d8@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 11 Aug 2021 13:14:39 -0700
Message-ID: <CAAdAUtjRBXhsOo6WcAjwoEvB5TsyDr5=C4Kyt8TdDoRktA880g@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of
 dirty pages
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 3:20 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/08/21 00:56, Oliver Upton wrote:
> > What if the statistic was 'dirtied_pages', which records the number of
> > pages dirtied in the lifetime of a VM? Userspace could just record the
> > value each time it blows away the dirty bitmaps and subtract that
> > value next time it reads the stat. It would circumvent the need to
> > walk the entire dirty bitmap to keep the statistic sane.
>
> Yeah, that'd be much better also because the "number of dirty pages"
> statistic is not well defined in init-all-dirty mode.
>
> Making it a vCPU stat works in fact, because mark_page_dirty_in_slot is
> only called with kvm_get_running_vcpu() != NULL; see
> kvm_dirty_ring_get() in virt/kvm/dirty_ring.c.
>
> >>
> >> +               if (kvm->dirty_ring_size) {
> >>                         kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
> >>                                             slot, rel_gfn);
> >> -               else
> >> +               } else {
> >>                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
> >> +                       ++kvm->stat.generic.dirty_pages;
> >> +               }
> >
> > Aren't pages being pushed out to the dirty ring just as dirty?
> >
>
> Yes, they are.
>
> Paolo
>
According to Oliver's idea, let's define the "dirty_pages" as the
number of dirtied pages during the life cycle of a VM to avoid the
overhead caused by walking the entire dirty_bitmap.
I didn't consider the dirty ring in this patch, but will do in the next.
Will still define dirty_pages as a VM scoped stat in the next patch.
From there, we will see if it is necessary to define it as a VCPU
scoped stat. (Both KVM code and user code would be simpler with it
being as a VM scoped stat).

Thanks,
Jing
