Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6942F7492
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 09:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbhAOItW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 03:49:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:38651 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbhAOItV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 03:49:21 -0500
IronPort-SDR: 1yQsMf2+rXVk2nhEDkx6zpgh2NlnhfG/5QZhhi7/ny8fT+0mWZ6AGXsrqhTV7nVqAMZpkeKe9O
 C8F8YiU16Tpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="178606984"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="178606984"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 00:47:32 -0800
IronPort-SDR: SHjVl41aTEVTO4rZxJx/ZKZScPvojw/NwJWqsSTros8GW98FNsywtZOvvFgy+0mGkf33kx9IhG
 cctqxceHsKRg==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382590373"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 00:47:29 -0800
Subject: Re: [PATCH] KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in
 intel_pmu_refresh()
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     syzkaller-bugs@googlegroups.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
References: <20201229071144.85418-1-like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <fb60e9b1-0d96-a1a7-1828-80d6e2c21e0c@linux.intel.com>
Date:   Fri, 15 Jan 2021 16:47:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20201229071144.85418-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping ?

On 2020/12/29 15:11, Like Xu wrote:
> Since we know vPMU will not work properly when the guest bit_width(s) of
> the [gp|fixed] counters are greater than the host ones, so we can setup a
> smaller left shift value and refresh the guest pmu cpuid entry, thus fixing
> the following UBSAN shift-out-of-bounds warning:
>
> shift exponent 197 is too large for 64-bit type 'long long unsigned int'
>
> Call Trace:
>   __dump_stack lib/dump_stack.c:79 [inline]
>   dump_stack+0x107/0x163 lib/dump_stack.c:120
>   ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>   __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
>   intel_pmu_refresh.cold+0x75/0x99 arch/x86/kvm/vmx/pmu_intel.c:348
>   kvm_vcpu_after_set_cpuid+0x65a/0xf80 arch/x86/kvm/cpuid.c:177
>   kvm_vcpu_ioctl_set_cpuid2+0x160/0x440 arch/x86/kvm/cpuid.c:308
>   kvm_arch_vcpu_ioctl+0x11b6/0x2d70 arch/x86/kvm/x86.c:4709
>   kvm_vcpu_ioctl+0x7b9/0xdb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3386
>   vfs_ioctl fs/ioctl.c:48 [inline]
>   __do_sys_ioctl fs/ioctl.c:753 [inline]
>   __se_sys_ioctl fs/ioctl.c:739 [inline]
>   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Reported-by: syzbot+ae488dc136a4cc6ba32b@syzkaller.appspotmail.com
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index a886a47daebd..a86a1690e75c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -345,6 +345,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   
>   	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
>   					 x86_pmu.num_counters_gp);
> +	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
>   	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
>   	pmu->available_event_types = ~entry->ebx &
>   					((1ull << eax.split.mask_length) - 1);
> @@ -355,6 +356,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   		pmu->nr_arch_fixed_counters =
>   			min_t(int, edx.split.num_counters_fixed,
>   			      x86_pmu.num_counters_fixed);
> +		edx.split.bit_width_fixed = min_t(int,
> +			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
>   		pmu->counter_bitmask[KVM_PMC_FIXED] =
>   			((u64)1 << edx.split.bit_width_fixed) - 1;
>   	}

