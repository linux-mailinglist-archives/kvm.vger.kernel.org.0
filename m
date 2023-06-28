Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A46C74071C
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjF1AQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjF1AQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:16:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A42E8
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:16:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bfebb1beeccso6825096276.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687911360; x=1690503360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hq2OjJQ3roZBmaU/SKFrvrTdRBlrpYEUlQfg0bTRSIg=;
        b=FCjqxlnrToXwKNz71xIIXcFFuP6ok5Kod8pb9bG8HrDZoH7ziC4bwLe0sfxIAJ/fF7
         01oPOTHhSUKJCW9Gij06znDs8jy89aVXmpxY+8PFb1oJkwhDbbOLZzHVeDEA/4iNCSPL
         LWk+Wp3TX5zNrqusv6SwKw39cuMbmb6iRVv28a6+9v5IsaStZuFGCz95kRifAhsCufHT
         HBxayvK+hD7n5fIVT25GwuLIS9huU2lRQw9IlknMempjrO0K3FKvgRfoleKi0RdqaNLg
         g/QBv7XbxHPlweIcGA+RhVBbCXGz19xfnvYTJL82D+Nw7WjLZhdbs58olJQULX/nC8go
         OKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911360; x=1690503360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hq2OjJQ3roZBmaU/SKFrvrTdRBlrpYEUlQfg0bTRSIg=;
        b=bl6f+4VA2bCaKKef7LJrYHxgsGFUx1CgcAQp6eNLuHr9SDTtqzFicztEIe5iZP502r
         AGABiImQe77PQBqcO/1sZUu1Db4j1znEN3QZ42JX22rJGce3IfO6VerDjwLjxG4Bpasm
         9GaykDDy5bj6jdmKPci5HuPCYLLSqCZ0PoVJgJobAIH+CzuK+Hwuo4zYWLp++nsqSUU7
         LfC1Mss8JbwqcNLsNFbI/ltHI8q0jv3G3gzU+UfSLAfAL1hPW7nAytj2gTvQxqEoDEnn
         2V+0/IFsLd/jFqwEnaUKJzv6BTGexS1d2ZEumQF3Laj6yiWm7isqeeccl5IhKOpVgOaN
         Dk7A==
X-Gm-Message-State: AC+VfDz8vp7NU89OzPvWfbdh8MZJ+oyG5XHEGH/CXhhYzv4bntDeJSku
        972zTFVBFAqRYzWDDD37zntwdDMVyH8=
X-Google-Smtp-Source: ACHHUZ6F2dfaQvYypQunraaBhJxvuOduwx/qAHdaP6/+EFHxLdZe2qm3SDEt/Kz5x1M4rFDb1a6da0Fr5Oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:91:b0:ba8:6dc0:cacf with SMTP id
 h17-20020a056902009100b00ba86dc0cacfmr8146219ybs.12.1687911360799; Tue, 27
 Jun 2023 17:16:00 -0700 (PDT)
Date:   Tue, 27 Jun 2023 17:15:58 -0700
In-Reply-To: <20230606091842.13123-5-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230606091842.13123-1-binbin.wu@linux.intel.com> <20230606091842.13123-5-binbin.wu@linux.intel.com>
Message-ID: <ZJt7vud/2FJtcGjV@google.com>
Subject: Re: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023, Binbin Wu wrote:
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 5b9ec610b2cb..c2091e24a6b9 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -91,6 +91,7 @@ struct x86_instruction_info {
>  /* x86-specific emulation flags */
>  #define X86EMUL_F_FETCH			BIT(0)
>  #define X86EMUL_F_WRITE			BIT(1)
> +#define X86EMUL_F_SKIPLAM		BIT(2)

See my comments in the LASS series about describing the access, not dictating
the end behavior.

>  
>  struct x86_emulate_ops {
>  	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 52dcf3c00bb8..82a225d1000e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8133,6 +8133,77 @@ static void vmx_vm_destroy(struct kvm *kvm)
>  	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>  }
>  
> +#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
> +static int lam_sign_extend_bit(struct kvm_vcpu *vcpu, gva_t addr)
> +{
> +	u64 cr3, cr4;
> +
> +	/*
> +	 * The LAM identification of a pointer as user or supervisor is
> +	 * based solely on the value of pointer bit 63.
> +	 */
> +	if (!(addr >> 63)) {

BIT_ULL(63)

> +		cr3 = kvm_read_cr3(vcpu);

Use the perfectly good helper added earlier in the series:

		cr3_lam = kvm_get_active_lam_bits();

That has the added bonus of avoiding a VMREAD of CR3 when LAM is disabled in CR4.

> +		if (cr3 & X86_CR3_LAM_U57)
> +			return 56;
> +		if (cr3 & X86_CR3_LAM_U48)
> +			return 47;
> +	} else {
> +		cr4 = kvm_read_cr4_bits(vcpu, LAM_S57_EN_MASK);
> +		if (cr4 == LAM_S57_EN_MASK)
> +			return 56;
> +		if (cr4 & X86_CR4_LAM_SUP)
> +			return 47;

This is way too complicated for a simple thing.  Burying multiple bits in a #define
and then relying on specific bits being in the mask is unnecessarily subtle.

And this whole helper shouldn't exist.  There's one caller, and will only ever
be one caller.  Defining magic numbers, i.e. using -1 to signal "disabled", makes
it that much harder to read the code.

More below.

> +	}
> +	return -1;
> +}
> +
> +/*
> + * Only called in 64-bit mode.
> + *
> + * LAM has a modified canonical check when applicable:
> + * LAM_S48                : [ 1 ][ metadata ][ 1 ]
> + *                            63               47
> + * LAM_U48                : [ 0 ][ metadata ][ 0 ]
> + *                            63               47
> + * LAM_S57                : [ 1 ][ metadata ][ 1 ]
> + *                            63               56
> + * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
> + *                            63               56
> + * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
> + *                            63               56..47
> + *
> + * Untag the metadata bits by sign-extending the value of bit 47 (LAM48) or
> + * bit 56 (LAM57). The resulting address after untag isn't guaranteed to be
> + * canonical. Callers should perform the original canonical check and raise
> + * #GP/#SS if the address is non-canonical.
> + *
> + * Note that KVM masks the metadata in addresses, performs the (original)
> + * canonicality checking and then walks page table. This is slightly
> + * different from hardware behavior but achieves the same effect.
> + * Specifically, if LAM is enabled, the processor performs a modified
> + * canonicality checking where the metadata are ignored instead of
> + * masked. After the modified canonicality checking, the processor masks
> + * the metadata before passing addresses for paging translation.
> + */
> +void vmx_untag_addr(struct kvm_vcpu *vcpu, gva_t *gva, u32 flags)

Rather than modify the pointer, return the untagged address.  That's more flexible
as it allows using the result in if-statements and whatnot.  That might not ever
come into play, but there's no good reason to use an in/out param in a void
function.

> +{
> +	int sign_ext_bit;
> +
> +	/*
> +	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
> +	 * If not set, vCPU doesn't supports LAM.
> +	 */
> +	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||

This is unnecessary, KVM should never allow the LAM bits in CR3 to be set if LAM
isn't supported.

> +	    (flags & X86EMUL_F_SKIPLAM) || WARN_ON_ONCE(!is_64_bit_mode(vcpu)))

Same comments as the LASS series, don't WARN, just put the check here.

> +		return;
> +
> +	sign_ext_bit = lam_sign_extend_bit(vcpu, *gva);
> +	if (sign_ext_bit > 0)
> +		*gva = (sign_extend64(*gva, sign_ext_bit) & ~BIT_ULL(63)) |
> +		       (*gva & BIT_ULL(63));


Something like this?  The early return in the user path is a bit forced, e.g. it
could also be:

	if (cr3 & X86_CR3_LAM_U57)
		lam_bit = 56;
	else if (X86_CR3_LAM_U48)
		lam_bit = 48;
	else
		return gva;

but IMO making the CR3 and CR4 paths somewhat symmetrical is valuable.

gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva,
			    unsigned int flags)
{
	unsigned long cr3_bits, cr4_bits;
	int lam_bit;

	if (flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH_INVLPG | X86EMUL_F_IMPLICIT))
		return gva;

	if (!is_64_bit_mode(vcpu))
		return gva;

	/*
	 * Bit 63 determines if the address should be treated as user address
	 * or a supervisor address.
	 */
	if (!(gva & BIT_ULL(63))) {
		cr3_bits = kvm_get_active_lam_bits(vcpu);
		if (!(cr3 & (X86_CR3_LAM_U57 | X86_CR3_LAM_U48))
			return gva;

		/* LAM_U48 is ignored if LAM_U57 is set. */
		lam_bit = cr3_bits & X86_CR3_LAM_U57 ? 56 : 47;
	} else {
		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LAM_SUP_BIT))
			return gva;

		lam_bit = kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 56 : 47;
	}
	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
}

