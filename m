Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E26467A3
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbfFNSgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 14:36:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:52676 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbfFNSgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 14:36:42 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 11:36:41 -0700
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 11:36:40 -0700
Date:   Fri, 14 Jun 2019 11:39:47 -0700
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
Subject: Re: [PATCH, RFC 46/62] x86/mm: Keep reference counts on encrypted
 VMAs for MKTME
Message-ID: <20190614183947.GA7252@alison-desk.jf.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-47-kirill.shutemov@linux.intel.com>
 <20190614115424.GG3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614115424.GG3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 01:54:24PM +0200, Peter Zijlstra wrote:
> On Wed, May 08, 2019 at 05:44:06PM +0300, Kirill A. Shutemov wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > The MKTME (Multi-Key Total Memory Encryption) Key Service needs
> > a reference count on encrypted VMAs. This reference count is used
> > to determine when a hardware encryption KeyID is no longer in use
> > and can be freed and reassigned to another Userspace Key.
> > 
> > The MKTME Key service does the percpu_ref_init and _kill, so
> > these gets/puts on encrypted VMA's can be considered the
> > intermediaries in the lifetime of the key.
> > 
> > Increment/decrement the reference count during encrypt_mprotect()
> > system call for initial or updated encryption on a VMA.
> > 
> > Piggy back on the vm_area_dup/free() helpers. If the VMAs being
> > duplicated, or freed are encrypted, adjust the reference count.
> 
> That all talks about VMAs, but...
> 
> > @@ -102,6 +115,22 @@ void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
> >  
> >  		page++;
> >  	}
> > +
> > +	/*
> > +	 * Make sure the KeyID cannot be freed until the last page that
> > +	 * uses the KeyID is gone.
> > +	 *
> > +	 * This is required because the page may live longer than VMA it
> > +	 * is mapped into (i.e. in get_user_pages() case) and having
> > +	 * refcounting per-VMA is not enough.
> > +	 *
> > +	 * Taking a reference per-4K helps in case if the page will be
> > +	 * split after the allocation. free_encrypted_page() will balance
> > +	 * out the refcount even if the page was split and freed as bunch
> > +	 * of 4K pages.
> > +	 */
> > +
> > +	percpu_ref_get_many(&encrypt_count[keyid], 1 << order);
> >  }

snip

> 
> counts pages, what gives?

Yeah. Comments are confusing. We implemented the refcounting w VMA's in
mind, and then added the page counting. I'll update the comments and
dig around some more based on your overall concerns about the
refcounting you mentioned in the cover letter.



