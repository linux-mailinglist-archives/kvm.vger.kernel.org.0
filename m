Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B5351ABB
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbhDASC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237576AbhDASAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:00:41 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6A2C031162
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 09:50:30 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e186so2838858iof.7
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IG7cdbLRsOLTbhVp6m/owdeIVeLrnBuTq0FcSaPNyZw=;
        b=WiqnXET2Wyh6a/KNqhbTDbwtl5AFiRrt/+LfiMOh7TTtIRClDGRZLFAbOAEzHOfj38
         g+u2iuzor0m3lFaxlHAHmheTzqleb2OiorqmpzUbln1BZahXfLPr4bO3PhnPwrloRihP
         Z/hPBOBThO2XZeVXF4s9rTtdjVd/mr18YJrKnbK+TPVlxDPl7hp9MJOcUTswxkHabCOt
         D62IiG8Xec3NSPYtjq+3F6Rf6ShFjJWXZjrEItcpLiGpqC3B9iddI4ZRjudfbvJgFghB
         KQFqiqvJj78G0gM+Mm9mCfH5YPATce3qIPiE0o/tSEclRHYWXsyfLzmb5AQNIvkbJzWm
         Tnrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IG7cdbLRsOLTbhVp6m/owdeIVeLrnBuTq0FcSaPNyZw=;
        b=BgF6nhfOCxfMk+lhOJwLdoF3g7t81qHDth0/D+mOXXUsPGJ3hEzNd1mBFH1/iG9plR
         XJuKEvu5j4CZWNCPVix3IgDRZtzgp8TZb6WPEJAuw9I/Dj506woS5dyw9CxW/fGbP8dE
         00OK5rz9qaVyrDPwThcDi+8sNYqPwp/J4H+Mq7I9zUm+U2Kdu89WHE1UdKj9N8e1eU1m
         a5wjGtNP/vK0MaPXZFJX+XynnMU7XMwFaQnbH6o+UKvKa0m5kwKx7nCqws0EQyZbYiEN
         sT5J4GwPepsJr28I8PQmGUxbiQGMWUnfMHuD6P1dmu9cZWOi45EcwliZCTozQD1gDbcF
         hwSA==
X-Gm-Message-State: AOAM530RRoT0veGCVesrCxEtVPi4xIuE5zbX7EltrEIzNYEGP0dTW0Dq
        B1hqoXCuyIySf1jFXoOO8l6+T8GfUr2nRi2aRV9YQg==
X-Google-Smtp-Source: ABdhPJyPlwt9XdTnKknqCS9GCyhQzgpJT8fGdYWzLyPqKD2HPehd+NAE+G6GyDOBmr8McThi8oBTiqkzgeYU4zaq1DI=
X-Received: by 2002:a05:6638:371e:: with SMTP id k30mr8718364jav.4.1617295829847;
 Thu, 01 Apr 2021 09:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com> <20210331210841.3996155-8-bgardon@google.com>
 <YGT2AV6lhDG5yLkW@google.com>
In-Reply-To: <YGT2AV6lhDG5yLkW@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 1 Apr 2021 09:50:19 -0700
Message-ID: <CANgfPd8bjO3sNAf2N0mnmSLfw57BG027eRZw4BoNN8G23BfP5Q@mail.gmail.com>
Subject: Re: [PATCH 07/13] KVM: x86/mmu: Make TDP MMU root refcount atomic
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
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

On Wed, Mar 31, 2021 at 3:22 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 31, 2021, Ben Gardon wrote:
> > In order to parallelize more operations for the TDP MMU, make the
> > refcount on TDP MMU roots atomic, so that a future patch can allow
> > multiple threads to take a reference on the root concurrently, while
> > holding the MMU lock in read mode.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
>
> ...
>
> > @@ -88,10 +88,12 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> >               next_root = list_first_entry(&kvm->arch.tdp_mmu_roots,
> >                                            typeof(*next_root), link);
> >
> > +     while (!list_entry_is_head(next_root, &kvm->arch.tdp_mmu_roots, link) &&
> > +            !kvm_tdp_mmu_get_root(kvm, next_root))
> > +             next_root = list_next_entry(next_root, link);
> > +
> >       if (list_entry_is_head(next_root, &kvm->arch.tdp_mmu_roots, link))
> >               next_root = NULL;
> > -     else
> > -             kvm_tdp_mmu_get_root(kvm, next_root);
> >
> >       if (prev_root)
> >               kvm_tdp_mmu_put_root(kvm, prev_root);
> > @@ -158,14 +160,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >
> >       /* Check for an existing root before allocating a new one. */
> >       for_each_tdp_mmu_root(kvm, root) {
> > -             if (root->role.word == role.word) {
> > -                     kvm_tdp_mmu_get_root(kvm, root);
> > +             if (root->role.word == role.word &&
> > +                 kvm_tdp_mmu_get_root(kvm, root))
>
> I'm not opposed to changing this logic while making the refcount atomic, but it
> needs to be explained in the changelog.  As is, the changelog makes it sound
> like the patch is a pure refactoring of the type.

Thanks for pointing that out. I'll add a note in the description in
v2. Those felt like natural changes since the introduction of the
atomic requires additional failure handling. I don't think there's any
way to add it as a separate commit without just introducing dead code,
but that would certainly be preferable.
