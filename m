Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8088372E3F1
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 15:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242559AbjFMNT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 09:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242552AbjFMNTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 09:19:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559E5E6
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 06:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686662395; x=1718198395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hfFgdff8XTWie2hZuUxnhjyHznpzx7DqvvjD22d3hG0=;
  b=Sl9j3wKDVhUbG+6UUV7SM0bQMJG2nCvP/qzOzUfM6EOzekOYmiBlLOgD
   1C4NGCJXLF1sSiPUyPz4exDP9qz5vy0Cz0oe/kvpVROJveR/OETt7m2Tp
   qlvtxqLDjcfnY3lZ7QNb1aeqFaB8Ib8zcik3QU7tS5KX5E7iGe70eHx82
   2+m6RSD8ah4wNyEom7zRxfEk3A+9D1STShHvLHn7rziZAFL9qVFdZslJp
   vCto6RHkAEEOBSXCBQSDAV87/IjQcsQMCQIf+iERIHDYbuivWpCC4Nug0
   wVCiw0CFJ/xXF+79B0E5BvSfPHHKc7XxHeco/sJtidVBFskPHGhW2zkOp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361696814"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="361696814"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:19:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="744680338"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="744680338"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 06:19:53 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH v2 2/3] i386/cpuid: Remove subleaf constraint on CPUID leaf 1F
Date:   Tue, 13 Jun 2023 09:19:28 -0400
Message-Id: <20230613131929.720453-3-xiaoyao.li@intel.com>
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

No such constraint that subleaf index needs to be less than 64.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index afa97799d89a..d7e235ce35a6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1968,10 +1968,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
                     break;
                 }
 
-                if (i == 0x1f && j == 64) {
-                    break;
-                }
-
                 c->function = i;
                 c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
                 c->index = j;
-- 
2.34.1

