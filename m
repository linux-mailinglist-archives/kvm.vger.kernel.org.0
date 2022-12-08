Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F529646911
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLHGZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHGZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:25:18 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8669F1F2EC
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 22:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670480717; x=1702016717;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qDHJxDVeH6abLeuhfZMFLLz0ASkkMeSjff0rLV5DuDQ=;
  b=X1ryVOHQELnKGVKsU12FJAgDDHbgMWaCraU8k84Zen3dBG1ZaZ+bF9Sd
   tKgu5Mxeqk62OAzTxSuF74gguowaB8wJgsy/IPgsXZAPypXAL/Ec3fQon
   CP0cV0xmQeQmXDsp9TNx8FQL2SQnAcBaN7jLCZGByRkOShzPoE11SzW7c
   cxVXVdu6fPl9RbEursJ9dnrbD7J6B3id/ksbtpYs0XShMJR5U8lqgrnJ6
   Id4L9GYyWSLYgpS9umNf0Xa9kBmPVu8afCmB8wQXXreNN48hN/wFxxCyz
   kCYwKHB1r8JaUNgNo1eNHWgY2jSTQoEtE2uiqmBkcGRvZDLBMDUtWSnYx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297444442"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="297444442"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:25:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679413372"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679413372"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 22:25:14 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com
Subject: [PATCH v3 0/8] Make Intel PT configurable
Date:   Thu,  8 Dec 2022 14:25:05 +0800
Message-Id: <20221208062513.2589476-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initial virtualization of Intel PT was added by making it as fixed
feature set of ICX's capabilities. However, it breaks the Intel PT exposure
on SPR machine because SPR has less PT capabilities of
CPUID(0x14,1):EBX[15:0].

This series aims to make Intel PT configurable that named CPU model can
define its own PT feature set and "-cpu host/max" can use host pass-through
feature set of Intel PT.

At the same time, it also ensures existing named CPU model to generate
the same PT CPUID set as before to not break live migration.

Changes in v3:
- rebase to v7.2.0-rc4
- Add bit 7 and 8 of FEAT_14_0_EBX in Patch 3

v2: https://lore.kernel.org/qemu-devel/20220808085834.3227541-1-xiaoyao.li@intel.com/
Changes in v2:
- split out 3 patches (per Eduardo's comment)
- determine if the named cpu model uses default Intel PT capabilities (to
  be compatible with the old behavior) by condition that all PT feature
  leaves are all zero.

v1: https://lore.kernel.org/qemu-devel/20210909144150.1728418-1-xiaoyao.li@intel.com/

Xiaoyao Li (8):
  target/i386: Print CPUID subleaf info for unsupported feature
  target/i386/intel-pt: Fix INTEL_PT_ADDR_RANGES_NUM_MASK
  target/i386/intel-pt: Introduce FeatureWordInfo for Intel PT CPUID
    leaf 0x14
  target/i386/intel-pt: print special message for
    INTEL_PT_ADDR_RANGES_NUM
  target/i386/intel-pt: Rework/rename the default INTEL-PT feature set
  target/i386/intel-pt: Enable host pass through of Intel PT
  target/i386/intel-pt: Define specific PT feature set for
    IceLake-server and Snowridge
  target/i386/intel-pt: Access MSR_IA32_RTIT_ADDRn based on guest CPUID
    configuration

 target/i386/cpu.c     | 293 +++++++++++++++++++++++++++++++-----------
 target/i386/cpu.h     |  40 +++++-
 target/i386/kvm/kvm.c |   8 +-
 3 files changed, 263 insertions(+), 78 deletions(-)

-- 
2.27.0

