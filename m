Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04616667C42
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbjALRLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbjALRKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:10:54 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52856132E;
        Thu, 12 Jan 2023 08:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542090; x=1705078090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QFP3jIj8NsfV1mtc5OzoIWRWOKvWQx16E9fvvGq2lpo=;
  b=TyyZFtiFunn4NJfPTmbE9VfYg2WPqZ6K7MpN/+4DHOimeenrMuhRgMRz
   c9mMlPdO0CLbuP5EjahO/CPUei0uW/YaEp9XLrkEvFLpD1AnY5gicuPot
   jh9lT4YW1LSgLwbHSdj5LOcv6N2WQZN2ZAzzRZzzItuXnpWh1TtF1K/R4
   3fT4TmTU1EV4YV12FIrAqhNuhtqEGKM006QelGPw/Uqx7bWfxMSoO5XHa
   1JP/IK14FvlagI0NTndY5hVYJqw8SqRiQLIgbSwfcXm3gOvIYPWYCn6RG
   w0llpwM4kqkSKu1BCwyt2r48pVBln88Jtc5qUeT3DUd0gL6IAAqLXg3pZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816292"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816292"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658331"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658331"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 04/16] KVM: TDX: Pass size to tdx_measure_page()
Date:   Thu, 12 Jan 2023 08:43:56 -0800
Message-Id: <d6dabe310707a87bcd7e1fe530ecdf97fca4f594.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 8959a019b87a..1bc07dfe765a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1299,13 +1299,15 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
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
@@ -1400,7 +1402,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_unpin(kvm, pfn);
 		return -EIO;
 	} else if (measure)
-		tdx_measure_page(kvm_tdx, gpa);
+		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
 
 	return 0;
 }
-- 
2.25.1

