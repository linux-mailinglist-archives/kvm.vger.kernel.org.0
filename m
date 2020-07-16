Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF79222613
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 16:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgGPOpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 10:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgGPOpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 10:45:08 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30324C08C5C0
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 07:45:08 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so7386145ljg.13
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 07:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEqbgXg5bolFCkaEREfRLUaB6wjIdNl0kMgYuxyNxpI=;
        b=GEjIqLiPxGWf30Xto3dr/VRzc+jve2MqdPGTM9sUQj6SX8bHj0uzqXyVE5K8msut3n
         LcgTNQNJqtw7IemIFS+OMy8vmAQJCY2yQD7IgTshitTlPFcWnVmsuYJ0Z2hDwfzIKbUJ
         cKheZtsoJichKATZ899iNX3ePelWfAebfy3ARo5wiIs/R4Ud+5wEUK8+rmEAaUYXT4EQ
         dVl7m668gegN7uHOzqeusAgXDr24DBP48h/z5g7LjaM5rNfYR1pD6vD7nw/+P7k2Db7a
         4tu57r9py1rEFDd2fujZs9B4aNhKOTlR4jVM85AT7LS+H2TzMmskAYFNea1MPtilOpHP
         uxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEqbgXg5bolFCkaEREfRLUaB6wjIdNl0kMgYuxyNxpI=;
        b=q3ssfCeLhs+7KoHCN0mcB7GwzFQB4dW4b5Sd/4kfjpowXP5zzalr4gKtwoD90U767m
         4zYgoKpkdGvM+LhCLOeJbsLDB44jmyTChyAjnb/lQXeIv9VdIQwJXa48s7nCEDuJJAx5
         zZ5DPmWN7a4BlFLyfNw2DXStr8esDX7r35fE/NTfuPUxK8JLei2FoTuzlp+tnSj7nNOR
         u34pFJCG//H8Q8ZxSYRdAL7ngoxNDKuBHI6aq24qNkudixpLZ9W3w/Sxtg5LKii1e71x
         jv1AUcf+/uHBMYGi8N6F3yd/7EQEM4ywu0uhe75MvDgoiXrV5dX3DT02cQdwghToiwHB
         vN6Q==
X-Gm-Message-State: AOAM531pQTzbTS6jJBWPFImkUH2fG3TMdLW1ymMessSWwhsD/cAXHpV3
        I79RPEKlLLbWe1+8olLG+s6iqfZfHzfttbJ9m/XPNQ==
X-Google-Smtp-Source: ABdhPJwJEhKsmRxsAvPniebMSKL4vf5R0zcd380KCBeBrDwpEZAgDNUsbbYigJ6CStV4ZzKU0+7UrLBBBKm2jdUPO50=
X-Received: by 2002:a2e:b054:: with SMTP id d20mr2073091ljl.55.1594910706505;
 Thu, 16 Jul 2020 07:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com> <20200712160856.GW9247@paulmck-ThinkPad-P72>
In-Reply-To: <20200712160856.GW9247@paulmck-ThinkPad-P72>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 Jul 2020 20:14:54 +0530
Message-ID: <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
To:     madhuparnabhowmik10@gmail.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     josh@joshtriplett.org, Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        frextrite@gmail.com, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Jul 2020 at 21:39, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Sun, Jul 12, 2020 at 06:40:03PM +0530, madhuparnabhowmik10@gmail.com wrote:
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >
> > Use hlist_for_each_entry_srcu() instead of hlist_for_each_entry_rcu()
> > as it also checkes if the right lock is held.
> > Using hlist_for_each_entry_rcu() with a condition argument will not
> > report the cases where a SRCU protected list is traversed using
> > rcu_read_lock(). Hence, use hlist_for_each_entry_srcu().
> >
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>
> I queued both for testing and review, thank you!
>
> In particular, this one needs an ack by the maintainer.
>
>                                                         Thanx, Paul
>
> >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > index a7bcde34d1f2..a9cd17625950 100644
> > --- a/arch/x86/kvm/mmu/page_track.c
> > +++ b/arch/x86/kvm/mmu/page_track.c
> > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> >               return;
> >
> >       idx = srcu_read_lock(&head->track_srcu);
> > -     hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > +     hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > +                             srcu_read_lock_held(&head->track_srcu))

x86 build failed on linux -next 20200716.

arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_write':
include/linux/rculist.h:727:30: error: left-hand operand of comma
expression has no effect [-Werror=unused-value]
  for (__list_check_srcu(cond),     \
                              ^
arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro
'hlist_for_each_entry_srcu'
  hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
  ^~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_flush_slot':
include/linux/rculist.h:727:30: error: left-hand operand of comma
expression has no effect [-Werror=unused-value]
  for (__list_check_srcu(cond),     \
                              ^
arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro
'hlist_for_each_entry_srcu'
  hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
  ^~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[3]: *** [arch/x86/kvm/mmu/page_track.o] Error 1

build link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/815/consoleText

-- 
Linaro LKFT
https://lkft.linaro.org
