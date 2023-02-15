Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7296A697355
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbjBOBRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjBOBRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:17:06 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4451D91B
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:40 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-52ec2c6b694so166010177b3.19
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0rHp5sqwZfV8zA2e7TUhcFyytercbqQ9f3OcSRDFb/Q=;
        b=DcL7+8nx8usjTLDWPqXAD6rATn8lKqd9G4SZWnKXMCVKVpTEkZFHQGl42QbdwM8yyC
         F/PqKakl2Ue/cLA4Dy1BUKzOOnmIrwcp7LLVRxn1Ncq+Tbh4r9XrnBd2pkhcy8HSB2fo
         BTGve3d5FP0uGMCEotT4ZjKGmLE9BB/9fc/D5FAYLUp8SgwEfgHjl76hrhvoAgxeT+lE
         sKiL+l2gRe1src5KhX25G8//0ca6bF4UK7W7jEjt+hIbZtVHIK+Owknqp0ORfFpJ3HWq
         YcY429eik4ynCo39gPPQ75PJnOHRdJL1LxGXwr5E1DgnDQgyo9WnGNAWOfnnPIdto+jY
         y1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0rHp5sqwZfV8zA2e7TUhcFyytercbqQ9f3OcSRDFb/Q=;
        b=4+/1cmJim7d55y787iqfi4eWa3c563T5Q8tQd0MgGanxUAxihUAErwHDxJDMFyYm5Q
         TnUF1pObs81QsJARr9AU7F3P3Vs/OJafwb7vc/KsVriYdQgfbTVC7D80JVgwFtaUp4/s
         R1WhOyXNbYXcPEHczhHOa5afpzV383YePAM6/PuOVI7FWmpyhfkSR4z7njNe35qoMlyj
         F10oHGH013ucanOdC5JAoeLO9ja/Arc63UAldbY3Ecrbm/c2gA9Fcg3SevfiUvHySNnm
         ugP7jsHjaWjM2Q5ZdQtzc2C7exZn0va48Jx7UL4M3Jg3IZ6nQunA4NMreqYTrfc9oiXQ
         e2BQ==
X-Gm-Message-State: AO0yUKUeqi8GrVwGgz7+VOFsvg/QbNUda/iexaWFWe09xu67pLUMlqUz
        416AERGTz9pBRA/UPO9wbfs4V/JZsr6+RA==
X-Google-Smtp-Source: AK7set9D0J1O6MGXIL+E7bG+8KXLjEN0EUoYJr/n+yaow9ec34nGQ4f54+vEtHEBbWDQCYr3fgOwzdZ75Z2Ebw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:9f11:0:b0:93b:ad96:1d07 with SMTP id
 n17-20020a259f11000000b0093bad961d07mr53407ybq.653.1676423795726; Tue, 14 Feb
 2023 17:16:35 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:16:11 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-6-amoorthy@google.com>
Subject: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From:   Anish Moorthy <amoorthy@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new KVM exit allows userspace to handle missing memory. It
indicates that the pages in the range [gpa, gpa + size) must be mapped.

The "flags" field actually goes unused in this series: it's included for
forward compatibility with [1], should this series happen to go in
first.

[1] https://lore.kernel.org/all/CA+EHjTyzZ2n8kQxH_Qx72aRq1k+dETJXTsoOM3tggPZAZkYbCA@mail.gmail.com/

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 Documentation/virt/kvm/api.rst | 42 ++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h       | 13 +++++++++++
 include/uapi/linux/kvm.h       | 13 ++++++++++-
 tools/include/uapi/linux/kvm.h |  7 ++++++
 virt/kvm/kvm_main.c            | 26 +++++++++++++++++++++
 5 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9807b05a1b571..4b06e60668686 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5937,6 +5937,18 @@ delivery must be provided via the "reg_aen" struct.
 The "pad" and "reserved" fields may be used for future extensions and should be
 set to 0s by userspace.
 
+4.137 KVM_SET_MEM_FAULT_NOWAIT
+------------------------------
+
+:Capability: KVM_CAP_MEM_FAULT_NOWAIT
+:Architectures: x86, arm64
+:Type: vm ioctl
+:Parameters: bool state (in)
+:Returns: 0 on success, or -1 if KVM_CAP_MEM_FAULT_NOWAIT is not present.
+
+Enables (state=true) or disables (state=false) waitless memory faults. For more
+information, see the documentation of KVM_CAP_MEM_FAULT_NOWAIT.
+
 5. The kvm_run structure
 ========================
 
@@ -6544,6 +6556,21 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+			__u64 gpa;
+			__u64 size;
+		} memory_fault;
+
+If exit reason is KVM_EXIT_MEMORY_FAULT then it indicates that the VCPU has
+encountered a memory error which is not handled by KVM kernel module and
+which userspace may choose to handle.
+
+'gpa' and 'size' indicate the memory range the error occurs at. Userspace
+may handle the error and return to KVM to retry the previous memory access.
+
 ::
 
     /* KVM_EXIT_NOTIFY */
@@ -7577,6 +7604,21 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
+7.34 KVM_CAP_MEM_FAULT_NOWAIT
+-----------------------------
+
+:Architectures: x86, arm64
+:Target: VM
+:Parameters: None
+:Returns: 0 on success, or -EINVAL if capability is not supported.
+
+The presence of this capability indicates that userspace can enable/disable
+waitless memory faults through the KVM_SET_MEM_FAULT_NOWAIT ioctl.
+
+When waitless memory faults are enabled, fast get_user_pages failures when
+handling EPT/Shadow Page Table violations will cause a vCPU exit
+(KVM_EXIT_MEMORY_FAULT) instead of a fallback to slow get_user_pages.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 109b18e2789c4..9352e7f8480fb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -801,6 +801,9 @@ struct kvm {
 	bool vm_bugged;
 	bool vm_dead;
 
+	rwlock_t mem_fault_nowait_lock;
+	bool mem_fault_nowait;
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
 #endif
@@ -2278,4 +2281,14 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+static inline bool memory_faults_enabled(struct kvm *kvm)
+{
+	bool ret;
+
+	read_lock(&kvm->mem_fault_nowait_lock);
+	ret = kvm->mem_fault_nowait;
+	read_unlock(&kvm->mem_fault_nowait_lock);
+	return ret;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646e..064fbfed97f01 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
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
+			__u64 size;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1175,6 +1182,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_MEM_FAULT_NOWAIT 226
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1658,7 +1666,7 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
-/* Available with  KVM_CAP_S390_VCPU_RESETS */
+/* Available with KVM_CAP_S390_VCPU_RESETS */
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
@@ -2228,4 +2236,7 @@ struct kvm_s390_zpci_op {
 /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
 #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
+/* Available with KVM_CAP_MEM_FAULT_NOWAIT */
+#define KVM_SET_MEM_FAULT_NOWAIT _IOWR(KVMIO, 0xd2, bool)
+
 #endif /* __LINUX_KVM_H */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 20522d4ba1e0d..5d9e3f48a9634 100644
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
+			__u64 size;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dae5f48151032..8e5bfc00d1181 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1149,6 +1149,9 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	INIT_LIST_HEAD(&kvm->devices);
 	kvm->max_vcpus = KVM_MAX_VCPUS;
 
+	rwlock_init(&kvm->mem_fault_nowait_lock);
+	kvm->mem_fault_nowait = false;
+
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
 	/*
@@ -2313,6 +2316,16 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
+static int kvm_vm_ioctl_set_mem_fault_nowait(struct kvm *kvm, bool state)
+{
+	if (!kvm_vm_ioctl_check_extension(kvm, KVM_CAP_MEM_FAULT_NOWAIT))
+		return -1;
+	write_lock(&kvm->mem_fault_nowait_lock);
+	kvm->mem_fault_nowait = state;
+	write_unlock(&kvm->mem_fault_nowait_lock);
+	return 0;
+}
+
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	return __gfn_to_memslot(kvm_memslots(kvm), gfn);
@@ -4675,6 +4688,10 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 
 		return r;
 	}
+	case KVM_CAP_MEM_FAULT_NOWAIT:
+		if (!kvm_vm_ioctl_check_extension_generic(kvm, cap->cap))
+			return -EINVAL;
+		return 0;
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
@@ -4892,6 +4909,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_SET_MEM_FAULT_NOWAIT: {
+		bool state;
+
+		r = -EFAULT;
+		if (copy_from_user(&state, argp, sizeof(state)))
+			goto out;
+		r = kvm_vm_ioctl_set_mem_fault_nowait(kvm, state);
+		break;
+	}
 	case KVM_CHECK_EXTENSION:
 		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
 		break;
-- 
2.39.1.581.gbfd45094c4-goog

