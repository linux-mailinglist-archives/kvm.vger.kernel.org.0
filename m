Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3A048612
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfFQOwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 10:52:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfFQOwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 10:52:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CC6TusG/xvd2NrKEqztW6Q0eLvQHpCSqZ9asqvSUbGQ=; b=HhwqhNrM9xrAQOq0eNTILgTfj
        R+0T3K6DbjbIQyqcNTefACa3jRYLYfmFr4O2DTtDoavuT0bYMdlrxcS92IvJtv2UUGOO3dBzTihLB
        UNtKyWn6YD230yNinCi6buZ5Y1cFQrcsU3Yf0AKOWWsUOio12DIiRYw0JHoJhAFyg7pDgL7qkcSr0
        9B1owcTUHT3GZq77EKPQ2Be6tSOdWLwu/5DQDTsaA+kc+xdgkxwwbDZqVqeemMIuiKx2sI21XYSkj
        VNQrWUbfXOqlIDfhkhAkwTWqWnsFdYX9pzSdlvpXOVDMOmtOUK0OoVu6wc12rWnWOkLladzvUZa8S
        /gsHPagpw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcszI-0004sz-1Q; Mon, 17 Jun 2019 14:52:00 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 68240201F4619; Mon, 17 Jun 2019 16:51:58 +0200 (CEST)
Date:   Mon, 17 Jun 2019 16:51:58 +0200
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
Subject: Re: [PATCH, RFC 18/62] x86/mm: Implement syncing per-KeyID direct
 mappings
Message-ID: <20190617145158.GF3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-19-kirill.shutemov@linux.intel.com>
 <20190614095131.GY3436@hirez.programming.kicks-ass.net>
 <20190614224309.t4ce7lpx577qh2gu@box>
 <20190617092755.GA3419@hirez.programming.kicks-ass.net>
 <20190617144328.oqwx5rb5yfm2ziws@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617144328.oqwx5rb5yfm2ziws@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 05:43:28PM +0300, Kirill A. Shutemov wrote:
> On Mon, Jun 17, 2019 at 11:27:55AM +0200, Peter Zijlstra wrote:

> > > > And yet I don't see anything in pageattr.c.
> > > 
> > > You're right. I've hooked up the sync in the wrong place.

> I think something like this should do (I'll fold it in after testing):

> @@ -643,7 +641,7 @@ static int sync_direct_mapping_keyid(unsigned long keyid)
>   *
>   * The function is nop until MKTME is enabled.
>   */
> -int sync_direct_mapping(void)
> +int sync_direct_mapping(unsigned long start, unsigned long end)
>  {
>  	int i, ret = 0;
>  
> @@ -651,7 +649,7 @@ int sync_direct_mapping(void)
>  		return 0;
>  
>  	for (i = 1; !ret && i <= mktme_nr_keyids; i++)
> -		ret = sync_direct_mapping_keyid(i);
> +		ret = sync_direct_mapping_keyid(i, start, end);
>  
>  	flush_tlb_all();
>  
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 6a9a77a403c9..eafbe0d8c44f 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -347,6 +347,28 @@ static void cpa_flush(struct cpa_data *data, int cache)
>  
>  	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
>  
> +	if (mktme_enabled()) {
> +		unsigned long start, end;
> +
> +		start = *cpa->vaddr;
> +		end = *cpa->vaddr + cpa->numpages * PAGE_SIZE;
> +
> +		/* Sync all direct mapping for an array */
> +		if (cpa->flags & CPA_ARRAY) {
> +			start = PAGE_OFFSET;
> +			end = PAGE_OFFSET + direct_mapping_size;
> +		}

Understandable but sad, IIRC that's the most used interface (at least,
its the one the graphics people use).

> +
> +		/*
> +		 * Sync per-KeyID direct mappings with the canonical one
> +		 * (KeyID-0).
> +		 *
> +		 * sync_direct_mapping() does full TLB flush.
> +		 */
> +		sync_direct_mapping(start, end);
> +		return;

But it doesn't flush cache. So you can't return here.

> +	}
> +
>  	if (cache && !static_cpu_has(X86_FEATURE_CLFLUSH)) {
>  		cpa_flush_all(cache);
>  		return;
> -- 
>  Kirill A. Shutemov
