Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84594974CA
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 19:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiAWSpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 13:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiAWSpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 13:45:52 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E69FC06173D
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 10:45:51 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t18-20020a63dd12000000b00342725203b5so8430287pgg.16
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 10:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=D5qM96Ol3YV2lp+i1j+g/Smh2OlqtuOLSTcd520xQO4=;
        b=hDiQclMqZ+cGpQZmriesJzt0cPF43oixzMorYGW7/Tq+7RlNgXtlsoXViICjajeHo2
         q91sGBn9yIKsJQgUIzVTfRs/QIMVyms3bw5yDoRvqmThLsXivOC56D0P0e639mCAiZAZ
         HxS11blov0tfP+wxj3ZgeORshLXXA9+qiAG7wRqM3/p0brWywwfLXnOQLYivdX3rrE3s
         xh4lUo9JwwIXu01sigtRo7PXwomsmRjGbl8jQd6MKAkpaNGwbVae/TzIL7raiGwGq0l5
         DUUruhEYh3wuOdWq/3KneIxLkE5Iotws0EagCz+A1C51jHwcatAL9gMWK0YWr2s/7i0B
         jMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D5qM96Ol3YV2lp+i1j+g/Smh2OlqtuOLSTcd520xQO4=;
        b=AhbYW2Dvfq4+NEYZs7iE0pT6NnoaJttt/X/XQ23FPiNzE5eWu45KfZPEq6E8u8g/X0
         zxZGXw66VhsufMVmAwSD/ajrMp9RB1ORsJMpvwlqxHEVQnWe3ZWJ/56TaRakZ/54vu8G
         +abVJLCi51GE1DIbErPb9cdgFpj05vkM4BP35fEvc7YnHEZA6i6iW67KhW7a3gXADcZa
         28yiGsvTfAKWNgFBSwcmVC1br0vk2KM46SdGiVy3Lsy5j2ymTEvnTqUMSPdp6alybhqs
         XDxeqtJANbJ74AWOLTq8MiWMxNA+yFPsO0KU4QirQETDADIiLowuTBC0lP42IT0s+5sU
         rrhg==
X-Gm-Message-State: AOAM531nDm7dckR989fkFUXLw7ZAROp4IpPYOfh5dpB1DEvSIo/znK0q
        Ec5ZsjoeLDplQn0MsT6STCvf8n9XXATEbRtA8fSKu6Ztu0WeKhSdrCkRt3TxvxDYnc/4HbFYUIp
        CW3bFYuTmdPxNIhZKvD2D5d9qRBp3Da5GWhPFsU6Vy3E7+1YtIc5aCM1pGRtqFlfC6A==
X-Google-Smtp-Source: ABdhPJyBMRDJIq7BqNC/7t72XBzNyDLYpT8RD9WCpj+SzNLRHkzBKDXCW529Oi66uZ0t36aNu0nsVnMb8RjhdOQ=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:902:6901:b0:149:4e89:2d45 with SMTP
 id j1-20020a170902690100b001494e892d45mr11310142plk.22.1642963550887; Sun, 23
 Jan 2022 10:45:50 -0800 (PST)
Date:   Sun, 23 Jan 2022 18:45:39 +0000
In-Reply-To: <20220123184541.993212-1-daviddunn@google.com>
Message-Id: <20220123184541.993212-2-daviddunn@google.com>
Mime-Version: 1.0
References: <20220123184541.993212-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v5 1/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
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

For VMs that have PMU virtualization disabled, usermode will need to
clear CPUID leaf 0xA to notify guests.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 include/uapi/linux/kvm.h        |  4 ++++
 tools/include/uapi/linux/kvm.h  |  4 ++++
 7 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bb8cfddbb22d..ae0d52c5359e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7559,3 +7559,25 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
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

