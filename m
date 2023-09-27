Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDAD7AFA95
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 08:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjI0GDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 02:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjI0GCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 02:02:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC7A10F7;
        Tue, 26 Sep 2023 23:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695794531; x=1727330531;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=43EZ2ak+dWd0Ucwj/uSlickdL5vUgMcvJYeX+1FPrpM=;
  b=luDR8bH2iyplUggPg9PwZIPqBRhITU9q9A9aP219mll4fAYRq5/MY8vN
   DaxkcFHl0Z1ITi+J1qn/TVHplRu14X3at76ydWHhvdDFeNouS/iF/A7K0
   9V6Qge/rlnBYAtO6kDW+D5SCeQtr88xRfkrBlIk4VPOvxv15Iga5HGQIf
   wjWUA5E3TVAnDRQHqHndblC4m2GRnTsFdwaOOOI1uCAWhoAn/TaLvpawc
   DrEWHr/GRh897g+gSF2P+HTs1V0cin3NlGEzAADEIstsNXtcQR56bDUn2
   aQ377eMcXxEWET9g+xBo0vZnJO5c47HuGEKbsgc+DQ86xPsApAetpaVBM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="468025992"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="468025992"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 23:02:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="742594936"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="742594936"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.84]) ([10.238.8.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 23:02:01 -0700
Message-ID: <303a3382-32e7-6afd-bdfa-1cefdbdfb41e@linux.intel.com>
Date:   Wed, 27 Sep 2023 14:01:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 07/13] KVM: x86/mmu: Track PRIVATE impact on hugepage
 mappings for all memslots
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>
References: <20230921203331.3746712-1-seanjc@google.com>
 <20230921203331.3746712-8-seanjc@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230921203331.3746712-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/22/2023 4:33 AM, Sean Christopherson wrote:
> Track the effects of private attributes on potential hugepage mappings if
> the VM supports private memory, i.e. even if the target memslot can only
> ever be mapped shared.  If userspace configures a chunk of memory as
> private, KVM must not allow that memory to be mapped shared regardless of
> whether or not the *current* memslot can be mapped private.  E.g. if the
> guest accesses a private range using a shared memslot, then KVM must exit
> to userspace.
How does usersapce handle this case?
IIRC, in gmem v12 patch set, it says a memslot can not be convert to 
private from shared.
So, userspace should delete the old memslot and and a new one?


> Fixes: 5bb0b4e162d1 ("KVM: x86: Disallow hugepages when memory attributes are mixed")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 269d4dc47c98..148931cf9dba 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7314,10 +7314,12 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>   	lockdep_assert_held(&kvm->slots_lock);
>   
>   	/*
> -	 * KVM x86 currently only supports KVM_MEMORY_ATTRIBUTE_PRIVATE, skip
> -	 * the slot if the slot will never consume the PRIVATE attribute.
> +	 * Calculate which ranges can be mapped with hugepages even if the slot
> +	 * can't map memory PRIVATE.  KVM mustn't create a SHARED hugepage over
> +	 * a range that has PRIVATE GFNs, and conversely converting a range to
> +	 * SHARED may now allow hugepages.
>   	 */
> -	if (!kvm_slot_can_be_private(slot))
> +	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
>   		return false;
>   
>   	/*
> @@ -7372,7 +7374,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
>   {
>   	int level;
>   
> -	if (!kvm_slot_can_be_private(slot))
> +	if (!kvm_arch_has_private_mem(kvm))
>   		return;
>   
>   	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {

