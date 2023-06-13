Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B8772E3EF
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 15:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242570AbjFMNUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 09:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242554AbjFMNT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 09:19:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94BB1AA
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 06:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686662396; x=1718198396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B5kXUdZwwuuOfUtptKN/wWx9SMd2e3OQhNjQfBpYiqM=;
  b=kfJVSzq5tiXw6gqtNHdUhm3tvCvTlEX+H0tAb2uVR9suMAGfVBgPlyeL
   huP6FStH9Mx2waDWxoF9T7nwSIG4p3eZGxj1hWyQ+93BYXg9YNYpsoAle
   hwuK0RnlRNZTWbcarQIfuenfUZLJJ41YsGbwD80HZdi939f5TEKodxFna
   Y8WOppRgMAalmXv8bql7aAa+hoopyTdjdcYDKSHJ/oMJ2w6IRz6bXk2em
   C7WMbMlatbJjEnbuw8XG/W7uFS2JBToYXtuHAkn8082UfElanxaVW4PEc
   lKdeDtB2FjRtdeeZOmhVcwnG3CQKVlPbzNPk1CVN5I7XCquepDsTwPg6n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361696826"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="361696826"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:19:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="744680355"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="744680355"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 06:19:55 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH v2 3/3] i386/cpuid: Move leaf 7 to correct group
Date:   Tue, 13 Jun 2023 09:19:29 -0400
Message-Id: <20230613131929.720453-4-xiaoyao.li@intel.com>
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

CPUID leaf 7 was grouped together with SGX leaf 0x12 by commit
b9edbadefb9e ("i386: Propagate SGX CPUID sub-leafs to KVM") by mistake.

SGX leaf 0x12 has its specific logic to check if subleaf (starting from 2)
is valid or not by checking the bit 0:3 of corresponding EAX is 1 or
not.

Leaf 7 follows the logic that EAX of subleaf 0 enumerates the maximum
valid subleaf.

Fixes: b9edbadefb9e ("i386: Propagate SGX CPUID sub-leafs to KVM")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d7e235ce35a6..86aab9ca4ba2 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1993,7 +1993,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 c = &cpuid_data.entries[cpuid_i++];
             }
             break;
-        case 0x7:
         case 0x12:
             for (j = 0; ; j++) {
                 c->function = i;
@@ -2013,6 +2012,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 c = &cpuid_data.entries[cpuid_i++];
             }
             break;
+        case 0x7:
         case 0x14:
         case 0x1d:
         case 0x1e: {
-- 
2.34.1

