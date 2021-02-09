Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DAE314DBB
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 12:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhBIK77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:59:59 -0500
Received: from mga06.intel.com ([134.134.136.31]:33675 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhBIK5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 05:57:40 -0500
IronPort-SDR: C452LsrHA2GGMh/naHlHSJ67SjONlud0rJZwU4wz1ECR6kCzEdK3zwUvGdKGsYr1pjgoVON08O
 MyXlBcpPQy9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="243356845"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="243356845"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 02:55:50 -0800
IronPort-SDR: 8JAL2x2H0J4WHV4St6Mu6Mj45fGB7cL871ydig3rzAXc68ooxSlv54MhyATXzM9ybX/RSJeYVa
 k3XQoEVGVlfQ==
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="396072221"
Received: from liujiaq1-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.174.87])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 02:55:47 -0800
Date:   Tue, 9 Feb 2021 18:55:43 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: Re: [PATCH v3] KVM: x86/MMU: Do not check unsync status for root SP.
Message-ID: <20210209105543.bgxd4qftfqz5k4pa@linux.intel.com>
References: <20210209170111.4770-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209170111.4770-1-yu.c.zhang@linux.intel.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry, forget the change log:

Changes in V3:
- fixed a bug in warnings inside mmu_sync_children().
- commit message changes based on Paolo's suggestion.
- added Co-developed-by: Sean Christopherson <seanjc@google.com>

Changes in V2:
- warnings added based on Sean's suggestion.


On Wed, Feb 10, 2021 at 01:01:11AM +0800, Yu Zhang wrote:
> In shadow page table, only leaf SPs may be marked as unsync;
> instead, for non-leaf SPs, we store the number of unsynced
> children in unsync_children. Therefore, in kvm_mmu_sync_root(),
> sp->unsync shall always be zero for the root SP and there is
> no need to check it. Remove the check, and add a warning
> inside mmu_sync_children() to assert that the flags are used
> properly.
> 
> While at it, move the warning from mmu_need_write_protect()
> to kvm_unsync_page().
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 86af58294272..5f482af125b4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1995,6 +1995,12 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
>  	LIST_HEAD(invalid_list);
>  	bool flush = false;
>  
> +	/*
> +	 * Only 4k SPTEs can directly be made unsync, the parent pages
> +	 * should never be unsyc'd.
> +	 */
> +	WARN_ON_ONCE(parent->unsync);
> +
>  	while (mmu_unsync_walk(parent, &pages)) {
>  		bool protected = false;
>  
> @@ -2502,6 +2508,8 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page);
>  
>  static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  {
> +	WARN_ON(sp->role.level != PG_LEVEL_4K);
> +
>  	trace_kvm_mmu_unsync_page(sp);
>  	++vcpu->kvm->stat.mmu_unsync;
>  	sp->unsync = 1;
> @@ -2524,7 +2532,6 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>  		if (sp->unsync)
>  			continue;
>  
> -		WARN_ON(sp->role.level != PG_LEVEL_4K);
>  		kvm_unsync_page(vcpu, sp);
>  	}
>  
> @@ -3406,8 +3413,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  		 * mmu_need_write_protect() describe what could go wrong if this
>  		 * requirement isn't satisfied.
>  		 */
> -		if (!smp_load_acquire(&sp->unsync) &&
> -		    !smp_load_acquire(&sp->unsync_children))
> +		if (!smp_load_acquire(&sp->unsync_children))
>  			return;
>  
>  		write_lock(&vcpu->kvm->mmu_lock);
> -- 
> 2.17.1
> 
