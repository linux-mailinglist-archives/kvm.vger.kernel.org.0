Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF128A1B9
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbgJJWPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 18:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730667AbgJJV7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 17:59:25 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668F1C0613D9
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 14:50:39 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id i12so12347313ota.5
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 14:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zskjUsHTtZxN7/2TQU3peg25br1tT43hRWFs8IXZrR4=;
        b=i63KoTVhRCCVQE6C47zXN/aote8oxAlq2u8XkZEfRS7C4aCQsGXOTE+Jx6GONLOzLt
         PE8349J61xYKgijEt/U90UIMaq9DrkU4QY1Tnas9hwBXWmOQCPO26SVsgXlr/ZipK8Ls
         RMwvBQZd64IkyMtuG55st8dU/i5RoewRXan9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zskjUsHTtZxN7/2TQU3peg25br1tT43hRWFs8IXZrR4=;
        b=g2vJ5GZHS8PCi5mF2TT75agHEfwB5gX3/DT4LHYSlmEFwfQNGJUksyWk/WOrn7G90E
         om7W/y/a77k4F9Hx34Fip68Nhl0fr/xI9LGSrGIc2zHjJ7dFC/dWUcraxrfisUxwYbTl
         ZZkgjF/5Svr/OFuhh3PDq7FNHkLOZIHdZpmmtKH1xlVdNP1oWHOjLc0FF/zo9qyzlSRZ
         z8am6KxcE57gxuo9r6gyh9ruLGGBRCZWdusGr9ZFvXl5jO8YqnDT3Tbi6k5tFX26D4lJ
         McHISxCItOAO45zJ3kpVOALOMd4PLfggsg3Fk/Bzs1L25KFEJUvWaiZ+LLioleMej65s
         cPpQ==
X-Gm-Message-State: AOAM530ui0d+gCHBIq3E4Tm8fydOU484vP4QXVi/FnfwFKjHaMCCLb2k
        Yp7ZY3GiDxA8+Fn3czMfHAPmtaFDH8SAULi+eU79hn3brd3AKA==
X-Google-Smtp-Source: ABdhPJznztyXj83TXT5Po+mKIPpYBLH3P+nInP8snkNIpnPLWv+XbgGvuCQZzJCVdvnd+c/ezVPBdFh+cvOLaSiqshs=
X-Received: by 2002:a05:6830:8b:: with SMTP id a11mr2057108oto.303.1602366638562;
 Sat, 10 Oct 2020 14:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-10-daniel.vetter@ffwll.ch> <20201009123421.67a80d72@coco.lan>
 <20201009122111.GN5177@ziepe.ca> <20201009143723.45609bfb@coco.lan>
 <20201009124850.GP5177@ziepe.ca> <CAKMK7uF-hrSwzFQkp6qEP88hM1Qg8TMQOunuRHh=f2+D8MaMRg@mail.gmail.com>
 <CAAFQd5CTT0re4ssj9NNTxhejFX_v_rCjy6=mX7C+dc=Lw9GOHw@mail.gmail.com> <20201010213554.GD3939@pendragon.ideasonboard.com>
In-Reply-To: <20201010213554.GD3939@pendragon.ideasonboard.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat, 10 Oct 2020 23:50:27 +0200
Message-ID: <CAKMK7uGhq+BiaJ5jD+bkO4VOaCPuUZ_empA3Ojr1AsvwNef6QQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/17] mm: Add unsafe_follow_pfn
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Kees Cook <keescook@chromium.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 10, 2020 at 11:36 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On Sat, Oct 10, 2020 at 07:22:48PM +0200, Tomasz Figa wrote:
> > On Fri, Oct 9, 2020 at 7:52 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > On Fri, Oct 9, 2020 at 2:48 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > On Fri, Oct 09, 2020 at 02:37:23PM +0200, Mauro Carvalho Chehab wrote:
> > > >
> > > > > I'm not a mm/ expert, but, from what I understood from Daniel's patch
> > > > > description is that this is unsafe *only if*  __GFP_MOVABLE is used.
> > > >
> > > > No, it is unconditionally unsafe. The CMA movable mappings are
> > > > specific VMAs that will have bad issues here, but there are other
> > > > types too.
> > > >
> > > > The only way to do something at a VMA level is to have a list of OK
> > > > VMAs, eg because they were creatd via a special mmap helper from the
> > > > media subsystem.
> > > >
> > > > > Well, no drivers inside the media subsystem uses such flag, although
> > > > > they may rely on some infrastructure that could be using it behind
> > > > > the bars.
> > > >
> > > > It doesn't matter, nothing prevents the user from calling media APIs
> > > > on mmaps it gets from other subsystems.
> > >
> > > I think a good first step would be to disable userptr of non struct
> > > page backed storage going forward for any new hw support. Even on
> > > existing drivers. dma-buf sharing has been around for long enough now
> > > that this shouldn't be a problem. Unfortunately right now this doesn't
> > > seem to exist, so the entire problem keeps getting perpetuated.
> > >
> > > > > If this is the case, the proper fix seems to have a GFP_NOT_MOVABLE
> > > > > flag that it would be denying the core mm code to set __GFP_MOVABLE.
> > > >
> > > > We can't tell from the VMA these kinds of details..
> > > >
> > > > It has to go the other direction, evey mmap that might be used as a
> > > > userptr here has to be found and the VMA specially created to allow
> > > > its use. At least that is a kernel only change, but will need people
> > > > with the HW to do this work.
> > >
> > > I think the only reasonable way to keep this working is:
> > > - add a struct dma_buf *vma_tryget_dma_buf(struct vm_area_struct *vma);
> > > - add dma-buf export support to fbdev and v4l
> >
> > I assume you mean V4L2 and not the obsolete V4L that is emulated in
> > the userspace by libv4l. If so, every video device that uses videobuf2
> > gets DMA-buf export for free and there is nothing needed to enable it.

Yeah. And I missed that v4l2 added dma-buf export too.

> > We probably still have a few legacy drivers using videobuf (non-2),
> > but IMHO those should be safe to put behind some disabled-by-default
> > Kconfig symbol or even completely drop, as the legacy framework has
> > been deprecated for many years already.
>
> There's 8 drivers left, and they support a very large number of devices.
> I expect unhappy users distros stop shipping them. On the other hand,
> videobuf has been deprecated for a loooooooong time, so there has been
> plenty of time to convert the remaining drivers to videobuf2. If nobody
> can do it, then we'll have to drop support for these devices given the
> security issues.

Again, the issue here is _only_ with follow_pfn. For videobuf1 this
means videbuf-dma-contig.c userptr support is broken. Unlike videobuf2
it means it's broken for all usage (not just zero-copy userptr),
because videbuf-dma-contig.c lacks the pin_user_pages path. But that
would be easy to add if this poses a  problem I think - we just need
to carry over the pin_user_pages_fast logic from videbuf2, no driver
changes required. But of course I don't think we should do that before
someone reports the regression, since videobuf1 userptr is doubly
deprecated :-)

Everything else keeps working with videobuf1 with my patch series. So
depending upon which videobuf1 implementations these 8 drivers use,
you might not even have any real breakage there.

> We have moved media drivers to staging in the past when there wasn't
> enough maintenance effort, we could do so here too.

I'm not breaking the world with this, it's really very minimal
use-case. At least as far as I'm understanding the entire media
subsystem here.
-Daniel

> > > - roll this out everywhere we still need it.
> > >
> > > Realistically this just isn't going to happen. And anything else just
> > > reimplements half of dma-buf, which is kinda pointless (you need
> > > minimally refcounting and some way to get at a promise of a permanent
> > > sg list for dma. Plus probably the vmap for kernel cpu access.
> > >
> > > > > Please let address the issue on this way, instead of broken an
> > > > > userspace API that it is there since 1991.
> > > >
> > > > It has happened before :( It took 4 years for RDMA to undo the uAPI
> > > > breakage caused by a security fix for something that was a 15 years
> > > > old bug.
> > >
> > > Yeah we have a bunch of these on the drm side too. Some of them are
> > > really just "you have to upgrade userspace", and there's no real fix
> > > for the security nightmare without that.
> >
> > I think we need to phase out such userspace indeed. The Kconfig symbol
> > allows enabling the unsafe functionality for anyone who still needs
> > it, so I think it's not entirely a breakage.
>
> --
> Regards,
>
> Laurent Pinchart



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
