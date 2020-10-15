Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FD028EDED
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 09:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgJOHw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 03:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgJOHw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Oct 2020 03:52:57 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB35C0613D4
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 00:52:57 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id h10so2159426oie.5
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 00:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhgu0dLDhdQohJO0sNuXaA2MoyXlGux/K8QZDPyJw6s=;
        b=NQD+qENEedFTKTlCD6h9DOFh4k6HLUd6xx7kkg5MeHaBwzG9gVFDzGcXE0xF2GmrJD
         dLMqZcDoQnkhUjU4yMSE+zE4g//7Vq4+UQwWv9N7H2FoDKlMxRcCLi7ps+MFAHdaZ3wK
         m9vmqDW1HLA7Gqj0yGcpzsjCUkgy10konM9bI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhgu0dLDhdQohJO0sNuXaA2MoyXlGux/K8QZDPyJw6s=;
        b=NIblww9arVUHlKVrgj2RAO3bI082sJVD1UsFBRz1hLx/8gaJQf6y7LDPQr1jL+iSzU
         QQE1XB+t3oYWKF3d5jmc702Xj11+XRAsTLsoN3YBKn8aW2XTrfk+7Gtz7rVJLkNnEOrO
         AOWAQ1UR/3wZ5UaAk+bzlC2VKi3VQrxL5VQsIGzYLdg0pq04vGDlOHpcCYyAWeIX+Ae8
         nC9wOQg8lx+ljh7vEyRChw8ZNhckbFHi0ZyCTD0JlfyzJBGBRCf9fAYgZB4mouoAiJSz
         d7gmh9FrglmSqEWU7HiKS+IL56IPzZkxpcl4MhtWNj6YmvsvQf1BC6WBRuW7fVja7Bmu
         NiQw==
X-Gm-Message-State: AOAM531/rQ/jpUNny0++kKsi49gvThPNl07xCzLcNtH1yfq3lPtFUk6E
        oDbt/VrVYpmT7uoyNs6qas5qpwfeXLhGzkXAYo+vwg==
X-Google-Smtp-Source: ABdhPJwzY298KqMl0piyY6WC1v3Jsl2LfZBMZXpCc0fBF/BMSEZT1UgqTE6Ob3TXXLbgq4lcb2cTsJzeh8/K8Jd2l54=
X-Received: by 2002:aca:6083:: with SMTP id u125mr1369147oib.14.1602748376570;
 Thu, 15 Oct 2020 00:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-15-daniel.vetter@ffwll.ch> <20201009123109.GO5177@ziepe.ca>
 <CAKMK7uFpPP-Q0jC0vM7vYPEcg0m4NzTw+Ld=swdTF3BgMX5Qug@mail.gmail.com>
 <20201009143209.GS5177@ziepe.ca> <CAPcyv4j54O8ac6WB3LEeNud2r11V26gA0PRKK9bhyEMF67AXtQ@mail.gmail.com>
 <20201015000939.GD6763@ziepe.ca>
In-Reply-To: <20201015000939.GD6763@ziepe.ca>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 15 Oct 2020 09:52:45 +0200
Message-ID: <CAKMK7uGu8yWRAGZX-dz-sXHsGufXKm003J5zuQr2AwNMG4+DUw@mail.gmail.com>
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

On Thu, Oct 15, 2020 at 2:09 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Oct 09, 2020 at 11:28:54AM -0700, Dan Williams wrote:
> > On Fri, Oct 9, 2020 at 7:32 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Fri, Oct 09, 2020 at 04:24:45PM +0200, Daniel Vetter wrote:
> > > > On Fri, Oct 9, 2020 at 2:31 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > >
> > > > > On Fri, Oct 09, 2020 at 09:59:31AM +0200, Daniel Vetter wrote:
> > > > >
> > > > > > +struct address_space *iomem_get_mapping(void)
> > > > > > +{
> > > > > > +     return iomem_inode->i_mapping;
> > > > >
> > > > > This should pair an acquire with the release below
> > > > >
> > > > > > +     /*
> > > > > > +      * Publish /dev/mem initialized.
> > > > > > +      * Pairs with smp_load_acquire() in revoke_iomem().
> > > > > > +      */
> > > > > > +     smp_store_release(&iomem_inode, inode);
> > > > >
> > > > > However, this seems abnormal, initcalls rarely do this kind of stuff
> > > > > with global data..
> > > > >
> > > > > The kernel crashes if this fs_initcall is raced with
> > > > > iomem_get_mapping() due to the unconditional dereference, so I think
> > > > > it can be safely switched to a simple assignment.
> > > >
> > > > Ah yes I checked this all, but forgot to correctly annotate the
> > > > iomem_get_mapping access. For reference, see b34e7e298d7a ("/dev/mem:
> > > > Add missing memory barriers for devmem_inode").
> > >
> > > Oh yikes, so revoke_iomem can run concurrently during early boot,
> > > tricky.
> >
> > It runs early because request_mem_region() can run before fs_initcall.
> > Rather than add an unnecessary lock just arrange for the revoke to be
> > skipped before the inode is initialized. The expectation is that any
> > early resource reservations will block future userspace mapping
> > attempts.
>
> Actually, on this point a simple WRITE_ONCE/READ_ONCE pairing is OK,
> Paul once explained that the pointer chase on the READ_ONCE side is
> required to be like an acquire - this is why rcu_dereference is just
> READ_ONCE

Indeed this changed with the sm_read_barrier_depends() removal a year
ago. Before that READ_ONCE and rcu_dereference where not actually the
same. I guess I'll throw a patch on top to switch that over too.
-Daniel




--
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
