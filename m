Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9623F7ED2
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhHYW7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhHYW7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:59:50 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB1C061757;
        Wed, 25 Aug 2021 15:59:04 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id j15so1260771ila.1;
        Wed, 25 Aug 2021 15:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4r6q20ZzFp9z+4hlR+432aUUYLC+se4vGKW1iv6AjMw=;
        b=MgR9suPRTXbbK1Xk3yV+T3zm9ZnjRmS1G1DvVh/hLru7NwLJzrximcqqnmP8QUza99
         AirZbGJobTSdjynwZAKv9LOO8akpV/5tA3k69nBIsQo6wWtCZUfeqZDxcOdyAgQgX+Sr
         R3emz/pNyTr2Jca3Et8un3VhuLJfzlCxnBMOAkZ1uqWmHclkhrJ7cTK8aKwBW/4w7NgD
         VMlJftfiNOBKWhHDFZj5d2qSo/z/g52UnGlRAJDj1dwKKV2tuvY3dZFbKaYMwhw3FGHr
         OqwGgz8hO2dvLObBvcxV8+hkVHDF1oQ4piajDOPcBcF+U5dWYar5fHTjoHV2gZFK3BYn
         BZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4r6q20ZzFp9z+4hlR+432aUUYLC+se4vGKW1iv6AjMw=;
        b=XE83mg+7uUPvf3wNpR9RbPriSkfknFywcJreHD4IflvR4LlymNPpUgL+wCQg9cCmWs
         l6l/LobMsI7BkvB6KusNhc8/qUnFbEwU7dbJJwSmoRkBSsMjXDDEZPyZSXoqDuJ43izR
         +1rdfCxBiVWI0sp7rLEkuMOKbgqhIFGzi5ExMi10E1WA5UNGp1gZPhGWerAnG5dmEi9z
         NyDfbWFYwPR17rsDg1EGkczCbPWg7cYK6aHvcrpmDslvJcVW9RAsipGzbBNloQbRZesE
         5hd7ab6Hvyi2ySZzbvHBMelwfaqoUy9J6F3K4KKyGgn+gGxqjylsoosYs8vW4nYlYvr6
         +euQ==
X-Gm-Message-State: AOAM532cw8wPx5eDHsoHnHouEXtoBoE6rFUj0VUPXyCC+nKgdLwoUPFX
        U9kxgCiO1HZdWUfEHbqPvgy7AbOpb/fCcm7ghfhkISiw
X-Google-Smtp-Source: ABdhPJxCrb8RRTlwN43XkfgEEYad1OiQO6/sbWXhQ07BKf6OwboeUnUhPS1+Izpp03mzM70UqLPBerTZJ0Iuj0cHZj4=
X-Received: by 2002:a92:c26f:: with SMTP id h15mr489051ild.47.1629932343859;
 Wed, 25 Aug 2021 15:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210824075524.3354-1-jiangshanlai@gmail.com> <20210824075524.3354-8-jiangshanlai@gmail.com>
 <YSZfUqPuhENCDa9z@google.com>
In-Reply-To: <YSZfUqPuhENCDa9z@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 26 Aug 2021 06:58:52 +0800
Message-ID: <CAJhGHyBXFUquvKM0Y84b0KQgDHMVbykkD4Osnw4yFCAciUYDig@mail.gmail.com>
Subject: Re: [PATCH 7/7] KVM: X86: Also prefetch the last range in __direct_pte_prefetch().
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 11:18 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Aug 24, 2021, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> >
> > __direct_pte_prefetch() skips prefetching the last range.
> >
> > The last range are often the whole range after the faulted spte when
> > guest is touching huge-page-mapped(in guest view) memory forwardly
> > which means prefetching them can reduce pagefault.
> >
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e5932af6f11c..ac260e01e9d8 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2847,8 +2847,9 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
> >       i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
> >       spte = sp->spt + i;
> >
> > -     for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
> > -             if (is_shadow_present_pte(*spte) || spte == sptep) {
> > +     for (i = 0; i <= PTE_PREFETCH_NUM; i++, spte++) {
> > +             if (i == PTE_PREFETCH_NUM ||
> > +                 is_shadow_present_pte(*spte) || spte == sptep) {
>
> Heh, I posted a fix just a few days ago.  I prefer having a separate call after
> the loop.  The "<= PTE_PREFETCH_NUM" is subtle, and a check at the ends avoids
> a CMP+Jcc in the loop, though I highly doubt that actually affects performance.
>
> https://lkml.kernel.org/r/20210818235615.2047588-1-seanjc@google.com

Thanks!

>
> >                       if (!start)
> >                               continue;
> >                       if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
> > --
> > 2.19.1.6.gb485710b
> >
