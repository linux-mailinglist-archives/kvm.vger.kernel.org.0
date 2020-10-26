Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B233D298DDE
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1774855AbgJZN3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 09:29:15 -0400
Received: from casper.infradead.org ([90.155.50.34]:39728 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1774827AbgJZN3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=34Y6r4GAweG7Mt/E2/mBFuI95NWQikkATWq3rx/SY8E=; b=ibm1wh4V//Ao40finn9v+c/DR0
        WKib4xCrTtJVXIcaYUSJ1zU9hxgEEylo/MOwv+q5ZiA8y+g2DZLWIzl8wDZgPrphU363e/eovSkbe
        wa8+Q/VSuBNCwj2sFg7XcOvhFS/EE0Svh1QiUwmtbID0haANDZN3FPixUgMNfP2TKAwyB7du+BqX3
        57Zm9kGjWCqnlE1u6dMQSnpHdc1Q3QeMZ4MsfZ5NFLADi86YvqhE8PZsiwcstdJ9d6eQLLgTALS2D
        qTsGz1vLwcBqGa+R08Uhn6VTC1hgBXjQz19Ryi4baKdQnioISiyXvnUwX4F1y7aH0k8+ydR8NXeyq
        T3YFjdTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kX2Y2-000704-4d; Mon, 26 Oct 2020 13:28:30 +0000
Date:   Mon, 26 Oct 2020 13:28:30 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20201026132830.GQ20115@casper.infradead.org>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
 <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
 <20201022114946.GR20115@casper.infradead.org>
 <30ce6691-fd70-76a2-8b61-86d207c88713@nvidia.com>
 <20201026042158.GN20115@casper.infradead.org>
 <ee308d1d-8762-6bcf-193e-85fea29743c3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee308d1d-8762-6bcf-193e-85fea29743c3@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 25, 2020 at 09:44:07PM -0700, John Hubbard wrote:
> On 10/25/20 9:21 PM, Matthew Wilcox wrote:
> > I don't think the page pinning approach is ever valid.  For file
> 
> Could you qualify that? Surely you don't mean that the entire pin_user_pages
> story is a waste of time--I would have expected you to make more noise
> earlier if you thought that, yes?

I do think page pinning is the wrong approach for everything.  I did say
so at the time, and I continue to say so when the opportunity presents
itself.  But shouting about it constantly only annoys people, so I don't
generally bother.  I have other things to work on, and they're productive,
so I don't need to spend my time arguing.

> > It's been five years since DAX was merged, and page pinning still
> > doesn't work.  How much longer before the people who are pushing it
> > realise that it's fundamentally flawed?
> 
> Is this a separate rant about *only* DAX, or is general RDMA in your sights
> too? :)

This is a case where it's not RDMA's _fault_ that there's no good API
for it to do what it needs to do.  There's a lot of work needed to wean
Linux device drivers off their assumption that there's a struct page
for every byte of memory.
