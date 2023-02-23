Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331D76A1088
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjBWTZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjBWTZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:25:53 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637A519F07
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:25:52 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id m10so15371392vso.4
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RaN2m3eSdvQkZvFXVE5UwMtaHXh9kInOcPsQSxfuApo=;
        b=EdY0Zf42ZDRE5qttzyl6jWrHpR09fR1WYt885kd5Np43hjOjFvTgv/qafLuP2e/iYn
         Q5NiW0sXJQ99vo9CaNQ0NgLbSkRRmaO8aMUbNLNlhu2ZbabhX9zEOX5k/kc2LuYCJFtr
         qQnSvXzZNvaThZ8gqnSKqcakXE3Dm5AGNefE0M3sBomy7U9GtpPIIzmUgxTF3/IyYYmw
         3J4ppBng3VEdZz4yGITOqYKi96kzh8seeVMxnEEhXUZrW50AtA5j0DmRye+ILDXMuKh9
         5yZ+74iJ6VpGIZ9GKicdgFx5BWvLcdUTerJkJh4BQ8UOfIm5uv4FE50NVc66HSEwySfk
         y1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RaN2m3eSdvQkZvFXVE5UwMtaHXh9kInOcPsQSxfuApo=;
        b=35TLmimrlae+WeDYwSJWg3RGejCxnzx1MCiWgCGrr5kqpMOCDW8KLHP+M3eDMdhh5a
         IYcV+BDrGrtyNirWE7dWT8EzmqevAZZTe03zOZ3aIbt5BYAs87elpAYpClm1u2OldFTc
         Z/Zf8CPB/t8k7YjyOhQmyj+JfYAcm02TK3SfFJST9wyQfxhldOKb4O6tb4jxw0MoBEze
         W9Dh2VpS8/qfzRvbyYEyFubTzKEEWS36an0fdU+x7GK/Wj9zDj9PklzPejJHm+BNOhi1
         lgqdmBtTgQxohxCYdYICLBNp5XNAn+Tw7EGeKUWFrIlJ4BI/uKbuSPCS32AavoXHAQWq
         MgiQ==
X-Gm-Message-State: AO0yUKWaNaSxR/JKNd/5/EwxuM4etmtaPH+lC1UYzWKDf6vfmZ+q4QFr
        4KM85B9zipawE8KHPyiz1fepgmV1HcBlNyHyP2RSuJjys8jTQFpIH/g=
X-Google-Smtp-Source: AK7set+MwFQXgKVqTLbdOfE3WTC6SqYAp6Rxgj82MRbQDTDH/3m6ISbS4ACZu2dBD1p1qYLzl2lVlP0QCPWzHhdfVlA=
X-Received: by 2002:a05:6102:5d9:b0:415:74b4:6067 with SMTP id
 v25-20020a05610205d900b0041574b46067mr633121vsf.6.1677180351265; Thu, 23 Feb
 2023 11:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
 <Y++q/lglE6FJBdjt@google.com> <CAOUHufaK-BHdajDZJKjn_LU-gMkUTKa_9foMB8g-u9DyrVhPwg@mail.gmail.com>
 <Y/ed0XYAPx+7pukA@google.com> <CAOUHufYw9Mc-w1E-Jkqnt869bVJ0AxOB5_grSEMcdMdDODDdCw@mail.gmail.com>
 <Y/evPJg9gvXxO1hs@google.com> <CAOUHufYx8JUT0T11jxuqknHzUHOYm7kLm_JfgP3LmRrFe=E20Q@mail.gmail.com>
 <Y/e006bZOYXIFE/j@google.com> <CAOUHufbhKsWzXZP_VgOTVkKgZhU=LaXJBRKcaAk++d6sLk1ktA@mail.gmail.com>
 <Y/e8wgqFSr8voAto@google.com>
In-Reply-To: <Y/e8wgqFSr8voAto@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 23 Feb 2023 12:25:12 -0700
Message-ID: <CAOUHufbVBVrO=ixNT-5nzQ=kOFDh6CYhdg0VT4c8gDd7rdE6Hg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Feb 23, 2023 at 12:21=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 23, 2023, Yu Zhao wrote:
> > On Thu, Feb 23, 2023 at 11:47=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > > On Thu, Feb 23, 2023 at 11:24=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > >
> > > > > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > > > > On Thu, Feb 23, 2023 at 10:09=E2=80=AFAM Sean Christopherson <s=
eanjc@google.com> wrote:
> > > > > > > > I'll take a look at that series. clear_bit() probably won't=
 cause any
> > > > > > > > practical damage but is technically wrong because, for exam=
ple, it can
> > > > > > > > end up clearing the A-bit in a non-leaf PMD. (cmpxchg will =
just fail
> > > > > > > > in this case, obviously.)
> > > > > > >
> > > > > > > Eh, not really.  By that argument, clearing an A-bit in a hug=
e PTE is also technically
> > > > > > > wrong because the target gfn may or may not have been accesse=
d.
> > > > > >
> > > > > > Sorry, I don't understand. You mean clear_bit() on a huge PTE i=
s
> > > > > > technically wrong? Yes, that's what I mean. (cmpxchg() on a hug=
e PTE
> > > > > > is not.)
> > > > > >
> > > > > > > The only way for
> > > > > > > KVM to clear a A-bit in a non-leaf entry is if the entry _was=
_ a huge PTE, but was
> > > > > > > replaced between the "is leaf" and the clear_bit().
> > > > > >
> > > > > > I think there is a misunderstanding here. Let me be more specif=
ic:
> > > > > > 1. Clearing the A-bit in a non-leaf entry is technically wrong =
because
> > > > > > that's not our intention.
> > > > > > 2. When we try to clear_bit() on a leaf PMD, it can at the same=
 time
> > > > > > become a non-leaf PMD, which causes 1) above, and therefore is
> > > > > > technically wrong.
> > > > > > 3. I don't think 2) could do any real harm, so no practically n=
o problem.
> > > > > > 4. cmpxchg() can avoid 2).
> > > > > >
> > > > > > Does this make sense?
> > > > >
> > > > > I understand what you're saying, but clearing an A-bit on a non-l=
eaf PMD that
> > > > > _just_ got converted from a leaf PMD is "wrong" if and only if th=
e intented
> > > > > behavior is nonsensical.
> > > >
> > > > Sorry, let me rephrase:
> > > > 1. Clearing the A-bit in a non-leaf entry is technically wrong beca=
use
> > > > we didn't make sure there is the A-bit there --  the bit we are
> > > > clearing can be something else. (Yes, we know it's not, but we didn=
't
> > > > define this behavior, e.g., a macro to designate that bit for non-l=
eaf
> > > > entries.
> > >
> > > Heh, by that definition, anything and everything is "technically wron=
g".
> >
> > I really don't see how what I said, in our context,
> >
> >   "Clearing the A-bit in a non-leaf entry is technically wrong because
> > we didn't make sure there is the A-bit there"
> >
> > can infer
> >
> >   "anything and everything is "technically wrong"."
> >
> > And how what I said can be an analogy to
> >
> >   "An Intel CPU might support SVM, even though we know no such CPUs
> > exist, so requiring AMD or Hygon to enable SVM is technically wrong."
> >
> > BTW, here is a bug caused by clearing the A-bit in non-leaf entries in
> > a different scenario:
> > https://lore.kernel.org/linux-mm/20221123064510.16225-1-jgross@suse.com=
/
> >
> > Let's just agree to disagree.
>
> No, because I don't want anyone to leave with the impression that relying=
 on the
> Accessed bit to uniformly exist (or not) at all levels in the TDP MMU is =
somehow
> technically wrong.  The link you posted is about running as a Xen guest, =
and is
> in arch-agnostic code.  That is wildly different than what we are talking=
 about
> here, where the targets are strictly limited to x86-64 TDP, and the exist=
ence of
> the Accessed bit is architecturally defined.

Yes, I see now.

Sorry to say this, but this is all I needed to hear: "the existence of
the Accessed bit is architecturally defined". (I didn't know and see
this is what you meant.)

> In this code, there are exactly two flavors of paging that can be in use,=
 and
> using clear_bit() to clear shadow_accessed_mask is safe for both, full st=
op.
