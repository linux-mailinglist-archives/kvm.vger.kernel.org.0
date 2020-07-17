Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD3222FDF
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 02:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgGQAUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 20:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgGQAUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 20:20:04 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606F2C061755;
        Thu, 16 Jul 2020 17:20:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id p205so8343637iod.8;
        Thu, 16 Jul 2020 17:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2FerGNFZKniOyRFjaMMBJDlV2XPDBsl8JaLwC0gfi7o=;
        b=f+wrzPk6yzAFgWypM0ttm/bz88d9IaZzRis5kK0Eg82y3tF0dYe+k5a4N/iohJ+icy
         fEthlTkf5JQC8a7kxhlUo4255wTDwmqU6lgIMBKiZ9gr4Z2xnWvSV2ERS6YkpEmAdL8I
         dHDO752UplWksHQed6DBxtBpHktstX55MpMHNGhY/cp+J5vzeLeHCnMvKklU5fS0jt18
         nPp49+DQKOwQZkz46FVTUGy7h/umw2sj/fjz+agmH43PwHR69CcuAq3sntZ9P2CWgUaX
         D2XGBWyL3c0BBsyUmhDo/AyYb2Q+jNNwFSpSCOLPTVK7tB4lTPGrkReUPqbMh9SBoUaA
         /14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2FerGNFZKniOyRFjaMMBJDlV2XPDBsl8JaLwC0gfi7o=;
        b=XQ3kwtS8jZAZ9pok03lggWMwcWaC3CszDocQCo9lAeQ3bQRKJ6F3bveNNjM2TR1r5y
         +jVx1tPd1dSeYKoMKw/c+2ZB4hlM8uQqw3ATnbP5p2ta0sclTWRMyacbnpiV4XFs+F9k
         wRWFr7E3q+QIHnW9I8YzwEdRfz93Bw2LBS1K903fj4BW0F0HE8TA/MhWnWLmYUZfXSWY
         lel5sjVZ7CPpEWls5U3WrdNxWcmO+8TA0OJpDrAenSSGLPWcZGoN+6WE7UNe7RBfWH3K
         XY5wk7T/nPhoZYJjoSlLFbETRZI3FNQgzpKk3hMHJP2Lw1BIpryCMbcPjv8J5AmJdszn
         GQnA==
X-Gm-Message-State: AOAM530ABMdvo4iIMkApIfd4C+vhIZYYao6aXEHi0ZNr8gJRGLShRvDF
        kgG+76kXh+N/wsU2/Z+BWYojKpN8hGIDySXO9vI=
X-Google-Smtp-Source: ABdhPJzJta5CGSAocN1NwUPeSiy2NdfZZdS1injlrEqZEkECIvwcAMeclHWbF2u2vMwrP7iKeAvo69aMuoNmmRi2bfQ=
X-Received: by 2002:a5d:9c0e:: with SMTP id 14mr7033701ioe.109.1594945203608;
 Thu, 16 Jul 2020 17:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com> <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
In-Reply-To: <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
From:   Dexuan-Linux Cui <dexuan.linux@gmail.com>
Date:   Thu, 16 Jul 2020 17:19:52 -0700
Message-ID: <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     madhuparnabhowmik10@gmail.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        frextrite@gmail.com, lkft-triage@lists.linaro.org,
        Dexuan Cui <decui@microsoft.com>, juhlee@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 7:47 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Sun, 12 Jul 2020 at 21:39, Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sun, Jul 12, 2020 at 06:40:03PM +0530, madhuparnabhowmik10@gmail.com wrote:
> > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > >
> > > Use hlist_for_each_entry_srcu() instead of hlist_for_each_entry_rcu()
> > > as it also checkes if the right lock is held.
> > > Using hlist_for_each_entry_rcu() with a condition argument will not
> > > report the cases where a SRCU protected list is traversed using
> > > rcu_read_lock(). Hence, use hlist_for_each_entry_srcu().
> > >
> > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >
> > I queued both for testing and review, thank you!
> >
> > In particular, this one needs an ack by the maintainer.
> >
> >                                                         Thanx, Paul
> >
> > >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > > index a7bcde34d1f2..a9cd17625950 100644
> > > --- a/arch/x86/kvm/mmu/page_track.c
> > > +++ b/arch/x86/kvm/mmu/page_track.c
> > > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > >               return;
> > >
> > >       idx = srcu_read_lock(&head->track_srcu);
> > > -     hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > +     hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > > +                             srcu_read_lock_held(&head->track_srcu))
>
> x86 build failed on linux -next 20200716.
>
> arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_write':
> include/linux/rculist.h:727:30: error: left-hand operand of comma
> expression has no effect [-Werror=unused-value]
>   for (__list_check_srcu(cond),     \
>                               ^
> arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro
> 'hlist_for_each_entry_srcu'
>   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
>   ^~~~~~~~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_flush_slot':
> include/linux/rculist.h:727:30: error: left-hand operand of comma
> expression has no effect [-Werror=unused-value]
>   for (__list_check_srcu(cond),     \
>                               ^
> arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro
> 'hlist_for_each_entry_srcu'
>   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
>   ^~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> make[3]: *** [arch/x86/kvm/mmu/page_track.o] Error 1
>
> build link,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/815/consoleText
>
> --
> Linaro LKFT
> https://lkft.linaro.org

Hi, we're seeing the same building failure with the latest linux-next tree.

Thanks,
Dexuan
