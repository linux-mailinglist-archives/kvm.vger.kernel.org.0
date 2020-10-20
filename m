Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4B293C34
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 14:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406681AbgJTMwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 08:52:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:52601 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406593AbgJTMwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 08:52:01 -0400
IronPort-SDR: UwJ1IdKv0rCa2GzD2pBM2rPWxf7fXZslNXb5IIO+NTVlBX253yQoFApQJFtc3/19m+vvXywFO4
 +fwrRY2rw5tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="164591009"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="164591009"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 05:52:00 -0700
IronPort-SDR: UEFABtKtnYFOe4P6NOaSR5SB36QwNAnSG9m5wo/9TnknmKohpwShq2ccBkV2hHffiaizBJbJnI
 0fNyj+amCb0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="301681442"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 05:51:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 3D120376; Tue, 20 Oct 2020 15:51:55 +0300 (EEST)
Date:   Tue, 20 Oct 2020 15:51:55 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20201020125155.7hubssbqhbm2dypj@black.fi.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
 <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 01:25:59AM -0700, John Hubbard wrote:
> On 10/19/20 11:18 PM, Kirill A. Shutemov wrote:
> > New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> > protection feature is enabled.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >   include/linux/kvm_host.h |  4 ++
> >   virt/kvm/kvm_main.c      | 90 +++++++++++++++++++++++++++++++---------
> >   2 files changed, 75 insertions(+), 19 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 05e3c2fb3ef7..380a64613880 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -504,6 +504,7 @@ struct kvm {
> >   	struct srcu_struct irq_srcu;
> >   	pid_t userspace_pid;
> >   	unsigned int max_halt_poll_ns;
> > +	bool mem_protected;
> >   };
> >   #define kvm_err(fmt, ...) \
> > @@ -728,6 +729,9 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
> >   void kvm_set_pfn_accessed(kvm_pfn_t pfn);
> >   void kvm_get_pfn(kvm_pfn_t pfn);
> > +int copy_from_guest(void *data, unsigned long hva, int len, bool protected);
> > +int copy_to_guest(unsigned long hva, const void *data, int len, bool protected);
> > +
> >   void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
> >   int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> >   			int len);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index cf88233b819a..a9884cb8c867 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2313,19 +2313,70 @@ static int next_segment(unsigned long len, int offset)
> >   		return len;
> >   }
> > +int copy_from_guest(void *data, unsigned long hva, int len, bool protected)
> > +{
> > +	int offset = offset_in_page(hva);
> > +	struct page *page;
> > +	int npages, seg;
> > +
> > +	if (!protected)
> > +		return __copy_from_user(data, (void __user *)hva, len);
> > +
> > +	might_fault();
> > +	kasan_check_write(data, len);
> > +	check_object_size(data, len, false);
> > +
> > +	while ((seg = next_segment(len, offset)) != 0) {
> > +		npages = get_user_pages_unlocked(hva, 1, &page, 0);
> > +		if (npages != 1)
> > +			return -EFAULT;
> > +		memcpy(data, page_address(page) + offset, seg);
> 
> Hi Kirill!
> 
> OK, so the copy_from_guest() is a read-only case for gup, which I think is safe
> from a gup/pup + filesystem point of view, but see below about copy_to_guest()...
> 
> > +		put_page(page);
> > +		len -= seg;
> > +		hva += seg;
> > +		offset = 0;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int copy_to_guest(unsigned long hva, const void *data, int len, bool protected)
> > +{
> > +	int offset = offset_in_page(hva);
> > +	struct page *page;
> > +	int npages, seg;
> > +
> > +	if (!protected)
> > +		return __copy_to_user((void __user *)hva, data, len);
> > +
> > +	might_fault();
> > +	kasan_check_read(data, len);
> > +	check_object_size(data, len, true);
> > +
> > +	while ((seg = next_segment(len, offset)) != 0) {
> > +		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
> 
> 
> Should copy_to_guest() use pin_user_pages_unlocked() instead of gup_unlocked?
> We wrote a  "Case 5" in Documentation/core-api/pin_user_pages.rst, just for this
> situation, I think:
> 
> 
> CASE 5: Pinning in order to write to the data within the page
> -------------------------------------------------------------
> Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
> write to a page's data, unpin" can cause a problem. Case 5 may be considered a
> superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
> other words, if the code is neither Case 1 nor Case 2, it may still require
> FOLL_PIN, for patterns like this:
> 
> Correct (uses FOLL_PIN calls):
>     pin_user_pages()
>     write to the data within the pages
>     unpin_user_pages()

Right. I didn't internalize changes in GUP interface yet. Will update.

-- 
 Kirill A. Shutemov
