Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21A45B19
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfFNLFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:05:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37538 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfFNLFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=E87CowIp+htiYTGS6CsPTPTEGv8n2gNXy2U9+KLGIFs=; b=0cz3WNC1WoJh9tx/1EngoYVrj
        5upJl14QfanK6cDpB5fCGNRv5B3ME4jKW4uShU0mPxNf1ByhA3yS71ZijaxYowR3yVkRJuwr+r13z
        DPrnvz8ByacVbE+PhTrPw2kEhfxMZ0twHAlKKHBsllzQLb/xHv5SaUUk4BdaxVuH3XlzTbUqW5+v6
        Bu6c90dPPkaM+lRb5Xy8hVVkgkHjzqFA8tSogeh10XgLVxB0x0/43FodCOEDqtjTn/+Za5VcuOzl4
        fRaZ/IhRtLbrICoDIv2pYyqBtKLXX5G6XVYDsIaUAvPPZ9KTtqC9MPOQDESxPDCUnrg749HYny8zZ
        X5CGE4h7g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbk0z-000724-Gu; Fri, 14 Jun 2019 11:05:01 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1AD9B20A29B4F; Fri, 14 Jun 2019 13:04:58 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:04:58 +0200
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
Message-ID: <20190614110458.GN3463@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
 <20190614093409.GX3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614093409.GX3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 11:34:09AM +0200, Peter Zijlstra wrote:
> On Wed, May 08, 2019 at 05:43:33PM +0300, Kirill A. Shutemov wrote:
> 
> > +		lookup_page_ext(page)->keyid = keyid;

> > +		lookup_page_ext(page)->keyid = 0;

Also, perhaps paranoid; but do we want something like:

static inline void page_set_keyid(struct page *page, int keyid)
{
	/* ensure nothing creeps after changing the keyid */
	barrier();
	WRITE_ONCE(lookup_page_ext(page)->keyid, keyid);
	barrier();
	/* ensure nothing creeps before changing the keyid */
}

And this is very much assuming there is no concurrency through the
allocator locks.
