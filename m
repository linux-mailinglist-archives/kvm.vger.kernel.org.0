Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3268E1C7D4E
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 00:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgEFW0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 18:26:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:17753 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgEFW0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 18:26:43 -0400
IronPort-SDR: Wm0QnBk76CkD5yHGOkJKtGXMpTWpR4MtQUyspzirQkBO+xVu/dbp6oBNBKn0K82NIXwLeexkwV
 BrDcB7OCf8Uw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 15:26:43 -0700
IronPort-SDR: lSsaQZ/Z10+OP2JmbuBbpFWmMm+JGxyRoLyg0rjh8IDtudYVq87/IidO0y1whloGcFnEqct64P
 r7QuGcdiYs/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="260324078"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 15:26:43 -0700
Date:   Wed, 6 May 2020 15:26:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for MPK feature on AMD
Message-ID: <20200506222643.GL3329@linux.intel.com>
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
 <158880254122.11615.156420638099504288.stgit@naples-babu.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158880254122.11615.156420638099504288.stgit@naples-babu.amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 05:02:21PM -0500, Babu Moger wrote:
>  static __init int svm_hardware_setup(void)
> @@ -1300,6 +1304,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		indirect_branch_prediction_barrier();
>  	}
>  	avic_vcpu_load(vcpu, cpu);
> +
> +	svm->host_pkru = read_pkru();

Move vcpu_vmx's host_prku to kvm_vcpu_arch instead of duplicating it to
SVM.  And I'm 99% certain "vcpu->arch.host_pkru = read_pkru()" can be moved
to kvm_arch_vcpu_load().  The only direct calls to vmx_vcpu_load() are to
get the right VMCS loaded.  Actually, those calls shouldn't be using
vmx_vcpu_load(), especially since that'll trigger IBPB.  I'll send a patch
for that.

>  }
>  
>  static void svm_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -3318,6 +3324,12 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	clgi();
>  	kvm_load_guest_xsave_state(vcpu);
>  
> +	/* Load the guest pkru state */
> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> +	    vcpu->arch.pkru != svm->host_pkru)
> +		__write_pkru(vcpu->arch.pkru);

This and the restoration should be moved to common x86 helpers, at a glance
they look identical.

In short, pretty much all of this belongs in common x86.

> +
>  	if (lapic_in_kernel(vcpu) &&
>  		vcpu->arch.apic->lapic_timer.timer_advance_ns)
>  		kvm_wait_lapic_expire(vcpu);
> @@ -3371,6 +3383,14 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>  		kvm_before_interrupt(&svm->vcpu);
>  
> +	/* Save the guest pkru state and restore the host pkru state back */
> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
> +		vcpu->arch.pkru = rdpkru();
> +		if (vcpu->arch.pkru != svm->host_pkru)
> +			__write_pkru(svm->host_pkru);
> +	}
> +
>  	kvm_load_host_xsave_state(vcpu);
>  	stgi();
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index df3474f4fb02..5d20a28c1b0e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -158,6 +158,8 @@ struct vcpu_svm {
>  	u64 *avic_physical_id_cache;
>  	bool avic_is_running;
>  
> +	u32 host_pkru;
> +
>  	/*
>  	 * Per-vcpu list of struct amd_svm_iommu_ir:
>  	 * This is used mainly to store interrupt remapping information used
> 
