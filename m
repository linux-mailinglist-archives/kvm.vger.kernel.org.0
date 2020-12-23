Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2A72E1D69
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 15:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgLWOVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 09:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgLWOVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 09:21:52 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB12C061793
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 06:21:12 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id q22so23057492eja.2
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 06:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fO2qSmrlcvH/Mg353URhHC+az0KYy8E1wxQsqV9SPRQ=;
        b=W2D1X7Mt84Nb5kPnZCeMlcV6/EJ1C1Kf72P5VIvq1kMLdhbP0M0papBa7+vYe8Wi15
         NPFhxbIqrr0t2ILjWlPDIBukPf+/Tm8P0Qjg82ORwp2ZDQ8kPKOOqHV6YCk+z5HoQQR2
         N/sOA8wASeeWRe+9qMULmc2wP5q8YrthdFPb1yAV9z7fpBgJ+t6sqMkYt1BLGseE6Y93
         WaBOyDYrQ0hCPgaVTBoTSiBOFYk2/A4CbS7rh517lN4Df+DtboPsZNaI8UW09LWwapvl
         TqgC9nhiFXq80Wci02GtFXgyiKs0OkkjlcnKMXffPq68JG/1AH9qixjYGvtbrzeX0dKA
         ophA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fO2qSmrlcvH/Mg353URhHC+az0KYy8E1wxQsqV9SPRQ=;
        b=ZDKyNRWg43opQYaZfayZNdVVirOmM0Ru5oiCtQ8qTwb6ffBDipeditXMqvKgf/cnh1
         chu0Eb5pfH4idID6FTI0cSeboUGgWy90ApRnE5zQGCZASf+bDNsdoUe1d3mF2gsWJ03T
         JwBp7kRyvZUcDmj3bV5sZVYawt5Ho/Wu6bRmzCIYOJLhoURSMK9+sZlRA0Qhy7MX7h3Y
         Wwtcg1pOyNwygAwsdqj/REyOdOlp/PV04idrQZB2vqOiBBJlRk1NdX9scgLL3o3TmfwS
         dfRlYc7gEn0yyr+WXdStA/cBPUNN4EXoQ1ti8NC8eyxoxgR1FZNMfOGP8ebt/v/XlS7Z
         JdFw==
X-Gm-Message-State: AOAM530Lm12vRYB8OgLkbp6GHORGZVYk2EiR1Iw6JFQHH7+k0kGt/YWk
        rlkZ6lFGX927mLJOxXLU3eXwZ6JfP9A6MQzLnCqC
X-Google-Smtp-Source: ABdhPJyDZ7RLosJL1uvsLWRc15zFRYf5SX9dmIgXydDgct+kDOAYD16d+yCEo6mFFoh8eoAMZ1hGPgz68c4IgfcSJZk=
X-Received: by 2002:a17:906:d0c2:: with SMTP id bq2mr24108121ejb.1.1608733270934;
 Wed, 23 Dec 2020 06:21:10 -0800 (PST)
MIME-Version: 1.0
References: <CACycT3vevQQ8cGK_ac-1oyCb9+YPSAhLMue=4J3=2HzXVK7XHw@mail.gmail.com>
 <20201223081324.GA21558@infradead.org>
In-Reply-To: <20201223081324.GA21558@infradead.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 23 Dec 2020 22:21:00 +0800
Message-ID: <CACycT3u=1bBWzAN0w-cNxF7DPjsLw=s=kFVfCnMUCtk0vj81-A@mail.gmail.com>
Subject: Re: [External] Re: [RFC v2 01/13] mm: export zap_page_range() for
 driver use
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 23, 2020 at 4:13 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Dec 23, 2020 at 02:32:07PM +0800, Yongji Xie wrote:
> > Now I want to map/unmap some pages in an userland vma dynamically. The
> > vm_insert_page() is being used for mapping. In the unmapping case, it
> > looks like the zap_page_range() does what I want. So I export it.
> > Otherwise, we need some ways to notify userspace to trigger it with
> > madvise(MADV_DONTNEED), which might not be able to meet all our needs.
> > For example, unmapping some pages in a memory shrinker function.
> >
> > So I'd like to know what's the limitation to use zap_page_range() in a
> > module. And if we can't use it in a module, is there any acceptable
> > way to achieve that?
>
> I think the anser is: don't play funny games with unmapped outside of
> munmap.  Especially as synchronization is very hard to get right.

OK, I will try to let userspace do this.

Thanks,
Yongji
