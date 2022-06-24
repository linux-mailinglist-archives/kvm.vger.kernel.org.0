Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0749D55960E
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 11:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiFXJJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 05:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiFXJJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 05:09:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62C44EF74
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 02:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656061759; x=1687597759;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XQ/caYneu9bKWmHbTy9v+P5D1Ppi4GA25vnPvt1khU4=;
  b=mZuixWpFZWALVwD/D/UgWjLvYQwQGv9PlLpJ9ZREpSLckIuGi5mG+xzh
   R8tfdh0Y/iVeTFTtOA/igpOzIh8gC9L5Odbz1zZAMFmN1CKPH8KbS6aCQ
   yOOQNANidHHbizc4oH48Wa+r6gzzf8beSXGTripp9wM2EBA8TelyEZdPG
   2iIEuoR/OLS7JHa9bEAIwFkRDkdlPLnjGVM0ASoo2M7J0u82ryusE/dHW
   ggK0ZMNKcfzVcfcr+wysSGan8NUP7gHAEyCS4aCCCkelpM1z0aBfj3XJI
   VDuzlIuCOJ9zGWIRWn4a6RS7VH4GUWMiS6IiOz5NL/nifY1HIFgjA/OQg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="278509304"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="278509304"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="539222080"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 02:09:19 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v3 0/3] Fix up test failures due to recent KVM changes
Date:   Fri, 24 Jun 2022 05:08:25 -0400
Message-Id: <20220624090828.62191-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently a few pmu KVM patches have been queued, and resulted into some test
failures based on the queue branch. Fix them in this series.

Patches were tested with below config:

kernel:
kvm/queue, commit 4284f0063c48

qemu:
master, commit 3a821c52e1a3

platform:
Skylake/Sapphire Rapids

v3:
1. Replaced msr test fixup with Paolo's patch at below link per
   Sean's comments, change RO bits to bit 11 and 12 due to Sean's
   commit 9fc222967a39 ("KVM: x86: Give host userspace full control of MSR_IA32_MISC_ENABLES")
   https://lore.kernel.org/all/20220520183207.7952-1-pbonzini@redhat.com/

2. Added helpers to check pmu verison and perf_global_ctrl MSR. [Sean]
3. Refactored pmu_lbr code with new helper.

Paolo Bonzini (1):
  x86: Don't overwrite bits 11 and 12 of MSR_IA32_MISC_ENABLE

Yang Weijiang (2):
  x86: Skip perf related tests when platform cannot support
  x86: Check platform vPMU capabilities before run lbr tests

 lib/x86/processor.h | 12 +++++++++++-
 x86/msr.c           |  8 +++++++-
 x86/pmu_lbr.c       | 32 +++++++++++++-------------------
 x86/vmx_tests.c     | 18 ++++++++++++++++++
 4 files changed, 49 insertions(+), 21 deletions(-)


base-commit: 610c15284a537484682adfb4b6d6313991ab954f
-- 
2.27.0

