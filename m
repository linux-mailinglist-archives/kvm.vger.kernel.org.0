Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B6B79FCE0
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbjINHMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjINHMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:12:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F48CCD
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675516; x=1726211516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0ZE8WKsDmhQnnfl28+IeLf/E4Fp5X9tcOON5zVdDyOs=;
  b=bep9QHuKYFJBQAUyfaTeEUd5LHYZcB54m16xwqPYO3kVVhsfXUs3rFG4
   5KEHr9UcoZmvz4704Ej5o+kk3HI+9rsmCtQfh050A9XDgfRU5SidcS1cj
   PNMHTAVybDytZPbzPwtn8zusvoJ0W4h5Ec4Tigg8RPHJR52vIlT36xLXd
   1ecUXYq7S3rz4ptQc0ISistdqBxaRSVftrffknCVGtWR7KK7Ct3N3qk7F
   AyDtxsVYSW38lPK65N9U6jnx/ro/kMiACCyzjpFmX+UtuoMp8tYwyr4rf
   BDrGr2EEZrXxqRUk785whk9R6J+j6X/WEiNK14ZmwH839/yC3Aao+Vmc5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359135981"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359135981"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:11:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526276"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526276"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:11:33 -0700
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
        Zhao Liu <zhao1.liu@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 05/21] i386/cpu: Fix i/d-cache topology to core level for Intel CPU
Date:   Thu, 14 Sep 2023 15:21:43 +0800
Message-Id: <20230914072159.1177582-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 709c055c8468..c5c2a045e032 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6108,12 +6108,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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

