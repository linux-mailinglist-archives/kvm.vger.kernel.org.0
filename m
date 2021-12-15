Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86C7475301
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 07:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhLOGfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 01:35:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:4997 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233961AbhLOGfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 01:35:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="226441797"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="226441797"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 22:35:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465413926"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.249.171.239]) ([10.249.171.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 22:35:40 -0800
Message-ID: <62cc7ba5-8a46-2396-e728-cf5902c22306@linux.intel.com>
Date:   Wed, 15 Dec 2021 14:35:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [patch 6/6] x86/fpu: Provide kvm_sync_guest_vmexit_xfd_state()
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.108057289@linutronix.de>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
In-Reply-To: <20211214024948.108057289@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Thomas,
On 12/14/2021 10:50 AM, Thomas Gleixner wrote:
> KVM can disable the write emulation for the XFD MSR when the vCPU's fpstate
> is already correctly sized to reduce the overhead.
>
> When write emulation is disabled the XFD MSR state after a VMEXIT is
> unknown and therefore not in sync with the software states in fpstate and
> the per CPU XFD cache.
>
> Provide kvm_sync_guest_vmexit_xfd_state() which has to be invoked after a
> VMEXIT before enabling interrupts when write emulation is disabled for the
> XFD MSR.
Thanks for this function.

s/kvm_sync_guest_vmexit_xfd_state/fpu_sync_guest_vmexit_xfd_state
in subject and changelog.


Thanks,
Jing
>
> It could be invoked unconditionally even when write emulation is enabled
> for the price of a pointless MSR read.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>   arch/x86/include/asm/fpu/api.h |    6 ++++++
>   arch/x86/kernel/fpu/core.c     |   26 ++++++++++++++++++++++++++
>   2 files changed, 32 insertions(+)
>
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -194,6 +194,12 @@ static inline int fpu_update_guest_xfd(s
>   	return __fpu_update_guest_features(guest_fpu, xcr0, xfd);
>   }
>   
> +#ifdef CONFIG_X86_64
> +extern void fpu_sync_guest_vmexit_xfd_state(void);
> +#else
> +static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
> +#endif
> +
>   extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
>   extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
>   
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -318,6 +318,32 @@ int __fpu_update_guest_features(struct f
>   }
>   EXPORT_SYMBOL_GPL(__fpu_update_guest_features);
>   
> +#ifdef CONFIG_X86_64
> +/**
> + * fpu_sync_guest_vmexit_xfd_state - Synchronize XFD MSR and software state
> + *
> + * Must be invoked from KVM after a VMEXIT before enabling interrupts when
> + * XFD write emulation is disabled. This is required because the guest can
> + * freely modify XFD and the state at VMEXIT is not guaranteed to be the
> + * same as the state on VMENTER. So software state has to be udpated before
> + * any operation which depends on it can take place.
> + *
> + * Note: It can be invoked unconditionally even when write emulation is
> + * enabled for the price of a then pointless MSR read.
> + */
> +void fpu_sync_guest_vmexit_xfd_state(void)
> +{
> +	struct fpstate *fps = current->thread.fpu.fpstate;
> +
> +	lockdep_assert_irqs_disabled();
> +	if (fpu_state_size_dynamic()) {
> +		rdmsrl(MSR_IA32_XFD, fps->xfd);
> +		__this_cpu_write(xfd_state, fps->xfd);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(fpu_sync_guest_vmexit_xfd_state);
> +#endif /* CONFIG_X86_64 */
> +
>   int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
>   {
>   	struct fpstate *guest_fps = guest_fpu->fpstate;
>

