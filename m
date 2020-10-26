Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E5029862E
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 05:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421503AbgJZEl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 00:41:29 -0400
Received: from casper.infradead.org ([90.155.50.34]:60048 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1421493AbgJZEl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 00:41:29 -0400
X-Greylist: delayed 1130 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 00:41:28 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qSdqOixYcTUUWwPEY+kW4kk0m43pmokWNe8HgQoh+Ek=; b=UjxXxgVyzDFJIFVUSt9bdjzayX
        iefTgd/ZqSsTt0Pm3HkL3ybwrwP1hcOChcgDH/U+DMrXwKwhQAGqs0Bi1w08k2Sp8nxYtL4hNr2J+
        LgFvKiFSWF6V6uaEaoSJshFx1xYOth5YCvDywB1SiT/jlkjTasm+tnGVT7G895IApb2RbxKXtxRXP
        Iqz4miNMTI0QfosAQ4ChTCvOxFuMMLl5MVf+QT+bPQHtZCAgdZZOR85cr9aT3e3UnzU5cZNff87K3
        pmeEb1GxbLjRDv+7sGfK/h7uff2Z/JmyX5GZjGCdHn5iklW1/GSzwqsp4hAiERiEEOHTD+HtYHzoN
        R8/as70A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWu19-00078M-0i; Mon, 26 Oct 2020 04:21:59 +0000
Date:   Mon, 26 Oct 2020 04:21:58 +0000
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
Message-ID: <20201026042158.GN20115@casper.infradead.org>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
 <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
 <20201022114946.GR20115@casper.infradead.org>
 <30ce6691-fd70-76a2-8b61-86d207c88713@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30ce6691-fd70-76a2-8b61-86d207c88713@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 22, 2020 at 12:58:14PM -0700, John Hubbard wrote:
> On 10/22/20 4:49 AM, Matthew Wilcox wrote:
> > On Tue, Oct 20, 2020 at 01:25:59AM -0700, John Hubbard wrote:
> > > Should copy_to_guest() use pin_user_pages_unlocked() instead of gup_unlocked?
> > > We wrote a  "Case 5" in Documentation/core-api/pin_user_pages.rst, just for this
> > > situation, I think:
> > > 
> > > 
> > > CASE 5: Pinning in order to write to the data within the page
> > > -------------------------------------------------------------
> > > Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
> > > write to a page's data, unpin" can cause a problem. Case 5 may be considered a
> > > superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
> > > other words, if the code is neither Case 1 nor Case 2, it may still require
> > > FOLL_PIN, for patterns like this:
> > > 
> > > Correct (uses FOLL_PIN calls):
> > >      pin_user_pages()
> > >      write to the data within the pages
> > >      unpin_user_pages()
> > 
> > Case 5 is crap though.  That bug should have been fixed by getting
> > the locking right.  ie:
> > 
> > 	get_user_pages_fast();
> > 	lock_page();
> > 	kmap();
> > 	set_bit();
> > 	kunmap();
> > 	set_page_dirty()
> > 	unlock_page();
> > 
> > I should have vetoed that patch at the time, but I was busy with other things.
> 
> It does seem like lock_page() is better, for now at least, because it
> forces the kind of synchronization with file system writeback that is
> still yet to be implemented for pin_user_pages().
> 
> Long term though, Case 5 provides an alternative way to do this
> pattern--without using lock_page(). Also, note that Case 5, *in
> general*, need not be done page-at-a-time, unlike the lock_page()
> approach. Therefore, Case 5 might potentially help at some call sites,
> either for deadlock avoidance or performance improvements.
> 
> In other words, once the other half of the pin_user_pages() plan is
> implemented, either of these approaches should work.
> 
> Or, are you thinking that there is never a situation in which Case 5 is
> valid?

I don't think the page pinning approach is ever valid.  For file
mappings, the infiniband registration should take a lease on the inode,
blocking truncation.  DAX shouldn't be using struct pages at all, so
there shouldn't be anything there to pin.

It's been five years since DAX was merged, and page pinning still
doesn't work.  How much longer before the people who are pushing it
realise that it's fundamentally flawed?
