Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5AC45DC3
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 15:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfFNNO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 09:14:56 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42653 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbfFNNO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 09:14:56 -0400
Received: by mail-ed1-f65.google.com with SMTP id z25so3432555edq.9
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 06:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lo8jzIeEl3qvMScl2nYeZEzcklK1JpdjNABkHh1fbHg=;
        b=eFeAcZtgO0/eRC+taEsG3o/626r+gJzLYZLu6JCyggVrs1QqMuSldztZimYV/jdkJJ
         KpqfmnAYmMswNNumhYoKPsqVbi6oXCsorOhOJsdBSnOChpopGRX1/ui0nf+Nlcf6FXPr
         gGpw+PJGJIdyx5tMB8ohHf7Qp8YL0Pn4pTIC3KYego9Ujsgpyiq4SkfHbxvn1Rplq1Pp
         IoST/0AGJDllFkhSDArOhMHcOdLQczefbj/Em08KjBQgqt7nPa6It4nRH8wS9yRppE3g
         SyL/Y8mhbNTD3QF8XNH0x1JlkrNyAot22I9vIuPdXcIIAhttxk+quH+74xWONAEiEFsY
         kixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lo8jzIeEl3qvMScl2nYeZEzcklK1JpdjNABkHh1fbHg=;
        b=STm/DgrsqOsGcybCihcYusixQwNe2Wv1dudXqYXoadbS9oVXgKnGc6lv0bisoCqKaB
         JtgYpFPF2/EB2ZjW7umNnWbj7II6bFS1iH9m1nm6W+RlAuNQm3mZG92lAZNeaXOnKszV
         i8oRfPxK+l3LFJb+Jdw0gGftAvImMbXFgcit8CT0DGynk7wh4Z8LSW0fZpL+sDkQzYNN
         NamWEMgIhIKFS9JUfYF2sFftsssky6pwb42dVV3iXQT4gmavEZP9ArVUEdj4M4c7JwAw
         KGt3iQUJaUDSqJ7mNP8iF74gTWRZ+m0TMFEY+1SFZMzI/YkkBqqD5t4doQjrSbtQikKg
         +J2w==
X-Gm-Message-State: APjAAAW8TngJIj1dpcw0JaGod6Oalwk0q374+2cLz2yDBrd/qJKYnCTD
        KxzitkBwMdcWsrf0+jv8POy0hA==
X-Google-Smtp-Source: APXvYqys9UpU3EDiYN8BSuwDi62d18/VihRzxeEm4B3CXY1/sZgOqGoIC2XqSZyXoR/BuWpsRnWF+g==
X-Received: by 2002:aa7:c619:: with SMTP id h25mr39051647edq.295.1560518094495;
        Fri, 14 Jun 2019 06:14:54 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t3sm593997ejk.56.2019.06.14.06.14.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 06:14:53 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id BB20210086F; Fri, 14 Jun 2019 16:14:53 +0300 (+03)
Date:   Fri, 14 Jun 2019 16:14:53 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20190614131453.ludfm4ufzqwa326k@box>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
 <20190614093409.GX3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614093409.GX3436@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 11:34:09AM +0200, Peter Zijlstra wrote:
> On Wed, May 08, 2019 at 05:43:33PM +0300, Kirill A. Shutemov wrote:
> 
> > +/* Prepare page to be used for encryption. Called from page allocator. */
> > +void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
> > +{
> > +	int i;
> > +
> > +	/*
> > +	 * The hardware/CPU does not enforce coherency between mappings
> > +	 * of the same physical page with different KeyIDs or
> > +	 * encryption keys. We are responsible for cache management.
> > +	 */
> 
> On alloc we should flush the unencrypted (key=0) range, while on free
> (below) we should flush the encrypted (key!=0) range.
> 
> But I seem to have missed where page_address() does the right thing
> here.

As you've seen by now, it will be addressed later in the patchset. I'll
update the changelog to indicate that page_address() handles KeyIDs
correctly.

> > +	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
> > +
> > +	for (i = 0; i < (1 << order); i++) {
> > +		/* All pages coming out of the allocator should have KeyID 0 */
> > +		WARN_ON_ONCE(lookup_page_ext(page)->keyid);
> > +		lookup_page_ext(page)->keyid = keyid;
> > +
> 
> So presumably page_address() is affected by this keyid, and the below
> clear_highpage() then accesses the 'right' location?

Yes. clear_highpage() -> kmap_atomic() -> page_address().

> > +		/* Clear the page after the KeyID is set. */
> > +		if (zero)
> > +			clear_highpage(page);
> > +
> > +		page++;
> > +	}
> > +}
> > +
> > +/*
> > + * Handles freeing of encrypted page.
> > + * Called from page allocator on freeing encrypted page.
> > + */
> > +void free_encrypted_page(struct page *page, int order)
> > +{
> > +	int i;
> > +
> > +	/*
> > +	 * The hardware/CPU does not enforce coherency between mappings
> > +	 * of the same physical page with different KeyIDs or
> > +	 * encryption keys. We are responsible for cache management.
> > +	 */
> 
> I still don't like that comment much; yes the hardware doesn't do it,
> and yes we have to do it, but it doesn't explain the actual scheme
> employed to do so.

Fair enough. I'll do better.

> > +	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
> > +
> > +	for (i = 0; i < (1 << order); i++) {
> > +		/* Check if the page has reasonable KeyID */
> > +		WARN_ON_ONCE(lookup_page_ext(page)->keyid > mktme_nr_keyids);
> 
> It should also check keyid > 0, so maybe:
> 
> 	(unsigned)(keyid - 1) > keyids-1
> 
> instead?

Makes sense.

-- 
 Kirill A. Shutemov
