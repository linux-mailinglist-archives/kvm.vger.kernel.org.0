Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D8C717A5F
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbjEaInW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbjEaInT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:43:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9D710B
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522598; x=1717058598;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+5VxqSApDTybbRqSSES1+Ai8coKoe4+HzHFHHa8plf8=;
  b=ISopDs9ncwWHDv7koROV3LH9kxoyrkh41H1lydGRk1cIXpB74md34DwP
   Stz0LqWq4VsBPX37xyLO3PM2penBRQb7EBWQyN1RzGvWqNugLxBJmXX4f
   31zvc8LjwGVJbbRX9CJBOxOqr+tB6a/fwT6wVImwGWM9E5pwMH4j0pRs7
   tpqHN4PWyhENj+Lknw1u/TJU/aIJHno7BX4vWqln36U4JQ5hIbf1Cuo31
   tx8kN/ewBSzdl0D00eIKEfjHQzN2gV+6kj9hsJ5UD1EjzAscmLnyWmGGi
   imC3zUUammbWIgZpidqCN/vuRCXMdywCXIxCMOI9vwbUxHdQNGEdsV9dx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669229"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669229"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956390"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956390"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:15 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 0/8] i386: Make Intel PT configurable 
Date:   Wed, 31 May 2023 04:43:03 -0400
Message-Id: <20230531084311.3807277-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

Changes in v4:
- rebase to 51bdb0b57a2d "Merge tag 'pull-tcg-20230530' of https://gitlab.com/rth7680/qemu into staging"
- cleanup Patch 6 by updating the commit message and remove unnecessary
  handlng;

v3: https://lore.kernel.org/qemu-devel/20221208062513.2589476-1-xiaoyao.li@intel.com/
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
    IceLake-server, Snowridge and SapphireRapids
  target/i386/intel-pt: Access MSR_IA32_RTIT_ADDRn based on guest CPUID
    configuration

 target/i386/cpu.c     | 293 +++++++++++++++++++++++++++++++-----------
 target/i386/cpu.h     |  39 +++++-
 target/i386/kvm/kvm.c |   8 +-
 3 files changed, 261 insertions(+), 79 deletions(-)

-- 
2.34.1

