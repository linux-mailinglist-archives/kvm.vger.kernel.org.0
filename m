Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCE149575C
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 01:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378401AbiAUAaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 19:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347824AbiAUAaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 19:30:19 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EF5C061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:19 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id m200-20020a628cd1000000b004c7473d8cb5so209586pfd.5
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=39yPp9RoXGDts+zygPxTJfWP0AtmMcXoUZ2TJ95lwms=;
        b=BYnwiV2u7Bmm9SG+BxxiKqw+fK+xa1I2gkPyQ7cO5OpBQMcfaBs5hyrGgVkf4l89K8
         yUqIh9DpHkXcnFWzrq4y+Da8BQ3FdoxukhYccUApM43zithPh+DpMTDMGHxqCnTUWO4X
         sV2xhwhfIwpAaBS/ulIxFBelY1CJR9HoL3YLnxUqmT2+Rs75JTRPrEqHC7Y7ayBRV5W3
         S5xzOTB9GKSt88kiOW8burqDpJB1imJ+inX1vlTcvjlUP937XDioq9xGDqHaWjGIWjsc
         XOTv1UqqO8w8XR5iI9vLfEzEf15ONuSm31xM9CRDex5sSJ8nmzgn4KH+2O+erh/f7UbD
         RahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=39yPp9RoXGDts+zygPxTJfWP0AtmMcXoUZ2TJ95lwms=;
        b=7J35S09E0G3pOoYQ1+7mSraTs9Rg76YYqSflIO2NM3pA+1nIcCV7V4+jUafN4dy9Yf
         mqvYY6FyvcgjzvW4rHsVehvCkVc1IJioFQfDJW/q14Ta1ep0CNdBAD5ZPiWREChTtjr/
         sFLf49z2dPQQ8b3WSoGQ1PIlyGI3v4iolQjMnLd0GsjJhd4psRji1HMSsFOCkC/8TdZU
         FcuBxAL71aprLSS/YIYkPXFFVveQSKjQWn8FHvWyIbGpBNutdkW43nWK+41sOJqXb5MV
         2Nz9IMXNWy67F+1BL6Vt3RfnoJnH+QxTOTO1kzqted0y0Z0V0jzYXxeBJwMV7Lkdl/aV
         nfzg==
X-Gm-Message-State: AOAM530KTDstQiTZ3vX70DKJtqAc/uFPAPPPJTpO9l9ve8sVRRp+CC5h
        dUVUiOL5IqF0/DjDrAIlHuo08mQiqTjY76MV0B9KEWaBt4AbSw8EDASH7c5X0PUVlOEkpFtwzcR
        4H+x+4EEsvIdx7LJzcmXA0PMaRloKp0RwfPMhLnXy0BHGBNVw63gdHyNJrnW/VUb7UQ==
X-Google-Smtp-Source: ABdhPJzCLBeCtgb5GweHQQLf5y01BOZqcDQEhr1DlYZh6P8iFuDLVy+Zyc4XveNb5JpOc7/cRnPAPuOHzFwkwGc=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:902:ecca:b0:14a:e540:6c76 with SMTP
 id a10-20020a170902ecca00b0014ae5406c76mr1369427plh.20.1642725018840; Thu, 20
 Jan 2022 16:30:18 -0800 (PST)
Date:   Fri, 21 Jan 2022 00:29:50 +0000
In-Reply-To: <20220121002952.241015-1-daviddunn@google.com>
Message-Id: <20220121002952.241015-2-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121002952.241015-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 1/3] Provide VM capability to disable PMU virtualization
 for individual VMs
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_PMU_CONFIG_DISABLE can be used to disable PMU virtualization on
individual x86 VMs.  PMU configuration must be done prior to creating
VCPUs.

To enable future extension, KVM_CAP_PMU_CONFIG reports available
settings when queried via check_extension.

Since KVM_GET_SUPPORTED_CPUID reports the maximal CPUID information
based on module parameters, usermode will need to adjust CPUID when
disabling PMU virtualization on individual VMs.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 include/uapi/linux/kvm.h        |  4 ++++
 tools/include/uapi/linux/kvm.h  |  4 ++++
 6 files changed, 23 insertions(+), 2 deletions(-)

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
index 55518b7d3b96..42a98635bea5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4326,6 +4326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	case KVM_CAP_PMU_CONFIG:
+		r = enable_pmu ? KVM_PMU_CONFIG_VALID : 0;
+		break;
 	}
 	default:
 		break;
@@ -5937,6 +5940,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exit_on_emulation_error = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_PMU_CONFIG:
+		r = -EINVAL;
+		if (!enable_pmu || kvm->created_vcpus > 0 ||
+		    cap->args[0] & ~KVM_PMU_CONFIG_VALID)
+			break;
+		kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CONFIG_DISABLE);
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
index 9563d294f181..57a1280fa43b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
+#define KVM_CAP_PMU_CONFIG 209
 
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
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 9563d294f181..57a1280fa43b 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
+#define KVM_CAP_PMU_CONFIG 209
 
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

