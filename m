Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3173258C52A
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbiHHI6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiHHI6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:58:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F63813E38
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949116; x=1691485116;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pvMgcmAhjFBY6Z506Vgh8jh6X3m82T4afmcR2kHV3X8=;
  b=Ny+MHxvIDeyYtMMp79W5CyQ81jRESqEtOl55iT81wVJzBd1wobpgrqD7
   uT+cw64UZ0+ePxad0ZQZwibXiYkSW27QCEVZ52klmEf0UsQt0K6g2ejkC
   i7GJ5bKVTXVrB06ssrkK3SUkQfxjhSjIRJTkOgx57l/3lq8OIUcU9Kba5
   LFuaiflvx+tBS02v2KjkWi5XXEtMB2ZXEwWQX/qChUblHffTmA+JYJCmr
   kzOEx6sI7BknV4JdLmjIVczMh+o39a5ZrvJnU9IX0Wd42JFxuI86IqBGr
   Yf7VymNrPc1fZdbRUPHb08OM9qMNcFgcHvjUSpa89h4VyKfeiMPZsA6xm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="376835040"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="376835040"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 01:58:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="931970528"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 01:58:34 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 0/8] Make Intel PT configurable
Date:   Mon,  8 Aug 2022 16:58:26 +0800
Message-Id: <20220808085834.3227541-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
    leaf 0xD
  target/i386/intel-pt: print special message for
    INTEL_PT_ADDR_RANGES_NUM
  target/i386/intel-pt: Rework/rename the default INTEL-PT feature set
  target/i386/intel-pt: Enable host pass through of Intel PT
  target/i386/intel-pt: Define specific PT feature set for
    IceLake-server and Snowridge
  target/i386/intel-pt: Access MSR_IA32_RTIT_ADDRn based on guest CPUID
    configuration

 target/i386/cpu.c     | 291 +++++++++++++++++++++++++++++++-----------
 target/i386/cpu.h     |  40 +++++-
 target/i386/kvm/kvm.c |   8 +-
 3 files changed, 261 insertions(+), 78 deletions(-)

-- 
2.27.0

