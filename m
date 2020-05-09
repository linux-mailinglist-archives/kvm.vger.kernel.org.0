Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE151CBC50
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 04:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgEICJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 22:09:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:33908 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEICJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 22:09:05 -0400
IronPort-SDR: NKl/ZAJt6k7ReUlFGvO0G1vNZgiYXSX6vVOlnEaVkLLKZyIQ5UDSy0xcRGN6LHO7ayaRIME+/f
 K55U0N2KfBOw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 19:09:04 -0700
IronPort-SDR: vZwu+/4YRX+uiHbp3aN/4S1dVUxQozEGbco1o2G1Igj89F1KGrw0cQfKn6vGCXqa29I4AUra1i
 M8/fcm72cdYA==
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="435987332"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 19:09:02 -0700
Subject: Re: [PATCH] KVM: x86: Restore update of required xstate size in
 guest's CPUID
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200508233749.3417-1-sean.j.christopherson@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <dd7bfdb9-dcad-8a4b-29bb-c48d4c98b515@intel.com>
Date:   Sat, 9 May 2020 10:09:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508233749.3417-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/2020 7:37 AM, Sean Christopherson wrote:
> Restore a guest CPUID update that was unintentional collateral damage
> when the per-vCPU guest_xstate_size field was removed.

It's really unintentional. None of us noticed it. :(

It's good that you catch it!

> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Fixes: d87277414b851 ("kvm: x86: Cleanup vcpu->arch.guest_xstate_size")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> There's nothing more thrilling than watching bisect home in on your own
> commits, only to land on someone else's on the very last step.
> 
>   arch/x86/kvm/cpuid.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 35845704cf57a..cd708b0b460a0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -84,11 +84,13 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>   				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
>   
>   	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
> -	if (!best)
> +	if (!best) {
>   		vcpu->arch.guest_supported_xcr0 = 0;
> -	else
> +	} else {
>   		vcpu->arch.guest_supported_xcr0 =
>   			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
> +		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
> +	}
>   
>   	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> 

