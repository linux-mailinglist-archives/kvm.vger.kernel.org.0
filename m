Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891787626D1
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbjGYWgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbjGYWfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F6D30C6;
        Tue, 25 Jul 2023 15:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324157; x=1721860157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M4lsElPqrb+BsCyYm4xXsf8VDc7nGWLgLNAovuenxyo=;
  b=CkfIZEbKbqLZC1MBk2q4hr54yiB2BkzdlW52x46+PkBoFVbgtj+ICDcS
   62RU44AXqpkyA5bti84r2+zjKk6vV1xhddiMgL+9t65SNfd+1mvKbe0bg
   234hvit9FFq1GwY08UY0B8Xt9ajLGS3cGzbSTA9sA68PRYo6h848E4VUB
   wEeSq8sj+/87k6BvUaFIsUWSo4pjCTXSMFB5X/L4fevajOIXDUttGjypv
   gCVki34KIYb7/OkAyi9SHVDX4yoZ836no3m7zGO+CycwI6Ttd/sOYAQm8
   LsWQSnXl+6X+JjFsafzzGR6HF2skGIbCOn4uTOzHjtLNwJmAkJa3+G5Uf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467111"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467111"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855796"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855796"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:09 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v4 04/16] KVM: TDX: Pass size to tdx_measure_page()
Date:   Tue, 25 Jul 2023 15:23:50 -0700
Message-Id: <c2b65c7a3b0d3788ab3fd90381ae4c0e2e7fea29.1690323516.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690323516.git.isaku.yamahata@intel.com>
References: <cover.1690323516.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Extend tdx_measure_page() to pass size info so that it can measure
large page as well.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f3a8ae3e81bd..3522ee232eda 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1340,13 +1340,15 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
-static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
+static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 {
 	struct tdx_module_output out;
 	u64 err;
 	int i;
 
-	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+	WARN_ON_ONCE(size % TDX_EXTENDMR_CHUNKSIZE);
+
+	for (i = 0; i < size; i += TDX_EXTENDMR_CHUNKSIZE) {
 		err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
 		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
 			pr_tdx_error(TDH_MR_EXTEND, err, &out);
@@ -1441,7 +1443,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_unpin(kvm, pfn);
 		return -EIO;
 	} else if (measure)
-		tdx_measure_page(kvm_tdx, gpa);
+		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
 
 	return 0;
 }
-- 
2.25.1

