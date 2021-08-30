Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8274A3FBDAD
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 22:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbhH3U6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 16:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbhH3U6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 16:58:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64801C06175F
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h143-20020a25d095000000b0059c2e43cd3eso3674805ybg.12
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zv67TwJUDsKSGkltZiACEJYFFnaxcP/3cm1t3N7XkTs=;
        b=SC8zjOGsJGsijvl2wxXNAPSRkicXFGnvhdUG78ANJsQ/eyMqIcmXCdpGiKUERSmwu0
         jUVkz8qEnpvhHOZPfocLS6m6h6LHtBWzH5fn2pbu939Ghz3LejSCIf54fufRIUndkiqN
         7xPRQuOV/QzwRavrKh/eqyst5d2muPVZZTXXJRhuB4QuLX3hpjcXlWREu+0GhupjC90a
         uCW/xeY44+h7Eck5sfA+2iGb8+j0B23k0/ODF7C3clB4sfMWcE+uurEcYot56LxjCX5/
         1EKb8Moj1mMFmrzxgdRTtz2c/NAzCS0cV1ur2Z5Ku12GNsNgmlg80+UO6s59GzT2wBXX
         wWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zv67TwJUDsKSGkltZiACEJYFFnaxcP/3cm1t3N7XkTs=;
        b=twREkDJrQrISpXDOPtKiev3edUDgnnOuhB8Kqk/QE8qYp+vToIRqqv4VW+yXZ4e+Pm
         MkaIzpqkLQjbdxv8NHLSx2+e6j14Vove6C7v88137X11tx505RaSHqc7YJ1yoyEkrof/
         OEblz0aOI4qGTx4GK6CrVsaerhqQ6lTJL6mSGAJXYTC5AVuIlQE8hfG8xBfqnuv/85Hq
         nthTyAGS3uZ5qlqanVuiUg6LPP49GYh1dpNRVA16gOPOJkh1wd5ZE4lKok0T7SWHHCn2
         D95AGTVYBrzeQjFwZgbOzMgP4Ys245Vf+t6YJgAz8mwaNmsUP+d507WqPHBjnAzmu0qG
         xfdw==
X-Gm-Message-State: AOAM530yPRN3EXwPH3cz3m2mmyqfDsLxa/Yxp7ZwPzTQ4jmoctqEWSxM
        60LKotrki09ZkvdX6CsIoANGIJlIYQrkwzILtCl3ArsXFwJOKRCfubZFSWmQ/Yo6coZVh6YGL4X
        wAngM+a8Ou8bKLOC2aWzPMwV9dJn3eX8UKVy/VVDgeCvymzbcFw8PgUsHaQ==
X-Google-Smtp-Source: ABdhPJyhd+M03HoxuRL8v9IhV3s9PaYewU6uwFgKvuO33yy410Q+AjQqs1pjDJOnEM/ghH07ei9oNSRFzpo=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:e552:6d5e:b69d:968c])
 (user=pgonda job=sendgmr) by 2002:a25:9201:: with SMTP id b1mr25480528ybo.354.1630357042543;
 Mon, 30 Aug 2021 13:57:22 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:57:15 -0700
In-Reply-To: <20210830205717.3530483-1-pgonda@google.com>
Message-Id: <20210830205717.3530483-2-pgonda@google.com>
Mime-Version: 1.0
References: <20210830205717.3530483-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 1/3 V6] KVM, SEV: Add support for SEV intra host migration
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
This change adds a commands for a target VMM to get a source SEV VM's sev
info.

The target is expected to be initialized (sev_guest_init), but not
launched state (sev_launch_start) when performing receive. Once the
target has received, it will be in a launched state and will not
need to perform the typical SEV launch commands.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
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
 Documentation/virt/kvm/api.rst  | 15 +++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 99 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  2 +
 arch/x86/kvm/x86.c              |  5 ++
 include/uapi/linux/kvm.h        |  1 +
 7 files changed, 124 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 86d7ad3a126c..9dc56778b421 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6701,6 +6701,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
 
+7.29 KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
+-------------------------------------
+
+Architectures: x86 SEV enabled
+Type: vm
+Parameters: args[0] is the fd of the source vm
+Returns: 0 on success
+
+This capability enables userspace to migrate the encryption context from the vm
+indicated by the fd to the vm this is called on.
+
+This is intended to support intra-host migration of VMs between userspace VMMs.
+in-guest workloads scheduled by the host. This allows for upgrading the VMM
+process without interrupting the guest.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20daaf67a5bf..fd3a118c9e40 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1448,6 +1448,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
+	int (*vm_migrate_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 46eb1ba62d3d..063cf26528bc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1501,6 +1501,105 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
 }
 
+static int svm_sev_lock_for_migration(struct kvm *kvm)
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
+static void svm_unlock_after_migration(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	mutex_unlock(&kvm->lock);
+	atomic_set_release(&sev->migration_in_progress, 0);
+}
+
+static void migrate_info_from(struct kvm_sev_info *dst,
+			      struct kvm_sev_info *src)
+{
+	sev_asid_free(dst);
+
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
+	int ret;
+
+	ret = svm_sev_lock_for_migration(kvm);
+	if (ret)
+		return ret;
+
+	if (!sev_guest(kvm) || sev_es_guest(kvm)) {
+		ret = -EINVAL;
+		pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
+		goto out_unlock;
+	}
+
+	if (!list_empty(&dst_sev->regions_list)) {
+		ret = -EINVAL;
+		pr_warn_ratelimited(
+			"VM must not have encrypted regions to migrate to.\n");
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
+	ret = svm_sev_lock_for_migration(source_kvm);
+	if (ret)
+		goto out_fput;
+
+	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
+		ret = -EINVAL;
+		pr_warn_ratelimited(
+			"Source VM must be SEV enabled to migrate from.\n");
+		goto out_source;
+	}
+
+	migrate_info_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
+	ret = 0;
+
+out_source:
+	svm_unlock_after_migration(source_kvm);
+out_fput:
+	if (source_kvm_file)
+		fput(source_kvm_file);
+out_unlock:
+	svm_unlock_after_migration(kvm);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7b58e445a967..8b5bcab48937 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4627,6 +4627,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
 	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
+	.vm_migrate_enc_context_from = svm_vm_migrate_from,
 
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
index fdc0c18339fb..ea3100134e35 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5655,6 +5655,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (kvm_x86_ops.vm_copy_enc_context_from)
 			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
 		return r;
+	case KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM:
+		r = -EINVAL;
+		if (kvm_x86_ops.vm_migrate_enc_context_from)
+			r = kvm_x86_ops.vm_migrate_enc_context_from(kvm, cap->args[0]);
+		return r;
 	case KVM_CAP_EXIT_HYPERCALL:
 		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
 			r = -EINVAL;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..49660204cdb9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.33.0.259.gc128427fd7-goog

