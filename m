Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003024967E2
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 23:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiAUW3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 17:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiAUW3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 17:29:41 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB8AC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:41 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p5-20020a170902bd0500b00148cb2d29ecso2205894pls.4
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aZXYB5NNtr+RbhBC4kyZ2vlroC6uq8YHN+NOx6a9vLM=;
        b=U2CorhnwekRPgqhGdhSv8a4HFBM3Oj183a61VKxsGXgdOEDbJoQ2UAfOjE08Q9nBFE
         sIljfqum22VNAtHFshKK12tr40hx56f1aezFx+SzOBZo02r3BkYrl/KFL2/xW5af9oHu
         8GTUNgxs8XbNjVJ7bE0+SxaffIG3L28KymwmDHrs5cDLzG19w81uXmAoTwcP7XetVlI3
         VUvfS6tj+qLt5XVFyOio4Ts+7SKfl5dB1pejL/WBY3Jz5J8GfuokobLUJjocdYrxf7JK
         1OTDHmtfOlOvUc4VVixB+xzJimO+ox4wNGTFShx9FifiNjMsBxmOk5echmeI8ckYsGjc
         WVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aZXYB5NNtr+RbhBC4kyZ2vlroC6uq8YHN+NOx6a9vLM=;
        b=ovHjhIMZezt4Nf1ICZJNDjfuwEQuMaHQGOqQo7Bpuu4QwEwTiGErhgVLESFgEL7+8G
         q4CKg+cva62hUppHUSNcy8EO3OfI4wWM9Ypm6j4yKBueiMUgjUA0wxKUMYc8bmApyIpG
         ne8Bbb/8J/U8x4bhmyYRfFtmgE2fLt2fsbgGgkjD8URbClgAgq/5raUfiWIoZybYPPS8
         fFCAfWz3itF99D6GMeAULSNtgVAPgBIjD6JaFylymilnjS7cIfJykmacBmsyoYWaON52
         TDDUnF8hnga7PJoND6ed3tLPYEzI1WQ25UKJ1EhoNd5wsAbMUH/bqggNkRZa0K1+hH9q
         THYw==
X-Gm-Message-State: AOAM530x0radhXcVBjMiKhUQ0nKM/zifkbDrw/1L/+SrEAYNoyedTLEL
        FhVdsrV00imdtzWucO9YRk3tGeYdNRL+2Z+nowSD+mTBXC1USYc6OBlQPpIx8eyRu/cfKVQntj4
        KZN8CDsFybZlLdDFzGzPACNF+V3b6EmZ+/1DIPn8JZWLMqVG7mzvDkNozgpbDnx6Gaw==
X-Google-Smtp-Source: ABdhPJzJmB9OJX1ii7VKmaukAPXesK904rsyUYeGXtTm/5ZmrL+vddoZalJuPVXfjeY9dS70+xFQti83zJgxcnM=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a63:d417:: with SMTP id
 a23mr4270560pgh.297.1642804180673; Fri, 21 Jan 2022 14:29:40 -0800 (PST)
Date:   Fri, 21 Jan 2022 22:29:31 +0000
In-Reply-To: <20220121222933.696067-1-daviddunn@google.com>
Message-Id: <20220121222933.696067-2-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121222933.696067-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v4 1/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
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
index 9563d294f181..a361cf6e8604 100644
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
 
+#define KVM_CAP_PMU_DISABLE                    (1 << 0)
+#define KVM_CAP_PMU_MASK                       (KVM_PMU_CONFIG_DISABLE)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
-- 
2.35.0.rc0.227.g00780c9af4-goog

