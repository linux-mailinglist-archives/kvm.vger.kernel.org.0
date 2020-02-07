Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE9515526A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 07:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgBGGYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 01:24:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgBGGYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 01:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=FZP0iQ7V7SgWd2g6clqUyIaa9pDDhceClvjQC6yZ8gc=; b=oUXSOgDctYqjzalLqUrfRY/oYl
        3mNEyg7oK6ZeFlBNI96//BS/C/Ctcc5nSXpQ48i3TsFWVv+5j/mY1zaU671yoLGocq7yt7Xqrov/x
        VEyXJU4iQtBmh1vacrt9kaitB3/6aZH//a6jhq5zeLEuZf7BzoyRo5ATwlW8puh6tSg9gNi2jppcX
        8zG1W4Qq4Qjwc7xYQzVahjWAIc95ByxtYv+GgsM/z9iAG2r/jfUaMin6EN/2ns7MqG2P0AEfym/qk
        YjrY/8ck2xuWrurwH40AplewuUuYbeUpx1aOxgBSKZncGs/ItS6xuC2zsabBoQJpZEojVBhvmEJPF
        O/yIP+XQ==;
Received: from [80.156.29.194] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izx3k-0002BL-Vf; Fri, 07 Feb 2020 06:24:13 +0000
Date:   Fri, 7 Feb 2020 07:24:09 +0100
From:   Mauro Carvalho Chehab <mchehab@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 21/27] docs: kvm: Convert locking.txt to ReST format
Message-ID: <20200207072409.2cb038da@infradead.org>
In-Reply-To: <20200206234736.196ef417@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <1464d69fe780940cec6ecec4ac2505b9701a1e01.1581000481.git.mchehab+huawei@kernel.org>
        <20200206171132.4f51f17a.cohuck@redhat.com>
        <a17d6a27-0d3f-2020-7fc2-87ec20a6225f@redhat.com>
        <20200206234736.196ef417@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> > 
> > Would be nicer but this is acceptable too I think.  Especially, the
> > monospaced font allows breaking the table and keeping the parts aligned.  

I couldn't resist trying to use a table ;-)

The following patch does that. IMO, it looks nice on both text and html
outputs.

Cheers,
Mauro

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 428cb3412ecc..c02291beac3f 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -59,30 +59,39 @@ The mapping from gfn to pfn may be changed since we can only ensure the pfn
 is not changed during cmpxchg. This is a ABA problem, for example, below case
 will happen:
 
-At the beginning::
-
-	gpte = gfn1
-	gfn1 is mapped to pfn1 on host
-	spte is the shadow page table entry corresponding with gpte and
-	spte = pfn1
-
-	   VCPU 0                           VCPU0
-
-on fast page fault path::
-
-   old_spte = *spte;
-                                 pfn1 is swapped out:
-                                    spte = 0;
-
-                                 pfn1 is re-alloced for gfn2.
-
-                                 gpte is changed to point to
-                                 gfn2 by the guest:
-                                    spte = pfn1;
-
-   if (cmpxchg(spte, old_spte, old_spte+W)
-	mark_page_dirty(vcpu->kvm, gfn1)
-             OOPS!!!
++------------------------------------------------------------------------+
+| At the beginning::                                                     |
+|                                                                        |
+|	gpte = gfn1                                                      |
+|	gfn1 is mapped to pfn1 on host                                   |
+|	spte is the shadow page table entry corresponding with gpte and  |
+|	spte = pfn1                                                      |
++------------------------------------------------------------------------+
+| On fast page fault path:                                               |
++------------------------------------+-----------------------------------+
+| CPU 0:                             | CPU 1:                            |
++------------------------------------+-----------------------------------+
+| ::                                 |                                   |
+|                                    |                                   |
+|   old_spte = *spte;                |                                   |
++------------------------------------+-----------------------------------+
+|                                    | pfn1 is swapped out::             |
+|                                    |                                   |
+|                                    |    spte = 0;                      |
+|                                    |                                   |
+|                                    | pfn1 is re-alloced for gfn2.      |
+|                                    |                                   |
+|                                    | gpte is changed to point to       |
+|                                    | gfn2 by the guest::               |
+|                                    |                                   |
+|                                    |    spte = pfn1;                   |
++------------------------------------+-----------------------------------+
+| ::                                                                     |
+|                                                                        |
+|   if (cmpxchg(spte, old_spte, old_spte+W)                              |
+|	mark_page_dirty(vcpu->kvm, gfn1)                                 |
+|            OOPS!!!                                                     |
++------------------------------------------------------------------------+
 
 We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
 
@@ -109,36 +118,42 @@ Accessed bit and Dirty bit can not be lost.
 But it is not true after fast page fault since the spte can be marked
 writable between reading spte and updating spte. Like below case:
 
-At the beginning::
-
-	spte.W = 0
-	spte.Accessed = 1
-
-	   VCPU 0                                       VCPU0
-
-In mmu_spte_clear_track_bits()::
-
-   old_spte = *spte;
-
-   /* 'if' condition is satisfied. */
-   if (old_spte.Accessed == 1 &&
-        old_spte.W == 0)
-      spte = 0ull;
-                                         on fast page fault path:
-                                             spte.W = 1
-                                         memory write on the spte:
-                                             spte.Dirty = 1
-
-
-   else
-      old_spte = xchg(spte, 0ull)
-
-
-   if (old_spte.Accessed == 1)
-      kvm_set_pfn_accessed(spte.pfn);
-   if (old_spte.Dirty == 1)
-      kvm_set_pfn_dirty(spte.pfn);
-      OOPS!!!
++------------------------------------------------------------------------+
+| At the beginning::                                                     |
+|                                                                        |
+|	spte.W = 0                                                       |
+|	spte.Accessed = 1                                                |
++------------------------------------+-----------------------------------+
+| CPU 0:                             | CPU 1:                            |
++------------------------------------+-----------------------------------+
+| In mmu_spte_clear_track_bits()::   |                                   |
+|                                    |                                   |
+|  old_spte = *spte;                 |                                   |
+|                                    |                                   |
+|                                    |                                   |
+|  /* 'if' condition is satisfied. */|                                   |
+|  if (old_spte.Accessed == 1 &&     |                                   |
+|       old_spte.W == 0)             |                                   |
+|     spte = 0ull;                   |                                   |
++------------------------------------+-----------------------------------+
+|                                    | on fast page fault path::         |
+|                                    |                                   |
+|                                    |    spte.W = 1                     |
+|                                    |                                   |
+|                                    | memory write on the spte::        |
+|                                    |                                   |
+|                                    |    spte.Dirty = 1                 |
++------------------------------------+-----------------------------------+
+|  ::                                |                                   |
+|                                    |                                   |
+|   else                             |                                   |
+|     old_spte = xchg(spte, 0ull)    |                                   |
+|   if (old_spte.Accessed == 1)      |                                   |
+|     kvm_set_pfn_accessed(spte.pfn);|                                   |
+|   if (old_spte.Dirty == 1)         |                                   |
+|     kvm_set_pfn_dirty(spte.pfn);   |                                   |
+|     OOPS!!!                        |                                   |
++------------------------------------+-----------------------------------+
 
 The Dirty bit is lost in this case.
 
