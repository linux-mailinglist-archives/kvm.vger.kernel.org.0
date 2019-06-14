Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C732346556
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfFNRHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 13:07:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:50750 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFNRHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 13:07:19 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 10:07:18 -0700
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 10:07:18 -0700
Date:   Fri, 14 Jun 2019 10:10:25 -0700
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
Subject: Re: [PATCH, RFC 26/62] keys/mktme: Move the MKTME payload into a
 cache aligned structure
Message-ID: <20190614171025.GA5917@alison-desk.jf.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-27-kirill.shutemov@linux.intel.com>
 <20190614113523.GC3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614113523.GC3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 01:35:23PM +0200, Peter Zijlstra wrote:
> On Wed, May 08, 2019 at 05:43:46PM +0300, Kirill A. Shutemov wrote:
> 
> > +/* Copy the payload to the HW programming structure and program this KeyID */
> > +static int mktme_program_keyid(int keyid, struct mktme_payload *payload)
> > +{
> > +	struct mktme_key_program *kprog = NULL;
> > +	int ret;
> > +
> > +	kprog = kmem_cache_zalloc(mktme_prog_cache, GFP_ATOMIC);
> 
> Why GFP_ATOMIC, afaict neither of the usage is with a spinlock held.

Got it. GFP_ATOMIC not needed.
That said, this is an artifact of reworking the locking, and that 
locking may need to change again. If it does, will try to pre-allocate
rather than depend on GFP_ATOMIC here.

> 
> > +	if (!kprog)
> > +		return -ENOMEM;
> > +
> > +	/* Hardware programming requires cached aligned struct */
> > +	kprog->keyid = keyid;
> > +	kprog->keyid_ctrl = payload->keyid_ctrl;
> > +	memcpy(kprog->key_field_1, payload->data_key, MKTME_AES_XTS_SIZE);
> > +	memcpy(kprog->key_field_2, payload->tweak_key, MKTME_AES_XTS_SIZE);
> > +
> > +	ret = MKTME_PROG_SUCCESS;	/* Future programming call */
> > +	kmem_cache_free(mktme_prog_cache, kprog);
> > +	return ret;
> > +}
