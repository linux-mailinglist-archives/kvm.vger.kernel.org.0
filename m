Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843C072E3EE
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 15:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242034AbjFMNT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 09:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242530AbjFMNTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 09:19:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B4CE6
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 06:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686662393; x=1718198393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pNFH4JwPCYF8TBeuPI1XWTw8Bh3QnsIP8OvvAgHWW74=;
  b=NjHbJM/eeSkfTFrCrvaI+AYxsPMM79yc9d0pUxcAR8Ybi6z6E1WQxP0J
   nfWwjD2JX98VUHN1DvfTOz7tUjaBIYH7dutYsGwAO/BzjGm99kdLchgdZ
   Gzxm+BtYxB8wfjkdLaXp36e7Ct9HsxNqMYAG8o+goopl+kI4iDSbtCGLL
   /U24hvZPSeETqmWuMITFxxFKlGGgkqDhNFhtp+s+Y01b2P2PniiTetfqc
   Ymd22oJdP8gqbP5MxV/FyFN/GQEQmNVOFCvvurzBU8LLzpqudrW7fHvPa
   uZfOWxYl0ceSRuiko38e7I41+DY74Mv9QewOXbs2+OHnglAZDRHB2xOQU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361696808"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="361696808"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="744680318"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="744680318"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 06:19:52 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH v2 1/3] i386/cpuid: Decrease cpuid_i when skipping CPUID leaf 1F
Date:   Tue, 13 Jun 2023 09:19:27 -0400
Message-Id: <20230613131929.720453-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613131929.720453-1-xiaoyao.li@intel.com>
References: <20230613131929.720453-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Decrease array index cpuid_i when CPUID leaf 1F is skipped, otherwise it
will get an all zero'ed CPUID entry with leaf 0 and subleaf 0. It
conflicts with correct leaf 0.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6b1..afa97799d89a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1956,6 +1956,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
         case 0x1f:
             if (env->nr_dies < 2) {
+                cpuid_i--;
                 break;
             }
             /* fallthrough */
-- 
2.34.1

