Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C59C38B942
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 23:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhETV6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 17:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhETV6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 17:58:32 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9894C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 14:57:09 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 131so21647792ljj.3
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 14:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJfWB1VaJBJ5Yl+QHokcIZ37jKWO4lVzBlah/HAG0zs=;
        b=lSeatsn4/9ZkhuXtAWV046PYUuww8IX7iO77h/TKv6Zl2d7TMHPf2yQm8vm2gPkERj
         bT0RX99GH8Evp3kXku/7uNZydTZEzsaDbkGRmLAFp2bWnbGfi8J1cNuXP82X+s2Aqe1y
         qRkDJvTbg6+pNL+RMIF6r6wXC893wyhq6BaFzsyIksW9564A3yA/QaNfSqkGlAIMe8pz
         f1Y+JWmTkrYOPBgIYATt0pgIok0wWIqA+QTsYnR5bhW0APHCz0+3pQLjlbQT0lR5DrwE
         X1NTXv6PGgaSVM7+2pB+HPOHRISWYRruCQ5JuCeiWdlz9NrQj3uDAw2O/0J/TbZKP1tz
         uMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJfWB1VaJBJ5Yl+QHokcIZ37jKWO4lVzBlah/HAG0zs=;
        b=CwFfShhGDQ54qzJTFdU/yn2vqTa2fBJ2Kj1RpyVlB4BzDG5lHte53j4Wofd07jw98H
         igmJF7b7mGNDL3zpBzRm4Bbw++BFcYA3rEBbVFQQcshMYrGdGAC7MISHCD0vqVK95d6X
         KgfABEBD3qeZs/K7YvPFNadBBTFAM1Hmtr805W67OpLNaLqLMWVFngbpoA345Yx11ILR
         nIIUweLadpTR3CXx/stuvpvD9wzlrWWlxSOzdIlAmmSq2IqEdYyQBmzN000CsXzaAupa
         3+am739RdlbSAhUNWwxziQNenMHNbMLyOH9oNrNxbONotxITn972YHzuGzN99aohRbkx
         RpFg==
X-Gm-Message-State: AOAM533OZecnchJOyW4hMA1FYTCQ55dbx2YbjJl6gD7MBUtXOtsv0AQD
        9IRvaVOKhBrztn6agDG4MIlf8ec+Bx6AnOzXUTPMkh0cgdUGEIi5
X-Google-Smtp-Source: ABdhPJxAdXxF34xt+PyKInuXQv69lGYbvbOnCpPE34cFqJyxvoSNjIjxZMPhEuK6QiCwlSvBguywJcKkwIH/xoCaqSk=
X-Received: by 2002:a2e:5d7:: with SMTP id 206mr4604219ljf.448.1621547827692;
 Thu, 20 May 2021 14:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210520212654.712276-1-dmatlack@google.com> <YKbZAT/cE5SobbGX@t490s>
In-Reply-To: <YKbZAT/cE5SobbGX@t490s>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 20 May 2021 14:56:41 -0700
Message-ID: <CALzav=dixRORFDyeaj67=SyXko9t++qGgnCJrhWD7bBKqz_3mA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 2:47 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Thu, May 20, 2021 at 09:26:54PM +0000, David Matlack wrote:
> > vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
> > which causes the upper 32-bits of the max_gfn to get truncated.
> >
> > Nobody noticed until now likely because vm_get_max_gfn() is only used
> > as a mechanism to create a memslot in an unused region of the guest
> > physical address space (the top), and the top of the 32-bit physical
> > address space was always good enough.
>
> s/top/bottom/?

I guess it depends on your reference point :). The existing comments
under tools/testing/selftests/kvm use the convention that "top" ==
high addresses.

>
> Looks right.. thanks for fixing it!
>
> >
> > This fix reveals a bug in memslot_modification_stress_test which was
> > trying to create a dummy memslot past the end of guest physical memory.
> > Fix that by moving the dummy memslot lower.
>
> Would it be better to split the different fixes?

I'm fine either way. I figured the net delta was small enough and the
fixes tightly coupled so sending as one patch made the most sense. Is
there value in splitting this up?

>
> >
> > Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h |  2 +-
> >  tools/testing/selftests/kvm/lib/kvm_util.c     |  2 +-
> >  .../testing/selftests/kvm/lib/perf_test_util.c |  2 +-
> >  .../kvm/memslot_modification_stress_test.c     | 18 +++++++++++-------
> >  4 files changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 84982eb02b29..5d9b35d09251 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -303,7 +303,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
> >
> >  unsigned int vm_get_page_size(struct kvm_vm *vm);
> >  unsigned int vm_get_page_shift(struct kvm_vm *vm);
> > -unsigned int vm_get_max_gfn(struct kvm_vm *vm);
> > +uint64_t vm_get_max_gfn(struct kvm_vm *vm);
> >  int vm_get_fd(struct kvm_vm *vm);
> >
> >  unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 1af1009254c4..aeffbb1e7c7d 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2058,7 +2058,7 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
> >       return vm->page_shift;
> >  }
> >
> > -unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> > +uint64_t vm_get_max_gfn(struct kvm_vm *vm)
> >  {
> >       return vm->max_gfn;
> >  }
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > index 81490b9b4e32..ed4424ed26d6 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -80,7 +80,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
> >        */
> >       TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
> >                   "Requested more guest memory than address space allows.\n"
> > -                 "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
> > +                 "    guest pages: %lx max gfn: %lx vcpus: %d wss: %lx]\n",
>
> If to fix it, maybe start to use PRIu64 (and include inttypes.h)?

Will do.

Thanks!

>
> Thanks,
>
> --
> Peter Xu
>
