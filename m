Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A167481E1
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjGEKR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjGEKR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:17:56 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDD4E3;
        Wed,  5 Jul 2023 03:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688552275; x=1720088275;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oLxACQJJ5+O8I5OycraL/46XHwuWjbLPz8/XoWWOHjg=;
  b=Mnn+HoPz0qna1i0f7IRCiprB16wNIfrQ9e5Z4ahaBsAYwDdtolu1ZHld
   wL8pm4hFu/OZd7y5XzYyRONPQ+ZkPrLQ+mJ8TNDsmoTccZOk3EumnY5lM
   Z7Q2SUa6FVHK9rzy8qwbV/1KhzFCTrLaGFwIR/HxjI+A1u/I6X+A2ehJN
   OjgaKbRGgVcWux9BPz1Lc8R8bTlrIxeUD03E1z4EybMRJaXWgL7kgdwV8
   VxUG/Ii6gIfiMFoQKF8Qt8eCtXdjss77/RJyYgwmHDRzy0sRrnvHaWhqW
   zP3eGdaF6E5EeEHJB6MvaEXr+P8jSWiWsicWh98eWG9zQDhhdWy8iNVh0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="365873180"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="365873180"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 03:17:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="965775138"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="965775138"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 03:17:51 -0700
Date:   Wed, 5 Jul 2023 18:18:00 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-6-stevensd@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to map
> memory into the guest that is backed by un-refcounted struct pages - for
> example, higher order non-compound pages allocated by the amdgpu driver
> via ttm_pool_alloc_page.

I guess you mean the tail pages of the higher order non-compound pages?
And as to the head page, it is said to be set to one coincidentally[*],
and shall not be considered as refcounted.  IIUC, refcount of this head
page will be increased and decreased soon in hva_to_pfn_remapped(), so
this may not be a problem(?). But treating this head page differently,
as a refcounted one(e.g., to set the A/D flags), is weired. 

Or maybe I missed some context, e.g., can the head page be allocted to
guest at all? 


> 
> The bulk of this change is tracking the is_refcounted_page flag so that
> non-refcounted pages don't trigger page_count() == 0 warnings. This is
> done by storing the flag in an unused bit in the sptes.

Also, maybe we should mention this only works on x86-64. 

> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++++++++++++------------
>  arch/x86/kvm/mmu/mmu_internal.h |  1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  |  9 ++++---
>  arch/x86/kvm/mmu/spte.c         |  4 ++-
>  arch/x86/kvm/mmu/spte.h         | 12 ++++++++-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++++-------
>  6 files changed, 62 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e44ab512c3a1..b1607e314497 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c

...

> @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  	bool host_writable = !fault || fault->map_writable;
>  	bool prefetch = !fault || fault->prefetch;
>  	bool write_fault = fault && fault->write;
> +	bool is_refcounted = !fault || fault->is_refcounted_page;

Just wonder, what if a non-refcounted page is prefetched?  Or is it possible in
practice?

...
>  
> @@ -883,7 +884,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   */
>  static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
>  {
> -	bool host_writable;
> +	bool host_writable, is_refcounted;
>  	gpa_t first_pte_gpa;
>  	u64 *sptep, spte;
>  	struct kvm_memory_slot *slot;
> @@ -940,10 +941,12 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
>  	sptep = &sp->spt[i];
>  	spte = *sptep;
>  	host_writable = spte & shadow_host_writable_mask;
> +	// TODO: is this correct?
> +	is_refcounted = spte & SPTE_MMU_PAGE_REFCOUNTED;
>  	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  	make_spte(vcpu, sp, slot, pte_access, gfn,
>  		  spte_to_pfn(spte), spte, true, false,
> -		  host_writable, &spte);
> +		  host_writable, is_refcounted, &spte);

Could we restrict that a non-refcounted page shall not be used as shadow page?

[*] https://lore.kernel.org/all/8caf3008-dcf3-985a-631e-e019b277c6f0@amd.com/

B.R.
Yu
