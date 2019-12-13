Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E063F11E91B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 18:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfLMRTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 12:19:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:23731 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbfLMRTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 12:19:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 09:19:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="414351942"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 13 Dec 2019 09:19:50 -0800
Date:   Fri, 13 Dec 2019 09:19:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Barret Rhoden <brho@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
Message-ID: <20191213171950.GA31552@linux.intel.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 03:07:31AM +0200, Liran Alon wrote:
> 
> > On 12 Dec 2019, at 21:55, Barret Rhoden <brho@google.com> wrote:
> > 
> >>>> Note that KVM already faulted in the page (or huge page) in the host's
> >>>> page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
> >>>> kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.
> >>>> 
> >>>> Signed-off-by: Barret Rhoden <brho@google.com>
> >>> 
> >>> I don’t think the right place to change for this functionality is
> >>> transparent_hugepage_adjust() which is meant to handle PFNs that are
> >>> mapped as part of a transparent huge-page.
> >>> 
> >>> For example, this would prevent mapping DAX-backed file page as 1GB.  As
> >>> transparent_hugepage_adjust() only handles the case (level ==
> >>> PT_PAGE_TABLE_LEVEL).

Teaching thp_adjust() how to handle 1GB wouldn't be a bad thing.  It's
unlikely THP itself will support 1GB pages any time soon, but having the
logic there wouldn't hurt anything.

> >>> As you are parsing the page-tables to discover the page-size the PFN is
> >>> mapped in, I think you should instead modify kvm_host_page_size() to
> >>> parse page-tables instead of rely on vma_kernel_pagesize() (Which relies
> >>> on vma->vm_ops->pagesize()) in case of is_zone_device_page().
> >>>
> >>> The main complication though of doing this is that at this point you
> >>> don’t yet have the PFN that is retrieved by try_async_pf(). So maybe you
> >>> should consider modifying the order of calls in tdp_page_fault() &
> >>> FNAME(page_fault)().
> >>> 
> >>> -Liran
> >> Or alternatively when thinking about it more, maybe just rename
> >> transparent_hugepage_adjust() to not be specific to THP and better handle
> >> the case of parsing page-tables changing mapping-level to 1GB.
> >> That is probably easier and more elegant.

Agreed.

> > I can rename it to hugepage_adjust(), since it's not just THP anymore.

Or maybe allowed_hugepage_adjust()?  To pair with disallowed_hugepage_adjust(),
which adjusts KVM's page size in the opposite direction to avoid the iTLB
multi-hit issue.

> 
> Sounds good.
> 
> > 
> > I was a little hesitant to change the this to handle 1 GB pages with this
> > patchset at first.  I didn't want to break the non-DAX case stuff by doing
> > so.
> 
> Why would it affect non-DAX case?
> Your patch should just make hugepage_adjust() to parse page-tables only in case is_zone_device_page(). Otherwise, page tables shouldn’t be parsed.
> i.e. THP merged pages should still be detected by PageTransCompoundMap().

I think what Barret is saying is that teaching thp_adjust() how to do 1gb
mappings would naturally affect the code path for THP pages.  But I agree
that it would be superficial.
 
> > Specifically, can a THP page be 1 GB, and if so, how can you tell?  If you
> > can't tell easily, I could walk the page table for all cases, instead of
> > just zone_device().

No, THP doesn't currently support 1gb pages.  Expliciting returning
PMD_SIZE on PageTransCompoundMap() would be a good thing from a readability
perspective.

> I prefer to walk page-tables only for is_zone_device_page().
> 
> > 
> > I'd also have to drop the "level == PT_PAGE_TABLE_LEVEL" check, I think,
> > which would open this up to hugetlbfs pages (based on the comments).  Is
> > there any reason why that would be a bad idea?

No, the "level == PT_PAGE_TABLE_LEVEL" check is to filter out the case
where KVM is already planning on using a large page, e.g. when the memory
is backed by hugetlbs.

> KVM already supports mapping 1GB hugetlbfs pages. As level is set to
> PUD-level by
> tdp_page_fault()->mapping_level()->host_mapping_level()->kvm_host_page_size()->vma_kernel_pagesize().
> As VMA which is mmap of hugetlbfs sets vma->vm_ops to hugetlb_vm_ops() where
> hugetlb_vm_op_pagesize() will return appropriate page-size.
> 
> Specifically, I don’t think THP ever merges small pages to 1GB pages. I think
> this is why transparent_hugepage_adjust() checks PageTransCompoundMap() only
> in case level == PT_PAGE_TABLE_LEVEL. I think you should keep this check in
> the case of !is_zone_device_page().

I would add 1gb support for DAX as a third patch in this series.  To pave
the way in patch 2/2, change it to replace "bool pfn_is_huge_mapped()" with
"int host_pfn_mapping_level()", and maybe also renaming host_mapping_level()
to host_vma_mapping_level() to avoid confusion.

Then allowed_hugepage_adjust() would look something like:

static void allowed_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
				    kvm_pfn_t *pfnp, int *levelp, int max_level)
{
	kvm_pfn_t pfn = *pfnp;
	int level = *levelp;	
	unsigned long mask;

	if (is_error_noslot_pfn(pfn) || !kvm_is_reserved_pfn(pfn) ||
	    level == PT_PAGE_TABLE_LEVEL)
		return;

	/*
	 * mmu_notifier_retry() was successful and mmu_lock is held, so
	 * the pmd/pud can't be split from under us.
	 */
	level = host_pfn_mapping_level(vcpu->kvm, gfn, pfn);

	*levelp = level = min(level, max_level);
	mask = KVM_PAGES_PER_HPAGE(level) - 1;
	VM_BUG_ON((gfn & mask) != (pfn & mask));
	*pfnp = pfn & ~mask;
}
