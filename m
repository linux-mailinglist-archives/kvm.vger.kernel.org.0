Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2651B47D53
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 10:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfFQIjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 04:39:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:3979 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfFQIjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 04:39:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 01:39:47 -0700
X-ExtLoop1: 1
Received: from khuang2-desk.gar.corp.intel.com ([10.255.91.82])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jun 2019 01:39:44 -0700
Message-ID: <1560760783.5187.10.camel@linux.intel.com>
Subject: Re: [PATCH, RFC 49/62] mm, x86: export several MKTME variables
From:   Kai Huang <kai.huang@linux.intel.com>
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
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 17 Jun 2019 20:39:43 +1200
In-Reply-To: <20190617074643.GW3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
         <20190508144422.13171-50-kirill.shutemov@linux.intel.com>
         <20190614115647.GI3436@hirez.programming.kicks-ass.net>
         <1560741269.5187.7.camel@linux.intel.com>
         <20190617074643.GW3436@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-06-17 at 09:46 +0200, Peter Zijlstra wrote:
> On Mon, Jun 17, 2019 at 03:14:29PM +1200, Kai Huang wrote:
> > On Fri, 2019-06-14 at 13:56 +0200, Peter Zijlstra wrote:
> > > On Wed, May 08, 2019 at 05:44:09PM +0300, Kirill A. Shutemov wrote:
> > > > From: Kai Huang <kai.huang@linux.intel.com>
> > > > 
> > > > KVM needs those variables to get/set memory encryption mask.
> > > > 
> > > > Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > ---
> > > >  arch/x86/mm/mktme.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
> > > > index df70651816a1..12f4266cf7ea 100644
> > > > --- a/arch/x86/mm/mktme.c
> > > > +++ b/arch/x86/mm/mktme.c
> > > > @@ -7,13 +7,16 @@
> > > >  
> > > >  /* Mask to extract KeyID from physical address. */
> > > >  phys_addr_t mktme_keyid_mask;
> > > > +EXPORT_SYMBOL_GPL(mktme_keyid_mask);
> > > >  /*
> > > >   * Number of KeyIDs available for MKTME.
> > > >   * Excludes KeyID-0 which used by TME. MKTME KeyIDs start from 1.
> > > >   */
> > > >  int mktme_nr_keyids;
> > > > +EXPORT_SYMBOL_GPL(mktme_nr_keyids);
> > > >  /* Shift of KeyID within physical address. */
> > > >  int mktme_keyid_shift;
> > > > +EXPORT_SYMBOL_GPL(mktme_keyid_shift);
> > > >  
> > > >  DEFINE_STATIC_KEY_FALSE(mktme_enabled_key);
> > > >  EXPORT_SYMBOL_GPL(mktme_enabled_key);
> > > 
> > > NAK, don't export variables. Who owns the values, who enforces this?
> > > 
> > 
> > Both KVM and IOMMU driver need page_keyid() and mktme_keyid_shift to set page's keyID to the
> > right
> > place in the PTE (of KVM EPT and VT-d DMA page table).
> > 
> > MKTME key type code need to know mktme_nr_keyids in order to alloc/free keyID.
> > 
> > Maybe better to introduce functions instead of exposing variables directly?
> > 
> > Or instead of introducing page_keyid(), we use page_encrypt_mask(), which essentially holds
> > "page_keyid() << mktme_keyid_shift"?
> 
> Yes, that's much better, because that strictly limits the access to R/O.
> 

Thanks. I think Kirill will be the one to handle your suggestion. :)

Kirill?

Thanks,
-Kai
