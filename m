Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43AE50B255
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445203AbiDVH62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241901AbiDVH6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:58:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D434647;
        Fri, 22 Apr 2022 00:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650614130; x=1682150130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TTlys0LYzTyNFpi4dCe718cEy03R8baV3CHMRO2CkLw=;
  b=KKx1ZjNP5/y/JqkF1wYQtlr4UbSxzkNjttmBRsfxj5SgkqGICa2k2I0X
   9avGzL9CBiKsJxKZStsLoCVAUOhZ+oaAQ585PwvGNST2O2QodRx0mxVIx
   fYsgSK50LWj2CnnmjbFODuet+zkf//JhF3LQptlKh0mQC99tZpYQAu+xJ
   17H7fjCrxF3sQXSUix+iVuiHXnumOj0LDE7OkNys0wDklxus86/5/1J/Y
   P0+KoIU0NmGb4IvWR6IPoofofM1EWV0XbxsXpOuN/vBGVTzstFS/wB+ea
   U927VZyQI+NQgutTggtFmDEJ8vpLbHxmn8YTTxp0WfJAB/3FWosOx5ZFl
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264384822"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="264384822"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="577741312"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:29 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 00/16] Introduce Architectural LBR for vPMU
Date:   Fri, 22 Apr 2022 03:54:53 -0400
Message-Id: <20220422075509.353942-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
v9: https://lore.kernel.org/all/20220215212544.51666-1-weijiang.yang@intel.com/

Changes in v10:
1. Refactored XSS related patch due to mainline evolvement.
2. Removed unnecessary guest fpu load/put helpers when accessing guest LBR MSRs.
3. Rebase the patch series to 5.18-rc2.


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
 arch/x86/kvm/vmx/pmu_intel.c     | 155 ++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmcs12.c        |   1 +
 arch/x86/kvm/vmx/vmcs12.h        |   3 +-
 arch/x86/kvm/vmx/vmx.c           |  65 ++++++++++++-
 arch/x86/kvm/x86.c               |  23 ++++-
 13 files changed, 294 insertions(+), 34 deletions(-)


base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
-- 
2.27.0

