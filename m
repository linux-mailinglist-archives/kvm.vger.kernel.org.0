Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329D6191494
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgCXPhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:37:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:40198 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbgCXPhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:05 -0400
IronPort-SDR: LLb5cSzLtWtvLZow8PQek16+ibtPBzmxOii4zVNpooSmTneWwN8ZbvO6xfms3Mb63Gd0Sl/iFA
 oJUuF1fBbo8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 08:37:04 -0700
IronPort-SDR: NW2j/PrriTw0QlQ/+lOlMn8Y1tzc6CVzaVQ2I5jYpByXrkvlhmdgGeOmwndNm65ka8Q/KZQbNV
 jugDFZwqC/0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="393319653"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.39])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2020 08:37:00 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 0/8] x86/split_lock: Fix and virtualization of split lock detection
Date:   Tue, 24 Mar 2020 23:18:51 +0800
Message-Id: <20200324151859.31068-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So sorry for the noise that I forgot to CC the maillist.

This series aims to add the virtualization of split lock detection for
guest, while containing some fixes of native kernel split lock handling. 

Note, this series is based on the kernel patch[1]. Patch 1-3 are x86
kernel patches that based on the linux/master branch. Patch 4-8 are kvm
patches that based on the kvm/queue branch.

Patch 1 is the fix and enhancement for kernel split lock detction. It
ensures X86_FEATURE_SPLIT_LOCK_DETECT flag is set only when feature does
exist and not disabled on kernel params. And it explicitly turn off split
lock when sld_off instead of assuming BIOS/firmware leaves it cleared.

Patch 2 optimizes the runtime MSR accessing.

Patch 3 are the preparation for enabling split lock detection
virtualization in KVM.

Patch 4 fixes the issue that malicious guest may exploit kvm emulator to
attcact host kernel.

Patch 5 handles guest's split lock when host turns split lock detect on.

Patch 6-8 implement the virtualization of split lock detection in kvm.

[1]: https://lore.kernel.org/lkml/158031147976.396.8941798847364718785.tip-bot2@tip-bot2/ 

Changes in v6:
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
 - Use X86_FEATURE_SPLIT_LOCK_DETECT flag in kvm to ensure split lock
   detection is really supported.
 - Add and export sld related helper functions in their related usecase 
   kvm patches.

Changes in v4:
 - Add patch 1 to rework the initialization flow of split lock
   detection.
 - Drop percpu MSR_TEST_CTRL cache, just use a static variable to cache
   the reserved/unused bit of MSR_TEST_CTRL. [Sean]
 - Add new option for split_lock_detect kernel param.
 - Changlog refinement. [Sean]
 - Add a new patch to enable MSR_TEST_CTRL for intel guest. [Sean]

Xiaoyao Li (8):
  x86/split_lock: Rework the initialization flow of split lock detection
  x86/split_lock: Avoid runtime reads of the TEST_CTRL MSR
  x86/split_lock: Export handle_user_split_lock()
  kvm: x86: Emulate split-lock access as a write in emulator
  kvm: vmx: Extend VMX's #AC interceptor to handle split lock #AC
    happens in guest
  kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
  kvm: vmx: Enable MSR_TEST_CTRL for intel guest
  kvm: vmx: virtualize split lock detection

 arch/x86/include/asm/cpu.h      |  21 +++++-
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kernel/cpu/intel.c     | 114 +++++++++++++++++++-------------
 arch/x86/kernel/traps.c         |   2 +-
 arch/x86/kvm/cpuid.c            |   1 +
 arch/x86/kvm/vmx/vmx.c          |  75 ++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |   1 +
 arch/x86/kvm/x86.c              |  42 +++++++++++-
 8 files changed, 203 insertions(+), 54 deletions(-)

-- 
2.20.1

