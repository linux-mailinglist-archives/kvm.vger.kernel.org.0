Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA21323925
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 10:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhBXJBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 04:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhBXJAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 04:00:54 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1239BC06174A
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 01:00:14 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e199so1420298pfh.11
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 01:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=xND5NPzVXfLcbqvng9kSRm35uak6gASQPEje4KIW2sA=;
        b=Q1DdZaQStS40ic6KaBUaznLddsLyINwWVJb+JB6SFucjVubHP8iiXYYFmRABzR89XG
         r2VV2WfBXrUNGR9iwZfgpO8pht2wzI7KJKJieqqqaYfCn2YS2DpSm3n9eXpN+wPG0DWi
         CNg6lLKgvbEDD11OXbl+I25vLw87mKWr8YRnQIAD+rt0q/pukrM6xqo1ijMMaBU63jA1
         mBnIgc8+3e5j6YyCwOU+/Er9/ldS10YtasQDKxs1yO82XCh3rI12Wp3j7dFdOUul4WRp
         pzhZFeC0XVbDQ9MCIvSfmE8mzEoiivSyGI8ZvJ8j2jyLeTZ8L/KgbvDggjHT2i7yn6PD
         xPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=xND5NPzVXfLcbqvng9kSRm35uak6gASQPEje4KIW2sA=;
        b=XZLumKy74Bq2++McdcPHlK8VAzhbbv0hSQzcdDy4KiLpHikNL6+KasBGVKQPMsq8qz
         9fv9cnmxlZHbNCSvw+fUIIVrJwpglAeI/vPPRS2M3nCl+LG+ffIHhBJoUNx1TlGSVpdw
         q3TOZp/w7vv9bTg4hmVWu9HQ4hBEV9N3ElXD00IUcPA7wMfLW2NdFtayfoKEwaWvp1sL
         cCvd9bKneMLRXescA40HhiuvQekJHjTbdNeT8ZUG5YdQfE7JFkLPpfJhjmxH/yK3CUsh
         lPsIGLqJ3qIOoqcpsMU3P0edg/c5ss1by/iWB+vFnPsUqM5hGpWEaxwXCSGZXlC8/+cf
         0eJw==
X-Gm-Message-State: AOAM530MyXHDfljC2E0s5Rbyn70kB20dDuI7swnWA/wwhvuELvXuBmKU
        Z7+dys7v/7MMChoViaGbWDyzn8ujvg==
X-Google-Smtp-Source: ABdhPJyCgOMbxMWcaSPF6FC9POMDZNNUmc5ybqqQS3quJMs+8n4Jm271E9ajaFsSyEAXSkkk7Y/VuAOKRQ==
Sender: "natet via sendgmr" <natet@natesp.c.googlers.com>
X-Received: from natesp.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:5758])
 (user=natet job=sendgmr) by 2002:a17:902:ed82:b029:e2:d106:e76d with SMTP id
 e2-20020a170902ed82b02900e2d106e76dmr30689065plj.46.1614157213381; Wed, 24
 Feb 2021 01:00:13 -0800 (PST)
Date:   Wed, 24 Feb 2021 08:59:15 +0000
Message-Id: <20210224085915.28751-1-natet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [RFC] KVM: x86: Support KVM VMs sharing SEV context
From:   Nathan Tempelman <natet@google.com>
To:     pbonzini@redhat.com
Cc:     natet@google.com, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com, rientjes@google.com,
        brijesh.singh@amd.com, Ashish.Kalra@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a capability for userspace to mirror SEV encryption context from
one vm to another. On our side, this is intended to support a
Migration Helper vCPU, but it can also be used generically to support
other in-guest workloads scheduled by the host. The intention is for
the primary guest and the mirror to have nearly identical memslots.

The primary benefits of this are that:
1) The VMs do not share KVM contexts (think APIC/MSRs/etc), so they
can't accidentally clobber each other.
2) The VMs can have different memory-views, which is necessary for post-copy
migration (the migration vCPUs on the target need to read and write to
pages, when the primary guest would VMEXIT).

This does not change the threat model for AMD SEV. Any memory involved
is still owned by the primary guest and its initial state is still
attested to through the normal SEV_LAUNCH_* flows. If userspace wanted
to circumvent SEV, they could achieve the same effect by simply attaching
a vCPU to the primary VM.
This patch deliberately leaves userspace in charge of the memslots for the
mirror, as it already has the power to mess with them in the primary guest.

This patch does not support SEV-ES (much less SNP), as it does not
handle handing off attested VMSAs to the mirror.

For additional context, we need a Migration Helper because SEV PSP migration
is far too slow for our live migration on its own. Using an in-guest
migrator lets us speed this up significantly.

Signed-off-by: Nathan Tempelman <natet@google.com>
---
 Documentation/virt/kvm/api.rst  | 17 +++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 82 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  2 +
 arch/x86/kvm/svm/svm.h          |  2 +
 arch/x86/kvm/x86.c              |  7 ++-
 include/linux/kvm_host.h        |  1 +
 include/uapi/linux/kvm.h        |  1 +
 virt/kvm/kvm_main.c             |  8 ++++
 9 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 482508ec7cc4..438b647663c9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6213,6 +6213,23 @@ the bus lock vm exit can be preempted by a higher priority VM exit, the exit
 notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
 KVM_RUN_BUS_LOCK flag is used to distinguish between them.
 
+7.23 KVM_CAP_VM_COPY_ENC_CONTEXT_TO
+-----------------------------------
+
+Architectures: x86 SEV enabled
+Type: system
+Parameters: args[0] is the fd of the kvm to mirror encryption context to
+Returns: 0 on success; ENOTTY on error
+
+This capability enables userspace to copy encryption context from a primary
+vm to the vm indicated by the fd.
+
+This is intended to support in-guest workloads scheduled by the host. This
+allows the in-guest workload to maintain its own NPTs and keeps the two vms
+from accidentally clobbering each other with interrupts and the like (separate
+APIC/MSRs/etc).
+
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 84499aad01a4..b7636c009647 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1334,6 +1334,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	int (*vm_copy_enc_context_to)(struct kvm *kvm, unsigned int child_fd);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 874ea309279f..2bad6cd2cb4c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -66,6 +66,11 @@ static int sev_flush_asids(void)
 	return ret;
 }
 
+static inline bool is_mirroring_enc_context(struct kvm *kvm)
+{
+	return &to_kvm_svm(kvm)->sev_info.enc_context_owner;
+}
+
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(int min_asid, int max_asid)
 {
@@ -1124,6 +1129,10 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
 		return -EFAULT;
 
+	/* enc_context_owner handles all memory enc operations */
+	if (is_mirroring_enc_context(kvm))
+		return -ENOTTY;
+
 	mutex_lock(&kvm->lock);
 
 	switch (sev_cmd.id) {
@@ -1186,6 +1195,10 @@ int svm_register_enc_region(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
+	/* If kvm is mirroring encryption context it isn't responsible for it */
+	if (is_mirroring_enc_context(kvm))
+		return -ENOTTY;
+
 	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
 		return -EINVAL;
 
@@ -1252,6 +1265,10 @@ int svm_unregister_enc_region(struct kvm *kvm,
 	struct enc_region *region;
 	int ret;
 
+	/* If kvm is mirroring encryption context it isn't responsible for it */
+	if (is_mirroring_enc_context(kvm))
+		return -ENOTTY;
+
 	mutex_lock(&kvm->lock);
 
 	if (!sev_guest(kvm)) {
@@ -1282,6 +1299,65 @@ int svm_unregister_enc_region(struct kvm *kvm,
 	return ret;
 }
 
+int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
+{
+	struct file *mirror_kvm_file;
+	struct kvm *mirror_kvm;
+	struct kvm_sev_info *mirror_kvm_sev;
+	unsigned int asid;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	mutex_lock(&kvm->lock);
+
+	/* Mirrors of mirrors should work, but let's not get silly */
+	if (is_mirroring_enc_context(kvm)) {
+		ret = -ENOTTY;
+		goto failed;
+	}
+
+	mirror_kvm_file = fget(mirror_kvm_fd);
+	if (!kvm_is_kvm(mirror_kvm_file)) {
+		ret = -EBADF;
+		goto failed;
+	}
+
+	mirror_kvm = mirror_kvm_file->private_data;
+
+	if (mirror_kvm == kvm || is_mirroring_enc_context(mirror_kvm)) {
+		ret = -ENOTTY;
+		fput(mirror_kvm_file);
+		goto failed;
+	}
+
+	asid = *&to_kvm_svm(kvm)->sev_info.asid;
+
+	/*
+	 * The mirror_kvm holds an enc_context_owner ref so its asid can't
+	 * disappear until we're done with it
+	 */
+	kvm_get_kvm(kvm);
+
+	mutex_unlock(&kvm->lock);
+	mutex_lock(&mirror_kvm->lock);
+
+	/* Set enc_context_owner and copy its encryption context over */
+	mirror_kvm_sev = &to_kvm_svm(mirror_kvm)->sev_info;
+	mirror_kvm_sev->enc_context_owner = kvm;
+	mirror_kvm_sev->asid = asid;
+	mirror_kvm_sev->active = true;
+
+	mutex_unlock(&mirror_kvm->lock);
+	fput(mirror_kvm_file);
+	return 0;
+
+failed:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1293,6 +1369,12 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	mutex_lock(&kvm->lock);
 
+	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
+	if (is_mirroring_enc_context(kvm)) {
+		kvm_put_kvm(sev->enc_context_owner);
+		return;
+	}
+
 	/*
 	 * Ensure that all guest tagged cache entries are flushed before
 	 * releasing the pages back to the system for use. CLFLUSH will
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 42d4710074a6..5308b7f8c11c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4608,6 +4608,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
+	.vm_copy_enc_context_to = svm_vm_copy_asid_to,
+
 	.can_emulate_instruction = svm_can_emulate_instruction,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..1e65c912552d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -65,6 +65,7 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 };
 
 struct kvm_svm {
@@ -561,6 +562,7 @@ int svm_register_enc_region(struct kvm *kvm,
 			    struct kvm_enc_region *range);
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
+int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int child_fd);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3fa140383f5d..7bbcf37fcc2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3753,6 +3753,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+	case KVM_CAP_VM_COPY_ENC_CONTEXT_TO:
 		r = 1;
 		break;
 	case KVM_CAP_XEN_HVM:
@@ -4649,7 +4650,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 			kvm_update_pv_runtime(vcpu);
 
 		return 0;
-
 	default:
 		return -EINVAL;
 	}
@@ -5321,6 +5321,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.bus_lock_detection_enabled = true;
 		r = 0;
 		break;
+	case KVM_CAP_VM_COPY_ENC_CONTEXT_TO:
+		r = -ENOTTY;
+		if (kvm_x86_ops.vm_copy_enc_context_to)
+			r = kvm_x86_ops.vm_copy_enc_context_to(kvm, cap->args[0]);
+		return r;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e126ebda36d0..18491638f070 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -637,6 +637,7 @@ void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
+bool kvm_is_kvm(struct file *file);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 63f8f6e95648..5b6296772db9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
+#define KVM_CAP_VM_COPY_ENC_CONTEXT_TO 194
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 001b9de4e727..5f31fcda4777 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -739,6 +739,8 @@ void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
 }
 
+static struct file_operations kvm_vm_fops;
+
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
@@ -903,6 +905,12 @@ void kvm_put_kvm(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_put_kvm);
 
+bool kvm_is_kvm(struct file *file)
+{
+	return file && file->f_op == &kvm_vm_fops;
+}
+EXPORT_SYMBOL_GPL(kvm_is_kvm);
+
 /*
  * Used to put a reference that was taken on behalf of an object associated
  * with a user-visible file descriptor, e.g. a vcpu or device, if installation
-- 
2.30.0.617.g56c4b15f3c-goog

