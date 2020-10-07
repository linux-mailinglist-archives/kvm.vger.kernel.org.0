Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6E286586
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgJGRMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgJGRMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 13:12:36 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C82CC061755
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 10:12:36 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id f10so2926202otb.6
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ds2b6pt8mpuSnK1WqusZcK5IPcMpzyRXiJsNhW5qyYM=;
        b=XywxnLHwupjUJptE/EVD6sBBvmwp1LZdLWVQN7sGbbfMYl92hBOlZr7ZFS4X+E/amg
         opzvB15wo+wkKlQcyzXYRqNCcc6ZTwDvf0ncSkJzjaY9dJ7cef2oaD3bBKharNZqlUDk
         SK2SYwy12YuTYhWzjRrLHd7+bMmqCT/EcoV/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ds2b6pt8mpuSnK1WqusZcK5IPcMpzyRXiJsNhW5qyYM=;
        b=UV3UzkkhZLs+Y0tAbaSU9QKXusD8zAaWvRBqLThct7vfpJbpvQi+dPifA9aLdv26Zj
         izvrq0se0+MZsk5tHn/7m9mfv4BhfEjvqju7/oIwLu6ZlcPXCceCueMMrR6xe1K1KGgG
         pa0UEFZM8Ci4pkVX1lk1qGpAX8UbiTFMs3H5/MeudoPjQGYvW9WWg8FxX4vHpKRG4u3D
         u9id8I1f6BSTBffHJWq1o0syffKr/NGG8jRQNHzz3oCRlc4RcaKQUTHt3IiEdrkcOO2I
         NDSrcP9HgxxZniJ0vWrlOIt5GPmchrsLJ3RoF4nMs/KLIw2VIKoRNzdmJ4+OGU0hmF6/
         sGTA==
X-Gm-Message-State: AOAM530bkOF5UqGX2+e/Ni6w7kw9u65TYGi/86EUgfbW4aXYmCJ3e59m
        s8SBDDDS7WP1U3W5hHavzswv1CE6cJnLcb+NY1EYYw==
X-Google-Smtp-Source: ABdhPJzTO+z2ObbheXgto8t7rJhDCsKMuOtKVLpylgXo93WqdqDznkfE8ic3+XhZYxCrctCNbkyO32BPlJ+tqH+Wfoo=
X-Received: by 2002:a05:6830:1c3c:: with SMTP id f28mr2639345ote.188.1602090755973;
 Wed, 07 Oct 2020 10:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-6-daniel.vetter@ffwll.ch> <20201007165316.GT5177@ziepe.ca>
In-Reply-To: <20201007165316.GT5177@ziepe.ca>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 7 Oct 2020 19:12:24 +0200
Message-ID: <CAKMK7uGTpZcHwrBNQOXwzDAzyfSgoLSt_Dae_3hMRE2xwGx+GA@mail.gmail.com>
Subject: Re: [PATCH 05/13] mm/frame-vector: Use FOLL_LONGTERM
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 7, 2020 at 6:53 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Oct 07, 2020 at 06:44:18PM +0200, Daniel Vetter wrote:
> >
> > -     /*
> > -      * While get_vaddr_frames() could be used for transient (kernel
> > -      * controlled lifetime) pinning of memory pages all current
> > -      * users establish long term (userspace controlled lifetime)
> > -      * page pinning. Treat get_vaddr_frames() like
> > -      * get_user_pages_longterm() and disallow it for filesystem-dax
> > -      * mappings.
> > -      */
> > -     if (vma_is_fsdax(vma)) {
> > -             ret = -EOPNOTSUPP;
> > -             goto out;
> > -     }
> > -
> > -     if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> > -             vec->got_ref = true;
> > -             vec->is_pfns = false;
> > -             ret = pin_user_pages_locked(start, nr_frames,
> > -                     gup_flags, (struct page **)(vec->ptrs), &locked);
> > -             goto out;
> > -     }
>
> The vm_flags still need to be checked before going into the while
> loop. If the break is taken then nothing would check vm_flags

Hm right that's a bin inconsistent. follow_pfn also checks for this,
so I think we can just ditch this entirely both here and in the do {}
while () check, simplifying the latter to just while (vma). Well, just
make it a real loop with less confusing control flow probably.

Or prefer I keep this and touch the code less?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
