Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C36510B60C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfK0Srh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:47:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:15822 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbfK0Srh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:47:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 10:47:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="383586811"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 27 Nov 2019 10:47:36 -0800
Date:   Wed, 27 Nov 2019 10:47:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 06/28] kvm: mmu: Replace mmu_lock with a read/write
 lock
Message-ID: <20191127184736.GF22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-7-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:02PM -0700, Ben Gardon wrote:
> Replace the KVM MMU spinlock with a read/write lock so that some parts of
> the MMU can be made more concurrent in future commits by switching some
> write mode aquisitions to read mode. A read/write lock was chosen over
> other synchronization options beause it has minimal initial impact: this
> change simply changes all uses of the MMU spin lock to an MMU read/write
> lock, in write mode. This change has no effect on the logic of the code
> and only a small performance penalty.
> 
> Other, more invasive options were considered for synchronizing access to
> the paging structures. Sharding the MMU lock to protect 2MB chunks of
> addresses, as the main MM does, would also work, however it makes
> acquiring locks for operations on large regions of memory expensive.
> Further, the parallel page fault handling algorithm introduced later in
> this series does not require exclusive access to the region of memory
> for which it is handling a fault.
> 
> There are several disadvantages to the read/write lock approach:
> 1. The reader/writer terminology does not apply well to MMU operations.
> 2. Many operations require exclusive access to a region of memory
> (often a memslot), but not all of memory. The read/write lock does not
> facilitate this.
> 3. Contention between readers and writers can still create problems in
> the face of long running MMU operations.
> 
> Despite these issues,the use of a read/write lock facilitates
> substantial improvements over the monolithic locking scheme.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu.c         | 106 +++++++++++++++++++------------------
>  arch/x86/kvm/page_track.c  |   8 +--
>  arch/x86/kvm/paging_tmpl.h |   8 +--
>  arch/x86/kvm/x86.c         |   4 +-
>  include/linux/kvm_host.h   |   3 +-
>  virt/kvm/kvm_main.c        |  34 ++++++------
>  6 files changed, 83 insertions(+), 80 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 56587655aecb9..0311d18d9a995 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2446,9 +2446,9 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
>  			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
>  			mmu_pages_clear_parents(&parents);
>  		}
> -		if (need_resched() || spin_needbreak(&vcpu->kvm->mmu_lock)) {

I gather there is no equivalent to spin_needbreak() for r/w locks?  Is it
something that can be added?  Losing spinlock contention detection will
negatively impact other flows, e.g. fast zapping all pages will no longer
drop the lock to allow insertion of SPTEs into the new generation of MMU.

> +		if (need_resched()) {
>  			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
> -			cond_resched_lock(&vcpu->kvm->mmu_lock);
> +			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
>  			flush = false;
>  		}
>  	}
