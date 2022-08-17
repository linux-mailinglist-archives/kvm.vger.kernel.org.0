Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5477597546
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiHQRrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 13:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240454AbiHQRrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 13:47:03 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC055B07D
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:47:00 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id v10so14227749ljh.9
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6Lpiz1ta55Jcbs86VApGk1gBmJf3rbYmfoE4TTocMyg=;
        b=fBeT+IwOc0/XwL2vLP9Dex41RpuBNVduuFonHwppiuYa1kIt5ujt0uaOIa43t69Qjj
         +Nt1rqDYMbyhOM5sRIcv2QQUUwBXV4A0hEoPReAra7yaVMCjhhHNGF4wPnIexGZxVDT+
         oXmXnjnNb6TdoAWWjAMxPDbGtkqWZQBNOviSQByney9PVYpWZOlAeraAb9NKb/H+JZnS
         4s043dSOm2OEzM4dA4li12obU8tq5f0cLomn/77OULeUzBr5JYscAZ8Hxts4dN2Svrp7
         U85EVMqBOj7Y70/IaKd4iHZ1ItDrI+OqNe8S/FfcSUIsc6Vlau3hEZvECPAaXqxpOeoo
         p7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6Lpiz1ta55Jcbs86VApGk1gBmJf3rbYmfoE4TTocMyg=;
        b=h7li70+XxfvKcCKgluWDbWT/phQUf49mRMBr7ERoaOGaPBxIY6O1cZKu3CLd8QaCnd
         ANt+TctYHKnaJLBYvamxYuaArPTImHQt1n7h39JdmB3f1Gg++7Kf19sr1pljNc4uIYcT
         Ad+4Xy2iO+rP8IefUaRQxG7IB6BzqyMqTOuropTbR3YFlz0cpn7peJq3Hm9RO9tiNGmk
         1kTW5JOaHSeaCq3FnQ3fHB7uXN0IlNnnjFsetfv3DeS19a8vYcenrS5gI15ZEhXR4/k/
         LURCo3MIEt022SuQBpzW3cC7jBq6w7PaDOLr4uDBBeBWzSY6Yeonssv0oQxBxstkW2Kp
         6guw==
X-Gm-Message-State: ACgBeo1+7RzeTJ0DYbZHlfIvcLNCKtdSCNJJAh8eNfjZzMflqOjdB5CI
        QDvRm8/QQGPbnfZ4fua2BHGQtXRX/AXQWMgWtCyRlQ==
X-Google-Smtp-Source: AA6agR49in0ysMLor1E06mPm8fra2qPN3GRd9f9TXLyO/ONnzkdXQsqu76HSr+DQw3MZ6GEySqWDqR6SCdTJzdU5Yww=
X-Received: by 2002:a2e:8758:0:b0:261:811d:8599 with SMTP id
 q24-20020a2e8758000000b00261811d8599mr6178565ljj.322.1660758419216; Wed, 17
 Aug 2022 10:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com> <20220815230110.2266741-2-dmatlack@google.com>
 <4789d370-ac0d-992b-7161-8422c0b7837c@redhat.com> <CALzav=cvxR3R6v2CptJJfPaH1go1zxDE15Aedw3ztT-w+wcVKQ@mail.gmail.com>
 <5969026f-8202-3407-b7de-224148e6c1d3@redhat.com>
In-Reply-To: <5969026f-8202-3407-b7de-224148e6c1d3@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 17 Aug 2022 10:46:32 -0700
Message-ID: <CALzav=fGsasHzpsRWczJwmJJh2YNMaOWmRy670dfD_zuiJ1+vQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 9:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 8/17/22 18:49, David Matlack wrote:
> > On Wed, Aug 17, 2022 at 3:05 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 8/16/22 01:01, David Matlack wrote:
> >>> Delete the module parameter tdp_mmu and force KVM to always use the TDP
> >>> MMU when TDP hardware support is enabled.
> >>>
> >>> The TDP MMU was introduced in 5.10 and has been enabled by default since
> >>> 5.15. At this point there are no known functionality gaps between the
> >>> TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
> >>> better with the number of vCPUs. In other words, there is no good reason
> >>> to disable the TDP MMU.
> >>>
> >>> Dropping the ability to disable the TDP MMU reduces the number of
> >>> possible configurations that need to be tested to validate KVM (i.e. no
> >>> need to test with tdp_mmu=N), and simplifies the code.
> >>
> >> The snag is that the shadow MMU is only supported on 64-bit systems;
> >> testing tdp_mmu=0 is not a full replacement for booting up a 32-bit
> >> distro, but it's easier (I do 32-bit testing only with nested virt).
> >
> > Ah, I did forget about 32-bit systems :(. Do Intel or AMD CPUs support
> > TDP in 32-bit mode?
>
> Both do.  Intel theoretically on some 32-bit processors that were
> actually sold, too.
>
> >> Personally I'd have no problem restricting KVM to x86-64 but I know
> >> people would complain.
> >
> > As a middle-ground we could stop supporting TDP on 32-bit
> > systems. 32-bit KVM would continue working but just with shadow
> > paging.
>
> The main problem is, shadow paging is awfully slow due to Meltdown
> mitigations these days.  I would start with the read-only parameter and
> then see whether there's more low-hanging fruit (e.g. make fast page
> fault TDP MMU-only).

Will do, thanks for the feedback.

>
> Paolo
>
> >> What about making the tdp_mmu module parameter read-only, so that at
> >> least kvm->arch.tdp_mmu_enabled can be replaced by a global variable?
> >>
> >> Paolo
> >>
> >
>
