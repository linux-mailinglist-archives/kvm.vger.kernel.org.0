Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA29432627
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhJRSRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhJRSRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 14:17:39 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836F1C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:15:27 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u21so1581722lff.8
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ERwIJtrAxSKFmtkdla8UNA3CjrOGMlzFelchQeuneqM=;
        b=PvFPrrHqhzLoQwugLC06OkLKAETokHq2kcRDQ2GRnjTqhztE5NwcSpFrcIF1QGvRzN
         QojzqkjCeMTtNbkax3976xxSB8xyWgHS1GjolB/a485xoNKOFy1jFgjouwfTYFpKqT2N
         56iFCafGyQxy4KrnM4lYvzC1ppazomKTmc7pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERwIJtrAxSKFmtkdla8UNA3CjrOGMlzFelchQeuneqM=;
        b=TZ0hOk/Hvj9q4a0gzlId7buQjg+t48AGzYY0GDZgTFkhXd1Sg0tK7NmDupfTa4IQRq
         Q8xCtvBwcudy4Hex+iCyq8KW90gkFiDoTfXYin1Dw9Qz+fObSewymVoF9lE2N+df5sVe
         6N4W3Rmjcs9GO2h9kFmjT3U1srr0pQqypT0HAcA74IFGMUU4J8J+zdQyDV69l1753VKq
         11xjJbpkn4PfJLCHlT5owFjhS6/V4I1/8XUd4olzrCfvzFMzTL602FxW5yXGIAVUve7/
         4Aw/hnLwdi2D42dDwV9NMi1vKDeXASCzYuwyJ5ZDByWodiAorc3yNzCdxS9ccHfk0dyq
         ayZg==
X-Gm-Message-State: AOAM531SGJbc36NMAcgZ698JhocxAjHIcvE+SGVUGSgqNc3qKSHYr4nx
        BF2ZObfdqB2fjD6zqN7P8pZ7DgZpQo/oz2H5
X-Google-Smtp-Source: ABdhPJx0ZGZHSpPVekfuG5BNvL6SxaaOHarKT2B+S7VHej/0s96YwC/JtDt/45P9Op0MEe7j8Op2AA==
X-Received: by 2002:a05:6512:3f8b:: with SMTP id x11mr1251814lfa.536.1634580925609;
        Mon, 18 Oct 2021 11:15:25 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id h4sm1460924lft.184.2021.10.18.11.15.22
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:15:23 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id o26so1360614ljj.2
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:15:22 -0700 (PDT)
X-Received: by 2002:a2e:a407:: with SMTP id p7mr1465932ljn.68.1634580921681;
 Mon, 18 Oct 2021 11:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211018174137.579907-1-pbonzini@redhat.com> <CAHk-=wg0+bWDKfApDHVR70hsaRA_7bEZfG1XtN2DxZGo+np9Ug@mail.gmail.com>
 <daba6b06-66cb-6564-b7b0-26cb994a07cd@redhat.com>
In-Reply-To: <daba6b06-66cb-6564-b7b0-26cb994a07cd@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Oct 2021 08:15:05 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgScNWP7Ohh5eEKgcs3NLp9GZOoQ6Z-Kz0aByRtHoJSrw@mail.gmail.com>
Message-ID: <CAHk-=wgScNWP7Ohh5eEKgcs3NLp9GZOoQ6Z-Kz0aByRtHoJSrw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for Linux 5.15-rc7
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 8:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The code is not wrong, there is a comment explaining it:
>
>          * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
>          * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
>          * (this is extremely unlikely to be short-circuited as true).

That makes very little sense.

It seems to be avoiding a 'jcc' and replace it with a 'setcc' and an
'or'. Which is likely both bigger and slower.

If the jcc were unpredictable, maybe that would be one thing. But at
least from a quick look, that doesn't even seem likely

 The other use of that function has a "WARN_ONCE()" on it, so
presumably it normally doesn't ever trigger either of the boolean
conditions.

Very strange code.

                    Linus
