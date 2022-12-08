Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3E647A15
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiLHXgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiLHXfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:55 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9096BCA7;
        Thu,  8 Dec 2022 15:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542554; x=1702078554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+sQP4o0OJhYPC5qL5BglaZeRAlQ+9kwaddW+ppgbLVk=;
  b=RLwThGfJGe21vbvqdstR1tedwwtkM7smjuq/XxWH5B0sXvDZPgy454kl
   eTyvXQxTKbMGwlcGQjIMF3o96vUZodte6mEzkFdDWZoYPglms9S7WbW7f
   ubLyPpGrkB4chNXeVkKlgC/LZjGtfLTyN9oKA1tXR9lyyZmBo+3T5B5vL
   jj8Zc0nF+iQ6IHEw5C/tUKuKWoZHUCtGujWFQ77CRR4NuNLPPiAYMaEjr
   tBsmiWo+0Y3nfcviqIwDOiNIqq/WbwOHXtMPO0HX+WIH1hABjtC4cQMU6
   D1lwJQ+HzOMqq+lh1rkN5TLbN/gAgmAj4m51Cp8L4MYacUi0FHTJHe9QG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586493"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586493"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950904"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950904"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:53 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 04/15] KVM: TDX: Pass size to tdx_measure_page()
Date:   Thu,  8 Dec 2022 15:35:39 -0800
Message-Id: <f305a49c4397af85c673f026f2b5b0e7aa0c8cc0.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
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
index 4f8479c20553..5b392d9baa25 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1273,13 +1273,15 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
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
 		err = tdh_mr_extend(kvm_tdx->tdr.pa, gpa + i, &out);
 		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
 			pr_tdx_error(TDH_MR_EXTEND, err, &out);
@@ -1371,7 +1373,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_unpin(kvm, pfn);
 		return -EIO;
 	} else if (measure)
-		tdx_measure_page(kvm_tdx, gpa);
+		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
 
 	return 0;
 }
-- 
2.25.1

