Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033D464C886
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 12:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbiLNL7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 06:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238349AbiLNL6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 06:58:43 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE8621E19;
        Wed, 14 Dec 2022 03:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671019111; x=1702555111;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V3fSrvP/L4OEGks3zDsYhRCRgh9WISDlG9d3Y5NZZkY=;
  b=hA4+R7FzrFHSnQjrZyYgsjLtiMC3+IvbRkejFTJ7HMscizmwXtNKB7/0
   N4rBiJcT2N6V81zaRoSUN5sFshe6AyITeKI3Gc6idSzZDc2eW/8DUoTnH
   1UCaZgqOzmJ1NvVAd9ZulN1ERl+pVEIuXE3PYR9uBcnNGBZ22BOkvjcuy
   yL/K8TNPEAu9XoLvQuoy0p33TMCYJuoi4noEiVZx4uauQ+MXX7833mJR0
   scRblUG8brqja5zjKncmLOW4YBNLyvZPjjcc+B86AonGoExBUesKgaRqK
   pv5oSAOomJAW1reKNvzZpF7V/Hr1n8Lc4rDyi7wzhNbhmsyQAzLkzIvW4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="317085382"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="317085382"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 03:58:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="679665139"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="679665139"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 14 Dec 2022 03:58:26 -0800
Message-ID: <247fcfc6de8ec08d0667de125e707046dce903fc.camel@linux.intel.com>
Subject: Re: [PATCH 3/5] KVM: x86/mmu: Re-check under lock that TDP MMU SP
 hugepage is disallowed
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Date:   Wed, 14 Dec 2022 19:58:25 +0800
In-Reply-To: <20221213033030.83345-4-seanjc@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
         <20221213033030.83345-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-13 at 03:30 +0000, Sean Christopherson wrote:
> Re-check sp->nx_huge_page_disallowed under the tdp_mmu_pages_lock
> spinlock
> when adding a new shadow page in the TDP MMU.  To ensure the NX
> reclaim
> kthread can't see a not-yet-linked shadow page, the page fault path
> links
> the new page table prior to adding the page to
> possible_nx_huge_pages.
> 
> If the page is zapped by different task, e.g. because dirty logging
> is
> disabled, between linking the page and adding it to the list, KVM can
> end
> up triggering use-after-free by adding the zapped SP to the
> aforementioned
> list, as the zapped SP's memory is scheduled for removal via RCU
> callback.
> The bug is detected by the sanity checks guarded by
> CONFIG_DEBUG_LIST=y,
> i.e. the below splat is just one possible signature.
> 
>   ------------[ cut here ]------------
>   list_add corruption. prev->next should be next (ffffc9000071fa70),
> but was ffff88811125ee38. (prev=ffff88811125ee38).
>   WARNING: CPU: 1 PID: 953 at lib/list_debug.c:30
> __list_add_valid+0x79/0xa0
>   Modules linked in: kvm_intel
>   CPU: 1 PID: 953 Comm: nx_huge_pages_t Tainted:
> G        W          6.1.0-rc4+ #71
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0
> 02/06/2015
>   RIP: 0010:__list_add_valid+0x79/0xa0
>   RSP: 0018:ffffc900006efb68 EFLAGS: 00010286
>   RAX: 0000000000000000 RBX: ffff888116cae8a0 RCX: 0000000000000027
>   RDX: 0000000000000027 RSI: 0000000100001872 RDI: ffff888277c5b4c8
>   RBP: ffffc90000717000 R08: ffff888277c5b4c0 R09: ffffc900006efa08
>   R10: 0000000000199998 R11: 0000000000199a20 R12: ffff888116cae930
>   R13: ffff88811125ee38 R14: ffffc9000071fa70 R15: ffff88810b794f90
>   FS:  00007fc0415d2740(0000) GS:ffff888277c40000(0000)
> knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000000 CR3: 0000000115201006 CR4: 0000000000172ea0
>   Call Trace:
>    <TASK>
>    track_possible_nx_huge_page+0x53/0x80
>    kvm_tdp_mmu_map+0x242/0x2c0
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
> Fixes: 61f94478547b ("KVM: x86/mmu: Set disallowed_nx_huge_page in
> TDP MMU before setting SPTE")
> Reported-by: Greg Thelen <gthelen@google.com>
> Analyzed-by: David Matlack <dmatlack@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e2e197d41780..fd4ae99790d7 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1203,7 +1203,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> struct kvm_page_fault *fault)
>  		if (fault->huge_page_disallowed &&
>  		    fault->req_level >= iter.level) {
>  			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -			track_possible_nx_huge_page(kvm, sp);
> +			if (sp->nx_huge_page_disallowed)
> +				track_possible_nx_huge_page(kvm, sp);
>  			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  		}
>  	}

Is this possible?
The aforementioned situation happened, i.e. before above hunk
track_possible_nx_huge_page(), the sp is zapped by some other task,
tdp_mmu_unlink_sp() --> untrack_possible_nx_huge_page(kvm, sp):

--kvm->stat.nx_lpage_splits;

But looks like the stat for this sp hasn't been increased yet.

