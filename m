Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B9E615C3D
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKBGYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKBGYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:24:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056A625EB6;
        Tue,  1 Nov 2022 23:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667370262; x=1698906262;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gARuuG7HD+xbGdiUK285S5OvPad2Kt8//awvHDfDUZg=;
  b=TMrKUOgD2FFqJeIDcpRxIRMySVToCLcIB62NezoXhKTYRwnBppCW/Ygf
   LtNDZzqnuKIaf98PWUQ5OTQom+FzwepJe15gMpfl7h62RLh+qVsaUvjGT
   jtZzjpaHTtH83oTW2splyTltBMZasf8NSnqfwJ08gtWNa3L2TSnLvcSnt
   TnscBTjMWXQHLWsyqudIXF8u7ROyIC+NAaE8HqXXEi4E8ba88Om7Cucgf
   P5z6LZYpTPQtiV2kQwQIFXY48WlvT1Vy4x55quAw8K6NwyEKYmAyTLRpq
   H5GZQsvjVduxmYZiB4IPkG9Pv6bLEXwpxlprDzlnhv+no2jxZeoY41faU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="296765000"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="296765000"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="703146393"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="703146393"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH 0/4] KVM: simplify hardware initialization
Date:   Tue,  1 Nov 2022 23:24:07 -0700
Message-Id: <cover.1667369456.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series include random simplifications of KVM hardware enable/disable.
Although the past attempt [1] was turned out to be a bad idea, it has still
useful patches.  This is small subset of [1].

[1] https://lore.kernel.org/kvm/cover.1663869838.git.isaku.yamahata@intel.com/

Isaku Yamahata (3):
  KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
  KVM: Make cpus_hardware_enabled cpumask_t instead of cpumask_var_t
  KVM: kvm_main.c: Remove a global variable, hardware_enable_failed

Marc Zyngier (1):
  KVM: arm64: Simplify the CPUHP logic

 arch/arm64/kvm/arch_timer.c     | 27 +++++++------------
 arch/arm64/kvm/arm.c            | 13 +++++++++
 arch/arm64/kvm/vgic/vgic-init.c | 19 ++-----------
 include/kvm/arm_arch_timer.h    |  4 +++
 include/kvm/arm_vgic.h          |  4 +++
 include/linux/cpuhotplug.h      |  3 ---
 virt/kvm/kvm_main.c             | 48 ++++++++++++++++-----------------
 7 files changed, 56 insertions(+), 62 deletions(-)

-- 
2.25.1

