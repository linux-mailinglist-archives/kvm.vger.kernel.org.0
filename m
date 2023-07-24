Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6890D75F5AE
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 14:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjGXMJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 08:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjGXMJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 08:09:12 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB77EE61
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 05:09:10 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-57045429f76so51064877b3.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 05:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690200550; x=1690805350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wcj/BMMGz4LUl61IlM0Kx+aVcsh62woNmjsXvHa2RMs=;
        b=oNI9qzOfvtscXoDQs+fo+kXSoHDhoK8qfuCnMJy49PCo00zbD24EpQQciB6TOvhkYc
         OHMEtavpI1cmfnroyfbfZJ23LeB4fhszSviAkNK1lpo/JmGec+JVf5D+VB+nQ0tU7k0S
         NXJXdh7FxBhIyRRajW56Z/dPMc2RPYWV4r+1qUYWWcZn8vn9Hmgm5cti+lpFpkNQr+OY
         tpZvuHDOx22IbPZddsujtT/vmybxRAYdpHnoeYimrkRqh7LJesANz1MnyR7HeJYpnsqM
         uY0qin6NvzFXbfbD0qHGgTySZcK4oY6VjY47ihaTnN+EmCSjsFB/o+yAhWX/qdK+Ftyx
         QYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690200550; x=1690805350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wcj/BMMGz4LUl61IlM0Kx+aVcsh62woNmjsXvHa2RMs=;
        b=L6U2yHYTv6w0IlJRHBVr3so84ivGQQ5wMfYk9+sTphIcKEY8V7D5ebGAiDRGChL1Ef
         /OVksnA3B29TVg1Zef897iilekR2FoBmLlVyylBE8m2LqtjnzGzR5kfpD5MJMFQhUKwf
         T5X002OoAbJiS5BcZydfm7UFfNVcT14lh6Vy2xLWvDsnBv/a7R6PDwk0foppyyXgWkoG
         DNVKJTtU7IRbrF+2HbotqQAP+z3aI2r186PBlT323D6fMufJW5f/ElIc4SpKD/ITV8CG
         T3hQkpo1n2MzFk3Jl1YjcdNpfQXUEAwCd5HU1+PRkH7uZaSMZjpnHPgrRU6fI/j1eUfb
         9wcg==
X-Gm-Message-State: ABy/qLbP3U2A2yUp1pCnBT0goWtJbKlmSMBgyzGWh+4W1cED17+CbbzK
        amqAANUn63UXzpQRj1pC4NiR7U0JtfP0sfWuzbEyHBugk2BzwtQn
X-Google-Smtp-Source: APBJJlG8RcFfmNOuAY5i6QWMwPPL9v5SNunLhEYt/bqfevkOIZGWHb1QraKbk6Caz5YiT8/6Y6QIkxPR7DzG6V+0y3A=
X-Received: by 2002:a25:bc6:0:b0:d05:bf5b:918f with SMTP id
 189-20020a250bc6000000b00d05bf5b918fmr5470588ybl.28.1690200549872; Mon, 24
 Jul 2023 05:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com>
In-Reply-To: <ZLrCUkwot/yiVC8T@google.com>
From:   Amaan Cheval <amaan.cheval@gmail.com>
Date:   Mon, 24 Jul 2023 17:38:58 +0530
Message-ID: <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
Subject: Re: Deadlock due to EPT_VIOLATION
To:     Sean Christopherson <seanjc@google.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
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

> > I've also run a `function_graph` trace on some of the affected hosts, if you
> > think it might be helpful...
>
> It wouldn't hurt to see it.
>

Here you go:
https://transfer.sh/SfXSCHp5xI/ept-function-graph.log

> > Another interesting observation we made was that when we migrate a guest to a
> > different host, the guest _stays_ locked up and throws EPT violations on the new
> > host as well
>
> Ooh, that's *very* interesting.  That pretty much rules out memslot and mmu_notifier
> issues.

Good to know, thanks!

> What I suspect is happening is that get_user_pages_remote() fails for some reason,
> i.e. the workqueue doesn't fault in the page, and the vCPU gets stuck trying to
> fault in a page that can't be faulted in for whatever reason.  AFAICT, nothing in
> KVM will actually complain or even surface the problem in tracepoints (yeah, that's
> not good).

Thanks for the explanation, I did suspect something similar seeing how the page
faults / EPT_VIOLATIONs tend to loop on the same eip/rip/instruction and address
(not always, but quite often).

> To mostly confirm this is likely what's happening, can you enable all of the async
> #PF tracepoints in KVM?  The exact tracepoints might vary dependending on which kernel
> version you're running, just enable everything with "async" in the name, e.g.
>
>   # ls -1 /sys/kernel/debug/tracing/events/kvm | grep async
>   kvm_async_pf_completed/
>   kvm_async_pf_not_present/
>   kvm_async_pf_ready/
>   kvm_async_pf_repeated_fault/
>   kvm_try_async_get_page/
>
> If kvm_try_async_get_page() is more or less keeping pace with the "pf_taken" stat,
> then this is likely what's happening.

I did this and unfortunately, don't see any of these functions being
called at all despite
EPT_VIOLATIONs still being thrown and pf_taken still climbing. (Tried both with
`trace-cmd -e ...` and using `bpftrace` and none of those functions
are being called
during the deadlock/guest being stuck.)

> And then to really confirm, this small bpf program will yell if get_user_pages_remote()
> fails when attempting get a single page (which is always the case for KVM's async
> #PF usage).
>
> $ tail gup_remote.bt
> kretfunc:get_user_pages_remote
> {
>         if ( args->nr_pages == 1 && retval != 1 ) {
>                 printf("Failed remote gup() on address %lx, ret = %d\n", args->start, retval);
>         }
> }
>

Our hosts don't have kfunc/kretfunc support (`bpftrace --info` reports
`kret: no`),
but I tried just a kprobe to verify that get_user_pages_remote is
being called at all -
does not seem like it is, unfortunately:

```
# bpftrace -e 'kprobe:get_user_pages_remote { @[comm] = count(); }'
Attaching 1 probe...
^C
#
```

So I guess that disproves the async #PF theory? Any other potential causes you
can think of, or anything we can try on faulting hosts that might help
illuminate the
issue further?

Thanks for your time and help!
