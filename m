Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF64715402
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 04:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjE3Cpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 22:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjE3CpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 22:45:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF83E4
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 19:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685414690; x=1716950690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rp72kGIs1NcqxbdM/XTJvaQ5IDVUmkr8Udft7D9zFKc=;
  b=DpJNDXz6Pw8h6PYANLSwPgn5M0Uw5vJ2wo+383JRMbV2Sr56YfkJibve
   /XRFlXmqVv0YcSBcivIbeYKPdmKKa01DLzE3rOnBK7LBVVMlz7Bvem17g
   Jnx1YLdOWMguVUj6k+eIa0CtDj09nP0i+mg59jTyWXCdVayNQlkTrdO0g
   st31P/PGhhMCwikA4hw7EC3i63EpHOUAVXgyBx4+WsferSqkCpvXu+gTp
   CX3CEzZpLtKf3VNrG8qeciNpOp94oaHYT6D0XFSW7Cn0N8zGMSOdwzzGF
   H1Hc4oHuDCB7CSxPxVaBWHp7QbmILyJKU0EIwgZDMlcw5Ohrxy51jownP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418287034"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418287034"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="656658863"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="656658863"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.104])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:10 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v5 4/4] x86: Add test case for INVVPID with LAM
Date:   Tue, 30 May 2023 10:43:56 +0800
Message-Id: <20230530024356.24870-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530024356.24870-1-binbin.wu@linux.intel.com>
References: <20230530024356.24870-1-binbin.wu@linux.intel.com>
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

LAM applies to the linear address of INVVPID operand, however,
it doesn't apply to the linear address in the INVVPID descriptor.

The added cases use tagged operand or tagged target invalidation
address to make sure the behaviors are expected when LAM is on.

Also, INVVPID case using tagged operand can be used as the common
test cases for VMX instruction VMExits.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 x86/vmx_tests.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 217befe..3f3f203 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3225,6 +3225,48 @@ static void invvpid_test_not_in_vmx_operation(void)
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
+	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
+								 lam_mask);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged operand");
+
+	/*
+	 * LAM doesn't apply to the address inside the descriptor, expected
+	 * failure and VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID set in
+	 * VMX_INST_ERROR.
+	 */
+	try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
+
+	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
+}
+
 /*
  * This does not test real-address mode, virtual-8086 mode, protected mode,
  * or CPL > 0.
@@ -3274,8 +3316,10 @@ static void invvpid_test(void)
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

