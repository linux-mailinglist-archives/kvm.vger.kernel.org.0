Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3778C61057B
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiJ0WPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbiJ0WPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:15:30 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33618260B
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:15:29 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id o70so4067346yba.7
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KAollUOv/RKnCgj4ZNfhycaHs24hjcXyvHqCJPL8sbA=;
        b=GTl7we77jMZHzq02I3zBO2gxCsOhrgGiuxzb+5x5tsBe7QS2y3W1Oil0so1EbAjnqV
         wlRtVdyR9vyJoBAEf46kjlL76zFHsC5UPjaWX7xtULPkyYMD3gs/VjT3w+eM9LdwBYoK
         bQzyNyPgkKXl4Z54mdFdRFl69VnK9ESn5viHfzvcMwnIsfkZyqVK/FzBJ3ifBj9wD/qk
         MXTWdOBukDH42iT+njqXtZ9L5IK0DDh4qtYRhoCwCAYzTQ8m+5GXPoYrjZp77r6esB9e
         YSAgXKSkufc/E74ejDcuiQ/IP2CIQ0obSHKO1UMXiZqVAhOvOOI+IzY7PT2CwPHbmC+w
         oqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KAollUOv/RKnCgj4ZNfhycaHs24hjcXyvHqCJPL8sbA=;
        b=o8aJb/5YhNW9Yf+SuiVRw5Nk22cev3Ladr4R1WA5ivGKKJhS7xAyY7ldmwGVk1CwZh
         04hUThoiuFk0hVchbCTLi2n87vPAAPri07Mt2IrAyyyO6WpXeSRO6gW2D/48oH5bsKnG
         Ipiqhs3kHygJWqrP51ds12V4JfBsrsXoa7L2aurWAkijlNNYnIqlrqNSEC1+jTXJhqsI
         RTpbDIy36B0RbGwMtBxG5bEmPBRjOEY/3SIiF2Zlo7LKujeigsbEcsKECjQxd4wJD0w/
         Htp9SqcyJ8Ays56vbWk7vk0Wff8TNEBriBHK3R/WH6gsK1tNsAuMJFYRFNYssx2ulPWw
         mzuQ==
X-Gm-Message-State: ACrzQf0YPLZtmqAvjWSXZLIVT2ngFg+6GxPVs+iupCGCGtdk0ZgWgpew
        lpTG6ILjwn6/4zzwYdy2CY7CXKd53H9a0672e/f70NRwamNAlg==
X-Google-Smtp-Source: AMsMyM7C5YJU5xhg6LjT47cLnRPbgZZbVj0GoX+ORqmvLk6SkrM7Nk4Fs7Nysq6gUr/m/m0SV7xpGMx7wemBYauxlf4=
X-Received: by 2002:a5b:10c:0:b0:6be:28ee:2b86 with SMTP id
 12-20020a5b010c000000b006be28ee2b86mr43514274ybx.582.1666908928866; Thu, 27
 Oct 2022 15:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200316.2221027-1-dmatlack@google.com> <20221027200316.2221027-2-dmatlack@google.com>
 <Y1rrcOcUJMo/VFSK@google.com>
In-Reply-To: <Y1rrcOcUJMo/VFSK@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 27 Oct 2022 15:15:02 -0700
Message-ID: <CALzav=cMvsSevxS2zT6-bd+4EBFO1Jk5Y6=_6W7PsHhnW5uDeQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: Keep track of the number of memslots with dirty
 logging enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
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

On Thu, Oct 27, 2022 at 1:35 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 27, 2022, David Matlack wrote:
> > Add a new field to struct kvm that keeps track of the number of memslots
> > with dirty logging enabled. This will be used in a future commit to
> > cheaply check if any memslot is doing dirty logging.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  include/linux/kvm_host.h |  2 ++
> >  virt/kvm/kvm_main.c      | 10 ++++++++++
>
> Why put this in common code?  I'm having a hard time coming up with a second use
> case since the count isn't stable, i.e. it can't be used for anything except
> scenarios like x86's NX huge page mitigation where a false negative/positive is benign.

I agree, but what is the downside of putting it in common code? The
downside of putting it in architecture-specific code is if any other
architecture needs it (or something similar) in the future they are
unlikely to look through x86 code to see if it already exists. i.e.
we're more likely to end up with duplicate code.

And while the count is not stable outside of slots_lock, it could
still theoretically be used under slots_lock to coordinate something
that depends on dirty logging being enabled in any slot. In our
internal kernel, for example, we use it to decide when to
create/destroy the KVM dirty log worker threads (although I doubt that
specific usecase will ever see the light of day upstream :).

>
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 32f259fa5801..25ed8c1725ff 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -709,6 +709,8 @@ struct kvm {
> >       struct kvm_memslots __memslots[KVM_ADDRESS_SPACE_NUM][2];
> >       /* The current active memslot set for each address space */
> >       struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
> > +     /* The number of memslots with dirty logging enabled. */
> > +     int nr_memslots_dirty_logging;
>
> I believe this can technically be a u16, as even with SMM KVM ensures the total
> number of memslots fits in a u16.  A BUILD_BUG_ON() sanity check is probably a
> good idea regardless.

Will do.

>
> >       struct xarray vcpu_array;
> >
> >       /* Used to wait for completion of MMU notifiers.  */
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index e30f1b4ecfa5..57e4406005cd 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1641,6 +1641,9 @@ static void kvm_commit_memory_region(struct kvm *kvm,
> >                                    const struct kvm_memory_slot *new,
> >                                    enum kvm_mr_change change)
> >  {
> > +     int old_flags = old ? old->flags : 0;
> > +     int new_flags = new ? new->flags : 0;
>
> Not that it really matters, but kvm_memory_slot.flags is a u32.

Oops, thanks.

>
> >       /*
> >        * Update the total number of memslot pages before calling the arch
> >        * hook so that architectures can consume the result directly.
> > @@ -1650,6 +1653,13 @@ static void kvm_commit_memory_region(struct kvm *kvm,
> >       else if (change == KVM_MR_CREATE)
> >               kvm->nr_memslot_pages += new->npages;
> >
> > +     if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) {
> > +             if (new_flags & KVM_MEM_LOG_DIRTY_PAGES)
> > +                     kvm->nr_memslots_dirty_logging++;
> > +             else
> > +                     kvm->nr_memslots_dirty_logging--;
>
> A sanity check that KVM hasn't botched the count is probably a good idea.  E.g.
> __kvm_set_memory_region() as a WARN_ON_ONCE() sanity check that KVM won't end up
> underflowing nr_memslot_pages.

Good idea, will do.
