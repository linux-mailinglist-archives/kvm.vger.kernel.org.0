Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D0A249529
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHSGrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:47:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:36074 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgHSGrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:47:13 -0400
IronPort-SDR: 0kSZqH/6hMfKVukG6QBU+89wFGahWNJTPnN+2lhKGureZ5B9+9auAHeafK4v6bSVfOeX7MDbAv
 Su/kqQiV2YSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873154"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873154"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:12 -0700
IronPort-SDR: DALWZK1vz4iWx0uSD7Bzuv9+EeAMOBmBT6Y4cSh1vRKwOQt1tcPfGcKBf8R4cZQBddE5tpgJ63
 NRBznJtgsoPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679238"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:09 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v10 0/9] KVM: Add virtualization support of split lock detection
Date:   Wed, 19 Aug 2020 14:46:58 +0800
Message-Id: <20200819064707.1033569-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi maintainers,

Please help review this new version and give comments. There is only one
minor change from previous v9, i.e., adding patch 8.

---

This series aims to add the virtualization of split lock detection in
KVM.

Due to the fact that split lock detection is tightly coupled with CPU
model and CPU model is configurable by host VMM, we elect to use
paravirt method to expose and enumerate it for guest.

Changes in v10
 - rebase to v5.9-rc1;
 - Add one patch to move the initialization of cpu_model_supports_sld to
   split_lock_setup();

Changes in v9
https://lkml.kernel.org/r/20200509110542.8159-1-xiaoyao.li@intel.com
 - rebase to v5.7-rc4
 - Add one patch to rename TIF_SLD to TIF_SLD_DISABLED;
 - Add one patch to remove bogus case in handle_guest_split_lock;
 - Introduce flag X86_FEATURE_SPLIT_LOCK_DETECT_FATAL and thus drop
   sld_state;
 - Use X86_FEATURE_SPLIT_LOCK_DETECT and X86_FEATURE_SPLIT_LOCK_DETECT_FATAL
   to determine the SLD state of host;
 - Introduce split_lock_virt_switch() and two wrappers for KVM instead
   of sld_update_to(); 
 - Use paravirt to expose and enumerate split lock detection for guest;
 - Split lock detection can be exposed to guest when host is sld_fatal,
   even though host is SMT available. 

Changes in v8:
https://lkml.kernel.org/r/20200414063129.133630-1-xiaoyao.li@intel.com
 - rebase to v5.7-rc1.
 - basic enabling of split lock detection already merged.
 - When host is sld_warn and nosmt, load guest's sld bit when in KVM
   context, i.e., between vmx_prepare_switch_to_guest() and before
   vmx_prepare_switch_to_host(), KVM uses guest sld setting.  

Changes in v7:
https://lkml.kernel.org/r/20200325030924.132881-1-xiaoyao.li@intel.com
 - only pick patch 1 and patch 2, and hold all the left.
 - Update SLD bit on each processor based on sld_state.

Changes in v6:
https://lkml.kernel.org/r/20200324151859.31068-1-xiaoyao.li@intel.com
 - Drop the sld_not_exist flag and use X86_FEATURE_SPLIT_LOCK_DETECT to
   check whether need to init split lock detection. [tglx]
 - Use tglx's method to verify the existence of split lock detectoin.
 - small optimization of sld_update_msr() that the default value of
   msr_test_ctrl_cache has split_lock_detect bit cleared.
 - Drop the patch3 in v5 that introducing kvm_only option. [tglx]
 - Rebase patch4-8 to kvm/queue.
 - use the new kvm-cpu-cap to expose X86_FEATURE_CORE_CAPABILITIES in
   Patch 6.

Changes in v5:
https://lkml.kernel.org/r/20200315050517.127446-1-xiaoyao.li@intel.com
 - Use X86_FEATURE_SPLIT_LOCK_DETECT flag in kvm to ensure split lock
   detection is really supported.
 - Add and export sld related helper functions in their related usecase 
   kvm patches.

Xiaoyao Li (9):
  x86/split_lock: Rename TIF_SLD to TIF_SLD_DISABLED
  x86/split_lock: Remove bogus case in handle_guest_split_lock()
  x86/split_lock: Introduce flag X86_FEATURE_SLD_FATAL and drop
    sld_state
  x86/split_lock: Introduce split_lock_virt_switch() and two wrappers
  x86/kvm: Introduce paravirt split lock detection enumeration
  KVM: VMX: Enable MSR TEST_CTRL for guest
  KVM: VMX: virtualize split lock detection
  x86/split_lock: Set cpu_model_supports_sld to true after the existence
    of split lock detection is verified BSP
  x86/split_lock: Enable split lock detection initialization when
    running as a guest on KVM

 Documentation/virt/kvm/cpuid.rst     | 29 +++++++----
 arch/x86/include/asm/cpu.h           | 36 ++++++++++++++
 arch/x86/include/asm/cpufeatures.h   |  1 +
 arch/x86/include/asm/thread_info.h   |  6 +--
 arch/x86/include/uapi/asm/kvm_para.h |  8 ++--
 arch/x86/kernel/cpu/intel.c          | 61 +++++++++++++++--------
 arch/x86/kernel/kvm.c                |  3 ++
 arch/x86/kernel/process.c            |  2 +-
 arch/x86/kvm/cpuid.c                 |  6 +++
 arch/x86/kvm/vmx/vmx.c               | 72 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h               |  3 ++
 arch/x86/kvm/x86.c                   |  6 ++-
 arch/x86/kvm/x86.h                   | 16 +++++++
 13 files changed, 207 insertions(+), 42 deletions(-)

-- 
2.18.4

