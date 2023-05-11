Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE396FEC81
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbjEKHO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237513AbjEKHOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:14:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20EC8694;
        Thu, 11 May 2023 00:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789232; x=1715325232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TvBtgUKn7ic3XTFVWWRTcuCfR4IG367PYPSHuHHSapk=;
  b=IC+ruKptPSahtdzxj6jjBO+aLtoeIDGo7ms5fotWJHOQC+/v4fhw3bOf
   UM8SyJPAlQkUkrFJgq5wGNMyx+nUnuVbFsiLK+KoPUUEL9amdD7QevuXO
   c8ztgwMePHuAckZgGwJdkfazZeRs178rCgvETMvaFiA3TdIfspXdKLUT3
   RUS/Bsy5+67VD3QvmcBvNsDX0bT5iLU+QEK/fA9mhxM08zbTPv2VQHJAn
   BQHLsMPHwyr4pHdMCN6Jc0N0NzagE2wwWgmHuHAfZIhEXdW0xbbMPxih6
   pqO1xxQ+jO5tL2He2Sf8am9xPM+SVxsOBlRCrhVyxACNtdl4v9oEwUfE3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896640"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896640"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512367"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512367"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:24 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 09/21] KVM:x86: Load guest FPU state when accessing xsaves-managed MSRs
Date:   Thu, 11 May 2023 00:08:45 -0400
Message-Id: <20230511040857.6094-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Load the guest's FPU state if userspace is accessing MSRs whose values are
managed by XSAVES. Two MSR access helpers, i.e., kvm_{get,set}_xsave_msr(),
are introduced by a later patch to facilitate access to this kind of MSRs.

If new feature MSRs supported in XSS are passed through to the guest they
are saved and restored by {XSAVES|XRSTORS} to/from guest's FPU state at
vm-entry/exit.

Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
explicitly check @vcpu is non-null before attempting to load guest state.
The XSS supporting MSRs cannot be retrieved via the device ioctl() without
loading guest FPU state (which doesn't exist).

Note that guest_cpuid_has() is not queried as host userspace is allowed
to access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2975ca96ac5..7788646bbf1f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -130,6 +130,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -4336,6 +4339,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+static const u32 xsave_msrs[] = {
+	MSR_IA32_U_CET, MSR_IA32_PL3_SSP,
+};
+
+static bool is_xsaves_msr(u32 index)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xsave_msrs); i++) {
+		if (index == xsave_msrs[i])
+			return true;
+	}
+	return false;
+}
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
@@ -4346,11 +4364,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
+		    is_xsaves_msr(entries[i].index)) {
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

