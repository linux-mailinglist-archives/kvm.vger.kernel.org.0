Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3581C46D31
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2019 02:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfFOA31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 20:29:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:26556 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbfFOA31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 20:29:27 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 17:29:25 -0700
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 17:29:25 -0700
Date:   Fri, 14 Jun 2019 17:32:31 -0700
From:   Alison Schofield <alison.schofield@intel.com>
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
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
Message-ID: <20190615003231.GA15479@alison-desk.jf.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
 <20190614115137.GF3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614115137.GF3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 01:51:37PM +0200, Peter Zijlstra wrote:
> On Wed, May 08, 2019 at 05:44:05PM +0300, Kirill A. Shutemov wrote:
snip
> >  /*
> > - * When pkey==NO_KEY we get legacy mprotect behavior here.
> > + * do_mprotect_ext() supports the legacy mprotect behavior plus extensions
> > + * for Protection Keys and Memory Encryption Keys. These extensions are
> > + * mutually exclusive and the behavior is:
> > + *	(pkey==NO_KEY && keyid==NO_KEY) ==> legacy mprotect
> > + *	(pkey is valid)  ==> legacy mprotect plus Protection Key extensions
> > + *	(keyid is valid) ==> legacy mprotect plus Encryption Key extensions
> >   */
> >  static int do_mprotect_ext(unsigned long start, size_t len,
> > -		unsigned long prot, int pkey)
> > +			   unsigned long prot, int pkey, int keyid)
> >  {

snip

>
> I've missed the part where pkey && keyid results in a WARN or error or
> whatever.
> 
I wasn't so sure about that since do_mprotect_ext()
is the call 'behind' the system calls. 

legacy mprotect always calls with: NO_KEY, NO_KEY
pkey_mprotect always calls with:  pkey, NO_KEY
encrypt_mprotect always calls with  NO_KEY, keyid

Would a check on those arguments be debug only 
to future proof this?
