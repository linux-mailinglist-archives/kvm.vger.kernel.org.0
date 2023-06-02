Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B80720752
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbjFBQUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbjFBQTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E6FBC
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb2202e0108so1028203276.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722792; x=1688314792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i7iPe74f/KaJDwP7wfYAQ7QEBJzZjifGgsG3QtxPBlg=;
        b=qJF3C2iiqGShvNXhuf14AdTeO0o0JXK3vIlrxsRMRGJnAP5HOgxRYjdzYqYKAHAVdt
         guBlIeDlT4rBbv9zWVerPkHCNeO4nn802pKYLkIJtiVa4cGwWFA+YJxBg0X++eM5faE/
         bIhgk4FJqAvbhZWYXpW8w4pYKzb8bZdKWPp8moRhZh/pL4uDUf0YJvVgf7YiIZK2QLVk
         AdH04u5jFSpDCE2HXNG3bqdJBwW/X6FTbqT19Ea1SSJCDzvQ1NucYGAuWOB4s+Ev9oaS
         gtZgbpU/HWhfgAjFr57iYeHafY2K3wDBRHzh15zqJaa69mvpKOANuDY64wGBT+7ER9Pf
         jEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722792; x=1688314792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i7iPe74f/KaJDwP7wfYAQ7QEBJzZjifGgsG3QtxPBlg=;
        b=NwiP35Yge1g+OtcGneA1m52heSFA74U2j6fjTr+zMrOSfhAIQEslwAZH2OJvyO6219
         fsb8kw61zjai6hf5OHzaB5dmGOwNXkn4TGLRnLs2YA2w8Q/zoUlnhHUltioXe7odcJao
         nkKFjn6aFWZ+dF52hQRiFGZw0q3sfW/VYmYvLqs5KWunhic6nt8fw45PTd9AOx1hCcCt
         sQLXHWfFyFIDow9SbE3afcDYjuek8wwaDqktrXArFFdhPIE+hrJaSiR+FhhdLxPQFVpL
         zrCtQdxbxAQtdt7A+5VkF1MuPR6vVZS3RQMZ3OncYhtNvwbcqtlgNcbgykncwbtMAi0H
         KRKA==
X-Gm-Message-State: AC+VfDzY+nwW2YaegBsZkbR7wRZ5aUC29lZRI6EQE1dORDN45l59GTGb
        vg8BCiOOWWepGrGrD6+0SCuRRbmFYOhdow==
X-Google-Smtp-Source: ACHHUZ57qlQL+0B0GIkxzv/Iux8s8oIxoP6iGrVFgwMJr440xgMYB1bqYrYlZocZAqp1enf4mGi8nxGy5LnDAQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:728:b0:ba1:d0:7f7c with SMTP id
 l8-20020a056902072800b00ba100d07f7cmr1379098ybt.2.1685722792179; Fri, 02 Jun
 2023 09:19:52 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:08 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-4-amoorthy@google.com>
Subject: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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

KVM_CAP_MEMORY_FAULT_INFO allows kvm_run to return useful information
besides a return value of -1 and errno of EFAULT when a vCPU fails an
access to guest memory which may be resolvable by userspace.

Add documentation, updates to the KVM headers, and a helper function
(kvm_populate_efault_info()) for implementing the capability.

Besides simply filling the run struct, kvm_populate_efault_info() takes
two safety measures

  a. It tries to prevent concurrent fills on a single vCPU run struct
     by checking that the run struct being modified corresponds to the
     currently loaded vCPU.
  b. It tries to avoid filling an already-populated run struct by
     checking whether the exit reason has been modified since entry
     into KVM_RUN.

Finally, mark KVM_CAP_MEMORY_FAULT_INFO as available on arm64 and x86,
even though EFAULT annotation are currently totally absent. Picking a
point to declare the implementation "done" is difficult because

  1. Annotations will be performed incrementally in subsequent commits
     across both core and arch-specific KVM.
  2. The initial series will very likely miss some cases which need
     annotation. Although these omissions are to be fixed in the future,
     userspace thus still needs to expect and be able to handle
     unannotated EFAULTs.

Given these qualifications, just marking it available here seems the
least arbitrary thing to do.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst             | 42 ++++++++++++++++++++++
 arch/arm64/kvm/arm.c                       |  1 +
 arch/x86/kvm/x86.c                         |  1 +
 include/linux/kvm_host.h                   |  9 +++++
 include/uapi/linux/kvm.h                   | 13 +++++++
 tools/include/uapi/linux/kvm.h             |  7 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c |  1 +
 virt/kvm/kvm_main.c                        | 35 ++++++++++++++++++
 8 files changed, 109 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index add067793b90..5b24059143b3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6700,6 +6700,18 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+			__u64 flags;
+			__u64 gpa;
+			__u64 len; /* in bytes */
+		} memory_fault;
+
+Indicates a vCPU memory fault on the guest physical address range
+[gpa, gpa + len). See KVM_CAP_MEMORY_FAULT_INFO for more details.
+
 ::
 
     /* KVM_EXIT_NOTIFY */
@@ -7734,6 +7746,36 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
+7.34 KVM_CAP_MEMORY_FAULT_INFO
+------------------------------
+
+:Architectures: x86, arm64
+:Returns: -EINVAL.
+
+The presence of this capability indicates that KVM_RUN may annotate EFAULTs
+returned by KVM_RUN in response to failed vCPU guest memory accesses which
+userspace may be able to resolve.
+
+The annotation is returned via the run struct. When KVM_RUN returns an error
+with errno=EFAULT, userspace may check the exit reason: if it is
+KVM_EXIT_MEMORY_FAULT, userspace is then permitted to read the run struct's
+'memory_fault' field.
+
+This capability is informational only: attempts to KVM_ENABLE_CAP it directly
+will fail.
+
+The 'gpa' and 'len' (in bytes) fields describe the range of guest
+physical memory to which access failed, i.e. [gpa, gpa + len). 'flags' is a
+bitfield indicating the nature of the access: valid masks are
+
+  - KVM_MEMORY_FAULT_FLAG_WRITE:     The failed access was a write.
+  - KVM_MEMORY_FAULT_FLAG_EXEC:      The failed access was an exec.
+
+NOTE: The implementation of this capability is incomplete. Even with it enabled,
+userspace may receive "bare" EFAULTs (i.e. exit reason != KVM_EXIT_MEMORY_FAULT)
+from KVM_RUN for failures which may be resolvable. These should be considered
+bugs and reported to the maintainers so that annotations can be added.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..b34cf0cedffa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -234,6 +234,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7725d41570a..d15bacb3f634 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4497,6 +4497,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e571e973bc2..69a221f71914 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2288,4 +2288,13 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+/*
+ * Attempts to set the run struct's exit reason to KVM_EXIT_MEMORY_FAULT and
+ * populate the memory_fault field with the given information.
+ *
+ * WARNs and does nothing if the exit reason is not KVM_EXIT_UNKNOWN, or if
+ * 'vcpu' is not the current running vcpu.
+ */
+inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
+				     uint64_t gpa, uint64_t len, uint64_t flags);
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 737318b1c1d9..143abb334f56 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_MEMORY_FAULT     38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -510,6 +511,12 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+			__u64 flags;
+			__u64 gpa;
+			__u64 len;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1190,6 +1197,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_COUNTER_OFFSET 227
+#define KVM_CAP_MEMORY_FAULT_INFO 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2245,4 +2253,9 @@ struct kvm_s390_zpci_op {
 /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
 #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
+/* flags for KVM_CAP_MEMORY_FAULT_INFO */
+
+#define KVM_MEMORY_FAULT_FLAG_WRITE    (1 << 0)
+#define KVM_MEMORY_FAULT_FLAG_EXEC     (1 << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 4003a166328c..5476fe169921 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_MEMORY_FAULT     38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -505,6 +506,12 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+			__u64 flags;
+			__u64 gpa;
+			__u64 len;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 298c4372fb1a..7d7e9f893fd5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1868,6 +1868,7 @@ static struct exit_reason {
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
 #endif
+	KVM_EXIT_STRING(MEMORY_FAULT),
 };
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd80a560378c..09d4d85691e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4674,6 +4674,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 
 		return r;
 	}
+	case KVM_CAP_MEMORY_FAULT_INFO: {
+		return -EINVAL;
+	}
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
@@ -6173,3 +6176,35 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
 
 	return init_context.err;
 }
+
+inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
+				     uint64_t gpa, uint64_t len, uint64_t flags)
+{
+	if (WARN_ON_ONCE(!vcpu))
+		return;
+
+	preempt_disable();
+	/*
+	 * Ensure the this vCPU isn't modifying another vCPU's run struct, which
+	 * would open the door for races between concurrent calls to this
+	 * function.
+	 */
+	if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
+		goto out;
+	/*
+	 * Try not to overwrite an already-populated run struct.
+	 * This isn't a perfect solution, as there's no guarantee that the exit
+	 * reason is set before the run struct is populated, but it should prevent
+	 * at least some bugs.
+	 */
+	else if (WARN_ON_ONCE(vcpu->run->exit_reason != KVM_EXIT_UNKNOWN))
+		goto out;
+
+	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+	vcpu->run->memory_fault.gpa = gpa;
+	vcpu->run->memory_fault.len = len;
+	vcpu->run->memory_fault.flags = flags;
+
+out:
+	preempt_enable();
+}
-- 
2.41.0.rc0.172.g3f132b7071-goog

