Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E072698B4
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgINWQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:16:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:33502 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINWQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 18:16:53 -0400
IronPort-SDR: R6C0hA9AYY9YXnVLLFBnjlfb5Ytmipkd5QM2IOXQ0kFUXrjs2uPiqqd7a52O4gJN/5ct5ykHxE
 7Cy0rCYhEAqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="156561114"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="156561114"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:16:53 -0700
IronPort-SDR: GHJqf5RW8LMKE/e8375PhESr1nZgSnwP9elSOBJf97g0pDi2g30vXT67Lhu2PXJDSulfAA2pxJ
 83j3mlMMCbgQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="345589287"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 15:16:52 -0700
Date:   Mon, 14 Sep 2020 15:16:51 -0700
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
Subject: Re: [RFC PATCH 23/35] KVM: SVM: Add support for CR4 write traps for
 an SEV-ES guest
Message-ID: <20200914221651.GK7192@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <97f610c7fcf0410985a3ff4cd6d4013f83fe59e6.1600114548.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97f610c7fcf0410985a3ff4cd6d4013f83fe59e6.1600114548.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:15:37PM -0500, Tom Lendacky wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6f5988c305e1..5e5f1e8fed3a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1033,6 +1033,26 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_cr4);
>  
> +int kvm_track_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +{
> +	unsigned long old_cr4 = kvm_read_cr4(vcpu);
> +	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> +				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
> +
> +	if (kvm_x86_ops.set_cr4(vcpu, cr4))
> +		return 1;

Pretty much all the same comments as EFER and CR0, e.g. call svm_set_cr4()
directly instead of bouncing through kvm_x86_ops.  And with that, this can
be called __kvm_set_cr4() to be consistent with __kvm_set_cr0().

> +
> +	if (((cr4 ^ old_cr4) & pdptr_bits) ||
> +	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
> +		kvm_mmu_reset_context(vcpu);
> +
> +	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
> +		kvm_update_cpuid_runtime(vcpu);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_track_cr4);
> +
>  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  {
>  	bool skip_tlb_flush = false;
> -- 
> 2.28.0
> 
