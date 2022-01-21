Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91B3496717
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 22:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiAUVHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 16:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiAUVHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 16:07:24 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F26C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:24 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id f24-20020aa782d8000000b004bc00caa4c0so6672055pfn.3
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GNhPVsMrmglqoIaHPPRxp4hmF1lZH9T5SC33+eOT8a8=;
        b=sTCdfGE3XCRnqMnViBslvjLo8IBROvItwaWlFWgXIS/uPOYB+WFDhC/OvsO9NhQFSA
         Yy1qG4uNfip0UiD5urMnMUMQV0kFHapSlHzPzpAzc/z8f5dXxonz4a4NWtGiAILV92Et
         Tt6rNHsjvvuB9rXDdlG92nNbo0X7GoBGvuenlqM9sXDp6QJAkZb7LqG1Vddfz20NSvE7
         ErjgSL/dsa9ncbXKtPfz1l6H3yAqMnwfNgjeP5+V46kganGFU5lAFEylP9Fkp3zCWMnt
         PuoUysaRktXjcpEDWUVgMHaL182WDsUisd06GiHK6DJvR/T7H6woe/cFOXcP8HBorLAg
         3wmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GNhPVsMrmglqoIaHPPRxp4hmF1lZH9T5SC33+eOT8a8=;
        b=LLNvKMtovEdS3WzQX4fcaWRzeJsULVrNBFuIPMz4SXDMh0P4J40TTYo13/ns5RWhoQ
         RIp1kXKX/YOiV/5FDsXASytL51Zm37PzgIDxzFZsFv/R+1FS/FIAvDE6YYq1rqaSIftk
         DnmxE0hddSyzexOEsAFQ4EEE+KEtujjihbnRdDXw0ixuJcrdDcrVeZy4BLsrFa42kA8C
         IfuDeC2o5BQA2wQjtADP0bIrlAf0bENDR9TMrszMh676Si8LkwPFWOfjcGXl2Re5b2CI
         W1i0dAqPPOx9acv2YTtzjzcfgW+R+ozB/Pan0QQ8SzwK3JzvEVJB6wxqpZT1VgIcX+Rc
         /e3Q==
X-Gm-Message-State: AOAM531WdwVNyh7Xa41wN9uWuiiKOqrNx/Lg4C3VSj8O1yIgRt/HJJIs
        MQ34GjUxC3mUcV/qoZNNdacIi4Xc1bts5LpMeqFy3wgiDJZLixhvYj5boIP2C25EQJE27r04BXV
        s8jY0YI9SgHhiNAc5VMfFgV1+RpNhQsK9wOtcOd/HFixSttoGVYgtFAkCDEnmePPqRg==
X-Google-Smtp-Source: ABdhPJzzlnfigAXjz8L55GlSNAmP3nUBUe2J15lU0q1VGY60ykkDSfY10hdtO7/ltDGXXfiHYLh1qXGYaI+vag4=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a63:d312:: with SMTP id
 b18mr4153589pgg.440.1642799243468; Fri, 21 Jan 2022 13:07:23 -0800 (PST)
Date:   Fri, 21 Jan 2022 21:07:00 +0000
In-Reply-To: <20220121210702.635477-1-daviddunn@google.com>
Message-Id: <20220121210702.635477-2-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121210702.635477-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v3 1/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_PMU_DISABLE is used to disable PMU virtualization on individual
x86 VMs.  PMU configuration must be done prior to creating VCPUs.

To enable future extension, KVM_CAP_PMU_CAPABILITY reports available
settings via bitmask when queried via check_extension.

For VMs that have PMU virtualization disabled, CPUID leaf 0xA will be
cleared to notify guests.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 Documentation/virt/kvm/api.rst  | 21 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  8 ++++++++
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 include/uapi/linux/kvm.h        |  4 ++++
 tools/include/uapi/linux/kvm.h  |  4 ++++
 8 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bb8cfddbb22d..375d35e8ac47 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7559,3 +7559,24 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
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
+this capability will disable PMU virtualization for that VM.  When
+PMU virtualization is disabled, CPUID leaf 0xA will always be cleared
+to properly inform Intel guests.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 682ad02a4e58..5cdcd4a7671b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1232,6 +1232,7 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+	bool enable_pmu;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28fb6cb..a91c4a00c913 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -217,6 +217,14 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
+	best = cpuid_entry2_find(entries, nent, 0xA, 0);
+	if (best && !vcpu->kvm->arch.enable_pmu) {
+		best->eax = 0;
+		best->ebx = 0;
+		best->ecx = 0;
+		best->edx = 0;
+	}
+
 	best = cpuid_entry2_find(entries, nent, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
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
index 466d18fc0c5d..2c5868d77268 100644
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
index 55518b7d3b96..a033f019a3f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4326,6 +4326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	case KVM_CAP_PMU_CAPABILITY:
+		r = enable_pmu ? KVM_CAP_PMU_MASK : 0;
+		break;
 	}
 	default:
 		break;
@@ -5937,6 +5940,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exit_on_emulation_error = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_PMU_CAPABILITY:
+		r = -EINVAL;
+		if (!enable_pmu || kvm->created_vcpus > 0 ||
+		    cap->args[0] & ~KVM_CAP_PMU_MASK)
+			break;
+		kvm->arch.enable_pmu = !(cap->args[0] & KVM_CAP_PMU_DISABLE);
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -11562,6 +11573,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;
+	kvm->arch.enable_pmu = enable_pmu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9563d294f181..1c5e6e172817 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
+#define KVM_CAP_PMU_CAPABILITY 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1972,6 +1973,9 @@ struct kvm_dirty_gfn {
 #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
 #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
 
+#define KVM_CAP_PMU_DISABLE                    (1 << 0)
+#define KVM_CAP_PMU_MASK                       (KVM_CAP_PMU_DISABLE)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 9563d294f181..104686806d2f 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
+#define KVM_CAP_PMU_CAPABILITY 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1972,6 +1973,9 @@ struct kvm_dirty_gfn {
 #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
 #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
 
+#define KVM_PMU_CONFIG_DISABLE                 (1 << 0)
+#define KVM_PMU_CONFIG_VALID                   (KVM_PMU_CONFIG_DISABLE)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
-- 
2.35.0.rc0.227.g00780c9af4-goog

