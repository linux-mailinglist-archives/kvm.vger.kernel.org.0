Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF075A8ADD
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiIABhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiIABhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0094115A22F;
        Wed, 31 Aug 2022 18:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996219; x=1693532219;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u3MQL7TjjSO4i53bJN9xBmsN6Fo6PT3JVtZ6S4PBn7w=;
  b=br7bhTHuK8QIWZGOYz+YzepnUOEfnRiK/RFmYBjMIqlvVDWoZ/vliN3B
   PNvPmWI/BGJYxmkksRsVOcu5oFXA1gEYXlYDFiZ3DiskKTVjO8ikCxVT3
   YuRGDTqddT/qTn/+ZLJTc5R55DbFt4eJFe/maSVSY2SIqOkef9CX6tlqP
   XGyjvgleoAx2crHanNuc0W6qIi3yJOhPxvllXOH/bjMxPZp/Al99hnVpi
   Ppl/ppJ6afw8jKIKhEzkopLgV08EzqjoOxYKGA2kj6Bx57uddBnsg+me+
   xYuaHaiJJzDGpRq+MzVRmRspaKhRRY/k0FPakf35jURkni4R9dm2ofsF7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735070"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735070"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:36:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754625958"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:36:59 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] Introduce Architectural LBR for vPMU
Date:   Wed, 31 Aug 2022 18:34:23 -0400
Message-Id: <20220831223438.413090-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel CPU model-specific LBR(Legacy LBR) evolved into Architectural
LBR(Arch LBR[0]), it's the replacement of legacy LBR on new platforms.
The native support patches were merged into 5.9 kernel tree, and this
patch series is to enable Arch LBR in vPMU so that guest can benefit
from the feature.

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

The old patch series was queued in KVM/queue for a while and finally
moved to below branch after Paolo's refactor. This new patch set is 
built on top of Paolo's work + some fixes, it's tested on legacy platform
(non-ArchLBR) and SPR platform(ArchLBR capable).

[0] https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

Original patch set:
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=lbr-for-weijiang

Changes in this version:
1. Fixed some minor issues in the refactored patch set.
2. Added a few minor fixes due to recent vPMU code cleanup.
3. Removed Paolo's SOBs in some modified patches.
4. Rebased to queue:kvm/kvm.git


Like Xu (3):
  perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
  KVM: x86: Add XSAVE Support for Architectural LBR

Paolo Bonzini (4):
  KVM: PMU: disable LBR handling if architectural LBR is available
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
  KVM: VMX: Support passthrough of architectural LBRs
  KVM: x86: Refine the matching and clearing logic for supported_xss

Sean Christopherson (1):
  KVM: x86: Report XSS as an MSR to be saved if there are supported
    features

Yang Weijiang (7):
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
  KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
  KVM: x86/vmx: Check Arch LBR config when return perf capabilities
  KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
  KVM: x86/vmx: Flip Arch LBREn bit on guest state change
  KVM: x86: Add Arch LBR data MSR access interface
  KVM: x86/cpuid: Advertise Arch LBR feature in CPUID

 arch/x86/events/intel/lbr.c      |   6 +-
 arch/x86/include/asm/kvm_host.h  |   3 +
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/vmx.h       |   4 +
 arch/x86/kvm/cpuid.c             |  52 +++++++++-
 arch/x86/kvm/vmx/capabilities.h  |   8 ++
 arch/x86/kvm/vmx/nested.c        |   8 ++
 arch/x86/kvm/vmx/pmu_intel.c     | 160 +++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c           |  81 +++++++++++++++-
 arch/x86/kvm/x86.c               |  27 +++++-
 10 files changed, 317 insertions(+), 33 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.27.0

