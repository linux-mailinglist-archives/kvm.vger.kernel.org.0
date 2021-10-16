Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA45430373
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 17:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbhJPPmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 11:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbhJPPmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Oct 2021 11:42:17 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83FFC061765
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 08:40:08 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so55277780lfa.9
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 08:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q88y4WBZj28jEM3JEV3sTlyhWcoR55HQTTGRioE6bb8=;
        b=RWvfd1Je9hSmT/qatBra/dYlQTeVwbONHHIbOZCZeDtvCB6/MPdCR8sayRyBNajSpU
         VaErKAyyaJiKiK//fHgCm5ZzDgyJbzmCUwQyFPEje9PuqElBQAPQNfJY5+njP4d/wBn5
         u6/WqZqcZh9bYzwWafKhBCaXdkenewyb8UgEM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q88y4WBZj28jEM3JEV3sTlyhWcoR55HQTTGRioE6bb8=;
        b=CdNu2S3OrM9YlK1ILNzJocoPN2lvQipy4dks/rMmvu3o32p/jhNJHkWeeclzTp3MyY
         osQvgm77nABy5T2y6fapHIIlw8VyfL0irrRSCLW3CdBcD9Fr/gc1xmTKDVG4OT7wiO6K
         iPpyOG73gnOkbSel8B9+ohJ+x7Ms2G0CL0yZa7R4EudA/wC2qgKsa3ILPWVpO8EP82Pn
         DyqHDl2ZwUAkn9y4M8+0aMZuNQhRanLsSpNMUUGAxsnxUuzfmjxTdJTjaIzju+64uL3o
         X4Wa52/i18/hEH3dv7aUwNOyYzh8TMHIvsbcmsf8i22zLkgoo3V7oNAAGZnUSAXoQVsN
         x7WA==
X-Gm-Message-State: AOAM531559WjO5whYqBr9ZEAlhnAM/kFgYcFERTHFqFiQl1D/RExXNpI
        PwpvSJDgfNBm+1RGJKiaINXPOhEuNioLShqm
X-Google-Smtp-Source: ABdhPJyoYGIUxsv88maDl/JWYnFye1g2z2XEEyjTI6ZOt4rJ37DKD8/xxvm3oc2wGLuqHQROX3Z8Tw==
X-Received: by 2002:a05:651c:17a5:: with SMTP id bn37mr19856455ljb.514.1634398807062;
        Sat, 16 Oct 2021 08:40:07 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id h22sm948567lfg.220.2021.10.16.08.40.05
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 08:40:05 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id i24so54434843lfj.13
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 08:40:05 -0700 (PDT)
X-Received: by 2002:a2e:1510:: with SMTP id s16mr19679295ljd.56.1634398804988;
 Sat, 16 Oct 2021 08:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211016064302.165220-1-pbonzini@redhat.com>
In-Reply-To: <20211016064302.165220-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 16 Oct 2021 08:39:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wijGo_yd7GiTMcgR+gv0ESRykwnOn+XHCEvs3xW3x6dCg@mail.gmail.com>
Message-ID: <CAHk-=wijGo_yd7GiTMcgR+gv0ESRykwnOn+XHCEvs3xW3x6dCg@mail.gmail.com>
Subject: Re: [PATCH] mm: allow huge kvmalloc() calls if they're accounted to memcg
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@chromium.org>,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 11:43 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Use memcg accounting as evidence that the crazy large allocations are
> expected---in which case, it is indeed a good idea to have them
> properly accounted---and exempt them from the warning.

This is not sensible.

The big allocation warnings are not about whether we have the memory
or not, or about whether it's accounted or not.

It's about bugs and overflows. Which we've had.

At least GFP_NOWARN would be somewhat sensible - although still wrong.
It should really be about "I've been careful with growing my
allocations", not about whether accounting or similar should be
disabled.

If the allocations really are expected to be that big, and it's
actually valid, just do vmalloc(), which doesn't warn.

                      Linus
