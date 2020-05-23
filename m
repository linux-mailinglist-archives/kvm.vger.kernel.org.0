Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34CF1DF94F
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbgEWRZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 13:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387507AbgEWRZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 13:25:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85409C061A0E;
        Sat, 23 May 2020 10:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CVNRhNLnfmlc2qa/qQiHI89PDUvBGY/AKeK4xvPMuyA=; b=UCHXLaK1YXp36y/WDD9cfsgfbN
        q54HO+/Y1Gem3JnXF8A7Qw33ZANMQEd4bL344Y8D2kBovzFVSHBVrajRPNX1KprdiEPCXgjvMujSH
        +E4gYyfQ1olJkeMcGn1BCieZSHDIGpcBU02O+4+VWWiKGGdGQHhQifrU4wb4PR3Rp4KevpLdNl4/b
        q4tpWZBFoEtKcjmRvPyBjQXe0C292c7A6fBUDivplEOpxv5wr464i6p5pepBW8XFCjTeDUx7BoiJ0
        qDBwA+/cZrAFMOVCIE8YsMVccyXo2Vr0MeMI2zR76BC1CtRI7Z8J0t2Ba+9HltIw5oNOgC4VbsCsx
        QwNAlymw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcXtf-0000Up-7w; Sat, 23 May 2020 17:25:19 +0000
Date:   Sat, 23 May 2020 10:25:19 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     paulus@ozlabs.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        akpm@linux-foundation.org, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        pbonzini@redhat.com, sfr@canb.auug.org.au, rppt@linux.ibm.com,
        msuchanek@suse.de, aneesh.kumar@linux.ibm.com,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [linux-next RFC] mm/gup.c: Convert to use
 get_user_pages_fast_only()
Message-ID: <20200523172519.GA17206@bombadil.infradead.org>
References: <1590252072-2793-1-git-send-email-jrdr.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590252072-2793-1-git-send-email-jrdr.linux@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 10:11:12PM +0530, Souptick Joarder wrote:
> Renaming the API __get_user_pages_fast() to get_user_pages_
> fast_only() to align with pin_user_pages_fast_only().

Please don't split a function name across lines.  That messes
up people who are grepping for the function name in the changelog.

> As part of this we will get rid of write parameter.
> Instead caller will pass FOLL_WRITE to get_user_pages_fast_only().
> This will not change any existing functionality of the API.
> 
> All the callers are changed to pass FOLL_WRITE.
> 
> Updated the documentation of the API.

Everything you have done here is an improvement, and I'd be happy to
see it go in (after fixing the bug I note below).

But in reading through it, I noticed almost every user ...

> -	if (__get_user_pages_fast(hva, 1, 1, &page) == 1) {
> +	if (get_user_pages_fast_only(hva, 1, FOLL_WRITE, &page) == 1) {

passes '1' as the second parameter.  So do we want to add:

static inline bool get_user_page_fast_only(unsigned long addr,
		unsigned int gup_flags, struct page **pagep)
{
	return get_user_pages_fast_only(addr, 1, gup_flags, pagep) == 1;
}

> @@ -2797,10 +2803,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  	 * FOLL_FAST_ONLY is required in order to match the API description of
>  	 * this routine: no fall back to regular ("slow") GUP.
>  	 */
> -	unsigned int gup_flags = FOLL_GET | FOLL_FAST_ONLY;
> -
> -	if (write)
> -		gup_flags |= FOLL_WRITE;
> +	gup_flags = FOLL_GET | FOLL_FAST_ONLY;

Er ... gup_flags |=, surely?

