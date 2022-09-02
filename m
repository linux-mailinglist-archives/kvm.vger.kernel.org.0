Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97BB5AA58A
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiIBCSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIBCSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F80C6B14C;
        Thu,  1 Sep 2022 19:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085090; x=1693621090;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=npT/BSnWZfK9QAa4XbMMnIxHSp51tHe3tCOKQu0VB50=;
  b=OeRmnEmcASGlwESl4RKbO/MuF3nOiW4y1NDRZW8TsFB5nqKXbfb8urtH
   Pytz3s5vvbDvUo5dvzHDpjoMfFaDKoCyWFan1bMLCVRF+fu7/kai68hx6
   zrWdRa2kwvgDCMWd+BDYjgf5A/R3wMVecuLTREKijjdFww/fSC1Iz6dIw
   pzEfSVbZZm5hVijvyp+NKWvw0Gtqyou4C18JQdOMvgMg2SxNtzzE+jjfm
   ZQAtnwxFdeNTgSF5/yEQU1CkcYwOBZl8grFUI7XpCoIKsmyiBi/WZyHBS
   23OKvNF+PfW/wvMW4rvVQBskdH0twH1Nil+xAjY3b0bxGYDFoZJs3n2Wl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="294614997"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="294614997"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:09 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="674153017"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:09 -0700
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
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 00/22] KVM: hardware enable/disable reorganize
Date:   Thu,  1 Sep 2022 19:17:35 -0700
Message-Id: <cover.1662084396.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Changes from v2:
- Replace the first patch("KVM: x86: Drop kvm_user_return_msr_cpu_online()")
  with Sean's implementation
- Included all patches of "Improve KVM's interaction with CPU hotplug" [2]
  Until v2, Tried to cherry-pick the least patches of it. It turned out that
  all the patches are desirable.

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
- Delete cpus_hardware_enabled. 17/18 and 18/18

[1] https://lore.kernel.org/kvm/YvU+6fdkHaqQiKxp@google.com/
[2] https://lore.kernel.org/all/20220216031528.92558-1-chao.gao@intel.com/

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

Isaku Yamahata (15):
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
  KVM: x86: Duplicate arch callbacks related to pm events
  KVM: Eliminate kvm_arch_post_init_vm()
  KVM: x86: Delete kvm_arch_hardware_enable/disable()
  KVM: Add config to not compile kvm_arch.c
  RFC: KVM: x86: Remove cpus_hardware_enabled and related sanity check
  RFC: KVM: Remove cpus_hardware_enabled and related sanity check

Marc Zyngier (1):
  KVM: arm64: Simplify the CPUHP logic

Sean Christopherson (2):
  KVM: x86: Drop kvm_user_return_msr_cpu_online()
  KVM: Provide more information in kernel log if hardware enabling fails

 Documentation/virt/kvm/locking.rst |  14 +-
 arch/arm64/kvm/arch_timer.c        |  27 ++--
 arch/arm64/kvm/arm.c               |   6 +-
 arch/arm64/kvm/vgic/vgic-init.c    |  19 +--
 arch/mips/kvm/mips.c               |   2 +-
 arch/powerpc/kvm/powerpc.c         |   2 +-
 arch/riscv/kvm/main.c              |   2 +-
 arch/s390/kvm/kvm-s390.c           |   2 +-
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/svm/svm.c             |   4 +-
 arch/x86/kvm/vmx/vmx.c             |  24 ++--
 arch/x86/kvm/x86.c                 | 177 ++++++++++++++++++++-----
 include/kvm/arm_arch_timer.h       |   4 +
 include/kvm/arm_vgic.h             |   4 +
 include/linux/cpuhotplug.h         |   5 +-
 include/linux/kvm_host.h           |  14 +-
 virt/kvm/Kconfig                   |   3 +
 virt/kvm/Makefile.kvm              |   3 +
 virt/kvm/kvm_arch.c                | 127 ++++++++++++++++++
 virt/kvm/kvm_main.c                | 203 ++++++++++-------------------
 22 files changed, 413 insertions(+), 233 deletions(-)
 create mode 100644 virt/kvm/kvm_arch.c


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.25.1

