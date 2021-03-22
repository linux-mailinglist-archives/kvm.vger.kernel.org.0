Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D75343952
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 07:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCVGSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 02:18:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:35103 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhCVGSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 02:18:47 -0400
IronPort-SDR: 6QIDA+Mjo+qMqYlN78DmRyr/7NpCf8BMpzZw7x0N9CYBU6qnYl7zB0Q44kL6dntjFZQI2b1Xk1
 vemT67/PHOhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9930"; a="177341164"
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="177341164"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2021 23:18:46 -0700
IronPort-SDR: YTveGvMP9t0Ge6gSWq4Ybq4PyunSpEJbJ9fw6pikIrAx9W88+KSNkm1c2gLfkFVWjI8uD/IZPn
 6oU+qk3J89NA==
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="407672739"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2021 23:18:42 -0700
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
Message-ID: <c73abc8d-a67b-6a6d-b052-682b8cf32351@intel.com>
Date:   Mon, 22 Mar 2021 14:18:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210314155225.206661-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, do we have any comments on this patch set?

On 2021/3/14 23:52, Like Xu wrote:
> Hi geniuses,
>
> Please help review the new version of Arch LBR enabling patch set.
>
> The Architectural Last Branch Records (LBRs) is publiced
> in the 319433-040 release of Intel Architecture Instruction
> Set Extensions and Future Features Programming Reference[0].
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

