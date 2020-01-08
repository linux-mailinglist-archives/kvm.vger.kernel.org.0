Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE32134B6F
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 20:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgAHTUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:20:00 -0500
Received: from mga04.intel.com ([192.55.52.120]:45729 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727191AbgAHTUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 14:20:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 11:19:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="254329013"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jan 2020 11:19:58 -0800
Date:   Wed, 8 Jan 2020 11:19:58 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v3] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
Message-ID: <20200108191958.GA31899@linux.intel.com>
References: <6d2b7e37ca4dca92fadd1f3df93803fd17aa70ad.1578508816.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d2b7e37ca4dca92fadd1f3df93803fd17aa70ad.1578508816.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 08, 2020 at 12:40:16PM -0600, Tom Lendacky wrote:
> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
> faults when a guest performs MMIO. The AMD memory encryption support uses
> a CPUID function to define the encryption bit position. Given this, it is
> possible that these bits can conflict.
> 
> Use svm_hardware_setup() to override the MMIO mask if memory encryption
> support is enabled. Various checks are performed to ensure that the mask
> is properly defined and rsvd_bits() is used to generate the new mask (as
> was done prior to the change that necessitated this patch).
> 
> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

A few nits below, other than that:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> 
> ---
> 
> Changes in v3:
> - Add additional checks to ensure there are no conflicts between the
>   encryption bit position and physical address setting.
> - Use rsvd_bits() generated mask (as was previously used) instead of
>   setting a single bit.
> 
> Changes in v2:
> - Use of svm_hardware_setup() to override MMIO mask rather than adding an
>   override callback routine.
> ---
>  arch/x86/kvm/svm.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 122d4ce3b1ab..9d6bd3fc12c8 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1307,6 +1307,55 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +/*
> + * The default MMIO mask is a single bit (excluding the present bit),
> + * which could conflict with the memory encryption bit. Check for
> + * memory encryption support and override the default MMIO masks if
> + * it is enabled.
> + */
> +static __init void svm_adjust_mmio_mask(void)
> +{
> +	unsigned int enc_bit, mask_bit;
> +	u64 msr, mask;
> +
> +	/* If there is no memory encryption support, use existing mask */
> +	if (cpuid_eax(0x80000000) < 0x8000001f)
> +		return;
> +
> +	/* If memory encryption is not enabled, use existing mask */
> +	rdmsrl(MSR_K8_SYSCFG, msr);
> +	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
> +		return;
> +
> +	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
> +	mask_bit = boot_cpu_data.x86_phys_bits;
> +
> +	/* Increment the mask bit if it is the same as the encryption bit */
> +	if (enc_bit == mask_bit)
> +		mask_bit++;

Nice!

> +
> +	if (mask_bit > 51) {
> +		/*
> +		 * The mask bit is above 51, so use bit 51 without the present
> +		 * bit.
> +		 */
> +		mask = BIT_ULL(51);

I don't think setting bit 51 is necessary.  Setting a reserved PA bit is
purely to trigger the #PF, the MMIO spte itself is confirmed by the presence
of SPTE_MMIO_MASK.

AFAICT, clearing only the present bit in kvm_set_mmio_spte_mask() is an
odd implementation quirk, i.e. it can, and arguably should, simply clear
the mask.  It's something I'd like to clean up (in mmu.c) and would prefer
to not propagate here.

> +	} else {
> +		/*
> +		 * Some bits above the physical addressing limit will always
> +		 * be reserved, so use the rsvd_bits() function to generate
> +		 * the mask. This mask, along with the present bit, will be
> +		 * used to generate a page fault with PFER.RSV = 1.
> +		 */
> +		mask = rsvd_bits(mask_bit, 51);
> +		mask |= BIT_ULL(0);

My personal preference would be to use PT_PRESENT_MASK (more crud in mmu.c
that should be fixed).  And the brackets can be dropped if mask is set in
a single line, e.g.:

	/*
	 * Here be a comment.
	 */
	if (mask_bit > 51)
		mask = 0;
	else
		mask = rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK;

> +	}
> +
> +	kvm_mmu_set_mmio_spte_mask(mask, mask,
> +				   PT_WRITABLE_MASK |
> +				   PT_USER_MASK);
> +}
> +
>  static __init int svm_hardware_setup(void)
>  {
>  	int cpu;
> @@ -1361,6 +1410,8 @@ static __init int svm_hardware_setup(void)
>  		}
>  	}
>  
> +	svm_adjust_mmio_mask();
> +
>  	for_each_possible_cpu(cpu) {
>  		r = svm_cpu_init(cpu);
>  		if (r)
> -- 
> 2.17.1
> 
