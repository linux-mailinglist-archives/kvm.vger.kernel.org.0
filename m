Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23ED1423AE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438248AbfFLLNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:13:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38155 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438224AbfFLLNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 07:13:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id v11so8752605pgl.5
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 04:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPH48pl3zgEAvx1ZV8NCaa+NrirZ7d55m0K/3ZW0DB4=;
        b=Wa+GrRiixuq08ZJy7YLBy/hw4N6KCGD4D0JGPHXeAhrhP7aYFGu2wrFVi/4U57v07h
         gabUfJpQMd/ZxixypJh6LG438zDMAFuaLmx1zNosW/bNS5e9DE+bfIpQfyXphO/5R37q
         J4BK+9faydCecf+zFNicytUzZ+34IwX2nZrUTbQwSG0d5Mwjsh+M/iy5iKaSTm2HU1Vc
         APJmA3gO7zhEVXs30R27Red8E5MuIvjfWVaZNPU7/jpeOCWo81HFfgpvxUE+snFq9nK5
         AQ9h1nAmh3KAeta7IGYJp8hdQcsOoF6BnZ35/+mA9Y0+45iTzl1SsN8NtN8M46KVCGVs
         tN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CPH48pl3zgEAvx1ZV8NCaa+NrirZ7d55m0K/3ZW0DB4=;
        b=QYoeiAHbp7WHzK+Zh6bCNA3rLPAm0dtgQt9Ck7iIa+FsNNDl//paQ/zg9aTwm0d0Lq
         vVKAHOnKEqmzipsFGGp0eC7ogk99LjPuZm7WIKOyih4zmYZbKwq3p0904Zh4jCYR5Wi5
         /+7d3jO/WzZ4rCK4pFN5iLeMrEsB1WghI8ZmhrveiwuPSGc9CT0THDjZPRDZQ3CFgrYY
         2iD5wWV6iJPRnMFlDFMa2P7Noj6DybRCkmuaLBX+as4HcqtA/SCOBzhlxHcvZPlxtgKh
         0z0NPT9zDfM2TNpGNju+wEL3vk/1t0kh1bBECP2KdjHOnDdZXBhaQJlkz0RTokII2Q0X
         X8GA==
X-Gm-Message-State: APjAAAXu/+eZDX6O8Nb1wHYdgG3/MZLkNhUpUlcZbDRiFUWlImwzay2e
        9CUQs9rXb62dE/EuB5ret8FVflufiIi6m52iTJ62WA==
X-Google-Smtp-Source: APXvYqwzlagi41UpMXh0yb3QZZS2gyEag7Dm2eoj6v2jESPsCD8f1MNuoUw/t7+/hDiqSvkq5q/rQO7JKsp+xiDho38=
X-Received: by 2002:a65:5845:: with SMTP id s5mr25017064pgr.286.1560337999517;
 Wed, 12 Jun 2019 04:13:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559580831.git.andreyknvl@google.com> <045a94326401693e015bf80c444a4d946a5c68ed.1559580831.git.andreyknvl@google.com>
 <20190610142824.GB10165@c02tf0j2hf1t.cambridge.arm.com> <CAAeHK+zBDB6i+iEw+TJY14gZeccvWeOBEaU+otn1F+jzDLaRpA@mail.gmail.com>
 <20190611174448.exg2zycfqf4a2vea@mbp>
In-Reply-To: <20190611174448.exg2zycfqf4a2vea@mbp>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 12 Jun 2019 13:13:08 +0200
Message-ID: <CAAeHK+wkA8PskRrdfJ7MMr+je+x71WW3yDgWajxPRPwPBRNVfA@mail.gmail.com>
Subject: Re: [PATCH v16 05/16] arm64: untag user pointers passed to memory syscalls
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
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 7:45 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Jun 11, 2019 at 05:35:31PM +0200, Andrey Konovalov wrote:
> > On Mon, Jun 10, 2019 at 4:28 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Mon, Jun 03, 2019 at 06:55:07PM +0200, Andrey Konovalov wrote:
> > > > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > > > pass tagged user pointers (with the top byte set to something else other
> > > > than 0x00) as syscall arguments.
> > > >
> > > > This patch allows tagged pointers to be passed to the following memory
> > > > syscalls: get_mempolicy, madvise, mbind, mincore, mlock, mlock2, mprotect,
> > > > mremap, msync, munlock.
> > > >
> > > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > >
> > > I would add in the commit log (and possibly in the code with a comment)
> > > that mremap() and mmap() do not currently accept tagged hint addresses.
> > > Architectures may interpret the hint tag as a background colour for the
> > > corresponding vma. With this:
> >
> > I'll change the commit log. Where do you you think I should put this
> > comment? Before mmap and mremap definitions in mm/?
>
> On arm64 we use our own sys_mmap(). I'd say just add a comment on the
> generic mremap() just before the untagged_addr() along the lines that
> new_address is not untagged for preserving similar behaviour to mmap().

Will do in v17, thanks!

>
> --
> Catalin
