Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CDE4AF880
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbiBIR3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiBIR3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:29:50 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4936DC0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:29:53 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id z12-20020a17090a1fcc00b001b63e477f9fso2114470pjz.3
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Mb03SItjo55ZPsSHbw8i8qIOyjBuu5+GBiaBDmefomY=;
        b=TgyvBw4T57OXvTyqbg9wUHHZ6CUISNxEPJPSEim8TjEkaKtIfJGO2T27LDa6q7dOKA
         840UplkQg0cHbNwakMZezXazJzF4pgDyil+xFFiAAg9kAMEpjoNtMTv3L5p4KVa/KOP9
         MCXceafRwI1WhaSYgTNGGhUrMmK7npQ0gwYU+L5N5PelGQnsMbBgKHvb56N/7sNMIVrU
         ErriqxQ8o9t0IuIY5iE6RJ3m2Gu1OW7mMXM28ASIrvjMMvs2Q/6/tY5JbHxNFIBlJNUU
         lPwLW5YY9zJJICfFaZbpFeefJj91ZOrG1iX2pDLAYwdnPGhs4CNtkB78uRYKxYEfPDDb
         Q/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Mb03SItjo55ZPsSHbw8i8qIOyjBuu5+GBiaBDmefomY=;
        b=iDTQXjqzrueiqkKaWag7uPyezJysLsZc7PA/BKX8MSe/Q8A8hMCfM64Enf/tiM4Aqs
         kBTCcD6g/Vx21XjkgsmXfHn3FZzE8t2oq7yBhsm9WerUNSyGXlZ7wBvMI/t+l8Kmk62x
         IadTItOJ8a+sKeaGuU7P71D2qgORnZaBdV3q6re40S3LZVk9UmMp8Om1mOt9FtpF9W3J
         MxPg8LTnX+juXzgTE37w/T7FZGaWrfWf6HlQx6dTx73SSek/i4vR5Vjx1Cel/QywLibP
         5Db08dQQHXsICPYgWf5+nseDq1meA01hQVUO85lw/fQKJ+RVxfMQRC8UAQrYFNiug1Uf
         b6Lg==
X-Gm-Message-State: AOAM531BsPV7PvTII0wPECilPGbGhbsb01ZWZJHqr35hvOhtap4wGJHu
        XxRBYN8PZ1jAkzVNZXUV+6757nHk9JHZ3V0=
X-Google-Smtp-Source: ABdhPJzJuwCMIj1ZCtdnJqpy1qx4IpKNvuKOlLqEcdg0qzUW3SzydnYH+A7CJMoRgW7eQyeXPkYWXVPHRT3X6YE=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:903:230c:: with SMTP id
 d12mr3155012plh.74.1644427792733; Wed, 09 Feb 2022 09:29:52 -0800 (PST)
Date:   Wed,  9 Feb 2022 17:29:43 +0000
In-Reply-To: <20220209172945.1495014-1-daviddunn@google.com>
Message-Id: <20220209172945.1495014-2-daviddunn@google.com>
Mime-Version: 1.0
References: <20220209172945.1495014-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v6 1/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
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
index c371ee7e45f7..f832cd0f9b27 100644
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
index 6f69f3e3635e..c35a6a193bf4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4329,6 +4329,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	case KVM_CAP_PMU_CAPABILITY:
+		r = enable_pmu ? KVM_CAP_PMU_MASK : 0;
+		break;
 	}
 	default:
 		break;
@@ -6003,6 +6006,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
@@ -11630,6 +11641,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;
+	kvm->arch.enable_pmu = enable_pmu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..cf6774cc18ef 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_PMU_CAPABILITY 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1970,6 +1971,9 @@ struct kvm_dirty_gfn {
 #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
 #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
 
+#define KVM_CAP_PMU_DISABLE                    (1 << 0)
+#define KVM_CAP_PMU_MASK                       (KVM_CAP_PMU_DISABLE)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index b46bcdb0cab1..00fb392e1742 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_PMU_CAPABILITY 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1973,6 +1974,9 @@ struct kvm_dirty_gfn {
 #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
 #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
 
+#define KVM_CAP_PMU_DISABLE                    (1 << 0)
+#define KVM_CAP_PMU_MASK                       (KVM_PMU_CONFIG_DISABLE)
+
 /**
  * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
  * @flags: Some extra information for header, always 0 for now.
-- 
2.35.0.263.gb82422642f-goog

