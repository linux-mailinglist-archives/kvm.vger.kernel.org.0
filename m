Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A2F1BF08D
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 08:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgD3Gt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 02:49:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:47294 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3Gt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 02:49:29 -0400
IronPort-SDR: 1bFkaxWvZXU8bvar9uxrx78bh4t2ASTXZQ72ZkWCjqYTtbonQp4LBODjMwj5KX3dOUmrrxhXsf
 YHt8FdxRhz0Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 23:49:28 -0700
IronPort-SDR: 9kL5j0T1nObJTAxCY6tYRK1s8mnbRHniBzznHbeT4Q0gj5aVkDCyiMBIpCiSZXctQg9u06FfpV
 kAR6ai7G9o7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,334,1583222400"; 
   d="scan'208";a="337203357"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga001.jf.intel.com with ESMTP; 29 Apr 2020 23:49:25 -0700
Subject: Re: [PATCH][v2] kvm: x86: emulate APERF/MPERF registers
To:     Li RongQing <lirongqing@baidu.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, joro@8bytes.org,
        jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, pbonzini@redhat.com
References: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <5aa01c91-b874-fd4f-a1fb-1d008753ca84@intel.com>
Date:   Thu, 30 Apr 2020 14:49:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/2020 1:46 PM, Li RongQing wrote:
> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
> this is confused to user when turbo is enable, and aperf/mperf
> can be used to show current cpu frequency after 7d5905dc14a
> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
> so we should emulate aperf mperf to achieve it
> 
> the period of aperf/mperf in guest mode are accumulated as
> emulated value, and add per-VM knod to enable emulate mperfaperf
> 
> diff v1:
> 1. support AMD
> 2. support per-vm capability to enable
> 
[...]
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 851e9cc79930..1d157a8dba46 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4310,6 +4310,12 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_F10H_DECFG:
>   		msr_info->data = svm->msr_decfg;
>   		break;
> +	case MSR_IA32_MPERF:
> +		msr_info->data = vcpu->arch.v_mperf;
> +		break;
> +	case MSR_IA32_APERF:
> +		msr_info->data = vcpu->arch.v_aperf;
> +		break;
>   	default:
>   		return kvm_get_msr_common(vcpu, msr_info);
>   	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 91749f1254e8..b05e276e262b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1914,6 +1914,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>   			return 1;
>   		goto find_shared_msr;
> +	case MSR_IA32_MPERF:
> +		msr_info->data = vcpu->arch.v_mperf;
> +		break;
> +	case MSR_IA32_APERF:
> +		msr_info->data = vcpu->arch.v_aperf;
> +		break;

They are same for both vmx and svm, you can put them in kvm_get_msr_common()

BTW, are those two MSR always readable regardless of guest's CPUID?

>   	default:
>   	find_shared_msr:
>   		msr = find_msr_entry(vmx, msr_info->index);


