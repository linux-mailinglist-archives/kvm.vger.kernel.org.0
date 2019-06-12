Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C542424
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437035AbfFLLgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:36:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40478 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409076AbfFLLgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 07:36:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so6215885pfp.7
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 04:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MhkB743oojqt0jCijE6DsOt5IqaBpxqgWof9mFxCLr0=;
        b=GDzbgDhOafy14R/X43UkUN/+wf8bZdqGlFyPynLyOoG20vlQgN7zE9jZaanLyn3zx5
         qQhhso2gb34OxP/u3xHSg6zS8JjJRY1rM9k4rX+82IiHVqiDxz7X2a893Yf4graw7TMN
         nSUF/2Gtu0ZiA9FjJgluVZwCMm/sY7nIvA/8cwZyNRO0pWttZ9rn4SJm4NDG5Og1LJ7q
         69ebVQ9hxBQQPUib1nigJuccodsU3NmYrSrnehuErfe4YWQQvRoySvoE3IbFgIm+u5mm
         oszynkP2bKoPt4/Zv/VgvQYlSIXKjNdvA3RFAgK5OHTEZyvWErx96s2gVUjdKfd7KRLc
         uonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MhkB743oojqt0jCijE6DsOt5IqaBpxqgWof9mFxCLr0=;
        b=Zap0hDzAFFXUWLawwRjQjZIB33Uk2vkQlFLREuA7EhpDgJ0sGq9wk4p5wfKVbrXgH/
         T0ZTKQISYjpHBhwfxfSJI0/WlJ4alw0fpXur/dKwLSBLJYwGr/uxRnIQYiaw+NldVRjc
         etpgLbrX+mV2MRd9Ft4QV/BAXAxSYYT28KJNqrhxNK+npnz7GjS4kCfqy6Xx5L9927Dw
         yrtscH+1FMVYyKV6ExmogwW27yYn1yVb8JWcU8zMIvJpzoHmy0g/5QI9DOCU3HWVKTHg
         e33HVH9BtF9E0PHK88hcH94cfQdgKUn+zBtbVAlkXMbmO/C1aYl0bQ0CkKlzgdqKP828
         Fgyg==
X-Gm-Message-State: APjAAAVhDTh/g2Evq8dNluISFC0M6I/WIla+vSTlGyI8MfZDrf5sgh1M
        kUtltzqKivk5Xhfa9LHwrkYfOIOEFj3sRYRXlz9tAA==
X-Google-Smtp-Source: APXvYqzGzjPmF8qGtciCMiJ8cvvmFlnWp+2d9nBudQ86r37IgxuDA/rPCLSSJ3M+cA0egqf1SPnYkN9tXts/BubXkpo=
X-Received: by 2002:aa7:97bb:: with SMTP id d27mr18575219pfq.93.1560339407628;
 Wed, 12 Jun 2019 04:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559580831.git.andreyknvl@google.com> <51f44a12c4e81c9edea8dcd268f820f5d1fad87c.1559580831.git.andreyknvl@google.com>
 <201906072101.58C919E@keescook> <CAAeHK+y8CH4P3vheUDCEnPAuO-2L6mc-sz6wMA_hT=wC1Cy3KQ@mail.gmail.com>
In-Reply-To: <CAAeHK+y8CH4P3vheUDCEnPAuO-2L6mc-sz6wMA_hT=wC1Cy3KQ@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 12 Jun 2019 13:36:36 +0200
Message-ID: <CAAeHK+xCmc-x=Mvs8RC+xJOCw6AnEUgUzXXjjS3NJXeLwJkyqg@mail.gmail.com>
Subject: Re: [PATCH v16 08/16] fs, arm64: untag user pointers in copy_mount_options
To:     Kees Cook <keescook@chromium.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Tue, Jun 11, 2019 at 4:38 PM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> On Sat, Jun 8, 2019 at 6:02 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Mon, Jun 03, 2019 at 06:55:10PM +0200, Andrey Konovalov wrote:
> > > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > > pass tagged user pointers (with the top byte set to something else other
> > > than 0x00) as syscall arguments.
> > >
> > > In copy_mount_options a user address is being subtracted from TASK_SIZE.
> > > If the address is lower than TASK_SIZE, the size is calculated to not
> > > allow the exact_copy_from_user() call to cross TASK_SIZE boundary.
> > > However if the address is tagged, then the size will be calculated
> > > incorrectly.
> > >
> > > Untag the address before subtracting.
> > >
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> >
> > One thing I just noticed in the commit titles... "arm64" is in the
> > prefix, but these are arch-indep areas. Should the ", arm64" be left
> > out?
> >
> > I would expect, instead:
> >
> >         fs/namespace: untag user pointers in copy_mount_options
>
> Hm, I've added the arm64 tag in all of the patches because they are
> related to changes in arm64 kernel ABI. I can remove it from all the
> patches that only touch common code if you think that it makes sense.

I'll keep the arm64 tags in commit titles for v17. Please reply
explicitly if you think I should remove them. Thanks! :)

>
> Thanks!
>
> >
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> >
> > -Kees
> >
> > > ---
> > >  fs/namespace.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/namespace.c b/fs/namespace.c
> > > index b26778bdc236..2e85712a19ed 100644
> > > --- a/fs/namespace.c
> > > +++ b/fs/namespace.c
> > > @@ -2993,7 +2993,7 @@ void *copy_mount_options(const void __user * data)
> > >        * the remainder of the page.
> > >        */
> > >       /* copy_from_user cannot cross TASK_SIZE ! */
> > > -     size = TASK_SIZE - (unsigned long)data;
> > > +     size = TASK_SIZE - (unsigned long)untagged_addr(data);
> > >       if (size > PAGE_SIZE)
> > >               size = PAGE_SIZE;
> > >
> > > --
> > > 2.22.0.rc1.311.g5d7573a151-goog
> > >
> >
> > --
> > Kees Cook
