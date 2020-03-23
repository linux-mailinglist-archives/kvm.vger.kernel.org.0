Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B34190042
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 22:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgCWV2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 17:28:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:6139 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgCWV2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 17:28:51 -0400
IronPort-SDR: 8dUI776iB47pUP1ATV2x2fL6ofzXbgOk089LTpP199sMwN/huegDEjSEbB4wBrJlPBaWWVwwrk
 f/mnlgL5XqEQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:28:50 -0700
IronPort-SDR: v7m990sy4UIzlgnBvHixJeHDugXx9yBPcaHMHJPtLr+/szpFs3u3DwOitw/M6BsSCCFEHT9NSG
 +kHzcOzkIrvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="419648976"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Mar 2020 14:28:50 -0700
Date:   Mon, 23 Mar 2020 14:28:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 6/7] KVM: selftests: Expose the primary memslot number to
 tests
Message-ID: <20200323212850.GU28711@linux.intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-7-sean.j.christopherson@intel.com>
 <20200323191202.GN127076@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323191202.GN127076@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 03:12:02PM -0400, Peter Xu wrote:
> On Fri, Mar 20, 2020 at 01:55:45PM -0700, Sean Christopherson wrote:
> > Add a define for the primary memslot number so that tests can manipulate
> > the memslot, e.g. to delete it.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h | 2 ++
> >  tools/testing/selftests/kvm/lib/kvm_util.c     | 4 ++--
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index 0f0e86e188c4..43b5feb546c6 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -60,6 +60,8 @@ enum vm_mem_backing_src_type {
> >  	VM_MEM_SRC_ANONYMOUS_HUGETLB,
> >  };
> >  
> > +#define VM_PRIMARY_MEM_SLOT	0
> > +
> >  int kvm_check_cap(long cap);
> >  int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
> >  
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index f69fa84c9a4c..6a1af0455e44 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -247,8 +247,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
> >  	/* Allocate and setup memory for guest. */
> >  	vm->vpages_mapped = sparsebit_alloc();
> >  	if (phy_pages != 0)
> > -		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> > -					    0, 0, phy_pages, 0);
> > +		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0,
> > +					    VM_PRIMARY_MEM_SLOT, phy_pages, 0);
> 
> IIUC VM_PRIMARY_MEM_SLOT should be used more than here... E.g., to all
> the places that allocate page tables in virt_map() as the last param?
> I didn't check other places.

Ouch, yeah, it bleeds into vm_vaddr_alloc() as well.
 
> Maybe it's simpler to drop this patch for now and use 0 directly as
> before for now, after all in the last patch the comment is good enough
> for me to understand slot 0 is the default slot.

Ya, I'll drop this and hardcode '0', it's a rather absurd amount of call
sites to change.
