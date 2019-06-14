Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDCD467BD
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 20:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfFNSm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 14:42:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:34137 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNSm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 14:42:56 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 11:42:55 -0700
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 11:42:55 -0700
Date:   Fri, 14 Jun 2019 11:46:02 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20190614184602.GB7252@alison-desk.jf.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-45-kirill.shutemov@linux.intel.com>
 <20190614114408.GD3436@hirez.programming.kicks-ass.net>
 <20190614173345.GB5917@alison-desk.jf.intel.com>
 <e0884a6b-78bc-209d-bc9a-90f69839189e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0884a6b-78bc-209d-bc9a-90f69839189e@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 11:26:10AM -0700, Dave Hansen wrote:
> On 6/14/19 10:33 AM, Alison Schofield wrote:
> > Preserving the data across encryption key changes has not
> > been a requirement. I'm not clear if it was ever considered
> > and rejected. I believe that copying in order to preserve
> > the data was never considered.
> 
> We could preserve the data pretty easily.  It's just annoying, though.
> Right now, our only KeyID conversions happen in the page allocator.  If
> we were to convert in-place, we'd need something along the lines of:
> 
> 	1. Allocate a scratch page
> 	2. Unmap target page, or at least make it entirely read-only
> 	3. Copy plaintext into scratch page
> 	4. Do cache KeyID conversion of page being converted:
> 	   Flush caches, change page_ext metadata
> 	5. Copy plaintext back into target page from scratch area
> 	6. Re-establish PTEs with new KeyID

Seems like the 'Copy plaintext' steps might disappoint the user, as
much as the 'we don't preserve your data' design. Would users be happy
w the plain text steps ?
Alison

> 
> #2 is *really* hard.  It's similar to the problems that the poor
> filesystem guys are having with RDMA these days when RDMA is doing writes.
> 
> What we have here (destroying existing data) is certainly the _simplest_
> semantic.  We can certainly give it a different name, or even non-PROT_*
> semantics where it shares none of mprotect()'s functionality.
> 
> Doesn't really matter to me at all.
