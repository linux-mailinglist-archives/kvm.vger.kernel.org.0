Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364A4E8B70
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 16:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389797AbfJ2PFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 11:05:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41264 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389520AbfJ2PFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 11:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=C3/5hrWsTa753nXHbDeBpwL/5p3fDxv/KfRS69GxIR0=; b=h1MeFf88lqAmEG4nDZ0T/g5pM
        Izw1QFBM2I7r/eLGPpAmndvLMBkXVfYCD1/7QGvpK6WsR1fBb6QsM1MvTmJl3ZQMCoBbYtk8r/F/x
        1yooJf12EHT2cKOQGNHbp8dEG/U0lW0sqFEr3gYFK3YewGVBivSyswJ0ShPneiluuHSiSzEudYGDt
        fGCsEJ0QG3u4LVV08iaVv7firRixHI3Fs/Hftms7azTP9chorAJT7Jsy3xLHoTTA6x2FtPyYuvRTK
        qQ6rvCDIDqyVkNF8MagqZqgQjqHPOhQeu1xzBVZy850QvvDlhWoWEFuNBv9NmXULLzqGq5GY8HI8I
        NUpNuxwpQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPT3s-00058V-RG; Tue, 29 Oct 2019 15:05:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 54847300E4D;
        Tue, 29 Oct 2019 16:04:30 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1CB0E2B43836E; Tue, 29 Oct 2019 16:05:31 +0100 (CET)
Date:   Tue, 29 Oct 2019 16:05:31 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org
Subject: Re: [PATCH v1 7/8] KVM: x86: Expose PEBS feature to guest
Message-ID: <20191029150531.GN4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-8-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572217877-26484-8-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 27, 2019 at 07:11:16PM -0400, Luwei Kang wrote:
> Expose PEBS feature to guest by IA32_MISC_ENABLE[bit12].
> IA32_MISC_ENABLE[bit12] is Processor Event Based Sampling (PEBS)
> Unavailable (RO) flag:
> 1 = PEBS is not supported; 0 = PEBS is supported.

Why does it make sense to expose this on SVM?

> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm.c              |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c          |  1 +
>  arch/x86/kvm/x86.c              | 22 +++++++++++++++++-----
>  4 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 24a0ab9..76f5fa5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1127,6 +1127,7 @@ struct kvm_x86_ops {
>  	bool (*xsaves_supported)(void);
>  	bool (*umip_emulated)(void);
>  	bool (*pt_supported)(void);
> +	bool (*pebs_supported)(void);
>  	bool (*pdcm_supported)(void);
>  
>  	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7e0a7b3..3a1bbb3 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5975,6 +5975,11 @@ static bool svm_pt_supported(void)
>  	return false;
>  }
>  
> +static bool svm_pebs_supported(void)
> +{
> +	return false;
> +}
> +
>  static bool svm_pdcm_supported(void)
>  {
>  	return false;
> @@ -7277,6 +7282,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  	.xsaves_supported = svm_xsaves_supported,
>  	.umip_emulated = svm_umip_emulated,
>  	.pt_supported = svm_pt_supported,
> +	.pebs_supported = svm_pebs_supported,
>  	.pdcm_supported = svm_pdcm_supported,
>  
>  	.set_supported_cpuid = svm_set_supported_cpuid,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5c4dd05..3c370a3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7879,6 +7879,7 @@ static __exit void hardware_unsetup(void)
>  	.xsaves_supported = vmx_xsaves_supported,
>  	.umip_emulated = vmx_umip_emulated,
>  	.pt_supported = vmx_pt_supported,
> +	.pebs_supported = vmx_pebs_supported,
>  	.pdcm_supported = vmx_pdcm_supported,
>  
>  	.request_immediate_exit = vmx_request_immediate_exit,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf..5f59073 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2591,6 +2591,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	bool pr = false;
> +	bool update_cpuid = false;
>  	u32 msr = msr_info->index;
>  	u64 data = msr_info->data;
>  
> @@ -2671,11 +2672,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
>  			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>  				return 1;
> -			vcpu->arch.ia32_misc_enable_msr = data;
> -			kvm_update_cpuid(vcpu);
> -		} else {
> -			vcpu->arch.ia32_misc_enable_msr = data;
> +			update_cpuid = true;
>  		}
> +
> +		if (kvm_x86_ops->pebs_supported())
> +			data &=  ~MSR_IA32_MISC_ENABLE_PEBS;

whitespace damage

> +		else
> +			data |= MSR_IA32_MISC_ENABLE_PEBS;
> +
> +		vcpu->arch.ia32_misc_enable_msr = data;
> +		if (update_cpuid)
> +			kvm_update_cpuid(vcpu);
>  		break;
>  	case MSR_IA32_SMBASE:
>  		if (!msr_info->host_initiated)
> @@ -2971,7 +2978,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = (u64)vcpu->arch.ia32_tsc_adjust_msr;
>  		break;
>  	case MSR_IA32_MISC_ENABLE:
> -		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
> +		if (kvm_x86_ops->pebs_supported())
> +			msr_info->data = (vcpu->arch.ia32_misc_enable_msr &
> +						~MSR_IA32_MISC_ENABLE_PEBS);
> +		else
> +			msr_info->data = (vcpu->arch.ia32_misc_enable_msr |
> +						MSR_IA32_MISC_ENABLE_PEBS);

Coding style violation.

>  		break;
>  	case MSR_IA32_SMBASE:
>  		if (!msr_info->host_initiated)
> -- 
> 1.8.3.1
> 
