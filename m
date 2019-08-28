Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72796A099B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 20:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfH1SfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 14:35:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:7081 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbfH1SfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 14:35:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 11:35:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="197623038"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 28 Aug 2019 11:35:23 -0700
Date:   Wed, 28 Aug 2019 11:35:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: x86: make exception_class() and
 exception_type() globally visible
Message-ID: <20190828183523.GC21651@linux.intel.com>
References: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <1567011759-9969-3-git-send-email-jan.dakinevich@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567011759-9969-3-git-send-email-jan.dakinevich@virtuozzo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 05:02:57PM +0000, Jan Dakinevich wrote:
> exception_type() function was moved for upcoming sanity check in
> emulation code. exceptions_class() function is not supposed to be used
> right now, but it was moved as well to keep things together.

Doh, I didn't realize exception_type() was confined to x86.c when I
suggested the sanity check.  It'd probably be better to add the check
in x86_emulate_instruction and forego this patch, e.g.:

	if (ctxt->have_exception) {
		WARN_ON_ONCE(...);
		inject_emulated_exception(vcpu));
		return EMULATE_DONE;
	}

Arguably we shouldn't WARN on an unexpected vector until we actually try
to inject it anyways.

Sorry for the thrash.

> 
> Cc: Denis Lunev <den@virtuozzo.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  arch/x86/kvm/x86.c | 46 ----------------------------------------------
>  arch/x86/kvm/x86.h | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 903fb7c..2b69ae0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -364,52 +364,6 @@ asmlinkage __visible void kvm_spurious_fault(void)
>  }
>  EXPORT_SYMBOL_GPL(kvm_spurious_fault);
>  
> -#define EXCPT_BENIGN		0
> -#define EXCPT_CONTRIBUTORY	1
> -#define EXCPT_PF		2
> -
> -static int exception_class(int vector)
> -{
> -	switch (vector) {
> -	case PF_VECTOR:
> -		return EXCPT_PF;
> -	case DE_VECTOR:
> -	case TS_VECTOR:
> -	case NP_VECTOR:
> -	case SS_VECTOR:
> -	case GP_VECTOR:
> -		return EXCPT_CONTRIBUTORY;
> -	default:
> -		break;
> -	}
> -	return EXCPT_BENIGN;
> -}
> -
> -#define EXCPT_FAULT		0
> -#define EXCPT_TRAP		1
> -#define EXCPT_ABORT		2
> -#define EXCPT_INTERRUPT		3
> -
> -static int exception_type(int vector)
> -{
> -	unsigned int mask;
> -
> -	if (WARN_ON(vector > 31 || vector == NMI_VECTOR))
> -		return EXCPT_INTERRUPT;
> -
> -	mask = 1 << vector;
> -
> -	/* #DB is trap, as instruction watchpoints are handled elsewhere */
> -	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
> -		return EXCPT_TRAP;
> -
> -	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
> -		return EXCPT_ABORT;
> -
> -	/* Reserved exceptions will result in fault */
> -	return EXCPT_FAULT;
> -}
> -
>  void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
>  {
>  	unsigned nr = vcpu->arch.exception.nr;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index b5274e2..2b66347 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -369,4 +369,50 @@ static inline bool kvm_pat_valid(u64 data)
>  void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
>  void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
>  
> +#define EXCPT_BENIGN		0
> +#define EXCPT_CONTRIBUTORY	1
> +#define EXCPT_PF		2
> +
> +static inline int exception_class(int vector)
> +{
> +	switch (vector) {
> +	case PF_VECTOR:
> +		return EXCPT_PF;
> +	case DE_VECTOR:
> +	case TS_VECTOR:
> +	case NP_VECTOR:
> +	case SS_VECTOR:
> +	case GP_VECTOR:
> +		return EXCPT_CONTRIBUTORY;
> +	default:
> +		break;
> +	}
> +	return EXCPT_BENIGN;
> +}
> +
> +#define EXCPT_FAULT		0
> +#define EXCPT_TRAP		1
> +#define EXCPT_ABORT		2
> +#define EXCPT_INTERRUPT		3
> +
> +static inline int exception_type(int vector)
> +{
> +	unsigned int mask;
> +
> +	if (WARN_ON(vector > 31 || vector == NMI_VECTOR))
> +		return EXCPT_INTERRUPT;
> +
> +	mask = 1 << vector;
> +
> +	/* #DB is trap, as instruction watchpoints are handled elsewhere */
> +	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
> +		return EXCPT_TRAP;
> +
> +	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
> +		return EXCPT_ABORT;
> +
> +	/* Reserved exceptions will result in fault */
> +	return EXCPT_FAULT;
> +}
> +
>  #endif
> -- 
> 2.1.4
> 
