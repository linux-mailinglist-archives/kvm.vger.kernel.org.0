Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B9073257A
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 04:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbjFPC4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 22:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFPC4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 22:56:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0442953;
        Thu, 15 Jun 2023 19:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884182; x=1718420182;
  h=from:to:cc:subject:date:message-id;
  bh=8VIZmxQ4ewUIEgXvqW8D+CvNYsj9X/EEEf+Oj1jPeU8=;
  b=JMeNA8N02PUowU8lAkp3tV+1tMiWX+VTj8jqqG2bRD5nXuwtiGNHkGps
   QBMeEVVRx6NbWWlxAT/X9ZFccppgDOszxliGr1Bj2Mmpqe3WjXQS5c6rw
   R3KnPMezH3eSdqDB9s82E5F4+v3LuKRX8phFoYQGRSsfDbbMF06zdsDjI
   4ajKAin4DIBLv5SejKz4Vz20oNG6HvRlogn/7XVXqzb8/4YtmVL9VbX4E
   cgG2a7Adc3rpurEgLX02swGpzZcZEFlziw5PXx9XUv2+q4pRLgDGEuUs4
   FuTueYXFWlLD+XrZPse8n7kzFvnnD1AH1DQXp0k80eLiGeBvcYimcoiiK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="425030927"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="425030927"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:56:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="706912916"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="706912916"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:56:19 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 00/11] KVM: x86/mmu: refine memtype related mmu zap
Date:   Fri, 16 Jun 2023 10:31:01 +0800
Message-Id: <20230616023101.7019-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series refines mmu zap caused by EPT memory type update when guest
MTRRs are honored.

The first 5 patches revolve around utilizing helper functions to check if
KVM TDP honors guest MTRRs, so that TDP zap and page fault max_level
reduction are only targeted to TDPs that honor guest MTRRs.

-The 5th patch will trigger zapping of TDP leaf entries if non-coherent
 DMA devices count goes from 0 to 1 or from 1 to 0.

The last 6 patches are fixes and optimizations for mmu zaps happen when
guest MTRRs are honored. Those mmu zaps are usually triggered from all
vCPUs in bursts on all GFN ranges, intending to remove stale memtypes of
TDP entries.

- The 6th patch places TDP zap to when CR0.CD toggles and when guest MTRRs
  update under CR0.CD=0.

- The 7th-8th patches refine KVM_X86_QUIRK_CD_NW_CLEARED by removing the
  IPAT bit in EPT memtype when CR0.CD=1 and guest MTRRs are honored.

- The 9th-11th patches are optimizations of the mmu zap when guest MTRRs
  are honored by serializing vCPUs' gfn zap requests and calculating of
  precise fine-grained ranges to zap.
  They are put in mtrr.c because the optimizations are related to when
  guest MTRRs are honored and because it requires to read guest MTRRs
  for fine-grained ranges.
  Calls to kvm_unmap_gfn_range() are not included into the optimization,
  because they are not triggered from all vCPUs in bursts and not all of
  them are blockable. They usually happen at memslot removal and thus do
  not affect the mmu zaps when guest MTRRs are honored. Also, current
  performance data shows that there's no observable performance difference
  to mmu zaps by turning on/off auto numa balancing triggered
  kvm_unmap_gfn_range().

A reference performance data for last 6 patches as below:

Base: base code before patch 6
C6-8: includes base code + patches 6 + 7 + 8
      patch 6: move TDP zaps from guest MTRRs update to CR0.CD toggling
      patch 7: drop IPAT in memtype when CD=1 for
               KVM_X86_QUIRK_CD_NW_CLEARED
      patch 8: move vmx code to get EPT memtype when CR0.CD=1 to x86 common
               code
C9:   includes C6-8 + patch 9
      patch 9: serialize vCPUs to zap gfn when guest MTRRs are honored
C10:  includes C9 + patch 10
      patch 10: fine-grained gfn zap when guest MTRRs are honored
C11:  includes C10 + patch 11
      patch 11: split a single gfn zap range when guest MTRRs are honored

vCPUs cnt: 8,  guest memory: 16G
Physical CPU frequency: 3100 MHz

     |              OVMF            |             Seabios          |
     | EPT zap cycles | EPT zap cnt | EPT zap cycles | EPT zap cnt |
Base |    3444.97M    |      84     |      61.29M    |      50     |
C6-8 |    4343.68M    |      74     |     503.04M    |      42     |*     
 C9  |     261.45M    |      74     |     106.64M    |      42     |     
 C10 |     157.42M    |      74     |      71.04M    |      42     |     
 C11 |      33.95M    |      74     |      24.04M    |      42     |     

* With C8, EPT zap cnt are reduced because there are some MTRR updates
  under CR0.CD=1.
  EPT zap cycles increases a bit (especially true in case of Seabios)
  because concurrency is more intense when CR0.CD toggles than when
  guest MTRRs update.
  (patch 7/8 are neglectable in performance)

Changelog:
v2 --> v3:
1. Updated patch 1 about definition of honor guest MTRRs helper. (Sean)
2. Added patch 2 to use honor guest MTRRs helper in kvm_tdp_page_fault().
   (Sean)
3. Remove unnecessary calculation of MTRR ranges.
   (Chao Gao, Kai Huang, Sean)
4. Updated patches 3-5 to use the helper. (Chao Gao, Kai Huang, Sean)
5. Added patches 6,7 to reposition TDP zap and drop IPAT bit. (Sean)
6. Added patch 8 to prepare for patch 10's memtype calculation when
   CR0.CD=1.
7. Added patches 9-11 to speed up MTRR update /CD0 toggle when guest
   MTRRs are honored. (Sean)
8. Dropped per-VM based MTRRs in v2 (Sean)

v1 --> v2:
1. Added a helper to skip non EPT case in patch 1
2. Added patch 2 to skip mmu zap when guest CR0_CD changes if EPT is not
   enabled. (Chao Gao)
3. Added patch 3 to skip mmu zap when guest MTRR changes if EPT is not
   enabled.
4. Do not mention TDX in patch 4 as the code is not merged yet (Chao Gao)
5. Added patches 5-6 to reduce EPT zap during guest bootup.

v2:
https://lore.kernel.org/all/20230509134825.1523-1-yan.y.zhao@intel.com/

v1:
https://lore.kernel.org/all/20230508034700.7686-1-yan.y.zhao@intel.com/

Yan Zhao (11):
  KVM: x86/mmu: helpers to return if KVM honors guest MTRRs
  KVM: x86/mmu: Use KVM honors guest MTRRs helper in
    kvm_tdp_page_fault()
  KVM: x86/mmu: Use KVM honors guest MTRRs helper when CR0.CD toggles
  KVM: x86/mmu: Use KVM honors guest MTRRs helper when update mtrr
  KVM: x86/mmu: zap KVM TDP when noncoherent DMA assignment starts/stops
  KVM: x86/mmu: move TDP zaps from guest MTRRs update to CR0.CD toggling
  KVM: VMX: drop IPAT in memtype when CD=1 for
    KVM_X86_QUIRK_CD_NW_CLEARED
  KVM: x86: move vmx code to get EPT memtype when CR0.CD=1 to x86 common
    code
  KVM: x86/mmu: serialize vCPUs to zap gfn when guest MTRRs are honored
  KVM: x86/mmu: fine-grained gfn zap when guest MTRRs are honored
  KVM: x86/mmu: split a single gfn zap range when guest MTRRs are
    honored

 arch/x86/include/asm/kvm_host.h |   4 +
 arch/x86/kvm/mmu.h              |   7 +
 arch/x86/kvm/mmu/mmu.c          |  18 +-
 arch/x86/kvm/mtrr.c             | 286 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  11 +-
 arch/x86/kvm/x86.c              |  25 ++-
 arch/x86/kvm/x86.h              |   2 +
 7 files changed, 333 insertions(+), 20 deletions(-)


base-commit: 24ff4c08e5bbdd7399d45f940f10fed030dfadda
-- 
2.17.1

