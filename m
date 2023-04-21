Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FAA6EB3F2
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjDUVy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 17:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDUVy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 17:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5DB10E6;
        Fri, 21 Apr 2023 14:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89EAA6533D;
        Fri, 21 Apr 2023 21:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5727DC433D2;
        Fri, 21 Apr 2023 21:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682114065;
        bh=DRON7XFtvhv8PDHCVrMA2EYaP0sAjS6fdsERTA2HI+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rrBnNisH4esAY7R0aw3/67+MLWbbMD/1amiuQEb2HQnsNZm3qE0MQ/0F0DWAkgVnK
         ew2RVa/nZktAwvWeVd+f21wRW5T5D3L6mNzqzggikKDeP0fcWP3PVU8sgT/sFv1bRz
         KQEQHx9U75B00v1PiolM+V7C4mUzlqXPJW1zZpW9q7F0rdrp+1ImWAkeKhvLZSPb/H
         VXJLQC+xHY2AOwoykskgCzzSg2qUAlguhXduKS9NenCogJOb3K+msyiUpkJa7xFUq5
         to3rfhqrUUwsELyvSZQaGp5UKDZBC6bAJwUULfIFUclXTH7x/FU0ZEJGnhB0Bs3F6d
         mv7aY+Q0LiUpg==
Date:   Sat, 22 Apr 2023 00:54:11 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 00/21] Enable CET Virtualization
Message-ID: <ZEMGA2uUfpJL4rMH@kernel.org>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Apr 21, 2023 at 09:45:54AM -0400, Yang Weijiang wrote:
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
> with CET capable gcc version(e.g., >=8.5.0).
> 
> 2. Build guest kernel. Patch CET native series to kernel tree and opt-in
> CONFIG_X86_KERNEL_IBT and CONFIG_X86_USER_SHADOW_STACK options.
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
 
I played a bit with KVM support for shadow stacks on AMD machines and I
rebased v1 patches along with John's SVM series 

https://lore.kernel.org/kvm/20221012203910.204793-1-john.allen@amd.com/

on top of v6.3-rc4 and Rick's series for host shadow stack support. I've
put this at

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=shstk/kvm

if anybody is interested. With this I could successfully run shadow stack
self test in a guest on an AMD Zen3 machine.

One thing I've noticed while rebasing is that John's patches move
cet_is_msr_accessible() from vmx/ to x86.c and I also had to make such move
for cet_is_ssp_msr_accessible().

Would make sense to have them available for both VMX and SVM from the
start.

> Rick Edgecombe (5):
>   x86/shstk: Add Kconfig option for shadow stack
>   x86/cpufeatures: Add CPU feature flags for shadow stacks
>   x86/cpufeatures: Enable CET CR4 bit for shadow stack
>   x86/fpu/xstate: Introduce CET MSR and XSAVES supervisor states
>   x86/fpu: Add helper for modifying xstate
> 
> Sean Christopherson (2):
>   KVM:x86: Report XSS as to-be-saved if there are supported features
>   KVM:x86: Load guest FPU state when accessing xsaves-managed MSRs
> 
> Yang Weijiang (14):
>   KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
>   KVM:x86: Init kvm_caps.supported_xss with supported feature bits
>   KVM:x86: Add #CP support in guest exception classification
>   KVM:VMX: Introduce CET VMCS fields and control bits
>   KVM:x86: Add fault checks for guest CR4.CET setting
>   KVM:VMX: Emulate reads and writes to CET MSRs
>   KVM:VMX: Add a synthetic MSR to allow userspace VMM to access
>     GUEST_SSP
>   KVM:x86: Report CET MSRs as to-be-saved if CET is supported
>   KVM:x86: Save/Restore GUEST_SSP to/from SMM state save area
>   KVM:VMX: Pass through user CET MSRs to the guest
>   KVM:x86: Enable CET virtualization for VMX and advertise to userspace
>   KVM:nVMX: Enable user CET support for nested VMX
>   KVM:x86: Enable supervisor IBT support for guest
>   KVM:x86: Support CET supervisor shadow stack MSR access
> 
>  arch/x86/Kconfig                         |  24 ++++
>  arch/x86/Kconfig.assembler               |   5 +
>  arch/x86/include/asm/cpufeatures.h       |   2 +
>  arch/x86/include/asm/disabled-features.h |   8 +-
>  arch/x86/include/asm/fpu/api.h           |   9 ++
>  arch/x86/include/asm/fpu/types.h         |  16 ++-
>  arch/x86/include/asm/fpu/xstate.h        |   6 +-
>  arch/x86/include/asm/kvm_host.h          |   3 +-
>  arch/x86/include/asm/vmx.h               |   8 ++
>  arch/x86/include/uapi/asm/kvm.h          |   1 +
>  arch/x86/include/uapi/asm/kvm_para.h     |   1 +
>  arch/x86/kernel/cpu/common.c             |  35 ++++--
>  arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
>  arch/x86/kernel/fpu/core.c               |  19 +++
>  arch/x86/kernel/fpu/xstate.c             |  90 +++++++-------
>  arch/x86/kvm/cpuid.c                     |  23 +++-
>  arch/x86/kvm/cpuid.h                     |   6 +
>  arch/x86/kvm/smm.c                       |  20 +++
>  arch/x86/kvm/vmx/capabilities.h          |   4 +
>  arch/x86/kvm/vmx/nested.c                |  29 ++++-
>  arch/x86/kvm/vmx/vmcs12.c                |   6 +
>  arch/x86/kvm/vmx/vmcs12.h                |  14 ++-
>  arch/x86/kvm/vmx/vmx.c                   | 150 ++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h                   |   6 +-
>  arch/x86/kvm/x86.c                       |  79 ++++++++++--
>  arch/x86/kvm/x86.h                       |  46 ++++++-
>  26 files changed, 528 insertions(+), 83 deletions(-)
> 
> 
> base-commit: 7b632f72528d5fa3f0265358a393f534da47d9dd
> -- 
> 2.27.0
> 

-- 
Sincerely yours,
Mike.
