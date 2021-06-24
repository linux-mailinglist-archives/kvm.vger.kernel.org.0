Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485883B3588
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhFXSXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhFXSW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 14:22:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B3BC061574
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:20:40 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j2so11821261lfg.9
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYGnZYIV0vcnFDP+T0eld95swUdTpGs/onjFUg+aRDE=;
        b=Y0f075SWZXYy+JT8BUzOqI5p4BinrJrMkIcSv1VdiRihCJE4kf+wtpRJHgYltsBJbS
         xUhNQ7vCUX9DgqdA8I9Y/lf1a/uZeaE7ZSd7q9ji7Q25GZUl8doqiklHsRUGnVdP4MEb
         0fCUGF80HW1+A+LWS7wV/ZV53ifTBAYfKc7SWUPClSa0GHkrXRW/vKzqkHSzGigGbwzt
         Vv2azfKMJwekCcsQB4Pkezpst6HwoUdlmctlY3+X5SLuHLMaQStM+9OIfJ3dRputHbAo
         cdrNkXnueL51V+oLcJ5rZvgfN7NrDAYLjbotAVPTaeW4m1JMl8VPE/JXw31d48c/PE9X
         Cthg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYGnZYIV0vcnFDP+T0eld95swUdTpGs/onjFUg+aRDE=;
        b=nBpN1fiVmFGZaP6dnErG2RkeQ1iKVmWke+qi+rtPcYde2yZ9d7uqlLUBJJMTwzLq6h
         jgfoL1MR5U6kE0G93clGZNSZQkYNSABNTn9BFrF+WSRIkYB4nO7Ci4yeD6UBhtJ9o0ub
         yTfm3Rq5xalQrJcGniIWR/3uRC5MQJh1P1AZdDMT3SgoKHoy20mCY+ObvsN+BZPliBxw
         XD7t/heO0EA3q3A1OU4kEbvPMKJ7kFCBUJ3cLJCoU5/YGlhzdaliylOlsjriAZFLGXHY
         hn9w0d0Av+xqgqP32oqmK0HvjSB5C4MuDrQfdxeERiEZ+HcuOW4FfGwgrgcb7a/JYmsz
         2Dsw==
X-Gm-Message-State: AOAM532mOrG7A9SIAOMkPsNgJM5i0Veo6Haa3ZmghqPfZ9SE6BkXbD43
        58xRo71koJg8Gc4qvPVjhXK8cdFujaOsNdk/FoNGZw==
X-Google-Smtp-Source: ABdhPJw7cmwlTLh/k/7ceHnDKRZy0blMCUg38R+BslRMmbogivf/LI5UdPilnnBZ1i+92VSk4DuNTh/XClomeAmwTUI=
X-Received: by 2002:a05:6512:310c:: with SMTP id n12mr4817178lfb.122.1624558838272;
 Thu, 24 Jun 2021 11:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210624180625.159495-1-seanjc@google.com> <6146d62f-3c96-1def-a537-1eace63368f3@redhat.com>
In-Reply-To: <6146d62f-3c96-1def-a537-1eace63368f3@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 24 Jun 2021 11:20:27 -0700
Message-ID: <CAKwvOdnVUpsiaHAi6DaV7zc4tbi7t6=BcYv85pDXiHQDQUY_0A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix uninitialized return value bug in
 EXIT_HYPERCALL enabling
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021 at 11:19 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> I have already fixed this locally, though I haven't pushed it to kvm.git
> yet; my tests should finish running in about an hour, and then I'll push
> everything to kvm/next, except for the C bit fixes.

Ah, I was looking at this case in linux-next, and
0dbb11230437895f7cd6fc55da61cef011e997d8 wondering what was going on!

-- 
Thanks,
~Nick Desaulniers
