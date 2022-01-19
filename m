Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D0F493FDF
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356717AbiASS20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244082AbiASS2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 13:28:25 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F29C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:28:25 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 19-20020a17090a001300b001b480b09680so2280894pja.2
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kC6elWjXhiQzM3dfT/1g4Hf/d6gd/gh+kSa3O2yzp3A=;
        b=AXwRuIY5F+0nmXtuUOfeY08UjqYhP0l6r4/9mZURGrDVP36ZWwq/+blAq4sdWvRCQO
         WUOnVCayxomj3rFxTruDjEv/hY4TQ15vXls9jeXqCasI7aIwKVqBECyCk+WUeAeEfy9V
         ri3pqPJ0Hd/VvsEyn9gIbrq+PndP3Id1CpHIZEF1144Zi1qCSGyJL3u3qrDimnQCYbOZ
         67OhnHX0179XAFunD5rG32NBmnbuTqhQz4OYclEZw+JB5/O1oj5dt8mhuTr9aW+Ms4P4
         cRx9JXNVDJv5ksgqx7zU+j1hUc610CG9UBnTVjrX0VKRcYlMuPqYMfhH/siEld0YVfWs
         O1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kC6elWjXhiQzM3dfT/1g4Hf/d6gd/gh+kSa3O2yzp3A=;
        b=UkPdOX31Pqkuqc8VMendyjzutTvWyc1RWJhUeIP6txMuSdDCUKPblhyA5xmg2apmXe
         nt6h8KonGLpeUBI48VRih5TXtHssriPt25wIJ9YYfXjSEa7v8mtBwEZ3yEr8lSQRdazG
         iHwhCBk88tKRaE7EtU1xsqT6qJ9PVoPFqw0z/DdOVYRzZBVOMOhInkaSg6NBQpP9jTOS
         ZiMuQ1hUORblt0qwfVI0O6SX+e+irlXk/ZumUGwHOYAWeE1C5rI4pZ5e1fvXwlpbCeSN
         mqWCrCr/4dnlPlkTzzln69fELRRfoSgaL36iBUgtLz3QAmD+E8f59deDcaI+CATmsYOC
         XtDQ==
X-Gm-Message-State: AOAM531l/ox3XuSO64RZqjJdtKif0sZ2piQDpc+y6Ix6yo9HOacNJ2l7
        0xCQ5fjFUS2+ZltO9pJORU/iIlhXfQmb7lim8P86imjmh3KSTpv8TQNHpy7YQJEtZk9PxTmHHmT
        AmPiEMzNBwVA1YFuXR5eC4/tlSTxN51XVo0UK4J2KHEHhc2FQVWagWiyVoKDzbwOnjw==
X-Google-Smtp-Source: ABdhPJxfW0Xln8FWZV+q5Nrb0BWJxqNS328F8RP4ozxHU/NyNuzn3JkzBnhDutQUWixzFoekdtL9RcTwUgNIavw=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a05:6a00:24c2:b0:4bc:bea:1e60 with SMTP
 id d2-20020a056a0024c200b004bc0bea1e60mr31541182pfv.63.1642616904746; Wed, 19
 Jan 2022 10:28:24 -0800 (PST)
Date:   Wed, 19 Jan 2022 18:28:16 +0000
Message-Id: <20220119182818.3641304-1-daviddunn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 1/3] Provide VM capability to disable PMU virtualization for
 individual VMs
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When PMU virtualization is enabled via the module parameter, usermode
can disable PMU virtualization on individual VMs using this new
capability.

This provides a uniform way to disable PMU virtualization on x86.  Since
AMD doesn't have a CPUID bit for PMU support, disabling PMU
virtualization requires some other state to indicate whether the PMU
related MSRs are ignored.

Since KVM_GET_SUPPORTED_CPUID reports the maximal CPUID information
based on module parameters, usermode will need to adjust CPUID when
disabling PMU virtualization on individual VMs.  On Intel CPUs, the
change to PMU enablement will not alter existing until SET_CPUID2 is
invoked.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
 arch/x86/kvm/x86.c              | 11 +++++++++++
 include/uapi/linux/kvm.h        |  1 +
 tools/include/uapi/linux/kvm.h  |  1 +
 6 files changed, 16 insertions(+), 2 deletions(-)

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
index 5aa45f13b16d..605bcfb55625 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 
-	if (!enable_pmu)
+	if (!enable_pmu || !vcpu->kvm->arch.enable_pmu)
 		return NULL;
 
 	switch (msr) {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..4c3885765027 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry || !enable_pmu)
+	if (!entry || !vcpu->kvm->arch.enable_pmu || !enable_pmu)
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..9b640c5bb4f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4326,6 +4326,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	case KVM_CAP_ENABLE_PMU:
+		r = enable_pmu;
+		break;
 	}
 	default:
 		break;
@@ -5937,6 +5940,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exit_on_emulation_error = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_ENABLE_PMU:
+		r = -EINVAL;
+		if (!enable_pmu || cap->args[0] & ~1)
+			break;
+		kvm->arch.enable_pmu = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -11562,6 +11572,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;
+	kvm->arch.enable_pmu = true;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9563d294f181..37cbcdffe773 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
+#define KVM_CAP_ENABLE_PMU 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f066637ee206..e71712c71ab1 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1132,6 +1132,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_XSAVE2 207
+#define KVM_CAP_ENABLE_PMU 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1.703.g22d0c6ccf7-goog

