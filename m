Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E55303F33
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405287AbhAZNrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:47:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:7861 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405244AbhAZNrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:47:24 -0500
IronPort-SDR: p9W/ZFS9zMtBBroU7k4wgd5u3b8RADYlSvDJBo98YTg3lcwDAG5mFs/yRKiAkJ92xxaIbc2LtG
 3ZJcRCyWwduQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="167000998"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="167000998"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 05:45:38 -0800
IronPort-SDR: UC2V7B//+ecyvrs0PY7ylxbVBW9iLV8zAt9QDO7mFxVVVu+XeGwYluE2DT8SOF+J2rQe0ughHi
 8qrtw7HOVSjQ==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="387831564"
Received: from haotongw-mobl2.ccr.corp.intel.com (HELO localhost) ([10.255.28.153])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 05:45:35 -0800
Date:   Tue, 26 Jan 2021 21:45:31 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: x86/MMU: Do not check unsync status for root SP.
Message-ID: <20210126134531.ctj326k3xwvmniwd@linux.intel.com>
References: <20210116002100.17339-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116002100.17339-1-yu.c.zhang@linux.intel.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

  Any comments? Thanks!

B.R.
Yu

On Sat, Jan 16, 2021 at 08:21:00AM +0800, Yu Zhang wrote:
> In shadow page table, only leaf SPs may be marked as unsync.
> And for non-leaf SPs, we use unsync_children to keep the number
> of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
> shall always be zero for the root SP, hence no need to check it.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481a..1a6bb03 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3412,8 +3412,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  		 * mmu_need_write_protect() describe what could go wrong if this
>  		 * requirement isn't satisfied.
>  		 */
> -		if (!smp_load_acquire(&sp->unsync) &&
> -		    !smp_load_acquire(&sp->unsync_children))
> +		if (!smp_load_acquire(&sp->unsync_children))
>  			return;
>  
>  		spin_lock(&vcpu->kvm->mmu_lock);
> -- 
> 1.9.1
> 
