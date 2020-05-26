Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2CB1A73DE
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 08:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406108AbgDNGuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 02:50:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:58687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgDNGuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 02:50:19 -0400
IronPort-SDR: OjmaLZZPHFzXUYE/kU+BQmnaIqwoO2JcFKOOOI+Lz5FuDhS08SlMtQRUHJABWsOCTMVuGZsN49
 3UCviNb4ac7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 23:50:18 -0700
IronPort-SDR: wgRVshwsFChPpE0xUr6eMwqj/GGvkxPTReoUOG0k+ja+18dP5qIgyYiK100cEjZX5dAyGM1L+m
 J88BRrCVCLzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="277158309"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2020 23:50:13 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v8 0/4] KVM: Add virtualization support of split lock detection
Date:   Tue, 14 Apr 2020 14:31:25 +0800
Message-Id: <20200414063129.133630-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series aims to add the virtualization of split lock detection in
KVM.

Due to the fact MSR TEST_CTRL is per-core scope, feature split lock
detection can be exposed to guest only when SMT is disabled/unsupported.

Changes in v8:
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

Xiaoyao Li (4):
  kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
  kvm: vmx: Enable MSR TEST_CTRL for guest
  x86/split_lock: Export sld_update_msr() and sld_state
  kvm: vmx: virtualize split lock detection

 arch/x86/include/asm/cpu.h      | 12 +++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kernel/cpu/intel.c     | 13 ++----
 arch/x86/kvm/cpuid.c            |  3 +-
 arch/x86/kvm/vmx/vmx.c          | 83 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h          |  2 +
 arch/x86/kvm/x86.c              | 35 +++++++++++++-
 7 files changed, 132 insertions(+), 17 deletions(-)

-- 
2.20.1

