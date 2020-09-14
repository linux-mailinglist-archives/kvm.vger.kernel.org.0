Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0912698B0
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgINWOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:14:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:54052 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINWN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 18:13:59 -0400
IronPort-SDR: MP6Dz+yE3CrwgtDPQ7t+Itl/PzdHl1j5xAXllFwHvCborAdQe7ArmsdVkbIisiJYQWXjzBrg5M
 dOsdHplLlBgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158452604"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="158452604"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:13:58 -0700
IronPort-SDR: w9uGGY2SLnY0hUE/8JkinGmaLcF1dPRyWmFepJ8cBoudrEw521Phbftd1y4KRywM0iy+UVwsBj
 Jem4WnLzxTnA==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="345588471"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:13:58 -0700
Date:   Mon, 14 Sep 2020 15:13:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 22/35] KVM: SVM: Add support for CR0 write traps for
 an SEV-ES guest
Message-ID: <20200914221353.GJ7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <68f885b63b18e5c72eae92c9c681296083c0ccd8.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68f885b63b18e5c72eae92c9c681296083c0ccd8.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:36PM -0500, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b65bd0c986d4..6f5988c305e1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -799,11 +799,29 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(pdptrs_changed);
>  
> +static void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0,
> +			     unsigned long cr0)

What about using __kvm_set_cr*() instead of kvm_post_set_cr*()?  That would
show that __kvm_set_cr*() is a subordinate of kvm_set_cr*(), and from the
SVM side would provide the hint that the code is skipping the front end of
kvm_set_cr*().

> +{
> +	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
> +
> +	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
> +		kvm_clear_async_pf_completion_queue(vcpu);
> +		kvm_async_pf_hash_reset(vcpu);
> +	}
> +
> +	if ((cr0 ^ old_cr0) & update_bits)
> +		kvm_mmu_reset_context(vcpu);
> +
> +	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
> +	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
> +	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> +		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> +}
> +
>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  {
>  	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>  	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
> -	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
>  
>  	cr0 |= X86_CR0_ET;
>  
> @@ -842,22 +860,23 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  
>  	kvm_x86_ops.set_cr0(vcpu, cr0);
>  
> -	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
> -		kvm_clear_async_pf_completion_queue(vcpu);
> -		kvm_async_pf_hash_reset(vcpu);
> -	}
> +	kvm_post_set_cr0(vcpu, old_cr0, cr0);
>  
> -	if ((cr0 ^ old_cr0) & update_bits)
> -		kvm_mmu_reset_context(vcpu);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_cr0);
>  
> -	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
> -	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
> -	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> -		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> +int kvm_track_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)

I really dislike the "track" terminology.  For me, using "track" as the verb
in a function implies the function activates tracking.  But it's probably a
moot point, because similar to EFER, I don't see any reason to put the front
end of the emulation into x86.c.  Both getting old_cr0 and setting
vcpu->arch.cr0 can be done in svm.c

> +{
> +	unsigned long old_cr0 = kvm_read_cr0(vcpu);
> +
> +	vcpu->arch.cr0 = cr0;
> +
> +	kvm_post_set_cr0(vcpu, old_cr0, cr0);
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(kvm_set_cr0);
> +EXPORT_SYMBOL_GPL(kvm_track_cr0);
>  
>  void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
>  {
> -- 
> 2.28.0
> 
