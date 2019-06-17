Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2773C47E59
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 11:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfFQJZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 05:25:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59136 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFQJZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 05:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R5E4jvXEvZihQlXT71dalQ2LmxCFvADw8lOr0h8eEyE=; b=iagTfw8xds9QY4p8IF0ieCpv7
        R6fN48j9Es6f93Yz2tldjKCQ+ntXSefyw3kNrKsMbUbjUqA84TeJzXrLEdQObSICB1iVXJGOQ8+Eq
        9IRMyOs8kYnpBHcGb6vewf6hYAdf+YhVjHqsNPjXmadLMxaRTZ6GUT5fPqBsFdBcRwSDu4jLiRB2u
        6hge9UbGUNfEwOyQAh3M2OUPuxWisqxTqIyBh9HT1+DrBhloyWAbYW5EX6+6oHX7zl1J1JhlESdAl
        mw0BwUkVul1GvsVfBbz0Hn28CVedvWeDc9DPhTlTajB0W4zdU5IGdxqqA1USUGiTQ/EKg+tF/qlYo
        U1JjgEeQA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcntN-00063N-3A; Mon, 17 Jun 2019 09:25:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C392220144538; Mon, 17 Jun 2019 11:25:31 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:25:31 +0200
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
Message-ID: <20190617092531.GZ3419@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
 <20190614093409.GX3436@hirez.programming.kicks-ass.net>
 <20190614110458.GN3463@hirez.programming.kicks-ass.net>
 <20190614132836.spl6bmk2kkx65nfr@box>
 <20190614134335.GU3436@hirez.programming.kicks-ass.net>
 <20190614224131.q2gjai32la4zb42p@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614224131.q2gjai32la4zb42p@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 15, 2019 at 01:41:31AM +0300, Kirill A. Shutemov wrote:
> On Fri, Jun 14, 2019 at 03:43:35PM +0200, Peter Zijlstra wrote:

> > Not really, it all 'works' because clflush_cache_range() includes mb()
> > and page_address() has an address dependency on the store, and there are
> > no other sites that will ever change 'keyid', which is all kind of
> > fragile.
> 
> Hm. I don't follow how the mb() in clflush_cache_range() relevant...
> 
> Any following access of page's memory by kernel will go through
> page_keyid() and therefore I believe there's always address dependency on
> the store.
> 
> Am I missing something?

The dependency doesn't help with prior calls; consider:

	addr = page_address(page);

	*addr = foo;

	page->key_id = bar;

	addr2 = page_address(page);


Without a barrier() between '*addr = foo' and 'page->key_id = bar', the
compiler is allowed to reorder these stores.

Now, the clflush stuff we do, that already hard orders things -- we need
to be done writing before we start flushing -- so we can/do rely on
that, but we should explicitly mention that.

Now, for the second part, addr2 must observe bar, because of the address
dependency, the compiler is not allowed mess that up, but again, that is
something we should put in a comment.
