Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B197A9DDE
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjIUTuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjIUTuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:50:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5E25AE0F
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318597; x=1726854597;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EmG5Eh45xtaD5D+VoOd+bFg08s45xZv/g7dPcaJzDXY=;
  b=GI4RyYpRmh+4oWnD7ciVDilBml81uSJ012SKq8599Tozvxaz+P3lu785
   8vAyn9xIXpJbYDujlGjXH/A8UjduldKNIH/0g6N564iHnEjGz4FPMkvBh
   jhHFlDjtigdXWNWyUOFdD5ztHh5+EpLcxWb7gKctrUVofO4DPfME0HcQn
   hbxyIHSV5x5i5wXmrCka1C1A2I2IBQjR50Sxi6vgfd7g1kf3jHtWQ2llX
   qBeJ87Ppw1WJIiSwkFAlzD7HAPWRcFHzWq4OzD6LL92u7rloPUZXgQcS5
   y5C5ri64hxFSMZuUzWG3L/vz3reQzksa5V03BZnMKav/Iim2iwVlX8MlL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841304"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841304"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:30:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747000988"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747000988"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:30:44 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 0/9] Upgrade intel vPMU version to 5
Date:   Thu, 21 Sep 2023 16:29:48 +0800
Message-Id: <20230921082957.44628-1-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel recent processors have supported Architectural Performance
Monitoring Version 5, while Intel vPMU still keeps on version 2. In order
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
especially the user case for these features.

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
C-state. Guest ACPI C-state is vague, KVM has little information about
guest ACPI C-state. So this feature's emulation isn't supported.

Changes since v1:
* vLBR release bug not only happens in Freeze_LBR_On_PMI, but also happens
  on generic case. So the first commit fixes this bug. (Like Xu)
* Add new PERF_GLOBAL_STATUS_SET and PERF_GLOBAL_STATUS_INUSE MSRs into
  msrs_to_save_pmu[] (Like Xu)
* If INUSE_PMI bit is set, no need to write it again. (Like Xu)
* Get Fixed Counter enumeration from host for nested vPMU, but I marked it
  as Todo to wait for perf driver fixed counter bitmap supporting.

Reference:
[1]: perf/intel: Remove Perfmon-v4 counter_freezing support
https://lore.kernel.org/all/20201110153721.GQ2651@hirez.programming.kicks-ass.net/

Like Xu (1):
  KVM: x86/pmu: Add Intel PMU supported fixed counters mask

Xiong Zhang (8):
  KVM: x86/PMU: Delay vLBR release to the vcpu next sched-in
  KVM: x86/pmu: Don't release vLBR casued by vPMI
  KVM: x85/pmu: Add Streamlined FREEZE_LBR_ON_PMI for vPMU v4
  KVM: x86/pmu: Add PERF_GLOBAL_STATUS_SET MSR emulation
  KVM: x86/pmu: Add MSR_CORE_PERF_GLOBAL_INUSE emulation
  KVM: x86/pmu: Add fixed counter enumeration for pmu v5
  KVM: x86/pmu: Upgrade pmu version to 5 on intel processor
  KVM: selftests: Add fixed counters enumeration test case

 arch/x86/include/asm/kvm_host.h               |   1 -
 arch/x86/include/asm/msr-index.h              |   6 +
 arch/x86/kvm/cpuid.c                          |  10 +-
 arch/x86/kvm/pmu.c                            |   8 -
 arch/x86/kvm/pmu.h                            |  14 +-
 arch/x86/kvm/svm/pmu.c                        |   1 -
 arch/x86/kvm/vmx/pmu_intel.c                  | 205 +++++++++++++++---
 arch/x86/kvm/vmx/vmx.c                        |  19 +-
 arch/x86/kvm/vmx/vmx.h                        |   8 +
 arch/x86/kvm/x86.c                            |   1 +
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  79 +++++++
 11 files changed, 308 insertions(+), 44 deletions(-)


base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.34.1

