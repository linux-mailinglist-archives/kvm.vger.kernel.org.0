Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3628BFC5
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388023AbgJLScK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387669AbgJLScK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:32:10 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C348C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:32:10 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id q21so16682210ota.8
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4UkI0qIYnCAUExKm81x3mFmF3y9KZQilf7OeOZukefU=;
        b=Jots4BWZK0DPajF8W7CbBAF7V+M8CgHv61wTWI45j7RqHlTeOnXqVca2wviDakPbql
         +ycPTWbphJoS/962TCmR5ORuCAoveAf53sEhznz14FtDZQFw8Kka827sdTkHI/uUElSv
         C6Sg3j2z1LkOUp0aKizUr3+ezAz3HtwFSUXDEyjDutC4GXl2pAgjdn8KIisfyOx2Ea3b
         H/iJdZgTwlvEUvuFb8zL59n9b4y0aeBwgDwG+3u1MqHwk9qN8rwmnuvCFxdXYJyribXV
         95ThlmkI6bmlKyZt8p+dVRMmL2i/Pock0WTTwognBMTkT+k1gsJ3vUAJgBYtRGT8yu7N
         aF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4UkI0qIYnCAUExKm81x3mFmF3y9KZQilf7OeOZukefU=;
        b=Lq0YY+3eRnhFFJnUZrLK/+ojVITYNj+ertE6xRiXEoWpcsq3FpudGmdKIc0APM+Rty
         V1REcJmPqseGICzgc7wg7W54GlePerL/EanduqbPhq/6I41nencu7KMk+sQ/racIBz1A
         4Cbx4fO3YzwtOCBTTT0YP3lB0zPaIZJcd+gAg4+hZ/Wl6aw8lJsz7HKfnXNcsZ38D5B/
         RRragzuB/sCk3s31U7dd+dK22uOCqAsKMT1NRN2H78ZG3DzbNR//QkL+/infEM0ZOalK
         Hu3OPCEIcQYHMGBytMvZpSeMrRKZcuJZga6WVTJ2gohjvvmHLzP8xgRD8WnDMw1+igJc
         5Iig==
X-Gm-Message-State: AOAM532p/gikYPlgEyDV0Bnm2KUbXDS3d//a5hU1u+iDz4YgPIbZ9AOU
        vavObY3wZJtIA1ezQQYWqTz9OU2womVh4c7PhfKBmJiuW4M=
X-Google-Smtp-Source: ABdhPJy482rKllXJSMXDDWMR1cpdn/ZdO/OytXB8FTZdUGY4heN3KHRyK7TDADFBsEJzdZrhtGvvO2QYLngzll+7flw=
X-Received: by 2002:a05:6830:1301:: with SMTP id p1mr19207254otq.241.1602527529249;
 Mon, 12 Oct 2020 11:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200818002537.207910-1-pshier@google.com> <4A2666E9-2C3F-4216-9944-70AC3413C09B@gmail.com>
 <7C2513EE-5754-4F42-9700-7FE43C6A0805@gmail.com> <CALMp9eQBgJwLLk-9in=v1wwrj2_p5T3aLfaj79Y6Yzh+CEE1SA@mail.gmail.com>
 <EBDAAC1E-1B27-43D6-AAAA-B8A7003CD45E@gmail.com>
In-Reply-To: <EBDAAC1E-1B27-43D6-AAAA-B8A7003CD45E@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Oct 2020 11:31:57 -0700
Message-ID: <CALMp9eSnbG-7ymgrOLiKB2ogX22QtnzVqFk+y74WFq2tvdXJ5g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Add test for MTF on a guest
 MOV-to-CR0 that enables PAE
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Shier <pshier@google.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 11:23 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Oct 12, 2020, at 11:16 AM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Sat, Oct 10, 2020 at 2:52 AM Nadav Amit <nadav.amit@gmail.com> wrote:
> >
> >> I guess that the test makes an assumption that there are no addresses
> >> greater than 4GB. When I reduce the size of the memory, the test passes.
> >
> > Yes; the identity-mapped page used for real-address mode has to be
> > less than 4Gb.
> >
> > I think this can be fixed with an entry in unittests.cfg that specifies -m 2048.
>
> I prefer to skip the test if the conditions do not allow to run it, as I do
> not use unittests.cfg.
>
> I will send a patch later.

It doesn't have to be skipped. We just need a variant of alloc_page()
that will dole out a page with a 32-bit address.
