Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6887F77D6C4
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 01:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbjHOXrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 19:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240703AbjHOXqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 19:46:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA841B5
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:46:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d65201b777dso10429102276.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692143203; x=1692748003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HM8SZ06YxRyqgVDvZ3Q4zN6c+jNJwG1KnHETCnoy8EQ=;
        b=yIFfLysNBGvr5ulEqYO2DbYiKjHU92boRuTAX2iQiqZZtEdPSWsEIS/QjuNu2Bsh6Q
         G7fGNCyDEFMxEWkEMPDHoRqtA6sgKBC6lJlg0Sn2eFnz0ThjkaW5x40bekWM9c+reOwN
         DoPtHav3PN67e+PHD+h84UHfU15Hjw5KtNd9dHyGcEywcIB+bJm6UekYk/V96OwIqFH6
         n6ZRBgJ46D+gpPJSTYyNHk1T6v88zbtAOtvnvcCcsqg/3YAn7BDQ1PvTy4je9sMGn5AG
         3y0khXD0IODOrz8ksOpGkAKae35LezsLKfwayEJOC23HZGhVtXkMHRR8Gnn5xTGpfCRb
         bk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692143203; x=1692748003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HM8SZ06YxRyqgVDvZ3Q4zN6c+jNJwG1KnHETCnoy8EQ=;
        b=jkv7/1N4Ebl9KFe2L1HmSUjYluxuqdjU3bVPzF1NicfrTNWlligrSR9WcbTIzlLZ9o
         INcivf/VAadb5kLsd2uTdSLg+ogCpJyEfnyKP1zsK35KJkRmUKCpVENk3Ps/FCzfzq3e
         +K7IYiENmMfiGK0aUzwdQEAhVheLK2TBrh7GEhiFQmrHY7Kv0pg2fj9JaB1COIrvs2Ob
         mgWDp2oyPwG0VSvBKBadb48/NRASJXhlNFdmQVPlUFK1NHcDP1rpyCIfcL90poR+Qm6P
         hYTpxV2n0mGmUFWVvNZiv4o7zYGkp6xmAeq0qzk1HZqFAcQfRAYXdCHXpaIYmaeYB6jt
         EjZg==
X-Gm-Message-State: AOJu0YyzHLG4shI8rv+iXBt2+UgNJoC3ZQ5snCr+vepD7x9aSJiCFCO4
        cKKXOAEfi4cMqsBfSWCUnQYuLyQDqa0=
X-Google-Smtp-Source: AGHT+IHzz6z6v1AlP79XchmyN0O0Vv8iWplxgCBICotivJMCPHxx54tW16ibdbPm6TJsyVc0rTCz3MbanpA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1818:b0:d08:95:76d with SMTP id
 cf24-20020a056902181800b00d080095076dmr9314ybb.6.1692143203303; Tue, 15 Aug
 2023 16:46:43 -0700 (PDT)
Date:   Tue, 15 Aug 2023 16:46:41 -0700
In-Reply-To: <8c628549-a388-afd5-3c6e-a956fbce7f79@linux.intel.com>
Mime-Version: 1.0
References: <20230719024558.8539-1-guang.zeng@intel.com> <20230719024558.8539-7-guang.zeng@intel.com>
 <8c628549-a388-afd5-3c6e-a956fbce7f79@linux.intel.com>
Message-ID: <ZNwOYdy3AC12MI52@google.com>
Subject: Re: [PATCH v2 6/8] KVM: VMX: Implement and apply vmx_is_lass_violation()
 for LASS protection
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 07, 2023, Binbin Wu wrote:
> 
> On 7/19/2023 10:45 AM, Zeng Guang wrote:
> > Implement and wire up vmx_is_lass_violation() in kvm_x86_ops for VMX.
> > 
> > LASS violation check takes effect in KVM emulation of instruction fetch
> > and data access including implicit access when vCPU is running in long
> > mode, and also involved in emulation of VMX instruction and SGX ENCLS
> > instruction to enforce the mode-based protections before paging.
> > 
> > But the target memory address of emulation of TLB invalidation and branch
> > instructions aren't subject to LASS as exceptions.

Same nit about branch instructions.  And I would explicitly say "linear address"
instead of "target memory address", the "target" part makes it a bit ambiguous.

How about this?

Linear addresses used for TLB invalidation (INVPLG, INVPCID, and INVVPID) and
branch targets are not subject to LASS enforcement.

> > 
> > Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> > Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> > ---
> >   arch/x86/kvm/vmx/nested.c |  3 ++-
> >   arch/x86/kvm/vmx/sgx.c    |  4 ++++
> >   arch/x86/kvm/vmx/vmx.c    | 35 +++++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/vmx.h    |  3 +++
> >   4 files changed, 44 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index e35cf0bd0df9..72e78566a3b6 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4985,7 +4985,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
> >   		 * non-canonical form. This is the only check on the memory
> >   		 * destination for long mode!
> >   		 */
> > -		exn = is_noncanonical_address(*ret, vcpu);
> > +		exn = is_noncanonical_address(*ret, vcpu) ||
> > +		      vmx_is_lass_violation(vcpu, *ret, len, 0);
> >   	} else {
> >   		/*
> >   		 * When not in long mode, the virtual/linear address is
> > diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> > index 2261b684a7d4..f8de637ce634 100644
> > --- a/arch/x86/kvm/vmx/sgx.c
> > +++ b/arch/x86/kvm/vmx/sgx.c
> > @@ -46,6 +46,10 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
> >   			((s.base != 0 || s.limit != 0xffffffff) &&
> >   			(((u64)*gva + size - 1) > s.limit + 1));
> >   	}
> > +
> > +	if (!fault)
> > +		fault = vmx_is_lass_violation(vcpu, *gva, size, 0);

At the risk of bleeding details where they don't need to go... LASS is Long Mode
only, so I believe this chunk can be:

	if (!IS_ALIGNED(*gva, alignment)) {
		fault = true;
	} else if (likely(is_64_bit_mode(vcpu))) {
		fault = is_noncanonical_address(*gva, vcpu) ||
			vmx_is_lass_violation(vcpu, *gva, size, 0);
	} else {
		*gva &= 0xffffffff;
		fault = (s.unusable) ||
			(s.type != 2 && s.type != 3) ||
			(*gva > s.limit) ||
			((s.base != 0 || s.limit != 0xffffffff) &&
			(((u64)*gva + size - 1) > s.limit + 1));
	}

which IIRC matches some earlier emulator code.

> > +
> >   	if (fault)
> >   		kvm_inject_gp(vcpu, 0);
> >   	return fault ? -EINVAL : 0;
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 44fb619803b8..15a7c6e7a25d 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8127,6 +8127,40 @@ static void vmx_vm_destroy(struct kvm *kvm)
> >   	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
> >   }
> > +bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
> > +			   unsigned int size, unsigned int flags)
> > +{
> > +	const bool is_supervisor_address = !!(addr & BIT_ULL(63));
> > +	const bool implicit = !!(flags & X86EMUL_F_IMPLICIT);
> > +	const bool fetch = !!(flags & X86EMUL_F_FETCH);
> > +	const bool is_wraparound_access = size ? (addr + size - 1) < addr : false;

Shouldn't this WARN if size==0?  Ah, the "pre"-fetch fetch to get the max insn
size passes '0'.  Well that's annoying.

Please don't use a local variable to track if an access wraps.  It's used exactly
one, and there's zero reason to use a ternary operator at the return.  E.g. this
is much easier on the eyes:

	if (size && (addr + size - 1) < addr)
		return true;

	return !is_supervisor_address;

Hrm, and typing that out makes me go "huh?"  Ah, it's the "implicit" thing that
turned me around.  Can you rename "implicit" to "implicit_supervisor"?  The
F_IMPLICIT flag is fine, it's just this code:

	if (!implicit && vmx_get_cpl(vcpu) == 3)
		return is_supervisor_address;

where it's easy to miss that "implicit" is "implicit supervisor".

And one more nit, rather than detect wraparound, I think it would be better to
detect that bit 63 isn't set.  Functionally, they're the same, but detecting
wraparound makes it look like wraparound itself is problematic, which isn't
technically true, it's just the only case where an access can possibly straddle
user and kernel address spaces.

And I think we should call out that if LAM is supported, @addr has already been
untagged.  Yeah, it's peeking ahead a bit, but I'd rather have a comment that
is a bit premature than forget to add the appropriate comment in the LAM series.

> > +
> > +	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
> > +		return false;
> > +
> > +	/*
> > +	 * INVTLB isn't subject to LASS, e.g. to allow invalidating userspace
> > +	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
> > +	 * to LASS in order to simplifiy far control transfers (the subsequent
> s/simplifiy/simplifiy
> 
> > +	 * fetch will enforce LASS as appropriate).
> > +	 */
> > +	if (flags & (X86EMUL_F_BRANCH | X86EMUL_F_INVTLB))
> > +		return false;
> > +
> > +	if (!implicit && vmx_get_cpl(vcpu) == 3)
> > +		return is_supervisor_address;
> > +
> > +	/* LASS is enforced for supervisor-mode access iff SMAP is enabled. */
> To be more accurate, supervisor-mode data access.
> Also, "iff" here is not is a typo for "if" or it stands for "if and only
> if"?

The latter.

> It is not accureate to use "if and only if" here because beside SMAP, there
> are other conditions, i.e. implicit or RFLAGS.AC.

I was trying to avoid a multi-line comment when I suggested the above.  Hmm, and
I think we could/should consolidate the two if-statements.  This?

	/*
	 * LASS enforcement for supervisor-mode data accesses depends on SMAP
	 * being enabled, and like SMAP ignores explicit accesses if RFLAGS.AC=1.
	 */
	if (!fetch) {
		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
			return false;

		if (!implicit && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
			return false;
	}

> > +	if (!fetch && !kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
> > +		return false;
> > +
> > +	/* Like SMAP, RFLAGS.AC disables LASS checks in supervisor mode. */
> > +	if (!fetch && !implicit && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
> > +		return false;

All in all, this?  (wildly untested)

	const bool is_supervisor_address = !!(addr & BIT_ULL(63));
	const bool implicit_supervisor = !!(flags & X86EMUL_F_IMPLICIT);
	const bool fetch = !!(flags & X86EMUL_F_FETCH);

	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
		return false;

	/*
	 * INVTLB isn't subject to LASS, e.g. to allow invalidating userspace
	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
	 * to LASS in order to simplifiy far control transfers (the subsequent
	 * fetch will enforce LASS as appropriate).
	 */
	if (flags & (X86EMUL_F_BRANCH | X86EMUL_F_INVTLB))
		return false;

	if (!implicit_supervisor && vmx_get_cpl(vcpu) == 3)
		return is_supervisor_address;

	/*
	 * LASS enforcement for supervisor-mode data accesses depends on SMAP
	 * being enabled, and like SMAP ignores explicit accesses if RFLAGS.AC=1.
	 */
	if (!fetch) {
		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
			return false;

		if (!implicit_supervisor && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
			return false;
	}

	/*
	 * The entire access must be in the appropriate address space.  Note,
	 * if LAM is supported, @addr has already been untagged, so barring a
	 * massive architecture change to expand the canonical address range,
	 * it's impossible for a user access to straddle user and supervisor
	 * address spaces.
	 */
	if (size && !((addr + size - 1) & BIT_ULL(63)))
		return true;

	return !is_supervisor_address;
