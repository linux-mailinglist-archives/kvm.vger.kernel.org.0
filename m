Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856962A6D5A
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 20:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgKDTC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 14:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbgKDTCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 14:02:16 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9CCC061A4C
        for <kvm@vger.kernel.org>; Wed,  4 Nov 2020 11:02:16 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id i7so12967770qti.6
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 11:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/UKgc10BslmqBEq+jaLxahr/MEdpryS7jFqE+Dnr3vI=;
        b=HhJHYDe4YHd+/a56BdoqnLrywV6UfuBf/DsyHbP4QvtBlGMcnvi67aThLz1LQnQ9C7
         8EemYt7CTkS9B+W9jO8pXOPnbTizt3Pe9397JG9VN2ZMIG13OJgH9kNFKGqXLgoE3Hzj
         V1vv8lw5Pa9YVxFQjZfe4EOFce5bInYTuWldtvqSVrDDdmTUopOFroR+gBfYNDg6Uuau
         3Jp2luUDv74e1JR/3SaJIovsmPrALIHM4h9v9NFcni+HQF+v8Dr91QTVCCYUEOxMud09
         LLulIis0YmYr2jolcahGS2sbLtv9wbZ7FKZV2VUnjcWsESvH7Lm4q6CoSzm/SgrhfDUT
         xwVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/UKgc10BslmqBEq+jaLxahr/MEdpryS7jFqE+Dnr3vI=;
        b=TNWbkhhmT9dPKWGxxhnZw5iXja2keoyPLktEDtSP/DK585k9OM1h+3D4ySgL0DUoyE
         Dcn2FG0HDLeXcw7BxrqpuE5ss/6dlEgAKv2RG/fFMt7UQzZWUTHkI6MDmrp4JkUIpUWI
         6mhxuG5m9ltp4ikzOZ2332n6iLIwiCByaC1ZtmOSRE0qIEYg1wlSMD3jYhKYLuNE7u7c
         9zDSmqWSrtS/mRjLKKN+AvriC8tanKXsMraWBR4/wHQBedxJ70GiRT6vLdBg0n9hgWKC
         2O7gn9yeRRVjH6DLigtIX/jpq8v2N87bxwGBmFP85l3qrEiz1UmWUGv4lyt/IJZ2X25z
         j7Fw==
X-Gm-Message-State: AOAM531CmULgeNvM5lWastkCgMOJZgTAhY82JD0x84FdhmJLwevnn9YW
        lbb5q1qK3KpfZtJHd6CE+yEDWg==
X-Google-Smtp-Source: ABdhPJx0R0pt2rE5Fh6PKobat9BHCWAKjXRAimq+VPJpufi8x0s4Mnx78kA46TVhPrgcaUAjwr3r5w==
X-Received: by 2002:ac8:5948:: with SMTP id 8mr20543496qtz.215.1604516535414;
        Wed, 04 Nov 2020 11:02:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id h9sm710672qth.78.2020.11.04.11.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 11:02:14 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kaO2w-00Gbbx-2K; Wed, 04 Nov 2020 15:02:14 -0400
Date:   Wed, 4 Nov 2020 15:02:14 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        J??r??me Glisse <jglisse@redhat.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        KVM list <kvm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux MM <linux-mm@kvack.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
Message-ID: <20201104190214.GW36674@ziepe.ca>
References: <7f29a42a-c408-525d-90b7-ef3c12b5826c@nvidia.com>
 <CAKMK7uEw701AWXNJbRNM8Z+FkyUB5FbWegmSzyWPy9cG4W7OLA@mail.gmail.com>
 <20201104140023.GQ36674@ziepe.ca>
 <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
 <20201104162125.GA13007@infradead.org>
 <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
 <20201104163758.GA17425@infradead.org>
 <20201104164119.GA18218@infradead.org>
 <20201104181708.GU36674@ziepe.ca>
 <d3497583-2338-596e-c764-8c571b7d22cf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3497583-2338-596e-c764-8c571b7d22cf@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 10:44:56AM -0800, John Hubbard wrote:
> On 11/4/20 10:17 AM, Jason Gunthorpe wrote:
> > On Wed, Nov 04, 2020 at 04:41:19PM +0000, Christoph Hellwig wrote:
> > > On Wed, Nov 04, 2020 at 04:37:58PM +0000, Christoph Hellwig wrote:
> > > > On Wed, Nov 04, 2020 at 05:26:58PM +0100, Daniel Vetter wrote:
> > > > > What we're discussing is whether gup_fast and pup_fast also obey this,
> > > > > or fall over and can give you the struct page that's backing the
> > > > > dma_mmap_* memory. Since the _fast variant doesn't check for
> > > > > vma->vm_flags, and afaict that's the only thing which closes this gap.
> > > > > And like you restate, that would be a bit a problem. So where's that
> > > > > check which Jason&me aren't spotting?
> > > > 
> > > > remap_pte_range uses pte_mkspecial to set up the PTEs, and gup_pte_range
> > > > errors out on pte_special.  Of course this only works for the
> > > > CONFIG_ARCH_HAS_PTE_SPECIAL case, for other architectures we do have
> > > > a real problem.
> > > 
> > > Except that we don't really support pte-level gup-fast without
> > > CONFIG_ARCH_HAS_PTE_SPECIAL, and in fact all architectures selecting
> > > HAVE_FAST_GUP also select ARCH_HAS_PTE_SPECIAL, so we should be fine.
> > 
> > Mm, I thought it was probably the special flag..
> > 
> > Knowing that CONFIG_HAVE_FAST_GUP can't be set without
> > CONFIG_ARCH_HAS_PTE_SPECIAL is pretty insightful, can we put that in
> > the Kconfig?
> > 
> > config HAVE_FAST_GUP
> >          depends on MMU
> >          depends on ARCH_HAS_PTE_SPECIAL
> >          bool
> > 
> Well, the !CONFIG_ARCH_HAS_PTE_SPECIAL case points out in a comment that
> gup-fast is not *completely* unavailable there, so I don't think you want
> to shut it off like that:
> 
> /*
>  * If we can't determine whether or not a pte is special, then fail immediately
>  * for ptes. Note, we can still pin HugeTLB and THP as these are guaranteed not
>  * to be special.
>  *
>  * For a futex to be placed on a THP tail page, get_futex_key requires a
>  * get_user_pages_fast_only implementation that can pin pages. Thus it's still
>  * useful to have gup_huge_pmd even if we can't operate on ptes.
>  */

I saw that once and I really couldn't make sense of it..
What use is having futex's that only work on THP pages? Confused

CH said there was no case of HAVE_FAST_GUP !ARCH_HAS_PTE_SPECIAL, is
one hidden someplace then?

Jason
