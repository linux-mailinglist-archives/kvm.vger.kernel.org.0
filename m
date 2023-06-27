Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8AC740330
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 20:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjF0S0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 14:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjF0S0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 14:26:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170DE107
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 11:26:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c0d62f4487cso5763655276.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 11:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687890365; x=1690482365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=81m5xWkNP+GjS/HPbi1v2wGzICrWPoT0YnSmr493DPo=;
        b=S5qhxSKQLWuqHJMFSZ3V2fGCaDXnXsv01q3Lzmy/uAjyq9HwRx48ZlUFgaUInREavH
         5f4Dy7d2Bxl5xqY4u+IXQ9dCHJsVUVB22LxZTBAUidCOuVkitiig1Xzi+krc7bqz5ng7
         sMAO4tJC4jlcRoNihM4U89dTGQ/UDZJxG1rkrEfTk3FhZWqJ8Io2q2ny6PxekGc/02ht
         GhjCjpGygblvO8BZCjn9/yQuhfT+qK1wQdEwwM1y4o/2wOJ58b4OlwSQBFNa1Kh39n9G
         Yi0AcpDfLv1f0Qcd7UELh4TdQGivz0ik9Mw4j2dHaO+UBIqPWIcwfXBxAinTvpJaJ0Mt
         vk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687890365; x=1690482365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81m5xWkNP+GjS/HPbi1v2wGzICrWPoT0YnSmr493DPo=;
        b=TIAGwRX5U3GKdYinxIKGB+nCsj5DPikfxxGq+EYH+QjtzynhXALu5zCbUxROapzPBT
         I313Pt8MsNmbQQncEBPsyTwUNO3FTj9j+Rjvi4Q98V4W9jjsiB4Ozw5TK8oPRNkOHLPZ
         2Y7Srm4hgumGxZ9yKIC9opjNGOyM0HqpjKYHpZqtt9IoJ2Xu+4Le48pZR99fD/EEL51a
         UQzz+rvC6NFs5T/NasC3QcHBi7CKFs3vVV3QX1RYLH4be9pTW7p68TUq/BMWLX+uCM/+
         6rEYs8YsMc4exEMiOQGJHgXsC8uu5Qgc2G+bwREKJmcrd/+MnA+XceoqJ/ZDAdAWYodX
         bHXg==
X-Gm-Message-State: AC+VfDwysRisI/X3fg2k+F0pNTG56QOsXzQ0WsrZJDd1KQdMALxQ1za1
        rRS2vlcoPMRHmw4OYSDhGypc8zOyE1I=
X-Google-Smtp-Source: ACHHUZ6enSW0eb2knSbUgE8LCETGfCR0YbBP1xlXox8wJIQwA7JaTkXrZ+5CQJjillg+07WBR5k6DgOGRCY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:addb:0:b0:be3:b9a6:a6b2 with SMTP id
 d27-20020a25addb000000b00be3b9a6a6b2mr7679867ybe.9.1687890365383; Tue, 27 Jun
 2023 11:26:05 -0700 (PDT)
Date:   Tue, 27 Jun 2023 11:26:03 -0700
In-Reply-To: <20230601142309.6307-4-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230601142309.6307-1-guang.zeng@intel.com> <20230601142309.6307-4-guang.zeng@intel.com>
Message-ID: <ZJspu3uS2mirF+4k@google.com>
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to comments on an earlier patch, don't try to describe the literal code
change, e.g. this does far more than just "Add new ops in kvm_x86_ops".  Something
like

  KVM: VMX: Add emulation of LASS violation checks on linear address 

On Thu, Jun 01, 2023, Zeng Guang wrote:
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

Use "is_lass_violation" instead of "check_lass" for all function names.  "check"
doesn't convey that the function is a predicate, i.e. that it returns true/false.

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

This belongs in the patch that integrates LASS into the emulator.  And rather than
make the flag a command (SKIPLASS), I think it makes sense to make the flag describe
the access.  It'll mean more flags, but those are free.  That way the originators of
the accesses, e.g. em_invlpg(), don't need to document how they interact with LASS,
e.g. this code is self-documenting, and if someone wants to understand why KVM
has a dedicated X86EMUL_F_INVLPG flag, it's easy enough to find the consumer.
And in the unlikely scenario that other things care about INVLPG, branch targets,
etc., we won't end up with X86EMUL_F_SKIPLASS, X86EMUL_F_SKIPOTHER, etc.

	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1,
			 X86EMUL_F_INVLPG, ctxt->mode, &linear);

So this?

  #define X86EMUL_F_IMPLICIT
  #define X86EMUL_F_INVLPG
  #define X86EMUL_F_BRANCH_TARGET

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

This is silly.  By making this a preqreq, 2 of the 3 callers are forced to explicitly
check for is_long_mode(), *and* it unnecessarily bleeds LASS details outside of VMX.

> +
> +	user_as = !(la >> 63);
> +
> +	/*
> +	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
> +	 * accesses a system data structure. For implicit accesses to system
> +	 * data structure, the processor acts as if RFLAGS.AC is clear.
> +	 */
> +	if (access & PFERR_IMPLICIT_ACCESS) {

Please don't use PFERR_IMPLICIT_ACCESS, just extend the new flags.  This is
obviously not coming from a page fault.  PFERR_IMPLICIT_ACCESS really shouldn't
exist, but at least there was reasonable justification for adding it (changing
all of the paths that lead to permission_fault() would have require a massive
overhaul).

***HOWEVER***

I think the entire approach of hooking __linearize() may be a mistake, and LASS
should instead be implemented in a wrapper of ->gva_to_gpa().  The two calls to
__linearize() that are escaped with SKIPLASS are escaped *because* they don't
actually access memory (branch targets and INVLPG), and so if LASS is enforced
only when ->gva_to_gpa() is invoked, all of these new flags go away because the
cases that ignore LASS are naturally handled.

That should also make it unnecessary to add one-off checks since e.g. kvm_handle_invpcid()
will hit kvm_read_guest_virt() and thus ->gva_to_gpa(), i.e. we won't end up playing
an ongoing game of whack-a-mole.

And one question that needs to be answered is what happens when an access rolls
over from supervisor to user, e.g. if the kernel access 8 bytes at -1ull and thus
reads all Fs => 0x6, does the access get a LASS violation on the access to user
memory.  User=>supervisor can't happen because non-canonical checks have higher
priority, but supervisor=>user can.  And that matters because it will impact
whether or not KVM needs to check each *page* or just the initial address.

> +		user_mode = false;
> +		rflags_ac = false;
> +	} else {
> +		user_mode = vmx_get_cpl(vcpu) == 3;
> +		if (!user_mode)
> +			rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
> +	}
> +
> +	if (user_mode == user_as)
> +		return false;
> +
> +	/*
> +	 * Supervisor-mode _data_ accesses to user address space
> +	 * cause LASS violations only if SMAP is enabled.
> +	 */
> +	if (!user_mode && !(access & PFERR_FETCH_MASK))
> +		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;

This is all more complex than it needs to be.  Using local bools just so that
the "user_mode == user_as" is common is not a good tradeoff.  User addresses have
*significantly* different behavior, lean into that instead of dancing around it.

bool is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
		       unsigned int flags)
{
	const bool is_supervisor_access = addr & BIT_ULL(63);
	const bool implicit = flags & X86EMUL_F_IMPLICIT;

	bool user_mode, user_as, rflags_ac;

	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
		return false;

	/*
	 * INVLPG isn't subject to LASS, e.g. to allow invalidating userspace
	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
	 * to LASS in order to simplifiy far control transfers (the subsequent
	 * fetch will enforce LASS as appropriate).
	 */
	if (flags & (X86EMUL_F_BRANCH_TARGET | X86EMUL_F_INVLPG))
		return false;

	if (!implicit && vmx_get_cpl(vcpu) == 3)
		return is_supervisor_address;

	/* LASS is enforced for supervisor access iff SMAP is enabled. */
	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
		return false;

	/* Like SMAP, RFLAGS.AC disables LASS checks in supervisor mode. */
	if (!implicit && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
		return false;

	return !is_supervisor_address;
}

> +	return true;
> +}
