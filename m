Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142D4705A9
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfGVQqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 12:46:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42513 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfGVQqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 12:46:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so17917095pgb.9
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F8BugWPvgcU2u1kFFZKMyP/IOkg4/qodeykECt+PCWA=;
        b=VX6SSuVoSHuo5NAioif+DJtSSs1RJl179j5hlo4DTfAYF66Jgcx0vpiJB8eR+9HEL8
         +f/45Mc4lQN3jKnZezfzKg+yOPAVpcviTazcgmREFQYvaP41eWd/rYtiTmOP5jut4IGW
         UsbCxeU7Nx57xcR3YkKPrTzMk7AWS/2VcXYuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F8BugWPvgcU2u1kFFZKMyP/IOkg4/qodeykECt+PCWA=;
        b=ZJRirmrvpwEv0j0Q0aqLvpR/Z+p7uV+mzj4GKHLcQo6Ic/sXZxbhudNgXoV3JKXjAb
         5d8jFa2VEyOOV1aNERRwrOl4LpxO9Lr+Wk2nl75rB22MagI5Unh9iUyWeKiHdE8J2y2U
         6XNEtat7JG1hWi2xznhTbvK4DdKy9Z+cIQgspBwyDa+kor98qLvdjY30SyfYQLOmflMs
         3+dfwk8axVhMLKQllazIZAYbbTzce/YqkLoYJ9i3ljJmYlOk1hHuKhsklKpH4zTlTB1Q
         4f6kSiZDgsUuuUB1s+Z/JS8Q3JYAJAvlSaQhYUYs/t+nHiWy5t/fVdrDbnsWCiKkwxmY
         ckpA==
X-Gm-Message-State: APjAAAXucBDu/l9eF90akXqJznNcZ32T0KFeNEl49Zy5/XSHZ1v4eItA
        4Xfy/KaRP/NvtHY8LhTJ5ZWpog==
X-Google-Smtp-Source: APXvYqzl1okfrN5zPZDspTEQta/i5+YABh20qrSg3GL1AN5406TswuRoR6v+V+I5B+11TbFoYh/o0Q==
X-Received: by 2002:a17:90a:ff17:: with SMTP id ce23mr77676431pjb.47.1563813968675;
        Mon, 22 Jul 2019 09:46:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 4sm48411440pfc.92.2019.07.22.09.46.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jul 2019 09:46:07 -0700 (PDT)
Date:   Mon, 22 Jul 2019 09:46:06 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
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
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v18 07/15] fs/namespace: untag user pointers in
 copy_mount_options
Message-ID: <201907220944.5821C92518@keescook>
References: <cover.1561386715.git.andreyknvl@google.com>
 <41e0a911e4e4d533486a1468114e6878e21f9f84.1561386715.git.andreyknvl@google.com>
 <20190624175009.GM29120@arrakis.emea.arm.com>
 <CAAeHK+x2TL057Fr0K7FZBTYgeEPVU3cC6scEeiSYk-Jkb3xgfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+x2TL057Fr0K7FZBTYgeEPVU3cC6scEeiSYk-Jkb3xgfg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Eric Biederman too, who might be able to Ack this...

On Mon, Jul 15, 2019 at 06:00:04PM +0200, Andrey Konovalov wrote:
> On Mon, Jun 24, 2019 at 7:50 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > On Mon, Jun 24, 2019 at 04:32:52PM +0200, Andrey Konovalov wrote:
> > > This patch is a part of a series that extends kernel ABI to allow to pass
> > > tagged user pointers (with the top byte set to something else other than
> > > 0x00) as syscall arguments.
> > >
> > > In copy_mount_options a user address is being subtracted from TASK_SIZE.
> > > If the address is lower than TASK_SIZE, the size is calculated to not
> > > allow the exact_copy_from_user() call to cross TASK_SIZE boundary.
> > > However if the address is tagged, then the size will be calculated
> > > incorrectly.
> > >
> > > Untag the address before subtracting.
> > >
> > > Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
> > > Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > ---
> > >  fs/namespace.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/namespace.c b/fs/namespace.c
> > > index 7660c2749c96..ec78f7223917 100644
> > > --- a/fs/namespace.c
> > > +++ b/fs/namespace.c
> > > @@ -2994,7 +2994,7 @@ void *copy_mount_options(const void __user * data)
> > >        * the remainder of the page.
> > >        */
> > >       /* copy_from_user cannot cross TASK_SIZE ! */
> > > -     size = TASK_SIZE - (unsigned long)data;
> > > +     size = TASK_SIZE - (unsigned long)untagged_addr(data);
> > >       if (size > PAGE_SIZE)
> > >               size = PAGE_SIZE;
> >
> > I think this patch needs an ack from Al Viro (cc'ed).
> >
> > --
> > Catalin
> 
> Hi Al,
> 
> Could you take a look and give your acked-by?
> 
> Thanks!

-- 
Kees Cook
