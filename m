Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0C34FC4C4
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 21:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349464AbiDKTKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349345AbiDKTK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 15:10:28 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D247035DE2
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 12:08:12 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v12so1716258plv.4
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 12:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p+rY+0tgM5EiHW0/0zRQ6ALM9kb8wEi0Fq1S8HRsqRM=;
        b=YN8G7gMq2LqC0IG5QOEk4Z8Kj31vr66KNtaFaQ6x8pNY3A5STHdply4UNf1ETKJB/p
         YEOPsJvNZeJUs6VPYo6YCtImbk24izw88JTL/i0E+w4azhF9dBP2O+PEmsVxNfxkXm+h
         8/iJBiMV027egxwx1par1BrpEP1naIM9aewsBjZW/Tnb9ciIsYHFm7rZVTtRnxyz5W5n
         Hb4mhq5Ej9wIAz9O/fy9aHoK+kb0FrX8Xh1pP86Hu/6umMm8dst4ZtpGhJuyKxCAP1tq
         SgMnN+jm8EKJaEtIhqI9pp4GPAqOwFS7HwjD/N57RK5LMUHFVTyboNL1QC/7PWQhg1Vy
         b+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p+rY+0tgM5EiHW0/0zRQ6ALM9kb8wEi0Fq1S8HRsqRM=;
        b=NYSdu5mpeKxg/8JvYSJC9pmhHGUILhbJs75yD/3FlkiRmjtmqdsJjH3F3sZznC/cxz
         tllpU8U/oPA/T9shaTPR/qRx6828R9iP97/giobuDFfL2kbavjo30PzaLQeza3goWYNG
         K1beaKpCFH5KZC/5vMa5txMBcrxWSP84s5hecPwkR9KfLtcyHXtzf3lUOsZXsqIJKKcu
         4QoCYvEHn0JQYkpmwzIbYMHqsWVIIwzdxuQqLnflp8adsMpdd0rz6wuIfCO3D1WiCT5x
         76iSVufJcky+lk95NGbgQA8j7q60X6vsi5XBqwPMRn1atUX3MJqxGLcoVxTgamSLNjeB
         SJ3Q==
X-Gm-Message-State: AOAM533cQgzEhi1S6DOFu6R7vFkYqppIZahyrMZTKYMOcsXbFN8YLvRx
        vkH9x6OtHsdDo6z0E1onWyx/Aw==
X-Google-Smtp-Source: ABdhPJzpxedmAP0+z3HBXbLX/O45Zn0AUwjggvN0pBVSR0YzWYIf3CVY20pWEpl/GmETwerkTDgoUA==
X-Received: by 2002:a17:902:8bcc:b0:158:20f8:392 with SMTP id r12-20020a1709028bcc00b0015820f80392mr16986942plo.93.1649704091946;
        Mon, 11 Apr 2022 12:08:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rm5-20020a17090b3ec500b001c7559762e9sm219992pjb.20.2022.04.11.12.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 12:08:11 -0700 (PDT)
Date:   Mon, 11 Apr 2022 19:08:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add support for CMCI and UCNA.
Message-ID: <YlR8l7aAYCwqaXEs@google.com>
References: <20220323182816.2179533-1-juew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323182816.2179533-1-juew@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022, Jue Wang wrote:
> CMCI 

Please write Corrected Machine Check Interrupt at least once.

> is supported since Nehalem.

While possibly interesting, this info is defitely not the most interesting tidbit
in the changelong, i.e. shouldn't be the opening line.

>  UCNA (uncorrectable no action required) errors signaled via CMCI allows a
>  guest to be notified as soon as uncorrectable memory errors get detected by
>  some background threads, e.g., threads that migrate guest memory across
>  hosts.
> 
> Upon receiving UCNAs, guest kernel isolates the poisoned pages from
> future accesses much earlier than a potential fatal Machine Check
> Exception due to accesses from a guest thread.
> 
> Add CMCI signaling based on the per vCPU opt-in of MCG_CMCI_P.

This changelog needs much longer explanation of what exactly is being added, e.g. I
had to read the code to find out that this introduces new userspace functionality
to allow injecting UNCA #MCs and thus CMCI IRQs.

That's also a symptom of this patch needing to be split into a proper series, e.g.
exposing the UNCA injection point to userspace needs to be a separate patch.

Looking through this, 5 or 6 patches is probably appropriate:

  1. Replace existing magic numbers with #defines
  2. Clean up the existing LVT mess
  3. Add in-kernel LVTCMCI support (unreachable until #, but easier to review)
  4. Add support for MSR_IA32_MCx_CTL2 MSRs
  5. Add CMCI support
  6. Add UNCA injection support

I can't tell if #4 is necessary as a separate patch, it might belong with #3.

> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  11 +++
>  arch/x86/kvm/lapic.c            |  65 ++++++++++++++----
>  arch/x86/kvm/lapic.h            |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |   1 +
>  arch/x86/kvm/x86.c              | 115 +++++++++++++++++++++++++++++---
>  5 files changed, 171 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ec9830d2aabf..d57f3d1284a3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -613,6 +613,8 @@ struct kvm_vcpu_xen {
>  	unsigned long evtchn_pending_sel;
>  };
>  
> +#define KVM_MCA_REG_PER_BANK 5
> +
>  struct kvm_vcpu_arch {
>  	/*
>  	 * rip and regs accesses must go through
> @@ -799,6 +801,15 @@ struct kvm_vcpu_arch {
>  	u64 mcg_status;
>  	u64 mcg_ctl;
>  	u64 mcg_ext_ctl;
> +	/*
> +	 * 5 registers per bank for up to KVM_MAX_MCE_BANKS.
> +	 * Register order within each bank:
> +	 * mce_banks[5 * bank]   - IA32_MCi_CTL
> +	 * mce_banks[5 * bank + 1] - IA32_MCi_STATUS
> +	 * mce_banks[5 * bank + 2] - IA32_MCi_ADDR
> +	 * mce_banks[5 * bank + 3] - IA32_MCi_MISC
> +	 * mce_banks[5 * bank + 4] - IA32_MCi_CTL2
> +	 */
>  	u64 *mce_banks;

Why shove CTL2 into mce_banks?  AFAICT, it just makes everything harder.  Adding
a new "u64 *mce_ctl2_banks" or whatever would simplify everything except the
memory allocation.

>  	/* Cache MMIO info */
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9322e6340a74..b388eb82308a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -27,6 +27,7 @@
>  #include <linux/math64.h>
>  #include <linux/slab.h>
>  #include <asm/processor.h>
> +#include <asm/mce.h>
>  #include <asm/msr.h>
>  #include <asm/page.h>
>  #include <asm/current.h>
> @@ -53,8 +54,6 @@
>  #define PRIu64 "u"
>  #define PRIo64 "o"
>  
> -/* 14 is the version for Xeon and Pentium 8.4.8*/
> -#define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))

Eh, probably worth keeping the APIC_VERSION #define and just move out the LVT crud.

>  #define LAPIC_MMIO_LENGTH		(1 << 12)
>  /* followed define is not in apicdef.h */
>  #define MAX_APIC_VECTOR			256
> @@ -367,7 +366,10 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 v = APIC_VERSION;
> +	int lvt_num = vcpu->arch.mcg_cap & MCG_CMCI_P ? KVM_APIC_LVT_NUM :
> +			KVM_APIC_LVT_NUM - 1;

Retrieving the number of LVT entries belongs in a helper, and this is rather gross
absuse of KVM_APIC_LVT_NUM as there's zero indication that it's pseudo-dynamic.
The code that handles accesses to APIC_LVTCMCI is even worse:

	val &= apic_lvt_mask[KVM_APIC_LVT_NUM - 1];

The easiest and best way to handle this is to define an enum, especially since
the LVT entries aren't exactly intuitive (e.g. LVT_LINT0 isn't entry 0)

enum lapic_lvt_entry {
	LVT_TIMER,
	LVT_THERMAL_MONITOR,
	LVT_PERFORMANCE_COUNTER,
	LVT_LINT0,
	LVT_LINT1,
	LVT_ERROR,
	LVT_CMCI,

	KVM_APIC_MAX_NR_LVT_ENTRIES,
}

And use those for the initialization of apic_lvt_mask[] and drop the comments:

static const unsigned int apic_lvt_mask[KVM_APIC_LVT_NUM] = {
	[LVT_TIMER] = LVT_MASK ,      /* timer mode mask added at runtime */
	[LVT_TERMAL_MONITOR] = LVT_MASK | APIC_MODE_MASK,

	and so on and so forth
};

Then there's no need for the ugly KVM_APIC_LVT_NUM - 1 shenanigans to access the
CMCI entry, and the only place that needs to be aware at all is the helper to
query the number of LVT entries.  Heh, and if we wanted to be clever/supid...

static inline kvm_apic_get_nr_lvt_entries(struct kvm_vcpu *vcpu)
{
	return KVM_APIC_MAX_NR_LVT_ENTRIES - !kvm_is_cmci_supported(vcpu);
}

> +	/* 14 is the version for Xeon and Pentium 8.4.8*/
> +	u32 v = 0x14UL | ((lvt_num - 1) << 16);
>  
>  	if (!lapic_in_kernel(vcpu))
>  		return;
> @@ -390,7 +392,8 @@ static const unsigned int apic_lvt_mask[KVM_APIC_LVT_NUM] = {
>  	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
>  	LVT_MASK | APIC_MODE_MASK,	/* LVTPC */
>  	LINT_MASK, LINT_MASK,	/* LVT0-1 */
> -	LVT_MASK		/* LVTERR */
> +	LVT_MASK,		/* LVTERR */
> +	LVT_MASK | APIC_MODE_MASK	/* LVTCMCI */
>  };
>  
>  static int find_highest_vector(void *bitmap)
> @@ -1405,6 +1408,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  		APIC_REG_MASK(APIC_TMCCT) |
>  		APIC_REG_MASK(APIC_TDCR);
>  
> +	if (apic->vcpu->arch.mcg_cap & MCG_CMCI_P)

As alluded to above, this belongs in a helper too.

> +		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
> +
>  	/* ARBPRI is not valid on x2APIC */
>  	if (!apic_x2apic_mode(apic))
>  		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
> @@ -1993,6 +1999,18 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>  	}
>  }
>  
> +static int kvm_lvt_reg_by_index(int i)
> +{
> +	if (i < 0 || i >= KVM_APIC_LVT_NUM) {
> +		pr_warn("lvt register index out of bound: %i\n", i);

This sanity check is unnecessary, @i is fully KVM controlled.  And a pr_warn() in
that case is nowhere near strong enough, e.g. at minimum this should be WARN_ON,
though again, I don't think that's necessary.

Actually, if we really wanted to sanity check @i, we could make this __always_inline
and turn it into a BUILD_BUG_ON(), though I bet there's a config option that will
result in the compiler not unrolling the callers and ruining that idea.

> +		return 0;
> +	}
> +
> +	if (i < KVM_APIC_LVT_NUM - 1)

Far better is

	if (i == LVT_CMCI)
		return APIC_LVTCMCI;

	return return APIC_LVTT + 0x10 * i;

Though given the nature of the usage, it might actually be better to bury this in
a macro (or a helper function masquerading as a macro by having a wierd name).

#define APIC_LVTx(x)							\
({									\
	int __apic_reg;							\
									\
	if ((x) != LVT_CMCI)						\
		__apic_reg = APIC_LVTCMCI;				\
	else								\
		__apic_reg = APIC_LVTT + 0x10 * (x);			\
	__apic_reg;							\
}


Then the usage stays quite readable and doesn't need temp variables, e.g.

			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
				kvm_lapic_set_reg(apic, APIC_LVTx(i),
						  lvt_val | APIC_LVT_MASKED);
			}

> +		return APIC_LVTT + 0x10 * i;
> +	return APIC_LVTCMCI;
> +}
> +

...

> @@ -2341,8 +2376,14 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
>  	kvm_apic_set_version(apic->vcpu);
>  
> -	for (i = 0; i < KVM_APIC_LVT_NUM; i++)
> -		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
> +	lvt_num = vcpu->arch.mcg_cap & MCG_CMCI_P ? KVM_APIC_LVT_NUM :
> +			KVM_APIC_LVT_NUM - 1;
> +	for (i = 0; i < lvt_num; i++) {
> +		int lvt_reg = kvm_lvt_reg_by_index(i);
> +
> +		if (lvt_reg)
> +			kvm_lapic_set_reg(apic, lvt_reg, APIC_LVT_MASKED);
> +	}
>  	apic_update_lvtt(apic);
>  	if (kvm_vcpu_is_reset_bsp(vcpu) &&
>  	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_LINT0_REENABLED))
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 2b44e533fc8d..e2ae097613ca 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -10,7 +10,7 @@
>  
>  #define KVM_APIC_INIT		0
>  #define KVM_APIC_SIPI		1
> -#define KVM_APIC_LVT_NUM	6
> +#define KVM_APIC_LVT_NUM	7
>  
>  #define APIC_SHORT_MASK			0xc0000
>  #define APIC_DEST_NOSHORT		0x0
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b730d799c26e..63aa2b3d30ca 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8035,6 +8035,7 @@ static __init int hardware_setup(void)
>  	}
>  
>  	kvm_mce_cap_supported |= MCG_LMCE_P;
> +	kvm_mce_cap_supported |= MCG_CMCI_P;
>  
>  	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
>  		return -EINVAL;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb4029660bd9..6626723bf51b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3180,6 +3180,25 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		vcpu->arch.mcg_ctl = data;
>  		break;
> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> +		{

Kernel style when curly braces is needed for a case statement is to put the opening
braces with the case and not indent.  Though my vote is to hoist "offset" to be
declared at the function level so that each statement doesn't need curly braces
just to define a fairly common varaible.

> +			u32 offset;
> +			/* BIT[30] - CMCI_ENABLE */
> +			/* BIT[0:14] - CMCI_THRESHOLD */
> +			u64 mask = (1 << 30) | 0x7fff;

Add proper #defines, not comments.

> +
> +			if (!(mcg_cap & MCG_CMCI_P) &&
> +			    (data || !msr_info->host_initiated))

This looks wrong, userspace should either be able to write the MSR or not, '0'
isn't special.  Unless there's a danger to KVM, which I don't think there is,
userspace should be allowed to ignore architectural restrictions, i.e. bypass
the MCG_CMCI_P check, so that KVM doesn't create an unnecessary dependency between
ioctls.  I.e. this should be:

		if (!(mcg_cap & MCG_CMCI_P) && !msr_info->host_initiated)
			return 1;

> +				return 1;
> +			/* An attempt to write a 1 to a reserved bit raises #GP*/
> +			if (data & ~mask)
> +				return 1;
> +			offset = array_index_nospec(
> +				msr - MSR_IA32_MC0_CTL2,
> +				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);

The existing code is gross, don't copy it :-)  I'd rather this run over the 80 char
soft limit.

> +			vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK + 4] = (data & mask);

The AND with the mask is pointless, @data has already been verified.

With all of the above, this becomes:

	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
		if (!(mcg_cap & MCG_CMCI_P) && !msr_info->host_initiated)
			return 1;

		if (data & ~(MCx_CTL2_CMCI_ENABLE | MCx_CTL2_CMCI_THRESHOLD))
			return 1;

		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
					    MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
		vcpu->arch.mce_ctl2_banks = [offset] = data;
		break;


> +		}
> +		break;
>  	default:
>  		if (msr >= MSR_IA32_MC0_CTL &&
>  		    msr < MSR_IA32_MCx_CTL(bank_num)) {
> @@ -3203,7 +3222,14 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  					return -1;
>  			}
>  
> -			vcpu->arch.mce_banks[offset] = data;
> +			/* MSR_IA32_MCi_CTL addresses are incremented by 4 bytes
> +			 * per bank.
> +			 * kvm_vcpu_arch.mce_banks has 5 registers per bank, see
> +			 * register layout details in kvm_host.h.
> +			 * MSR_IA32_MCi_CTL is the first register in each bank
> +			 * within kvm_vcpu_arch.mce_banks.
> +			 */
> +			vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK / 4] = data;

This mess goes away if CTL2 gets a separate array.

>  			break;
>  		}
>  		return 1;
> @@ -3489,7 +3515,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		}
>  		break;
> -	case 0x200 ... 0x2ff:
> +	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
> +	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
>  		return kvm_mtrr_set_msr(vcpu, msr, data);
>  	case MSR_IA32_APICBASE:
>  		return kvm_set_apic_base(vcpu, msr_info);
> @@ -3646,6 +3673,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
>  	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>  		return set_msr_mce(vcpu, msr_info);
>  
>  	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> @@ -3767,6 +3795,18 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>  	case MSR_IA32_MCG_STATUS:
>  		data = vcpu->arch.mcg_status;
>  		break;
> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> +		{
> +			u32 offset;
> +
> +			if (!(mcg_cap & MCG_CMCI_P) && !host)
> +				return 1;
> +			offset = array_index_nospec(
> +				msr - MSR_IA32_MC0_CTL2,
> +				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
> +			data = vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK + 4];

Same comments as the write path.

> +		}
> +		break;
>  	default:
>  		if (msr >= MSR_IA32_MC0_CTL &&
>  		    msr < MSR_IA32_MCx_CTL(bank_num)) {
> @@ -3774,7 +3814,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>  				msr - MSR_IA32_MC0_CTL,
>  				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
>  
> -			data = vcpu->arch.mce_banks[offset];
> +			data = vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK / 4];
>  			break;
>  		}
>  		return 1;

...
  
> +static bool is_ucna(u64 mcg_status, u64 mci_status)
> +{
> +	return !mcg_status &&
> +		!(mci_status & (MCI_STATUS_PCC|MCI_STATUS_S|MCI_STATUS_AR));

Spaces around the '|'.

> +}
> +
> +static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu,
> +				       struct kvm_x86_mce *mce)
> +{
> +	u64 mcg_cap = vcpu->arch.mcg_cap;
> +	unsigned int bank_num = mcg_cap & 0xff;
> +	u64 *banks = vcpu->arch.mce_banks;
> +
> +	/* Check for legal bank number in guest */
> +	if (mce->bank >= bank_num)
> +		return -EINVAL;
> +
> +	/* Disallow bits that are used for machine check signalling */

This needs a more verbose comment/explanation.  I can kinda sorta piece things
together, but the intent is unclear.

> +	if (mce->mcg_status ||
> +	    (mce->status & (MCI_STATUS_PCC|MCI_STATUS_S|MCI_STATUS_AR)))
> +		return -EINVAL;
> +
> +	 /* UCNA must have VAL and UC bits set */
> +	if ((mce->status & (MCI_STATUS_VAL|MCI_STATUS_UC)) !=
> +	    (MCI_STATUS_VAL|MCI_STATUS_UC))

Spaces again, though my personal preference would be:

	if (!(mce->status & MCI_STATUS_VAL) || !(mce->status & MCI_STATUC_UC))

> +		return -EINVAL;
> +
> +	banks += KVM_MCA_REG_PER_BANK * mce->bank;
> +	banks[1] = mce->status;
> +	banks[2] = mce->addr;
> +	banks[3] = mce->misc;
> +	vcpu->arch.mcg_status = mce->mcg_status;
> +
> +	/*
> +	 * if MCG_CMCI_P is 0 or BIT[30] of IA32_MCi_CTL2 is 0, CMCI signaling
> +	 * is disabled for the bank
> +	 */
> +	if (!(mcg_cap & MCG_CMCI_P) || !(banks[4] & (1 << 30)))

#defines, not comments for the BIT 32 thing.

> +		return 0;
> +
> +	if (lapic_in_kernel(vcpu))

Any reason to support UNCA injection without an in-kernel APIC?

> +		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTCMCI);
> +
> +	return 0;
> +}
