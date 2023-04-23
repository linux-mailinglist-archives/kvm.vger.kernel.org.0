Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024B66EBDFF
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 10:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDWIbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 04:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDWIat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 04:30:49 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D045E19A6;
        Sun, 23 Apr 2023 01:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682238647; x=1713774647;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h09NLjNrNUcMe+93oCKdt5W9T2zmsGANfBaYb7CFOqA=;
  b=BAAHTlZBZO1OiRLKojRc+agjHaPNk87xd3lZR8dzdq5YyLCLy+UTc7AH
   RzNQc/Ddd+r3tpJYJonLMU24P2SBs9ceP371omSDseE/1B9t5yYb0wfMB
   ZIZ+jkMnJf1Amw1r8Lc6AsgKfRMovV7ufygQGEnxLZIyMVyyllCLuzAiz
   s45uJoLk/A6YkE6KyrPd7B/iL7o36n8IeSzgT2z8TIuskFvpix919bQxy
   GM3Pur9EFPBidNlfgpv7Y2At1ErxD1koK3PQjmIFn3CbIO4/qn4ZqpHdw
   hmfFka4hD75guGPFxfv7AN54htHwB1HYGMxUhnEzMgdU4PDJj7rqtTBFs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="335144699"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="335144699"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 01:30:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="670165831"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="670165831"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.112]) ([10.254.214.112])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 01:30:44 -0700
Message-ID: <821ee57d-83cf-56ae-cc49-b8e8fcadf2ea@linux.intel.com>
Date:   Sun, 23 Apr 2023 16:30:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 00/21] Enable CET Virtualization
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com
References: <20230421134615.62539-1-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/21/2023 9:45 PM, Yang Weijiang wrote:
> CET (Control-flow Enforcement Technology) is a CPU feature used to prevent\n
> Return/Jump-Oriented Programming (ROP/JOP) attacks. CET introduces a new\n
> exception type, Control Protection (#CP), and two sub-features(SHSTK,IBT)\n
> to defend against ROP/JOP style control-flow subversion attacks.\n
>
> Shadow Stack (SHSTK):
>    A shadow stack is a second stack used exclusively for control transfer
>    operations. The shadow stack is separate from the data/normal stack and
>    can be enabled individually in user and kernel mode. When shadow stacks
>    are enabled, CALL pushes the return address on both the data and shadow
>    stack. RET pops the return address from both stacks and compares them.
>    If the return addresses from the two stacks do not match, the processor
>    generates a #CP.
>
> Indirect Branch Tracking (IBT):
>    IBT adds new instrutions, ENDBRANCH{32|64}, to mark valid target addresses

/s/instrutions/instructions


>    of indirect branches (CALL, JMP etc...). If an indirect branch is executed
>    and the next instruction is _not_ an ENDBRANCH, the processor generates a #CP.

IMHO, it's better to mention the behavior of the new instructions when 
IBT is not enabled or
on the old platforms that don't support the feature.


>
>
> Build dependency:
> --------------------------------------------------------------------------
> The first 5 patches are took over from CET native series [1] in linux-next,
> they must be included in kernel tree when build host kernel for testing CET
> in guest. Will remove them once the native series landed in mainline kernel
> tree. It's just for build and test purpose.
>
>
> Implementation:
> --------------------------------------------------------------------------
> Historically, the early KVM patches can support both user SHSTK and IBT,
> and most of the early patches are carried forward with changes by this new
> series. Then with kernel IBT feature merged in 5.18, a new patch was added
> to support the feature for guest. The last patch is introduced to support
> supervisor SHSTK but the feature is not enabled on Intel platform for now,
> the main purpose of this patch is to facilitate AMD folks to enable the
> feature.
>
> In summary, this new series enables CET user SHSTK/IBT and kernel IBT, but
> doesn't fully support CET supervisor SHSTK, the enabling work is left for
> the future.
>
> Supported CET sub-features:
>
>                    |
>      User SHSTK    |    User IBT      (user mode)
> --------------------------------------------------
>      s-SHSTK (X)   |    Kernel IBT    (kernel mode)
>                    |
>
> The user SHSTK/IBT relies on host side XSAVES support(XSS[bit 11]) for user
> mode CET states. The kernel IBT doesn't have dependency on host XSAVES.
> The supervisor SHSTK relies on host side XSAVES support(XSS[bit 12]) for
> supervisor mode CET states.
>
> This version removed unnecessary checks for host CET enabling status before
> enabling guest CET support, making guest CET support apart from that of host.
> By doing so, it's expected to be more friendly to cloud computing scenarios.
>
>
> CET states management:
> --------------------------------------------------------------------------
> CET user mode states, MSR_IA32_{U_CET,PL3_SSP} depends on {XSAVES|XRSTORS}
> instructions to swap guest/host context when vm-exit/vm-entry happens.
> On vm-exit, the guest CET states are stored to guest fpu area and host user
> mode states are loaded from thread/process context before vCPU returns to
> userspace, vice-versa on vm-entry. See details in kvm_{load|put}_guest_fpu().
> So the user mode state validity depends on host side U_CET bit set in MSR_XSS.
>
> CET supervisor mode states are grouped into two categories - XSAVES dependent
> and non-dependent, the former includes MSR_IA32_PL{0,1,2}_SSP, the later
> consists of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL. The XSAVES dependent
> MSR's save/restore depends on S_CET bit set in MSR_XSS. Since the native series
> doesn't enable S_CET support,

Do you know the reason why native patch doesn't enable S_CET support?


> these s-SHSTK shadow stack pointers are invalid.
>
> Moveover, new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, are
> introduced for guest/host supervisor state switch. When CET entry/exit load
> bits are set, the guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are swapped
> automatically at vm-exit/entry. With these new fields, current guest kernel
> IBT enalbing doesn't depend on host {XSAVES|XRSTORS} support.

/s/enalbing/enabling


>
>
> Tests:
> --------------------------------------------------------------------------
> This series passed basic CET user shadow stack test and kernel IBT test in
> L1 and L2 guest. It also passed CET KUT test which has been merged there.
>
> Executed all KUT tests and KVM selftests against this series, all test cases
> passes except the vmx test, the failure is due to CR4_CET bit testing in
> test_vmxon_bad_cr(). After add CR4_CET bit to skip list, the test passed.
> I'll send a patch to fix this issue later.
>
>
> To run user shadow stack test and kernel IBT test in VM, you need an CET
> capable platform, e.g., Sapphire Rapids server, and follow below steps to
> build host/guest kernel properly:
>
> 1. Buld host kernel. Patch this series to kernel tree and build kernel

/s/Buld/Build


> with CET capable gcc version(e.g., >=8.5.0).

I guess these should be some compiler option(s), can you also list it 
here if any?


>
> 2. Build guest kernel. Patch CET native series to kernel tree and opt-in
> CONFIG_X86_KERNEL_IBT and CONFIG_X86_USER_SHADOW_STACK options.

I guess guest kernel also needs to be built using CET capable tool chain 
with CET enabled?


>
> 3. Launch a VM with QEMU built with CET enabling patches [2].
>
> Check kernel selftest test_shadow_stack_64 output:
> [INFO]  new_ssp = 7f8c82100ff8, *new_ssp = 7f8c82101001
> [INFO]  changing ssp from 7f8c82900ff0 to 7f8c82100ff8
> [INFO]  ssp is now 7f8c82101000
> [OK]    Shadow stack pivot
> [OK]    Shadow stack faults
> [INFO]  Corrupting shadow stack
> [INFO]  Generated shadow stack violation successfully
> [OK]    Shadow stack violation test
> [INFO]  Gup read -> shstk access success
> [INFO]  Gup write -> shstk access success
> [INFO]  Violation from normal write
> [INFO]  Gup read -> write access success
> [INFO]  Violation from normal write
> [INFO]  Gup write -> write access success
> [INFO]  Cow gup write -> write access success
> [OK]    Shadow gup test
> [INFO]  Violation from shstk access
> [OK]    mprotect() test
> [SKIP]  Userfaultfd unavailable.
> [OK]    32 bit test
>
> Check kernel IBT with dmesg | grep CET:
> CET detected: Indirect Branch Tracking enabled
>
> --------------------------------------------------------------------------
> Changes in v2:
> 1. Remove excessive checks on host CET Kconfig options in v1 patchset [3].
> 2. Make CET CPUIDs, MSRs and control flags enabling independent to host CET status.
> 3. Introduce supervisor SHSTK support to make the patch set complete.
> 4. Refactor patches to accommodate above changes.
> 5. Rebase on kvm-x86/next [4].
>
>
> [1]: linux-next: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/?h=next-20230420
> [2]: QEMU patch: https://lore.kernel.org/all/20230421041227.90915-1-weijiang.yang@intel.com/
> [3]: v1 patchset: https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
> [4]: Rebase branch: https://github.com/kvm-x86/linux.git, commit: 7b632f72528d (tag: kvm-x86-next-2023.04.14)
>
>
> Rick Edgecombe (5):
>    x86/shstk: Add Kconfig option for shadow stack
>    x86/cpufeatures: Add CPU feature flags for shadow stacks
>    x86/cpufeatures: Enable CET CR4 bit for shadow stack
>    x86/fpu/xstate: Introduce CET MSR and XSAVES supervisor states
>    x86/fpu: Add helper for modifying xstate
>
> Sean Christopherson (2):
>    KVM:x86: Report XSS as to-be-saved if there are supported features
>    KVM:x86: Load guest FPU state when accessing xsaves-managed MSRs
>
> Yang Weijiang (14):
>    KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
>    KVM:x86: Init kvm_caps.supported_xss with supported feature bits
>    KVM:x86: Add #CP support in guest exception classification
>    KVM:VMX: Introduce CET VMCS fields and control bits
>    KVM:x86: Add fault checks for guest CR4.CET setting
>    KVM:VMX: Emulate reads and writes to CET MSRs
>    KVM:VMX: Add a synthetic MSR to allow userspace VMM to access
>      GUEST_SSP
>    KVM:x86: Report CET MSRs as to-be-saved if CET is supported
>    KVM:x86: Save/Restore GUEST_SSP to/from SMM state save area
>    KVM:VMX: Pass through user CET MSRs to the guest
>    KVM:x86: Enable CET virtualization for VMX and advertise to userspace
>    KVM:nVMX: Enable user CET support for nested VMX
>    KVM:x86: Enable supervisor IBT support for guest
>    KVM:x86: Support CET supervisor shadow stack MSR access
>
>   arch/x86/Kconfig                         |  24 ++++
>   arch/x86/Kconfig.assembler               |   5 +
>   arch/x86/include/asm/cpufeatures.h       |   2 +
>   arch/x86/include/asm/disabled-features.h |   8 +-
>   arch/x86/include/asm/fpu/api.h           |   9 ++
>   arch/x86/include/asm/fpu/types.h         |  16 ++-
>   arch/x86/include/asm/fpu/xstate.h        |   6 +-
>   arch/x86/include/asm/kvm_host.h          |   3 +-
>   arch/x86/include/asm/vmx.h               |   8 ++
>   arch/x86/include/uapi/asm/kvm.h          |   1 +
>   arch/x86/include/uapi/asm/kvm_para.h     |   1 +
>   arch/x86/kernel/cpu/common.c             |  35 ++++--
>   arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
>   arch/x86/kernel/fpu/core.c               |  19 +++
>   arch/x86/kernel/fpu/xstate.c             |  90 +++++++-------
>   arch/x86/kvm/cpuid.c                     |  23 +++-
>   arch/x86/kvm/cpuid.h                     |   6 +
>   arch/x86/kvm/smm.c                       |  20 +++
>   arch/x86/kvm/vmx/capabilities.h          |   4 +
>   arch/x86/kvm/vmx/nested.c                |  29 ++++-
>   arch/x86/kvm/vmx/vmcs12.c                |   6 +
>   arch/x86/kvm/vmx/vmcs12.h                |  14 ++-
>   arch/x86/kvm/vmx/vmx.c                   | 150 ++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.h                   |   6 +-
>   arch/x86/kvm/x86.c                       |  79 ++++++++++--
>   arch/x86/kvm/x86.h                       |  46 ++++++-
>   26 files changed, 528 insertions(+), 83 deletions(-)
>
>
> base-commit: 7b632f72528d5fa3f0265358a393f534da47d9dd
