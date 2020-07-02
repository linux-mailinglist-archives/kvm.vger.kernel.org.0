Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB61D212FDE
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 01:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGBXIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 19:08:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:22836 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgGBXIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 19:08:50 -0400
IronPort-SDR: 9KBl74tTI4gZx3K3SxW4LaN6VqZR7pSM6DfSMZbOvIaJLnlJ18KCRF0eevrxDUd7F95O/d65yj
 o6W2S1r+G5ig==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="134507530"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="134507530"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 16:08:49 -0700
IronPort-SDR: nqD/LQS7GowioAIHzBOTKSewaXL6TK4pMcJMspEozGQdTCShYXn9rHORtrFZdeBlGoiS4JPhs0
 XF8wTVircYCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="267199222"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jul 2020 16:08:49 -0700
Date:   Thu, 2 Jul 2020 16:08:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v10 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200702230849.GL3575@linux.intel.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601115957.1581250-3-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 01, 2020 at 07:59:45AM -0400, Peter Xu wrote:
> Cache the address space ID just like the slot ID.  It will be used in
> order to fill in the dirty ring entries.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/kvm_main.c      | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 01276e3d01b9..5e7bbaf7a36b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -346,6 +346,7 @@ struct kvm_memory_slot {
>  	unsigned long userspace_addr;
>  	u32 flags;
>  	short id;
> +	u16 as_id;
>  };
>  
>  static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 74bdb7bf3295..ebdd98a30e82 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1243,6 +1243,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if (!mem->memory_size)
>  		return kvm_delete_memslot(kvm, mem, &old, as_id);

This technically needs to set as_id in the deleted memslot.  I highly doubt
it will ever matter from a functionality perspective, but it'd be confusing
to encounter a memslot whose as_id did not match that of its owner.

> +	new.as_id = as_id;
>  	new.id = id;
>  	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
>  	new.npages = mem->memory_size >> PAGE_SHIFT;
> -- 
> 2.26.2
> 
