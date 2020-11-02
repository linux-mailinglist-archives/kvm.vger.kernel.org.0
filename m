Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A672A2B21
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 14:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgKBNBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 08:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbgKBNBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 08:01:19 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3929C0617A6
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 05:01:17 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id l2so11365936qkf.0
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 05:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ywfiDbg6XCEWmoBx9eC29OtR/MyEWOW93XTelnAXaBk=;
        b=ir3GR39YhTRDVVIubqbd2b6fYJQqoYzGlGzQhJGPgx/IpIwERjn3x6j0FKgwPju8tJ
         K346RwtLd1HrF6IYofhsCSTJj3QK+10oMg2YllJh/KpA3n62CbFQnKL6ivWZ5KZSOniq
         QwLvLlA6x1j/aJc2hKzXChvGjpbbw6GWq/KNk/8R9NhESFTt0yrJ0KQKjkdmTuloLwW/
         Zwps2gbtqPniuVum2Pfu8S68SKxWxd0HMyfFBAbv4qCeVCCuOZxQnUab9RNI4DYrsJao
         v2N/I2zDZif6Md4+OJsi4IvpXjI5tOvsKPLa0IKjhrcIMk4ZoUB68GDdMIbIvaBwF1NM
         /xmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ywfiDbg6XCEWmoBx9eC29OtR/MyEWOW93XTelnAXaBk=;
        b=kAPTlNZJh0t6yniGNjLgRBlahzzDBNGk5lEQ5lOdUJqRuklljLmdjiJ/V7WO4XuX/y
         hmkqqSLZQpIw3SJeHgBHs9r14qLyGwTtCqEu1sxR1BJom0rQde6Jl6RQQQp2YVBDA0K0
         EFAM5Jdrs9F5w4KtZUFu/mwvkcbzODwVjWCrse6l8XW5oDB/+mei29rRAs5Z/LyLj4W6
         Ir+43e8fCF9AJga4eX9w5uBSmXUtixZpmRT6Nna7tbbQLoserbd2CZPpb/vBaTJWxLoF
         6H0naMU5ddf6ZJBvd01TzYXFIvoRNpKgRH4DZt7DjZriSfBQsSNaI6IAuNJVhXhHyA/Q
         uklQ==
X-Gm-Message-State: AOAM532W0wEnzJQXqZpvNUUX3/IHn/kk51Z9KoOegFR6qhVC5bST1PQ9
        K/iZUcstaYl0pxQN8q2v+qrfdw==
X-Google-Smtp-Source: ABdhPJzRrsH3Zfgny2Ycg3bBy2Q+SuhdpwI09cYL0ZnBVzwrgv7GmXDFxfx3kiLU2YMRfbo6u8i3PQ==
X-Received: by 2002:a37:8c41:: with SMTP id o62mr13561782qkd.240.1604322076971;
        Mon, 02 Nov 2020 05:01:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id b8sm7742829qkn.133.2020.11.02.05.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 05:01:16 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kZZSV-00EvRo-QJ; Mon, 02 Nov 2020 09:01:15 -0400
Date:   Mon, 2 Nov 2020 09:01:15 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Christoph Hellwig <hch@infradead.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        J??r??me Glisse <jglisse@redhat.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 08/15] mm: Add unsafe_follow_pfn
Message-ID: <20201102130115.GC36674@ziepe.ca>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
 <20201030100815.2269-9-daniel.vetter@ffwll.ch>
 <20201102072931.GA16419@infradead.org>
 <CAKMK7uEe5FQuukYU7RhL90ttC9XyWw6wvdQrZ2JpP0jpbYTO6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEe5FQuukYU7RhL90ttC9XyWw6wvdQrZ2JpP0jpbYTO6g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 01:56:10PM +0100, Daniel Vetter wrote:
> On Mon, Nov 2, 2020 at 8:29 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Fri, Oct 30, 2020 at 11:08:08AM +0100, Daniel Vetter wrote:
> > > Also mark up follow_pfn as EXPORT_SYMBOL_GPL. The only safe way to use
> > > that by drivers/modules is together with an mmu_notifier, and that's
> > > all _GPL stuff.
> >
> > I also think it also needs to be renamed to explicitly break any existing
> > users out of tree or int the submission queue.
> 
> Ok I looked at the mmu notifier locking again and noticed that
> mm->subscriptions has its own spinlock. Since there usually shouldn't
> be a huge pile of these I think it's feasible to check for the mmu
> notifier in follow_pfn. And that would stuff this gap for good. I'll
> throw that on top as a final patch and see what people think.

Probably the simplest is to just check mm_has_notifiers() when in
lockdep or something very simple like that

Jason
