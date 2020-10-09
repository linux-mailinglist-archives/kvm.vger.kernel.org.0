Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B66288AC8
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388790AbgJIOY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 10:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388338AbgJIOY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 10:24:58 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AFCC0613D5
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 07:24:57 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id q136so9185528oic.8
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 07:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4j8VU4wpGDl6YV4vbFDWVWHEZCZz4TBGhbt0uuUGdBg=;
        b=YLM0g/4oQLD0hu/Oa87scm3scHf+vbiPkLbDqUAnyXk3ER+QRam40zaijXvFBD6PRA
         nzSbXcW7hn805lQbe6AX68hG76VYbA+coTzGsCT/QWJIzeeROcYpI8QHsxV9QNKX8ew0
         Dn833fe+dPzpkngPWmhP7pgAZbKyHIAe+x52Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4j8VU4wpGDl6YV4vbFDWVWHEZCZz4TBGhbt0uuUGdBg=;
        b=dd/7zplrrR6TCAwW0pqbDGHcxvH6YMwABIbdV/OkrUrKrBSqkcBXkuyCet38YXIlIa
         Abek7Tg0TIJ6GV0pW//QGoLZVv279a+hFEwnlZC/E5lY9HjnHWKlLrjF3fJBs+g3MT3N
         i/pji4ytajsMwT8z2gyDbMnExyNXXrwla3bHpqfeXM+m/hBwM+vF4YxAK1M2il49EIUi
         B26y3GSPpr5dwhiVnBtgmFg2Sl9TSeetPEI33m6mpMagZHStcVcPWKKxfE2O2UdBMfgN
         2u6CIeHGykKtTIWlkS6qKHmwaNhVX3p6UhnE/C9cnTB2F3vRei9EwUHtfDkVes+d5zAQ
         aV5Q==
X-Gm-Message-State: AOAM531Obgcqm1k6zq+Bpky8+PTFut8pTPHITgHZfg9XM1lyt6B5CmsD
        e1knw+qqKMjSp6X9L+u4xcIyGpEiLwjeovRw5cmWbw==
X-Google-Smtp-Source: ABdhPJyHxT/6NZr88G54H2j+X8AAqjyafUNpDVmVkQQPYeZ/EXQjiOmXOOdqJRKMWvSSWVU71sVuY9YK0QkcwCetmpo=
X-Received: by 2002:aca:6083:: with SMTP id u125mr2688783oib.14.1602253497033;
 Fri, 09 Oct 2020 07:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-15-daniel.vetter@ffwll.ch> <20201009123109.GO5177@ziepe.ca>
In-Reply-To: <20201009123109.GO5177@ziepe.ca>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 9 Oct 2020 16:24:45 +0200
Message-ID: <CAKMK7uFpPP-Q0jC0vM7vYPEcg0m4NzTw+Ld=swdTF3BgMX5Qug@mail.gmail.com>
Subject: Re: [PATCH v2 14/17] resource: Move devmem revoke code to resource framework
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
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

On Fri, Oct 9, 2020 at 2:31 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Oct 09, 2020 at 09:59:31AM +0200, Daniel Vetter wrote:
>
> > +struct address_space *iomem_get_mapping(void)
> > +{
> > +     return iomem_inode->i_mapping;
>
> This should pair an acquire with the release below
>
> > +     /*
> > +      * Publish /dev/mem initialized.
> > +      * Pairs with smp_load_acquire() in revoke_iomem().
> > +      */
> > +     smp_store_release(&iomem_inode, inode);
>
> However, this seems abnormal, initcalls rarely do this kind of stuff
> with global data..
>
> The kernel crashes if this fs_initcall is raced with
> iomem_get_mapping() due to the unconditional dereference, so I think
> it can be safely switched to a simple assignment.

Ah yes I checked this all, but forgot to correctly annotate the
iomem_get_mapping access. For reference, see b34e7e298d7a ("/dev/mem:
Add missing memory barriers for devmem_inode").

The reasons for the annotations is that iomem requests can happen
fairly early, way before fs_initcalls happen. That means revoke_iomem
needs to check for that and bail out if we race - nothing bad can
happen since userspace isn't running at this point anyway. And
apparently it needs to be a full acquire fence since we don't just
write a value, but need a barrier for the struct stuff.

Now iomem_get_mapping otoh can only be called after userspace is up &
running, so way after all the fs_initcalls are guaranteed to have
fininshed. Hence we don't really need anything there. But I expect the
kernel race checker thing to complain, plus that then gives me a good
spot to explain why we can't race and don't have to check for a NULL
iomem_inode.

I'll add that in v3.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
