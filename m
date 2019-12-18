Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C93123B6E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 01:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfLRAS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 19:18:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:33088 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfLRAS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 19:18:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 16:18:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="217971873"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 17 Dec 2019 16:18:57 -0800
Date:   Tue, 17 Dec 2019 16:18:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Barret Rhoden <brho@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Subject: Re: [PATCH v5 1/2] mm: make dev_pagemap_mapping_shift() externally
 visible
Message-ID: <20191218001857.GM11771@linux.intel.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-2-brho@google.com>
 <20191213174702.GB31552@linux.intel.com>
 <e004e742-f755-c22c-57bb-acfe30971c7d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e004e742-f755-c22c-57bb-acfe30971c7d@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 12:59:53PM -0500, Barret Rhoden wrote:
> On 12/13/19 12:47 PM, Sean Christopherson wrote:
> >>+EXPORT_SYMBOL_GPL(dev_pagemap_mapping_shift);
> >
> >This is basically a rehash of lookup_address_in_pgd(), and doesn't provide
> >exactly what KVM needs.  E.g. KVM works with levels instead of shifts, and
> >it would be nice to provide the pte so that KVM can sanity check that the
> >pfn from this walk matches the pfn it plans on mapping.
> 
> One minor issue is that the levels for lookup_address_in_pgd() and for KVM
> differ in name, although not in value.  lookup uses PG_LEVEL_4K = 1.  KVM
> uses PT_PAGE_TABLE_LEVEL = 1.  The enums differ a little too: x86 has a name
> for a 512G page, etc.  It's all in arch/x86.
> 
> Does KVM-x86 need its own names for the levels?  If not, I could convert the
> PT_PAGE_TABLE_* stuff to PG_LEVEL_* stuff.

Not really.  I suspect the whole reason KVM has different enums is to
handle PSE/Mode-B paging, where PG_LEVEL_2M would be inaccurate, e.g.:

	if (PTTYPE == 32 && walker->level == PT_DIRECTORY_LEVEL && is_cpuid_PSE36())
		gfn += pse36_gfn_delta(pte);

That being said, I absolute loathe PT_PAGE_TABLE_LEVEL, I can never
remember that it means 4k pages.  I would be in favor of using the kernel's
enums with some KVM-specific abstraction of PG_LEVEL_2M, e.g.

/* KVM Hugepage definitions for x86 */
enum {
	PG_LEVEL_2M_OR_4M      = PG_LEVEL_2M,
	/* set max level to the biggest one */
	KVM_MAX_HUGEPAGE_LEVEL = PG_LEVEL_1G,
};

And ideally restrict usage of the ugly PG_LEVEL_2M_OR_4M to flows that can
actually encounter 4M pages, i.e. when walking guest page tables.  On the
host side, KVM always uses PAE or 64-bit paging.

Personally, I'd pursue that in a separate patch/series, it'll touch a
massive amount of code and will probably get bikeshedded a fair amount.
