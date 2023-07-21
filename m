Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA0775BE76
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjGUGJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjGUGJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:09:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8FE272E;
        Thu, 20 Jul 2023 23:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919742; x=1721455742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7e5ypkNSvdnqN0MtKaMYvhf+y8wsyyJlu13WVz7mfU8=;
  b=Qh/NYCB0XJKv9nTmOBxn4iOP7WbEca9oaNPpBJuT670UAz0rYLG4QU3K
   JEVvxsunsEnHNlNyFWuWzAvSp1+7BGs8u8Qlx5dwgzGdBr+eJ1LxNyj39
   BCSImOETgfnDK5VeoWblLjcV7kODUbEkThP2/Tbm0dIfafK2rNDcLPjnr
   qAtZLKI42qo4xXnnBPpUmUbolrEP7+gqXn/pXe6FDqc1ss587Nz3Wr4lf
   Flu9B3AKos0G93ag92a9D9mH9FxUQUoCK9q2/EPblXiz+4+z67jeC7ur5
   jGbfTJwoB/zjJ/OY9aZ6iw3BYHoddQ7G8xZNTumDcJSuDwtX8qD9OP2Z2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547629"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547629"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721992"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721992"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 19/20] KVM:nVMX: Refine error code injection to nested VM
Date:   Thu, 20 Jul 2023 23:03:51 -0400
Message-Id: <20230721030352.72414-20-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

