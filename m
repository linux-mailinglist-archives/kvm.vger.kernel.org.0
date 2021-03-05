Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700D632F4B3
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 21:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhCEUnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 15:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhCEUnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 15:43:19 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E83C06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 12:43:19 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a188so3001507pfb.4
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 12:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KySvOFZxt1c0YZjiiuNCyl7b6HcxJLjY37j04g7aO08=;
        b=v01vynvWKOKYGLu1bYQ0lAk1nsOmhbm1OSnXePtIutOsSy6HrVj34Y4JSn87NiIV42
         dvi0Yb+BPfBlpUYyhJqxEbEYLAVvXTaueiY7R3SoCMLuDiEfHUJgVXEIh8QDGhiKO2Bn
         UBA81bDq4AR/FMm0VkQdOgDgQ8Tko1G/x2Hx3BnrxQif2Le02xGPaWyjHmUmRv85+LZI
         1bbiA/QreROxid8rT4tJpsm8atCtZgIuHU2Of7zWAPh1QNIbsfc4ZUN0Zuc1405Ompiv
         TRxBGrETyO+4NadWKk2eRvsNd7hNftC9FHWy71LnmGbH7oS57EBLXv91cLwIuFGxBUXO
         OFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KySvOFZxt1c0YZjiiuNCyl7b6HcxJLjY37j04g7aO08=;
        b=WgkHZsLjtXaBzrxredvVcUEp30hgZA7Y6b3oWUN4s/rvHI9waMvMvRELZQe8JzudJB
         fS5HQN0FiAggue4pG3Wh83hwwFvRTkksVqPG4m2GKgIc0T+v/c8PEMuCrcvRc35e8InN
         7cgRYvYrljPV6dm2pmnB1TTh13NXjYIGKIaMjUT0dxNCFuDWnO44Ee/tKRuS5AmTY4F0
         2XiQ3aLXoQKBrCXF7FHQb819g0Lb5Te4HG3Xk/57/6wW5czwFk/s75PlId4qmPjWSi9U
         yIM1uT6Lith10+MF+Y0HElDs39TvjYLUsak3ju54G/A0/d0RWgGqxR87EDVjfqiRFjn5
         bj8A==
X-Gm-Message-State: AOAM533LAgvRf+zJaQZrmBRj/Gs2SbHX9NnNcJ7DBlI/8jRr5mm4hB3M
        Cra1jMNL660eE2yBHpguN4p3pJtK3CJYTmParJ74yA==
X-Google-Smtp-Source: ABdhPJzBngssd2CcwsYrGrHXFib6t8QarZRWlst7uENKB3mpnYGMKqkdEJNJqM7S5X/KNSxpEZrpw+nr95LOci9yQkw=
X-Received: by 2002:a05:6a00:16c7:b029:1b6:68a6:985a with SMTP id
 l7-20020a056a0016c7b02901b668a6985amr10597366pfc.44.1614976998900; Fri, 05
 Mar 2021 12:43:18 -0800 (PST)
MIME-Version: 1.0
References: <20210224085915.28751-1-natet@google.com> <20210305140409.GA2116@ashkalra_ubuntu_server>
 <ba4121bd-cad7-49f3-d53c-d1b03d95ca39@redhat.com>
In-Reply-To: <ba4121bd-cad7-49f3-d53c-d1b03d95ca39@redhat.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Fri, 5 Mar 2021 12:43:07 -0800
Message-ID: <CAKiEG5oicgF=wuYda6RhH_Memc_gnoYSeiimVthkuxckKWN9_w@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 5, 2021 at 7:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/03/21 15:04, Ashish Kalra wrote:
> >> +    /* Mirrors of mirrors should work, but let's not get silly */
> >> +    if (is_mirroring_enc_context(kvm)) {
> >> +            ret = -ENOTTY;
> >> +            goto failed;
> >> +    }
> > How will A->B->C->... type of live migration work if mirrors of
> > mirrors are not supported ?
>
> Each host would only run one main VM and one mirror, wouldn't it?

That's correct. You could create a second mirror vm of the original
(A->B, A->C) if you needed two in-guest workers, but I don't see a use
for a chain. If anyone can see one I can write it that way, but in the interest
of keeping it simple I've blocked it. Originally I'd built it with
that functionality,
but allowing a chain like that smells like recursion and from what I
understand we don't like recursion in the kernel. There's also the fear as
steve mentioned that we could blow the callstack with a long chain of
destroys starting from the leaf.
Ideally we give userspace one less gun to shoot itself in the foot with.
