Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5EA351CF9
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbhDASXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbhDASMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:12:45 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584BEC03115D
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 09:50:17 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f5so2571294ilr.9
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hS10QxYqo081plk7djXLpiSk72EjSMQOalfDnvofOY=;
        b=d0a/qJGLS+gJRHp77DqbzcXWpsEQOcN8NRzk/ofcis8L0n9MZJLfSJYDFZmEbDXG+/
         8mGYUDuDwD6O1u4jO3/EAFBgzol5FlgW+sWdBSKsaffN2xpxW0L4CJ45KohqNYoQ4grZ
         Zxw+goiD2nAq/u/4AD4F24yOeW6qs4rbiovAHGEJ/CBP6bxp1iUxhynh+LbzTX8H1A13
         ikoRt1jgpoIn4b6BwKkrGSD5FW7I4uCP8LEU2eNFiqfc3FRCovfuoLYtXnoUMpaWhy+1
         RX3611GzLDhdPJxSnU+fqjU/ssHfu9l7t9x7ji0neV4QYywz/jxlYvvfLJwnbt7uKwLe
         PPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hS10QxYqo081plk7djXLpiSk72EjSMQOalfDnvofOY=;
        b=ausZr4rnIME0pFb7CSxE8HrnJJHFlMKNhxBzihKomgFuCjuyH5ayWkijqXRvW5CuWe
         LLtKw4eojHWMIv/NpUA42oAEGMRFaTthT2E0Ulht7NhGz47zDbzwaQub04xJSQ/3i2xV
         ZtGVvU1fj+2mMN2o2a26IfTyQF5D+0xSG3c2yz3pHcxX8KKyrocY0ZnLciM7ppaq2JCI
         KGM6fH8yClzUYN5id8kMnuS02qe/8MudTgwooEwfpzk5aoc2h83U681K33SMquIsFHLP
         LdWercFytnkh2ms0xJ/7DS067+n3xhNiQn9FD0JHUySYxI5A7jS+rxa0DA8YmUwttHnE
         wMbA==
X-Gm-Message-State: AOAM530K/Hvh2eKxaVxMotTKEqJXgQCJkR+N9N3TM5UCp5iTzHKEV63V
        vTiKQumOKUaX9qOLQfH3Ki4M7h1DpWmk2sQRtc8Ycw==
X-Google-Smtp-Source: ABdhPJwFzuPSMDw12EOMJER9qENN/CIBqX9OAyOnoUTwYHBf2oLUWdWnC0zmZH3vh8FAFQD1I3W1eH16VPeBr1j0yCA=
X-Received: by 2002:a92:d9c3:: with SMTP id n3mr7902126ilq.306.1617295816642;
 Thu, 01 Apr 2021 09:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com> <20210331210841.3996155-13-bgardon@google.com>
 <79548215-b86f-99de-9322-c76ba5a1802d@redhat.com>
In-Reply-To: <79548215-b86f-99de-9322-c76ba5a1802d@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 1 Apr 2021 09:50:05 -0700
Message-ID: <CANgfPd_wFMFQgqSG9gi5zo3=WMGVST-66DkNJTopvTBZoangmQ@mail.gmail.com>
Subject: Re: [PATCH 12/13] KVM: x86/mmu: Fast invalidation for TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 1, 2021 at 3:36 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/03/21 23:08, Ben Gardon wrote:
> >
> > +     if (is_tdp_mmu_enabled(kvm))
> > +             kvm_tdp_mmu_invalidate_roots(kvm);
> > +
> >       /*
> >        * Toggle mmu_valid_gen between '0' and '1'.  Because slots_lock is
> >        * held for the entire duration of zapping obsolete pages, it's
> > @@ -5451,9 +5454,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
> >
> >       kvm_zap_obsolete_pages(kvm);
> >
> > -     if (is_tdp_mmu_enabled(kvm))
> > -             kvm_tdp_mmu_zap_all(kvm);
> > -
>
> This is just cosmetic, but I'd prefer to keep the call to
> kvm_tdp_mmu_invalidate_roots at the original place, so that it's clear
> in the next patch that it's two separate parts because of the different
> locking requirements.

I'm not sure exactly what you mean and I could certainly do a better
job explaining in the commit description, but it's actually quite
important that kvm_tdp_mmu_invalidate_roots at least precede
kvm_zap_obsolete_pages as kvm_zap_obsolete_pages drops the lock and
yields. If kvm_tdp_mmu_invalidate_roots doesn't go first then vCPUs
could wind up dropping their ref on an old root and then picking it up
again before the last root had a chance to drop its ref.

Explaining in the description that kvm_tdp_mmu_zap_all is being
dropped because it is no longer necessary (as opposed to being moved)
might help make that cleaner.

Alternatively I could just leave kvm_tdp_mmu_zap_all and replace it in
the next patch.

>
> Paolo
>
