Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680F96383C7
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKYGKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKYGKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:06 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19371F633;
        Thu, 24 Nov 2022 22:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356604; x=1700892604;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8UWDNe48EAaP9r+66pBn1fuXQNiyPhafj2xZXuM1ITM=;
  b=QGhkcwy87Hd1sUx4hTIOP8fQhEBIbAq4riRX4UISvX7BwglyASE41Po9
   aVIOsqg6ggIdmal9Id81q/xQLtaWjNGqcPwc4c/PgfksdTEcJcsVMX2k2
   tlZ2dicEJRsUq9kq2acW393U/A9dZOXDMX+yx94nctLZx7dGZbRG4cpid
   5e2GBClKm+yIvoV6p8MTs7rbYT7UB5ExyMzKjHeliwahUwaw3RnDhRKuD
   c3KGHwjUfZWmEn1oxs0uQ7ou0V9QOB13phdPJeA8DJrzyfhclhMKEtBxC
   4YZZyy0i2TmxeZAMJ/xcWjntw/9yjmn642m1e+NJRB90gup/piFhBT6B8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116789"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116789"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838441"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838441"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:00 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 00/15] Introduce Architectural LBR for vPMU
Date:   Thu, 24 Nov 2022 23:05:49 -0500
Message-Id: <20221125040604.5051-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel CPU model-specific LBR(Legacy LBR) has evolved to Architectural
LBR(Arch LBR [0]), it's the replacement of legacy LBR on new platforms.
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

Note, in this series, there's one restriction for guest Arch LBR, i.e.,
guest can only set its LBR record depth the same as host's. This is due
to the special behavior of MSR_ARCH_LBR_DEPTH: 
1) On write to the MSR, it'll reset all Arch LBR recording MSRs to 0s.
2) XRSTORS resets all record MSRs to 0s if the saved depth mismatches
MSR_ARCH_LBR_DEPTH.
Enforcing the restriction keeps KVM Arch LBR vPMU working flow simple
and straightforward.

Paolo refactored the old series and the resulting patches became the
base of this new series, therefore he's the author of some patches.

[0] https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

v1:
https://lore.kernel.org/all/20220831223438.413090-1-weijiang.yang@intel.com/

Changes v2:
1. Removed Paolo's SOBs from some patches. [Sean]
2. Modified some patches due to KVM changes, e.g., SMM/vPMU refactor.
3. Rebased to https://git.kernel.org/pub/scm/virt/kvm/kvm.git : queue branch.


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
  KVM: x86/vmx: Disable Arch LBREn bit in #DB and warm reset
  KVM: x86/vmx: Save/Restore guest Arch LBR Ctrl msr at SMM entry/exit
  KVM: x86: Add Arch LBR data MSR access interface
  KVM: x86/cpuid: Advertise Arch LBR feature in CPUID

 arch/x86/events/intel/lbr.c      |   6 +-
 arch/x86/include/asm/kvm_host.h  |   3 +
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/vmx.h       |   4 +
 arch/x86/kvm/cpuid.c             |  52 +++++++++-
 arch/x86/kvm/smm.c               |   1 +
 arch/x86/kvm/smm.h               |   3 +-
 arch/x86/kvm/vmx/capabilities.h  |   5 +
 arch/x86/kvm/vmx/nested.c        |   8 ++
 arch/x86/kvm/vmx/pmu_intel.c     | 161 +++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c           |  74 +++++++++++++-
 arch/x86/kvm/vmx/vmx.h           |   6 +-
 arch/x86/kvm/x86.c               |  27 +++++-
 13 files changed, 316 insertions(+), 35 deletions(-)


base-commit: da5f28e10aa7df1a925dbc10656cc89d9c061358
-- 
2.27.0

