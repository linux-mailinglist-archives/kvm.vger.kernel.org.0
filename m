Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FFA5E6A93
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiIVSVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiIVSVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:21 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0F110AB14;
        Thu, 22 Sep 2022 11:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870880; x=1695406880;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wLDkGwdWgKBcfDunJwn8bEHAKVMNn61aCjKIMFlG95s=;
  b=M0Zna6V0rXStOY0jcQrH/fbgqedmZzjGbItHqMrj00q1Dn1XqGzyRSRe
   0ArXMXjkVlel9nSs2sJ2o70D8a5yR6DSEs9x/f8YH7cRnAQKhrlez3g9D
   AHXZsVy5BQ5nUUixIwVLyT+YB8S55Dgk5PxL1l5DuBcakXWrm9KB9vILX
   aDbrDxB9jqN1rJP0Z6wkBsx6Klb1Zo4TwVe4iduOBjmb9bNsmb/QfB3Fc
   XQdJCJbljns+YXozktnPopcXn7+X4PxjxiCHBDQOcsTdSzQS49LWDhpoR
   jXjKo0OFW+WlOFPN36bS2KdeakFa68a29ShAdqv5YqvB9L3IdCOfdmtH9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386675921"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="386675921"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086599"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:11 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 00/30] KVM: hardware enable/disable reorganize
Date:   Thu, 22 Sep 2022 11:20:29 -0700
Message-Id: <cover.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

I've updated the patch series based on Chao's review and eliminated
kvm_arch_pre_hardware_unsetup() and compatibility check on resume.

Those two patch are compile only tested.
- "KVM: arm64: Simplify the CPUHP logic"
- "RFC: KVM: powerpc: Move processor compatibility check to hardware setup"
- "RFC: KVM: Remove cpus_hardware_enabled and related sanity check"

Changes from v4:
- reorder/reorganize the patch.  Especially introduced one patch for each PM
  events. reboot, suspend, resume, and cpu online/offline.
- eliminated kvm_arch_pre_hardware_unsetup().
- removed compatibility check on resume
- "KVM: arm64: Simplify the CPUHP logic": fixed up signed-off-by and the link.
- "RFC: KVM: powerpc: Move processor compatibility check to hardware setup"
  move the comment in the code to the commit message.

This patch series is to implement the suggestion by Sean Christopherson [1]
to reorganize enable/disable cpu virtualization feature by replacing
the arch-generic current enable/disable logic with PM related hooks. And
convert kvm/x86 to use new hooks.

- Untable x86 hardware enable logic, snapshot MSRs for user return notifier,
  enabling cpu virtualization on cpu online and platform resume. and real
  enabling of CPU virtualization feature
- Introduce hooks related to PM.
- Convert kvm/x86 code to user those hooks.
- Split out hardware enabling/disabling logic into a separate file.  Compile
  it for non-x86 code.  Once conversion of other KVM archs is done, this file
  can be dropped.
- Delete kvm_arch_check_processor_compat()
- Delete cpus_hardware_enabled. 29/30 and 30/30

[1] https://lore.kernel.org/kvm/YvU+6fdkHaqQiKxp@google.com/
[2] https://lore.kernel.org/all/20220216031528.92558-1-chao.gao@intel.com/

Changes from v3:
- Updated "KVM: arm64: Simplify the CPUHP logic".
- add preempt_disable/enable() around hardware_enable/disable() to keep the
  assumption of the arch callback.
- Eliminated arch compat check callback, kvm_arch_check_processor_compat().

Changes from v2:
- Replace the first patch("KVM: x86: Drop kvm_user_return_msr_cpu_online()")
  with Sean's implementation
- Included all patches of "Improve KVM's interaction with CPU hotplug" [2]
  Until v2, Tried to cherry-pick the least patches of it. It turned out that
  all the patches are desirable.

Changes from v1:
- Add a patch "KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section"
  to make online/offline callback to run thread context to use mutex instead
  of spin lock
- fixes pointed by Chao Gao

Chao Gao (4):
  KVM: x86: Move check_processor_compatibility from init ops to runtime
    ops
  Partially revert "KVM: Pass kvm_init()'s opaque param to additional
    arch funcs"
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
  KVM: Do compatibility checks on hotplugged CPUs

Isaku Yamahata (24):
  KVM: x86: Use this_cpu_ptr() instead of
    per_cpu_ptr(smp_processor_id())
  KVM: Provide more information in kernel log if hardware enabling fails
  KVM: Drop kvm_count_lock and instead protect kvm_usage_count with
    kvm_lock
  KVM: Add arch hooks when VM is added/deleted
  KVM: Add arch hook for reboot event
  KVM: Add arch hook for suspend
  KVM: Add arch hook for resume event
  KVM: Add arch hook for cpu online event
  KVM: Add arch hook for cpu offline event
  KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
  KVM: Move out KVM arch PM hooks and hardware enable/disable logic
  KVM: kvm_arch.c: Remove _nolock post fix
  KVM: kvm_arch.c: Remove a global variable, hardware_enable_failed
  KVM: Introduce an arch wrapper to check all processor compatibility
  KVM: x86: Duplicate arch callbacks related to pm events and compat
    check
  KVM: x86: Move TSC fixup logic to KVM arch resume callback
  KVM: Eliminate kvm_arch_post_init_vm()
  KVM: Add config to not compile kvm_arch.c
  KVM: x86: Delete kvm_arch_hardware_enable/disable()
  KVM: x86: Make x86 processor compat check callback empty
  RFC: KVM: powerpc: Move processor compatibility check to hardware
    setup
  KVM: Eliminate kvm_arch_check_processor_compat()
  RFC: KVM: x86: Remove cpus_hardware_enabled and related sanity check
  RFC: KVM: Remove cpus_hardware_enabled and related sanity check

Marc Zyngier (1):
  KVM: arm64: Simplify the CPUHP logic

Sean Christopherson (1):
  KVM: x86: Drop kvm_user_return_msr_cpu_online()

 Documentation/virt/kvm/locking.rst |  14 +-
 arch/arm64/kvm/arch_timer.c        |  27 ++--
 arch/arm64/kvm/arm.c               |  18 ++-
 arch/arm64/kvm/vgic/vgic-init.c    |  19 +--
 arch/mips/kvm/mips.c               |   5 -
 arch/powerpc/kvm/powerpc.c         |   5 -
 arch/riscv/kvm/main.c              |   5 -
 arch/s390/kvm/kvm-s390.c           |   5 -
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/svm/svm.c             |   4 +-
 arch/x86/kvm/vmx/vmx.c             |  24 ++--
 arch/x86/kvm/x86.c                 | 201 ++++++++++++++++++++++++----
 include/kvm/arm_arch_timer.h       |   4 +
 include/kvm/arm_vgic.h             |   4 +
 include/linux/cpuhotplug.h         |   5 +-
 include/linux/kvm_host.h           |  13 +-
 virt/kvm/Kconfig                   |   3 +
 virt/kvm/Makefile.kvm              |   3 +
 virt/kvm/kvm_arch.c                | 132 +++++++++++++++++++
 virt/kvm/kvm_main.c                | 205 +++++++++--------------------
 22 files changed, 443 insertions(+), 257 deletions(-)
 create mode 100644 virt/kvm/kvm_arch.c


base-commit: 521a547ced6477c54b4b0cc206000406c221b4d6
-- 
2.25.1

