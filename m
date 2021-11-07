Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700AB44727D
	for <lists+kvm@lfdr.de>; Sun,  7 Nov 2021 11:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhKGKRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Nov 2021 05:17:06 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15370 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhKGKRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Nov 2021 05:17:06 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hn97y33Dvz90HZ;
        Sun,  7 Nov 2021 18:14:06 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 7 Nov 2021 18:14:18 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Sun, 7 Nov 2021 18:14:17 +0800
Subject: Re: [PATCH V10 05/18] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
To:     Zhu Lingshan <lingshan.zhu@intel.com>, <like.xu.linux@gmail.com>,
        Like Xu <like.xu@linux.intel.com>, <like.xu.linux@gmail.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-6-lingshan.zhu@intel.com>
CC:     <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kan.liang@linux.intel.com>, <ak@linux.intel.com>,
        <wei.w.wang@intel.com>, <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <boris.ostrvsky@oracle.com>,
        Yao Yuan <yuan.yao@intel.com>,
        "Venkatesh Srinivas" <venkateshs@chromium.org>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <6187A6F9.5030401@huawei.com>
Date:   Sun, 7 Nov 2021 18:14:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210806133802.3528-6-lingshan.zhu@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, like and lingshan.

As said,  IA32_MISC_ENABLE[7] bit depends on the PMU is enabled for the 
guest, so a software
write openration to this bit will be ignored.

But, in this patch, all the openration that writes msr_ia32_misc_enable 
in guest could make this bit become 0.

Suppose:
When we start vm with "enable_pmu", vcpu->arch.ia32_misc_enable_msr may 
be 0x80 first.
And next, guest writes msr_ia32_misc_enable value 0x1.
What we want could be 0x81, but unfortunately, it will be 0x1 because of
"data &= ~MSR_IA32_MISC_ENABLE_EMON;"
And even if guest writes msr_ia32_misc_enable value 0x81, it will be 0x1 
also.


What we want is write operation will not change this bit. So, how about 
this?

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3321,6 +3321,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, 
struct msr_data *msr_info)
          }
          break;
      case MSR_IA32_MISC_ENABLE:
+        data &= ~MSR_IA32_MISC_ENABLE_EMON;
+        data |= (vcpu->arch.ia32_misc_enable_msr & 
MSR_IA32_MISC_ENABLE_EMON);
          if (!kvm_check_has_quirk(vcpu->kvm, 
KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
              ((vcpu->arch.ia32_misc_enable_msr ^ data) & 
MSR_IA32_MISC_ENABLE_MWAIT)) {
              if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))


Or is there anything in your design intention I don't understand?

Thanks!

Xiangdong Liu


On 2021/8/6 21:37, Zhu Lingshan wrote:
> From: Like Xu <like.xu@linux.intel.com>
>
> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
> detect whether the processor supports performance monitoring facility.
>
> It depends on the PMU is enabled for the guest, and a software write
> operation to this available bit will be ignored. The proposal to ignore
> the toggle in KVM is the way to go and that behavior matches bare metal.
>
> Cc: Yao Yuan <yuan.yao@intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 1 +
>   arch/x86/kvm/x86.c           | 1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 9efc1a6b8693..d9dbebe03cae 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	if (!pmu->version)
>   		return;
>   
> +	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
>   	perf_get_x86_pmu_capability(&x86_pmu);
>   
>   	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index efd11702465c..f6b6984e26ef 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3321,6 +3321,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		}
>   		break;
>   	case MSR_IA32_MISC_ENABLE:
> +		data &= ~MSR_IA32_MISC_ENABLE_EMON;
>   		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>   		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
>   			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))

