Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD51C2AB2A8
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 09:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgKIIoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 03:44:46 -0500
Received: from mga06.intel.com ([134.134.136.31]:5481 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgKIIop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 03:44:45 -0500
IronPort-SDR: Qs8cHwYvmGnic3fcikFX1xyYzk+48O3hIDKyyHuMP/R7n6yYh3j7A6Y/9L2c1W6sMXAXbBUBl+
 fosXP9MpGzrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="231401659"
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="231401659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 00:44:45 -0800
IronPort-SDR: IfG8q/sA5EMlyMjSvfUVNc+EaAlzDVZgRGJpX0K7ztOK0lomesX1KEuchnWCGhkYW9POxwry58
 wHJVsBh0G9fA==
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="540750920"
Received: from sfhansen-mobl.ger.corp.intel.com ([10.249.254.141])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 00:44:40 -0800
Message-ID: <504d77b87c81b7027157e0c7b5286e17123c59d9.camel@linux.intel.com>
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
From:   Thomas =?ISO-8859-1?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Daniel Vetter <daniel@ffwll.ch>
Cc:     John Hubbard <jhubbard@nvidia.com>,
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
Date:   Mon, 09 Nov 2020 09:44:02 +0100
In-Reply-To: <20201106125505.GO36674@ziepe.ca>
References: <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
         <20201104163758.GA17425@infradead.org>
         <20201104164119.GA18218@infradead.org> <20201104181708.GU36674@ziepe.ca>
         <d3497583-2338-596e-c764-8c571b7d22cf@nvidia.com>
         <20201105092524.GQ401619@phenom.ffwll.local>
         <20201105124950.GZ36674@ziepe.ca>
         <7ae3486d-095e-cf4e-6b0f-339d99709996@nvidia.com>
         <CAKMK7uGRw=xXE+D=JJsNeRav9+hdO4tcDSvDbAuWfc3T4VkoJw@mail.gmail.com>
         <CAKMK7uFb2uhfRCwe1y5Kafd-WWqE_F3_FfpHR9f8-X-aHhgjOQ@mail.gmail.com>
         <20201106125505.GO36674@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-11-06 at 08:55 -0400, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2020 at 11:27:59AM +0100, Daniel Vetter wrote:
> > On Fri, Nov 6, 2020 at 11:01 AM Daniel Vetter <daniel@ffwll.ch>
> > wrote:
> > > On Fri, Nov 6, 2020 at 5:08 AM John Hubbard <jhubbard@nvidia.com>
> > > wrote:
> > > > On 11/5/20 4:49 AM, Jason Gunthorpe wrote:
> > > > > On Thu, Nov 05, 2020 at 10:25:24AM +0100, Daniel Vetter
> > > > > wrote:
> > > > > > > /*
> > > > > > >   * If we can't determine whether or not a pte is
> > > > > > > special, then fail immediately
> > > > > > >   * for ptes. Note, we can still pin HugeTLB and THP as
> > > > > > > these are guaranteed not
> > > > > > >   * to be special.
> > > > > > >   *
> > > > > > >   * For a futex to be placed on a THP tail page,
> > > > > > > get_futex_key requires a
> > > > > > >   * get_user_pages_fast_only implementation that can pin
> > > > > > > pages. Thus it's still
> > > > > > >   * useful to have gup_huge_pmd even if we can't operate
> > > > > > > on ptes.
> > > > > > >   */
> > > > > > 
> > > > > > We support hugepage faults in gpu drivers since recently,
> > > > > > and I'm not
> > > > > > seeing a pud_mkhugespecial anywhere. So not sure this
> > > > > > works, but probably
> > > > > > just me missing something again.
> > > > > 
> > > > > It means ioremap can't create an IO page PUD, it has to be
> > > > > broken up.
> > > > > 
> > > > > Does ioremap even create anything larger than PTEs?
> > > 
> > > gpu drivers also tend to use vmf_insert_pfn* directly, so we can
> > > do
> > > on-demand paging and move buffers around. From what I glanced for
> > > lowest level we to the pte_mkspecial correctly (I think I
> > > convinced
> > > myself that vm_insert_pfn does that), but for pud/pmd levels it
> > > seems
> > > just yolo.
> > 
> > So I dug around a bit more and ttm sets PFN_DEV | PFN_MAP to get
> > past
> > the various pft_t_devmap checks (see e.g.
> > vmf_insert_pfn_pmd_prot()).
> > x86-64 has ARCH_HAS_PTE_DEVMAP, and gup.c seems to handle these
> > specially, but frankly I got totally lost in what this does.
> 
> The fact vmf_insert_pfn_pmd_prot() has all those BUG_ON's to prevent
> putting VM_PFNMAP pages into the page tables seems like a big red
> flag.
> 
> The comment seems to confirm what we are talking about here:
> 
> 	/*
> 	 * If we had pmd_special, we could avoid all these
> restrictions,
> 	 * but we need to be consistent with PTEs and architectures
> that
> 	 * can't support a 'special' bit.
> 	 */
> 
> ie without the ability to mark special we can't block fast gup and
> anyone who does O_DIRECT on these ranges will crash the kernel when
> it
> tries to convert a IO page into a struct page.
> 
> Should be easy enough to directly test?
> 
> Putting non-struct page PTEs into a VMA without setting VM_PFNMAP
> just
> seems horribly wrong to me.

Although core mm special huge-page support is currently quite limited,
some time ago, I extended the pre-existing vma_is_dax() to
vma_is_special_huge():

/**
 * vma_is_special_huge - Are transhuge page-table entries considered
special?
 * @vma: Pointer to the struct vm_area_struct to consider
 *
 * Whether transhuge page-table entries are considered "special"
following
 * the definition in vm_normal_page().
 *
 * Return: true if transhuge page-table entries should be considered
special,
 * false otherwise.
 */
static inline bool vma_is_special_huge(const struct vm_area_struct
*vma)
{
	return vma_is_dax(vma) || (vma->vm_file &&
				   (vma->vm_flags & (VM_PFNMAP |
VM_MIXEDMAP)));
}

meaning that currently all transhuge page-table-entries in a PFNMAP or
MIXEDMAP vma are considered "special". The number of calls to this
function (mainly in the page-splitting code) is quite limited so
replacing it with a more elaborate per-page-table-entry scheme would, I
guess, definitely be possible. Although all functions using it would
need to require a fallback path for architectures not supporting it.

/Thomas



> 
> Jason

