Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3FE6E50B5
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 21:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjDQTQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 15:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDQTQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 15:16:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D1B40E6
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 12:16:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54ee12aa4b5so239881947b3.4
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 12:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681758981; x=1684350981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ncZxqb5WFyPe1+ZpQ8PZQt8gt8+1KXsaLpvOssElGw=;
        b=ztrYx909wU0E4C4fpIxazR3iU1/doAqQTn/It7I5XO5RP/H9ZYXyuhKdBCToffXuA4
         9ymN8fyVDotr5xXEsIlQKbUlszwHgxz60FNw04gzVNpruLyyx64PubrHWVLlZpqpBhvh
         vKWEH9YJ0YOLYMGo4iFU65zKtP7q7UZnp+uz9t4BR4N/9FBLehmWY0SIc5VhHkip24G5
         K1m5AlClUhPs9NQEruZr7RLnkYdxG6AQA5cbku/1KRM6FGgQmeipGncM5ftAnohmLBxq
         maaJarYp0xwTDMAFLUo1WRHPRRXtnFqiq3K5A0R+O1k2UroqEOBdn4ZYqcx+PaU9ygpP
         MwIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758981; x=1684350981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ncZxqb5WFyPe1+ZpQ8PZQt8gt8+1KXsaLpvOssElGw=;
        b=gJLp0EEK6cKT3B8ZQI7vlt82T7wqiwaDNsYS2yATYuVhz8Pe4wgaH/t588GsnyKOeJ
         Kim2bzD6beBeMTkke+ehlBrI/MCuQey8b+pjsCxOT7eJgw9b0X2qnvKdjHb8oVI0S3dX
         sJSoGqG2Lq1XcNAZ9rDYOF6PODu02pqKBCSSQkVGYN+sRqkAZm3ZmEHi/+a37gCmfedn
         pQmN6VOpSeJmTk3Nz/dRX2yl4ChC8KF9C2EOqR2qVqU7vIifRjaLo74jTBdSu0DN/HJE
         DIwRIYokaFUfxLh0KQibYlmYCt1ZCjvA2ce9NxZlCR0yIPGOMlZq+duWC1w4LgwD4bkE
         WoDg==
X-Gm-Message-State: AAQBX9eW1U/Rt43JzmIuDrFomG4fhVbzl3UwA2vyoMyjA4q6E2KNEcCy
        IBIUYNJcd5dTDvmbx/pLsBYR2ksB9RM=
X-Google-Smtp-Source: AKy350a2dsem8ucyiGhUFVn2DtBy6lBFc/RqNb+Jfev6KtVWLDED5ErUcWhYM9l9XcC5/F95P0TGKweWO+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e0c5:0:b0:b75:8ac3:d5d9 with SMTP id
 x188-20020a25e0c5000000b00b758ac3d5d9mr10290256ybg.3.1681758981543; Mon, 17
 Apr 2023 12:16:21 -0700 (PDT)
Date:   Mon, 17 Apr 2023 12:16:20 -0700
In-Reply-To: <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
Mime-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
Message-ID: <ZD2bBB00eKP6F8kz@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023, David Hildenbrand wrote:
> On 17.04.23 18:40, Sean Christopherson wrote:
> > On Mon, Apr 17, 2023, David Hildenbrand wrote:
> > > On 17.04.23 17:40, Sean Christopherson wrote:
> > > > I want to start referring to the code/patches by its syscall/implementation name
> > > > instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the broader effort
> > > > and not just the non-KVM code, and (c) will likely be confusing for future reviewers
> > > > since there's nothing in the code that mentions "UPM" in any way.
> > > > 
> > > > But typing out restrictedmem is quite tedious, and git grep shows that "rmem" is
> > > > already used to refer to "reserved memory".
> > > > 
> > > > Renaming the syscall to "guardedmem"...
> > > 
> > > restrictedmem, guardedmem, ... all fairly "suboptimal" if you'd ask me ...
> > 
> > I'm definitely open to other suggestions, but I suspect it's going to be difficult
> > to be more precise than something like "guarded".
> 
> Guardedmem is just as bad as restrictedmem IMHO, sorry.
> 
> 
> Restricted: what's restricted? how does the restriction manifest? secretmem
> also has it's restrictions/limitations (pinning), why does that one not fall
> under the same category?
> 
> Make a stranger guess what "restrictedmem" is and I can guarantee that it
> has nothing to do with the concept we're introducing here.
> 
> 
> Guarded: what's guarded? From whom? For which purpose? How does the
> "guarding" manifest?

I completely agree that "guarded" lacks precision, but as above, I've pretty much
given up hope of being super precise.  I actually like "restricted", I just don't
like that I can't shorten the name.

Hmm, maybe that won't be a huge problem in practice.  I can't say I've ever heard
any use "rmem" in verbale or written communication, it's primarily just "rmem" in
code that we can't use, and I don't mind having to use restrictedmem for the namespace.
So maybe we can use "rmem", just not in code?

Or, we could pretend we're pirates and call it arrrmem!, which is definitely going
to be how I refer to it in my internal dialogue if we keep "restricted" :-)

> Again, make a stranger guess what "guardedmem" is and I can guarantee that
> it has nothing to do with the concept we're introducing here.
> 
> If, at all, the guess might be "guarded storage" [1] on s390x, which, of
> course, has nothing to do with the concept here.

Oof, and guarded storage is even documented in Documentation/virt/kvm/api.rst.

> (storage on s390x is just the dinosaur slang for memory)
> 
> 
> Often, if we fail to find a good name, the concept is either unclear or not
> well defined.
> 
> So what are the characteristics we want to generalize under that new name?
> We want to have an fd, that
> 
> (a) cannot be mapped into user space (mmap)
> (b) cannot be accessed using ordinary system calls (read/write)
> (c) can still be managed like other fds (fallocate, future NUMA
>     policies?)
> (d) can be consumed by some special entities that are allowed to
>     read/write/map.
> 
> So the fd content is inaccessible using the ordinary POSIX syscalls. It's
> only accessible by special entities (e.g., KVM).
> 
> Most probably I am forgetting something. But maybe that will help to find a
> more expressive name. Maybe :)

Hidden/Concealed/etc - Too close to secretmem, suffers the "hidden from whom" problem,
and depending on the use case, the memory may not actually be concealed from the
user that controls the VMM.

Restricted - "rmem" collides with "reserved memory" in code.

Guarded - Conflicts with s390's "guarded storage", has the "from whom" problem.

Inaccessible - Many of the same problems as "hidden".

Unmappable - Doesn't cover things like read/write, and is wrong in the sense that
the memory is still mappable, just not via mmap().

Secured - I'm not getting anywhere near this one :-)
