Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DE478F916
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbjIAH3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjIAH3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:29:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD9B10D0
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693553351; x=1725089351;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YDwBbYg9yKdkIF5C8xiCR88O0FXB/MRGDKe6x/Y0zIc=;
  b=KkNtMMsdI/vNX9DLQeWoYUkJrNtVCUtULjf811oiefwgBHsNkwZRwsqx
   JwvHaDLrcc9+CLc7PBC4VskIXpOfxmZ/BjoQwUxjOGbRHg//Pd8/++3oz
   aSPOVsDIliTp3PGCvZe1cwzHyVL9MmzfroKE8gmWEIfqRBcJjx8KQm72I
   LwW4ra9S3zsJntO/RjQ0/3koalWi9tM0OMMw29bEvHJFdV9Xnsnr8DlJd
   GICGfCKKnoKJsgjB3XRxrEPgN0n4N/JXQ0/oTgfxLbWPcgRj8T68TpCLb
   TljJ/BDpygD/yYSX1NPu9c/zoHiAWkVMHnUr9X1w56z9v6rrTO6bootY+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="373550285"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="373550285"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="716671232"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="716671232"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:08 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 0/9] Upgrade vPMU version to 5
Date:   Fri,  1 Sep 2023 15:28:00 +0800
Message-Id: <20230901072809.640175-1-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
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

Intel recent processors have supported Architectural Performance
Monitoring Version 5, while kvm vPMU still keeps on version 2. In order
to use new PMU features introduced in version 4 and 5, this patchset
upgrades vPMU version to 5.

Go through PMU features from version 3 to 5, the following features are
supported by this patchset:
1. Streamlined Freeze LBR on PMI on version 4. This feature adds a new
bit IA32_MSR_PERF_GLOBAL_STATUS.LBR_FRZ[58], it will be set when PMI
happens and LBR stack is forzen. This bit also serves as a control to
enable LBR stack. SW should clear this bit at the end of PMI handler
to enable LBR stack.
2. IA32_PERF_GLOBAL_STATUS_RESET MSR on version 4. its address is
inherited from  IA32_PERF_GLOBAL_OVF_CTRL MSR, and they have the same
function to clear individual bits in IA32_PERF_GLOBAL_STATUS MSR.
3. IA32_PERF_GLOBAL_STATUS_SET MSR on version 4. it allows software to
set individual bits in IA32_PERF_GLOBAL_STATUS MSR.
4. IA32_PERF_GLOBAL_INUSE MSR on version 4. It provides an "InUse" bit
for each programmable performance counter and fixed counter in the
processor. Additionally, it includes an indicator if the PMI mechanisam
has been used.
5. Fixed Counter Enumeration on version 5. CPUID.0AH.ECX provides a bit
mask which enumerates the supported Fixed Counters in a processor.

For each added feature, the kvm emulation is straightforward and reflects
vPMU state, please see each feature's emulation code in the following
commits, a kvm unit test case or kernel selftests is added to verify
this feature's emultion. Kernel doesn't use feature 3 and 4, so
designed kvm unit test case is the only verification method for
feature 3 and 4. I'm afraid that I miss something for these features,
especially the user case for these features. So any suggestions and
usage are welcome.

While the following features are not supported:
1. AnyThread counting: it is added in v3, and deprecated in v5. so this
feature isn't supported.
2. Streamlined Freeze_PerfMon_On_PMI on version 4. Since legacy
Freeze_PerMon_On_PMI on version 2 isn't supported and community think
this feature has problems on native[1], so this feature's emulation
isn't supported.
3. IA32_PERF_GLOBAL_STATUS.ASCI[bit 60] on version 4. This new bit
relates to SGX, and will be emulated by SGX developer.
4. Domain Seperation on version 5. When INV flag in IA32_PERFEVTSELx is
used, a counter stops counting when logical processor exits the C0 ACPI
C-state. First guest INV flag isn't supported, second guest ACPI C-state
is vague. So this feature's emulation isn't supported.

Reference:
[1]: perf/intel: Remove Perfmon-v4 counter_freezing support
https://lore.kernel.org/all/20201110153721.GQ2651@hirez.programming.kicks-ass.net/


Like Xu (1):
  KVM: x86/pmu: Add Intel PMU supported fixed counters mask

Xiong Zhang (8):
  KVM: x86/PMU: Don't release vLBR caused by PMI
  KVM: x85/pmu: Add Streamlined FREEZE_LBR_ON_PMI for vPMU v4
  KVM: x86/pmu: Add PERF_GLOBAL_STATUS_SET MSR emulation
  KVM: x86/pmu: Add MSR_PERF_GLOBAL_INUSE emulation
  KVM: x86/pmu: Check CPUID.0AH.ECX consistency
  KVM: x86/pmu: Add fixed counter enumeration for pmu v5
  KVM: x86/pmu: Upgrade pmu version to 5 on intel processor
  KVM: selftests: Add fixed counters enumeration test case

 arch/x86/include/asm/kvm_host.h               |   1 -
 arch/x86/include/asm/msr-index.h              |   6 +
 arch/x86/kvm/cpuid.c                          |  32 ++-
 arch/x86/kvm/pmu.c                            |   8 -
 arch/x86/kvm/pmu.h                            |  17 +-
 arch/x86/kvm/svm/pmu.c                        |   1 -
 arch/x86/kvm/vmx/pmu_intel.c                  | 188 +++++++++++++++---
 arch/x86/kvm/vmx/vmx.c                        |  15 +-
 arch/x86/kvm/vmx/vmx.h                        |   3 +
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  84 ++++++++
 10 files changed, 312 insertions(+), 43 deletions(-)


base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
-- 
2.34.1

