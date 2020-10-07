Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3D0286691
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgJGSKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgJGSKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 14:10:46 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE959C0613D3
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 11:10:45 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q21so3085150ota.8
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 11:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xxzMWzZDg+VcRWGQ/c2kzQrjqzz9Zr/vQmYEu/FEsRY=;
        b=JHHbdSa3yjRCRnWpyNRhKKiSEOBUKxgo2tfjYtBvhCHpORb0ALeU5M+5x5K5yNzCHm
         lADTYYQR32EHxoVtfzUaalEzZmnDh6DAaDz8LEVrvhIFw/92GoGYNABw2nQYniRBDjZZ
         trEXtjVKX20MlR66/aUzrdTZc9L9Ye/bFneWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xxzMWzZDg+VcRWGQ/c2kzQrjqzz9Zr/vQmYEu/FEsRY=;
        b=lotMqEyPTtWan/ymdrQ+hpea/PXW6v4koygl/QCzlgfy1tymKcbBbDIzOL+y9DCjW9
         pOf/Moo6O6d+wF+lEEKl2yS4rOxOgElCK7Mh5u9hJFQq/Hi3THl50SrnPTHs6JGaUgrM
         sUbl4eJvKS/pFv9mQB5yXpYdwgbfd5eHmBm+QHU5P2dCa9zfPkwKEH/Gjm7vc9ssoRGv
         c177z8zw/fj2e3F/b/U+mgMFRdYruFK5GPDqIGgqPqQHNGJHSC10RuXXQEwHH2MpRrQL
         8d9voy0GdZ1sSIdD36Y30PaeuN02SffnWrC5kE0HLViPwMjq86vcSAcS2LlTpw7nDKwV
         9yPQ==
X-Gm-Message-State: AOAM532QLLgkdwkgRyCbnMjZUC4TghKx+r5QZCT0w1T7P/f2RkmHD38I
        +vIHEXBCnubLt0vgibSqmHghggFVLCg5ruFFu4k1aA==
X-Google-Smtp-Source: ABdhPJw9fFZN/ovuisic7f8Uj9KPXiMNmYYqtFH7SfVt9HtB4IgG/AqVfKw/vHLMcJ5OwO7pnRxjiIvlLFeiVdztT+E=
X-Received: by 2002:a05:6830:1e56:: with SMTP id e22mr2510412otj.303.1602094245171;
 Wed, 07 Oct 2020 11:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-12-daniel.vetter@ffwll.ch> <20201007173647.GW5177@ziepe.ca>
In-Reply-To: <20201007173647.GW5177@ziepe.ca>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 7 Oct 2020 20:10:34 +0200
Message-ID: <CAKMK7uE9sbK_tGhJbsnHgD9rOnx-dr=2xmpMw7RvvvpPLnjVVA@mail.gmail.com>
Subject: Re: [PATCH 11/13] mm: add unsafe_follow_pfn
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 7, 2020 at 7:36 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Oct 07, 2020 at 06:44:24PM +0200, Daniel Vetter wrote:
> > Way back it was a reasonable assumptions that iomem mappings never
> > change the pfn range they point at. But this has changed:
> >
> > - gpu drivers dynamically manage their memory nowadays, invalidating
> > ptes with unmap_mapping_range when buffers get moved
> >
> > - contiguous dma allocations have moved from dedicated carvetouts to
> > cma regions. This means if we miss the unmap the pfn might contain
> > pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> >
> > - even /dev/mem now invalidates mappings when the kernel requests that
> > iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> > ("/dev/mem: Revoke mappings when a driver claims the region")
> >
> > Accessing pfns obtained from ptes without holding all the locks is
> > therefore no longer a good idea.
> >
> > Unfortunately there's some users where this is not fixable (like v4l
> > userptr of iomem mappings) or involves a pile of work (vfio type1
> > iommu). For now annotate these as unsafe and splat appropriately.
> >
> > This patch adds an unsafe_follow_pfn, which later patches will then
> > roll out to all appropriate places.
> >
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: kvm@vger.kernel.org
> > ---
> >  include/linux/mm.h |  2 ++
> >  mm/memory.c        | 32 +++++++++++++++++++++++++++++++-
> >  mm/nommu.c         | 17 +++++++++++++++++
> >  security/Kconfig   | 13 +++++++++++++
> >  4 files changed, 63 insertions(+), 1 deletion(-)
>
> Makes sense to me.
>
> I wonder if we could change the original follow_pfn to require the
> ptep and then lockdep_assert_held() it against the page table lock?

The safe variant with the pagetable lock is follow_pte_pmd. The only
way to make follow_pfn safe is if you have an mmu notifier and
corresponding retry logic. That is not covered by lockdep (it would
splat if we annotate the retry side), so I'm not sure how you'd check
for that?

Checking for ptep lock doesn't work here, since the one leftover safe
user of this (kvm) doesn't need that at all, because it has the mmu
notifier.

Also follow_pte_pmd will splat with lockdep if you get it wrong, since
the function leaves you with the right ptlock lock when it returns. If
you forget to unlock that, lockdep will complain.

So I think we're as good as it gets, since I really have no idea how
to make sure follow_pfn callers do have an mmu notifier registered.

> > +int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long addres=
s,
> > +     unsigned long *pfn)
> > +{
> > +#ifdef CONFIG_STRICT_FOLLOW_PFN
> > +     pr_info("unsafe follow_pfn usage rejected, see
> > CONFIG_STRICT_FOLLOW_PFN\n");
>
> Wonder if we can print something useful here, like the current
> PID/process name?

Yeah adding comm/pid here makes sense.

> > diff --git a/security/Kconfig b/security/Kconfig
> > index 7561f6f99f1d..48945402e103 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -230,6 +230,19 @@ config STATIC_USERMODEHELPER_PATH
> >         If you wish for all usermode helper programs to be disabled,
> >         specify an empty string here (i.e. "").
> >
> > +config STRICT_FOLLOW_PFN
> > +     bool "Disable unsafe use of follow_pfn"
> > +     depends on MMU
>
> I would probably invert this CONFIG_ALLOW_UNSAFE_FOLLOW_PFN
> default n

I've followed the few other CONFIG_STRICT_FOO I've seen, which are all
explicit enables and default to "do not break uapi, damn the
(security) bugs". Which is I think how this should be done. It is in
the security section though, so hopefully competent distros will
enable this all.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
