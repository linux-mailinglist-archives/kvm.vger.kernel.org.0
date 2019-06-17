Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6763C47E61
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 11:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfFQJ2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 05:28:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59186 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFQJ2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 05:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dgc1wrW0fGZnefyMKVMTGRnzP9OVcereHagkOu/cG+U=; b=tNis53xzbQZR2aMou732pL582
        h2akG0bu1oJD0boOM5O1W+C0s/uo2BPwL2h95A/DatIXLmF24M5kUTq5iR+N43yTObBeopwaVaxKn
        2nyApRRc4cq0QWGQ4eXdncto7ClkcpAUYNrlnlbDdza8rSK/kBXlSeBxAhvv5FCtBL040+RjOyOjM
        4ad3gCXje4n/dXRLEh1tL/eSnuQFt9NL5CU71x/rFfcOmYDWS3enCKObsN4l92/S0BqKzeGp1naQd
        yBRlZCgxDMG2X35QxX+BlO0FEQi92zBN+WPMgg5U2bstpzAL2WGHPx32nJGquwCUnxnNyY8pGSzjJ
        GpXI6zT9w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcnvg-00064Q-QK; Mon, 17 Jun 2019 09:27:57 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 91C3120144538; Mon, 17 Jun 2019 11:27:55 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:27:55 +0200
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
Message-ID: <20190617092755.GA3419@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-19-kirill.shutemov@linux.intel.com>
 <20190614095131.GY3436@hirez.programming.kicks-ass.net>
 <20190614224309.t4ce7lpx577qh2gu@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614224309.t4ce7lpx577qh2gu@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 15, 2019 at 01:43:09AM +0300, Kirill A. Shutemov wrote:
> On Fri, Jun 14, 2019 at 11:51:32AM +0200, Peter Zijlstra wrote:
> > On Wed, May 08, 2019 at 05:43:38PM +0300, Kirill A. Shutemov wrote:
> > > For MKTME we use per-KeyID direct mappings. This allows kernel to have
> > > access to encrypted memory.
> > > 
> > > sync_direct_mapping() sync per-KeyID direct mappings with a canonical
> > > one -- KeyID-0.
> > > 
> > > The function tracks changes in the canonical mapping:
> > >  - creating or removing chunks of the translation tree;
> > >  - changes in mapping flags (i.e. protection bits);
> > >  - splitting huge page mapping into a page table;
> > >  - replacing page table with a huge page mapping;
> > > 
> > > The function need to be called on every change to the direct mapping:
> > > hotplug, hotremove, changes in permissions bits, etc.
> > 
> > And yet I don't see anything in pageattr.c.
> 
> You're right. I've hooked up the sync in the wrong place.
> > 
> > Also, this seems like an expensive scheme; if you know where the changes
> > where, a more fine-grained update would be faster.
> 
> Do we have any hot enough pageattr users that makes it crucial?
> 
> I'll look into this anyway.

The graphics people would be the most agressive users of this I'd think.
They're the ones that yelled when I broke it last ;-)

