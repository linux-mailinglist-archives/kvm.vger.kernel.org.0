Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0D31784F9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 22:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbgCCVfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 16:35:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:55439 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732572AbgCCVfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 16:35:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 13:35:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="232402038"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 03 Mar 2020 13:35:42 -0800
Date:   Tue, 3 Mar 2020 13:35:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     John Andersen <john.s.andersen@intel.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, hpa@zytor.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, liran.alon@oracle.com,
        luto@kernel.org, joro@8bytes.org, rick.p.edgecombe@intel.com,
        kristen@linux.intel.com, arjan@linux.intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 2/4] KVM: X86: Add CR pin MSRs
Message-ID: <20200303213541.GY1439@linux.intel.com>
References: <20200218215902.5655-1-john.s.andersen@intel.com>
 <20200218215902.5655-3-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218215902.5655-3-john.s.andersen@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subject should be something like

  KVM: x86: Introduce paravirt feature CR0/CR4 pinning

This patch obviously does a lot more than add a few MSRs :-)

On Tue, Feb 18, 2020 at 01:59:00PM -0800, John Andersen wrote:

...

> +MSR_KVM_CR0_PIN_ALLOWED: 0x4b564d06
> +MSR_KVM_CR4_PIN_ALLOWED: 0x4b564d07
> +	Read only registers informing the guest which bits may be pinned for
> +	each control register respectively via the CR pinned MSRs.
> +
> +	data: Bits which may be pinned.
> +
> +	Attempting to pin bits other than these will result in a failure when
> +	writing to the respective CR pinned MSR.
> +
> +	Bits which are allowed to be pinned are WP for CR0 and SMEP, SMAP, and
> +	UMIP for CR4.
> +
> +MSR_KVM_CR0_PINNED: 0x4b564d08
> +MSR_KVM_CR4_PINNED: 0x4b564d09
> +	Used to configure pinned bits in control registers
> +
> +	data: Bits to be pinned.
> +
> +	Fails if data contains bits which are not allowed to be pinned. Bits
> +	which are allowed to be pinned can be found by reading the CR pin
> +	allowed MSRs.
> +
> +	The MSRs are read/write for host userspace, and write-only for the
> +	guest.
> +
> +	Once set to a non-zero value, the guest cannot clear any of the bits
> +	that have been pinned to 1. The guest can set more bits to 1, so long
> +	as those bits appear in the allowed MSR.

Why not allow pinning a bit to 0?  That would make the logic in set_cr0/4
more intuitive.  This approach also means that WRMSR interception needs to
inject a #GP if the guest attempts to pin a bit and the bit isn't currently
set in the MSR, which this patch doesn't do.

The downside to allowing pinning to '0' is that KVM will need to track the
pinned value, e.g. for RSM and VM-Exit, but that's a fairly small cost and
might be valuable in the long run, e.g. if TSX retroactively gained CR
enable bit...

> +
> +	Host userspace may clear or change pinned bits at any point. Host
> +	userspace must clear pinned bits on reboot.
> +
> +	The MSR enables bit pinning for control registers. Pinning is active
> +	when the guest is not in SMM. If the guest attempts to write values to
> +	cr* where bits differ from pinned bits, the write will fail and the
> +	guest will be sent a general protection fault.

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb5d64ebc35d..2ee0e9886a6e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -733,6 +733,9 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(pdptrs_changed);
>  
> +#define KVM_CR0_PIN_ALLOWED	(X86_CR0_WP)
> +#define KVM_CR4_PIN_ALLOWED	(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP)
> +
>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  {
>  	unsigned long old_cr0 = kvm_read_cr0(vcpu);
> @@ -753,6 +756,11 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
>  		return 1;
>  
> +	if (!is_smm(vcpu)

Hmm, so there's some work to be done for nested virtualization.  I'm
guessing the story will be the same as SMM, i.e. L2 is allowed to "unpin"
bits, and pinned bits are rechecked on VM-Exit to L1.

Assuming you want to go that route, this needs to also check for
!is_guest_mode(), i.e. allow L2 to change bits that are pinned by L1.  It
likely works for standard nesting because nested VM-Enter bypasses
kvm_set_cr0(), e.g. prepare_vmcs02() calls vmx_set_cr0() to avoid fault
logic, but it'll break if L1 doesn't intercept pinned bits.  

Speaking of the bypass, you'll need to incorporate pinning into the
VM-Enter consistency checks, otherwise L1 could bypass pinning by loading
CR0/CR4 via VM-Exit, e.g. load_vmcs12_host_state() bypasses pinning checks.

> +		&& vcpu->arch.cr0_pinned

Operators go on the previous line, newline only when needed, and align
indentation when continuing a statement, e.g. (whitespace damaged)

        if (!is_smm(vcpu) && vcpu->arch.cr0_pinned &&
            ((cr0 ^ vcpu->arch.cr0_pinned) & KVM_CR0_PIN_ALLOWED))
                return 1;

> +             && ((cr0 ^ vcpu->arch.cr0_pinned) & KVM_CR0_PIN_ALLOWED))

If this ends up only allowing "pin-to-one" semantics, then the fields
should be named vcpu->arch.cr0_pinned_1 or so.  It took a lot of staring
to figure out what this code was doing.  The logic can also be optimized,
e.g.:

        if (!is_smm(vcpu) && !is_guest_mode(vcpu) &&
            (~cr0 & vcpu->arch.cr0_pinned_1))
                return 1;

If the feature is defined to pin bits to their current value, as opposed to
pinning bits to '1', then this code becomes:

        if (!is_smm(vcpu) && !is_guest_mode(vcpu) &&
            ((cr0 ^ old_cr0) & vcpu->arch.cr0_pinned.mask))
		return 1;

or if you wanted to be more paranoid

        if (!is_smm(vcpu) && !is_guest_mode(vcpu) &&
            ((cr0 ^ vcpu->arch.cr0_pinned.val) & vcpu->arch.cr0_pinned.mask))
		return 1;

or

        if (!is_smm(vcpu) && !is_guest_mode(vcpu) &&
            ((cr0 & vcpu->arch.cr0_pinned.mask) != vcpu->arch.cr0_pinned.val))
		return 1;

> +		&& ((cr0 ^ vcpu->arch.cr0_pinned) & KVM_CR0_PIN_ALLOWED))
> +		return 1;
> +
>  	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
>  #ifdef CONFIG_X86_64
>  		if ((vcpu->arch.efer & EFER_LME)) {
> @@ -932,6 +940,11 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	if (kvm_valid_cr4(vcpu, cr4))
>  		return 1;
>  
> +	if (!is_smm(vcpu)
> +		&& vcpu->arch.cr4_pinned
> +		&& ((cr4 ^ vcpu->arch.cr4_pinned) & KVM_CR4_PIN_ALLOWED))
> +		return 1;
> +
>  	if (is_long_mode(vcpu)) {
>  		if (!(cr4 & X86_CR4_PAE))
>  			return 1;
> @@ -1255,6 +1268,10 @@ static const u32 emulated_msrs_all[] = {
>  
>  	MSR_K7_HWCR,
>  	MSR_KVM_POLL_CONTROL,
> +	MSR_KVM_CR0_PIN_ALLOWED,
> +	MSR_KVM_CR4_PIN_ALLOWED,
> +	MSR_KVM_CR0_PINNED,
> +	MSR_KVM_CR4_PINNED,
>  };
>  
>  static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
> @@ -2878,6 +2895,28 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		vcpu->arch.msr_kvm_poll_control = data;
>  		break;
>  
> +	case MSR_KVM_CR0_PIN_ALLOWED:
> +	case MSR_KVM_CR4_PIN_ALLOWED:
> +		if (report_ignored_msrs)
> +			vcpu_debug_ratelimited(vcpu, "unhandled wrmsr: 0x%x data 0x%llx\n",
> +				    msr, data);

report_ignored_msrs is only for MSRs that KVM doesn't know how to handle.
The *_PIN_ALLOWED MSRs should simply do "return 1", even for host initiated
writes.  I.e. inject #GP on attempted WRMSR in the guest, return -EINVAL if
the userspace VMM tries to redefine what's allowed.

> +		break;
> +	case MSR_KVM_CR0_PINNED:
> +		if (data & ~KVM_CR0_PIN_ALLOWED)
> +			return 1;
> +		if (msr_info->host_initiated)
> +			vcpu->arch.cr0_pinned = data;
> +		else
> +			vcpu->arch.cr0_pinned |= data;

Hmm, I understand what you're doing, but having fundamentally different
behavior for host vs. guest is probably a bad idea.  I don't think it's
too onerous to require a RMW operation from the guest, e.g.

		if (data & ~KVM_CR0_PIN_ALLOWED)
			return 1;

		if (!msr_info->host_initiated &&
		    (~data & vcpu->arch.cr0_pinned.mask))
			return 1;

		vcpu->arch.cr0_pinned.mask = data;
		vcpu->arch.cr0_pinned.val = kvm_read_cr0(vcpu) & data;
		break;

> +		break;
> +	case MSR_KVM_CR4_PINNED:
> +		if (data & ~KVM_CR4_PIN_ALLOWED)
> +			return 1;
> +		if (msr_info->host_initiated)
> +			vcpu->arch.cr4_pinned = data;
> +		else
> +			vcpu->arch.cr4_pinned |= data;
> +		break;
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
>  	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> @@ -3124,6 +3163,18 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_KVM_POLL_CONTROL:
>  		msr_info->data = vcpu->arch.msr_kvm_poll_control;
>  		break;
> +	case MSR_KVM_CR0_PIN_ALLOWED:
> +		msr_info->data = KVM_CR0_PIN_ALLOWED;
> +		break;
> +	case MSR_KVM_CR4_PIN_ALLOWED:
> +		msr_info->data = KVM_CR4_PIN_ALLOWED;
> +		break;
> +	case MSR_KVM_CR0_PINNED:
> +		msr_info->data = vcpu->arch.cr0_pinned;
> +		break;
> +	case MSR_KVM_CR4_PINNED:
> +		msr_info->data = vcpu->arch.cr4_pinned;
> +		break;
>  	case MSR_IA32_P5_MC_ADDR:
>  	case MSR_IA32_P5_MC_TYPE:
>  	case MSR_IA32_MCG_CAP:
> @@ -6316,10 +6367,84 @@ static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_fla
>  	emul_to_vcpu(ctxt)->arch.hflags = emul_flags;
>  }
>  
> +static inline u64 restore_pinned(u64 val, u64 subset, u64 pinned)
> +{
> +	u64 pinned_high = pinned & subset;
> +	u64 pinned_low = ~pinned & subset;
> +
> +	val |= pinned_high;
> +	val &= ~pinned_low;
> +
> +	return val;
> +}
> +
> +static void kvm_pre_leave_smm_32_restore_crX_pinned(struct kvm_vcpu *vcpu,
> +						    const char *smstate,
> +						    u16 offset,
> +						    unsigned long allowed,
> +						    unsigned long cr_pinned)
> +{
> +	u32 cr;
> +
> +	cr = GET_SMSTATE(u32, smstate, offset);
> +	cr = (u32)restore_pinned(cr, allowed, cr_pinned);
> +	put_smstate(u32, smstate, offset, cr);
> +}
> +
> +static void kvm_pre_leave_smm_32_restore_cr_pinned(struct kvm_vcpu *vcpu,
> +						   const char *smstate)
> +{
> +	if (vcpu->arch.cr0_pinned)
> +		kvm_pre_leave_smm_32_restore_crX_pinned(vcpu, smstate, 0x7ffc,
> +							KVM_CR0_PIN_ALLOWED,
> +							vcpu->arch.cr0_pinned);
> +
> +	if (vcpu->arch.cr4_pinned)
> +		kvm_pre_leave_smm_32_restore_crX_pinned(vcpu, smstate, 0x7f14,
> +							KVM_CR4_PIN_ALLOWED,
> +							vcpu->arch.cr4_pinned);
> +}
> +
> +static void kvm_pre_leave_smm_64_restore_crX_pinned(struct kvm_vcpu *vcpu,
> +						    const char *smstate,
> +						    u16 offset,
> +						    unsigned long allowed,
> +						    unsigned long cr_pinned)
> +{
> +	u32 cr;
> +
> +	cr = GET_SMSTATE(u64, smstate, offset);
> +	cr = restore_pinned(cr, allowed, cr_pinned);
> +	put_smstate(u64, smstate, offset, cr);
> +}
> +
> +static void kvm_pre_leave_smm_64_restore_cr_pinned(struct kvm_vcpu *vcpu,
> +						   const char *smstate)
> +{
> +	if (vcpu->arch.cr0_pinned)
> +		kvm_pre_leave_smm_64_restore_crX_pinned(vcpu, smstate, 0x7f58,
> +							KVM_CR0_PIN_ALLOWED,
> +							vcpu->arch.cr0_pinned);
> +
> +	if (vcpu->arch.cr4_pinned)
> +		kvm_pre_leave_smm_64_restore_crX_pinned(vcpu, smstate, 0x7f48,
> +							KVM_CR4_PIN_ALLOWED,
> +							vcpu->arch.cr4_pinned);

Oof, that's a fair bit of ugly just to prevent SMM from poking into SMRAM
to attack the kernel.

If we do want to enforce pinning on RSM, I think it'd be better to inject
shutdown (well, return X86EMUL_UNHANDLEABLE) if the SMM handler changed the
value of a pinned CR bit.  The SDM blurb on RSM states:

  If the processor detects invalid state information during state
  restoration, it enters the shutdown state.

IMO it's fair to say that attempting to unpin CR bits qualifies as invalid
state.

The logic is also a lot cleaner, e.g. (plus updating prototypes)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index dd19fb3539e0..b1252de853c1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2674,7 +2674,8 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
                return X86EMUL_UNHANDLEABLE;
        }

-       ctxt->ops->post_leave_smm(ctxt);
+       if (ctxt->ops->post_leave_smm(ctxt))
+               return X86EMUL_UNHANDLEABLE;

        return X86EMUL_CONTINUE;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa2a085f115c..7c33c22b18fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6263,8 +6263,14 @@ static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
        return kvm_x86_ops->pre_leave_smm(emul_to_vcpu(ctxt), smstate);
 }

-static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
+static int emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
 {
+       struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+       unsigned long cr0 = kvm_read_cr0(vcpu);
+
+       if ((cr0 ^ vcpu->arch.cr0_pinned.val) & vcpu->arch.cr0_pinned.mask)
+               return 1;
+
        kvm_smm_changed(emul_to_vcpu(ctxt));
 }


> +}
> +
>  static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
>  				  const char *smstate)
>  {
> -	return kvm_x86_ops->pre_leave_smm(emul_to_vcpu(ctxt), smstate);
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +
> +#ifdef CONFIG_X86_64
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> +		kvm_pre_leave_smm_64_restore_cr_pinned(vcpu, smstate);
> +	else
> +#endif
> +		kvm_pre_leave_smm_32_restore_cr_pinned(vcpu, smstate);
> +
> +	return kvm_x86_ops->pre_leave_smm(vcpu, smstate);
>  }
>  
>  static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
> @@ -9490,6 +9615,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vcpu->arch.ia32_xss = 0;
>  
> +	vcpu->arch.cr0_pinned = 0;
> +	vcpu->arch.cr4_pinned = 0;
> +
>  	kvm_x86_ops->vcpu_reset(vcpu, init_event);
>  }
>  
> -- 
> 2.21.0
> 
