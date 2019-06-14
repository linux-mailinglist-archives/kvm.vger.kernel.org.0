Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B753A458C5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 11:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfFNJeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 05:34:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFNJeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 05:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v8sKDZr9w6cVAjaj6YSpqDHjOecR4ISemYmtJwZe3FY=; b=kH34VcWNT4Cav+GjG7CqlXy44
        JXzqwvLIwTvMinkAO+TRylimlvR57aQTl6R7J8h2IT4P0MA63u6VdOzQDzCbMD9iu/1rxFj9RKZmb
        o9u06p8ViQ8gJ5dyh2N4jaMWyIT0MJZGbPd9FIUyjWfyRvtbC+nqGDLMKjoHQoItVNnVNETBg3XHa
        /EFK8hfeCAK0wqta5ky6wI9fQlG4ZeH6B63bsMuP6+A1WJ3DVQE48CdQv5tm0qSB/i6C7Ev/Yco27
        JReMy3HKsSnOQ3TVN9wgekm5FU1rDzfRGnsiJhXNfi53fnyqodzPmaUbJT/6qnRMCKPprYWDjQ4GG
        pfErC0P/Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbib5-00058b-5L; Fri, 14 Jun 2019 09:34:11 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5673620A26CE6; Fri, 14 Jun 2019 11:34:09 +0200 (CEST)
Date:   Fri, 14 Jun 2019 11:34:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
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
Message-ID: <20190614093409.GX3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:33PM +0300, Kirill A. Shutemov wrote:

> +/* Prepare page to be used for encryption. Called from page allocator. */
> +void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
> +{
> +	int i;
> +
> +	/*
> +	 * The hardware/CPU does not enforce coherency between mappings
> +	 * of the same physical page with different KeyIDs or
> +	 * encryption keys. We are responsible for cache management.
> +	 */

On alloc we should flush the unencrypted (key=0) range, while on free
(below) we should flush the encrypted (key!=0) range.

But I seem to have missed where page_address() does the right thing
here.

> +	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
> +
> +	for (i = 0; i < (1 << order); i++) {
> +		/* All pages coming out of the allocator should have KeyID 0 */
> +		WARN_ON_ONCE(lookup_page_ext(page)->keyid);
> +		lookup_page_ext(page)->keyid = keyid;
> +

So presumably page_address() is affected by this keyid, and the below
clear_highpage() then accesses the 'right' location?

> +		/* Clear the page after the KeyID is set. */
> +		if (zero)
> +			clear_highpage(page);
> +
> +		page++;
> +	}
> +}
> +
> +/*
> + * Handles freeing of encrypted page.
> + * Called from page allocator on freeing encrypted page.
> + */
> +void free_encrypted_page(struct page *page, int order)
> +{
> +	int i;
> +
> +	/*
> +	 * The hardware/CPU does not enforce coherency between mappings
> +	 * of the same physical page with different KeyIDs or
> +	 * encryption keys. We are responsible for cache management.
> +	 */

I still don't like that comment much; yes the hardware doesn't do it,
and yes we have to do it, but it doesn't explain the actual scheme
employed to do so.

> +	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
> +
> +	for (i = 0; i < (1 << order); i++) {
> +		/* Check if the page has reasonable KeyID */
> +		WARN_ON_ONCE(lookup_page_ext(page)->keyid > mktme_nr_keyids);

It should also check keyid > 0, so maybe:

	(unsigned)(keyid - 1) > keyids-1

instead?

> +		lookup_page_ext(page)->keyid = 0;
> +		page++;
> +	}
> +}
> -- 
> 2.20.1
> 
