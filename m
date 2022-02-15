Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8D34B859E
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiBPK1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiBPK1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:02 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CCA1DE88E;
        Wed, 16 Feb 2022 02:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007211; x=1676543211;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m+JmOIPg8/c6L0AeIIq3f/9AFdTuQIqLHDgz0afZf60=;
  b=WDlHVi+FXuWX6ZRyTsjOT142Dk7zD4XV1SCZ9gTD7WQ/7WY7VOhPvqHT
   VeQVmV7yYdO13lrNplI9m9lgbCXfNDgi3HVX+TegcGW2Ozmw9XRshlhHh
   2Kln2u+sGJtTd0XAVpKq1IngSEixdp3iCpW3omyftgygBjM3m/7u5q0Wk
   QWzEX9rkIWJvyWJcTLmSeslCeh2ijyc0NuDr4cmZUgXovN3v0Olo4NUic
   UOPCWBhoc4+DOhs7FxQBcK/oiR2gfIHnInGqvYt6hhalSVZoBFwig4h4G
   VqCUmjPRjkCfObfXNnlgCYSwn7Jk302mwLN8L7lZcXEiTC7Nn8SJ6UgM9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="231201145"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="231201145"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708563"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:50 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 00/17] Introduce Architectural LBR for vPMU
Date:   Tue, 15 Feb 2022 16:25:27 -0500
Message-Id: <20220215212544.51666-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Architectural Last Branch Records (LBRs) is published in release
Intel Architecture Instruction Set Extensions and Future Features
Programming Reference[0].

The main advantages of Arch LBR are [1]:
- Faster context switching due to XSAVES support and faster reset of
  LBR MSRs via the new DEPTH MSR
- Faster LBR read for a non-PEBS event due to XSAVES support, which
  lowers the overhead of the NMI handler.
- Linux kernel can support the LBR features without knowing the model
  number of the current CPU.

From end user's point of view, the usage of Arch LBR is the same as
the Legacy LBR that has been merged in the mainline.

Note, In this KVM series, we impose one restriction for guest Arch LBR:
Guest can only set the same LBR record depth as host, this is due to
the special behavior of MSR_ARCH_LBR_DEPTH: 1) On write to the MSR,
it'll reset all Arch LBR recording MSRs to 0s. 2) XRSTORS resets all
record MSRs to 0s if the saved depth mismatches MSR_ARCH_LBR_DEPTH.

But this restriction won't impact guest perf tool usage.

[0] https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

Qemu patch:
https://patchwork.ozlabs.org/project/qemu-devel/cover/20220215195258.29149-1-weijiang.yang@intel.com/

Previous version:
v8: https://lkml.kernel.org/kvm/1629791777-16430-1-git-send-email-weijiang.yang@intel.com/

Changes in v9:
1. Added Arch LBR MSR access interface for userspace.
2. Refactored XSS related dependent patches so that xsaves/xrstors can work for guest.
3. Refactored Arch LBR CTL and DEPTH MSR handling in KVM.
4. Rebased and tested on kernel base-commit: c5d9ae265b10

Like Xu (6):
  perf/x86/intel: Fix the comment about guest LBR support on KVM
  perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
  KVM: x86: Refine the matching and clearing logic for supported_xss
  KVM: x86: Add XSAVE Support for Architectural LBR

Sean Christopherson (2):
  KVM: x86: Report XSS as an MSR to be saved if there are supported
    features
  KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES

Yang Weijiang (9):
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
  KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
  KVM: x86/pmu: Refactor code to support guest Arch LBR
  KVM: x86/vmx: Check Arch LBR config when return perf capabilities
  KVM: nVMX: Add necessary Arch LBR settings for nested VM
  KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
  KVM: x86/vmx: Flip Arch LBREn bit on guest state change
  KVM: x86: Add Arch LBR MSR access interface
  KVM: x86/cpuid: Advertise Arch LBR feature in CPUID

 arch/x86/events/intel/core.c     |   3 +-
 arch/x86/events/intel/lbr.c      |   6 +-
 arch/x86/include/asm/kvm_host.h  |   7 ++
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/vmx.h       |   4 +
 arch/x86/kvm/cpuid.c             |  54 ++++++++++-
 arch/x86/kvm/vmx/capabilities.h  |   8 ++
 arch/x86/kvm/vmx/nested.c        |   7 +-
 arch/x86/kvm/vmx/pmu_intel.c     | 155 ++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmcs12.c        |   1 +
 arch/x86/kvm/vmx/vmcs12.h        |   3 +-
 arch/x86/kvm/vmx/vmx.c           |  65 ++++++++++++-
 arch/x86/kvm/x86.c               |  78 +++++++++++++++-
 13 files changed, 356 insertions(+), 36 deletions(-)

-- 
2.27.0

