Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CB74A7B27
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 23:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347788AbiBBWf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 17:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiBBWf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 17:35:57 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBDDC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 14:35:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id r59so658711pjg.4
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 14:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOJciJmMfKX59zirYC4fedok2G+mCB9M97xtePEyCxs=;
        b=tJ7DSie/k3qorNqByfiltFBEY6Y41g7j+9qFoVXSAAdu4Z7iqfJTcY36zypmO6fDdd
         hsC+DfkV6B0CDVo67a6pN73X/pqTlU3X1Ha93jOGt+lhyp16jiKeT7gSyv9SeGpH1TMZ
         hM/lshWwBazpNPxZnPh+GSblyPU1R3ck4BanyWlqjEI1v9iEBBxfU6eL4bHjaDEymnQZ
         flqoFHA6uVLEV76Aqw8D1lcQT/EKFRvuTRE5e4Q1LoPtjBJtryRD5pImnyEju/oi+OgL
         tFNdle6DCa+bbFl2JRMi0cioiS/+J3SmpWlOj8TmdkQL/XOR40RadfN4a5VUncodUv3Z
         qkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOJciJmMfKX59zirYC4fedok2G+mCB9M97xtePEyCxs=;
        b=iI1UxjUI9G784abLWLqJDzA6vYj/cy5PPAV3ov8tz7w/VWqbrcajnXr6Gk5X4xI7mO
         41nquxGX8fdvfoVj4JJl3nwpiOkhHr+Hl5pyRRy2b7udVxaatNbOmUxdTp5n9Pnxrh78
         VX22/txG4l+kp6GFw47yqQFhfPpKFyxACKC3/JJy77SEKd6s/ZGWhPXdsa20vi5A2GXc
         TOeXM6nojKdLvX8Ay+NqmDcRvpqeTsMHIQIxe+uvfPIUZes3Iu8mRQqRAXOW8SPnsnta
         Dd+sRromL0BgcCWUBXKOpFnJ/qEXqXtnfqVzIcP15TfVjChhKprwJbs5rE/uyTI31NZe
         u9ZQ==
X-Gm-Message-State: AOAM531lE72SypWALFwDw7mMjjL6QeFaS2IvltrXHuTBPpjfqmotxLqb
        P4oe3clfSNAK/yF7OiwZPsKZBBMWGtO9zawTBGYbYw==
X-Google-Smtp-Source: ABdhPJyGltNN9hECUX69y3THPARvb7JMjzrCnjnInjkdQNfNbbtYS81tdnjKa0L2nBzfQwF7pDIVjj6A9ASKEZzbnfQ=
X-Received: by 2002:a17:90b:146:: with SMTP id em6mr10579169pjb.214.1643841356497;
 Wed, 02 Feb 2022 14:35:56 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
In-Reply-To: <20220202144308.GB20638@worktop.programming.kicks-ass.net>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Feb 2022 14:35:45 -0800
Message-ID: <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 6:43 AM Peter Zijlstra <peterz@infradead.org> wrote:

> Urgh... hate on kvm being a module again. We really need something like
> EXPORT_SYMBOL_KVM() or something.

Perhaps we should reconsider the current approach of treating the
guest as a client of the host perf subsystem via kvm as a proxy. There
are several drawbacks to the current approach:
1) If the guest actually sets the counter mask (and invert counter
mask) or edge detect in the event selector, we ignore it, because we
have no way of requesting that from perf.
2) If a system-wide pinned counter preempts one of kvm's thread-pinned
counters, we have no way of letting the guest know, because the
architectural specification doesn't allow counters to be suspended.
3) TDX is going to pull the rug out from under us anyway. When the TDX
module usurps control of the PMU, any active host counters are going
to stop counting. We are going to need a way of telling the host perf
subsystem what's happening, or other host perf clients are going to
get bogus data.

Given what's coming with TDX, I wonder if we should just bite the
bullet and cede the PMU to the guest while it's running, even for
non-TDX guests. That would solve (1) and (2) as well.
