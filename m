Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EA01E5067
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 23:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgE0VWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 17:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgE0VWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 17:22:10 -0400
Received: from kernel.org (unknown [87.71.78.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612E52078C;
        Wed, 27 May 2020 21:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590614529;
        bh=ZfN6TjCih4KRWkakKKG5b5uklqfy1UErCB1lMEJOcfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j2ZgK8EwwFrGozUSttXAmBtw0/ayQsFW5FCRyot+Db9RnnnICgh26zIKdwlOtXgep
         2EUvcj6Zr4e0h0wGRqXx9com35n6GlA4rF8kTsDjfz5KwKqryTTeihjFRrSjvVfgCF
         Q6EnS/w7tfSWhWnJJg4ICc5DWPCfTn2ITCaFND10=
Date:   Thu, 28 May 2020 00:22:00 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
Message-ID: <20200527212200.GH48741@kernel.org>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
 <20200526061721.GB48741@kernel.org>
 <8866ff79-e8fd-685d-9a1d-72acff5bf6bb@oracle.com>
 <20200526113844.GC48741@kernel.org>
 <b616bed6-9be2-0e79-86cc-0d571417bc71@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b616bed6-9be2-0e79-86cc-0d571417bc71@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 27, 2020 at 08:45:33AM -0700, Dave Hansen wrote:
> On 5/26/20 4:38 AM, Mike Rapoport wrote:
> > On Tue, May 26, 2020 at 01:16:14PM +0300, Liran Alon wrote:
> >> On 26/05/2020 9:17, Mike Rapoport wrote:
> >>> On Mon, May 25, 2020 at 04:47:18PM +0300, Liran Alon wrote:
> >>>> On 22/05/2020 15:51, Kirill A. Shutemov wrote:
> >>>>
> >>> Out of curiosity, do we actually have some numbers for the "non-trivial
> >>> performance cost"? For instance for KVM usecase?
> >>>
> >> Dig into XPFO mailing-list discussions to find out...
> >> I just remember that this was one of the main concerns regarding XPFO.
> >
> > The XPFO benchmarks measure total XPFO cost, and huge share of it comes
> > from TLB shootdowns.
> 
> Yes, TLB shootdown when pages transition between owners is huge.  The
> XPFO folks did a lot of work to try to optimize some of this overhead
> away.  But, it's still a concern.
> 
> The concern with XPFO was that it could affect *all* application page
> allocation.  This approach cheats a bit and only goes after guest VM
> pages.  It's significantly more work to allocate a page and map it into
> a guest than it is to, for instance, allocate an anonymous user page.
> That means that the *additional* overhead of things like this for guest
> memory matter a lot less.
> 
> > It's not exactly measurement of the imapct of the direct map
> > fragmentation to workload running inside a vitrual machine.
> 
> While the VM *itself* is running, there is zero overhead.  The host
> direct map is not used at *all*.  The guest and host TLB entries share
> the same space in the TLB so there could be some increased pressure on
> the TLB, but that's a really secondary effect.  It would also only occur
> if the guest exits and the host runs and starts evicting TLB entries.
> 
> The other effects I could think of would be when the guest exits and the
> host is doing some work for the guest, like emulation or something.  The
> host would see worse TLB behavior because the host is using the
> (fragmented) direct map.
> 
> But, both of those things require VMEXITs.  The more exits, the more
> overhead you _might_ observe.  What I've been hearing from KVM folks is
> that exits are getting more and more rare and the hardware designers are
> working hard to minimize them.

Right, when guest stays in the guest mode, there is no overhead. But
guests still exit sometimes and I was wondering if anybody had measured
difference in the overhead with different page size used for the host's
direct map. 

My guesstimate is that the overhead will not differ much for most
workloads. But still, it's still interesting to *know* what is it.

> That's especially good news because it means that even if the
> situation
> isn't perfect, it's only bound to get *better* over time, not worse.

The processors have been aggressively improving performance for decades
and see where are we know because of it ;-)

-- 
Sincerely yours,
Mike.
