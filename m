Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197AF76E1CD
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbjHCHhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjHCHgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:17 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9E049E3;
        Thu,  3 Aug 2023 00:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047942; x=1722583942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7e5ypkNSvdnqN0MtKaMYvhf+y8wsyyJlu13WVz7mfU8=;
  b=bjAH44JRU+58OQM/x+IGAP4KjrG+bp4K/RjOQuL8f/5POyMSOQnWzlTj
   xhG1w5Rdo6YWff1PaxSAgq7TpD3xdr1hnr17Wxflfj0TP/o5m8KbaFQ/o
   ICX/vkCBwrexiX5FAv/JSer7b5DQ/2mQhs/FiJdaqAJ7s6VUpvsJAXE+Q
   YWOR7eFdPHdDZDg2YkzQm+WbQUabPEDlwQNMf/Zu5xjvqX7O2T+61b4Ak
   XxaCPOUJhPEG8wyRTULn101GYCn8+z4s3pyTMf1R8R+NTB5n14TzCNTrK
   wMVFukxvp9Y4UjnO7ZpFaCOlQAF7LgWp/rxMigzc/nil88zsqFc/oJoR8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708180"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708180"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888524"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888524"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 18/19] KVM:nVMX: Refine error code injection to nested VM
Date:   Thu,  3 Aug 2023 00:27:31 -0400
Message-Id: <20230803042732.88515-19-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per SDM description(Vol.3D, Appendix A.1):
"If bit 56 is read as 1, software can use VM entry to deliver
a hardware exception with or without an error code, regardless
of vector"

Modify has_error_code check  before inject events to nested guest.
Only enforce the check when guest is in real mode, the exception
is not hard exception and the platform doesn't enumerate bit56
in VMX_BASIC, otherwise ignore it.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++--------
 arch/x86/kvm/vmx/nested.h |  7 +++++++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 516391cc0d64..9bcd989252f7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1205,9 +1205,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
 	const u64 feature_and_reserved =
 		/* feature (except bit 48; see below) */
-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
+		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
 		/* reserved */
-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
+		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
 	u64 vmx_basic = vmcs_config.nested.basic;
 
 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
@@ -2846,12 +2846,16 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
 			return -EINVAL;
 
-		/* VM-entry interruption-info field: deliver error code */
-		should_have_error_code =
-			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
-			x86_exception_has_error_code(vector);
-		if (CC(has_error_code != should_have_error_code))
-			return -EINVAL;
+		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
+		    !nested_cpu_has_no_hw_errcode(vcpu)) {
+			/* VM-entry interruption-info field: deliver error code */
+			should_have_error_code =
+				intr_type == INTR_TYPE_HARD_EXCEPTION &&
+				prot_mode &&
+				x86_exception_has_error_code(vector);
+			if (CC(has_error_code != should_have_error_code))
+				return -EINVAL;
+		}
 
 		/* VM-entry exception error code */
 		if (CC(has_error_code &&
@@ -6967,6 +6971,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
+	if (cpu_has_vmx_basic_no_hw_errcode())
+		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE;
 }
 
 static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 96952263b029..1884628294e4 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -284,6 +284,13 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	       __kvm_is_valid_cr4(vcpu, val);
 }
 
+static inline bool nested_cpu_has_no_hw_errcode(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return vmx->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE;
+}
+
 /* No difference in the restrictions on guest and host CR4 in VMX operation. */
 #define nested_guest_cr4_valid	nested_cr4_valid
 #define nested_host_cr4_valid	nested_cr4_valid
-- 
2.27.0

