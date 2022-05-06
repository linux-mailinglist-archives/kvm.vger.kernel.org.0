Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A5251CF9D
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388685AbiEFDhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388624AbiEFDhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2F734B89;
        Thu,  5 May 2022 20:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808010; x=1683344010;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jWl1D5slKk6w7g0PrJ06g4GuOXgOsDIIVfKaaFlJcrU=;
  b=AY5pqZSX7/qfGtmXbYqGT9kzZP8XT4X8b2HHHI0xh76DWSrH71dbzHOA
   NaflWsb3Ucyr27+rEuMD1UK5UUuM9f4s0HrhTSwG+3+PW2oPU7OlJ+tf7
   hFbjogcVSLAZlWfi0qvlcZeAXoGI0+fa1VRVA1FJhMduphRlGfOKGvMMX
   jgTd/kx/dxTmmMWVL7c1fNqNCAd/xivwDSM2DpqotD611gqQzg58AE7PO
   XMN1gu0CalBd/iccAQ4OFGU7og6ByK73YBZoPt6RPc9odwhkB/4hNh+oi
   GxRD8bY9i4Tdjs4n9/AwZ9425zQBZZr077gBYwfgKTug8S4/9IZxndYfq
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241398"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241398"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:30 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745146"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 00/16] Introduce Architectural LBR for vPMU
Date:   Thu,  5 May 2022 23:32:49 -0400
Message-Id: <20220506033305.5135-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel CPU model-specific LBR(Legacy LBR) evolved into Architectural
LBR(Arch LBR[0]), it's the replacement of legacy LBR on new platforms.
The native support patches were merged into 5.9 kernel tree, and this
patch series is to enable Arch LBR in vPMU so that guest can benefit
from the merits of the feature.

The main advantages of Arch LBR are [1]:
- Faster context switching due to XSAVES support and faster reset of
  LBR MSRs via the new DEPTH MSR
- Faster LBR read for a non-PEBS event due to XSAVES support, which
  lowers the overhead of the NMI handler.
- Linux kernel can support the LBR features without knowing the model
  number of the current CPU.

From end user's point of view, the usage of Arch LBR is the same as
the Legacy LBR that has been merged in the mainline.

Note, in this series, we impose one restriction for guest Arch LBR:
Guest can only set the same LBR record depth as host, this is due to
the special behavior of MSR_ARCH_LBR_DEPTH: 1) On write to the MSR,
it'll reset all Arch LBR recording MSRs to 0s. 2) XRSTORS resets all
record MSRs to 0s if the saved depth mismatches MSR_ARCH_LBR_DEPTH.
Enforcing the restriction keeps the KVM enabling patch simple and
straightforward.

[0] https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

Qemu patch:
https://patchwork.ozlabs.org/project/qemu-devel/cover/20220215195258.29149-1-weijiang.yang@intel.com/

Previous version:
v10: https://lore.kernel.org/all/20220422075509.353942-1-weijiang.yang@intel.com/

Changes in v11:
1. Moved MSR_ARCH_LBR_DEPTH/CTL check code to a unified function.[Kan]
2. Modified some commit messages per Kan's feedback.
3. Rebased the patch series to 5.18-rc5.

Like Xu (6):
  perf/x86/intel: Fix the comment about guest LBR support on KVM
  perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
  KVM: x86: Refine the matching and clearing logic for supported_xss
  KVM: x86: Add XSAVE Support for Architectural LBR

Sean Christopherson (1):
  KVM: x86: Report XSS as an MSR to be saved if there are supported
    features

Yang Weijiang (9):
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
  KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
  KVM: x86/pmu: Refactor code to support guest Arch LBR
  KVM: x86/vmx: Check Arch LBR config when return perf capabilities
  KVM: nVMX: Add necessary Arch LBR settings for nested VM
  KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
  KVM: x86/vmx: Flip Arch LBREn bit on guest state change
  KVM: x86: Add Arch LBR data MSR access interface
  KVM: x86/cpuid: Advertise Arch LBR feature in CPUID

 arch/x86/events/intel/core.c     |   3 +-
 arch/x86/events/intel/lbr.c      |   6 +-
 arch/x86/include/asm/kvm_host.h  |   3 +
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/vmx.h       |   4 +
 arch/x86/kvm/cpuid.c             |  49 +++++++++-
 arch/x86/kvm/vmx/capabilities.h  |   8 ++
 arch/x86/kvm/vmx/nested.c        |   7 +-
 arch/x86/kvm/vmx/pmu_intel.c     | 157 ++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmcs12.c        |   1 +
 arch/x86/kvm/vmx/vmcs12.h        |   3 +-
 arch/x86/kvm/vmx/vmx.c           |  65 ++++++++++++-
 arch/x86/kvm/x86.c               |  23 ++++-
 13 files changed, 295 insertions(+), 35 deletions(-)


base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
-- 
2.27.0

