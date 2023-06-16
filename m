Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A123732FED
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 13:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245214AbjFPLez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 07:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344038AbjFPLeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 07:34:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED9B2720;
        Fri, 16 Jun 2023 04:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686915289; x=1718451289;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AKKeQORNxyoIr55evresNhecisiAb3zFzExDFUiE9pw=;
  b=YcG8Yg5pOPGzbscLUJ3zXBps2izdrd1CnfuIubRr5Q2+wqOrS+ifFdHL
   10Y2SGu0g8NLa0Y+w8attK+JIGNp6LdI8h/OyAHCY3NUWHk0hMe25WSjV
   rLcwCs+BO1e88lJskr+DmnQBAZuYyzWu5dv5dJyDe4BkC5RCAtILOSo7h
   9nwCW/3gv8NfTIa478px2Gbk1DBXzwQziW//S6+LKp958qkBAvCxOESas
   n7jnB/OsBChKvBRNtHlMkH+Vf5USf4UNeUfbSBngjq/lXDAzEBAowy2/3
   v69E/GreIe01E+eJ4C8FG6iC8ZNYdn7G/bkMbJUaZyVQTsajYoX2l5Yq0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445574753"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="445574753"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:34:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782872274"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="782872274"
Received: from youzhiji-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.249.173.213])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:34:46 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 0/4] Part of fix for host and guest LBR event coexist
Date:   Fri, 16 Jun 2023 19:33:49 +0800
Message-Id: <20230616113353.45202-1-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perf has four types of events: per cpu pinned event, per process pinned
event, per cpu event, per process event, their priority are from high to
low. This means higher priority event could premmpt lower prority event
and owns hardware resource. Perf scheduler activates an event on specific
cpu through sending ipi to the target cpu.

When guest access LBR msr at the first time, kvm will create a per process
pinned vLBR event which take part in perf scheduler. When vLBR event is
active, LBR will be owned by guest and guest could access LBR msr. When
vLBR event is inactive, LBR is ownned by host and guest couldn't access LBR
msr.

But current vLBR event is always active even if LBR is owned by host higher
prority per cpu pinned LBR event, this violates perf scheduler's rule. vLBR
event is a kind of perf event and doesn't have any special for perf
scheduler, it should follow perf scheduler's rule.

This patchset try to fix this violation, make vLBR event not break host,
and expects the following results when host and guest LBR event coexist:
1. If host per cpu pinned LBR event is active when vm starts, guest vLBR
event couldn't preempt LBR, so guest couldn't use LBR.
2. If host other LBR events are active when vm starts, guest vLBR event
could preempt LBR, so guest could use LBR.
3. If host per cpu pinned LBR event begin active when guest vLBR event is
active, guest vLBR event will lose LBR and guest couldn't use LBR anymore.
4. If host other LBR events begin active when guest vLBR event is active,
guest vLBR event keeps LBR, guest could still use LBR.
5. If host per cpu pinned LBR event becomes inactive when guest vLBR event
is inactive, guest vLBR event could be active and own LBR, so guest could
use LBR.

In the first three commits, each commit fix an issue when host and guest
LBR coexist, the fourth commit add a kernel selftests to cover the above
cases when host and guest LBR coexist.

Even with this patchset, the coexist of host and guest perf LBR events
still has gap, actually this gap exists in vPMU arch when host and guest
perf event coexist, kvm guest perf event could be inactive in two cases:
1. Counter or hw resource is full at kvm guest perf event creataion.
2. host higher priority event preempts kvm guest perf event in vm exit
handler.
But current guest couldn't get any notification about these failure, and
guest think its PMU still works, then get wrong data. Maybe some PV
interface is needed.

Perf command to create per cpu pinned LBR event:
perf record -b -a -e instructions:D

Xiong Zhang (4):
  perf/x86/intel: Get shared reg constraints first for vLBR
  KVM: VMX/pmu: Save host debugctlmsr just before vm entry
  KVM: vmx/pmu: Enable inactive vLBR event in guest LBR MSR emulation
  KVM:X86:selftests: Add test case for guest and host LBR preemption

 arch/x86/events/intel/core.c                  |   6 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |   9 +-
 arch/x86/kvm/vmx/vmx.c                        |   5 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/ucall_common.h      |  17 ++
 .../kvm/x86_64/pmu_event_filter_test.c        |  16 --
 .../kvm/x86_64/vmx_pmu_lbr_contend.c          | 171 ++++++++++++++++++
 7 files changed, 201 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c

-- 
2.25.1

