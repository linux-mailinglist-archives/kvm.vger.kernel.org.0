Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C585A62A9
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiH3MB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiH3MB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:01:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5B8E399B;
        Tue, 30 Aug 2022 05:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860914; x=1693396914;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gbCj+SlvH9cYEHWaMs6CxZsjrHuR25HaucDocuWVwrY=;
  b=TSfdZervg1u9br9iNhdOeOyxzoFZlx0B7PCpzQzSVDrCXc9rWkdCakcq
   bijidyiO/ABzuoFEwGC2hli2cJPi7QAVhgTCN+ZTuX3ZfEzwQTlmT7Dgc
   +mkyaLVasR2c2hURC0Z/yxEgu/WFxELSAPDtQB9cCvy9sNtmbOlwRB6ND
   Uyf6/YZ6TDOvglar7u+UArRDR0E5C6DOgs8/mmI7rNcHSXY4GX0LmHaVy
   NBIFKLzmWOJC0TfFYnCxEEYt0yNMuTyiAHWq6DRVunYBB2Zqhr+li23G1
   PeFUg02ABslV8zKdAE2WGl4/t9vSpvHThs1izMLehH3GHIYzQFZ4cqWwy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870953"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870953"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="857078224"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 00/19] KVM hardware enable/disable reorganize
Date:   Tue, 30 Aug 2022 05:01:15 -0700
Message-Id: <cover.1661860550.git.isaku.yamahata@intel.com>
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

Changes from v1:
- Add a patch "KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section"
  to make online/offline callback to run thread context to use mutex instead
  of spin lock
- fixes pointed by Chao Gao

Chao Gao (3):
  KVM: x86: Move check_processor_compatibility from init ops to runtime
    ops
  Partially revert "KVM: Pass kvm_init()'s opaque param to additional
    arch funcs"
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section

Isaku Yamahata (16):
  KVM: x86: Drop kvm_user_return_msr_cpu_online()
  KVM: x86: Use this_cpu_ptr() instead of
    per_cpu_ptr(smp_processor_id())
  KVM: Drop kvm_count_lock and instead protect kvm_usage_count with
    kvm_lock
  KVM: Add arch hooks for PM events with empty stub
  KVM: x86: Move TSC fixup logic to KVM arch resume callback
  KVM: Add arch hook when VM is added/deleted
  KVM: Move out KVM arch PM hooks and hardware enable/disable logic
  KVM: kvm_arch.c: Remove _nolock post fix
  KVM: kvm_arch.c: Remove a global variable, hardware_enable_failed
  KVM: Do processor compatibility check on cpu online and resume
  KVM: x86: Duplicate arch callbacks related to pm events
  KVM: Eliminate kvm_arch_post_init_vm()
  KVM: x86: Delete kvm_arch_hardware_enable/disable()
  KVM: Add config to not compile kvm_arch.c
  RFC: KVM: x86: Remove cpus_hardware_enabled and related sanity check
  RFC: KVM: Remove cpus_hardware_enabled and related sanity check

 Documentation/virt/kvm/locking.rst |  14 +--
 arch/arm64/kvm/arm.c               |   2 +-
 arch/mips/kvm/mips.c               |   2 +-
 arch/powerpc/kvm/powerpc.c         |   2 +-
 arch/riscv/kvm/main.c              |   2 +-
 arch/s390/kvm/kvm-s390.c           |   2 +-
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/svm/svm.c             |   4 +-
 arch/x86/kvm/vmx/vmx.c             |  14 +--
 arch/x86/kvm/x86.c                 | 192 +++++++++++++++++++++-------
 include/linux/cpuhotplug.h         |   2 +-
 include/linux/kvm_host.h           |  14 ++-
 virt/kvm/Kconfig                   |   3 +
 virt/kvm/Makefile.kvm              |   3 +
 virt/kvm/kvm_arch.c                | 126 +++++++++++++++++++
 virt/kvm/kvm_main.c                | 193 +++++++++--------------------
 18 files changed, 373 insertions(+), 206 deletions(-)
 create mode 100644 virt/kvm/kvm_arch.c

-- 
2.25.1

