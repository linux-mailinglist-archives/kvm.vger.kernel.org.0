Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EEE43699B
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhJURrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbhJURrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:47:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EF5C0432C9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:10 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z23-20020a17090ab11700b001a070e36178so772591pjq.3
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GM/73rFyOeaFxCM1RLNv0seYsNoPuU+uZe804g2V+sw=;
        b=NHWmn4sQmqx5Nn6EhnO5PnZknz5YrGiAuRm8pkVQqfLzVo22XSknG0ZkCbgKymipwu
         +PvQYQiUZteghv91rIHrYAB77vGk6waeWz+KjQQVfnV6Mbj0zTPSNgLBXTgHENnQ++k1
         ZjgvFtu7wTzLOGd0nAH2gry3PI9Qsfnn6V88eMTrykdbD2gNCuaFR9adPxlESNmrfbSj
         K3jyllTXRsZVmnaQp0dso5v6iu1tESaQQsL30inE9TT/cTwiUJPE7WfNxw88MT6AHWET
         no2kIt3o3xnCyxLPcpmNCKyV6YYczFtWlohuBJ3u7shhKUdXpT61wv15DPIDZr6O67w1
         HJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GM/73rFyOeaFxCM1RLNv0seYsNoPuU+uZe804g2V+sw=;
        b=r8pxYIu9iRL/iRkj/Zx0f/6NI+kkI5D1bVy479xyHzjI3Qw/8B0pQtOFtKjRsEePpL
         4rarTfw3Om5NjHF1Ua5xvWpFPgBYZRfKGXp26eWX1qWolsmV995Fdtf2Ym6qBbUxMBh+
         UNUJhglGD08zX3G6YvhdU1Me3/4uRHfFEKcUPtSn1JY8Kf30NEqjGAXrbG7g2z0juiHF
         xLYrujONwmK3BYmBv5qTYWMJjITMABfWs6BFaHVSE+JDEumEoTd3NyLDn5eqCNzjd9ex
         XCwVBoqbnSZXDvnOMq/4DIlgg5h/0spNJQ4knNcSyk48qD4WdTCxFHHcPqOSmLsgLMNH
         8DQg==
X-Gm-Message-State: AOAM531XVFHb/R3+swuiOaGscWFiQnsgUQpQI/F5l75t6ZlEwqXyvyFx
        rs5UCkHKyRfWvMqJNJrxzhc08xj8qKHRd8ZVHxmo5O+btNBG0QaRF7Ikr6cmKrI2wvMH/jS1bmz
        SCT2VN6unxtHLg+xBHL81OXf77p2xvhvX/uFphv+eJFgjGcbtkrnTx/rMZw==
X-Google-Smtp-Source: ABdhPJwQJTihnsj2SVeqdqeQd4IyUzG2eQBW3ccjmYxTH/PJnRk02GNxWo0AQH/jQtizN54BL+nFypdCfUk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:da2d:dcb2:6:add9])
 (user=pgonda job=sendgmr) by 2002:a63:a119:: with SMTP id b25mr5483958pgf.358.1634838190395;
 Thu, 21 Oct 2021 10:43:10 -0700 (PDT)
Date:   Thu, 21 Oct 2021 10:43:00 -0700
In-Reply-To: <20211021174303.385706-1-pgonda@google.com>
Message-Id: <20211021174303.385706-3-pgonda@google.com>
Mime-Version: 1.0
References: <20211021174303.385706-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH V11 2/5] KVM: SEV: Add support for SEV intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For SEV to work with intra host migration, contents of the SEV info struct
such as the ASID (used to index the encryption key in the AMD SP) and
the list of memory regions need to be transferred to the target VM.
This change adds a commands for a target VMM to get a source SEV VM's sev
info.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/virt/kvm/api.rst  |  15 ++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/sev.c          | 137 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   1 +
 arch/x86/kvm/svm/svm.h          |   2 +
 arch/x86/kvm/x86.c              |   6 ++
 include/uapi/linux/kvm.h        |   1 +
 7 files changed, 163 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..df6f56d689e2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6706,6 +6706,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
 
+7.29 KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM
+-------------------------------------
+
+Architectures: x86 SEV enabled
+Type: vm
+Parameters: args[0] is the fd of the source vm
+Returns: 0 on success
+
+This capability enables userspace to migrate the encryption context from the VM
+indicated by the fd to the VM this is called on.
+
+This is intended to support intra-host migration of VMs between userspace VMMs.
+in-guest workloads scheduled by the host. This allows for upgrading the VMM
+process without interrupting the guest.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..422869707466 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1468,6 +1468,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
+	int (*vm_migrate_protected_vm_from)(struct kvm *kvm, unsigned int source_fd);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 109b223c0b58..2c2f724c9096 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1529,6 +1529,143 @@ static bool cmd_allowed_from_miror(u32 cmd_id)
 	return false;
 }
 
+static int sev_lock_for_migration(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	/*
+	 * Bail if this VM is already involved in a migration to avoid deadlock
+	 * between two VMs trying to migrate to/from each other.
+	 */
+	if (atomic_cmpxchg_acquire(&sev->migration_in_progress, 0, 1))
+		return -EBUSY;
+
+	mutex_lock(&kvm->lock);
+
+	return 0;
+}
+
+static void sev_unlock_after_migration(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	mutex_unlock(&kvm->lock);
+	atomic_set_release(&sev->migration_in_progress, 0);
+}
+
+
+static int sev_lock_vcpus_for_migration(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i, j;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (mutex_lock_killable(&vcpu->mutex))
+			goto out_unlock;
+	}
+
+	return 0;
+
+out_unlock:
+	kvm_for_each_vcpu(j, vcpu, kvm) {
+		if (i == j)
+			break;
+
+		mutex_unlock(&vcpu->mutex);
+	}
+	return -EINTR;
+}
+
+static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		mutex_unlock(&vcpu->mutex);
+	}
+}
+
+static void sev_migrate_from(struct kvm_sev_info *dst,
+			      struct kvm_sev_info *src)
+{
+	dst->active = true;
+	dst->asid = src->asid;
+	dst->misc_cg = src->misc_cg;
+	dst->handle = src->handle;
+	dst->pages_locked = src->pages_locked;
+
+	src->asid = 0;
+	src->active = false;
+	src->handle = 0;
+	src->pages_locked = 0;
+	src->misc_cg = NULL;
+
+	INIT_LIST_HEAD(&dst->regions_list);
+	list_replace_init(&src->regions_list, &dst->regions_list);
+}
+
+int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
+{
+	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
+	struct file *source_kvm_file;
+	struct kvm *source_kvm;
+	struct kvm_vcpu *vcpu;
+	int i, ret;
+
+	ret = sev_lock_for_migration(kvm);
+	if (ret)
+		return ret;
+
+	if (sev_guest(kvm)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	source_kvm_file = fget(source_fd);
+	if (!file_is_kvm(source_kvm_file)) {
+		ret = -EBADF;
+		goto out_fput;
+	}
+
+	source_kvm = source_kvm_file->private_data;
+	ret = sev_lock_for_migration(source_kvm);
+	if (ret)
+		goto out_fput;
+
+	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
+		ret = -EINVAL;
+		goto out_source;
+	}
+	ret = sev_lock_vcpus_for_migration(kvm);
+	if (ret)
+		goto out_dst_vcpu;
+	ret = sev_lock_vcpus_for_migration(source_kvm);
+	if (ret)
+		goto out_source_vcpu;
+
+	sev_migrate_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
+	kvm_for_each_vcpu(i, vcpu, source_kvm) {
+		kvm_vcpu_reset(vcpu, /* init_event= */ false);
+	}
+	ret = 0;
+
+out_source_vcpu:
+	sev_unlock_vcpus_for_migration(source_kvm);
+
+out_dst_vcpu:
+	sev_unlock_vcpus_for_migration(kvm);
+
+out_source:
+	sev_unlock_after_migration(source_kvm);
+out_fput:
+	if (source_kvm_file)
+		fput(source_kvm_file);
+out_unlock:
+	sev_unlock_after_migration(kvm);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 68294491c23d..c2e25ae4757f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4637,6 +4637,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
 	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
+	.vm_migrate_protected_vm_from = svm_vm_migrate_from,
 
 	.can_emulate_instruction = svm_can_emulate_instruction,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6d8d762d208f..d7b44b37dfcf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -80,6 +80,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
+	atomic_t migration_in_progress;
 };
 
 struct kvm_svm {
@@ -557,6 +558,7 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
+int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c8b5129effd..c80fa1d378c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5665,6 +5665,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (kvm_x86_ops.vm_copy_enc_context_from)
 			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
 		return r;
+	case KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM:
+		r = -EINVAL;
+		if (kvm_x86_ops.vm_migrate_protected_vm_from)
+			r = kvm_x86_ops.vm_migrate_protected_vm_from(
+				kvm, cap->args[0]);
+		return r;
 	case KVM_CAP_EXIT_HYPERCALL:
 		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
 			r = -EINVAL;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..77b292ed01c1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.33.0.1079.g6e70778dc9-goog

