Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768F51EDA7D
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 03:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFDBiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 21:38:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:4723 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgFDBiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 21:38:03 -0400
IronPort-SDR: 0sfn51z1d00TTxQzzn4LdWSRJ1ohEjiugFl9PNKdC8GcWtrXiU5TWjP11/otemPeh0C3qI+lWp
 IV3Pgf6+hEaA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 18:38:02 -0700
IronPort-SDR: lB7F4LxmOVSL9m3TUe7alqnZZrD+XqL+JrOUcbzmt6D7eq+inSMjzfzzUl2/2tseDdOz/ELHhD
 HhBh2D4gKzOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,470,1583222400"; 
   d="scan'208";a="416751073"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2020 18:38:00 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: VMX: Always treat MSR_IA32_PERF_CAPABILITIES as a
 valid PMU MSR
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20200603203303.28545-1-sean.j.christopherson@intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <46f57aa8-e278-b4fd-7ac8-523836308051@intel.com>
Date:   Thu, 4 Jun 2020 09:37:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200603203303.28545-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/6/4 4:33, Sean Christopherson wrote:
> Unconditionally return true when querying the validity of
> MSR_IA32_PERF_CAPABILITIES so as to defer the validity check to
> intel_pmu_{get,set}_msr(), which can properly give the MSR a pass when
> the access is initiated from host userspace.
Regardless of  the MSR is emulated or not, is it a really good assumption that
the guest cpuids are not properly ready when we do initialization from host 
userspace
?
> The MSR is emulated so
> there is no underlying hardware dependency to worry about.
>
> Fixes: 27461da31089a ("KVM: x86/pmu: Support full width counting")
> Cc: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> KVM selftests are completely hosed for me, everything fails on KVM_GET_MSRS.
At least I tried "make --silent -C tools/testing/selftests/kvm run_tests"
and how do I reproduce the "everything fails" for this issue ?

Thanks,
Like Xu
>
>   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index d33d890b605f..bdcce65c7a1d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -181,7 +181,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   		ret = pmu->version > 1;
>   		break;
>   	case MSR_IA32_PERF_CAPABILITIES:
> -		ret = guest_cpuid_has(vcpu, X86_FEATURE_PDCM);
> +		ret = 1;
>   		break;
>   	default:
>   		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||

