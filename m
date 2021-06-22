Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E13AFF91
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFVItf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:49:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:36958 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhFVItf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 04:49:35 -0400
IronPort-SDR: icvnJynfx3cRjCCMThGggg5xTGuVe2f+Obakbd8+bvzh7FzdP4gfUyeEdDL5jbJoX7kOk8Cl4s
 FZ4FkSn/6fXA==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="187394152"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="187394152"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 01:47:15 -0700
IronPort-SDR: ukPvfoQOa44oqWOVGcyyHYwYOtkxKNyKOuVVvXOs9sLN5Iv3/3rhYIL8pjFx3zTSDDT6zPtHbY
 JD+12BxKULpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="486827427"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by orsmga001.jf.intel.com with ESMTP; 22 Jun 2021 01:47:11 -0700
Date:   Tue, 22 Jun 2021 17:01:52 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v4 00/10] KVM: x86/pmu: Guest Architectural LBR
 Enabling
Message-ID: <20210622090152.GA13141@intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510081535.94184-1-like.xu@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hello, maintainers,

I took over the work from Like and will carry it forward. Here I'd like to
get your valuable comments on this patch series before I post next version.

Thanks a lot!

> Hi geniuses,
> 
> A new kernel cycle has begun, and this version looks promising. 
> 
> >From the end user's point of view, the usage of Arch LBR is the same as
> the legacy LBR we have merged in the mainline, but it is much faster.
> 
> The Architectural Last Branch Records (LBRs) is published 
> in the 319433-040 release of Intel Architecture Instruction
> Set Extensions and Future Features Programming Reference[0].
> 
> The main advantages for the Arch LBR users are [1]:
> - Faster context switching due to XSAVES support and faster reset of
>   LBR MSRs via the new DEPTH MSR
> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>   lowers the overhead of the NMI handler.
> - Linux kernel can support the LBR features without knowing the model
>   number of the current CPU.
> 
> Please check more details in each commit and feel free to comment.
> 
> [0] https://software.intel.com/content/www/us/en/develop/download/
> intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
> [1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
> 
> ---
> v13->v13 RESEND Changelog:
> - Rebase to kvm/queue tree tag: kvm-5.13-2;
> - Includes two XSS dependency patches from kvm/intel tree;
> 
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
> v4: https://lore.kernel.org/kvm/20210314155225.206661-1-like.xu@linux.intel.com/
> v3: https://lore.kernel.org/kvm/20210303135756.1546253-1-like.xu@linux.intel.com/
> 
> Like Xu (8):
>   perf/x86/intel: Fix the comment about guest LBR support on KVM
>   perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
>   KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
>   KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
>   KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
>   KVM: x86: Expose Architectural LBR CPUID leaf
>   KVM: x86: Refine the matching and clearing logic for supported_xss
>   KVM: x86: Add XSAVE Support for Architectural LBRs
> 
> Sean Christopherson (1):
>   KVM: x86: Report XSS as an MSR to be saved if there are supported
>     features
> 
> Yang Weijiang (1):
>   KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
> 
>  arch/x86/events/intel/core.c     |   3 +-
>  arch/x86/events/intel/lbr.c      |   6 +-
>  arch/x86/include/asm/kvm_host.h  |   1 +
>  arch/x86/include/asm/msr-index.h |   1 +
>  arch/x86/include/asm/vmx.h       |   4 ++
>  arch/x86/kvm/cpuid.c             |  46 ++++++++++++--
>  arch/x86/kvm/vmx/capabilities.h  |  25 +++++---
>  arch/x86/kvm/vmx/pmu_intel.c     | 103 ++++++++++++++++++++++++++++---
>  arch/x86/kvm/vmx/vmx.c           |  50 +++++++++++++--
>  arch/x86/kvm/vmx/vmx.h           |   4 ++
>  arch/x86/kvm/x86.c               |  19 +++++-
>  11 files changed, 226 insertions(+), 36 deletions(-)
> 
> -- 
> 2.31.1
