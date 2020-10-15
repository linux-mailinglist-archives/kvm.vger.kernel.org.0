Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B86728EDF7
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 09:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgJOHzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 03:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgJOHzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Oct 2020 03:55:50 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5E4C0613D5
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 00:55:50 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id t15so2143563otk.0
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 00:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKpQn0FDypcCkXIOygWWNsNfWX2lsbxOB8uCbMksAIA=;
        b=HQSl5QWfcvPbV2pGTi/CgSYNE6yrm43VcrDZdZgXfpSEZAPIWhWUaC3Z9+19ZGIOT/
         L1FwUAUuyIWjzwGqR/YpO/MiPOAvkTi9v6qcb2Wcm3bTcyjMzBlJxDT1/tZLBuBLm3mU
         NDzd8Hc1lCeymtif5yx0kEE4DAlngk2j4kC84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKpQn0FDypcCkXIOygWWNsNfWX2lsbxOB8uCbMksAIA=;
        b=bUbZg2P3qUi+rF6VCpRLm37bAI5g14sz7IwAle632PR9HmOiRrLjKfiLlN8eJz510h
         sygVJYBnMGX2ast3fmgx3fzbrvf8Ad0kMhLtJ7gVW1N2zI5Y7VsdXLtQGSzvZXFx1tpj
         YKhBwkzlXsMWvyeKdUcMi20YB77rmtuySIAgjzBGDo3XkLIJM/wI822UvfBlt9foK+yH
         nonPXfW1VsEHamV3FHbDtowOKfI7Sgf7ugxpls8JMrkn+QaM6AfxmeQnz7rmFUu75pf4
         uMN2SV+/k7mlbOxz3Klz2OE3RUgrIgpuNAUNoDQm9iphKmt0aziU1UUzPc1EY5CZFxzi
         kIEQ==
X-Gm-Message-State: AOAM532+54Ui/Ebj20FxGpD4jsARpvO13O0j9XR+hHHAfWG7N0ryiQ8W
        r+QKzYk4+32M8NkDDgRvAZZ/688GKXA3Jm41Jxx1Zw==
X-Google-Smtp-Source: ABdhPJxdSyalRqLRcx8/tcfIkmtSxIfRSiuYpFEh1r0/JAJixM8EE3XAGRAgngn5UADgaJioF6PuXkNghwu1P0DfUPk=
X-Received: by 2002:a05:6830:8b:: with SMTP id a11mr1751471oto.303.1602748549701;
 Thu, 15 Oct 2020 00:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-15-daniel.vetter@ffwll.ch> <20201009123109.GO5177@ziepe.ca>
 <CAKMK7uFpPP-Q0jC0vM7vYPEcg0m4NzTw+Ld=swdTF3BgMX5Qug@mail.gmail.com>
 <20201009143209.GS5177@ziepe.ca> <CAPcyv4j54O8ac6WB3LEeNud2r11V26gA0PRKK9bhyEMF67AXtQ@mail.gmail.com>
 <20201015000939.GD6763@ziepe.ca> <CAKMK7uGu8yWRAGZX-dz-sXHsGufXKm003J5zuQr2AwNMG4+DUw@mail.gmail.com>
In-Reply-To: <CAKMK7uGu8yWRAGZX-dz-sXHsGufXKm003J5zuQr2AwNMG4+DUw@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 15 Oct 2020 09:55:38 +0200
Message-ID: <CAKMK7uHwi8_zurd59aX7ZDst+TGFB3TxyzPiWc8fmVvmomskMw@mail.gmail.com>
Subject: Re: [PATCH v2 14/17] resource: Move devmem revoke code to resource framework
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 15, 2020 at 9:52 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> On Thu, Oct 15, 2020 at 2:09 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Oct 09, 2020 at 11:28:54AM -0700, Dan Williams wrote:
> > > On Fri, Oct 9, 2020 at 7:32 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > >
> > > > On Fri, Oct 09, 2020 at 04:24:45PM +0200, Daniel Vetter wrote:
> > > > > On Fri, Oct 9, 2020 at 2:31 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > > >
> > > > > > On Fri, Oct 09, 2020 at 09:59:31AM +0200, Daniel Vetter wrote:
> > > > > >
> > > > > > > +struct address_space *iomem_get_mapping(void)
> > > > > > > +{
> > > > > > > +     return iomem_inode->i_mapping;
> > > > > >
> > > > > > This should pair an acquire with the release below
> > > > > >
> > > > > > > +     /*
> > > > > > > +      * Publish /dev/mem initialized.
> > > > > > > +      * Pairs with smp_load_acquire() in revoke_iomem().
> > > > > > > +      */
> > > > > > > +     smp_store_release(&iomem_inode, inode);
> > > > > >
> > > > > > However, this seems abnormal, initcalls rarely do this kind of stuff
> > > > > > with global data..
> > > > > >
> > > > > > The kernel crashes if this fs_initcall is raced with
> > > > > > iomem_get_mapping() due to the unconditional dereference, so I think
> > > > > > it can be safely switched to a simple assignment.
> > > > >
> > > > > Ah yes I checked this all, but forgot to correctly annotate the
> > > > > iomem_get_mapping access. For reference, see b34e7e298d7a ("/dev/mem:
> > > > > Add missing memory barriers for devmem_inode").
> > > >
> > > > Oh yikes, so revoke_iomem can run concurrently during early boot,
> > > > tricky.
> > >
> > > It runs early because request_mem_region() can run before fs_initcall.
> > > Rather than add an unnecessary lock just arrange for the revoke to be
> > > skipped before the inode is initialized. The expectation is that any
> > > early resource reservations will block future userspace mapping
> > > attempts.
> >
> > Actually, on this point a simple WRITE_ONCE/READ_ONCE pairing is OK,
> > Paul once explained that the pointer chase on the READ_ONCE side is
> > required to be like an acquire - this is why rcu_dereference is just
> > READ_ONCE
>
> Indeed this changed with the sm_read_barrier_depends() removal a year
> ago. Before that READ_ONCE and rcu_dereference where not actually the
> same. I guess I'll throw a patch on top to switch that over too.

Actually 2019 landed just the clean-up, the read change landed in 2017 already:

commit 76ebbe78f7390aee075a7f3768af197ded1bdfbb
Author: Will Deacon <will@kernel.org>
Date:   Tue Oct 24 11:22:47 2017 +0100

   locking/barriers: Add implicit smp_read_barrier_depends() to READ_ONCE()

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
