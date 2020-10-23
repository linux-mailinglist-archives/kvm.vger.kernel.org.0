Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E262973EA
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750745AbgJWQcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:32:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:44372 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S376033AbgJWQcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 12:32:14 -0400
IronPort-SDR: B0NU0EdIFd/RS0sZ8Q7p9UpfG9VtccGqZSfeHnf2sMlw5LshKFAzM6mXeARf1dsFX7jAj70jzY
 88ON6Fpm1xjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="154658378"
X-IronPort-AV: E=Sophos;i="5.77,409,1596524400"; 
   d="scan'208";a="154658378"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 09:32:02 -0700
IronPort-SDR: 71aJvcrUnpatw20KEuhZ3rsuXf7oGTND3XZXVxTlK40kSHCdl/N440+ISf1WSgAX+bfXg19DUl
 JcldFVkia1+Q==
X-IronPort-AV: E=Sophos;i="5.77,409,1596524400"; 
   d="scan'208";a="524731467"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 09:32:01 -0700
Date:   Fri, 23 Oct 2020 09:32:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
Message-ID: <20201023163158.GB5580@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
 <20201023123712.GC392079@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023123712.GC392079@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 23, 2020 at 03:37:12PM +0300, Mike Rapoport wrote:
> On Tue, Oct 20, 2020 at 09:18:58AM +0300, Kirill A. Shutemov wrote:
> > If the protected memory feature enabled, unmap guest memory from
> > kernel's direct mappings.
> > 
> > Migration and KSM is disabled for protected memory as it would require a
> > special treatment.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  include/linux/mm.h       |  3 +++
> >  mm/huge_memory.c         |  8 ++++++++
> >  mm/ksm.c                 |  2 ++
> >  mm/memory.c              | 12 ++++++++++++
> >  mm/rmap.c                |  4 ++++
> >  virt/lib/mem_protected.c | 21 +++++++++++++++++++++
> >  6 files changed, 50 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ee274d27e764..74efc51e63f0 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -671,6 +671,9 @@ static inline bool vma_is_kvm_protected(struct vm_area_struct *vma)
> >  	return vma->vm_flags & VM_KVM_PROTECTED;
> >  }
> >  
> > +void kvm_map_page(struct page *page, int nr_pages);
> > +void kvm_unmap_page(struct page *page, int nr_pages);
> 
> This still does not seem right ;-)
> 
> And I still think that map/unmap primitives shoud be a part of the
> generic mm rather than exported by KVM.

Ya, and going a step further, I suspect it will be cleaner in the long run if
the kernel does not automatically map or unmap when converting between private
and shared/public memory.  Conversions will be rare in a well behaved guest, so
exiting to userspace and forcing userspace to do the unmap->map would not be a
performance bottleneck.  In theory, userspace could also maintain separate
pools for private vs. public mappings, though I doubt any VMM will do that in
practice.
