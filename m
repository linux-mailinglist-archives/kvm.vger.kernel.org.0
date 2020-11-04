Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70312A6C90
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 19:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbgKDSRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 13:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKDSRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 13:17:10 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A02C0613D3
        for <kvm@vger.kernel.org>; Wed,  4 Nov 2020 10:17:10 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id p12so5525851qtp.7
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 10:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0IlAXzxWFTQTUuhmHtEVnKs2xhR6KwI7WPZxiLpUe5M=;
        b=nBv9S+jwc5JdfLlq4RL/YRGMRQsYfNmjawGrU9GxIfERfAzcpQgZP7hrv69Mesc6M+
         quTXVEbUxyGRkpm9rbsP8azSm9DhVnbhxJgRfZltG0yrlTEb9tUc276PX/VzeI4+sRFb
         4r/IU25uiRBU2ueg3BK2D1b5dzTlQrhsuR29PTFyGpgIBwSarkIUR8LSQBS70hi2P/nX
         3m9r9pQVhoUF1DKe/otBAG1Rv7Kcrglv3VfUI2ehd7bNrMEt5ljYuJ0XfoYPWDc7w4EG
         xr2aRwLmdjA9s+hlno1U0yOoQqyB/mpuAfQuUyKvK6M+DNWEL6fkUm6gwdGKM5MFyxPD
         3ciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0IlAXzxWFTQTUuhmHtEVnKs2xhR6KwI7WPZxiLpUe5M=;
        b=kw3nmguh/FR7tabWG6+4HqIpXZ86LpS29oG3h1mUmfB7q2Bu3rNP4cNj7DOBTb9VWs
         wifaIXJPLWxr2r+7kwtbVAGJ4oj6+i1U99A1gEKYlots0Zs0/3vYQwbyP/vtx3/fZCfr
         vqRerP+d6Mb70WnorGY5FRy43rYCjjg68anWDekHcoqBXsui16xFerSDbdMVTk4Axqif
         1k/GG9wDX3Ld1m9TwKucCfXdGNXDzC3W0kegNpCRTCzDy0RKD2GaHwiCO/ifhTL0SHoZ
         MilnrbeLPmIRCiHL0z4zPFcl2lyYt9O3i7xPk0+LeGhSnf/E5fpvu4JghnpQ93EZby85
         p7+g==
X-Gm-Message-State: AOAM532DqzuUCBzJGwNkDJvRvPEPLUlEgzS26pP94/vSBVgGKhW09joK
        R9H+fbcI51gI5ZcGIc3UcJnZwA==
X-Google-Smtp-Source: ABdhPJzbeLbokY3xWw1ad4Wlq96Bw2Ur+AXtnppBcNVDAcKLM++yGsaQXPWFUe04HeoITS7ilZQ2EA==
X-Received: by 2002:ac8:590c:: with SMTP id 12mr12840139qty.28.1604513829572;
        Wed, 04 Nov 2020 10:17:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id a30sm701698qtn.55.2020.11.04.10.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 10:17:08 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kaNLI-00GaUi-BN; Wed, 04 Nov 2020 14:17:08 -0400
Date:   Wed, 4 Nov 2020 14:17:08 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        J??r??me Glisse <jglisse@redhat.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        KVM list <kvm@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
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
Message-ID: <20201104181708.GU36674@ziepe.ca>
References: <1f7cf690-35e2-c56f-6d3f-94400633edd2@nvidia.com>
 <CAKMK7uFYDSqnNp_xpohzCEidw_iLufNSoX4v55sNZj-nwTckSg@mail.gmail.com>
 <7f29a42a-c408-525d-90b7-ef3c12b5826c@nvidia.com>
 <CAKMK7uEw701AWXNJbRNM8Z+FkyUB5FbWegmSzyWPy9cG4W7OLA@mail.gmail.com>
 <20201104140023.GQ36674@ziepe.ca>
 <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
 <20201104162125.GA13007@infradead.org>
 <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
 <20201104163758.GA17425@infradead.org>
 <20201104164119.GA18218@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104164119.GA18218@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 04:41:19PM +0000, Christoph Hellwig wrote:
> On Wed, Nov 04, 2020 at 04:37:58PM +0000, Christoph Hellwig wrote:
> > On Wed, Nov 04, 2020 at 05:26:58PM +0100, Daniel Vetter wrote:
> > > What we're discussing is whether gup_fast and pup_fast also obey this,
> > > or fall over and can give you the struct page that's backing the
> > > dma_mmap_* memory. Since the _fast variant doesn't check for
> > > vma->vm_flags, and afaict that's the only thing which closes this gap.
> > > And like you restate, that would be a bit a problem. So where's that
> > > check which Jason&me aren't spotting?
> > 
> > remap_pte_range uses pte_mkspecial to set up the PTEs, and gup_pte_range
> > errors out on pte_special.  Of course this only works for the
> > CONFIG_ARCH_HAS_PTE_SPECIAL case, for other architectures we do have
> > a real problem.
> 
> Except that we don't really support pte-level gup-fast without
> CONFIG_ARCH_HAS_PTE_SPECIAL, and in fact all architectures selecting
> HAVE_FAST_GUP also select ARCH_HAS_PTE_SPECIAL, so we should be fine.

Mm, I thought it was probably the special flag..

Knowing that CONFIG_HAVE_FAST_GUP can't be set without
CONFIG_ARCH_HAS_PTE_SPECIAL is pretty insightful, can we put that in
the Kconfig?

config HAVE_FAST_GUP
        depends on MMU
        depends on ARCH_HAS_PTE_SPECIAL
        bool

?

Jason
