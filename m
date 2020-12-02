Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE682CC0E4
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 16:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgLBPcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 10:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730453AbgLBPcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 10:32:31 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DFDC0613CF
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 07:31:45 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y22so4418839edv.1
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 07:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vUOCXRBRvj8QQUt4Req06cqogkz9BReRzksxQEI70Y=;
        b=tovjkBvnDxekGDoe7x4JD8avePhwR3jcsnoor2kAfF0rH2ADPIZCdYC7z6Ww1ta2nf
         EyAgCbEvjA7KXY8N8PAeFqhZmOaLSMAlQzHfN4jVHItue1FskvJHL/8kBJ/UDozgCqlo
         kzi6JIgKIkpox+Cxdy6UU7D9qwg9UTiTIi52bA6lV5m4seVsXJZXZZrL9cAI8zmac/LD
         fYtsBVh0e1Mnnv2RGBmCJuHAGtpZIpS/z6oT95NhtGuqyxErZC7atuyWW63WyJ7g+jnc
         +f5lX+7yRjsp0BMnu8r+YS7t1jE3NLrGQkKByJ7x2Zva78beMQS7JijOjteoUIsWRyMh
         oeXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vUOCXRBRvj8QQUt4Req06cqogkz9BReRzksxQEI70Y=;
        b=uH/1ao3IBgoFSTQiFcQKboNE+DMxhJuBMyGl/83qs2uMoyksZiLzUC6cleq0ITEmsO
         tosXMGVWgA2VjAr8/3qRJTWptcLt4EMMBvm0UOvDKh3rYDaf9IM2ulaO36zE+J1Rg+56
         cb21NaJW8LKgvwYWBoumQhesFdsIDekedEOOOQfAgcR8k1HxXmhFKmPlwaI79VTN/Ix1
         AmYxtpO6TAmZ2GtGNakhfh8BA24GHog5u4g9Rnr6qAb1oyUNlLP/FuV6++nmQdqNCHqg
         56SK+uCR0IRONOqJc84xU5Ue+PybFjeE+2LvC/5SEx0eez6hbcAFLYqyByT2+gjX+Fjo
         k8rg==
X-Gm-Message-State: AOAM533l6pvJLGYHCwF8uB85d9SJNkq3TdovnDNvrS9+r/PHY7M/gR/e
        4jR/F0cfHKV7SJMfr018TtHYGENupereEn7BgpaJ5w==
X-Google-Smtp-Source: ABdhPJx3neUfpRefI6JGP2+aBX9TjOswNaPzT6+S+v6Q4I+uqyB9q0Ufq1eAXTkwEvun2HRgFQBf2dSkPxmiC/m2C+o=
X-Received: by 2002:aa7:dd17:: with SMTP id i23mr457883edv.14.1606923103911;
 Wed, 02 Dec 2020 07:31:43 -0800 (PST)
MIME-Version: 1.0
References: <20201012194716.3950330-1-aaronlewis@google.com>
 <20201012194716.3950330-5-aaronlewis@google.com> <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
 <1e7c370b-1904-4b54-db8a-c9d475bb4bf5@redhat.com>
In-Reply-To: <1e7c370b-1904-4b54-db8a-c9d475bb4bf5@redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 2 Dec 2020 07:31:32 -0800
Message-ID: <CAAAPnDFpfiYRs7GZ0o0wSXdzD2AFxLy=XOhRyhcEaQKmaYJzGw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] selftests: kvm: Test MSR exiting to userspace
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 9, 2020 at 9:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/11/20 17:58, Aaron Lewis wrote:
> >> Signed-off-by: Aaron Lewis<aaronlewis@google.com>
> >> Reviewed-by: Alexander Graf<graf@amazon.com>
> >> ---
> >>   tools/testing/selftests/kvm/.gitignore        |   1 +
> >>   tools/testing/selftests/kvm/Makefile          |   1 +
> >>   tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +
> >>   .../kvm/x86_64/userspace_msr_exit_test.c      | 560 ++++++++++++++++++
> >>   4 files changed, 564 insertions(+)
> >>   create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> >>
> > It looks like the rest of this patchset has been accepted upstream.
> > Is this one okay to be taken too?
> >
>
> I needed more time to understand the overlap between the tests, but yes.
>
> Paolo
>

Pinging this thread.

Just wanted to check if this will be upstreamed soon or if there are
any questions about it.
