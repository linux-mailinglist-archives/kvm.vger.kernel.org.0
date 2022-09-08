Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BEE5B2A26
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIHX0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiIHX0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FBAE3D54;
        Thu,  8 Sep 2022 16:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679563; x=1694215563;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AnR25Mtws37eW5qf8SWZUs9ikbFHxwFvTBT5Tpv7hrw=;
  b=Pom8M4HuCpHT8Eq325XH7efnmKeWePTagBk6uEZ6hB9GoEba0HJ3xNTB
   7waeJJwWeXtC0odAzzTL/jomlJeX7adYkT7QF9sNENxXMFBLpKqaejqJY
   jizwPbwAmeCOGR2eJu2ugENGCb4cG5dWiHWKWmI/RI9UZDB41UOqysjsq
   Elp0+zjO1de1qdQBX/hhqtluPs/WLsJgX2OzW7uaoHPDA5VofUjb1vpuQ
   incFRSFETUS77UAxvZa+hVx8jnWCg/7ZYgs1ywK2xbOyHDXog8RPXa3ae
   wH/8TFC7ldsGXer0CDV3DyHYSZK6vlEF8zYLAbENbNFSPizWwM/TPZ5CS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277082057"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="277082057"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="676915111"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:02 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v4 00/26] KVM: hardware enable/disable reorganize
Date:   Thu,  8 Sep 2022 16:25:16 -0700
Message-Id: <cover.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

I've updated the patch series based on Marc's request and Yuan review and
now eliminated kvm_arch_check_processor_compat().

Those two patch are compile only tested.
- "KVM: arm64: Simplify the CPUHP logic"
- "RFC: KVM: powerpc: Move processor compatibility check to hardware setup"
- "RFC: KVM: Remove cpus_hardware_enabled and related sanity check"

Changes from v3:
- Updated "KVM: arm64: Simplify the CPUHP logic".
- add preempt_disable/enable() around hardware_enable/disable() to keep the
  assumption of the arch callback.
- Eliminated arch compat check callback, kvm_arch_check_processor_compat().

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
- Delete cpus_hardware_enabled. 17/18 and 18/18

[1] https://lore.kernel.org/kvm/YvU+6fdkHaqQiKxp@google.com/
[2] https://lore.kernel.org/all/20220216031528.92558-1-chao.gao@intel.com/

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

Isaku Yamahata (19):
  KVM: x86: Use this_cpu_ptr() instead of
    per_cpu_ptr(smp_processor_id())
  KVM: Do processor compatibility check on resume
  KVM: Drop kvm_count_lock and instead protect kvm_usage_count with
    kvm_lock
  KVM: Add arch hooks for PM events with empty stub
  KVM: x86: Move TSC fixup logic to KVM arch resume callback
  KVM: Add arch hook when VM is added/deleted
  KVM: Move out KVM arch PM hooks and hardware enable/disable logic
  KVM: kvm_arch.c: Remove _nolock post fix
  KVM: kvm_arch.c: Remove a global variable, hardware_enable_failed
  KVM: Introduce a arch wrapper to check all processor compatibility
  KVM: x86: Duplicate arch callbacks related to pm events and compat
    check
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

Sean Christopherson (2):
  KVM: x86: Drop kvm_user_return_msr_cpu_online()
  KVM: Provide more information in kernel log if hardware enabling fails

 Documentation/virt/kvm/locking.rst |  14 +-
 arch/arm64/kvm/arch_timer.c        |  27 ++--
 arch/arm64/kvm/arm.c               |  18 ++-
 arch/arm64/kvm/vgic/vgic-init.c    |  19 +--
 arch/mips/kvm/mips.c               |   5 -
 arch/powerpc/kvm/powerpc.c         |  14 +-
 arch/riscv/kvm/main.c              |   5 -
 arch/s390/kvm/kvm-s390.c           |   5 -
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/svm/svm.c             |   4 +-
 arch/x86/kvm/vmx/vmx.c             |  24 ++--
 arch/x86/kvm/x86.c                 | 221 ++++++++++++++++++++++++-----
 include/kvm/arm_arch_timer.h       |   4 +
 include/kvm/arm_vgic.h             |   4 +
 include/linux/cpuhotplug.h         |   5 +-
 include/linux/kvm_host.h           |  16 ++-
 virt/kvm/Kconfig                   |   3 +
 virt/kvm/Makefile.kvm              |   3 +
 virt/kvm/kvm_arch.c                | 140 ++++++++++++++++++
 virt/kvm/kvm_main.c                | 208 +++++++++------------------
 22 files changed, 481 insertions(+), 262 deletions(-)
 create mode 100644 virt/kvm/kvm_arch.c


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.25.1

