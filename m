Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6201E92F4
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 19:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgE3R5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 13:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgE3R5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 13:57:44 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FD5C08C5CA
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 10:57:44 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z13so3156139ljn.7
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 10:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oSw9tD6N6PkQVpqgffMdls3duXKGoPYgqTcZw/O/Ajs=;
        b=Lrpv+rXNeI30WFwiZ3vG/HqSBj3X8LK4/226aM9DIBxsp+rGuUknOUrRMAKhbygxl4
         2/b72LXeaiKacrNWcsuKU1yFVjfrDuO9n9ZrCDP6XoASr7ATsfi5/BJRKwLKcRRm019Y
         q0vVl8iWNZpE3VHVrbGLWaJXKDmyB69Ejad/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oSw9tD6N6PkQVpqgffMdls3duXKGoPYgqTcZw/O/Ajs=;
        b=g4FwNLnvECPzfRB2nxPtH3OP1GB9XOs8Z5irWrV/KiK9NSrmEMh9xuu+j97FMhUcHx
         mhX3OjrSg+rqVeWPErEaS9cWHcm3GH0ZSqTCwhbQvjOqEhnqo+ZnUWICGGzuiU4C6Qmw
         Up2ytugsoT6AyE7iF33noR4XHjQTTSkqL7y8lIKcFD4MYqL2rrGU+GfoKir5n+G2s/t1
         pZw7QWwlDKjl3IU/cRmFLi28EeOhp/cUnhnk/bCoal5YBihPj5jEH7vzghDSPR33TFQc
         xikWuiTFmqcHojjY0ol9WfZtjOzZbpyA+ATWOAhq5VWudMCaiWiYGVex9MXq05phAgeN
         aAWA==
X-Gm-Message-State: AOAM531cVPOUNUAfoMT2/XAI9musOnub3IOEVrZqxFOqxm7ttdZqA2cq
        G8Wi0tMJqFNkboyqq43LAcz6JAq4tYw=
X-Google-Smtp-Source: ABdhPJyukJoxX5W11e2W3QTo3IMdJegBVXpKHZpVPeudhzoNvprMNkf9hBIQZSixnT9qRBZGWf8lgg==
X-Received: by 2002:a2e:9087:: with SMTP id l7mr7116149ljg.430.1590861461965;
        Sat, 30 May 2020 10:57:41 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id l16sm3146036lfg.2.2020.05.30.10.57.40
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 10:57:40 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id b6so3202061ljj.1
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 10:57:40 -0700 (PDT)
X-Received: by 2002:a2e:8897:: with SMTP id k23mr2590713lji.285.1590861460328;
 Sat, 30 May 2020 10:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200528234025.GT23230@ZenIV.linux.org.uk> <20200529232723.44942-1-viro@ZenIV.linux.org.uk>
 <20200529232723.44942-8-viro@ZenIV.linux.org.uk> <CAHk-=wgq2dzOdN4_=eY-XwxmcgyBM_esnPtXCvz1zStZKjiHKA@mail.gmail.com>
 <20200530143147.GN23230@ZenIV.linux.org.uk> <81563af6-6ea2-3e21-fe53-9955910e303a@redhat.com>
In-Reply-To: <81563af6-6ea2-3e21-fe53-9955910e303a@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 May 2020 10:57:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiW=cKaMyBKgZMOOJQbpAyeRrz--o2H_7CdDpbn+az9vQ@mail.gmail.com>
Message-ID: <CAHk-=wiW=cKaMyBKgZMOOJQbpAyeRrz--o2H_7CdDpbn+az9vQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: kvm_hv_set_msr(): use __put_user() instead of
 32bit __clear_user()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 30, 2020 at 9:20 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Yes, the access_ok is done in __kvm_set_memory_region and gfn_to_hva()
> returns a page-aligned address so it's obviously ok for a u32.

It's not that it's "obviously ok for an u32".

It is _not_ obviously ok for a user address. There's actually no
access_ok() done in the lookup path at all, and what gfn_to_hva()
actually ends up doing in the end is __gfn_to_hva_memslot(), which has
zero overflow protection at all, and just does

        slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;

without us having _ever_ checked that 'gfn' parameter.

Yes, at some point in the very very distant past,
__kvm_set_memory_region() has validated
mem->{userspace_addr,memory_size}.  But even that validation is
actually very questionable, since it's not even done for all of the
memory slots, only the "user" ones.

So if at any point we have a non-user slot, of it at any point the gfn
thing was mis-calculated and {over,under}flows, there are no
protections what-so-ever.

In other words, it really looks like kvm is entirely dependent on
magic and luck and a desperate hope that there are no other bugs to
keep the end result as a user address.

Because if _any_ bug or oversight in that kvm_memory_slot handling
ever happens, you end up with random crap.

So no. I disagree. There is absolutely nothing "obviously ok" about
any of that kvm code. Quite the reverse.

I'd argue that it's very much obviously *NOT* ok, even while it might
just happen to work.

That double underscore needs to go away. It's either actively buggy
right now and I see no proof it isn't, or it's a bug just waiting to
happen in the future.

               Linus
