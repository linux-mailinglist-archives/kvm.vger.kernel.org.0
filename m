Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E1F7AF8F9
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjI0EDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjI0ECg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:02:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C259CD;
        Tue, 26 Sep 2023 20:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695784586; x=1727320586;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xUJdeRQT19cYRNhrNkhJa/Ogmuttz6tri9miEiYvpMA=;
  b=RFpuyRn1LbkUPsLCqAIjEAGRZuxK1FEsHkfNXiCYZ2FdewRgrSPzgTAs
   gdVD0oCUvQYNSP8ebImLj44rNSvBjAD5mh+08O8LlPCG/HTY55nTulphZ
   xKl7bUqho87irYd2GUX953bAwbOYQuz8J2yfoDZAN4XAhNN6jgYmrLqyM
   4rLFWl+zx5BLwM5Ew0yuyNTNsgrjr/uiTh4FuEFel6kLlH7gNmjVYdF45
   qrteUNQ/G9lZpzGaUbZxr+ZRblVRROq3TuvWyHSk5Zpk6flzwE0I2xl/8
   p+pP+qN6dQG5hJhStwbiTt+GXpRDmIxM+JMOA93NIksor2TIqVGIh0HyC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="412633116"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="412633116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="814698010"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="814698010"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.84]) ([10.238.8.84])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:16:23 -0700
Message-ID: <7be47fe7-9587-dd1b-fac1-5c4d5c6e2ff6@linux.intel.com>
Date:   Wed, 27 Sep 2023 11:16:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 04/13] KVM: WARN if there are danging MMU invalidations at
 VM destruction
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>
References: <20230921203331.3746712-1-seanjc@google.com>
 <20230921203331.3746712-5-seanjc@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230921203331.3746712-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/22/2023 4:33 AM, Sean Christopherson wrote:
> Add an assertion that there are no in-progress MMU invalidations when a
> VM is being destroyed, with the exception of the scenario where KVM
> unregisters its MMU notifier between an .invalidate_range_start() call and
> the corresponding .invalidate_range_end().
>
> KVM can't detect unpaired calls from the mmu_notifier due to the above
> exception waiver, but the assertion can detect KVM bugs, e.g. such as the
> bug that *almost* escaped initial guest_memfd development.
>
> Link: https://lore.kernel.org/all/e397d30c-c6af-e68f-d18e-b4e3739c5389@linux.intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 54480655bcce..277afeedd670 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1381,9 +1381,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
>   	 * No threads can be waiting in kvm_swap_active_memslots() as the
>   	 * last reference on KVM has been dropped, but freeing
>   	 * memslots would deadlock without this manual intervention.
> +	 *
> +	 * If the count isn't unbalanced, i.e. KVM did NOT unregister between
Nit: Readers can get it according to the code context, but is it better 
to add
"MMU notifier"  to tell what to "unregister" to make the comment easier to
understand?


> +	 * a start() and end(), then there shouldn't be any in-progress
> +	 * invalidations.
>   	 */
>   	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
> -	kvm->mn_active_invalidate_count = 0;
> +	if (kvm->mn_active_invalidate_count)
> +		kvm->mn_active_invalidate_count = 0;
> +	else
> +		WARN_ON(kvm->mmu_invalidate_in_progress);
>   #else
>   	kvm_flush_shadow_all(kvm);
>   #endif

