Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD45547DED
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 11:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfFQJIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 05:08:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58920 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfFQJIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 05:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wRdvOfPDETJvARv+zW+J5HAlYTlZLHmPl7FzG8lv1Ps=; b=1SzaizZlFZrcso1vWkqcGDQl+
        3GTCltkdhp6F4a07txN0iCkbOsUS3i2IcD+SBI6D6d9SwZsu4Oycx+PvZZikN/HOdKTZel19mOF2J
        +peAXjqfCZilEMVgF0K7ZJwWBaqoYufu0uC0+iuDeKKct2mo+pCFPu/C1lPHumKWDgt7haPR9GIgQ
        TBo8KuIZVoi+uAFMs/Z1tHQ3wg+4yhY5/sfjUYVByRFDQ9XvfpYTwgHraXRrjLA1aP+Bk0x0UN4An
        y0z13wfIJsgXhGdYqGoUMe0nZyQTlF1QGFr2mKt6F9CN05mSKBVY3Glim/3cO/Ed3NCdpaqW/QkYQ
        ElKV/y6YQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcncs-0005vu-7b; Mon, 17 Jun 2019 09:08:30 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D430F2025A803; Mon, 17 Jun 2019 11:08:27 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:08:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alison Schofield <alison.schofield@intel.com>
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
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
Message-ID: <20190617090827.GY3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
 <20190614115137.GF3436@hirez.programming.kicks-ass.net>
 <20190615003231.GA15479@alison-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615003231.GA15479@alison-desk.jf.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 05:32:31PM -0700, Alison Schofield wrote:
> On Fri, Jun 14, 2019 at 01:51:37PM +0200, Peter Zijlstra wrote:
> > On Wed, May 08, 2019 at 05:44:05PM +0300, Kirill A. Shutemov wrote:
> snip
> > >  /*
> > > - * When pkey==NO_KEY we get legacy mprotect behavior here.
> > > + * do_mprotect_ext() supports the legacy mprotect behavior plus extensions
> > > + * for Protection Keys and Memory Encryption Keys. These extensions are
> > > + * mutually exclusive and the behavior is:

Well, here it states that the extentions are mutually exclusive.

> > > + *	(pkey==NO_KEY && keyid==NO_KEY) ==> legacy mprotect
> > > + *	(pkey is valid)  ==> legacy mprotect plus Protection Key extensions
> > > + *	(keyid is valid) ==> legacy mprotect plus Encryption Key extensions
> > >   */
> > >  static int do_mprotect_ext(unsigned long start, size_t len,
> > > -		unsigned long prot, int pkey)
> > > +			   unsigned long prot, int pkey, int keyid)
> > >  {
> 
> snip
> 
> >
> > I've missed the part where pkey && keyid results in a WARN or error or
> > whatever.
> > 
> I wasn't so sure about that since do_mprotect_ext()
> is the call 'behind' the system calls. 
> 
> legacy mprotect always calls with: NO_KEY, NO_KEY
> pkey_mprotect always calls with:  pkey, NO_KEY
> encrypt_mprotect always calls with  NO_KEY, keyid
> 
> Would a check on those arguments be debug only 
> to future proof this?

But you then don't check that, anywhere, afaict.
