Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C0F6B2E0B
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 21:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCIT76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 14:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjCIT7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 14:59:45 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CAAF9EFE
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 11:59:37 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-536cb25982eso55005157b3.13
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 11:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678391977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vNJ5leP47dzTnf81JmNzO3kZKlUcAdWzEpMj2al3ps=;
        b=ZbV45xN0xfCzaoIr+bcYMr4uFSnv4cw5SiU7yho3+d3MhnSKMhcw0SShbkLT9G6Jgb
         SusYaPPV7w1f3OvaU1gGlWpJ2g0roeBtGAE1MFdHzJ349eETVq+6KPorp2I0Jiy2jELR
         pwtNSRuzqyDfBk7urYzCY2R98fsZ2ksr7Gcy9jx9a2r7xBX2QPOz08nu6owZ/JaNP9X9
         IT7/zTBD3YK8Vtbpw/ScHkEa/vDAaRsRl9SNnBi8eV0VzbzJS91szKvtIrl/7X02QAMX
         kU9nVhHQM2uTWEzDABRQShyXGkijpLsiot+HEiE5UYhQW/Ej6xzfjSQ70URaYs0JhdFz
         dSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3vNJ5leP47dzTnf81JmNzO3kZKlUcAdWzEpMj2al3ps=;
        b=XagDWmAHWoCBr2fuGWJZ/dUOIsZDKA7iq/SXVS95vg58IORj0agAo2Q1NRJ7neyC2S
         GVWWw0p/dKywBQVNbcCIaWlaFHw41zlUkANmh0qVhQIfLhTrIZMcKPvMqWDNjTdGOmPG
         P4kVxng3P2usWpO6RvA8gVOWLy6/YDw4qttJqWd1u50HfCvM8ijiCtnAioGxjBuF2lDr
         ZC1yFDSlQr6Hss2eGnK7qTZlKeEOLM0H+5gD5+6o0WE+8iMFb8iM+i+YLG3Vd8Qx82UF
         x/9NsMnQwNBDDjtd+DCdV990lirTdeS7+6d6ICUXV61e51X4CmHNKk7M2qSnDF96Z0MS
         cLKw==
X-Gm-Message-State: AO0yUKWelIVQuHGn6DMCbmWLTlN8XBajKrzoiU8ekP5Lv+52X4CSUAEj
        JQtbV2XhWGMytr2dWH1AhNIViBMQBbZRk3P3lAt5+Q==
X-Google-Smtp-Source: AK7set90CbrDevVoVNGYf4xSDL+/fwBY+7ly63+oQL8q06DErAyUAwJmz8Rqako/v5+RMtUYbhFU3TJBJQH/Hsk3kyU=
X-Received: by 2002:a81:af5d:0:b0:52a:9eac:92b with SMTP id
 x29-20020a81af5d000000b0052a9eac092bmr15058768ywj.4.1678391976646; Thu, 09
 Mar 2023 11:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-6-vipinsh@google.com>
 <20230309175849.0000565e@gmail.com>
In-Reply-To: <20230309175849.0000565e@gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 9 Mar 2023 11:59:00 -0800
Message-ID: <CAHVum0fhU2PAQEerG5t92R1ropoh1-ML4Yv1CzwGThRtbbvWHg@mail.gmail.com>
Subject: Re: [Patch v4 05/18] KVM: x86/mmu: Add split_shadow_page_cache pages
 to global count of MMU cache pages
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, jmattson@google.com, mizhang@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 9, 2023 at 7:58=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.com> =
wrote:
>
> On Mon,  6 Mar 2023 14:41:14 -0800
> Vipin Sharma <vipinsh@google.com> wrote:
>
> > Add pages in split_shadow_page_cache to the global counter
> > kvm_total_unused_cached_pages. These pages will be freed by MMU shrinke=
r
> > in future commit.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index df8dcb7e5de7..0ebb8a2eaf47 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6149,7 +6149,9 @@ static void mmu_free_vm_memory_caches(struct kvm =
*kvm)
> >  {
> >       kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
> >       kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> > -     kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> > +     mutex_lock(&kvm->slots_lock);
> > +     mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache);
> > +     mutex_unlock(&kvm->slots_lock);
>
> Taking the lock of the calling path in the layer of cache topping/free la=
yer
> seems off.
>
> My vote goes to have a lock for each cache and take the lock of the cache=
 when
> topping/free the cache. It is more self-contained and architecturally nic=
e.
>

Yeah, this can be one way. However, in future patches when I am adding
per NUMA node cache, it will add up a lot of locks for the same code
path before a topup. In split huge page case we know what NUMA node we
need to allocate from so we can fine tune which lock to take but  in
fault path code we don't know what NUMA node the page will be coming
from so we need to topup all of the NUMA caches. Having a single lock
simplifies code a little bit.

I agree with you on being more self-contained. I will wait for others
to also chime in on this and go from there.
