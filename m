Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFF93DE339
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 01:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhHBXqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 19:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbhHBXqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 19:46:15 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A3FC061764
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 16:46:05 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id x192so31274387ybe.0
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 16:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFen2a45R4zylZ5qIL4DVKtH1qD/CEYQohUeJ2fIXYE=;
        b=K2qSnv70To4LaSCdj95R8BywMdScv43S8+f6gqhC4b0dowiA8S/jofRv6VSdH/uYi9
         TRc02yj0eWBkHhr2np5dDbEe1Z62wQUgleAdcOpEaI9MqMjXw3MdwrW7Cjk+flN+wOr/
         IYaV6Fz1GIZzSEgVV+ZEybtXI9Z3qKltq1jJf+YH60WImY6hQ31QTryNmqlzHgVxrGGP
         v4D4djcLSrNJ2Rcz1MDTzKKMH074YME/UANXrkGIYYYXE7gVw24XjNFNQ4J14rUsDE9U
         LC4COmdip1DP/3zHPcSY7n7MRRVrvpCddiW555ijiyZ/mKZML4kifeCRjQ3kuDaYCQg6
         B2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFen2a45R4zylZ5qIL4DVKtH1qD/CEYQohUeJ2fIXYE=;
        b=kBu354YITdX0jEGwpCjNOOTUFdydyFoMSl/EhIMPjDCVpwvhKsbAItM8iTW4ZyC3yR
         lWdSu36dZTUAkZuof8w4zw0aJzasGuhZHbdMgIcxIZFhWg254emYZ9w90Vh7v2QFJnGj
         bgASbuh5SucW5SZUcfYcqn+MQWKLWoYjRr9LZ8gOFU0X8iK/lOpJZ2ACIwjLB00z+Zad
         owkpZyY9M8yt8pD9ePYOuGuglvwo4IMBnTsyFurUqiKmm642aAa0jXfSFzRJ1e+oMkOy
         NmZzaCscgPCDPvjkuYayVn6KZuNOfDezhaeh004TrkqK/sNMuL70OFqZvg9cLeZxGwW7
         FMbg==
X-Gm-Message-State: AOAM53308iFIHmI/tEL56Me1RZthexe0rd+wWauf/HDyNq5k4Nnt0i7b
        P5oQJYBM5007ZvBMxF6FI7RRZpMPMOAFPF3dDiE8WA==
X-Google-Smtp-Source: ABdhPJxUFP4kJAwxVZdGUB2z7l2xV/z+hhj6fqS7XIiwm/EVFKwreCRXhIjFT4N5XKhulNOO3AkM7pChtnlG/IL9xLc=
X-Received: by 2002:a25:dcd1:: with SMTP id y200mr23800031ybe.92.1627947964806;
 Mon, 02 Aug 2021 16:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210730225939.3852712-1-mizhang@google.com> <20210730225939.3852712-4-mizhang@google.com>
 <YQh5baC5cYAuj6y0@google.com>
In-Reply-To: <YQh5baC5cYAuj6y0@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 2 Aug 2021 16:45:53 -0700
Message-ID: <CAL715WJ1=ZA+0hBzCfUQBvvuN_++iQG1wc=JKfmpq-iUnDxkVA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> Looks good, but you'll probably need/want to rebase to kvm/queue once that settles
> down (I suspect a forced push is coming this week).  This has quite a few conflicts
> with other stuff sitting in kvm/queue.

will do.

> > @@ -235,9 +235,12 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> >       STATS_DESC_COUNTER(VM, mmu_recycled),
> >       STATS_DESC_COUNTER(VM, mmu_cache_miss),
> >       STATS_DESC_ICOUNTER(VM, mmu_unsync),
> > -     STATS_DESC_ICOUNTER(VM, lpages),
> >       STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
> > -     STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
> > +     STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
> > +     STATS_DESC_ICOUNTER(VM, pages_4k),
> > +     STATS_DESC_ICOUNTER(VM, pages_2m),
> > +     STATS_DESC_ICOUNTER(VM, pages_1g),
> > +     STATS_DESC_ICOUNTER(VM, pages_512g)
>
> Uber nit that I wouldn't even have noticed if this didn't conflict, but there's
> no need to land the union and the stats definitions at the end of the structs,
> i.e. the new fields can directly replace lpages.  I don't think it will actually
> avoid a conflict, but it would avoid modifying the max_mmu_page_hash_collisions
> line.
>

ah, so I will just remove 'lpages' and put new lines in place instead
appending those at the end. Yeah, I did not know that it can create
conflicts. So, I will change that.
