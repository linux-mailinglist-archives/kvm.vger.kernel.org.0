Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E680D7D48F6
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjJXHux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjJXHuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:50:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0295E5;
        Tue, 24 Oct 2023 00:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698133849; x=1729669849;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pBPmX8plw4xqxvX7zjZCy6fPKvlgK/+i1hyGOGqL9Is=;
  b=HUBkLDNwzLRE9Yjk0jVKDr8/DgJ6r6TifBN3ZlcwFfJ8AshAhzmGrO5I
   ym0XfEp1oEcVFIQM0r4dmwKdi62WaefhrKiqce8EGdLXy9m0EiEK33qUb
   IbUpfohuedNpVba/xP+sd17s2capGPw2E7f9shk5QsLoqcfUNEpC6gSW2
   TREHWqc77/LbrBbhJURlqhnp3uSGG0F/ECd4lY+shlvBJcz3e3/mu/HDr
   VS849fvMyxLco9glR+A7Oay1VBZPmH74SN0Av8HtB2fhw9KEkey6CWsMh
   S1maMJMgpuN6zBFDKb2hI+PYery78P5xKCb7v3EiQjn+FWHkBYH8rZy+c
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="367235163"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="367235163"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 00:50:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="1089766162"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="1089766162"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2023 00:50:40 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch 0/5] Fix PMU test failures on Sapphire Rapids
Date:   Tue, 24 Oct 2023 15:57:43 +0800
Message-Id: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running pmu test on Intel Sapphire Rapids, we found several
failures are encountered, such as "llc misses" failure, "all counters"
failure and "fixed counter 3" failure.

Intel Sapphire Rapids introduces new fixed counter 3, total PMU counters
including GP and fixed counters increase to 12 and also optimizes cache
subsystem. All these changes make the original assumptions in pmu test
unavailable any more on Sapphire Rapids. Patches 2-4 fixes these
failures, patch 0 remove the duplicate code and patch 5 adds assert to
ensure predefine fixed events are matched with HW fixed counters.

Dapeng Mi (4):
  x86: pmu: Change the minimum value of llc_misses event to 0
  x86: pmu: Enlarge cnt array length to 64 in check_counters_many()
  x86: pmu: Support validation for Intel PMU fixed counter 3
  x86: pmu: Add asserts to warn inconsistent fixed events and counters

Xiong Zhang (1):
  x86: pmu: Remove duplicate code in pmu_init()

 lib/x86/pmu.c |  5 -----
 x86/pmu.c     | 17 ++++++++++++-----
 2 files changed, 12 insertions(+), 10 deletions(-)


base-commit: bfe5d7d0e14c8199d134df84d6ae8487a9772c48
-- 
2.34.1

