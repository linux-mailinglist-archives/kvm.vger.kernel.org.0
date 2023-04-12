Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7672C6DECFF
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 09:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjDLHwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 03:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDLHwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 03:52:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0B96589
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 00:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681285914; x=1712821914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MjKV4s8VGpZ1zEkznfY4jiS1d+KzIYwTcz+xV2KmVqM=;
  b=hld8OYlU/Bj8NY+PF9eWzeQY/rZAgyDooOiWn8D9qgZHlw2rFcZiqemV
   wIf6DsNesZKCShAX4HSCbXAdjR3l5wqrNKQx2HfOfZRrEIg1U9CtE5RHs
   mRE1nQfq2apc3lbek4UqAvcqnU1gVWPeinOtb7AIK+Ei9++WCZ2lKCh/q
   CCT+q98/Qex40pLyeTPYsA1wwhRjbHjRtSfktIJMBNIZun4eo3zGLsHoo
   h2yHIZSvXdw91Arf6n8RkoFn5ODQ/fqy+XNGw6Y4IsKDLiL4n9PEZKrWA
   /H/7BqNd9rB2AsHBTTdqTMva5rP80AqwVU08NL3BqGQGJZ+7sJGnUDXNb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345623276"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="345623276"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812893691"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="812893691"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:51 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, chao.gao@intel.com,
        robert.hu@linux.intel.com
Subject: [kvm-unit-tests v3 4/4] x86: Add test case for INVVPID with LAM
Date:   Wed, 12 Apr 2023 15:51:34 +0800
Message-Id: <20230412075134.21240-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230412075134.21240-1-binbin.wu@linux.intel.com>
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
---
 x86/vmx_tests.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5ee1264..381ca1c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3225,6 +3225,65 @@ static void invvpid_test_not_in_vmx_operation(void)
 	TEST_ASSERT(!vmx_on());
 }
 
+#define LAM57_MASK	GENMASK_ULL(62, 57)
+#define LAM48_MASK	GENMASK_ULL(62, 48)
+
+static inline u64 set_metadata(u64 src, u64 metadata_mask)
+{
+	return (src & ~metadata_mask) | (NONCANONICAL & metadata_mask);
+}
+
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
+	write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);
+	if (!(read_cr4() & X86_CR4_LAM_SUP)) {
+		report_skip("Failed to enable LAM_SUP");
+		return;
+	}
+
+	operand = (struct invvpid_operand *)vaddr;
+	operand->gla = set_metadata(operand->gla, lam_mask);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): untagged pointer + tagged addr");
+
+	operand = (struct invvpid_operand *)set_metadata((u64)operand, lam_mask);
+	operand->gla = (u64)vaddr;
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged pointer + untagged addr");
+
+	operand = (struct invvpid_operand *)set_metadata((u64)operand, lam_mask);
+	operand->gla = set_metadata(operand->gla, lam_mask);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged pointer + tagged addr");
+
+	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
+}
+
 /*
  * This does not test real-address mode, virtual-8086 mode, protected mode,
  * or CPL > 0.
@@ -3282,6 +3341,7 @@ static void invvpid_test(void)
 	invvpid_test_pf();
 	invvpid_test_compatibility_mode();
 	invvpid_test_not_in_vmx_operation();
+	invvpid_test_lam();
 }
 
 /*
-- 
2.25.1

