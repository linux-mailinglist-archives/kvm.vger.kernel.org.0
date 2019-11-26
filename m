Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4645010A389
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 18:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfKZRqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 12:46:08 -0500
Received: from mga17.intel.com ([192.55.52.151]:15766 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfKZRqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 12:46:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2019 09:46:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,246,1571727600"; 
   d="scan'208";a="383222652"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 26 Nov 2019 09:46:03 -0800
Date:   Tue, 26 Nov 2019 09:46:03 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: THP refcounting in disallowed_hugepage_adjust()?
Message-ID: <20191126174603.GB22233@linux.intel.com>
References: <20191126152109.GA23850@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126152109.GA23850@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 26, 2019 at 04:21:09PM +0100, Joerg Roedel wrote:
> Hi Paolo et al,
> 
> while looking again at the recently added IFU patches I noticed a
> dicrepancy between the two _hugepage_adjust() functions which doesn't
> make sense to me yet:
> 
> 	* transparent_hugepage_adjust(), when changing the value of pfn,
> 	  does a kvm_release_pfn_clean() on the old value and a
> 	  kvm_get_pfn() on the new value to make sure the code holds the
> 	  reference to the correct pfn.
> 
> 	* disallowed_hugepage_adjust() also changes the value of the pfn
> 	  to map, kinda reverses what transparent_hugepage_adjust() did
> 	  before. But that function does not care about the pfn
> 	  refcounting.
> 
> I was wondering what the reason for that might be, is it just not
> necessary in disallowed_hugepage_adjust() or is that an oversight?

The page fault flows don't actually rely on holding a reference to the
page once they reach thp_adjust().  At that point, they hold mmu_lock and
have verified no invalidation from mmu_notifier have occured since the
page reference was acquired. 

The release/get pfn dance in transparent_hugepage_adjust() is a quirk of
sorts that is necessitated because thp_adjust() modifies the local @pfn
variable in FNAME(page_fault)(), nonpaging_map() and tdp_page_fault().
Those functions all call kvm_release_pfn_clean() on @pfn, so thp_adjust()
needs to transfer the page reference purely for correctness when the pfn
is released.

disallowed_hugepage_adjust() is called from __direct_map() and its
modification of the pfn is also contained to __direct_map(), i.e. the
updated @pfn doesn't get propagated back up to the fault handlers.  Thus,
kvm_release_pfn_clean() is called on the original pfn and so there's no
need to transfer the page reference.

The above discrepancy can resolved by moving thp_adjust() into FNAME(fetch)
and __direct_map() so that the "top-level" @pfn isn't modified.  Getting
rid of the kvm_get_pfn() call would be a nice side effect.  The downside is
that @force_pt_level would need to be passed down the call stack.
