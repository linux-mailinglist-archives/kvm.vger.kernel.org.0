Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704E83B3592
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhFXSZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbhFXSZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 14:25:19 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47F7C061574
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:22:59 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m2so5424146pgk.7
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TJhHdtnxjj/1lVcprn43QULb+ZY45Gr2FgD9/P84aBY=;
        b=P5/Ko+gJ8MDRmc9LFwnOF/4ehpMbP5HoDQi+FRXbTm/Lvh53L19UftCK5oNvnV1yXO
         IxgKRQDU3AHhwmJ0GIskAlWBYCHjYVLEJcVvDSkjNMjxFLSZ7FQZg+fc1Iz2yJ2pqG5e
         6aYOZevKik5DoDZLLwKqcKse/lOLUDx6I0aAVriwC7zTIL2Qff1Iw5yBa4ucq0WjOb5s
         MUxVjFINmO6M6wQJmfWnSkOq7ojYCgQhPzMuK0FLruX1ckYkZiXzbZPBspd7fAU3fFFF
         xZoVwy/ejcrez0V0Kqw2oYuA8AOADzHEPFzuJIAK234KwgrYh7Ri302hEmdOKNQirI66
         HPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TJhHdtnxjj/1lVcprn43QULb+ZY45Gr2FgD9/P84aBY=;
        b=j8lw0IScsZuM5fURn03UOqIL1Fha1hBfXqoXpNaL50yhFmskJtop7Y5OZGtrIHjXpq
         qulkwcgMQUSE96ntbwgGKPkSh8Q17qyPaGooFcLQlOA8IltEGQBMLiIs8hkTNH81x3jf
         zoDV2vc5PzGj2rlLQfXNn2V8JKYmPw0Eql3W2iwg6wk4Ohxkw0QQPsnRjn/xMeTv41jN
         nXjOGKHcHJgfEkorI4ipQZ2sUK4g1nm4Z1S2IkmUH7abyOMvJvO+M7vExJv5Y3KyqsZ2
         EdtuwL3p7rffBgwPgAMKoAeFUsatf8pttk1pBbg0NHqIgvw+t1UJLG4i6ZKe1n7GV2q0
         K6gw==
X-Gm-Message-State: AOAM5326sKTQPy1ONrHqYuVLZVW9V0WSKmZTxgDNbHCchS8PA8qBMk7N
        jQoBaij9C/0YD2xomVsDRAjMjQ==
X-Google-Smtp-Source: ABdhPJw3vlLyaJMIS/4zHGZVNguvlAujelhx4/lUcgZS6VaIVdkQwxduwh2vHy0A67/SEVxGFWqLpg==
X-Received: by 2002:a05:6a00:be4:b029:300:effd:431f with SMTP id x36-20020a056a000be4b0290300effd431fmr6203290pfu.69.1624558979065;
        Thu, 24 Jun 2021 11:22:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g38sm2948626pgg.63.2021.06.24.11.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:22:58 -0700 (PDT)
Date:   Thu, 24 Jun 2021 18:22:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix uninitialized return value bug in
 EXIT_HYPERCALL enabling
Message-ID: <YNTNfouvheAyCSdK@google.com>
References: <20210624180625.159495-1-seanjc@google.com>
 <6146d62f-3c96-1def-a537-1eace63368f3@redhat.com>
 <CAKwvOdnVUpsiaHAi6DaV7zc4tbi7t6=BcYv85pDXiHQDQUY_0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnVUpsiaHAi6DaV7zc4tbi7t6=BcYv85pDXiHQDQUY_0A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021, Nick Desaulniers wrote:
> On Thu, Jun 24, 2021 at 11:19 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > I have already fixed this locally, though I haven't pushed it to kvm.git
> > yet; my tests should finish running in about an hour, and then I'll push
> > everything to kvm/next, except for the C bit fixes.
> 
> Ah, I was looking at this case in linux-next, and
> 0dbb11230437895f7cd6fc55da61cef011e997d8 wondering what was going on!

Doh, I obviously didn't look too closely at the blame.
