Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C3576E1B6
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjHCHhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjHCHgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:07 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F2F35BB;
        Thu,  3 Aug 2023 00:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047938; x=1722583938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IPCrPajh7UzLAqJcOYg8gmyGcQfu+kJKJlt1LMvrhdM=;
  b=mm1VdVyEN0XUqDPhu/MCEgd0WnOklWAozPKebEWI8r7DI9pcs0t5Idjv
   ALOHnrB4U3OF6gmWYtwFopkVfeR7AXTt80dQjvmvHVutloE4uo3m68Byr
   se7WK3fWYEkvvqGZSUEnKkVNXGu0WyNwbssH953LUpYXuZ9uQg+IaA7EI
   opz+++sIT5Etc8zK7njZzTrqgYAmm3I9fLgENWWA507ErUqAeZJpXqnCs
   NYgs5hYO5Lm9SPsnKKwudeod5rQeC12YatQCqvp24EMupZbcl27QvHOyi
   oShrl2aTvFmpP+9btxP14EKfc/ey2hz7mGPY7ej96mor3Wkn67/Gqyeba
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708109"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708109"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888483"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888483"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:15 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 06/19] KVM:x86: Load guest FPU state when access XSAVE-managed MSRs
Date:   Thu,  3 Aug 2023 00:27:19 -0400
Message-Id: <20230803042732.88515-7-weijiang.yang@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

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
index e9f3627d5fdd..015fb0ef102c 100644
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
@@ -4345,6 +4348,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4355,11 +4373,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
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

