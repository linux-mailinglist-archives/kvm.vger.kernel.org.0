Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F1558C52B
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241883AbiHHI6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239780AbiHHI6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:58:39 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B23DFE0
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 01:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949117; x=1691485117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PjZ1u2QturzYjKa031f0MFI5soukUiMr35knNOFdceY=;
  b=m/m1ppgRg3hr6dSdVCjXvxTxB4ftLWvXyQd7bb0l/qcWVJQNBeKkp+dE
   HW89zWve5zKWBJ6EW6tpTORyu9JHyK9ssakUrgbOQDnYPx8XxU4PUNuDp
   2/Vi13eWowowti4KVXgCKVeAhZgeF8WGHH/7aumv2bvsDWpdsDl2Wilob
   Im+3pBwNJPm4ZbHRjgItiKLRZeZ10iZiVdEa6qTImR+RLEUhVd+v9n3ZP
   Y4rzk/mHZnr0BYW9Voe6L28VyZT0QPf9FrzGCItv7xQzIXB0OOP5TkDl/
   WlJOmvM4RMV5M3WL3uq+mP+DZ6ttC3kCreeeBNR8FK6UNZqnRWk0fcnqf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="376835047"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="376835047"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 01:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="931970536"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 01:58:36 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 1/8] target/i386: Print CPUID subleaf info for unsupported feature
Date:   Mon,  8 Aug 2022 16:58:27 +0800
Message-Id: <20220808085834.3227541-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220808085834.3227541-1-xiaoyao.li@intel.com>
References: <20220808085834.3227541-1-xiaoyao.li@intel.com>
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

Some CPUID leaves have meaningful subleaf index. Print the subleaf info
in feature_word_description for CPUID features.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1db1278a599b..f9646e16b872 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4244,8 +4244,9 @@ static char *feature_word_description(FeatureWordInfo *f, uint32_t bit)
         {
             const char *reg = get_register_name_32(f->cpuid.reg);
             assert(reg);
-            return g_strdup_printf("CPUID.%02XH:%s",
-                                   f->cpuid.eax, reg);
+            return g_strdup_printf("CPUID.%02XH_%02XH:%s",
+                                   f->cpuid.eax,
+                                   f->cpuid.needs_ecx ? f->cpuid.ecx : 0, reg);
         }
     case MSR_FEATURE_WORD:
         return g_strdup_printf("MSR(%02XH)",
-- 
2.27.0

