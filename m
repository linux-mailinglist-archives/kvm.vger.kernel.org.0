Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8232918C91D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 09:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCTIpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 04:45:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:58600 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgCTIpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 04:45:50 -0400
IronPort-SDR: 9XomDNd3tMdpymeRrO3qxFPjGAiC0z++Pf0VKWhQfaaStLk6WKy0NQqamaer79CE1kiTInL2Nr
 IZ/VBS5NzuPA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 01:45:50 -0700
IronPort-SDR: 5T1C30mSaU7qaOolo5XckRkhJ0nDDnwxM5w043asqU1T28Dx/O+hHzy8nXj9/WQxzzBKTL2RyQ
 DvkYL+e6IhAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="446590259"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.82]) ([10.238.4.82])
  by fmsmga006.fm.intel.com with ESMTP; 20 Mar 2020 01:45:46 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v9 00/10] Guest Last Branch Recording Enabling
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <446eef98-4d9f-4a9b-bdae-d29e36f6e07e@intel.com>
Date:   Fri, 20 Mar 2020 16:45:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,
any comments on the host perf changes?

Hi Paolo,
any comments on the kvm changes? Isn't this feature interesting to you?

Just kindly ping.

Thanks,
Like Xu

On 2020/3/13 10:16, Like Xu wrote:
> Hi all,
>
> Please help review your interesting parts in this stable version,
> e.g. the first four patches involve the perf event subsystem
> and the fifth patch concerns the KVM userspace interface.

> v8->v9 Changelog:
> - using guest_lbr_constraint to create guest LBR event without hw counter;
>    (please check perf changes in patch 0003)
> - rename 'cpuc->vcpu_lbr' to 'cpuc->guest_lbr_enabled';
>    (please check host LBR changes in patch 0004)
> - replace 'pmu->lbr_used' mechanism with lazy release kvm_pmu_lbr_cleanup();
> - refactor IA32_PERF_CAPABILITIES trap via get_perf_capabilities();
> - refactor kvm_pmu_lbr_enable() with kvm_pmu_lbr_setup();
> - simplify model-specific LBR functionality check;
> - rename x86_perf_get_lbr_stack to x86_perf_get_lbr;
> - rename intel_pmu_lbr_confirm() to kvm_pmu_availability_check();
>
> Previous:
> https://lore.kernel.org/lkml/1565075774-26671-1-git-send-email-wei.w.wang@intel.com/
>
> Like Xu (7):
>    perf/x86/lbr: Add interface to get basic information about LBR stack
>    perf/x86: Add constraint to create guest LBR event without hw counter
>    perf/x86: Keep LBR stack unchanged on the host for guest LBR event
>    KVM: x86: Add KVM_CAP_X86_GUEST_LBR interface to dis/enable LBR
>      feature
>    KVM: x86/pmu: Add LBR feature emulation via guest LBR event
>    KVM: x86/pmu: Release guest LBR event via vPMU lazy release mechanism
>    KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES to guest for LBR record
>      format
>
> Wei Wang (3):
>    perf/x86: Fix msr variable type for the LBR msrs
>    KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in
>    KVM: x86: Remove the common trap handler of the MSR_IA32_DEBUGCTLMSR
>
>   Documentation/virt/kvm/api.rst    |  28 +++
>   arch/x86/events/core.c            |   9 +-
>   arch/x86/events/intel/core.c      |  29 +++
>   arch/x86/events/intel/lbr.c       |  55 +++++-
>   arch/x86/events/perf_event.h      |  21 ++-
>   arch/x86/include/asm/kvm_host.h   |   7 +
>   arch/x86/include/asm/perf_event.h |  24 ++-
>   arch/x86/kvm/cpuid.c              |   3 +-
>   arch/x86/kvm/pmu.c                |  28 ++-
>   arch/x86/kvm/pmu.h                |  26 ++-
>   arch/x86/kvm/pmu_amd.c            |   7 +-
>   arch/x86/kvm/vmx/pmu_intel.c      | 291 ++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/vmx.c            |   4 +-
>   arch/x86/kvm/vmx/vmx.h            |   2 +
>   arch/x86/kvm/x86.c                |  42 +++--
>   include/linux/perf_event.h        |   7 +
>   include/uapi/linux/kvm.h          |   1 +
>   kernel/events/core.c              |   7 -
>   tools/include/uapi/linux/kvm.h    |   1 +
>   19 files changed, 540 insertions(+), 52 deletions(-)
>

