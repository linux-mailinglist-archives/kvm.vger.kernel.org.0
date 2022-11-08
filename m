Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD94A6212B3
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 14:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiKHNmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 08:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbiKHNlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 08:41:50 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B621D51C38;
        Tue,  8 Nov 2022 05:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667914909; x=1699450909;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=FmRgVS4cTjgYRBdIR1Sl5CCtDj0f4AUy7bzdc1murYw=;
  b=NZUJPMEMU0skIf1/6SkrAr9OYPhY+PZblPx6Mxqwt1c2BBC4j/oIXuGw
   w+xRjB0eLpbE1KoK28549yF8P7xUSqfQQmHwtL+U2+a/Y/2uKiVxLAe2+
   1adGBI7/Ld2TkaVcikvDEWKQCKozAzrOy0POOkHi1Bh4NM98WosJ9DHDk
   s65aDuh57oeTYitOWFq8QGYx2Mcqb7M9BfFmu/vJskVHUj68e3Ap9+YPg
   dha1EJt3L10lcxgPUj9ldrHUAA9Itl/aBh9q6l00LFeUoA0pjaDTs/TkD
   SrOFjMSbnfKoLBeez4LK8IV3u+lHlfb/4PxKKzyFFKibenXRv8qL6kQK/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="310692476"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="310692476"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 05:41:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811243110"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="811243110"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.143]) ([10.255.28.143])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 05:41:46 -0800
Message-ID: <30be6d64-31bd-bfc8-72f7-fb57999e4566@linux.intel.com>
Date:   Tue, 8 Nov 2022 21:41:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
From:   Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v10 049/108] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata<isaku.yamahata@intel.com>
>
> Allocate protected page table for private page table, and add hooks to
> operate on protected page table.  This patch adds allocation/free of
> protected page tables and hooks.  When calling hooks to update SPTE entry,
> freeze the entry, call hooks and unfree

unfreeze


>   the entry to allow concurrent
> updates on page tables.  Which is the advantage of TDP MMU.  As
> kvm_gfn_shared_mask() returns false always, those hooks aren't called yet
> with this patch.
>
> When the faulting GPA is private, the KVM fault is called private.  When
> resolving private KVM,

private KVM fault？


> allocate protected page table and call hooks to
> operate on protected page table. On the change of the private PTE entry,
> invoke kvm_x86_ops hook in __handle_changed_spte() to propagate the change
> to protected page table. The following depicts the relationship.
>
>    private KVM page fault   |
>        |                    |
>        V                    |
>   private GPA               |     CPU protected EPTP
>        |                    |           |
>        V                    |           V
>   private PT root           |     protected PT root
>        |                    |           |
>        V                    |           V
>     private PT --hook to propagate-->protected PT
>        |                    |           |
>        \--------------------+------\    |
>                             |      |    |
>                             |      V    V
>                             |    private guest page
>                             |
>                             |
>       non-encrypted memory  |    encrypted memory
>                             |
> PT: page table
>
> The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
> the EPT entry, atomically set the entry.  However, it requires TLB
> shootdown to zap SPTE.  To address it, the entry is frozen with the special
> SPTE value that clears the present bit. After the TLB shootdown, the entry
> is set to the eventual value (unfreeze).
>
> For protected page table, hooks are called to update protected page table
> in addition to direct access to the private SPTE. For the zapping case, it
> works to freeze the SPTE. It can call hooks in addition to TLB shootdown.
> For populating the private SPTE entry, there can be a race condition
> without further protection
>
>    vcpu 1: populating 2M private SPTE
>    vcpu 2: populating 4K private SPTE
>    vcpu 2: TDX SEAMCALL to update 4K protected SPTE => error
>    vcpu 1: TDX SEAMCALL to update 2M protected SPTE
>
> To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
> of the private entry, freeze the entry, call the hook that update protected
> SPTE, set the entry to the final value.
>
> Support 4K page only at this stage.  2M page support can be done in future
> patches.
>
> Co-developed-by: Kai Huang<kai.huang@intel.com>
> Signed-off-by: Kai Huang<kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |   5 +
>   arch/x86/include/asm/kvm_host.h    |  11 ++
>   arch/x86/kvm/mmu/mmu.c             |  15 +-
>   arch/x86/kvm/mmu/mmu_internal.h    |  32 ++++
>   arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c         | 244 +++++++++++++++++++++++++----
>   arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
>   virt/kvm/kvm_main.c                |   1 +
>   8 files changed, 280 insertions(+), 32 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index f28c9fd72ac4..1b01dc2098b0 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -94,6 +94,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
> +KVM_X86_OP_OPTIONAL(link_private_spt)
> +KVM_X86_OP_OPTIONAL(free_private_spt)
> +KVM_X86_OP_OPTIONAL(set_private_spte)
> +KVM_X86_OP_OPTIONAL(remove_private_spte)
> +KVM_X86_OP_OPTIONAL(zap_private_spte)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
>   KVM_X86_OP(get_l2_tsc_multiplier)
>
> @@ -509,9 +524,81 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   		WARN_ON_ONCE(ret);
>   	}
>   
> +	if (is_private_sp(sp) &&
> +	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,
> +							  kvm_mmu_private_spt(sp)))) {
> +		/*
> +		 * Failed to unlink Secure EPT page and there is nothing to do
> +		 * further.  Intentionally leak the page to prevent the kernel
> +		 * from accessing the encrypted page.
> +		 */
> +		kvm_mmu_init_private_spt(sp, NULL);

Do you think is it better to add some statistics for the intentinal 
leakage?


> +	}
> +
>   	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>   }
>   
> pu, until a matching vcpu_put()
