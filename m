Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD04248FF5
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgHRVQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgHRVQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:18 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA040C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:18 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z16so13650541pfq.7
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=to60OveT2KgnhzdmFUACAYM2wTOqtaSPAC6ACiSaLPY=;
        b=TOYPoa5mUQ5alCG7/s8pI89oczU994+48YEjkjpSGrlrTMUmajMrFbsJbiqFGSK2/F
         JbJdsdC5yj7L/lei6LFAlTvoEo62VZHh5mPHFDKHZeJx6gnC0Zke3T8dDpXlKD801jOv
         lrXfNDGwhpELAD6QrbUmkCeOmEny+aj2FzgtCSooef+jsjKECSH9DDXYsxZWao0XnhYF
         nHDkgz2AwRu6Lh56CMFEfb6pDDLuebHBCUYruxdfG/SF/MD5fZg0pqTyfFbW4zz+H9xg
         5tNFFiXWcEzaKZI5iqXRZB+sXb/T6NYgcfQIFFWzMs1oTm3AnElRFxSRbduZcyJoN2lT
         G9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=to60OveT2KgnhzdmFUACAYM2wTOqtaSPAC6ACiSaLPY=;
        b=NOCaSgJKj8FOx6wOuAZDxVZsemle0HAZ2WGi/IkayvYMdmZ1NivrjgYFo350qpc2Lm
         v9mzYP1qK+9iKGGfADEvh6cB+qexX0SRID+/9XplOF4n64mQQaZbxOgyHPhpfftmQD72
         UB/qV/JH19XXPFYomjQsfYM1gY2f9sKe8zYDea7nIx7VFvQMSn03+EPX84nsROivbU/q
         Kgw9SZ2rKELi93FTmuvNoq1WFbHiolZcyyH7XqiRZ2SrFk8+TVdRmra64vG2YucisBBg
         p7W+MDwHiQOwMiLmAcLUYeBR6Rbj6Lf+JZ4Sk5Sen5myC4xPooPJy3+L1xWFfMR/brNv
         a86w==
X-Gm-Message-State: AOAM530ob6z0HB97zOs7GK15W0s64Ylres9uRab5hIVtZUO6OvUxgBgh
        E08aR/3PiI9kbwXKBwq2xbZKHjLR6bP8XNuY
X-Google-Smtp-Source: ABdhPJzKTnpUkySwRvRYbTRpGKyS7mBQ9sVEH8NDgx8K/hvhutNfebQ7BCSaoW+UVG32+gys0YTzp0X0+3sPRjo+
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:2764:: with SMTP id
 o91mr1427452pje.113.1597785378062; Tue, 18 Aug 2020 14:16:18 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:23 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 01/12] KVM: x86: Deflect unknown MSR accesses to user space
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSRs are weird. Some of them are normal control registers, such as EFER.
Some however are registers that really are model specific, not very
interesting to virtualization workloads, and not performance critical.
Others again are really just windows into package configuration.

Out of these MSRs, only the first category is necessary to implement in
kernel space. Rarely accessed MSRs, MSRs that should be fine tunes against
certain CPU models and MSRs that contain information on the package level
are much better suited for user space to process. However, over time we have
accumulated a lot of MSRs that are not the first category, but still handled
by in-kernel KVM code.

This patch adds a generic interface to handle WRMSR and RDMSR from user
space. With this, any future MSR that is part of the latter categories can
be handled in user space.

Furthermore, it allows us to replace the existing "ignore_msrs" logic with
something that applies per-VM rather than on the full system. That way you
can run productive VMs in parallel to experimental ones where you don't care
about proper MSR handling.

Signed-off-by: Alexander Graf <graf@amazon.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

---

v1 -> v2:

  - s/ETRAP_TO_USER_SPACE/ENOENT/g
  - deflect all #GP injection events to user space, not just unknown MSRs.
    That was we can also deflect allowlist errors later
  - fix emulator case

v2 -> v3:

  - return r if r == X86EMUL_IO_NEEDED
  - s/KVM_EXIT_RDMSR/KVM_EXIT_X86_RDMSR/g
  - s/KVM_EXIT_WRMSR/KVM_EXIT_X86_WRMSR/g
  - Use complete_userspace_io logic instead of reply field
  - Simplify trapping code

v3 -> v4:

  - Mention exit reasons in re-inter mandatory section of API documentation
  - Clear padding bytes
  - Generalize get/set deflect functions
  - Remove redundant pending_user_msr field

---
 Documentation/virt/kvm/api.rst  |  66 +++++++++++++++++++-
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/emulate.c          |  18 +++++-
 arch/x86/kvm/x86.c              | 106 ++++++++++++++++++++++++++++++--
 include/trace/events/kvm.h      |   2 +-
 include/uapi/linux/kvm.h        |  10 +++
 6 files changed, 196 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eb3a1316f03e..aad51c33fcae 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4869,8 +4869,8 @@ to the byte array.
 
 .. note::
 
-      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR and
-      KVM_EXIT_EPR the corresponding
+      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR,
+      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
 
 operations are complete (and guest state is consistent) only after userspace
 has re-entered the kernel with KVM_RUN.  The kernel side will first finish
@@ -5163,6 +5163,35 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+::
+
+               /* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
+               struct {
+                       __u8 error;
+                       __u8 pad[3];
+                       __u32 index;
+                       __u64 data;
+               } msr;
+
+Used on x86 systems. When the VM capability KVM_CAP_X86_USER_SPACE_MSR is
+enabled, MSR accesses to registers that would invoke a #GP by KVM kernel code
+will instead trigger a KVM_EXIT_X86_RDMSR exit for reads and KVM_EXIT_X86_WRMSR
+exit for writes.
+
+For KVM_EXIT_X86_RDMSR, the "index" field tells user space which MSR the guest
+wants to read. To respond to this request with a successful read, user space
+writes the respective data into the "data" field and must continue guest
+execution to ensure the read data is transferred into guest register state.
+
+If the RDMSR request was unsuccessful, user space indicates that with a "1" in
+the "error" field. This will inject a #GP into the guest when the VCPU is
+executed again.
+
+For KVM_EXIT_X86_WRMSR, the "index" field tells user space which MSR the guest
+wants to write. Once finished processing the event, user space must continue
+vCPU execution. If the MSR write was unsuccessful, user space also sets the
+"error" field to "1".
+
 ::
 
 		/* Fix the size of the union. */
@@ -5852,6 +5881,28 @@ controlled by the kvm module parameter halt_poll_ns. This capability allows
 the maximum halt time to specified on a per-VM basis, effectively overriding
 the module parameter for the target VM.
 
+7.21 KVM_CAP_X86_USER_SPACE_MSR
+-------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is 1 if user space MSR handling is enabled, 0 otherwise
+:Returns: 0 on success; -1 on error
+
+This capability enables trapping of #GP invoking RDMSR and WRMSR instructions
+into user space.
+
+When a guest requests to read or write an MSR, KVM may not implement all MSRs
+that are relevant to a respective system. It also does not differentiate by
+CPU type.
+
+To allow more fine grained control over MSR handling, user space may enable
+this capability. With it enabled, MSR accesses that would usually trigger
+a #GP event inside the guest by KVM will instead trigger KVM_EXIT_X86_RDMSR
+and KVM_EXIT_X86_WRMSR exit notifications which user space can then handle to
+implement model specific MSR handling and/or user notifications to inform
+a user that an MSR was not handled.
+
 8. Other capabilities.
 ======================
 
@@ -6159,3 +6210,14 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.24 KVM_CAP_X86_USER_SPACE_MSR
+----------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports deflection of MSR reads and
+writes to user space. It can be enabled on a VM level. If enabled, MSR
+accesses that would usually trigger a #GP by KVM into the guest will
+instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
+KVM_EXIT_X86_WRMSR exit notifications.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ab3af7275d8..02a102c60dff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -961,6 +961,9 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
+	bool user_space_msr_enabled;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d0e2825ae617..744ab9c92b73 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3689,11 +3689,18 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
 
 static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 {
+	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
 	u64 msr_data;
+	int r;
 
 	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
 		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
-	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
+	r = ctxt->ops->set_msr(ctxt, msr_index, msr_data);
+
+	if (r == X86EMUL_IO_NEEDED)
+		return r;
+
+	if (r)
 		return emulate_gp(ctxt, 0);
 
 	return X86EMUL_CONTINUE;
@@ -3701,9 +3708,16 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 
 static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
 {
+	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
 	u64 msr_data;
+	int r;
+
+	r = ctxt->ops->get_msr(ctxt, msr_index, &msr_data);
+
+	if (r == X86EMUL_IO_NEEDED)
+		return r;
 
-	if (ctxt->ops->get_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), &msr_data))
+	if (r)
 		return emulate_gp(ctxt, 0);
 
 	*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 599d73206299..5d94a95fb66b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1588,12 +1588,75 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);
 
+static int complete_emulated_msr(struct kvm_vcpu *vcpu, bool is_read)
+{
+	if (vcpu->run->msr.error) {
+		kvm_inject_gp(vcpu, 0);
+	} else if (is_read) {
+		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
+		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
+	}
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
+{
+	return complete_emulated_msr(vcpu, true);
+}
+
+static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return complete_emulated_msr(vcpu, false);
+}
+
+static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
+			      u32 exit_reason, u64 data,
+			      int (*completion)(struct kvm_vcpu *vcpu))
+{
+	if (!vcpu->kvm->arch.user_space_msr_enabled)
+		return 0;
+
+	vcpu->run->exit_reason = exit_reason;
+	vcpu->run->msr.error = 0;
+	vcpu->run->msr.pad[0] = 0;
+	vcpu->run->msr.pad[1] = 0;
+	vcpu->run->msr.pad[2] = 0;
+	vcpu->run->msr.index = index;
+	vcpu->run->msr.data = data;
+	vcpu->arch.complete_userspace_io = completion;
+
+	return 1;
+}
+
+static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, u32 index)
+{
+	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_RDMSR, 0,
+				  complete_emulated_rdmsr);
+}
+
+static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_WRMSR, data,
+				  complete_emulated_wrmsr);
+}
+
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
+	int r;
 
-	if (kvm_get_msr(vcpu, ecx, &data)) {
+	r = kvm_get_msr(vcpu, ecx, &data);
+
+	/* MSR read failed? See if we should ask user space */
+	if (r && kvm_get_msr_user_space(vcpu, ecx)) {
+		/* Bounce to user space */
+		return 0;
+	}
+
+	/* MSR read failed? Inject a #GP */
+	if (r) {
 		trace_kvm_msr_read_ex(ecx);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -1611,8 +1674,18 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
+	int r;
+
+	r = kvm_set_msr(vcpu, ecx, data);
+
+	/* MSR write failed? See if we should ask user space */
+	if (r && kvm_set_msr_user_space(vcpu, ecx, data)) {
+		/* Bounce to user space */
+		return 0;
+	}
 
-	if (kvm_set_msr(vcpu, ecx, data)) {
+	/* MSR write failed? Inject a #GP */
+	if (r) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -3516,6 +3589,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
+	case KVM_CAP_X86_USER_SPACE_MSR:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5033,6 +5107,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_USER_SPACE_MSR:
+		kvm->arch.user_space_msr_enabled = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -6362,13 +6440,33 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	int r;
+
+	r = kvm_get_msr(vcpu, msr_index, pdata);
+
+	if (r && kvm_get_msr_user_space(vcpu, msr_index)) {
+		/* Bounce to user space */
+		return X86EMUL_IO_NEEDED;
+	}
+
+	return r;
 }
 
 static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 data)
 {
-	return kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	int r;
+
+	r = kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
+
+	if (r && kvm_set_msr_user_space(vcpu, msr_index, data)) {
+		/* Bounce to user space */
+		return X86EMUL_IO_NEEDED;
+	}
+
+	return r;
 }
 
 static u64 emulator_get_smbase(struct x86_emulate_ctxt *ctxt)
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 9417a34aad08..26cfb0fa8e7e 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -17,7 +17,7 @@
 	ERSN(NMI), ERSN(INTERNAL_ERROR), ERSN(OSI), ERSN(PAPR_HCALL),	\
 	ERSN(S390_UCONTROL), ERSN(WATCHDOG), ERSN(S390_TSCH), ERSN(EPR),\
 	ERSN(SYSTEM_EVENT), ERSN(S390_STSI), ERSN(IOAPIC_EOI),          \
-	ERSN(HYPERV), ERSN(ARM_NISV)
+	ERSN(HYPERV), ERSN(ARM_NISV), ERSN(X86_RDMSR), ERSN(X86_WRMSR)
 
 TRACE_EVENT(kvm_userspace_exit,
 	    TP_PROTO(__u32 reason, int errno),
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..6470c0c1e77a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -248,6 +248,8 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_X86_RDMSR        29
+#define KVM_EXIT_X86_WRMSR        30
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -413,6 +415,13 @@ struct kvm_run {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
+		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
+		struct {
+			__u8 error;
+			__u8 pad[3];
+			__u32 index;
+			__u64 data;
+		} msr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1035,6 +1044,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_X86_USER_SPACE_MSR 187
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.28.0.220.ged08abb693-goog

