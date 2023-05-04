Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749906F67B9
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 10:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjEDIsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 04:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjEDIsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 04:48:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAE93586
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 01:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683190085; x=1714726085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sbjB8woQe6rmZ8r1YOWkI+Aglor4+/apfpOtOU91qGI=;
  b=hZo64q+Tcrz8HW6NEN6la9KYfS8ZSBJf39Rk4ney3iH4pRyK26SwgOX+
   Hivwyb7+5Rk2fTkO0boPF+W6eSoH3M72welq7+jiGSj1jDZYYztq/w0H0
   u79yNBfxPJHG0AijqwwQ9B5nj6C1HWNJYgq7H6fAU8QRFxs3ZWe69pUgn
   tnU3K6dkla0sbxZHB2WroJEdAzZHMeFMEkSx4WdKaZ6Zgn5RyZV/1Lys+
   jFB0roJJudHiE3mL/IBUS2f9m+N968IxYzXAJ9cstUlCRBuId9ndkfP2w
   mnjT9QGX29JtFmLHsv5+sFmAZkWt52nyXs4hsKWTjjDY4ZqMuAlrlFqxJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="435178195"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="435178195"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:48:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="766480503"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="766480503"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.1.46])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:48:01 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [kvm-unit-tests v4 4/4] x86: Add test case for INVVPID with LAM
Date:   Thu,  4 May 2023 16:47:51 +0800
Message-Id: <20230504084751.968-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230504084751.968-1-binbin.wu@linux.intel.com>
References: <20230504084751.968-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When LAM is on, the linear address of INVVPID operand can contain
metadata, and the linear address in the INVVPID descriptor can
contain metadata.

The added cases use tagged descriptor address or/and tagged target
invalidation address to make sure the behaviors are expected when
LAM is on.
Also, INVVPID cases can be used as the common test cases for VMX
instruction VMExits.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 x86/vmx_tests.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 217befe..678c9ec 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3225,6 +3225,54 @@ static void invvpid_test_not_in_vmx_operation(void)
 	TEST_ASSERT(!vmx_on());
 }
 
+/* LAM applies to the target address inside the descriptor of invvpid */
+static void invvpid_test_lam(void)
+{
+	void *vaddr;
+	struct invvpid_operand *operand;
+	u64 lam_mask = LAM48_MASK;
+	bool fault;
+
+	if (!this_cpu_has(X86_FEATURE_LAM)) {
+		report_skip("LAM is not supported, skip INVVPID with LAM");
+		return;
+	}
+	write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);
+
+	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
+		lam_mask = LAM57_MASK;
+
+	vaddr = alloc_vpage();
+	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
+	/*
+	 * Since the stack memory address in KUT doesn't follow kernel address
+	 * space partition rule, reuse the memory address for descriptor and
+	 * the target address in the descriptor of invvpid.
+	 */
+	operand = (struct invvpid_operand *)vaddr;
+	operand->vpid = 0xffff;
+	operand->gla = (u64)vaddr;
+
+	operand = (struct invvpid_operand *)vaddr;
+	operand->gla = set_la_non_canonical(operand->gla, lam_mask);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): untagged pointer + tagged addr");
+
+	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
+								 lam_mask);
+	operand->gla = (u64)vaddr;
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged pointer + untagged addr");
+
+	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
+								 lam_mask);
+	operand->gla = set_la_non_canonical(operand->gla, lam_mask);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged pointer + tagged addr");
+
+	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
+}
+
 /*
  * This does not test real-address mode, virtual-8086 mode, protected mode,
  * or CPL > 0.
@@ -3274,8 +3322,10 @@ static void invvpid_test(void)
 	/*
 	 * The gla operand is only validated for single-address INVVPID.
 	 */
-	if (types & (1u << INVVPID_ADDR))
+	if (types & (1u << INVVPID_ADDR)) {
 		try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
+		invvpid_test_lam();
+	}
 
 	invvpid_test_gp();
 	invvpid_test_ss();
-- 
2.25.1

