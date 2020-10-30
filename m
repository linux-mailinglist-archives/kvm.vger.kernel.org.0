Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9805C29FD40
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgJ3FbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:31:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:4687 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgJ3FbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:31:03 -0400
IronPort-SDR: yKRQmXT1xFH7b03VAdj++pPvvCWOehS79nBzOnvYvGCOQ6ETKsyA2xQ327u+OCAHediTPdBS8Q
 jTIrAqh9mK3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="253269999"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="253269999"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:31:03 -0700
IronPort-SDR: YvbuGj2gX9INrl35KZ+dc3E32qH6s1M+ouO68tNoPGNkv5PgBTU1mTjp4KyHdA4xVQLl8g+uJo
 6iMCGf5fWt1w==
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="536945186"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:31:00 -0700
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON when vPMU
 is enabled
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201020145755.122333-1-like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <144cc653-c575-24c4-fcee-1568d09cf8eb@linux.intel.com>
Date:   Fri, 30 Oct 2020 13:30:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201020145755.122333-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Is the community not interested in these two patches?
The second one also appears in the LBR patch set and
will benefit other PMU features later, such as PEBS.

Thanks,
Like Xu

On 2020/10/20 22:57, Like Xu wrote:
> On Intel platforms, software may uses IA32_MISC_ENABLE[7]
> bit to detect whether the performance monitoring facility
> is supported in the processor.
> 
> A write to this PMU available bit will be ignored.
> 
> Cc: Yao Yuan <yuan.yao@intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 2 ++
>   arch/x86/kvm/x86.c           | 1 +
>   2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index a886a47daebd..01c7d84ecf3e 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -339,6 +339,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	if (!pmu->version)
>   		return;
>   
> +	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
> +
>   	perf_get_x86_pmu_capability(&x86_pmu);
>   	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
>   		vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c4015a43cc8a..d7b8f98ada93 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3042,6 +3042,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		}
>   		break;
>   	case MSR_IA32_MISC_ENABLE:
> +		data &= ~MSR_IA32_MISC_ENABLE_EMON;
>   		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>   		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
>   			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> 

