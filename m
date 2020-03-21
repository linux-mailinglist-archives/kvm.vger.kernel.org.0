Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA96C18E3DA
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 20:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgCUTMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 15:12:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:4567 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgCUTMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 15:12:51 -0400
IronPort-SDR: BF5uw76TWSpmJxU09thk8Rga+09mJZDkusnxTEn3SaqeAcxZxSGDysE4Je6pOjXMgHW2+z6esi
 NLND2S5j8ACA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 12:12:50 -0700
IronPort-SDR: LEGngsaaDdt6kb5w+R52hg45Dzy0hFhk3Ck92J3u+FrpKnfuQtr4UDreSOVg9rQ4FlkgxuE9Gt
 SLzGcxHyB8IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="419063818"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 21 Mar 2020 12:12:50 -0700
Date:   Sat, 21 Mar 2020 12:12:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 06/14] KVM: Make dirty ring exclusive to dirty bitmap
 log
Message-ID: <20200321191250.GB13851@linux.intel.com>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-7-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318163720.93929-7-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 12:37:12PM -0400, Peter Xu wrote:
> There's no good reason to use both the dirty bitmap logging and the
> new dirty ring buffer to track dirty bits.  We should be able to even
> support both of them at the same time, but it could complicate things
> which could actually help little.  Let's simply make it the rule
> before we enable dirty ring on any arch, that we don't allow these two
> interfaces to be used together.
> 
> The big world switch would be KVM_CAP_DIRTY_LOG_RING capability
> enablement.  That's where we'll switch from the default dirty logging
> way to the dirty ring way.  As long as kvm->dirty_ring_size is setup
> correctly, we'll once and for all switch to the dirty ring buffer mode
> for the current virtual machine.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst |  7 +++++++
>  virt/kvm/kvm_main.c            | 12 ++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 99ee9cfc20c4..8f3a83298d3f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6202,3 +6202,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
>  
>  The dirty ring can gets full.  When it happens, the KVM_RUN of the
>  vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
> +
> +NOTE: the KVM_CAP_DIRTY_LOG_RING capability and the new ioctl

Leave off "new", it'll be stale a few months/years from now.

> +KVM_RESET_DIRTY_RINGS are exclusive to the existing KVM_GET_DIRTY_LOG

Did you mean "mutually exclusive with"?  "exclusive to" would mean they
can only be used by KVM_GET_DIRTY_LOG with doesn't match the next
sentence.

> +interface.  After enabling KVM_CAP_DIRTY_LOG_RING with an acceptable
> +dirty ring size, the virtual machine will switch to the dirty ring
> +tracking mode, and KVM_GET_DIRTY_LOG, KVM_CLEAR_DIRTY_LOG ioctls will
> +stop working.
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 54a1e893d17b..b289d3bddd5c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1352,6 +1352,10 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>  	unsigned long n;
>  	unsigned long any = 0;
>  
> +	/* Dirty ring tracking is exclusive to dirty log tracking */
> +	if (kvm->dirty_ring_size)
> +		return -EINVAL;
> +
>  	*memslot = NULL;
>  	*is_dirty = 0;
>  
> @@ -1413,6 +1417,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>  	unsigned long *dirty_bitmap_buffer;
>  	bool flush;
>  
> +	/* Dirty ring tracking is exclusive to dirty log tracking */
> +	if (kvm->dirty_ring_size)
> +		return -EINVAL;
> +
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
>  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> @@ -1521,6 +1529,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	unsigned long *dirty_bitmap_buffer;
>  	bool flush;
>  
> +	/* Dirty ring tracking is exclusive to dirty log tracking */
> +	if (kvm->dirty_ring_size)
> +		return -EINVAL;
> +
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
>  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> -- 
> 2.24.1
> 
