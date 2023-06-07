Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A3572511F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbjFGA22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbjFGA21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:28:27 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8421993
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:28:26 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f6e194e7bso5949881a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686097705; x=1688689705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E64Iu3RjeQxnJOawkwVtMlHo7Qw2zMqB7rD6Gt59u6U=;
        b=hbByc+eBc10oz1R0ZBfrJhka/Zfxs+Kmawl1wepq8hHgYMeC2Ja4xOeongIU/IHFWk
         f4ZohHN9WizzgwghfY1CGQaU92e6tuTecCqGoy82F8EONiO3dqXVMrBH+6Y4cEcQFyRg
         ydA7hvMvUMZqJy9nXwV8aZqLu64Njwyrt9SLZzMrzf6XO9XQLQvMX6WL3cjld5DivSpg
         enGLPY5vulMF5Salfq08OWSpsUIzVfzIHZzDXvuYvPqn43S7vjSFORzSd6DQpC9saemd
         tJ0U9WBZnlYWqZaLu35VNlT+6rmrfyj8NVeqClfGfYCswsoJyb+3U6ByDH2Gu3mx2AUm
         8uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686097705; x=1688689705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E64Iu3RjeQxnJOawkwVtMlHo7Qw2zMqB7rD6Gt59u6U=;
        b=gCY1w/djYoXDvRhkg4imxOCddLJVjBWSFuVWWzY0G2FhiyGQ3/pUVY759MFwy9Jr2q
         s8GOGxY1o6VnOEoH0fZLh8VhrzuAFmrAJcnyT0T72+m88bCzpmTxnebjM0MzzgZGks54
         XIItIZPaTdAgaWky9aJ5c5x0qd7IRwTfEjfnmrDUNXmBYIKSGNAX4FewhVFuXwvaBfZg
         +JJ3JPtDDFEUoZAf1HW7mPnO03CPekK7NJBp9VyFnK9Q8n1QOleyL7mHjzAw/Y35nLHd
         BX0rAaoH0iQDI8JeNESrDnm/4uzxerBMU8FPTCfePumHkKxLkb0RDz9mt69lyGLZ6Fla
         RUYg==
X-Gm-Message-State: AC+VfDzHG15dq9TMsItOQAw9uA2x9Dks9vi172XCnJ9mKXQr91/SmBxG
        0MNhNNZMbwL/FXXiDXNxylY3wYLGlsA=
X-Google-Smtp-Source: ACHHUZ4H1GMMLOdzM0nl0MSpgdQMuxyFumoN3C9RMkvxCyDzeiO0M9Cv9zLue4cWxoMIT3NIRj9RTl0QHnE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:400d:0:b0:53f:32cf:bcd1 with SMTP id
 f13-20020a65400d000000b0053f32cfbcd1mr822116pgp.5.1686097705646; Tue, 06 Jun
 2023 17:28:25 -0700 (PDT)
Date:   Tue, 6 Jun 2023 17:28:24 -0700
In-Reply-To: <CAL715WJ1rHS9ORR2ttyAw+idqbaLnOhLveUhW8f4tB9o+ZsuiQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
 <ZH4ofuj0qvKNO9Bz@google.com> <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
 <ZH+8GafaNLYPvTJI@google.com> <CAL715WJ1rHS9ORR2ttyAw+idqbaLnOhLveUhW8f4tB9o+ZsuiQ@mail.gmail.com>
Message-ID: <ZH/PKMmWWgJQdcJQ@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023, Mingwei Zhang wrote:
> > > Hmm. I agree with both points above, but below, the change seems too
> > > heavyweight. smp_wb() is a mfence(), i.e., serializing all
> > > loads/stores before the instruction. Doing that for every shadow page
> > > creation and destruction seems a lot.
> >
> > No, the smp_*b() variants are just compiler barriers on x86.
> 
> hmm, it is a "lock addl" now for smp_mb(). Check this: 450cbdd0125c
> ("locking/x86: Use LOCK ADD for smp_mb() instead of MFENCE")
> 
> So this means smp_mb() is not a free lunch and we need to be a little
> bit careful.

Oh, those sneaky macros.  x86 #defines __smp_mb(), not the outer helper.  I'll
take a closer look before posting to see if there's a way to avoid the runtime
barrier.
