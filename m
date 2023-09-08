Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2554C799236
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343816AbjIHW37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343761AbjIHW35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:29:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2310E1FD5
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d71f505d21dso2550376276.3
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212192; x=1694816992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sFLqyRQVGyStZ6wmmJoKmX48Ce2SAwoanh5HC5XvG8k=;
        b=Vkc6tbI7L+G8LKGS5ULmAZ1d0lPfoYWGhlcyytRM8C2kCVbgrBo5XhVFC0Ka2n18oU
         6xePNiNNGo6/uWXZdLjpbOWBHjim9Wd4SPwW4Hy66zFi9VxWEGL7VjurRYnTachSOLop
         v7PNfCSs2YWliK6keEq1MXn+c4UVCboeOu/J+yJVrxE/s15yg81DjzJtK3sBxr/hCGfB
         bdb4kJTAE46FQELNrRQvFFvzfZw/97KAmDXKZ3p4XpTc/Fy9yKIbm+/k56+Uhq9sJquj
         kroo4YcTahrcn2+5Jz0xvrAMeSPlx5wWvEvmtk0Voaztinglxw4nRdGcXi83xJmwtN4a
         0AcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212192; x=1694816992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFLqyRQVGyStZ6wmmJoKmX48Ce2SAwoanh5HC5XvG8k=;
        b=hY5Kv6WyUB+5hwO6MWrzKqg23auCSfABr/+bDF00Fg8uwBXfdmeB1uQVHifq3LefjB
         ElEy0BN1QM1ZYAAdkC1UQIqYVAYGIViGT3jwV67cUF+js7B3QVujafXrLnYFZeIhCNI8
         3bbXsUJXW1K/RUcBKBjrghfAZtUvBVItcDkgsR8riOQkipXHpTdKJolBZxBnOTpYlWhh
         2NfUIshNw/wUsTSW+/8cFrN6clnkIO8NvvQDRRtGT7oWsoXj6NDjoXpXpxW/1SJ5Dr38
         c3sE1AUwExayOMhUXadkPeWO32Xe85fThItA6R07AGNp/93hOswKwhwEs0ilTuaeCIXk
         U8ow==
X-Gm-Message-State: AOJu0Yz3mxCKF0+9vWaEThZwJStWjMlr98kbXo9tEYPKYE3znsHuu4LF
        jP3amLcZkDgqHxf3Dqskn/Uu0NOqr84QCw==
X-Google-Smtp-Source: AGHT+IH5Pjm50udQqayL/HhGoZuhUb8kke6pZg7BLVikQuxrQNq9sPbd4Tg7jduOWhg8/aNBF18rTrWuMgE8IA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:d4c9:0:b0:d78:f45:d7bd with SMTP id
 m192-20020a25d4c9000000b00d780f45d7bdmr83908ybf.4.1694212192389; Fri, 08 Sep
 2023 15:29:52 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:51 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-5-amoorthy@google.com>
Subject: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
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
(kvm_handle_guest_uaccess_fault()) for implementing the capability.

Mark KVM_CAP_MEMORY_FAULT_INFO as available on arm64 and x86, even
though EFAULT annotation are currently totally absent. Picking a point
to declare the implementation "done" is difficult because

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
 Documentation/virt/kvm/api.rst | 49 ++++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h       | 35 ++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 34 +++++++++++++++++++++++
 tools/include/uapi/linux/kvm.h | 24 +++++++++++++++++
 virt/kvm/kvm_main.c            |  3 +++
 5 files changed, 143 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 660d9ca7a251..92fd3faa6bab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6130,8 +6130,10 @@ local APIC is not used.
 
 	__u16 flags;
 
-More architecture-specific flags detailing state of the VCPU that may
-affect the device's behavior. Current defined flags::
+Flags detailing state of the VCPU. The lower/upper bytes encode archiecture
+specific/agnostic bytes respectively. Current defined flags
+
+::
 
   /* x86, set if the VCPU is in system management mode */
   #define KVM_RUN_X86_SMM     (1 << 0)
@@ -6140,6 +6142,9 @@ affect the device's behavior. Current defined flags::
   /* arm64, set for KVM_EXIT_DEBUG */
   #define KVM_DEBUG_ARCH_HSR_HIGH_VALID  (1 << 0)
 
+  /* Arch-agnostic, see KVM_CAP_MEMORY_FAULT_INFO */
+  #define KVM_RUN_MEMORY_FAULT_FILLED (1 << 8)
+
 ::
 
 	/* in (pre_kvm_run), out (post_kvm_run) */
@@ -6750,6 +6755,18 @@ kvm_valid_regs for specific bits. These bits are architecture specific
 and usually define the validity of a groups of registers. (e.g. one bit
 for general purpose registers)
 
+::
+	union {
+		/* KVM_SPEC_EXIT_MEMORY_FAULT */
+		struct {
+			__u64 flags;
+			__u64 gpa;
+			__u64 len; /* in bytes */
+		} memory_fault;
+
+Indicates a memory fault on the guest physical address range
+[gpa, gpa + len). See KVM_CAP_MEMORY_FAULT_INFO for more details.
+
 Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
@@ -7736,6 +7753,34 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
+7.34 KVM_CAP_MEMORY_FAULT_INFO
+------------------------------
+
+:Architectures: x86, arm64
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that KVM_RUN may fill
+kvm_run.memory_fault in response to failed guest memory accesses in a vCPU
+context.
+
+When KVM_RUN returns an error with errno=EFAULT, (kvm_run.flags |
+KVM_RUN_MEMORY_FAULT_FILLED) indicates that the kvm_run.memory_fault field is
+valid. This capability is only partially implemented in that not all EFAULTs
+from KVM_RUN may be annotated in this way: these "bare" EFAULTs should be
+considered bugs and reported to the maintainers.
+
+The 'gpa' and 'len' (in bytes) fields of kvm_run.memory_fault describe the range
+of guest physical memory to which access failed, i.e. [gpa, gpa + len). 'flags'
+is a bitfield indicating the nature of the access: valid masks are
+
+  - KVM_MEMORY_FAULT_FLAG_READ:      The failed access was a read.
+  - KVM_MEMORY_FAULT_FLAG_WRITE:     The failed access was a write.
+  - KVM_MEMORY_FAULT_FLAG_EXEC:      The failed access was an exec.
+
+Note: Userspaces which attempt to resolve memory faults so that they can retry
+KVM_RUN are encouraged to guard against repeatedly receiving the same
+error/annotated fault.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb6c6109fdca..9206ac944d31 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -392,6 +392,12 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+
+	/*
+	 * KVM_RUN initializes this value to KVM_SPEC_EXIT_UNUSED on entry and
+	 * sets it to something else when it fills the speculative_exit struct.
+	 */
+	u8 speculative_exit_canary;
 };
 
 /*
@@ -2318,4 +2324,33 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+/*
+ * Attempts to set the run struct's exit reason to KVM_EXIT_MEMORY_FAULT and
+ * populate the memory_fault field with the given information.
+ *
+ * WARNs and does nothing if the speculative exit canary has already been set
+ * or if 'vcpu' is not the current running vcpu.
+ */
+static inline void kvm_handle_guest_uaccess_fault(struct kvm_vcpu *vcpu,
+						  uint64_t gpa, uint64_t len, uint64_t flags)
+{
+	/*
+	 * Ensure that an unloaded vCPU's run struct isn't being modified
+	 */
+	if (WARN_ON_ONCE(vcpu != kvm_get_running_vcpu()))
+		return;
+
+	/*
+	 * Warn when overwriting an already-populated run struct.
+	 */
+	WARN_ON_ONCE(vcpu->speculative_exit_canary != KVM_SPEC_EXIT_UNUSED);
+
+	vcpu->speculative_exit_canary = KVM_SPEC_EXIT_MEMORY_FAULT;
+
+	vcpu->run->flags |= KVM_RUN_MEMORY_FAULT_FILLED;
+	vcpu->run->memory_fault.gpa = gpa;
+	vcpu->run->memory_fault.len = len;
+	vcpu->run->memory_fault.flags = flags;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f089ab290978..b2e4ac83b5a8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -265,6 +265,9 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 
+#define KVM_SPEC_EXIT_UNUSED           0
+#define KVM_SPEC_EXIT_MEMORY_FAULT     1
+
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
 #define KVM_INTERNAL_ERROR_EMULATION	1
@@ -278,6 +281,9 @@ struct kvm_xen_exit {
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
 
+/* KVM_CAP_MEMORY_FAULT_INFO flag for kvm_run.flags */
+#define KVM_RUN_MEMORY_FAULT_FILLED (1 << 8)
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -531,6 +537,27 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+
+	/*
+	 * This second exit union holds structs for exits which may be triggered
+	 * after KVM has already initiated a different exit, and/or may be
+	 * filled speculatively by KVM.
+	 *
+	 * For instance, because of limitations in KVM's uAPI, a memory fault
+	 * may be encounterd after an MMIO exit is initiated and exit_reason and
+	 * kvm_run.mmio are filled: isolating the speculative exits here ensures
+	 * that KVM won't clobber information for the original exit.
+	 */
+	union {
+		/* KVM_SPEC_EXIT_MEMORY_FAULT */
+		struct {
+			__u64 flags;
+			__u64 gpa;
+			__u64 len;
+		} memory_fault;
+		/* Fix the size of the union. */
+		char speculative_exit_padding[256];
+	};
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1192,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_MEMORY_FAULT_INFO 230
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2249,4 +2277,10 @@ struct kvm_s390_zpci_op {
 /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
 #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
+/* flags for KVM_CAP_MEMORY_FAULT_INFO */
+
+#define KVM_MEMORY_FAULT_FLAG_READ     (1 << 0)
+#define KVM_MEMORY_FAULT_FLAG_WRITE    (1 << 1)
+#define KVM_MEMORY_FAULT_FLAG_EXEC     (1 << 2)
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f089ab290978..d19aa7965392 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -278,6 +278,9 @@ struct kvm_xen_exit {
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
 
+/* KVM_CAP_MEMORY_FAULT_INFO flag for kvm_run.flags */
+#define KVM_RUN_MEMORY_FAULT_FILLED (1 << 8)
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
@@ -531,6 +534,27 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+
+	/*
+	 * This second exit union holds structs for exits which may be triggered
+	 * after KVM has already initiated a different exit, and/or may be
+	 * filled speculatively by KVM.
+	 *
+	 * For instance, because of limitations in KVM's uAPI, a memory fault
+	 * may be encounterd after an MMIO exit is initiated and exit_reason and
+	 * kvm_run.mmio are filled: isolating the speculative exits here ensures
+	 * that KVM won't clobber information for the original exit.
+	 */
+	union {
+		/* KVM_RUN_MEMORY_FAULT_FILLED + EFAULT */
+		struct {
+			__u64 flags;
+			__u64 gpa;
+			__u64 len;
+		} memory_fault;
+		/* Fix the size of the union. */
+		char speculative_exit_padding[256];
+	};
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b2d5aab32bf..e31435179764 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4151,6 +4151,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
+		vcpu->speculative_exit_canary = KVM_SPEC_EXIT_UNUSED;
+		vcpu->run->flags &= ~KVM_RUN_MEMORY_FAULT_FILLED;
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
 		break;
@@ -4539,6 +4541,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 	case KVM_CAP_HALT_POLL:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
-- 
2.42.0.283.g2d96d420d3-goog

