Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030F85B2A54
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiIHX2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiIHX1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:27:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054B7115CF2;
        Thu,  8 Sep 2022 16:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679586; x=1694215586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jWuQBoK0q0gfpKRVUiGWH6TTCqtzESEI7BQKtOCQK/A=;
  b=VdH9HOw+wpKg/YHb1ccH+wr82NYVKGrSxAoymdPA+k69luFufPjukpal
   BcFl6jIn0onEea7Ji0wkniJvTCpn+nRhj/QAC1D+9DNywbyM3qTAP0Dv5
   aV76/h4vr+rekk3fiOPDMh64Jq4dJOGY5KyB3InA5jHT1VrzvLCro57x7
   ZWxw8/2pkxy1u4LjP+rDW2gdidtBirfU+OdFV3VbAZDtFeeNTbm9gQyEm
   Q6mYUal53/iiXXZs8Q0h3mK4vbWKGk2MClnUyvGdZDclpF95z7DlTtiQv
   Bk03Hnd+YXrhsfSv0f98lscqECeluYnBtMzU+71takedPf1x/+NtP1k1z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687045"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687045"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863281"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:15 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 23/26] RFC: KVM: powerpc: Move processor compatibility check to hardware setup
Date:   Thu,  8 Sep 2022 16:25:39 -0700
Message-Id: <b348201517333f52c570f359e0d94bc9d5afc4f2.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662679124.git.isaku.yamahata@intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7b56d6ccfdfb..7e3a6659f107 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -444,12 +444,21 @@ int kvm_arch_hardware_enable(void)
 
 int kvm_arch_hardware_setup(void *opaque)
 {
-	return 0;
+	/*
+	 * kvmppc_core_check_processor_compat() checks the global variable.
+	 * No point to check on all processors or at runtime.
+	 * arch/powerpc/kvm/book3s.c: return 0
+	 * arch/powerpc/kvm/e500.c: strcmp(cur_cpu_spec->cpu_name, "e500v2")
+	 * arch/powerpc/kvm/e500mc.c: strcmp(cur_cpu_spec->cpu_name, "e500mc")
+	 *                            strcmp(cur_cpu_spec->cpu_name, "e5500")
+	 *                            strcmp(cur_cpu_spec->cpu_name, "e6500")
+	 */
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

