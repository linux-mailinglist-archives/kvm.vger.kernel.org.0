Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD594B6022
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 02:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiBOBt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 20:49:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiBOBtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 20:49:25 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4472D1342E9
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:49:16 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 62-20020a17090a09c400b001b80b0742b0so12031337pjo.8
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2bCcqviidJObjCJ6gSL+JgamR6NeyUOSKoZiJNILybI=;
        b=RZfYfN/6BdUkZA/MkOcyj1lbzADlzT+Qw3vSTUjOnEgspEh8K2QDVdCmjddW7Hoei5
         5WRnXhYHoKjUW0lzAS2FF7R3SvAtWAUfwxWUhqqR7+jXoYM5vbMblI8rSygs4/ds+GwO
         4Mf7qvos8E1VBbZ8cxZ1SCufIh3rxFD5wAg/dYXjF9PGmiPbh2ryoR1DKrvwIHlFaO8v
         tRprHr2QhFH0BmSsNft1G7Ss/lFZfLQ7Pm380kpIqkHtBRGXyg+Ylu5MuPhlR8pMSTc7
         3jdIXnPLm9HKfBqlaIFzw/nu343JM8jA77r4WKcBclnPDWNqZF3tLlxd8pXSm2Ec2Pr+
         84lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2bCcqviidJObjCJ6gSL+JgamR6NeyUOSKoZiJNILybI=;
        b=y1EOybEXTY00xzGb1/0bctJSH/uB7O1fYj/5a5J7+qPvGzJeL6rVQ5G+iw7aFN/+hu
         lDY1OQQDPlKP9okhUJEkUz4Jov4m+ioDPB+xoOrPEyyW7bg+ZmWRo2809kf/id9MgseJ
         FhZBr/K5g20lb6oGETPjUob5Q8OR1ZeFJ9qvfQdGSeEdHycCFC2FqX3LoeHNgzt3swnS
         n8cwCqV1mnzfBKFoyEmw9Ld8m+owCOOPGjz0664tw4ksZQ3uzJDaT52Qm7ET7bJSMY3A
         uqAElHcL5xBuHNW52kAjgKymCpmMXJjKVQ061msx6iTJuNey3DfiG55/e9gbxu6L9v43
         ihBA==
X-Gm-Message-State: AOAM530eEVcFPb4onRkA8KmhlMdCAJKyoTih/5RATjGTU41pzLzdfzaK
        5bNGbnSjGDT/QMz9n47KHIgPfonRpQF1BRM=
X-Google-Smtp-Source: ABdhPJwg9x54scGJY86/xs05kF7AW1HYCG88ECIX+Mp1TgpGWjQ0xpmM/PMDOhz3rVfllrRUEFh1AWuxlPrrqB0=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:aa7:8b13:: with SMTP id
 f19mr1987743pfd.62.1644889755606; Mon, 14 Feb 2022 17:49:15 -0800 (PST)
Date:   Tue, 15 Feb 2022 01:48:04 +0000
In-Reply-To: <20220215014806.4102669-1-daviddunn@google.com>
Message-Id: <20220215014806.4102669-2-daviddunn@google.com>
Mime-Version: 1.0
References: <20220215014806.4102669-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v7 1/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
From:   David Dunn <daviddunn@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new capability, KVM_CAP_PMU_CAPABILITY, that takes a bitmask of
settings/features to allow userspace to configure PMU virtualization on
a per-VM basis.  For now, support a single flag, KVM_CAP_PMU_DISABLE,
to allow disabling PMU virtualization for a VM even when KVM is configured
with enable_pmu=true a module level.

To keep KVM simple, disallow changing VM's PMU configuration after vCPUs
have been created.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
 arch/x86/kvm/x86.c              | 17 +++++++++++++++++
 include/uapi/linux/kvm.h        |  3 +++
 tools/include/uapi/linux/kvm.h  |  3 +++
 7 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..df836965b347 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7561,3 +7561,25 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_PMU_CAPABILITY
+---------------------------
+
+:Capability KVM_CAP_PMU_CAPABILITY
+:Architectures: x86
+:Type: vm
+:Parameters: arg[0] is bitmask of PMU virtualization capabilities.
+:Returns 0 on success, -EINVAL when arg[0] contains invalid bits
+
+This capability alters PMU virtualization in KVM.
+
+Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
+PMU virtualization capabilities that can be adjusted on a VM.
+
+The argument to KVM_ENABLE_CAP is also a bitmask and selects specific
+PMU virtualization capabilities to be applied to the VM.  This can
+only be invoked on a VM prior to the creation of VCPUs.
+
+At this time, KVM_CAP_PMU_DISABLE is the only capability.  Setting
+this capability will disable PMU virtualization for that VM.  Usermode
+should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 10815b672a26..61e9050a3488 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1233,6 +1233,7 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+	bool enable_pmu;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5aa45f13b16d..d4de52409335 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 
-	if (!enable_pmu)
+	if (!vcpu->kvm->arch.enable_pmu)
 		return NULL;
 
 	switch (msr) {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 03fab48b149c..4e5b1eeeb77c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry || !enable_pmu)
+	if (!entry || !vcpu->kvm->arch.enable_pmu)
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eaa3b5b89c5e..0803a1388bbf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -110,6 +110,8 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
+#define KVM_CAP_PMU_VALID_MASK KVM_CAP_PMU_DISABLE
+
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
@@ -4331,6 +4333,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	case KVM_CAP_PMU_CAPABILITY:
+		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
+		break;
 	}
 	default:
 		break;
@@ -6005,6 +6010,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exit_on_emulation_error = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_PMU_CAPABILITY:
+		r = -EINVAL;
+		if (!enable_pmu || (cap->args[0] & ~KVM_CAP_PMU_VALID_MASK))
+			break;
+		mutex_lock(&kvm->lock);
+		if (!kvm->created_vcpus) {
+			kvm->arch.enable_pmu = !(cap->args[0] & KVM_CAP_PMU_DISABLE);
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -11591,6 +11607,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;
+	kvm->arch.enable_pmu = enable_pmu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..3d6046295755 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_PMU_CAPABILITY 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1970,6 +1971,8 @@ struct kvm_dirty_gfn {
 #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
 #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
 
+#define KVM_CAP_PMU_DISABLE                    (1 << 0)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 5191b57e1562..3d6046295755 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_PMU_CAPABILITY 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1970,6 +1971,8 @@ struct kvm_dirty_gfn {
 #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
 #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
 
+#define KVM_CAP_PMU_DISABLE                    (1 << 0)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
-- 
2.35.1.265.g69c8d7142f-goog

