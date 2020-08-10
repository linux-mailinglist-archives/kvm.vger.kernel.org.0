Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D492A241234
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 23:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHJVSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 17:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbgHJVSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 17:18:24 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B51AC061756
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 14:18:24 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l23so7453555edv.11
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 14:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rlb/NKygli/k191hVtWgB5DzFndmgn6N88FhGxbSqLI=;
        b=rWPCdS6FfaqyxMtbIGbAkzq/kR9XpiHcG92WxNbblZG8oOfaI/63b7onTTYU9Lls8T
         nq5ZsUo95uRXl9lthUxt6feSt7ONWsvNN3P8UTUVbMg7qL1oq65Xng9M5pjjGt3vtOcT
         XAeAOdZjx8w6MGtX60755sG7f+Xa0s7G0DD0bhsUZ4MluafGcezBLJbroNwXdWf7qbtu
         IJpswNTNAdVBKpnCsY2fD4b/2ktPX5SjYnRwUuOmUGLdB5Ii5rfgfvkankqaPDl8pGG5
         IogTY0tU3kSOjjQN/+aaglum9WaNfj5qdki6HuRvl4qV9bYbVPBhqdXMwAFKwtyfpuWc
         7Zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rlb/NKygli/k191hVtWgB5DzFndmgn6N88FhGxbSqLI=;
        b=uKJWMElAU2f0D3eXn1lpMZQnvgVO6jbDCQXuJ1UQp9YBkBevzjyuay/UBTyBNAnlhz
         BrhoFNmcE6zXGlTj69KhhmIa83Ulku/h1CfYtTrojz/BjaX7T+NpHTNryfCIsEKctQkp
         4RUpy0YUbMR8uTJZYIBko4uWZlV6VuQie3V3EtlX4YalJPiXPQBq08Z7sTi/XiapsOcJ
         PD0bOZU11x/x5uN/oNtS8hwoGKXjpjJ7tIci9m11XyeVj8EvDt6iGUgvYq51J8mFYCRU
         QQ4f58tfBS8jCGkbAF026SG8FGJ7XilfHMgHhl+IQixGvOTmLofn3AxtqZ7roq1q+/t7
         3liw==
X-Gm-Message-State: AOAM532vHwmHAua4hV1ne2DvQfKLe8GLpiIZA5PaYQgQdk1HQ0bZ7APV
        CeF8XJMDJcrNepB6/7WtuEOo2yJpLC0y2iTvNfiPcA==
X-Google-Smtp-Source: ABdhPJx2Xn+SzJQGemAEMm3RlA6UHhvqP6hmjM+f6BD0754rXF9fkPyZYvMC4vR+DsRC+k2JJpETztei+fvo665xB1I=
X-Received: by 2002:a05:6402:403:: with SMTP id q3mr22113525edv.12.1597094302582;
 Mon, 10 Aug 2020 14:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
 <20200804042043.3592620-7-aaronlewis@google.com> <db97d3bc-801e-2adc-9351-0f536561c279@amazon.com>
 <CALMp9eScA9SBJfYcnnDUH9mujvBsYmhyD5nC8XhorrxmBBv03g@mail.gmail.com>
In-Reply-To: <CALMp9eScA9SBJfYcnnDUH9mujvBsYmhyD5nC8XhorrxmBBv03g@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 10 Aug 2020 14:18:11 -0700
Message-ID: <CAAAPnDGp4pYwF7amKuuUYpb1ssAWCoTJJG1oidY71UVpkzR-Tw@mail.gmail.com>
Subject: Re: [PATCH 6/6] selftests: kvm: Add test to exercise userspace MSR list
To:     Jim Mattson <jmattson@google.com>
Cc:     Alexander Graf <graf@amazon.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I released v2 of this series to incorporate Alex's changes with the
generic instruction emulator into it.  I'll incorporate this feedback
into v3.

On Mon, Aug 10, 2020 at 10:24 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Aug 7, 2020 at 4:28 PM Alexander Graf <graf@amazon.com> wrote:
> >
> >
> >
> > On 04.08.20 06:20, Aaron Lewis wrote:
>
> > > +       __asm__ __volatile__("rdmsr_start: rdmsr; rdmsr_end:" :
> > > +                       "=a"(a), "=d"(d) : "c"(msr) : "memory");
> >
> > I personally would find
> >
> > asm volatile("rdmsr_start:");
> > r = rdmsr(msr);
> > asm volatile("rdmsr_end:");
> >
> > more readable. Same for wrmsr.
>
> I don't think the suggested approach is guaranteed to work, because "r
> = rdmsr(msr)" isn't always going to be a single instruction. The
> compiler may do some register shuffling before and/or after the rdmsr
> instruction itself, and I believe Aaron wants the labels immediately
> before and after the rdmsr instruction.
