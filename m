Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E6C2C3C9A
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgKYJmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:15 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57200 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728593AbgKYJmK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:10 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4EC57305D467;
        Wed, 25 Nov 2020 11:35:50 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 21A1C3072784;
        Wed, 25 Nov 2020 11:35:50 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 46/81] KVM: introspection: handle vCPU commands
Date:   Wed, 25 Nov 2020 11:35:25 +0200
Message-Id: <20201125093600.2766-47-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

Based on the common structure (kvmi_vcpu_hdr) used for all vCPU commands,
the receiving thread validates and dispatches the message to the proper
vCPU (adding the handling function to its jobs list).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst   |   8 ++
 arch/x86/kvm/Makefile             |   2 +-
 arch/x86/kvm/kvmi_msg.c           |  17 ++++
 include/uapi/linux/kvmi.h         |   6 ++
 virt/kvm/introspection/kvmi_int.h |  16 ++++
 virt/kvm/introspection/kvmi_msg.c | 150 +++++++++++++++++++++++++++++-
 6 files changed, 196 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/kvmi_msg.c

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 7812d62240c0..4d340528d2f4 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -221,6 +221,14 @@ The following C structures are meant to be used directly when communicating
 over the wire. The peer that detects any size mismatch should simply close
 the connection and report the error.
 
+The vCPU commands start with::
+
+	struct kvmi_vcpu_hdr {
+		__u16 vcpu;
+		__u16 padding1;
+		__u32 padding2;
+	}
+
 1. KVMI_GET_VERSION
 -------------------
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 8fad40649bcf..6d04731e235e 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
 				$(KVM)/dirty_ring.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o kvmi.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o kvmi.o kvmi_msg.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
new file mode 100644
index 000000000000..0f4717ca5fa8
--- /dev/null
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection (message handling) - x86
+ *
+ * Copyright (C) 2020 Bitdefender S.R.L.
+ *
+ */
+
+#include "../../../virt/kvm/introspection/kvmi_int.h"
+
+static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
+};
+
+kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
+{
+	return id < ARRAY_SIZE(msg_vcpu) ? msg_vcpu[id] : NULL;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 048afad01be6..7ba1c8758aba 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -107,4 +107,10 @@ struct kvmi_vm_write_physical {
 	__u8  data[0];
 };
 
+struct kvmi_vcpu_hdr {
+	__u16 vcpu;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index c3aa12554c2b..c3e4da7e7f20 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -14,6 +14,18 @@
  */
 #define KVMI_MAX_MSG_SIZE (4096 * 2 - sizeof(struct kvmi_msg_hdr))
 
+struct kvmi_vcpu_msg_job {
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} *msg;
+	struct kvm_vcpu *vcpu;
+};
+
+typedef int (*kvmi_vcpu_msg_job_fct)(const struct kvmi_vcpu_msg_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *req);
+
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
@@ -28,6 +40,9 @@ bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_event_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_known_event(u16 id);
 bool kvmi_is_known_vm_event(u16 id);
+int kvmi_add_job(struct kvm_vcpu *vcpu,
+		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
+		 void *ctx, void (*free_fct)(void *ctx));
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 			       u16 event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
@@ -40,5 +55,6 @@ int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 
 /* arch */
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
+kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4fe385265758..6f2fe245a8b1 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -13,6 +13,7 @@ typedef int (*kvmi_vm_msg_fct)(struct kvm_introspection *kvmi,
 			       const void *req);
 
 static bool is_vm_command(u16 id);
+static bool is_vcpu_command(u16 id);
 
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd)
 {
@@ -104,6 +105,17 @@ static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
 	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
 }
 
+static struct kvm_vcpu *kvmi_get_vcpu(struct kvm_introspection *kvmi,
+				      unsigned int vcpu_idx)
+{
+	struct kvm *kvm = kvmi->kvm;
+
+	if (vcpu_idx >= atomic_read(&kvm->online_vcpus))
+		return NULL;
+
+	return kvm_get_vcpu(kvm, vcpu_idx);
+}
+
 static int handle_get_version(struct kvm_introspection *kvmi,
 			      const struct kvmi_msg_hdr *msg, const void *req)
 {
@@ -125,7 +137,7 @@ static int handle_vm_check_command(struct kvm_introspection *kvmi,
 
 	if (req->padding1 || req->padding2)
 		ec = -KVM_EINVAL;
-	else if (!is_vm_command(req->id))
+	else if (!is_vm_command(req->id) && !is_vcpu_command(req->id))
 		ec = -KVM_ENOENT;
 	else if (!kvmi_is_command_allowed(kvmi, req->id))
 		ec = -KVM_EPERM;
@@ -254,6 +266,74 @@ static bool is_vm_command(u16 id)
 	return is_vm_message(id) && id != KVMI_VM_EVENT;
 }
 
+/*
+ * These functions are executed from the vCPU thread. The receiving thread
+ * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
+ * and signals the vCPU to handle the message (which includes
+ * sending back the reply).
+ */
+static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
+};
+
+static kvmi_vcpu_msg_job_fct get_vcpu_msg_handler(u16 id)
+{
+	kvmi_vcpu_msg_job_fct fct;
+
+	fct = id < ARRAY_SIZE(msg_vcpu) ? msg_vcpu[id] : NULL;
+
+	if (!fct)
+		fct = kvmi_arch_vcpu_msg_handler(id);
+
+	return fct;
+}
+
+static bool is_vcpu_message(u16 id)
+{
+	bool is_vcpu_msg_id = id & 1;
+
+	return is_vcpu_msg_id && !!get_vcpu_msg_handler(id);
+}
+
+static bool is_vcpu_command(u16 id)
+{
+	return is_vcpu_message(id);
+}
+
+static void kvmi_job_vcpu_msg(struct kvm_vcpu *vcpu, void *ctx)
+{
+	struct kvmi_vcpu_msg_job *job = ctx;
+	kvmi_vcpu_msg_job_fct fct;
+	int err;
+
+	job->vcpu = vcpu;
+
+	fct = get_vcpu_msg_handler(job->msg->hdr.id);
+	err = fct(job, &job->msg->hdr, job->msg + 1);
+
+	/*
+	 * The soft errors are sent with the reply.
+	 * On hard errors, like this one,
+	 * we shut down the socket.
+	 */
+	if (err)
+		kvmi_sock_shutdown(KVMI(vcpu->kvm));
+}
+
+static void kvmi_free_ctx(void *_ctx)
+{
+	const struct kvmi_vcpu_msg_job *ctx = _ctx;
+
+	kvmi_msg_free(ctx->msg);
+	kfree(ctx);
+}
+
+static int kvmi_msg_queue_to_vcpu(struct kvm_vcpu *vcpu,
+				  const struct kvmi_vcpu_msg_job *cmd)
+{
+	return kvmi_add_job(vcpu, kvmi_job_vcpu_msg, (void *)cmd,
+			    kvmi_free_ctx);
+}
+
 static struct kvmi_msg_hdr *kvmi_msg_recv(struct kvm_introspection *kvmi)
 {
 	struct kvmi_msg_hdr *msg;
@@ -307,9 +387,72 @@ static int kvmi_msg_handle_vm_cmd(struct kvm_introspection *kvmi,
 	return kvmi_msg_do_vm_cmd(kvmi, msg);
 }
 
+static bool vcpu_can_handle_messages(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
+}
+
+static int kvmi_get_vcpu_if_ready(struct kvm_introspection *kvmi,
+				  unsigned int vcpu_idx,
+				  struct kvm_vcpu **vcpu)
+{
+	*vcpu = kvmi_get_vcpu(kvmi, vcpu_idx);
+	if (*vcpu == NULL)
+		return -KVM_EINVAL;
+
+	if (!vcpu_can_handle_messages(*vcpu))
+		return -KVM_EAGAIN;
+
+	return 0;
+}
+
+static int kvmi_msg_dispatch_vcpu_msg(struct kvm_introspection *kvmi,
+				      struct kvmi_msg_hdr *msg,
+				      struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu_msg_job *job_cmd;
+	int err;
+
+	job_cmd = kzalloc(sizeof(*job_cmd), GFP_KERNEL);
+	if (!job_cmd)
+		return -ENOMEM;
+
+	job_cmd->msg = (void *)msg;
+
+	err = kvmi_msg_queue_to_vcpu(vcpu, job_cmd);
+	if (err)
+		kfree(job_cmd);
+
+	return err;
+}
+
+static int kvmi_msg_handle_vcpu_msg(struct kvm_introspection *kvmi,
+				    struct kvmi_msg_hdr *msg,
+				    bool *queued)
+{
+	struct kvmi_vcpu_hdr *vcpu_hdr = (struct kvmi_vcpu_hdr *)(msg + 1);
+	struct kvm_vcpu *vcpu = NULL;
+	int err, ec;
+
+	if (!kvmi_is_command_allowed(kvmi, msg->id))
+		return kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_EPERM);
+
+	if (vcpu_hdr->padding1 || vcpu_hdr->padding2)
+		return kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_EINVAL);
+
+	ec = kvmi_get_vcpu_if_ready(kvmi, vcpu_hdr->vcpu, &vcpu);
+	if (ec)
+		return kvmi_msg_vm_reply_ec(kvmi, msg, ec);
+
+	err = kvmi_msg_dispatch_vcpu_msg(kvmi, msg, vcpu);
+	*queued = err == 0;
+	return err;
+}
+
 bool kvmi_msg_process(struct kvm_introspection *kvmi)
 {
 	struct kvmi_msg_hdr *msg;
+	bool queued = false;
 	int err = -1;
 
 	msg = kvmi_msg_recv(kvmi);
@@ -318,10 +461,13 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi)
 
 	if (is_vm_command(msg->id))
 		err = kvmi_msg_handle_vm_cmd(kvmi, msg);
+	else if (is_vcpu_message(msg->id))
+		err = kvmi_msg_handle_vcpu_msg(kvmi, msg, &queued);
 	else
 		err = kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_ENOSYS);
 
-	kvmi_msg_free(msg);
+	if (!queued)
+		kvmi_msg_free(msg);
 out:
 	return err == 0;
 }
