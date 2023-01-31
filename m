Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEF368350D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 19:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjAaSTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 13:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjAaSTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 13:19:51 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEBF589B4
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:19:38 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id pj1so6902531qkn.3
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hK0xL11vO1cW1nuDhXZMtvmMjIJPZj7ljY3iY/xX6Vo=;
        b=hFHRU4aUCHe7FZOkeFDWhbz4E74GM2js7i6pMBN/oU6YLbo7iYmH13ZcGo5RAJXAuC
         NrtUNZ5Q1IUUbYpR4TAIP0rOsBQjjVdskDLir0jwluBaZ5j4uP8tmkaWrx4KjCnIDj9I
         dB5bFWlnQdnUl0Y5LVJt5jMTjHNPmNUCTL44yKcDmbewgDgh6vOzWwRSDUmYoRBNn7zf
         tltQxw54cL8svhzjZ5dSZ531DvCA9g5ot3Bg/N2iz48n8r/rKvtfmCjvA5f1iaaKLCP5
         jPNzVO0XA4il8oqT9KIxstFWUCEo19YSFLSV+8gTdZgDpEa5TdQIruPc4CrlADkNhprM
         6bHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hK0xL11vO1cW1nuDhXZMtvmMjIJPZj7ljY3iY/xX6Vo=;
        b=s010oZSmtjQxdwURCS9hyLDt9BRT0eO2a8KZavAQuBCEIudM+kNtjsC876HPpeltvy
         jRMpE1hDBIHWIkj8K8HovPx64mHJtIeVVzDcQN5Z5h5f2jMLCucdVPM0Hmcj7IyjbTLU
         SSRgl/iSC5wW1ckXKzykkANjkteWxjNR4WAFxeEJnIY2ik6ERtQTp3mHqOW1FwSEmnY/
         JBKUhGcmpxluE0ahvXwJEt9u6vOj+Q+dgukWB2WIHmTp3c71c98DbGGdmn2ltfAONpic
         lqxHSQSyuSeI/gTLOQnqS9i7F9JCxRaB8m10JhfSHXKQw6cGHsoqpqns9g8fEj2DpdK1
         KFVA==
X-Gm-Message-State: AFqh2kpIlOTRwSV3OGi0UfUHI8zUw3FdXAaDF6BqajIi3aF8bmltjMM7
        ZKkPRBBP2vq8o11ULeWybGK3PvoJMqeFIraGpNvJVQ==
X-Google-Smtp-Source: AMrXdXvFPI0jCmSwoX1pEMKknliZ3GDVJ/tsK8hnkzz2iLSekN1hlJptmjeWLuvwCJONXKMT0HsuUjWH1tRUCPVuJiQ=
X-Received: by 2002:a05:620a:1e1:b0:706:8588:513c with SMTP id
 x1-20020a05620a01e100b007068588513cmr3034813qkn.390.1675189177184; Tue, 31
 Jan 2023 10:19:37 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi> <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org> <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com> <Y9hsV02TpQeoB0oN@google.com>
 <Y9lTz3ryasgkfhs/@google.com> <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
In-Reply-To: <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Tue, 31 Jan 2023 10:19:25 -0800
Message-ID: <CAOHnOrwVgpznefk_vSeLAfj7zMGnofJSCgb5G8CU0S1xQYAJrg@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
To:     David Matlack <dmatlack@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        yuzenghui@huawei.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 10:02 AM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Jan 31, 2023 at 9:46 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> > > On Mon, Jan 30, 2023, Oliver Upton wrote:
> > > > I think that Marc's suggestion of having userspace configure this is
> > > > sound. After all, userspace _should_ know the granularity of the backing
> > > > source it chose for guest memory.
> > > >
> > > > We could also interpret a cache size of 0 to signal that userspace wants
> > > > to disable eager page split for a VM altogether. It is entirely possible that
> > > > the user will want a differing QoS between slice-of-hardware and
> > > > overcommitted VMs.
> > >
> > > Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> > > guarantees for all VMs on a system are better met by enabling eager splitting
> > > across the board.
> > >
> > > There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> > > to let the user opt out even when something is on by default.  x86's TDP MMU has
> > > benefited greatly from downstream users being able to do A/B performance testing
> > > this way.  I suspect x86's eager_page_split knob was added largely for this
> > > reason, e.g. to easily see how a specific workload is affected by eager splitting.
> > > That seems like a reasonable fit on the ARM side as well.
> >
> > There's a rather important distinction here in that we'd allow userspace
> > to select the page split cache size, which should be correctly sized for
> > the backing memory source. Considering the break-before-make rules of
> > the architecture, the only way eager split is performant on arm64 is by
> > replacing a block entry with a fully populated table hierarchy in one
> > operation.
>
> I don't see how this can be true if we are able to tolerate splitting
> 2M pages. Splitting 2M pages inherently means 512 Break-Before-Make
> operations per 1GiB region of guest physical memory.
>
> If we had a cache size of 1 and were splitting a 1GiB region, we would
> then need to do 512+1 BBM per 1GiB region. If we can tolerate 512 per
> 1GiB, why not 513?
>
> It seems more like the 513 cache size is more to optimize splitting
> 1GiB pages.

That's correct. Although there's also a slight benefit for the 2M huge-pages
case as the 512 huge-pages can be split without having to walk down
the tree from the root every time.

> I agree it can turn those 513 int 1, but future versions
> of the architecture also elide BBM requirements which is another way
> to optimize 1GiB pages.

There's also the CPU cost needed to walk down the tree from the root
513 times (same as above).

>
>
> > AFAICT, you don't have this problem on x86, as the
> > architecture generally permits a direct valid->valid transformation
> > without an intermediate invalidation. Well, ignoring iTLB multihit :)
> >
> > So, the largest transformation we need to do right now is on a PUD w/
> > PAGE_SIZE=4K, leading to 513 pages as proposed in the series. Exposing
> > that configuration option in a module parameter is presumptive that all
> > VMs on a host use the exact same memory configuration, which doesn't
> > feel right to me.
> >
> > --
> > Thanks,
> > Oliver
