Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F328A717A60
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbjEaInY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbjEaInU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:43:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B5210E
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522599; x=1717058599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tCe2NK+4wo5tYFcR9V7u1zkUeKhtImrp9c2scYoxMcc=;
  b=O3m88E1yrLn7941KYjuktQeXL1P9hb3rAqtnzbzR4bvZhdftsgKIMIol
   5T7BJ2TWWH8aqh7aT7Jv+QzmaZDKTg569LTdZrLWtUvRG2zmr5rQ3PWen
   Q1qX+UBLkcc7sAXxv3/gff3HsQTcnyYKZ/pBioQv1MDxVPFtXGnxoTer7
   gZag6++dGR1e9gIE3uhlBuIRKu6uGLnaRJydm7mRW1jWP/Yar63DOCpXw
   bP1pKlvJ9y8Q+nhXb/X+kmZ4NkiHbix2fkgRhWOqNGmZ5gzlt/v8L9oSy
   NxUvCsNcVePBBJiEVSsKHC2PwkWEysgBHGlVZgrToL3+a5umYtnTrXrw3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669243"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669243"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956395"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956395"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:17 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 1/8] target/i386: Print CPUID subleaf info for unsupported feature
Date:   Wed, 31 May 2023 04:43:04 -0400
Message-Id: <20230531084311.3807277-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230531084311.3807277-1-xiaoyao.li@intel.com>
References: <20230531084311.3807277-1-xiaoyao.li@intel.com>
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

Some CPUID leaves have meaningful subleaf index. Print the subleaf info
in feature_word_description for CPUID features.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1242bd541a53..88e90c1f7b7c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4745,8 +4745,9 @@ static char *feature_word_description(FeatureWordInfo *f, uint32_t bit)
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
2.34.1

