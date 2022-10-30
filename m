Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7051A612807
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiJ3G0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJ3GZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:25:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047F41EE;
        Sat, 29 Oct 2022 23:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111054; x=1698647054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZakXX3Wx8TmNedmlc63R5sE7OXgzgan1HAW4wBcmf/0=;
  b=Bw4uFQ7BS2IhUVisxC0dzWS2svNUw5wlmjNKsIRXUOzoIKIRw4a6Ts3D
   5utLEttVLjhWu4zfbW0d6d753wzyf+SXPRMRJb7P2K5z+hFHBZSfr26QD
   /XGNmi1x6JiYC8SUjgOzfri2+Epso+iQBj7qZxfJXVgrIwYkq68oMAX8i
   tS4vuW5ZIV6hW8Kwuv4bylzrdX2L0lQI5U+OIKKKrpUZXKRYg8sVPs51z
   1BIYwyFClZHpXKvZba05cKyGdqciqfdjiWWiUCMAs+AbEtYDPty7y27hX
   M6y503mxcVMNX5pJcwpQNYDkCMl6oS4JFYMk4Qqg0YEfjsUkz+vAxKVYE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037170"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037170"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393030"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393030"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:06 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 057/108] KVM: x86/VMX: introduce vmx tlb_remote_flush and tlb_remote_flush_with_range
Date:   Sat, 29 Oct 2022 23:22:58 -0700
Message-Id: <009a08eb9b20f1c23d37e06a5958eafd05466249.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ee4f696a0782..d43518da1c0e 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -93,11 +93,14 @@ int hv_remote_flush_tlb(struct kvm *kvm)
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
index efc3b3f2dd12..08923b64dcc8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -242,7 +242,7 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 {
 	int ret = -ENOTSUPP;
 
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
+	if (range && kvm_available_flush_tlb_with_range())
 		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
 
 	if (ret)
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index e2fc59380465..b3cd61c62305 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -36,6 +36,7 @@ static inline void svm_hv_hardware_setup(void)
 		svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
 		svm_x86_ops.tlb_remote_flush_with_range =
 				hv_remote_flush_tlb_with_range;
+		hv_use_remote_flush_tlb = true;
 	}
 
 	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 974e00fd3260..fe9583b640fb 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -178,6 +178,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.flush_tlb_all = vmx_flush_tlb_all,
 	.flush_tlb_current = vmx_flush_tlb_current,
+	.tlb_remote_flush = vmx_tlb_remote_flush,
+	.tlb_remote_flush_with_range = vmx_tlb_remote_flush_with_range,
 	.flush_tlb_gva = vmx_flush_tlb_gva,
 	.flush_tlb_guest = vmx_flush_tlb_guest,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b5c3652c3cc4..f2887dbde700 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3126,6 +3126,33 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
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
@@ -8223,11 +8250,8 @@ __init int vmx_hardware_setup(void)
 
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
index dd05991afbad..cf7e0c6c65ac 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -92,6 +92,9 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
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

