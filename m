Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7E486CB
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfFQPRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 11:17:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38980 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFQPRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 11:17:21 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so16706107edv.6
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 08:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=793wO/lpxosyL8Lo8JzZhwJr+Npn0SNzRpqHl7DL5pk=;
        b=RXkc/NizyisWqRuCLogAjrsGOcBd68f10ywsjcm7brS6yJ+d35dfd+cuxSbAdQkx7z
         wKq6dhyTSmZ8s4JbZA59Rkjj72jmNHBxRcmOYEgxuj6UaAQzP3CjhQs8yOYAaNNeQtYZ
         oQiaPvp4+5m58VPDDZEqv915qKyTqDyud0y//YquxhBsN1QiXiGgrRgpGbRFSbY2lMhp
         16SEa3RJWjVMHgeXA/9dyN9Ap1U+ZDrdKgvOStfNibxXjwuR3roK7mBx8fRE2X27RuH9
         2I09MIggqYS5t3kBHlA8AG3pKMkbKtW5EIxg5zvJJHx3o698XrY/7sue3H+NA82wDJmc
         Y3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=793wO/lpxosyL8Lo8JzZhwJr+Npn0SNzRpqHl7DL5pk=;
        b=sKreaLZhaRir71J2sVWFzwVgk4ZZ9LBxnI5b71IppiTJlUQAQQHQJhri6Kqx7NYOMU
         dQPcuXp7Yinft30k9nQRd2FITULICu1q7RyYcBVcrwpPVqwrP+Oi1Ai0CvgFj6FpDJKy
         bC2Y4hlusZ3b79ngVHgnpJc9W8ddnQtok6Uwmfpypeh32ez2es3WRoL0SCYH8jdgz2xE
         xCqf0Sh7k8Jw1/kLqu6d5wt6eV1blaeRuV0cxZx+rGQe6Yk0AKyZTM31kJt6yKJWwBBB
         AyFX7QQVSDZ+HnrQH7UdU90sTNSR6AMHegHCEoX1E8Xo9W04E8ev5OTHXFCZXvwMlRKe
         m7HQ==
X-Gm-Message-State: APjAAAUXUFVTswdx6stsdLT/MU3SZ6p5coPZmgiCzMzFvTyTwp0J7AQS
        aGnHzjdMHyjq6Q7cjxHRTleB2w==
X-Google-Smtp-Source: APXvYqx/2PG0WVKQ0QCNSQz1um97AoXbarsKCLVMsvp/9S7L7EsBQNFc5qFB/PVQai5MQ0iioIgvfg==
X-Received: by 2002:a50:addc:: with SMTP id b28mr23146217edd.174.1560784639396;
        Mon, 17 Jun 2019 08:17:19 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j17sm4004322ede.60.2019.06.17.08.17.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 08:17:18 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id E2A72100F6D; Mon, 17 Jun 2019 18:17:17 +0300 (+03)
Date:   Mon, 17 Jun 2019 18:17:17 +0300
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
Subject: Re: [PATCH, RFC 18/62] x86/mm: Implement syncing per-KeyID direct
 mappings
Message-ID: <20190617151717.ofjfbpsgv6hkj2jk@box>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-19-kirill.shutemov@linux.intel.com>
 <20190614095131.GY3436@hirez.programming.kicks-ass.net>
 <20190614224309.t4ce7lpx577qh2gu@box>
 <20190617092755.GA3419@hirez.programming.kicks-ass.net>
 <20190617144328.oqwx5rb5yfm2ziws@box>
 <20190617145158.GF3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617145158.GF3436@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 04:51:58PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 17, 2019 at 05:43:28PM +0300, Kirill A. Shutemov wrote:
> > On Mon, Jun 17, 2019 at 11:27:55AM +0200, Peter Zijlstra wrote:
> 
> > > > > And yet I don't see anything in pageattr.c.
> > > > 
> > > > You're right. I've hooked up the sync in the wrong place.
> 
> > I think something like this should do (I'll fold it in after testing):
> 
> > @@ -643,7 +641,7 @@ static int sync_direct_mapping_keyid(unsigned long keyid)
> >   *
> >   * The function is nop until MKTME is enabled.
> >   */
> > -int sync_direct_mapping(void)
> > +int sync_direct_mapping(unsigned long start, unsigned long end)
> >  {
> >  	int i, ret = 0;
> >  
> > @@ -651,7 +649,7 @@ int sync_direct_mapping(void)
> >  		return 0;
> >  
> >  	for (i = 1; !ret && i <= mktme_nr_keyids; i++)
> > -		ret = sync_direct_mapping_keyid(i);
> > +		ret = sync_direct_mapping_keyid(i, start, end);
> >  
> >  	flush_tlb_all();
> >  
> > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > index 6a9a77a403c9..eafbe0d8c44f 100644
> > --- a/arch/x86/mm/pageattr.c
> > +++ b/arch/x86/mm/pageattr.c
> > @@ -347,6 +347,28 @@ static void cpa_flush(struct cpa_data *data, int cache)
> >  
> >  	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
> >  
> > +	if (mktme_enabled()) {
> > +		unsigned long start, end;
> > +
> > +		start = *cpa->vaddr;
> > +		end = *cpa->vaddr + cpa->numpages * PAGE_SIZE;
> > +
> > +		/* Sync all direct mapping for an array */
> > +		if (cpa->flags & CPA_ARRAY) {
> > +			start = PAGE_OFFSET;
> > +			end = PAGE_OFFSET + direct_mapping_size;
> > +		}
> 
> Understandable but sad, IIRC that's the most used interface (at least,
> its the one the graphics people use).
> 
> > +
> > +		/*
> > +		 * Sync per-KeyID direct mappings with the canonical one
> > +		 * (KeyID-0).
> > +		 *
> > +		 * sync_direct_mapping() does full TLB flush.
> > +		 */
> > +		sync_direct_mapping(start, end);
> > +		return;
> 
> But it doesn't flush cache. So you can't return here.

Thanks for catching this.

	if (!cache)
		return;

should be fine.

-- 
 Kirill A. Shutemov
