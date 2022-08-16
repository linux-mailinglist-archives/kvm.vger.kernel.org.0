Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926185965A9
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 00:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbiHPWvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 18:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiHPWvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 18:51:45 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CE0901BB
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:51:44 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id z6so16836203lfu.9
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=C5zMKo6O1AIsX4SXPjK2YwIObu5P/amVe0VlPQFbfBE=;
        b=CynbWLTVxPjEZ04QKDb+B7lkPK95HwhJrWBYD8Umnd5gBFVozIexI7kjFjy3r2cWVI
         AjjfGL1VpcpVr98f4taYq7I1iOqUTbGo5lm3Uu0yYTtIWdoxrVDfFpaxLElZdOXyT7m0
         aiMCjqJR2PMhUoVBKSMXCkMRK0Gx/yTeDnl7YMF191o3c6f0x1FAGOO7BERvsL3xVN+o
         A0qAUwsA9Qh+wxb5jnD70v5Yk/rGYofQ6zvLyXvEmmuJUSIWlkv1o5Z6pX0szb6421++
         wzWKMKZwo7Z+rNfo7KdzPUhkatfHdfEkIyzcv8dBV59sTvKQb3kxa3BdKq1JlJa+Y4j3
         znJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=C5zMKo6O1AIsX4SXPjK2YwIObu5P/amVe0VlPQFbfBE=;
        b=s3gH8IBPYO8aDQyY11N7PotFUt+TuDJQ4tTKLl0SIFHk7e+Pguw3xpV5curkNEcR3z
         aE3i4ujoZsdPqdUUFJTVaymfHwnC7mmrw1gmyAZ7MZ4QYlyMKSF4Np9hQUi1TZWWClCP
         1ypb81KvBhFsA3tC0/r8MCsdaQJZdRjyrKL7AGxauQ5dHegygzOXG4Z8pkBqCQN9PLgP
         R1aC4viQDir6WI2ilATsUlTB1G1f1mJhoOQA0CBjs50jUYPI9zBq461tsqDqBV8QAu7W
         MtZNiqcrquDJSavHXuL9QVjFxowcZALkrLlX1EdUMUO239+gW0/RshaQ12wg+RDTSGDi
         SqdQ==
X-Gm-Message-State: ACgBeo3wwTfpJMh/qBZlPgI1S+TXJRELaCOVtX6P1WMeH6SjzF2bbqbO
        mayJAkh9dUId3ZNHb54+30SfBCpdWRmrxHbei2fFqQ==
X-Google-Smtp-Source: AA6agR6rJNvdSkzkbUXOVijt+M3uVg+AKWY4Rwoarf4HzU6Y8fZ5UPEco2eMKTOoZVLNdMeLVqQB34m6QXpYtLxR534=
X-Received: by 2002:ac2:4c4f:0:b0:48b:1358:67e3 with SMTP id
 o15-20020ac24c4f000000b0048b135867e3mr7555661lfk.441.1660690302541; Tue, 16
 Aug 2022 15:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220721000318.93522-1-peterx@redhat.com> <20220721000318.93522-4-peterx@redhat.com>
 <YvVitqmmj7Y0eggY@google.com> <YvVtX+rosTLxFPe3@xz-m1.local>
 <Yvq6DSu4wmPfXO5/@google.com> <YvwCZsHxZV9kPn6I@xz-m1.local>
In-Reply-To: <YvwCZsHxZV9kPn6I@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 16 Aug 2022 15:51:16 -0700
Message-ID: <CALzav=faMEU63-7-k-CMT=R-KbBPrZmSVsD3Ef0QNP7gm68wAA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] kvm/x86: Allow to respond to generic signals
 during slow page faults
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 1:48 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Aug 15, 2022 at 09:26:37PM +0000, Sean Christopherson wrote:
> > On Thu, Aug 11, 2022, Peter Xu wrote:
> > > On Thu, Aug 11, 2022 at 08:12:38PM +0000, Sean Christopherson wrote:
> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index 17252f39bd7c..aeafe0e9cfbf 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > @@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > > > >  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > > > >                                unsigned int access)
> > > > >  {
> > > > > +       /* NOTE: not all error pfn is fatal; handle sigpending pfn first */
> > > > > +       if (unlikely(is_sigpending_pfn(fault->pfn))) {
> > > >
> > > > Move this into kvm_handle_bad_page(), then there's no need for a comment to call
> > > > out that this needs to come before the is_error_pfn() check.  This _is_ a "bad"
> > > > PFN, it just so happens that userspace might be able to resolve the "bad" PFN.
> > >
> > > It's a pity it needs to be in "bad pfn" category since that's the only
> > > thing we can easily use, but true it is now.
> >
> > Would renaming that to kvm_handle_error_pfn() help?  I agree that "bad" is poor
> > terminology now that it handles a variety of errors, hence the quotes.
>
> It could be slightly helpful I think, at least it starts to match with how
> we name KVM_PFN_ERR_*.  Will squash the renaming into the same patch.

+1 to kvm_handle_error_pfn(). Weirdly I proposed the same as part of
another series  yesterday [1]. That being said I'm probably going to
drop my cleanup patch (specifically patches 7-9) since it conflicts
with your changes and there is a bug in the last patch.

[1] https://lore.kernel.org/kvm/20220815230110.2266741-8-dmatlack@google.com/

>
> Thanks,
>
> --
> Peter Xu
>
