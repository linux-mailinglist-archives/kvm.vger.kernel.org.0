Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14110646912
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLHGZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLHGZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:25:19 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5549848767
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 22:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670480718; x=1702016718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G8LA9vVA0WKBbYhT4If4VLWUJUlVJA5e/5pnoBEZ5hY=;
  b=lpXqmpSoNZcRQM7aJqCjLxA+wSYzy7AmiZSwT9tAe2ERwoce2Sg7dm+4
   +EW9bHX+STj/tv6KpBaD2ZbfkwegnvCn7nZ+udonDsd8BAAqAl4Zzl4J8
   ICDSRsBg55P8QumbSFdxkBplBFiqaWkqTVlXDc9VFGZSvunOaeBX+9g0N
   HpUq9LkBBC+Z4LWBKGdLYyKZ1CYWfYb960LS90h89CKRFAdWQNcVTQVUb
   pXbLCa2wCJ1z7c9pmqdIYvKf0vrI1GQJMFYmdGGqzhFVxB99vkoqF07m0
   NCV1hUOQk9NQS7DLN1r7KdpRBd3MGTCUbjUcY7Ud92lRfGypJGJ0l7L/0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297444446"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="297444446"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:25:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679413383"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679413383"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 22:25:15 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com
Subject: [PATCH v3 1/8] target/i386: Print CPUID subleaf info for unsupported feature
Date:   Thu,  8 Dec 2022 14:25:06 +0800
Message-Id: <20221208062513.2589476-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221208062513.2589476-1-xiaoyao.li@intel.com>
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
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

Some CPUID leaves have meaningful subleaf index. Print the subleaf info
in feature_word_description for CPUID features.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 22b681ca37dd..8d95202f6a42 100644
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

