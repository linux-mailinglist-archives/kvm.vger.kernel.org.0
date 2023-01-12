Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B337A667B9F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241020AbjALQoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbjALQif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918F51C90D;
        Thu, 12 Jan 2023 08:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541245; x=1705077245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zQ4CIHnZclaOv/I14BlAFQyBI6CAMGr+yZ3TIZZXQzI=;
  b=Qz2rNRgRUA/r+8cHOdjyUrqUSQ9ixk1o8ac7UOwdG34wKT3pgoITVPYT
   /KQcVpSUEQ2na1JlIhhn2abJTfPKvjjAVsstbWTSrMzKWDANtSV9HAfUp
   Bb+zwDyD4l0AEqWjqgajWIvP4CcyQKeIFLWV08rr0KhbNB4NEZLUV/cb3
   w/iqNuCprJIGpWGYn5ItzjiybHxS61zpaC39ft5VTEIaj4HPA3KWsNbJT
   RF+8TmH2eRgZEj5q4sBoXvBBlNY7FDLsq+sB6QidJ9eGJA9cbPNRkRXHb
   Ffd3bYP71udZ6yjVnuVQfRC4mhQPO/mMdfOVQ6JWyEGHfL4zaLUCGAMCB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811921"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811921"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151825"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151825"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:29 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 055/113] KVM: x86/VMX: introduce vmx tlb_remote_flush and tlb_remote_flush_with_range
Date:   Thu, 12 Jan 2023 08:32:03 -0800
Message-Id: <d69b281c23131254ae6fdea67e384ef931dbba8e.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

This is preparation for TDX to define its own tlb_remote_flush and
tlb_remote_flush_with_range.  Currently vmx code defines tlb_remote_flush
and tlb_remote_flush_with_range defined as NULL by default and only when
nested hyper-v guest case, they are defined to non-NULL methods.

To make TDX code to override those two methods consistently with other
methods, define vmx_tlb_remote_flush and vmx_tlb_remote_flush_with_range
as nop and call hyper-v code only when nested hyper-v guest case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/kvm_onhyperv.c     |  5 ++++-
 arch/x86/kvm/kvm_onhyperv.h     |  1 +
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/svm/svm_onhyperv.h |  1 +
 arch/x86/kvm/vmx/main.c         |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 34 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/x86_ops.h      |  3 +++
 7 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index 482d6639ef88..d2e71c7ab4f4 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -94,11 +94,14 @@ int hv_remote_flush_tlb(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
 
+bool hv_use_remote_flush_tlb __ro_after_init;
+EXPORT_SYMBOL_GPL(hv_use_remote_flush_tlb);
+
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
 
-	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
+	if (hv_use_remote_flush_tlb) {
 		spin_lock(&kvm_arch->hv_root_tdp_lock);
 		vcpu->arch.hv_root_tdp = root_tdp;
 		if (root_tdp != kvm_arch->hv_root_tdp)
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..9a07a34666fb 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -10,6 +10,7 @@
 int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range);
 int hv_remote_flush_tlb(struct kvm *kvm);
+extern bool hv_use_remote_flush_tlb __ro_after_init;
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ad0482a101a3..4f3f4cdc67ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,7 +244,7 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 {
 	int ret = -ENOTSUPP;
 
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
+	if (range && kvm_available_flush_tlb_with_range())
 		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
 
 	if (ret)
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 6981c1e9a809..3ebe08f9d647 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -38,6 +38,7 @@ static inline void svm_hv_hardware_setup(void)
 		svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
 		svm_x86_ops.tlb_remote_flush_with_range =
 				hv_remote_flush_tlb_with_range;
+		hv_use_remote_flush_tlb = true;
 	}
 
 	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a2ffef95bf9d..d0d8cfa89344 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -179,6 +179,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.flush_tlb_all = vmx_flush_tlb_all,
 	.flush_tlb_current = vmx_flush_tlb_current,
+	.tlb_remote_flush = vmx_tlb_remote_flush,
+	.tlb_remote_flush_with_range = vmx_tlb_remote_flush_with_range,
 	.flush_tlb_gva = vmx_flush_tlb_gva,
 	.flush_tlb_guest = vmx_flush_tlb_guest,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2b0de8ba86b1..d67877a7dcc6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3208,6 +3208,33 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
 
+int vmx_tlb_remote_flush(struct kvm *kvm)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (hv_use_remote_flush_tlb)
+		return hv_remote_flush_tlb(kvm);
+#endif
+	/*
+	 * fallback to KVM_REQ_TLB_FLUSH.
+	 * See kvm_arch_flush_remote_tlb() and kvm_flush_remote_tlbs().
+	 */
+	return -EOPNOTSUPP;
+}
+
+int vmx_tlb_remote_flush_with_range(struct kvm *kvm,
+				    struct kvm_tlb_range *range)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (hv_use_remote_flush_tlb)
+		return hv_remote_flush_tlb_with_range(kvm, range);
+#endif
+	/*
+	 * fallback to tlb_remote_flush. See
+	 * kvm_flush_remote_tlbs_with_range()
+	 */
+	return -EOPNOTSUPP;
+}
+
 void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
@@ -8361,11 +8388,8 @@ __init int vmx_hardware_setup(void)
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
-	    && enable_ept) {
-		vt_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
-		vt_x86_ops.tlb_remote_flush_with_range =
-				hv_remote_flush_tlb_with_range;
-	}
+	    && enable_ept)
+		hv_use_remote_flush_tlb = true;
 #endif
 
 	if (!cpu_has_vmx_ple()) {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 27dd778aed6a..d7745ac380ed 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -99,6 +99,9 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 bool vmx_get_if_flag(struct kvm_vcpu *vcpu);
 void vmx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void vmx_flush_tlb_current(struct kvm_vcpu *vcpu);
+int vmx_tlb_remote_flush(struct kvm *kvm);
+int vmx_tlb_remote_flush_with_range(struct kvm *kvm,
+				    struct kvm_tlb_range *range);
 void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr);
 void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu);
 void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
-- 
2.25.1

