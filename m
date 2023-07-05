Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036CD747F0D
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 10:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjGEIH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 04:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjGEIH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 04:07:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598AB123;
        Wed,  5 Jul 2023 01:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688544475; x=1720080475;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cn1WBv4JrMsrgoasE/lasO/n0SnRwlADo/SoWnSzf8M=;
  b=H6nAxTJNgv7Mug2MwINb9R7fJ+dUEjWUth49iW5C0tbqncwQrpLMWCqc
   kpa0T6eDc+GGGurircEYjoCQGIOQITwifUSsb+ExHcgIWscSsF+7Bzw/G
   S+y1/mFEHNvQ7pYv63Zm/5AQeXeh8QuCh0TsmJ7V8B6tHb2GNpKk3srbw
   eLy+al/5TYiavWE+8KQgRcTSw5DcnizUmpz7JuNyaEcqV/QZIDa+LiGFz
   0lRCmO2ZGwn4IrcCfvKx3A5z0tJEuPWKUkeWy6hYZY3MPSNTmAOKIsJPE
   C7MdVRw03s1BiIw69w/nSmHgeOxuJjOQ6tuQEOGMUOeGA7EpaJ1S7dG9J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="343610815"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="343610815"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 01:07:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="669323671"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="669323671"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 01:07:50 -0700
Date:   Wed, 5 Jul 2023 16:07:56 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
Message-ID: <20230705080756.xv7fm3jxewipunvn@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-5-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-5-stevensd@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 04, 2023 at 04:50:49PM +0900, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..e44ab512c3a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> -	bool async;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = fault->gfn,
> +		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> +		.allow_write_mapping = true,
> +	};
>  
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> -	if (!async)
> -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> +	foll.flags |= FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))
> +		goto success;
> +
> +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> +		return RET_PF_CONTINUE;

IIUC, FOLL_NOWAIT is set only when we wanna an async fault. So
KVM_PFN_ERR_NEEDS_IO may not be necessary? 

B.R.
Yu
