Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971882A9683
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 13:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbgKFMzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 07:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbgKFMzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 07:55:07 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626D1C0613D4
        for <kvm@vger.kernel.org>; Fri,  6 Nov 2020 04:55:07 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id i21so865129qka.12
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 04:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y9u4GqsYFp3yQokc1modUW8kbXKOkRHXB2lqruGcudE=;
        b=VKArHGzBXh6z/A+MygU+amo68YTqsv8wcX06tMjQJtSaCh73j9dK84DDYNiOFbWqbG
         oWPby5Nt17abP3CNuT4Y8hOrMF9IphjmFlJ+1LFTGZJslKxvYBCkSQrvO11j5gLNPiyD
         dVfekpRDt0jU+YzoaecvEZ4LCFhH+XfiNy4waUk/+nEQ0mmuEpuYBI6Uswsojiaa1B6R
         4eHm926I6a27i5ah9cJ5gtV9zfeyLjLkJD44KWC+QIdKscIOwG27BP9X+Qsw/8/Tj3Ln
         mUTJhpKjLu76fxGa66zDAX1JckZqgFcVUxJppOLi4JuOkrAZQ52ZBCQ/Pp5o1ft2CM/4
         MpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y9u4GqsYFp3yQokc1modUW8kbXKOkRHXB2lqruGcudE=;
        b=LTTGmC4HpuS21g1G/IZhBF3F02410LKmAaG3+bayZ8HTV+mO+vV6UpHFnJ9gIdv9vA
         GtPgiqMWCHzZfQI9Zjc4b0dLHO2r2gF9pE91rT8mjxKtoTltiPrzCzsQbedEmNLPjdF3
         0MRaToJ9xH6r/5sJOXbJoMLcuJsvSEdKa7RNITDFgx9r+Rk5Q19y2lfykvPVjyh1Dq7I
         cqAU3eUYRr4Eqr/EKisV5xo4kud8hs/QNHErxmGaS9auglFFkd9WC1cdLL/3kEeihpyW
         H3XERJQqAboLZUlC/KRxgDShqQ7tf4NSvOIji8+p+nw+QswoFI+gTMrHOfF/IzGk8O3z
         pnmw==
X-Gm-Message-State: AOAM532oSzVs1maVbZBF+sa0TX1sUnaC4ONBnRNtF4n81sjH5yzTAqWm
        7oMzhQEelMuIo9w3CAJKPvZAvA==
X-Google-Smtp-Source: ABdhPJypDSdSDlm1WvWqsV5KWCBdZzp9Y89hHRIKGgXQ8bDqOzWA3qxmMNugSM6RB0Bn+AiihIdxtQ==
X-Received: by 2002:a37:7d84:: with SMTP id y126mr1335251qkc.36.1604667306647;
        Fri, 06 Nov 2020 04:55:06 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id y187sm408537qka.116.2020.11.06.04.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 04:55:05 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kb1Gj-000lY1-5o; Fri, 06 Nov 2020 08:55:05 -0400
Date:   Fri, 6 Nov 2020 08:55:05 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <20201106125505.GO36674@ziepe.ca>
References: <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
 <20201104163758.GA17425@infradead.org>
 <20201104164119.GA18218@infradead.org>
 <20201104181708.GU36674@ziepe.ca>
 <d3497583-2338-596e-c764-8c571b7d22cf@nvidia.com>
 <20201105092524.GQ401619@phenom.ffwll.local>
 <20201105124950.GZ36674@ziepe.ca>
 <7ae3486d-095e-cf4e-6b0f-339d99709996@nvidia.com>
 <CAKMK7uGRw=xXE+D=JJsNeRav9+hdO4tcDSvDbAuWfc3T4VkoJw@mail.gmail.com>
 <CAKMK7uFb2uhfRCwe1y5Kafd-WWqE_F3_FfpHR9f8-X-aHhgjOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFb2uhfRCwe1y5Kafd-WWqE_F3_FfpHR9f8-X-aHhgjOQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 11:27:59AM +0100, Daniel Vetter wrote:
> On Fri, Nov 6, 2020 at 11:01 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > On Fri, Nov 6, 2020 at 5:08 AM John Hubbard <jhubbard@nvidia.com> wrote:
> > >
> > > On 11/5/20 4:49 AM, Jason Gunthorpe wrote:
> > > > On Thu, Nov 05, 2020 at 10:25:24AM +0100, Daniel Vetter wrote:
> > > >>> /*
> > > >>>   * If we can't determine whether or not a pte is special, then fail immediately
> > > >>>   * for ptes. Note, we can still pin HugeTLB and THP as these are guaranteed not
> > > >>>   * to be special.
> > > >>>   *
> > > >>>   * For a futex to be placed on a THP tail page, get_futex_key requires a
> > > >>>   * get_user_pages_fast_only implementation that can pin pages. Thus it's still
> > > >>>   * useful to have gup_huge_pmd even if we can't operate on ptes.
> > > >>>   */
> > > >>
> > > >> We support hugepage faults in gpu drivers since recently, and I'm not
> > > >> seeing a pud_mkhugespecial anywhere. So not sure this works, but probably
> > > >> just me missing something again.
> > > >
> > > > It means ioremap can't create an IO page PUD, it has to be broken up.
> > > >
> > > > Does ioremap even create anything larger than PTEs?
> >
> > gpu drivers also tend to use vmf_insert_pfn* directly, so we can do
> > on-demand paging and move buffers around. From what I glanced for
> > lowest level we to the pte_mkspecial correctly (I think I convinced
> > myself that vm_insert_pfn does that), but for pud/pmd levels it seems
> > just yolo.
> 
> So I dug around a bit more and ttm sets PFN_DEV | PFN_MAP to get past
> the various pft_t_devmap checks (see e.g. vmf_insert_pfn_pmd_prot()).
> x86-64 has ARCH_HAS_PTE_DEVMAP, and gup.c seems to handle these
> specially, but frankly I got totally lost in what this does.

The fact vmf_insert_pfn_pmd_prot() has all those BUG_ON's to prevent
putting VM_PFNMAP pages into the page tables seems like a big red
flag.

The comment seems to confirm what we are talking about here:

	/*
	 * If we had pmd_special, we could avoid all these restrictions,
	 * but we need to be consistent with PTEs and architectures that
	 * can't support a 'special' bit.
	 */

ie without the ability to mark special we can't block fast gup and
anyone who does O_DIRECT on these ranges will crash the kernel when it
tries to convert a IO page into a struct page.

Should be easy enough to directly test?

Putting non-struct page PTEs into a VMA without setting VM_PFNMAP just
seems horribly wrong to me.

Jason
