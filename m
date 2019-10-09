Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D065AD078A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJIGoa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 9 Oct 2019 02:44:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50236 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIGoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 02:44:30 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iI5hx-0006Nx-RK; Wed, 09 Oct 2019 08:44:25 +0200
Date:   Wed, 9 Oct 2019 08:44:25 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
Message-ID: <20191009064425.mxxiegsyr7ugiqum@linutronix.de>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191009004142.225377-3-aaronlewis@google.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-10-08 17:41:39 [-0700], Aaron Lewis wrote:
> Hoist support for IA32_XSS so it can be used for both AMD and Intel,

Hoist

> instead of for just Intel.
> 
> AMD has no equivalent of Intel's "Enable XSAVES/XRSTORS" VM-execution
> control. Instead, XSAVES is always available to the guest when supported
> on the host.

You could add that implement the XSAVES check based on host's features
and move the MSR_IA32_XSS msr R/W from Intel only code to the common
code.

…
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e90e658fd8a9..77f2e8c05047 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2702,6 +2702,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_TSC:
>  		kvm_write_tsc(vcpu, msr_info);
>  		break;
> +	case MSR_IA32_XSS:
> +		if (!kvm_x86_ops->xsaves_supported() ||
> +		    (!msr_info->host_initiated &&
> +		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
> +			return 1;

I wouldn't ditch the comment. You could explain why only zero is allowed
to be written. The Skylake is not true for both but this probably
requires an explanation.

> +		if (data != 0)
> +			return 1;
> +		vcpu->arch.ia32_xss = data;
> +		break;
>  	case MSR_SMI_COUNT:
>  		if (!msr_info->host_initiated)
>  			return 1;
