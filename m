Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968B8180093
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCJOtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:49:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:49085 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgCJOtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 10:49:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 07:48:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,537,1574150400"; 
   d="scan'208";a="276977480"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 10 Mar 2020 07:48:59 -0700
Date:   Tue, 10 Mar 2020 07:48:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200310144858.GA7600@linux.intel.com>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309214424.330363-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309214424.330363-3-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 05:44:12PM -0400, Peter Xu wrote:
> Cache the address space ID just like the slot ID.  It will be used in
> order to fill in the dirty ring entries.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/kvm_main.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index bcb9b2ac0791..afa0e9034881 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -346,6 +346,7 @@ struct kvm_memory_slot {
>  	unsigned long userspace_addr;
>  	u32 flags;
>  	short id;
> +	u8 as_id;

My vote is to store this as a u16 and remove the BUILD_BUG_ON.  Using a u8
doesn't save any memory since the compiler will pad out the struct.

>  };
>  
>  static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70f03ce0e5c1..e6484dabfc59 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1036,6 +1036,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  
>  	new = old = *slot;
>  
> +	BUILD_BUG_ON(U8_MAX < KVM_ADDRESS_SPACE_NUM);
> +	new.as_id = as_id;
>  	new.id = id;
>  	new.base_gfn = base_gfn;
>  	new.npages = npages;
> -- 
> 2.24.1
> 
