Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D774975BE6C
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjGUGJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjGUGI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2665019A6;
        Thu, 20 Jul 2023 23:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919738; x=1721455738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tsSOF6cYaov4kLpfGw7bY+1WPoPGNDtD70m4QddfAE4=;
  b=gz2cbFwk9k7de1sTGpaWDZXMGpWhP7HnJgwDweI6RQxi9KiUV3NpArRL
   5vTCs/LlXL0MTPDhfgXMUod46dzRIiVc6W8gKQ4BqFOJF/508gvj1iDrE
   +r5MZyfTNB2I63pq5ucCal8G3Of2gRCZlHEwKTnZUK86Aq/4WkNF3s8tI
   kBI3AJaBwx28kVWN3MD0F4n3EewAvzIUl6saCZ3Alxxqx388PBleEUB4V
   IEH1fGvHw0RW+LNvkRMmJs4IEt9Et2EWr418IlBRXJSiOC27nWhSjCo6e
   72gl7yZpvFrPJW4egwNtDJMHE3NtrpqVBE2d4mc4uYFFKl4QpjrABo5K7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547588"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547588"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721962"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721962"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 06/20] KVM:x86: Load guest FPU state when access XSAVE-managed MSRs
Date:   Thu, 20 Jul 2023 23:03:38 -0400
Message-Id: <20230721030352.72414-7-weijiang.yang@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Load the guest's FPU state if userspace is accessing MSRs whose values are
managed by XSAVES. Two MSR access helpers, i.e., kvm_{get,set}_xsave_msr(),
are designed by a later patch to facilitate access to such kind of MSRs.

If MSRs supported in kvm_caps.supported_xss are passed through to guest,
the guest MSRs are swapped with host contents before vCPU exits to userspace
and after it enters kernel again.

Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
explicitly check @vcpu is non-null before attempting to load guest state.
The XSS supporting MSRs cannot be retrieved via the device ioctl() without
loading guest FPU state (which doesn't exist).

Note that guest_cpuid_has() is not queried as host userspace is allowed
to access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8bdcbcf13146..04f0245ad0a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -132,6 +132,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -4346,6 +4349,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+static const u32 xstate_msrs[] = {
+	MSR_IA32_U_CET, MSR_IA32_PL3_SSP,
+};
+
+static bool is_xstate_msr(u32 index)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xstate_msrs); i++) {
+		if (index == xstate_msrs[i])
+			return true;
+	}
+	return false;
+}
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
@@ -4356,11 +4374,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
+		    is_xstate_msr(entries[i].index)) {
+			kvm_load_guest_fpu(vcpu);
+			fpu_loaded = true;
+		}
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
+	}
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
 
 	return i;
 }
-- 
2.27.0

