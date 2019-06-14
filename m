Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E6545EAB
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 15:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfFNNns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 09:43:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39208 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbfFNNnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 09:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CEpLzxWl0gVhhE2loe/wZNC7HEFBNtusAecwnKLSC9Y=; b=wJWUaH4KBhaf6FksZmx6YleNS
        SqJt2t24BqEHD50uiboct62KgbUmDCuQAqSNqCr87Vaizsbh9ww1KCcI+top6ZWkFHX3dyskStBzq
        UIViB3eY+V4668fgqSO5LtEzseW5ElzpJsd3aNvCMF/RVO9Lg/DIm9iLz357FOEQ+WxQ4pw2Q077W
        kf4mJRIvgRsBYqbPyY7CtR7XUwXqeFv4KrkG8WnWDVb7ouPheOhasUPP57/2hdI+uSHSKuH4XsfuR
        +Si9/YiEQVF9qWr46i2A8Hr8Uzh3Su4WRqmqOee1TLNOHja45yFHb/hTiCA++kVXKwxYFFWwXNFqx
        pH+R4j+Fg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmUS-00087g-TV; Fri, 14 Jun 2019 13:43:37 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 983BF20292FD5; Fri, 14 Jun 2019 15:43:35 +0200 (CEST)
Date:   Fri, 14 Jun 2019 15:43:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 13/62] x86/mm: Add hooks to allocate and free
 encrypted pages
Message-ID: <20190614134335.GU3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
 <20190614093409.GX3436@hirez.programming.kicks-ass.net>
 <20190614110458.GN3463@hirez.programming.kicks-ass.net>
 <20190614132836.spl6bmk2kkx65nfr@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614132836.spl6bmk2kkx65nfr@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 04:28:36PM +0300, Kirill A. Shutemov wrote:
> On Fri, Jun 14, 2019 at 01:04:58PM +0200, Peter Zijlstra wrote:
> > On Fri, Jun 14, 2019 at 11:34:09AM +0200, Peter Zijlstra wrote:
> > > On Wed, May 08, 2019 at 05:43:33PM +0300, Kirill A. Shutemov wrote:
> > > 
> > > > +		lookup_page_ext(page)->keyid = keyid;
> > 
> > > > +		lookup_page_ext(page)->keyid = 0;
> > 
> > Also, perhaps paranoid; but do we want something like:
> > 
> > static inline void page_set_keyid(struct page *page, int keyid)
> > {
> > 	/* ensure nothing creeps after changing the keyid */
> > 	barrier();
> > 	WRITE_ONCE(lookup_page_ext(page)->keyid, keyid);
> > 	barrier();
> > 	/* ensure nothing creeps before changing the keyid */
> > }
> > 
> > And this is very much assuming there is no concurrency through the
> > allocator locks.
> 
> There's no concurrency for this page: it has been off the free list, but
> have not yet passed on to user. Nobody else sees the page before
> allocation is finished.
> 
> And barriers/WRITE_ONCE() looks excessive to me. It's just yet another bit
> of page's metadata and I don't see why it's has to be handled in a special
> way.
> 
> Does it relax your paranoia? :P

Not really, it all 'works' because clflush_cache_range() includes mb()
and page_address() has an address dependency on the store, and there are
no other sites that will ever change 'keyid', which is all kind of
fragile.

At the very least that should be explicitly called out in a comment.

