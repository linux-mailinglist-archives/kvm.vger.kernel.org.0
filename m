Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2F6154F13
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgBFWrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:47:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgBFWrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=X5g/vz2mielUqGgcMniEPqPAC4edakR71gQvCI0vZpA=; b=X4Hz7KTx6g2GH2KN/j6C8ln1l2
        2UJ06yVeUOiv+YUUEblU3kx6TVrSMA7TrTGGgKoBRaagjBh+cF+BcPUvTDn3noHBeTx96dDce1Cna
        TseAqqJA9Ze1EILMbnko3IsQSDqvInPvr4NqCjq+biMen9B9+8g3F+We1wFI2URJ3eCU+J0xIy4uD
        BMTheP3l9x/gXkqH6IO07Lq+ulzi+29RQWmXVZtqDX2DSvV89C3Svn/Xe+EFwj4vgNUc4bnHwCru/
        FQv9nrQtowcqGfk9cynnNM5oltGooiyIGDICqXzQvAHPkLzft2U6z2ZBLkWRe8JZ7ZhSzyiGgXz6x
        SNQEl9LA==;
Received: from [80.156.29.194] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izpvw-0007dP-Ne; Thu, 06 Feb 2020 22:47:41 +0000
Date:   Thu, 6 Feb 2020 23:47:36 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 21/27] docs: kvm: Convert locking.txt to ReST format
Message-ID: <20200206234736.196ef417@kernel.org>
In-Reply-To: <a17d6a27-0d3f-2020-7fc2-87ec20a6225f@redhat.com>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <1464d69fe780940cec6ecec4ac2505b9701a1e01.1581000481.git.mchehab+huawei@kernel.org>
        <20200206171132.4f51f17a.cohuck@redhat.com>
        <a17d6a27-0d3f-2020-7fc2-87ec20a6225f@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Thu, 6 Feb 2020 22:57:39 +0100
Paolo Bonzini <pbonzini@redhat.com> escreveu:

> On 06/02/20 17:11, Cornelia Huck wrote:
> > On Thu,  6 Feb 2020 15:50:18 +0100
> > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> >   
> >> - Use document title and chapter markups;
> >> - Add markups for literal blocks;
> >> - use :field: for field descriptions;
> >> - Add blank lines and adjust indentation.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> >> ---
> >>  Documentation/virt/kvm/index.rst              |   1 +
> >>  .../virt/kvm/{locking.txt => locking.rst}     | 111 ++++++++++--------
> >>  2 files changed, 63 insertions(+), 49 deletions(-)
> >>  rename Documentation/virt/kvm/{locking.txt => locking.rst} (78%)  
> > 
> > (...)
> >   
> >> @@ -48,19 +52,23 @@ restore the saved R/X bits if VMX_EPT_TRACK_ACCESS mask is set, or both. This
> >>  is safe because whenever changing these bits can be detected by cmpxchg.
> >>  
> >>  But we need carefully check these cases:
> >> -1): The mapping from gfn to pfn
> >> +
> >> +1) The mapping from gfn to pfn
> >> +
> >>  The mapping from gfn to pfn may be changed since we can only ensure the pfn
> >>  is not changed during cmpxchg. This is a ABA problem, for example, below case
> >>  will happen:
> >>  
> >> -At the beginning:
> >> -gpte = gfn1
> >> -gfn1 is mapped to pfn1 on host
> >> -spte is the shadow page table entry corresponding with gpte and
> >> -spte = pfn1
> >> +At the beginning::
> >>  
> >> -   VCPU 0                           VCPU0
> >> -on fast page fault path:
> >> +	gpte = gfn1
> >> +	gfn1 is mapped to pfn1 on host
> >> +	spte is the shadow page table entry corresponding with gpte and
> >> +	spte = pfn1
> >> +
> >> +	   VCPU 0                           VCPU0
> >> +
> >> +on fast page fault path::
> >>  
> >>     old_spte = *spte;
> >>                                   pfn1 is swapped out:  
> > 
> > I'm wondering if that should rather be converted to a proper table.  

Converting into a table would require to escape the asterisk, e. g.:

	old_spte = \*spte;

or:

	``old_spte = *spte;``

	(and, for consistency, for all other stuff there)
	

So, yeah, the html/pdf output could be nicer, but it would be worse for those
who read the .rst file.

> 
> Would be nicer but this is acceptable too I think.  Especially, the
> monospaced font allows breaking the table and keeping the parts aligned.

FYI, there's a way to setup monospaced font on a table by using a template.

As I pointed a while ago, it would require to add something to the
Sphinx theme:

	diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
	index e21e36cd6761..0948de6651f8 100644
	--- a/Documentation/sphinx-static/theme_overrides.css
	+++ b/Documentation/sphinx-static/theme_overrides.css
	@@ -125,3 +125,7 @@ div[class^="highlight"] pre {
	         color: inherit;
	     }
	 }
	+
	+table.monospaced {
	+	font-family: monospace, monospace;
	+}

Then use, at locking.rst (or anywhere when a monospaced font is desired):

	+.. cssclass:: monospaced

	+ ==== ====== =====
	+ Some Random Table
	+ ==== ====== =====

For completeness, a similar template class should also be needed at 
latex_prefix setting at Documentation/conf.py, implementing the same
feature for LaTeX and PDF output.

IMHO, this would be too complex for not much gain.

> 
> But the two headers should be "CPU 0" and "CPU 1", and it's worth
> changing that while we're at it.  Same for the table below.

Ok.

Maybe we could append the enclosed patch to this one. I suspect it would
visually be better.

Cheers,
Mauro

---

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 428cb3412ecc..82322a4c9fde 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -57,18 +57,18 @@ But we need carefully check these cases:
 
 The mapping from gfn to pfn may be changed since we can only ensure the pfn
 is not changed during cmpxchg. This is a ABA problem, for example, below case
-will happen:
+will happen::
 
-At the beginning::
+  At the beginning:
 
 	gpte = gfn1
 	gfn1 is mapped to pfn1 on host
 	spte is the shadow page table entry corresponding with gpte and
 	spte = pfn1
 
-	   VCPU 0                           VCPU0
+  On fast page fault path:
 
-on fast page fault path::
+	   CPU 0                           CPU 1
 
    old_spte = *spte;
                                  pfn1 is swapped out:
@@ -80,6 +80,7 @@ on fast page fault path::
                                  gfn2 by the guest:
                                     spte = pfn1;
 
+
    if (cmpxchg(spte, old_spte, old_spte+W)
 	mark_page_dirty(vcpu->kvm, gfn1)
              OOPS!!!
@@ -107,16 +108,16 @@ spte is read-only and the Accessed bit has already been set since the
 Accessed bit and Dirty bit can not be lost.
 
 But it is not true after fast page fault since the spte can be marked
-writable between reading spte and updating spte. Like below case:
+writable between reading spte and updating spte. Like below case::
 
-At the beginning::
+  At the beginning:
 
 	spte.W = 0
 	spte.Accessed = 1
 
-	   VCPU 0                                       VCPU0
+	   CPU 0                                       CPU 1
 
-In mmu_spte_clear_track_bits()::
+  In mmu_spte_clear_track_bits():
 
    old_spte = *spte;
 
