Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577A7465C9
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 19:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfFNRcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 13:32:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:41698 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbfFNRcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 13:32:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 10:32:34 -0700
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 10:32:34 -0700
Date:   Fri, 14 Jun 2019 10:35:41 -0700
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
Message-ID: <20190614173541.GC5917@alison-desk.jf.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
 <20190614114732.GE3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614114732.GE3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 01:47:32PM +0200, Peter Zijlstra wrote:
> On Wed, May 08, 2019 at 05:44:05PM +0300, Kirill A. Shutemov wrote:
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 2e0033348d8e..695c121b34b3 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -755,8 +755,8 @@ int setup_arg_pages(struct linux_binprm *bprm,
> >  	vm_flags |= mm->def_flags;
> >  	vm_flags |= VM_STACK_INCOMPLETE_SETUP;
> >  
> > -	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end,
> > -			vm_flags);
> > +	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end, vm_flags,
> > +			     -1);
> 
> You added a nice NO_KEY helper a few patches back, maybe use it?

Sure, done.
(I hesitated to define NO_KEY in mm.h initially. Put it there now.
We'll see how that looks it next round.)

> 
> >  	if (ret)
> >  		goto out_unlock;
> >  	BUG_ON(prev != vma);
