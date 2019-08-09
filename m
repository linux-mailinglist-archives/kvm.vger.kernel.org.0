Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CD687F97
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437202AbfHIQUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:04 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53328 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407417AbfHIQUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 19B73305D3D7;
        Fri,  9 Aug 2019 19:00:58 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B3315305B7A3;
        Fri,  9 Aug 2019 19:00:57 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 16/92] kvm: introspection: handle events and event replies
Date:   Fri,  9 Aug 2019 18:59:31 +0300
Message-Id: <20190809160047.8319-17-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

All events are sent by the vCPU thread, which will handle any
introspection command while waiting for the reply.

The event reply messages contain a common strucure (kvmi_vcpu_hdr), as
any vCPU related command, which allows the receiving worker to dispatch
the reply as it does with any other introspection command sent for a
specific vCPU.

The kernel side will gracefully handle commands coming from an
introspection tool compiled with older or newer versions of KVMI API.
However, it will only accept smaller replies (coming from older versions),
but not the bigger/newer ones (this should make the kernel code simpler).

TODO: Not quite true. An event reply has a common part (kvmi_event_reply)
and an event specific part (eg. the new value for MSR x). If the common
part is smaller, the event will be rejected.

The code from handle_event_reply():

	common = sizeof(struct kvmi_vcpu_hdr) + sizeof(*reply);
	if (unlikely(msg->size < common))
		goto out;

should be changed to

	min_common = sizeof(struct kvmi_vcpu_hdr) + offsetof(reply...)
	if (unlikely(msg->size < min_common))
		goto out;

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst |  56 +++++++++++++
 arch/x86/include/uapi/asm/kvmi.h   |  29 +++++++
 arch/x86/kvm/Makefile              |   2 +-
 arch/x86/kvm/kvmi.c                |  92 ++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  10 +++
 include/linux/kvm_host.h           |   3 +
 include/uapi/linux/kvmi.h          |  16 ++++
 virt/kvm/kvmi.c                    |  15 ++++
 virt/kvm/kvmi_int.h                |  16 ++++
 virt/kvm/kvmi_msg.c                | 129 +++++++++++++++++++++++++++++
 10 files changed, 367 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/uapi/asm/kvmi.h
 create mode 100644 arch/x86/kvm/kvmi.c

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 7f3c4f8fce63..e7d9a3816e00 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -427,3 +427,59 @@ in almost all cases, it must reply with: continue, retry, crash, etc.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EPERM - the access is restricted by the host
 
+Events
+======
+
+All vCPU events are sent using the *KVMI_EVENT* message id. No event
+will be sent unless explicitly enabled with a *KVMI_CONTROL_EVENTS*
+or a *KVMI_CONTROL_VM_EVENTS* command or requested, as it is the case
+with the *KVMI_EVENT_PAUSE_VCPU* event (see **KVMI_PAUSE_VCPU**).
+
+There is one VM event, *KVMI_EVENT_UNHOOK*, which doesn't have a reply,
+but shares the kvmi_event structure, for consistency with the vCPU events.
+
+The message data begins with a common structure, having the size of the
+structure, the vCPU index and the event id::
+
+	struct kvmi_event {
+		__u16 size;
+		__u16 vcpu;
+		__u8 event;
+		__u8 padding[3];
+		struct kvmi_event_arch arch;
+	}
+
+On x86 the structure looks like this::
+
+	struct kvmi_event_arch {
+		__u8 mode;
+		__u8 padding[7];
+		struct kvm_regs regs;
+		struct kvm_sregs sregs;
+		struct {
+			__u64 sysenter_cs;
+			__u64 sysenter_esp;
+			__u64 sysenter_eip;
+			__u64 efer;
+			__u64 star;
+			__u64 lstar;
+			__u64 cstar;
+			__u64 pat;
+			__u64 shadow_gs;
+		} msrs;
+	};
+
+It contains information about the vCPU state at the time of the event.
+
+The reply to events have the *KVMI_EVENT_REPLY* message id and begins
+with two common structures::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply {
+		__u8 action;
+		__u8 event;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+Specific data can follow these common structures.
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
new file mode 100644
index 000000000000..551f9ed1ed9c
--- /dev/null
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_X86_KVMI_H
+#define _UAPI_ASM_X86_KVMI_H
+
+/*
+ * KVM introspection - x86 specific structures and definitions
+ */
+
+#include <asm/kvm.h>
+
+struct kvmi_event_arch {
+	__u8 mode;		/* 2, 4 or 8 */
+	__u8 padding[7];
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct {
+		__u64 sysenter_cs;
+		__u64 sysenter_esp;
+		__u64 sysenter_eip;
+		__u64 efer;
+		__u64 star;
+		__u64 lstar;
+		__u64 cstar;
+		__u64 pat;
+		__u64 shadow_gs;
+	} msrs;
+};
+
+#endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 0963e475dbe9..673cf37c0747 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,7 +7,7 @@ KVM := ../../../virt/kvm
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o $(KVM)/kvmi_msg.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o $(KVM)/kvmi_msg.o kvmi.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
new file mode 100644
index 000000000000..9aecca551673
--- /dev/null
+++ b/arch/x86/kvm/kvmi.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection - x86
+ *
+ * Copyright (C) 2019 Bitdefender S.R.L.
+ */
+#include "x86.h"
+#include "../../../virt/kvm/kvmi_int.h"
+
+/*
+ * TODO: this can be done from userspace.
+ *   - all these registers are sent with struct kvmi_event_arch
+ *   - userspace can request MSR_EFER with KVMI_GET_REGISTERS
+ */
+static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
+				   const struct kvm_sregs *sregs)
+{
+	unsigned int mode = 0;
+
+	if (is_long_mode((struct kvm_vcpu *) vcpu)) {
+		if (sregs->cs.l)
+			mode = 8;
+		else if (!sregs->cs.db)
+			mode = 2;
+		else
+			mode = 4;
+	} else if (sregs->cr0 & X86_CR0_PE) {
+		if (!sregs->cs.db)
+			mode = 2;
+		else
+			mode = 4;
+	} else if (!sregs->cs.db) {
+		mode = 2;
+	} else {
+		mode = 4;
+	}
+
+	return mode;
+}
+
+static void kvmi_get_msrs(struct kvm_vcpu *vcpu, struct kvmi_event_arch *event)
+{
+	struct msr_data msr;
+
+	msr.host_initiated = true;
+
+	msr.index = MSR_IA32_SYSENTER_CS;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.sysenter_cs = msr.data;
+
+	msr.index = MSR_IA32_SYSENTER_ESP;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.sysenter_esp = msr.data;
+
+	msr.index = MSR_IA32_SYSENTER_EIP;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.sysenter_eip = msr.data;
+
+	msr.index = MSR_EFER;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.efer = msr.data;
+
+	msr.index = MSR_STAR;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.star = msr.data;
+
+	msr.index = MSR_LSTAR;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.lstar = msr.data;
+
+	msr.index = MSR_CSTAR;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.cstar = msr.data;
+
+	msr.index = MSR_IA32_CR_PAT;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.pat = msr.data;
+
+	msr.index = MSR_KERNEL_GS_BASE;
+	kvm_get_msr(vcpu, &msr);
+	event->msrs.shadow_gs = msr.data;
+}
+
+void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev)
+{
+	struct kvmi_event_arch *event = &ev->arch;
+
+	kvm_arch_vcpu_get_regs(vcpu, &event->regs);
+	kvm_arch_vcpu_get_sregs(vcpu, &event->sregs);
+	ev->arch.mode = kvmi_vcpu_mode(vcpu, &event->sregs);
+	kvmi_get_msrs(vcpu, event);
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index adbdb1ceb618..30cf0d162aa8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8244,6 +8244,11 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
+void kvm_arch_vcpu_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	__get_regs(vcpu, regs);
+}
+
 static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = true;
@@ -8339,6 +8344,11 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+void kvm_arch_vcpu_get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+{
+	__get_sregs(vcpu, sregs);
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1ec04384fad3..e876921938b6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -788,9 +788,12 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 				    struct kvm_translation *tr);
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+void kvm_arch_vcpu_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
+void kvm_arch_vcpu_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs);
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 29452da818e3..dda2ae352611 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -8,6 +8,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <asm/kvmi.h>
 
 #define KVMI_VERSION 0x00000001
 
@@ -120,4 +121,19 @@ struct kvmi_vcpu_hdr {
 	__u32 padding2;
 };
 
+struct kvmi_event {
+	__u16 size;
+	__u16 vcpu;
+	__u8 event;
+	__u8 padding[3];
+	struct kvmi_event_arch arch;
+};
+
+struct kvmi_event_reply {
+	__u8 action;
+	__u8 event;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 3c884dc0e38c..3cc7bb035796 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -76,6 +76,8 @@ static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
 	if (!ikvm)
 		return false;
 
+	atomic_set(&ikvm->ev_seq, 0);
+
 	set_bit(KVMI_GET_VERSION, ikvm->cmd_allow_mask);
 	set_bit(KVMI_CHECK_COMMAND, ikvm->cmd_allow_mask);
 	set_bit(KVMI_CHECK_EVENT, ikvm->cmd_allow_mask);
@@ -520,10 +522,20 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool need_to_wait(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+	return ivcpu->reply_waiting;
+}
+
 static bool done_waiting(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
 
+	if (!need_to_wait(vcpu))
+		return true;
+
 	return !list_empty(&ivcpu->job_list);
 }
 
@@ -552,6 +564,9 @@ int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu)
 			break;
 		}
 
+		if (!need_to_wait(vcpu))
+			break;
+
 		kvmi_add_job(vcpu, kvmi_job_wait, NULL, NULL);
 	}
 
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 33ea05cb99af..70c8ca0343a3 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -82,7 +82,18 @@ struct kvmi_job {
 	void (*free_fct)(void *ctx);
 };
 
+struct kvmi_vcpu_reply {
+	int error;
+	int action;
+	u32 seq;
+	void *data;
+	size_t size;
+};
+
 struct kvmi_vcpu {
+	bool reply_waiting;
+	struct kvmi_vcpu_reply reply;
+
 	struct list_head job_list;
 	spinlock_t job_lock;
 
@@ -96,6 +107,7 @@ struct kvmi {
 
 	struct socket *sock;
 	struct task_struct *recv;
+	atomic_t ev_seq;
 
 	uuid_t uuid;
 
@@ -118,8 +130,12 @@ void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 			       bool enable);
+int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
 
+/* arch */
+void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
+
 #endif
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 2728e6870d47..536034e1bea7 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -25,6 +25,8 @@ static const char *const msg_IDs[] = {
 	[KVMI_CHECK_EVENT]           = "KVMI_CHECK_EVENT",
 	[KVMI_CONTROL_CMD_RESPONSE]  = "KVMI_CONTROL_CMD_RESPONSE",
 	[KVMI_CONTROL_VM_EVENTS]     = "KVMI_CONTROL_VM_EVENTS",
+	[KVMI_EVENT]                 = "KVMI_EVENT",
+	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
 };
@@ -337,6 +339,57 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_GET_VERSION]           = handle_get_version,
 };
 
+static int handle_event_reply(struct kvm_vcpu *vcpu,
+			      const struct kvmi_msg_hdr *msg, const void *rpl,
+			      vcpu_reply_fct reply_cb)
+{
+	const struct kvmi_event_reply *reply = rpl;
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvmi *ikvm = IKVM(vcpu->kvm);
+	struct kvmi_vcpu_reply *expected = &ivcpu->reply;
+	size_t useful, received, common;
+
+	if (unlikely(msg->seq != expected->seq))
+		goto out;
+
+	common = sizeof(struct kvmi_vcpu_hdr) + sizeof(*reply);
+	if (unlikely(msg->size < common))
+		goto out;
+
+	if (unlikely(reply->padding1 || reply->padding2))
+		goto out;
+
+	received = msg->size - common;
+	/* Don't accept newer/bigger structures */
+	if (unlikely(received > expected->size))
+		goto out;
+
+	useful = min(received, expected->size);
+	if (useful)
+		memcpy(expected->data, reply + 1, useful);
+
+	if (useful < expected->size)
+		memset((char *)expected->data + useful, 0,
+			expected->size - useful);
+
+	expected->action = reply->action;
+	expected->error = 0;
+
+out:
+
+	if (unlikely(expected->error))
+		kvmi_err(ikvm, "Invalid event %d/%d reply seq %x/%x size %u min %zu expected %zu padding %u,%u\n",
+			 reply->event, reply->action,
+			 msg->seq, expected->seq,
+			 msg->size, common,
+			 common + expected->size,
+			 reply->padding1,
+			 reply->padding2);
+
+	ivcpu->reply_waiting = false;
+	return expected->error;
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd'
@@ -346,6 +399,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 static int(*const msg_vcpu[])(struct kvm_vcpu *,
 			      const struct kvmi_msg_hdr *, const void *,
 			      vcpu_reply_fct) = {
+	[KVMI_EVENT_REPLY]      = handle_event_reply,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *_ctx)
@@ -576,3 +630,78 @@ bool kvmi_msg_process(struct kvmi *ikvm)
 
 	return err == 0;
 }
+
+static void kvmi_setup_event_common(struct kvmi_event *ev, u32 ev_id,
+				    unsigned short vcpu_idx)
+{
+	memset(ev, 0, sizeof(*ev));
+
+	ev->vcpu = vcpu_idx;
+	ev->event = ev_id;
+	ev->size = sizeof(*ev);
+}
+
+static void kvmi_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev,
+			     u32 ev_id)
+{
+	kvmi_setup_event_common(ev, ev_id, kvm_vcpu_get_idx(vcpu));
+	kvmi_arch_setup_event(vcpu, ev);
+}
+
+static inline u32 new_seq(struct kvmi *ikvm)
+{
+	return atomic_inc_return(&ikvm->ev_seq);
+}
+
+int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+		    void *ev, size_t ev_size,
+		    void *rpl, size_t rpl_size, int *action)
+{
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_event common;
+	struct kvec vec[] = {
+		{.iov_base = &hdr,	.iov_len = sizeof(hdr)	 },
+		{.iov_base = &common,	.iov_len = sizeof(common)},
+		{.iov_base = ev,	.iov_len = ev_size	 },
+	};
+	size_t msg_size = sizeof(hdr) + sizeof(common) + ev_size;
+	size_t n = ev_size ? ARRAY_SIZE(vec) : ARRAY_SIZE(vec)-1;
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvmi *ikvm = IKVM(vcpu->kvm);
+	int err;
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.id = KVMI_EVENT;
+	hdr.seq = new_seq(ikvm);
+	hdr.size = msg_size - sizeof(hdr);
+
+	kvmi_setup_event(vcpu, &common, ev_id);
+
+	memset(&ivcpu->reply, 0, sizeof(ivcpu->reply));
+
+	ivcpu->reply.seq = hdr.seq;
+	ivcpu->reply.data = rpl;
+	ivcpu->reply.size = rpl_size;
+	ivcpu->reply.error = -EINTR;
+
+	err = kvmi_sock_write(ikvm, vec, n, msg_size);
+	if (err)
+		goto out;
+
+	ivcpu->reply_waiting = true;
+	err = kvmi_run_jobs_and_wait(vcpu);
+	if (err)
+		goto out;
+
+	err = ivcpu->reply.error;
+	if (err)
+		goto out;
+
+	*action = ivcpu->reply.action;
+
+out:
+	if (err)
+		kvmi_sock_shutdown(ikvm);
+	return err;
+}
+
