Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4AB6C0005
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjCSIWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjCSIWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:22:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050D324C85
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679214168; x=1710750168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AA1LhgMGpiTDo/qs/Zr+Cp2CNmiv1WbX0CpLXr5ylTI=;
  b=CxB4EhLNNt7285Ese2haACRGTkhG7yn/g/FdTlpGD4mBPnpA5nd3W/U1
   GrQh/A19ONCnXYr7MUrdjZ3pSg9sRFKR0IjRluXV8N95B7jk8cz90jH6i
   VNealFeD4RjULBXnj3o/3F3zg8valwsBW8STCsFRHup/xq4yjklk+FmKq
   mEZ3o0jHUnH6Vm56XtMbOTsSNYa36Q+RSnoej2l5JXUmuFlkZgTc6ziJK
   yq1rSESb9I3VeYhdcVi1vkqAFDvBgzl63+NsE0e9GvzVGwkyvNMTqpYvH
   pLCwF85m8y27cPurfvJmjwl+LMFQTte+Z8Ap8/d+d+or2mVQmki5JSZjz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="340849334"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="340849334"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:22:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="749741235"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="749741235"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:22:46 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v2 4/4] x86: Add test case for INVVPID with LAM
Date:   Sun, 19 Mar 2023 16:22:25 +0800
Message-Id: <20230319082225.14302-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230319082225.14302-1-binbin.wu@linux.intel.com>
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When LAM is on, the linear address of INVVPID operand can contain
metadata, and the linear address in the INVVPID descriptor can
caontain metadata.

The added cases use tagged descriptor address or/and tagged target
invalidation address to make sure the behaviors are expected when
LAM is on.
Also, INVVPID cases can be used as the common test cases for VMX
instruction vmexits.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 x86/vmx_tests.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1be22ac..9e9589f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3225,6 +3225,78 @@ static void invvpid_test_not_in_vmx_operation(void)
 	TEST_ASSERT(!vmx_on());
 }
 
+#define LAM57_BITS 6
+#define LAM48_BITS 15
+#define LAM57_MASK	GENMASK_ULL(62, 57)
+#define LAM48_MASK	GENMASK_ULL(62, 48)
+
+/* According to LAM mode, set metadata in high bits */
+static u64 set_metadata(u64 src, unsigned long lam)
+{
+	u64 metadata;
+
+	switch (lam) {
+	case LAM57_BITS: /* Set metadata in bits 62:57 */
+		metadata = (NONCANONICAL & ((1UL << LAM57_BITS) - 1)) << 57;
+		metadata |= (src & ~(LAM57_MASK));
+		break;
+	case LAM48_BITS: /* Set metadata in bits 62:48 */
+		metadata = (NONCANONICAL & ((1UL << LAM48_BITS) - 1)) << 48;
+		metadata |= (src & ~(LAM48_MASK));
+		break;
+	default:
+		metadata = src;
+		break;
+	}
+
+	return metadata;
+}
+
+static void invvpid_test_lam(void)
+{
+	void *vaddr;
+	struct invvpid_operand *operand;
+	int lam_bits = LAM48_BITS;
+	bool fault;
+
+	if (!this_cpu_has(X86_FEATURE_LAM)) {
+		report_skip("LAM is not supported, skip INVVPID with LAM");
+		return;
+	}
+
+	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
+		lam_bits = LAM57_BITS;
+
+	vaddr = alloc_vpage();
+	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
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
+	operand->gla = set_metadata(operand->gla, lam_bits);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): untagged pointer + tagged addr");
+
+	operand = (struct invvpid_operand *)set_metadata((u64)operand, lam_bits);
+	operand->gla = (u64)vaddr;
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged pointer + untagged addr");
+
+	operand = (struct invvpid_operand *)set_metadata((u64)operand, lam_bits);
+	operand->gla = set_metadata(operand->gla, lam_bits);
+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
+	report(!fault, "INVVPID (LAM on): tagged pointer + tagged addr");
+
+	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
+}
+
 /*
  * This does not test real-address mode, virtual-8086 mode, protected mode,
  * or CPL > 0.
@@ -3282,6 +3354,7 @@ static void invvpid_test(void)
 	invvpid_test_pf();
 	invvpid_test_compatibility_mode();
 	invvpid_test_not_in_vmx_operation();
+	invvpid_test_lam();
 }
 
 /*
-- 
2.25.1

