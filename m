Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32D38F5CD
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 00:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhEXWtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 18:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhEXWtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 18:49:45 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A90C061756
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:48:16 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id n3-20020a9d74030000b029035e65d0a0b8so5386726otk.9
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hoy3e/I5xnBrFyarcOwWtri9p33MhFrhxPmYcCRuOP8=;
        b=l7eXdUCUS2uQYjPY2ylTXmFp1AtY/hF+NCpE9LRTeTvR4y49DU7F8tuIyWp5Il0aOk
         KCTpGZ3ObZsoVRQfHnOBDllSo7GM5BuGNuwc4q2BnEt4biUSqmZSXz7XIbZqR2uHe1qg
         kO8LiGVD500dgFPKd5hpVos1GRytTZbVrtbggOiXpPrdC2mMCgzPpiQKoRoiWprEX0Ar
         V70e+hFHS6Kso0b7roWinUO3YK0ZoHk2jgG0LVqgY4cy24Me6XzBF+Ev1pxpzC967A6S
         KPdTMhhbiSxXrxH2lv1kwH2tvmXwhlN1d0LMx0kH/LPVt+5/S8DXrcEQXWP3b6QIOyMO
         FuBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hoy3e/I5xnBrFyarcOwWtri9p33MhFrhxPmYcCRuOP8=;
        b=MCk7y6hkuM+BUH7eVFG4dixEmgIddak7QXIbVqREPz6/KvvPzWEcTbg4GrbrEVZSAq
         NePFprvfEa77r9oGAHZn6S/eYKsOmT2kZ93UjPbrvJZk/abH4fquWKnwLl8zcj+CFfw/
         RALAwD+wXmirKls+bdPq5GJ/DVIiMkj2D+jrQgTcI+ALpAfE+WyxgWWYUSphO80Hif1p
         1HTgzqsdtMvALgczHAhA2B55J5B9CKT70N2hKYi9rXUjpLq4lJtKub/PKUjgIFcUAx/E
         Np+7lmrJRiSkzkaoQaFkQtaiE37k9z5Bqh/pl8nkb39DeFRydgjuVjfziwH5WYM585xf
         gEQQ==
X-Gm-Message-State: AOAM532AP1irrRbJBj2Ildm0cx2X+g4wUZ3Je1wyAT2Q5Hld7vcn3rHP
        hLBUWOVkzm/K9z5LujSuH0nPywQ0QGxgOS6wSadk3w==
X-Google-Smtp-Source: ABdhPJzyaxlFs0OfOxSvAJEnHayZ/UKn/7+Wa6gVxdZ6IJxfA7FfNenwyS6vc7ZW1hZIn2U/pZvQiiG9tIRwZnbXGDA=
X-Received: by 2002:a9d:131:: with SMTP id 46mr20854696otu.241.1621896495340;
 Mon, 24 May 2021 15:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-43-seanjc@google.com>
 <e2974b79-a6e5-81be-2adb-456f114391da@redhat.com> <YKwomNuTEwgf4Xt0@google.com>
In-Reply-To: <YKwomNuTEwgf4Xt0@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 15:48:04 -0700
Message-ID: <CALMp9eSsOw0=n4-rn5B1A_T9nYBB0UkXWQ+oOJNx6ammfJ6Q-A@mail.gmail.com>
Subject: Re: [PATCH 42/43] KVM: VMX: Drop VMWRITEs to zero fields at vCPU RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 3:28 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 24, 2021, Paolo Bonzini wrote:
> > On 24/04/21 02:46, Sean Christopherson wrote:
> > > Don't waste time writing zeros via VMWRITE during vCPU RESET, the VMCS
> > > is zero allocated.
> >
> > Is this guaranteed to be valid, or could the VMCS in principle use some
> > weird encoding? (Like it does for the access rights, even though this does
> > not matter for this patch).
>
> Phooey.  In principle, the CPU can do whatever it wants, e.g. the SDM states that
> software should never write to the data portion of the VMCS under any circumstance.
>
> In practice, I would be flabbergasted if Intel ever ships a CPU that doesn't play
> nice with zero initiazing the VMCS via software writes.  I'd bet dollars to
> donuts that KVM isn't the only software that relies on that behavior.

It's not just Intel. It's any manufacturer of physical or virtual CPUs
that implement VT-x. Non-architected behavior isn't guaranteed.

> That said, I'm not against switching to VMWRITE for everything, but regardless
> of which route we choose, we should commit to one or the other.  I.e. double down
> on memset() and bet that Intel won't break KVM, or replace the memset() in
> alloc_vmcs_cpu() with a sequence that writes all known (possible?) fields.  The
> current approach of zeroing the memory in software but initializing _some_ fields
> is the worst option, e.g. I highly doubt vmcs01 and vmcs02 do VMWRITE(..., 0) on
> the same fields.

The memset should probably be dropped, unless it is there to prevent
information leakage. However, it is not necessary to VMWRITE all known
(or possible) fields--just those that aren't guarded by an enable bit.
