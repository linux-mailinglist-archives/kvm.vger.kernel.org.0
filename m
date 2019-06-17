Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F2947DF9
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 11:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfFQJKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 05:10:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58960 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfFQJKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 05:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lSBxG3pslaMoZ4q5LfNT8Zk++zn3HV9csalZ1zH5zZQ=; b=F60cT2pWFaw+0bzwXk+QRPjac
        SQSBB/T3pjj2vvFitGT/VQMox0OWHFlY644jDhByelCvdv36dXHlHs3LZfXBNZLOcSyAel99wBGkY
        dFsCansXAOcFaLXJODF/MXDuQ8yJInHw7J7paI8oo77fjHJJkvvsAKzyfXfCipuAVRZfyrQpHtdD/
        QM8OcVqmrDNHs8qOYqIJsH4Lf8t+jhkz5jV/yXzAdo16KalPAs6LpG1ubmATO7b7shkE064qeSkQM
        bPPwCnc+sKzykEJ6dtXc1BDAiu59261Ly0WOF5HSco5f1OwG4zfFkrhkepGAG9wwbbdLQXTYyNU1T
        uXZZrXUnQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcnf0-0005x4-8P; Mon, 17 Jun 2019 09:10:42 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0782E2025A803; Mon, 17 Jun 2019 11:10:41 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:10:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Alison Schofield <alison.schofield@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 44/62] x86/mm: Set KeyIDs in encrypted VMAs for MKTME
Message-ID: <20190617091040.GZ3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-45-kirill.shutemov@linux.intel.com>
 <20190614114408.GD3436@hirez.programming.kicks-ass.net>
 <20190614173345.GB5917@alison-desk.jf.intel.com>
 <e0884a6b-78bc-209d-bc9a-90f69839189e@intel.com>
 <20190614184602.GB7252@alison-desk.jf.intel.com>
 <ca62a921-e60c-6532-32c3-f02e15ba69aa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca62a921-e60c-6532-32c3-f02e15ba69aa@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 12:11:23PM -0700, Dave Hansen wrote:
> On 6/14/19 11:46 AM, Alison Schofield wrote:
> > On Fri, Jun 14, 2019 at 11:26:10AM -0700, Dave Hansen wrote:
> >> On 6/14/19 10:33 AM, Alison Schofield wrote:
> >>> Preserving the data across encryption key changes has not
> >>> been a requirement. I'm not clear if it was ever considered
> >>> and rejected. I believe that copying in order to preserve
> >>> the data was never considered.
> >>
> >> We could preserve the data pretty easily.  It's just annoying, though.
> >> Right now, our only KeyID conversions happen in the page allocator.  If
> >> we were to convert in-place, we'd need something along the lines of:
> >>
> >> 	1. Allocate a scratch page
> >> 	2. Unmap target page, or at least make it entirely read-only
> >> 	3. Copy plaintext into scratch page
> >> 	4. Do cache KeyID conversion of page being converted:
> >> 	   Flush caches, change page_ext metadata
> >> 	5. Copy plaintext back into target page from scratch area
> >> 	6. Re-establish PTEs with new KeyID
> > 
> > Seems like the 'Copy plaintext' steps might disappoint the user, as
> > much as the 'we don't preserve your data' design. Would users be happy
> > w the plain text steps ?
> 
> Well, it got to be plaintext because they wrote it to memory in
> plaintext in the first place, so it's kinda hard to disappoint them. :)
> 
> IMNHO, the *vast* majority of cases, folks will allocate memory and then
> put a secret in it.  They aren't going to *get* a secret in some
> mysterious fashion and then later decide they want to protect it.  In
> other words, the inability to convert it is pretty academic and not
> worth the complexity.

I'm not saying it is (required to preserve); but I do think it is
somewhat surprising to have an mprotect() call destroy content. It's
traditionally specified to not do that.

