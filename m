Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3058B1E3BED
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgE0I2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:28:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:64097 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgE0I2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:28:18 -0400
IronPort-SDR: NHxQ3X4VTBwiGXTUPciSsudrAVti+de4L9IsrWWLPQUeTsZcJ6Mqe2Zgpm9M+n2xmZ8nmn7jHR
 AWpCag5Ho8eQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 01:28:18 -0700
IronPort-SDR: BPuFDtUAXFOhySWlK+3vXLr86xoGMOJzINr6rvv+xvydIz+8LVAPPyR5NkGL22c9cp1p0NzCYZ
 z9iU6/C4GT/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="302386909"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by orsmga008.jf.intel.com with ESMTP; 27 May 2020 01:28:14 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 00/11] Guest Last Branch Recording Enabling
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
References: <20200514083054.62538-1-like.xu@linux.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <810b0c63-ee8f-169b-d2a3-85feca5a9f22@intel.com>
Date:   Wed, 27 May 2020 16:28:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514083054.62538-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2020/5/14 16:30, Like Xu wrote:
> Hi Peter,
> Would you mind acking the host perf patches if it looks good to you ?
>
> Hi Paolo,
> Please help review the KVM proposal changes in this stable version.
>
> Now, we can use upstream QEMU w/ '-cpu host' to test this feature, and
> disable it by clearing the LBR format bits in the IA32_PERF_CAPABILITIES.
>
> v10->v11 Changelog:
> - add '.config = INTEL_FIXED_VLBR_EVENT' to the guest LBR event config;
> - rewrite is_guest_lbr_event() with 'config == INTEL_FIXED_VLBR_EVENT';
> - emit pr_warn() on the host when guest LBR is temporarily unavailable;
> - drop the KVM_CAP_X86_GUEST_LBR patch;
> - rewrite MSR_IA32_PERF_CAPABILITIES patch LBR record format;
> - split 'kvm_pmu->lbr_already_available' into a separate patch;
> - split 'pmu_ops->availability_check' into a separate patch;
> - comments and naming refinement, misc;
>
> You may check more details in each commit.
>
> Previous:
> https://lore.kernel.org/kvm/20200423081412.164863-1-like.xu@linux.intel.com/
...
>
> Like Xu (9):
>    perf/x86/core: Refactor hw->idx checks and cleanup
>    perf/x86/lbr: Add interface to get basic information about LBR stack
>    perf/x86: Add constraint to create guest LBR event without hw counter
>    perf/x86: Keep LBR stack unchanged in host context for guest LBR event
Do you have a moment to review the KVM changes in this version
to enable guest LBR on most Intel platforms ?

It would be great if I can address most of your comments in the next version.

Thanks,
Like Xu
>    KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES for LBR record format
>    KVM: x86/pmu: Emulate LBR feature via guest LBR event
>    KVM: x86/pmu: Release guest LBR event via vPMU lazy release mechanism
>    KVM: x86/pmu: Check guest LBR availability in case host reclaims them
>    KVM: x86/pmu: Reduce the overhead of LBR passthrough or cancellation
>
> Wei Wang (2):
>    perf/x86: Fix variable types for LBR registers
>    KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in
>
>   arch/x86/events/core.c            |  26 ++-
>   arch/x86/events/intel/core.c      | 105 ++++++----
>   arch/x86/events/intel/lbr.c       |  56 +++++-
>   arch/x86/events/perf_event.h      |  12 +-
>   arch/x86/include/asm/kvm_host.h   |  13 ++
>   arch/x86/include/asm/perf_event.h |  34 +++-
>   arch/x86/kvm/cpuid.c              |   2 +-
>   arch/x86/kvm/pmu.c                |  19 +-
>   arch/x86/kvm/pmu.h                |  15 +-
>   arch/x86/kvm/svm/pmu.c            |   7 +-
>   arch/x86/kvm/vmx/capabilities.h   |  15 ++
>   arch/x86/kvm/vmx/pmu_intel.c      | 320 +++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.c            |  12 +-
>   arch/x86/kvm/vmx/vmx.h            |   2 +
>   arch/x86/kvm/x86.c                |  18 +-
>   15 files changed, 564 insertions(+), 92 deletions(-)
>

