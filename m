Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31337406E9
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 01:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjF0Xkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 19:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjF0Xkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 19:40:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CD51BE6
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 16:40:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c361777c7f7so329432276.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 16:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687909239; x=1690501239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kuye64R7CBgMaDLN8lrGwuRN3UwBizDiiMMe3qOfNs=;
        b=w2a09hsoYsqWjJZfst/OW9sXBfPahnHX/cWgIakOV2k6qiWr+xwcXv+48Psp0MdB7h
         pWtuxdbaMR+4SpvqvL5EJg3La6QtBTU53baxWNEe3dZK2THfoiYJAPUfDlaa1rGHIMEU
         0iSdqVDiIcK5u0PeOiwVAZiz9kyZcAMqquwY5IxB6FO3Qq5fw3HW8c2z9+Q+UWUc16yH
         bNmzijXcKVcd++ArgJdpKKFH2Fo34xwnYv8KexmG9zqRQWc50d1mk2wqwZZODRQLD5AV
         LNSiN7caGJfnfGVgsdWl3ieMhBYBbw2mJ9v1uzql/b4IdYSMnVZ46tYYK+dsEtDCsEzB
         gAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687909239; x=1690501239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kuye64R7CBgMaDLN8lrGwuRN3UwBizDiiMMe3qOfNs=;
        b=D6b8gJj/PCgbfHxWO/DVBlGPaVufJ/zFex5CLiqKjrp/aN7nbz08QH7BaAgpiwDaWD
         1eixUAVHtaLQCIRVg61iH2MTUczMpfeK7mDMhYRtqywGRYK/EaD7MIvmrLQ9Ex3LhNdn
         eu98zR9EnNhtshfhZzDZvAgz287mSYhcx8wXb0kJwnODe9gLMUa1eaQFCMTw1esbBF0W
         Cn6gHGrmhG8GtY0AECTho1+VEYDOr5ABh93HRQmbHPgUGrGN2B2ljGeISdBm1zKEv4jF
         u1n81TSR+/5j0t2Tufnw+y/up00QfKY+PTCdikLEtf5oY+PzFUg1ph3UkQoP6NWUENR7
         Kl9w==
X-Gm-Message-State: AC+VfDz8ON9OWUGktjrCpYSPUFNM20ug++2EfgTH0/9kHzvCSlkIgOWn
        l3hmyRgqhxt5utBsa9ZEkbKYNvbSxlM=
X-Google-Smtp-Source: ACHHUZ7P8T83Cz7R8MxciPORMXvY2UAqRBCq1v6MDgDX8mfPZvTPtzOqjLsAjWH0qufStJSnMXARuKU0mDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e60e:0:b0:c1c:9553:d4f4 with SMTP id
 d14-20020a25e60e000000b00c1c9553d4f4mr4869992ybh.3.1687909239261; Tue, 27 Jun
 2023 16:40:39 -0700 (PDT)
Date:   Tue, 27 Jun 2023 16:40:37 -0700
In-Reply-To: <20230606091842.13123-4-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230606091842.13123-1-binbin.wu@linux.intel.com> <20230606091842.13123-4-binbin.wu@linux.intel.com>
Message-ID: <ZJtzdftocuwTvp67@google.com>
Subject: Re: [PATCH v9 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, t@google.com
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
> Opportunistically use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.

This are not the type of changes to do opportunstically.   Opportunstic changes
are things like fixing comment typos, dropping unnecessary semi-colons, fixing
coding styles violations, etc.

> Opportunistically use kvm_vcpu_is_legal_cr3() to check CR3 in SVM nested code,
> to provide a clear distinction b/t CR3 and GPA checks.

This *shouldn't* be an opportunsitic thing.  That you felt compelled to call it
out is a symptom of this patch doing too much.

In short, split this into three patches:

  1. Do the __PT_BASE_ADDR_MASK() changes
  2. Add and use kvm_vcpu_is_legal_cr3()
  3. Add support for CR3.LAM bits

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 5 +++++
>  arch/x86/kvm/cpuid.h            | 5 +++++
>  arch/x86/kvm/mmu.h              | 5 +++++
>  arch/x86/kvm/mmu/mmu.c          | 8 +++++++-
>  arch/x86/kvm/mmu/mmu_internal.h | 1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  | 3 ++-
>  arch/x86/kvm/mmu/spte.h         | 2 +-
>  arch/x86/kvm/svm/nested.c       | 4 ++--
>  arch/x86/kvm/vmx/nested.c       | 4 ++--
>  arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
>  arch/x86/kvm/x86.c              | 4 ++--
>  11 files changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c6f03d151c31..46471dd9cc1b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -727,6 +727,11 @@ struct kvm_vcpu_arch {
>  	unsigned long cr0_guest_owned_bits;
>  	unsigned long cr2;
>  	unsigned long cr3;
> +	/*
> +	 * CR3 non-address feature control bits.
> +	 * Guest CR3 may contain any of those bits at runtime.
> +	 */
> +	u64 cr3_ctrl_bits;

This should be an "unsigned long".

Hmm, "ctrl_bits" is unnecessarily generic at this point.  It's also arguably wrong,
because X86_CR3_PCID_NOFLUSH is also a control bit, it's just allowed in CR3 itself.

I think I'd prefer to drop this field and avoid bikeshedding the name entirely.  The
only reason to effectively cache "X86_CR3_LAM_U48 | X86_CR3_LAM_U57" is because
guest_cpuid_has() is slow, and I'd rather solve that problem with the "governed
feature" framework.

More below.

>  	unsigned long cr4;
>  	unsigned long cr4_guest_owned_bits;
>  	unsigned long cr4_guest_rsvd_bits;
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index b1658c0de847..ef8e1b912d7d 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -42,6 +42,11 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
>  	return vcpu->arch.maxphyaddr;
>  }
>  
> +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)

Heh, I think it makes sense to wrap this one.  I'll probably tell you differently
tomorrow, but today, let's wrap.

> +{
> +	return !((cr3 & vcpu->arch.reserved_gpa_bits) & ~vcpu->arch.cr3_ctrl_bits);

Don't open code something for which there is a perfect helper, i.e. use
kvm_vcpu_is_legal_gpa().

If we go the governed feature route, this becomes:

static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu,
					 unsigned long cr3)
{
	if (guest_can_use(vcpu, X86_FEATURE_LAM))
		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);

	return kvm_vcpu_is_legal_gpa(cr3);
}

> +}
> +
>  static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
>  {
>  	return !(gpa & vcpu->arch.reserved_gpa_bits);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 92d5a1924fc1..81d8a433dae1 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -144,6 +144,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>  	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
>  }
>  
> +static inline u64 kvm_get_active_cr3_ctrl_bits(struct kvm_vcpu *vcpu)

And then this becomes:

static inline u64 kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
{
	if (!guest_can_use(vcpu, X86_FEATURE_LAM))
		return 0;

	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
}

> +{
> +	return kvm_read_cr3(vcpu) & vcpu->arch.cr3_ctrl_bits;
> +}
> +
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
>  	u64 root_hpa = vcpu->arch.mmu->root.hpa;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..deea9a9f0c75 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3812,7 +3812,13 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	hpa_t root;
>  
>  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
> -	root_gfn = root_pgd >> PAGE_SHIFT;
> +	/*
> +	 * Guest PGD can be CR3 or EPTP (for nested EPT case). CR3 may contain
> +	 * additional control bits (e.g. LAM control bits). To be generic,
> +	 * unconditionally strip non-address bits when computing the GFN since
> +	 * the guest PGD has already been checked for validity.
> +	 */

Drop this comment, the code is self-explanatory, and the comment is incomplete,
e.g. it can also be nCR3.

> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>  
>  	if (mmu_check_root(vcpu, root_gfn))
>  		return 1;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d39af5639ce9..7d2105432d66 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -21,6 +21,7 @@ extern bool dbg;
>  #endif
>  
>  /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
> +#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)
>  #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
>  	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
>  #define __PT_INDEX(address, level, bits_per_level) \
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0662e0278e70..394733ac9088 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -62,7 +62,7 @@
>  #endif
>  
>  /* Common logic, but per-type values.  These also need to be undefined. */
> -#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
> +#define PT_BASE_ADDR_MASK	((pt_element_t)__PT_BASE_ADDR_MASK)
>  #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>  #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>  #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
> @@ -324,6 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	trace_kvm_mmu_pagetable_walk(addr, access);
>  retry_walk:
>  	walker->level = mmu->cpu_role.base.level;
> +	/* gpte_to_gfn() will strip non-address bits. */

Drop this comment too, it's not relevant to the immediate code, i.e. it'd be
better suited about this code:

	table_gfn = gpte_to_gfn(pte);

but IMO that code is quite self-explanatory too.

> @@ -7740,6 +7741,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		vmx->msr_ia32_feature_control_valid_bits &=
>  			~FEAT_CTL_SGX_LC_ENABLED;
>  
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))

This is wrong, KVM needs to check that the host supports LAM too, otherwise KVM
will allow userspace to shove garbage into guest CR3 and induce VM-Entry failures
and whatnot.  If we go the guest_can_use() route, this problem solves itself.
