Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008D16EC363
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 03:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjDXBUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 21:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDXBU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 21:20:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1393F10DF;
        Sun, 23 Apr 2023 18:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682299228; x=1713835228;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=as4THXpWVtwsuMyx+EcJb1cT+H8svUTldBTwSxNT588=;
  b=TnHSDaTTjLV4AjZdKMYHHmJuLm9CCW+4o1+iJU1mB/DH/dH7IckGp/bm
   3MQk7Pt/FuTR6ua9P0KwAmfG7JFdLGllIMGgBh8EXz98YKume4OQ5xZ3Q
   prTi5PsR/n8Ws/QSx5x16kbTYKtfItnoade4Dno5DxfcDV9UXUfqOt2qA
   U109KE0uYCjEn1DYFdB5VmC5UFugi7v9LhenXuW4cDkyFljZITi+l4DqL
   Z1fb6qQGX0iD4SEEGBC4s79Zt8ESZIIBhwKnG4dqgvAyw1TNc2dQYi9uw
   BftVsPh4B06nWyeIFwjLADPiLhmQzWpb4AzUdqDnTwKvA3Dk2pplDmgK4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="330538440"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="330538440"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 18:20:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="692885238"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="692885238"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.168.81]) ([10.249.168.81])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 18:20:24 -0700
Message-ID: <99fd6359-bc5d-b633-9b16-711f16063da8@linux.intel.com>
Date:   Mon, 24 Apr 2023 09:20:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/6] LASS KVM virtualization support
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230420133724.11398-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/20/2023 9:37 PM, Zeng Guang wrote:
> Linear Address Space Separation (LASS)[1] is a new mechanism that
> enforces the same mode-based protections as paging, i.e. SMAP/SMEP but
> without traversing the paging structures. Because the protections
> enforced by LASS are applied before paging, "probes" by malicious
> software will provide no paging-based timing information.
>
> LASS works in long mode and partitions the 64-bit canonical linear
> address space into two halves:
>      1. Lower half (LA[63]=0) --> user space
>      2. Upper half (LA[63]=1) --> kernel space
>
> When LASS is enabled, a general protection #GP fault or a stack fault
> #SS will be generated if software accesses the address from the half
> in which it resides to another half,

The accessor's mode is based on CPL, not the address range,
so it feels a bit inaccurate of descripton "in which it resides".


> e.g., either from user space to
> upper half, or from kernel space to lower half. This protection applies
> to data access, code execution.
>
> This series add KVM LASS virtualization support.
>
> When platform has LASS capability, KVM requires to expose this feature
> to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
> allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
> executed in the guest directly, hardware will perform the LASS violation
> check, while KVM also needs to apply LASS to instructions emulated by
> software and injects #GP or #SS fault to the guest.
>
> Following LASS voilations check will be taken on KVM emulation path.

/s/voilations/violations


> User-mode access to supervisor space address:
>          LA[bit 63] && (CPL == 3)
> Supervisor-mode access to user space address:
>          Instruction fetch: !LA[bit 63] && (CPL < 3)
>          Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>                       CPL < 3) || Implicit supervisor access)
>
> We tested the basic function of LASS virtualization including LASS
> enumeration and enabling in non-root and nested environment. As current
> KVM unittest framework is not compatible to LASS rule that kernel should
> run in the upper half, we use kernel module and application test to verify
> LASS functionalities in guest instead. The data access related x86 emulator
> code is verified with forced emulation prefix (FEP) mechanism. Other test
> cases are working in progress.
>
> How to add tests for LASS in KUT or kselftest is still under investigation.
>
> [1] Intel Architecutre Instruction Set Extensions and Future Features

/s/Architecutre/Architecture


> Programming Reference: Chapter Linear Address Space Separation (LASS)
> https://cdrdv2.intel.com/v1/dl/getContent/671368
>
> Zeng Guang (6):
>    KVM: x86: Virtualize CR4.LASS
>    KVM: VMX: Add new ops in kvm_x86_ops for LASS violation check
>    KVM: x86: Add emulator helper for LASS violation check
>    KVM: x86: LASS protection on KVM emulation when LASS enabled
>    KVM: x86: Advertise LASS CPUID to user space
>    KVM: x86: Set KVM LASS based on hardware capability
>
>   arch/x86/include/asm/cpuid.h       | 36 +++++++++++++++++++
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  7 +++-
>   arch/x86/kvm/cpuid.c               |  8 +++--
>   arch/x86/kvm/emulate.c             | 36 ++++++++++++++++---
>   arch/x86/kvm/kvm_emulate.h         |  1 +
>   arch/x86/kvm/vmx/nested.c          |  3 ++
>   arch/x86/kvm/vmx/sgx.c             |  2 ++
>   arch/x86/kvm/vmx/vmx.c             | 58 ++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.h             |  2 ++
>   arch/x86/kvm/x86.c                 |  9 +++++
>   arch/x86/kvm/x86.h                 |  2 ++
>   12 files changed, 157 insertions(+), 8 deletions(-)
>
