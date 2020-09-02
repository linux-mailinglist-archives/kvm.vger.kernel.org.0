Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E0B25AC04
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 15:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgIBNAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 09:00:18 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:52245 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgIBNAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 09:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599051606; x=1630587606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sVr8f22MaDe/QCgG5Z/gJcf5Swrutmw8uwmX7xhUdug=;
  b=MrhzV9kUEU5kEwIB5unt4OVA2o7ALbc7kxPIDYPbzeiR88WCEq77ZLK6
   v3770NTl15mc4Rp8HNsD+t5CE46Im4ufsfg2w3ZM2I87CWzYzVknDYLml
   p2d43ojQBy6LQixvH9esWQriwIC4zcpTWc1wn5w6kyd4fcLElVHgXb8YF
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,383,1592870400"; 
   d="scan'208";a="51634662"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 02 Sep 2020 12:59:51 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 170EEA013F;
        Wed,  2 Sep 2020 12:59:50 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:59:49 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.145) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 12:59:46 +0000
From:   Alexander Graf <graf@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 1/7] KVM: x86: Deflect unknown MSR accesses to user space
Date:   Wed, 2 Sep 2020 14:59:29 +0200
Message-ID: <20200902125935.20646-2-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200902125935.20646-1-graf@amazon.com>
References: <20200902125935.20646-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D08UWB004.ant.amazon.com (10.43.161.232) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

v5 -> v6:

  - Introduce exit reason mask to allow for future expansion and filtering
  - s/emul_to_vcpu(ctxt)/vcpu/
---
 Documentation/virt/kvm/api.rst  |  73 +++++++++++++++++++-
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/emulate.c          |  18 ++++-
 arch/x86/kvm/x86.c              | 119 ++++++++++++++++++++++++++++++--
 include/trace/events/kvm.h      |   2 +-
 include/uapi/linux/kvm.h        |  12 ++++
 6 files changed, 218 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 320788f81a05..1aab18e8c0c3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4861,8 +4861,8 @@ to the byte array.
 
 .. note::
 
-      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR and
-      KVM_EXIT_EPR the corresponding
+      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR,
+      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
 
 operations are complete (and guest state is consistent) only after userspace
 has re-entered the kernel with KVM_RUN.  The kernel side will first finish
@@ -5155,6 +5155,42 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+::
+
+		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
+		struct {
+			__u8 error; /* user -> kernel */
+			__u8 pad[3];
+			__u32 reason; /* kernel -> user */
+			__u32 index; /* kernel -> user */
+			__u64 data; /* kernel <-> user */
+		} msr;
+
+Used on x86 systems. When the VM capability KVM_CAP_X86_USER_SPACE_MSR is
+enabled, MSR accesses to registers that would invoke a #GP by KVM kernel code
+will instead trigger a KVM_EXIT_X86_RDMSR exit for reads and KVM_EXIT_X86_WRMSR
+exit for writes.
+
+The "reason" field specifies why the MSR trap occurred. User space will only
+receive MSR exit traps when a particular reason was requested during through
+ENABLE_CAP. Currently valid exit reasons are:
+
+	KVM_MSR_EXIT_REASON_INVAL - access to invalid MSRs or reserved bits
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
@@ -5844,6 +5880,28 @@ controlled by the kvm module parameter halt_poll_ns. This capability allows
 the maximum halt time to specified on a per-VM basis, effectively overriding
 the module parameter for the target VM.
 
+7.21 KVM_CAP_X86_USER_SPACE_MSR
+-------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] contains the mask of KVM_MSR_EXIT_REASON_* events to report
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
+this capability. With it enabled, MSR accesses that match the mask specified in
+args[0] and trigger a #GP event inside the guest by KVM will instead trigger
+KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
+can then handle to implement model specific MSR handling and/or user notifications
+to inform a user that an MSR was not handled.
+
 8. Other capabilities.
 ======================
 
@@ -6151,3 +6209,14 @@ KVM can therefore start protected VMs.
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
index be5363b21540..6608c8efbfa1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1002,6 +1002,9 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
+	u32 user_space_msr_mask;
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
index 88c593f83b28..4d285bf054fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1549,12 +1549,88 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
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
+static u64 kvm_msr_reason(int r)
+{
+	switch (r) {
+	default:
+		return KVM_MSR_EXIT_REASON_INVAL;
+	}
+}
+
+static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
+			      u32 exit_reason, u64 data,
+			      int (*completion)(struct kvm_vcpu *vcpu),
+			      int r)
+{
+	u64 msr_reason = kvm_msr_reason(r);
+
+	/* Check if the user wanted to know about this MSR fault */
+	if (!(vcpu->kvm->arch.user_space_msr_mask & msr_reason))
+		return 0;
+
+	vcpu->run->exit_reason = exit_reason;
+	vcpu->run->msr.error = 0;
+	vcpu->run->msr.pad[0] = 0;
+	vcpu->run->msr.pad[1] = 0;
+	vcpu->run->msr.pad[2] = 0;
+	vcpu->run->msr.reason = msr_reason;
+	vcpu->run->msr.index = index;
+	vcpu->run->msr.data = data;
+	vcpu->arch.complete_userspace_io = completion;
+
+	return 1;
+}
+
+static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, u32 index, int r)
+{
+	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_RDMSR, 0,
+				   complete_emulated_rdmsr, r);
+}
+
+static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, u32 index, u64 data, int r)
+{
+	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_WRMSR, data,
+				   complete_emulated_wrmsr, r);
+}
+
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
+	int r;
+
+	r = kvm_get_msr(vcpu, ecx, &data);
 
-	if (kvm_get_msr(vcpu, ecx, &data)) {
+	/* MSR read failed? See if we should ask user space */
+	if (r && kvm_get_msr_user_space(vcpu, ecx, r)) {
+		/* Bounce to user space */
+		return 0;
+	}
+
+	/* MSR read failed? Inject a #GP */
+	if (r) {
 		trace_kvm_msr_read_ex(ecx);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -1572,8 +1648,18 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
+	int r;
 
-	if (kvm_set_msr(vcpu, ecx, data)) {
+	r = kvm_set_msr(vcpu, ecx, data);
+
+	/* MSR write failed? See if we should ask user space */
+	if (r && kvm_set_msr_user_space(vcpu, ecx, data, r)) {
+		/* Bounce to user space */
+		return 0;
+	}
+
+	/* MSR write failed? Inject a #GP */
+	if (r) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -3476,6 +3562,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_X86_USER_SPACE_MSR:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4990,6 +5077,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_USER_SPACE_MSR:
+		kvm->arch.user_space_msr_mask = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -6319,13 +6410,33 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	int r;
+
+	r = kvm_get_msr(vcpu, msr_index, pdata);
+
+	if (r && kvm_get_msr_user_space(vcpu, msr_index, r)) {
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
+	r = kvm_set_msr(vcpu, msr_index, data);
+
+	if (r && kvm_set_msr_user_space(vcpu, msr_index, data, r)) {
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
index 4fdf30316582..a42841141cae 100644
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
@@ -412,6 +414,15 @@ struct kvm_run {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
+		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
+		struct {
+			__u8 error; /* user -> kernel */
+			__u8 pad[3];
+#define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
+			__u32 reason; /* kernel -> user */
+			__u32 index; /* kernel -> user */
+			__u64 data; /* kernel <-> user */
+		} msr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1031,6 +1042,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_X86_USER_SPACE_MSR 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



