Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0217D4AF0
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbjJXIwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbjJXIwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:52:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D88910CF
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 01:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698137550; x=1729673550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4opFv5gZlPghtdFYlMcRuhrtU9m/JKFpT86TK4Zq0gY=;
  b=loeoBdc2Ngz1tin4eGxHz2XvQskcETIWdcg6y4RV2Su/a/p2B6L2n3Xe
   weK41aHPER4vGyYxFEYeeCKbAUtoMv3CECMNNQ5edhdHzlnA7DwAosKVM
   0z/WWivR+WyYVg+MaHgY9DWvaRvS2N6f/DscZB5R/KxWQy6iy07fdVw79
   WoWqbS7ShpR2YXr+FQ+H3JMb9XCn6wKYUrBQ4ZCN2E2wzhZPWcTOIzUYi
   KsE1QWhudOrhIosUocU3revVswLo6dNv/YE7d3WmD8SKu/vP/TigB1T0f
   dee67JnInA7QJ/nNFmhCYefm2czcnWyfo0mw+WczdSZSNu9GPcAVRZAzQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="5638336"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="5638336"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="793417997"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="793417997"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 24 Oct 2023 01:52:25 -0700
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 05/20] i386/cpu: Fix i/d-cache topology to core level for Intel CPU
Date:   Tue, 24 Oct 2023 17:03:08 +0800
Message-Id: <20231024090323.1859210-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
References: <20231024090323.1859210-1-zhao1.liu@linux.intel.com>
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

From: Zhao Liu <zhao1.liu@intel.com>

For i-cache and d-cache, current QEMU hardcodes the maximum IDs for CPUs
sharing cache (CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits
25:14]) to 0, and this means i-cache and d-cache are shared in the SMT
level.

This is correct if there's single thread per core, but is wrong for the
hyper threading case (one core contains multiple threads) since the
i-cache and d-cache are shared in the core level other than SMT level.

For AMD CPU, commit 8f4202fb1080 ("i386: Populate AMD Processor Cache
Information for cpuid 0x8000001D") has already introduced i/d cache
topology as core level by default.

Therefore, in order to be compatible with both multi-threaded and
single-threaded situations, we should set i-cache and d-cache be shared
at the core level by default.

This fix changes the default i/d cache topology from per-thread to
per-core. Potentially, this change in L1 cache topology may affect the
performance of the VM if the user does not specifically specify the
topology or bind the vCPU. However, the way to achieve optimal
performance should be to create a reasonable topology and set the
appropriate vCPU affinity without relying on QEMU's default topology
structure.

Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Change the description of current i/d cache encoding status to avoid
   misleading to "architectural rules". (Xiaoyao)

Changes since v1:
 * Split this fix from the patch named "i386/cpu: Fix number of
   addressable IDs in CPUID.04H".
 * Add the explanation of the impact on performance. (Xiaoyao)
---
 target/i386/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 36214c84ec14..a3b170db108e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6112,12 +6112,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             switch (count) {
             case 0: /* L1 dcache info */
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    1, cs->nr_cores,
+                                    cs->nr_threads, cs->nr_cores,
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    1, cs->nr_cores,
+                                    cs->nr_threads, cs->nr_cores,
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
-- 
2.34.1

