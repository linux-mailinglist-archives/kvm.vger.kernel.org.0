Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA77722869
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbjFEOK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbjFEOJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:09:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26C410C9;
        Mon,  5 Jun 2023 07:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685974136; x=1717510136;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Aj5xU0E8HM6ruKdnFvz1ex49rnTP0xoMbsNDzlocswU=;
  b=kQ4YzbklciIK5QCQvmmhSu2BzXjBZ6bgKxNBZAdKQSEBii6qgbUrAyrP
   MOpHecXysrObkz4Li2ZZ9KuGK0eKkLCfkCIFooyLjTOsoG4ioIy+L/jtI
   0bwAgfbq5yyks+cBJFIuxBcz+qlXEnS0cd1A3bBuIsNobFWZXjPgwRbc6
   xPaFbhyLxTEBS+EyRW2Eags1YA4L9+7cijlCsMfytjXhwF+9AgML+CHM1
   NfXdHQfBeAIoLDpr5HCYvvM4HDP0mfRty9ETNaJQQJ6wjFzCUZwgDypmc
   FoY5tCzUOulbyJ/1XpK8jkzf4iKeLjSCKUpcVJsQW464WX9kFkWrOkNf2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="345968045"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="345968045"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:07:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="708662638"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="708662638"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2023 07:07:26 -0700
Date:   Mon, 5 Jun 2023 22:07:25 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Message-ID: <20230605140725.32ogo6gbhqyl4kfl@yy-desk-7060>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-4-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601142309.6307-4-guang.zeng@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 10:23:06PM +0800, Zeng Guang wrote:
> Intel introduces LASS (Linear Address Separation) feature providing
> an independent mechanism to achieve the mode-based protection.
>
> LASS partitions 64-bit linear address space into two halves, user-mode
> address (LA[bit 63]=0) and supervisor-mode address (LA[bit 63]=1). It
> stops any code execution or conditional data access[1]
>     1. from user mode to supervisor-mode address space
>     2. from supervisor mode to user-mode address space
> and generates LASS violation fault accordingly.
>
> [1]A supervisor mode data access causes a LASS violation only if supervisor
> mode access protection is enabled (CR4.SMAP = 1) and either RFLAGS.AC = 0
> or the access implicitly accesses a system data structure.
>
> Following are the rules of LASS violation check on the linear address(LA).
> User access to supervisor-mode address space:
>     LA[bit 63] && (CPL == 3)
> Supervisor access to user-mode address space:
>     Instruction fetch: !LA[bit 63] && (CPL < 3)
>     Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>                  CPL < 3) || Implicit supervisor access)
>
> Add new ops in kvm_x86_ops to do LASS violation check.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  3 +-
>  arch/x86/include/asm/kvm_host.h    |  2 ++
>  arch/x86/kvm/kvm_emulate.h         |  1 +
>  arch/x86/kvm/vmx/vmx.c             | 47 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h             |  2 ++
>  5 files changed, 54 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 13bc212cd4bc..8980a3bfa687 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -132,7 +132,8 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
>  KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
> -KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
> +KVM_X86_OP_OPTIONAL_RET0(check_lass)
>
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 92d8e65fe88c..98666d1e7727 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
>  	 * Returns vCPU specific APICv inhibit reasons
>  	 */
>  	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
> +
> +	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 5b9ec610b2cb..f1439ab7c14b 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -91,6 +91,7 @@ struct x86_instruction_info {
>  /* x86-specific emulation flags */
>  #define X86EMUL_F_FETCH			BIT(0)
>  #define X86EMUL_F_WRITE			BIT(1)
> +#define X86EMUL_F_SKIPLASS		BIT(2)
>
>  struct x86_emulate_ops {
>  	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a33205ded85c..876997e8448e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8130,6 +8130,51 @@ static void vmx_vm_destroy(struct kvm *kvm)
>  	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>  }
>
> +/*
> + * Determine whether an access to the linear address causes a LASS violation.
> + * LASS protection is only effective in long mode. As a prerequisite, caller
> + * should make sure vCPU running in long mode and invoke this api to do LASS
> + * violation check.
> + */
> +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags)
> +{
> +	bool user_mode, user_as, rflags_ac;
> +
> +	if (!!(flags & X86EMUL_F_SKIPLASS) ||
> +	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
> +		return false;
> +
> +	WARN_ON_ONCE(!is_long_mode(vcpu));
> +
> +	user_as = !(la >> 63);
> +
> +	/*
> +	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
> +	 * accesses a system data structure. For implicit accesses to system
> +	 * data structure, the processor acts as if RFLAGS.AC is clear.
> +	 */
> +	if (access & PFERR_IMPLICIT_ACCESS) {
> +		user_mode = false;
> +		rflags_ac = false;
> +	} else {
> +		user_mode = vmx_get_cpl(vcpu) == 3;
> +		if (!user_mode)
> +			rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
> +	}
> +
> +	if (user_mode == user_as)

Confused by user_as, it's role of address(U/S) so how about
"user_addr" ? "if (user_mode == user_addr)" looks more clear
to me.

> +		return false;
> +
> +	/*
> +	 * Supervisor-mode _data_ accesses to user address space
> +	 * cause LASS violations only if SMAP is enabled.
> +	 */
> +	if (!user_mode && !(access & PFERR_FETCH_MASK))
> +		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;
> +
> +	return true;
> +}
> +
>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>
> @@ -8269,6 +8314,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.complete_emulated_msr = kvm_complete_insn_gp,
>
>  	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +
> +	.check_lass = vmx_check_lass,
>  };
>
>  static unsigned int vmx_handle_intel_pt_intr(void)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9e66531861cf..f2e775b9849b 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>  u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>  u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>
> +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);
> +
>  static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>  					     int type, bool value)
>  {
> --
> 2.27.0
>
