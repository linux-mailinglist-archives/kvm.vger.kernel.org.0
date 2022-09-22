Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC475E6AD5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIVSY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiIVSXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6909010D647;
        Thu, 22 Sep 2022 11:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870948; x=1695406948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W2Kk+Oh554M6hYppcd4bamgUFE8iODrNht1zMrNWv44=;
  b=DgMFcpt2hXTCBYItcSRRmP/nE2AN+siYptH8QwzyAMZu/6xwX6iwVwRu
   kySITF+P1+P5nUnSsbLnYZOp/YLLtDboItTULV2zUFZ5p7VcKzRN8VctQ
   izpn0W3ErqRPbRpAQZoQWiA2CCCo13Qq865NvMNnG1SPPoslrI2i/t9fc
   NTO7ku5WXw2XxLAZM6TSVWRyjjCG18HSuURtfpwJTGoN40fr3VzR/Flhb
   qoinFx6H0k5AgeCjB0lKs/ye5S96lFL0GlTf9lqeznkSPSNBmNAwvSxlM
   InMJb+PAB36AewAoYFNBWn/20h9MWqPdBNdRKW9uqLGhfe3hPOlY4NmcR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712941"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712941"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086909"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:28 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 27/30] RFC: KVM: powerpc: Move processor compatibility check to hardware setup
Date:   Thu, 22 Sep 2022 11:20:56 -0700
Message-Id: <574ca90fdaec0f37c197d9600d47d48a74f324bd.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Move processor compatibility check from kvm_arch_processor_compat() into
kvm_arch_hardware_setup().  The check does model name comparison with a
global variable, cur_cpu_spec.  There is no point to check it at run time
on all processors.

kvmppc_core_check_processor_compat() checks the global variable.  There are
five implementation for it as follows.

  arch/powerpc/include/asm/cputable.h: extern struct cpu_spec *cur_cpu_spec;
  arch/powerpc/kvm/book3s.c: return 0
  arch/powerpc/kvm/e500.c: strcmp(cur_cpu_spec->cpu_name, "e500v2")
  arch/powerpc/kvm/e500mc.c: strcmp(cur_cpu_spec->cpu_name, "e500mc")
                             strcmp(cur_cpu_spec->cpu_name, "e5500")
                             strcmp(cur_cpu_spec->cpu_name, "e6500")

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7b56d6ccfdfb..31dc4f231e9d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -444,12 +444,12 @@ int kvm_arch_hardware_enable(void)
 
 int kvm_arch_hardware_setup(void *opaque)
 {
-	return 0;
+	return kvmppc_core_check_processor_compat();
 }
 
 int kvm_arch_check_processor_compat(void)
 {
-	return kvmppc_core_check_processor_compat();
+	return 0;
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
-- 
2.25.1

