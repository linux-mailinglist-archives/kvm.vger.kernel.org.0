Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD8B40B534
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhINQsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhINQsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:48:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EC8C061766
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z6-20020a257e06000000b0059bad6decfbso18051490ybc.16
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yBwqgvkRijAsE1dz7yoXX9lIAm5CkwJC622QPkBmzrY=;
        b=TfYojWcj1FVtBktuiZzDIpZiFdH5yb1s4S0KmaV8wOP41z60t42f1esftbOElWv9zx
         KiXenFEr0RE1BbLxU9NfCm5wtnAE2ry47tR1BFIYin05RCrsCWJ1osG4p5aW9wBc1V8M
         ND3jBiFBVS+55e9uTHZ2VSf2qiwpUJx6nGaUjcCThUhAx8qtt6CpZCN9cQx5xhb7dLL7
         fxY9Z4uB5bXpT7uLxAedzBzJSciJUb7kQEhrzJG9vLgHGlTZhOPoGKV1w5/9R40fGxkq
         yTxTESXdJCbICdMD1gGkCHNvqF8q/M2/Uak0fc61+sDdo0DS2FXTrfnrlAFYlK8/ZDoV
         m/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yBwqgvkRijAsE1dz7yoXX9lIAm5CkwJC622QPkBmzrY=;
        b=HGf8bI0kbK4lozQjnDE4CP0erad/RM6XprHlG7sbx2aVdl1gPjQkOa1zM0/NUwE4oz
         CBXQcygJDWaRpb76t9GXwjMBJIm9t4CK/ArvRb37ADJOxDoDkWT8UFHVe4G2ECkkWToo
         80Xo36XWsa3Es6yHWrgo4bxbx4IrjfAYv2mQ86IKS6tbEuPaP/o95nVvaVg3uU5PTqek
         FP3tsj1DhaoRdG3z1hIL71JoarXUT5ajyLzhVaODUYhZ5Al81Emaxz0r1giQCzQKoRNN
         35CMPVcd/JdxRhbit5IV7fdG84Qlj6RME92HuvnyMS3w83wZ3kZ6xRYAjQIbOCuBl6AG
         F7HA==
X-Gm-Message-State: AOAM531GzJCmh1QWwxw0hfKm5bSIV/iPylZLqei+MxtxKuHjxO0aTG8J
        4m2hl/YnIRlTlfBDnJmbnin7fsrdtvMxAIGuNXWOcfr/6cRInkc2RUR99K3a+DE/CQT1IYqjbzJ
        rK8om/knEYTnRczlNDZXkYEAchLGQUzbfO8z1Gmv6mUueFKLxaaJB1F7oCw==
X-Google-Smtp-Source: ABdhPJyT4Fl3Y9gld5cW9PcOF99nBmfPO4NEvemI/0DNb3WB71GClBRq5bLDnfLfQeEmyInXHgmHP6Tnv4U=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b358:1f40:79d5:ab23])
 (user=pgonda job=sendgmr) by 2002:a5b:408:: with SMTP id m8mr166479ybp.2.1631638052952;
 Tue, 14 Sep 2021 09:47:32 -0700 (PDT)
Date:   Tue, 14 Sep 2021 09:47:24 -0700
In-Reply-To: <20210914164727.3007031-1-pgonda@google.com>
Message-Id: <20210914164727.3007031-2-pgonda@google.com>
Mime-Version: 1.0
References: <20210914164727.3007031-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 1/4 V8] KVM: SEV: Add support for SEV intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
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
This change adds a command for a target VMM to get a source SEV VM's sev
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
 arch/x86/kvm/svm/sev.c          | 136 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   1 +
 arch/x86/kvm/svm/svm.h          |   2 +
 arch/x86/kvm/x86.c              |   6 ++
 include/uapi/linux/kvm.h        |   1 +
 7 files changed, 162 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4ea1bb28297b..4d5dbb4f14ec 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6702,6 +6702,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
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
index 09b256db394a..96bf358f5a46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1456,6 +1456,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
+	int (*vm_migrate_protected_vm_from)(struct kvm *kvm, unsigned int source_fd);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 46eb1ba62d3d..6fc1935b52ea 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1501,6 +1501,142 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
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
+		mutex_unlock(&vcpu->mutex);
+		if (i == j)
+			break;
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
index 1a70e11f0487..51d767266dc6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4625,6 +4625,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
 	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
+	.vm_migrate_protected_vm_from = svm_vm_migrate_from,
 
 	.can_emulate_instruction = svm_can_emulate_instruction,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 524d943f3efc..67bfb43301e1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -80,6 +80,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
+	atomic_t migration_in_progress;
 };
 
 struct kvm_svm {
@@ -552,6 +553,7 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
+int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..ef254f34b5a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5654,6 +5654,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
2.33.0.309.g3052b89438-goog

