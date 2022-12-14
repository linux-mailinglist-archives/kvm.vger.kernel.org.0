Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F5A64C883
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 12:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbiLNL6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 06:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbiLNL6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 06:58:13 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2556A25E9A;
        Wed, 14 Dec 2022 03:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671019079; x=1702555079;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n4iyoPXWxUWz1yJqQU/LUbFr01rh+9Sqx5WZtOI15Ck=;
  b=U/UV0fQD1wu42mCKJwHnpZINiCYc0I26hSuXerQZzgc2z/oJtOYYyiUn
   Bff1tR3vi7u6781PSstp+qFrFfJG96rBO/uZiL01w3Xi6zcHSSmkBGxgG
   1qTFLeXEmKcUoux8HMagpnHoaZgz/OUwjaUWq1iYs8Al0etlU+wj+Qq4p
   +KnKMWQiPzrhp1PQJ6YrvdZ/VTkap83GB1ko9qERo6Lcbsy0Qj9AzHJP0
   G+5XOwwpjNoIMyf54dx6VEKQ2dNFYxmp7UB/6jR/29wZkpW9ZSHt4MmnN
   jmluStqBjYG3Oq85aQueKi9t2RCQVXS6Y4wf8PCmcWaEVoOfq+N8MRF8a
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="316018851"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="316018851"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 03:57:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="977806611"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="977806611"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 14 Dec 2022 03:57:56 -0800
Message-ID: <0595da5ddc9084d3fceb4a6efd4b9f407e2aaddb.camel@linux.intel.com>
Subject: Re: [PATCH 1/5] KVM: x86/mmu: Don't attempt to map leaf if target
 TDP MMU SPTE is frozen
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Date:   Wed, 14 Dec 2022 19:57:56 +0800
In-Reply-To: <20221213033030.83345-2-seanjc@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
         <20221213033030.83345-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-13 at 03:30 +0000, Sean Christopherson wrote:
> Hoist the is_removed_spte() check above the "level == goal_level"
> check
> when walking SPTEs during a TDP MMU page fault to avoid attempting to
> map
> a leaf entry if said entry is frozen by a different task/vCPU.
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 3 PID: 939 at arch/x86/kvm/mmu/tdp_mmu.c:653
> kvm_tdp_mmu_map+0x269/0x4b0
>   Modules linked in: kvm_intel
>   CPU: 3 PID: 939 Comm: nx_huge_pages_t Not tainted 6.1.0-rc4+ #67
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0
> 02/06/2015
>   RIP: 0010:kvm_tdp_mmu_map+0x269/0x4b0
>   RSP: 0018:ffffc9000068fba8 EFLAGS: 00010246
>   RAX: 00000000000005a0 RBX: ffffc9000068fcc0 RCX: 0000000000000005
>   RDX: ffff88810741f000 RSI: ffff888107f04600 RDI: ffffc900006a3000
>   RBP: 060000010b000bf3 R08: 0000000000000000 R09: 0000000000000000
>   R10: 0000000000000000 R11: 000ffffffffff000 R12: 0000000000000005
>   R13: ffff888113670000 R14: ffff888107464958 R15: 0000000000000000
>   FS:  00007f01c942c740(0000) GS:ffff888277cc0000(0000)
> knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000000 CR3: 0000000117013006 CR4: 0000000000172ea0
>   Call Trace:
>    <TASK>
>    kvm_tdp_page_fault+0x10c/0x130
>    kvm_mmu_page_fault+0x103/0x680
>    vmx_handle_exit+0x132/0x5a0 [kvm_intel]
>    vcpu_enter_guest+0x60c/0x16f0
>    kvm_arch_vcpu_ioctl_run+0x1e2/0x9d0
>    kvm_vcpu_ioctl+0x271/0x660
>    __x64_sys_ioctl+0x80/0xb0
>    do_syscall_64+0x2b/0x50
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> Fixes: 63d28a25e04c ("KVM: x86/mmu: simplify kvm_tdp_mmu_map flow
> when guest has to retry")
> Cc: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 764f7c87286f..b740f38fedcc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1162,9 +1162,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> struct kvm_page_fault *fault)
>  		if (fault->nx_huge_page_workaround_enabled)
>  			disallowed_hugepage_adjust(fault,
> iter.old_spte, iter.level);
>  
> -		if (iter.level == fault->goal_level)
> -			break;
> -
>  		/*
>  		 * If SPTE has been frozen by another thread, just give
> up and
>  		 * retry, avoiding unnecessary page table allocation
> and free.
> @@ -1172,6 +1169,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> struct kvm_page_fault *fault)
>  		if (is_removed_spte(iter.old_spte))
>  			goto retry;
>  
> +		if (iter.level == fault->goal_level)
> +			break;
> +
>  		/* Step down into the lower level page table if it
> exists. */
>  		if (is_shadow_present_pte(iter.old_spte) &&
>  		    !is_large_pte(iter.old_spte))

Reviewed-by: Robert Hoo <robert.hu@linux.intel.com>

