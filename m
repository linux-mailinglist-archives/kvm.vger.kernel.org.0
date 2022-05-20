Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A0252E972
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 11:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348003AbiETJyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 05:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347989AbiETJye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 05:54:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A1214CA1A;
        Fri, 20 May 2022 02:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653040472; x=1684576472;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e57KscECE+4podIf9mIVnQB3nlnxc3JwwKJkTZj1mHc=;
  b=EcgcnywtfIWQu7/ht1OIxQgWwIbIe2hSNx+yuzexvNaUuRsqOm/Ox3Hm
   YOCk7omaXQD5b3Yxqf9pXIVaoGZWS7393Cnk/Qs1C//vjtGozLt64/Jvj
   K6A8+DL6Kg2EnWz/pjMSd6cmd6az/SyGiMPAJyloCwAHlNGD6X5FMdNIR
   Uf4VfKa3fzI6aO17bQlJla8tNeM/XVm44mn9HB/7t5ZmGEFVMphXmHhMq
   tYUsQOokhM2gtSVzbybHsyr0krHpz49vZaWSuOCCW+/bDhVvF3HxsoWNC
   TnlzvXrmftPRB0Oyo7LOuql64yoo+GOewFGQ2Osl58nJoDs78PuRKt6IH
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271376521"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271376521"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 02:54:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="557378558"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 20 May 2022 02:54:29 -0700
Date:   Fri, 20 May 2022 17:54:28 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yun Lu <luyun_611@163.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: optimizing the code in
 mmu_try_to_unsync_pages
Message-ID: <20220520095428.bahy37jxkznqtwx5@yy-desk-7060>
References: <20220520060907.863136-1-luyun_611@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520060907.863136-1-luyun_611@163.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 02:09:07PM +0800, Yun Lu wrote:
> There is no need to check can_unsync and prefetch in the loop
> every time, just move this check before the loop.
>
> Signed-off-by: Yun Lu <luyun@kylinos.cn>
> ---
>  arch/x86/kvm/mmu/mmu.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 311e4e1d7870..e51e7735adca 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2534,6 +2534,12 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>  	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
>  		return -EPERM;
>
> +	if (!can_unsync)
> +		return -EPERM;
> +
> +	if (prefetch)
> +		return -EEXIST;
> +
>  	/*
>  	 * The page is not write-tracked, mark existing shadow pages unsync
>  	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
> @@ -2541,15 +2547,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>  	 * allowing shadow pages to become unsync (writable by the guest).
>  	 */
>  	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> -		if (!can_unsync)
> -			return -EPERM;
> -
>  		if (sp->unsync)
>  			continue;
>
> -		if (prefetch)
> -			return -EEXIST;
> -

Consider the case that for_each_gfn_indirect_valid_sp() loop is
not triggered, means the gfn is not MMU page table page:

The old behavior when : return 0;
The new behavior with this change: returrn -EPERM / -EEXIST;

It at least breaks FNAME(sync_page) -> make_spte(prefetch = true, can_unsync = false)
which removes PT_WRITABLE_MASK from last level mapping unexpectedly.


>  		/*
>  		 * TDP MMU page faults require an additional spinlock as they
>  		 * run with mmu_lock held for read, not write, and the unsync
> --
> 2.25.1
>
>
> No virus found
> 		Checked by Hillstone Network AntiVirus
>
