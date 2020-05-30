Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE57F1E909A
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 12:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgE3KkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 06:40:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:3468 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgE3KkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 06:40:20 -0400
IronPort-SDR: CqtWu+38znZlrYi1rY1GZzjko+Em+vWCyIdjqOOEnGNmsuMGe3bcK8z1/45k+RtIxbvN2Z1fbm
 o043oqMXLOBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2020 03:40:20 -0700
IronPort-SDR: 8D9REyJVuH8h9Dmzz8hoWB5VNZVrD5uv/pVK5BigyLsRjeRL0U/hh+KcSAOhE74//aeb2QhtfM
 60DDOxTM0eOg==
X-IronPort-AV: E=Sophos;i="5.73,451,1583222400"; 
   d="scan'208";a="443709424"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.205]) ([10.249.168.205])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2020 03:40:16 -0700
Subject: Re: [PATCH][v5] KVM: X86: support APERF/MPERF registers
To:     Li RongQing <lirongqing@baidu.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, jmattson@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        wei.huang2@amd.com
References: <1590813353-11775-1-git-send-email-lirongqing@baidu.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <3f931ecf-7f1c-c178-d18c-46beadd1d313@intel.com>
Date:   Sat, 30 May 2020 18:40:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <1590813353-11775-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/2020 12:35 PM, Li RongQing wrote:
> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
> this is confused to user when turbo is enable, and aperf/mperf
> can be used to show current cpu frequency after 7d5905dc14a
> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
> so guest should support aperf/mperf capability
> 
> This patch implements aperf/mperf by three mode: none, software
> emulation, and pass-through
> 
> None: default mode, guest does not support aperf/mperf
> 
> Software emulation: the period of aperf/mperf in guest mode are
> accumulated as emulated value
> 
> Pass-though: it is only suitable for KVM_HINTS_REALTIME, Because
> that hint guarantees we have a 1:1 vCPU:CPU binding and guaranteed
> no over-commit.
> 
> And a per-VM capability is added to configure aperfmperf mode
> 

[...]

> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index cd708b0b460a..c960dda4251b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -122,6 +122,14 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>   					   MSR_IA32_MISC_ENABLE_MWAIT);
>   	}
>   
> +	best = kvm_find_cpuid_entry(vcpu, 6, 0);
> +	if (best) {
> +		if (guest_has_aperfmperf(vcpu->kvm) &&
> +			boot_cpu_has(X86_FEATURE_APERFMPERF))
> +			best->ecx |= 1;
> +		else
> +			best->ecx &= ~1;
> +	}

In my understanding, KVM allows userspace to set a CPUID feature bit for 
guest even if hardware doesn't support the feature.

So what makes X86_FEATURE_APERFMPERF different here? Is there any 
concern I miss?

-Xiaoyao

>   	/* Note, maxphyaddr must be updated before tdp_level. */
>   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>   	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
