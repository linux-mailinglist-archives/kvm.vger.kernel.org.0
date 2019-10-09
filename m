Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714E9D054D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 03:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfJIBka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 21:40:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:29609 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbfJIBka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 21:40:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 18:40:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="193544050"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 08 Oct 2019 18:40:28 -0700
Date:   Wed, 9 Oct 2019 09:42:26 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [Patch 4/6] kvm: svm: Enumerate XSAVES in guest CPUID when it is
 available to the guest
Message-ID: <20191009014226.GA27134@local-michael-cet-test>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009004142.225377-4-aaronlewis@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 08, 2019 at 05:41:40PM -0700, Aaron Lewis wrote:
> Add the function guest_cpuid_set() to allow a bit in the guest cpuid to
> be set.  This is complementary to the guest_cpuid_clear() function.
> 
> Also, set the XSAVES bit in the guest cpuid if the host has the same bit
> set and guest has XSAVE bit set.  This is to ensure that XSAVES will be
> enumerated in the guest CPUID if XSAVES can be used in the guest.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/cpuid.h | 9 +++++++++
>  arch/x86/kvm/svm.c   | 4 ++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index d78a61408243..420ceea02fd1 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -113,6 +113,15 @@ static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x8
>  		*reg &= ~bit(x86_feature);
>  }
>  
> +static __always_inline void guest_cpuid_set(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +{
> +	int *reg;
> +
> +	reg = guest_cpuid_get_register(vcpu, x86_feature);
> +	if (reg)
> +		*reg |= ~bit(x86_feature);
> +}
> +
Sounds like it's to set the bit, is it: *reg |= bit(x86_feature)?
>  static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 65223827c675..2522a467bbc0 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5887,6 +5887,10 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> +	    boot_cpu_has(X86_FEATURE_XSAVES))
> +		guest_cpuid_set(vcpu, X86_FEATURE_XSAVES);
> +
>  	/* Update nrips enabled cache */
>  	svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
>  
> -- 
> 2.23.0.581.g78d2f28ef7-goog
