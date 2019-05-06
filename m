Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903CE14B9F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfEFOPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 10:15:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44786 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEFOPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 10:15:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id d3so2431112plj.11
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 07:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OW9r981uG4q4mCEE3eviMpvcgNrP8ztSBy/V22TuEyU=;
        b=RwIwMiF88+Wz2lyiiiRFLD0DtzmtPhSYctT7DECXSVGGsMCqqEywraKb1VVIDK0D+6
         e05K/iAAJcE9yRHQNbEvq9ePWUxNo3jMQ16tSsOGtmWiuiuGjYTIKZn3RWyGJN1L7rxH
         JWCib8njn+v5Gl74GjdEjnavoToExJWkPKuLN2usGUeeVQU1cj6afqv3AP+Szx9d1YbR
         /iYb1mW4rEJXqf/1doCy1zenFphH/aiHoOYrBoxPgEK3EUfKzOGpHL63KMDfpfhEfnGD
         SAWo20WeW5Qs/kAhFHEaSxMs4rZb4+Da05bz1k2JR3ScMW8GRukA/aJ+BvUhLbhKhimD
         bg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OW9r981uG4q4mCEE3eviMpvcgNrP8ztSBy/V22TuEyU=;
        b=lhOPv87qvpKB05wshrLnMnL3vlG7iF7LHOBGRkIXSZhlTZBWRLjqSrBp0V/hTIG2uD
         eQx3SXOFOm648Q+VK0w5Xub276RyQniQWjePVkCYPYurN3WxZY8ziYi/dmb3zbiOfWsf
         H8YEH5+IkyHTl2/96EjQy3C7lbJLMzfpL57eg4Y5503emiyAb7IbBTl4FFpH5TFZQL7N
         qU4FUq6l3+NP8dmErcJtj1NIAoc75jHOu1wjlGGAgwKJNfJaKPwZo7JOmL6cwNSFG43Y
         ZnUWDSLC3VWTl03I0rL+2PP1uzUg+Aq3g5Lu0BKaLCNVRCTLZj6OWaSGIReSM9pQY7r+
         n5ew==
X-Gm-Message-State: APjAAAWkJ2nZIDRY+XG3APHZA1g/0DQ5XAVVK66y7uecN9h2esyyO2oc
        SsM1KfSqs9Prcn8fDHDeXT50O1fXSn1fuM9XFwY8Uw==
X-Google-Smtp-Source: APXvYqyWDp8mHq4mu+m9PaBcR4hr0UfLsUgs2S/OxvEKrdiWi6A7iqRf42KWhYp4nRTNFO6VlU1AYWwzebl0ku93GlI=
X-Received: by 2002:a17:902:7783:: with SMTP id o3mr32385898pll.159.1557152131315;
 Mon, 06 May 2019 07:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1556630205.git.andreyknvl@google.com> <7d3b28689d47c0fa1b80628f248dbf78548da25f.1556630205.git.andreyknvl@google.com>
 <20190503165646.GK55449@arrakis.emea.arm.com>
In-Reply-To: <20190503165646.GK55449@arrakis.emea.arm.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 6 May 2019 16:15:20 +0200
Message-ID: <CAAeHK+yya4OR7GfSJPc59+trq3fS9Qh_1WK2hB1aoHdR0C_t8Q@mail.gmail.com>
Subject: Re: [PATCH v14 10/17] fs, arm64: untag user pointers in fs/userfaultfd.c
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>, Kuehling@google.com,
        Felix <Felix.Kuehling@amd.com>, Deucher@google.com,
        Alexander <Alexander.Deucher@amd.com>, Koenig@google.com,
        Christian <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Chintan Pandya <cpandya@codeaurora.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 3, 2019 at 6:56 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Apr 30, 2019 at 03:25:06PM +0200, Andrey Konovalov wrote:
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > userfaultfd_register() and userfaultfd_unregister() use provided user
> > pointers for vma lookups, which can only by done with untagged pointers.
> >
> > Untag user pointers in these functions.
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >  fs/userfaultfd.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index f5de1e726356..fdee0db0e847 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -1325,6 +1325,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> >               goto out;
> >       }
> >
> > +     uffdio_register.range.start =
> > +             untagged_addr(uffdio_register.range.start);
> > +
> >       ret = validate_range(mm, uffdio_register.range.start,
> >                            uffdio_register.range.len);
> >       if (ret)
> > @@ -1514,6 +1517,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> >       if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
> >               goto out;
> >
> > +     uffdio_unregister.start = untagged_addr(uffdio_unregister.start);
> > +
> >       ret = validate_range(mm, uffdio_unregister.start,
> >                            uffdio_unregister.len);
> >       if (ret)
>
> Wouldn't it be easier to do this in validate_range()? There are a few
> more calls in this file, though I didn't check whether a tagged address
> would cause issues.

Yes, I think it makes more sense, will do in v15, thanks!

>
> --
> Catalin
