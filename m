Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61355913F2
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239131AbiHLQf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbiHLQfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:35:55 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5E81F603
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:35:53 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w3so2002249edc.2
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=PhJG6bBOCkvyTjU2NcpvtIl0Bn94VJLHdY/CNTDx92c=;
        b=A0zopqIFjMTW4LHzcxx7Kgim0jgeE1PHu1MzJPGzrmEGVqIyHVf4olgYQvI/zgqkqg
         NkeEGgSheDwg61Jnhu1y5RwwnHybQJGN/2AMmcJbtEpHsNsf0peok5GdgvQoBhxaPNUs
         Bmlag/RZqX1KjE9J/4TB+lbCnIfJ/X1osMBGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=PhJG6bBOCkvyTjU2NcpvtIl0Bn94VJLHdY/CNTDx92c=;
        b=q4xKFFPqLX3urXWMJ8YNBKwCOiIPfjWQMwChLFXl93853CCzq+IHy4f+L3eGL4YrTQ
         sNDn2/mzxMo3cqNffrgYaTZKdRH5hNk1vWyJkTdK56pyFMKk1CY5vaLzPIhRwcj7GXzQ
         AW7HLtEw4eR86ovllfpswsV/cAzgkHyfiTnu4gXc4zW1WVjE9Sqe98NYCDbxTJyg/3gZ
         7k6KNYdl6hd4isfFXg3xKzonL5J1yFLLhqrbF4ZCj8ovfuNj4Qox+zKJ8LDZczleIS8p
         frwdPMtzPwFjBZwyziYEdgJgecu9AOTg7wkCcW5tqOMG8GlMQuTS9VP81pYMiVzX372n
         kVwQ==
X-Gm-Message-State: ACgBeo23IC/EawGT2NE4WiYB9NS7fTsizeakuCo+F24knabb8hesmLia
        fuHDzvoJaLKh1alkmZHBCXyok5MHti2JV88L
X-Google-Smtp-Source: AA6agR5zW686Do6WzpL6D8u5kfBjmzrzuqb/mfMtzB4A50hsCz0ELjSSzWfpImULNCK1K1xL/s/DHw==
X-Received: by 2002:aa7:de18:0:b0:43d:30e2:d22b with SMTP id h24-20020aa7de18000000b0043d30e2d22bmr4371570edv.224.1660322152264;
        Fri, 12 Aug 2022 09:35:52 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id r9-20020a17090609c900b00731803d4d04sm956311eje.82.2022.08.12.09.35.51
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 09:35:51 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id j1so1767512wrw.1
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:35:51 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id
 a8-20020a056000188800b00222ca41dc26mr2492830wri.442.1660322150722; Fri, 12
 Aug 2022 09:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220811153632.0ce73f72.alex.williamson@redhat.com>
In-Reply-To: <20220811153632.0ce73f72.alex.williamson@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 09:35:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgfqqMMQG+woPEpAOyn8FkMQDqxq6k0OLKajZNGa7Jsfg@mail.gmail.com>
Message-ID: <CAHk-=wgfqqMMQG+woPEpAOyn8FkMQDqxq6k0OLKajZNGa7Jsfg@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.0-rc1 (part 2)
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 2:36 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
>  - Rename vfio source file to more easily allow additional source
>    files in the upcoming development cycles (Jason Gunthorpe)
>
> ----------------------------------------------------------------
> Jason Gunthorpe (1):
>       vfio: Move vfio.c to vfio_main.c
>
>  drivers/vfio/Makefile                | 2 ++
>  drivers/vfio/{vfio.c => vfio_main.c} | 0

Guys, why do you do this ludicrously redundant file naming?

The directory is called "vfio".

Why is every file in it called "vfio_xyzzy.c"?

This is a bad pattern, and I don't understand why you do this and
continue to just make it worse.

We don't have "drivers/block/block_floppy.c".

We don't have "kernel/kernel_exit.c".

And then when somebody finally points out that "vfio/vfio.c" is kind
of silly and bad naming practice because it doesn't say what the file
is all about, instead of realizing what the problem is, you just
continue the same broken pattern.

Is vfio the only subsystem that does this? No. We have the same odd
pattern in "drivers/leds/leds-xyzzy.c" and a few other subsystems, and
I don't understand it there either.

I don't care that much, because I never touch those files, but if I
did, I would have complained long ago about how auto-complete of
filenames is broken because of that silly non-unique and pointless
prefix that is just repeated mindlessly over and over again.

So I've pulled this, since hey, "maintainer preference" and me not
really having a lot of reason to *care*, but when I get this kind of
pure rename pull request, I just have to pipe up about how silly and
pointless the new name seems to be.

Am I the only one that just uses auto-complete for everything when I'm
off editing files in a terminal?

And if you don't use autocomplete, and actually type things out fully,
doesn't that double redundant 'vtio' bother you even *more*?

I'm just confused and wondering about this all, since it seems so *odd*.

It's like people have entirely missed what the point of using
directories to give you a hierarchy of things is all about..

               Linus
