Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6266E131BD0
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 23:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgAFWtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 17:49:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:51362 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgAFWtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 17:49:32 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 14:49:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,403,1571727600"; 
   d="scan'208";a="216958946"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jan 2020 14:49:31 -0800
Date:   Mon, 6 Jan 2020 14:49:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
Message-ID: <20200106224931.GB12879@linux.intel.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 27, 2019 at 09:58:00AM -0600, Tom Lendacky wrote:
> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
> faults when a guest performs MMIO. The AMD memory encryption support uses
> a CPUID function to define the encryption bit position. Given this, it is
> possible that these bits can conflict.
> 
> Use svm_hardware_setup() to override the MMIO mask if memory encryption
> support is enabled. When memory encryption support is enabled the physical
> address width is reduced and the first bit after the last valid reduced
> physical address bit will always be reserved. Use this bit as the MMIO
> mask.
> 
> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 122d4ce3b1ab..2cb834b5982a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1361,6 +1361,32 @@ static __init int svm_hardware_setup(void)
>  		}
>  	}
>  
> +	/*
> +	 * The default MMIO mask is a single bit (excluding the present bit),
> +	 * which could conflict with the memory encryption bit. Check for
> +	 * memory encryption support and override the default MMIO masks if
> +	 * it is enabled.
> +	 */
> +	if (cpuid_eax(0x80000000) >= 0x8000001f) {
> +		u64 msr, mask;
> +
> +		rdmsrl(MSR_K8_SYSCFG, msr);
> +		if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT)  {
> +			/*
> +			 * The physical addressing width is reduced. The first
> +			 * bit above the new physical addressing limit will
> +			 * always be reserved. Use this bit and the present bit
> +			 * to generate a page fault with PFER.RSV = 1.
> +			 */
> +			mask = BIT_ULL(boot_cpu_data.x86_phys_bits);

This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
on a future processor, i.e. x86_phys_bits==52.

After staring at things for a while, I think we can handle this issue with
minimal fuss by special casing MKTME in kvm_set_mmio_spte_mask().  I'll
send a patch, I have a related bug fix for kvm_set_mmio_spte_mask() that
touches the same code.

> +			mask |= BIT_ULL(0);
> +
> +			kvm_mmu_set_mmio_spte_mask(mask, mask,
> +						   PT_WRITABLE_MASK |
> +						   PT_USER_MASK);
> +		}
> +	}
> +
>  	for_each_possible_cpu(cpu) {
>  		r = svm_cpu_init(cpu);
>  		if (r)
> -- 
> 2.17.1
> 
