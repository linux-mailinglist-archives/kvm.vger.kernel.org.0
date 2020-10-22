Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C98295DC2
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 13:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897588AbgJVLuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 07:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503592AbgJVLuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 07:50:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5720FC0613CE;
        Thu, 22 Oct 2020 04:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DbTniUlZ4cwQM5ojHgxz8WDCNPislMvGHePJYXv0WFc=; b=GEQUyOt0iJvv6z1z8sIv1u4YRi
        Kqh9xlCiWPOrKtlvbhdgrd+48/6sHrI9oZSW9MxmycXAtVGxDgJuP4GoVzZIlLUpxiVvL0cHRPZlZ
        7dhWqV0fi8fF8JQtc4d7CJwUzvLEDH5ypBGSh3VPXM3JqBsETKQrCaRhNH2MKTw8SL9IzQvvASo4H
        Cw3M8+dEEG5Df8C+0cIG64wULnpVwQDF6AD6mxEvi65kPhWUgJaYiGsgDSBRbyFq7Id68Y9flS7Ax
        7asD+3Xsusg3Vstvm8yLW2msEIcQzmAP/GN7hPhMevkLOPsb/H4VoeHWJFxd0uud18Bzk4iIeaIYD
        2BQtVOKQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVZ6I-00078x-4X; Thu, 22 Oct 2020 11:49:46 +0000
Date:   Thu, 22 Oct 2020 12:49:46 +0100
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
Message-ID: <20201022114946.GR20115@casper.infradead.org>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
 <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 01:25:59AM -0700, John Hubbard wrote:
> Should copy_to_guest() use pin_user_pages_unlocked() instead of gup_unlocked?
> We wrote a  "Case 5" in Documentation/core-api/pin_user_pages.rst, just for this
> situation, I think:
> 
> 
> CASE 5: Pinning in order to write to the data within the page
> -------------------------------------------------------------
> Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
> write to a page's data, unpin" can cause a problem. Case 5 may be considered a
> superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
> other words, if the code is neither Case 1 nor Case 2, it may still require
> FOLL_PIN, for patterns like this:
> 
> Correct (uses FOLL_PIN calls):
>     pin_user_pages()
>     write to the data within the pages
>     unpin_user_pages()

Case 5 is crap though.  That bug should have been fixed by getting
the locking right.  ie:

	get_user_pages_fast();
	lock_page();
	kmap();
	set_bit();
	kunmap();
	set_page_dirty()
	unlock_page();

I should have vetoed that patch at the time, but I was busy with other things.
