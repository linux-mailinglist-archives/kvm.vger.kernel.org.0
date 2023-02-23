Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B596A0FB5
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 19:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjBWSsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 13:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBWSsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 13:48:18 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930C7ED
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:47:49 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id j20-20020a170902759400b0019ace17fa33so5640155pll.7
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Ny3Ht+RWz/HwV/rhms1DlUfHO1U87sDcU+U5kFbTW4=;
        b=lNvI/2rgj77Ic7ZvRg0lZ3CNmRucFlSj1+rQwgfvitkvy19Jw0pxzNMx6FDvqCPFgd
         fn7VvVppBKZsXPQhRzKJCkooJ1oyseISzoGS+zDrrC4kbkpz6pSAbvEq8JhS6plQEk9q
         GaU9E7UQAt/0o4s9nTWcnmlOZZQZR7Wez5KV2PxLO0WB0tDVrdFUyd+T6Hyj40TI2nEx
         H7df+dSoERd5mIARNVp4RJW9qzoqsk1dw8VWiF+VkWBRU5oX4U7Ze618a/cVc1xIOtFm
         XTxfpiw3IlfubSNl590W+AZZI8EVvNZsS+T/gWaccOVxmQJj2hJcgPaJQSqH67nvLspK
         7zGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9Ny3Ht+RWz/HwV/rhms1DlUfHO1U87sDcU+U5kFbTW4=;
        b=isDnuTEDWFMMyXpnxfdFvmHxvldBopxUX68dLkttH1JcDI/PSpW3DCVxb8fYG/E98Q
         Sr9zs0uufT4Q31UEAeQtdi07N4eLRytkpqgL624s/zAT4zP8+ukG8PuaJC2tE5JxONL2
         sM3p/RzeXILjq2TY5+1CjzZOe5BL0Y48Wlwqm3PYtLSeIYfU4o3njOTR+2JAvJPMjZyj
         EIxLG/51aCzbKXbMoxWzFmdn5+5mHUWVHhpkc3ZT1sZATIgZp/8oSoNKD/weIH/K8YXw
         6uB1MopSYdyGeK/bv7xvWdnMDqyb4bZuct+GGnVyA4O+nxcLVbb34IAKQLdhs3yW+fc+
         0YSg==
X-Gm-Message-State: AO0yUKXVZLjaqjqmZX89wCH/6c74PGgYMmrdsbSgQmTZGo8YHuhao3L8
        Itus+NLZk5Spf3wIbjZaRhBZWPVebMk=
X-Google-Smtp-Source: AK7set8sDaiXwAv5raafMe6W95s8Ae365ZmaLbZB81kaT6psKhE8P1bs3HjFLIj62NtTvEiT8J5dndICUjg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3282:b0:19a:7e00:da70 with SMTP id
 jh2-20020a170903328200b0019a7e00da70mr1903601plb.12.1677178068660; Thu, 23
 Feb 2023 10:47:48 -0800 (PST)
Date:   Thu, 23 Feb 2023 10:47:47 -0800
In-Reply-To: <CAOUHufYx8JUT0T11jxuqknHzUHOYm7kLm_JfgP3LmRrFe=E20Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
 <Y++q/lglE6FJBdjt@google.com> <CAOUHufaK-BHdajDZJKjn_LU-gMkUTKa_9foMB8g-u9DyrVhPwg@mail.gmail.com>
 <Y/ed0XYAPx+7pukA@google.com> <CAOUHufYw9Mc-w1E-Jkqnt869bVJ0AxOB5_grSEMcdMdDODDdCw@mail.gmail.com>
 <Y/evPJg9gvXxO1hs@google.com> <CAOUHufYx8JUT0T11jxuqknHzUHOYm7kLm_JfgP3LmRrFe=E20Q@mail.gmail.com>
Message-ID: <Y/e006bZOYXIFE/j@google.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 11:24=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > On Thu, Feb 23, 2023 at 10:09=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > > I'll take a look at that series. clear_bit() probably won't cause=
 any
> > > > > practical damage but is technically wrong because, for example, i=
t can
> > > > > end up clearing the A-bit in a non-leaf PMD. (cmpxchg will just f=
ail
> > > > > in this case, obviously.)
> > > >
> > > > Eh, not really.  By that argument, clearing an A-bit in a huge PTE =
is also technically
> > > > wrong because the target gfn may or may not have been accessed.
> > >
> > > Sorry, I don't understand. You mean clear_bit() on a huge PTE is
> > > technically wrong? Yes, that's what I mean. (cmpxchg() on a huge PTE
> > > is not.)
> > >
> > > > The only way for
> > > > KVM to clear a A-bit in a non-leaf entry is if the entry _was_ a hu=
ge PTE, but was
> > > > replaced between the "is leaf" and the clear_bit().
> > >
> > > I think there is a misunderstanding here. Let me be more specific:
> > > 1. Clearing the A-bit in a non-leaf entry is technically wrong becaus=
e
> > > that's not our intention.
> > > 2. When we try to clear_bit() on a leaf PMD, it can at the same time
> > > become a non-leaf PMD, which causes 1) above, and therefore is
> > > technically wrong.
> > > 3. I don't think 2) could do any real harm, so no practically no prob=
lem.
> > > 4. cmpxchg() can avoid 2).
> > >
> > > Does this make sense?
> >
> > I understand what you're saying, but clearing an A-bit on a non-leaf PM=
D that
> > _just_ got converted from a leaf PMD is "wrong" if and only if the inte=
nted
> > behavior is nonsensical.
>=20
> Sorry, let me rephrase:
> 1. Clearing the A-bit in a non-leaf entry is technically wrong because
> we didn't make sure there is the A-bit there --  the bit we are
> clearing can be something else. (Yes, we know it's not, but we didn't
> define this behavior, e.g., a macro to designate that bit for non-leaf
> entries.

Heh, by that definition, anything and everything is "technically wrong".  A=
n Intel
CPU might support SVM, even though we know no such CPUs exist, so requiring=
 AMD or
Hygon to enable SVM is technically wrong.

> Also I didn't check the spec -- does EPT actually support the
> A-bit in non-leaf entries? My guess is that NPT does.)

If A/D bits are enabled, both EPT and 64-bit NPT support the Accessed bit a=
t all
levels irrespective of whether or not the entry maps a huge page.

PAE NPT is a different story, but the TDP MMU is limited to 64-bit kernels,=
 i.e.
requires 64-bit NPT.
