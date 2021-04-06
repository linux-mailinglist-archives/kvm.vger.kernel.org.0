Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E7C354B29
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 05:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243544AbhDFDTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 23:19:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:52793 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243540AbhDFDTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 23:19:51 -0400
IronPort-SDR: N+i8Aakfc9G/kr+dX+zRs7uz9TfIVzTtaBZCXrtPgZ+XkGDJCUUEy8Hut5LSxwCqO1zfWx1GhD
 DWOllQbGaHAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="190798965"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="190798965"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 20:19:43 -0700
IronPort-SDR: h22GGbqxnoL0TkLIntPMbQn0E8HGZmwifqpqJ55zX5XEQfpaysiRYKJaJNrWG0Loqo5u6DEj/a
 Gw3+25lo34tQ==
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="421005713"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 20:19:40 -0700
Subject: Re: [PATCH v4 00/11] KVM: x86/pmu: Guest Architectural LBR Enabling
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210314155225.206661-1-like.xu@linux.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <8ab9709f-a866-a73e-2d78-70a0c17763be@intel.com>
Date:   Tue, 6 Apr 2021 11:19:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210314155225.206661-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all, do we have any comments on this patch set?

On 2021/3/14 23:52, Like Xu wrote:
> Hi geniuses,
>
> Please help review the new version of Arch LBR enabling patch set.
>
> The Architectural Last Branch Records (LBRs) is publiced
> in the 319433-040 release of Intel Architecture Instruction
> Set Extensions and Future Features Programming Reference[0].
>
> The main advantages for the Arch LBR users are [1]:
> - Faster context switching due to XSAVES support and faster reset of
>    LBR MSRs via the new DEPTH MSR
> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>    lowers the overhead of the NMI handler.
> - Linux kernel can support the LBR features without knowing the model
>    number of the current CPU.
>
> It's based on the kvm/queue tree plus two commits from kvm/intel tree:
> - 'fea4ab260645 ("KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS")'
> - '0ccd14126cb2 ("KVM: x86: Report XSS as an MSR to be saved if there are supported features")'
>
> Please check more details in each commit and feel free to comment.
>
> [0] https://software.intel.com/content/www/us/en/develop/download/
> intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
> [1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
>
> ---
> v3->v4 Changelog:
> - Add one more host patch to reuse ARCH_LBR_CTL_MASK;
> - Add reserve_lbr_buffers() instead of using GFP_ATOMIC;
> - Fia a bug in the arch_lbr_depth_is_valid();
> - Add LBR_CTL_EN to unify DEBUGCTLMSR_LBR and ARCH_LBR_CTL_LBREN;
> - Add vmx->host_lbrctlmsr to save/restore host values;
> - Add KVM_SUPPORTED_XSS to refactoring supported_xss;
> - Clear Arch_LBR ans its XSS bit if it's not supported;
> - Add negative testing to the related kvm-unit-tests;
> - Refine code and commit messages;
>
> Previous:
> https://lore.kernel.org/kvm/20210303135756.1546253-1-like.xu@linux.intel.com/
>
> Like Xu (11):
>    perf/x86/intel: Fix the comment about guest LBR support on KVM
>    perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
>    perf/x86/lbr: Skip checking for the existence of LBR_TOS for Arch LBR
>    perf/x86/lbr: Move cpuc->lbr_xsave allocation out of sleeping region
>    perf/x86: Move ARCH_LBR_CTL_MASK definition to include/asm/msr-index.h
>    KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
>    KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
>    KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
>    KVM: x86: Expose Architectural LBR CPUID leaf
>    KVM: x86: Refine the matching and clearing logic for supported_xss
>    KVM: x86: Add XSAVE Support for Architectural LBRs
>
>   arch/x86/events/core.c           |   8 ++-
>   arch/x86/events/intel/bts.c      |   2 +-
>   arch/x86/events/intel/core.c     |   6 +-
>   arch/x86/events/intel/lbr.c      |  28 +++++----
>   arch/x86/events/perf_event.h     |   8 ++-
>   arch/x86/include/asm/msr-index.h |   1 +
>   arch/x86/include/asm/vmx.h       |   4 ++
>   arch/x86/kvm/cpuid.c             |  25 +++++++-
>   arch/x86/kvm/vmx/capabilities.h  |  25 +++++---
>   arch/x86/kvm/vmx/pmu_intel.c     | 103 ++++++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/vmx.c           |  50 +++++++++++++--
>   arch/x86/kvm/vmx/vmx.h           |   4 ++
>   arch/x86/kvm/x86.c               |   6 +-
>   13 files changed, 227 insertions(+), 43 deletions(-)
>

