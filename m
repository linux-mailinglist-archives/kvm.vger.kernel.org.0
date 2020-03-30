Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3551978BC
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgC3KT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:56 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43776 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729181AbgC3KTy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:54 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0899C305FFA6;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D6237305B7A1;
        Mon, 30 Mar 2020 13:12:56 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 51/81] KVM: introspection: handle vCPU commands
Date:   Mon, 30 Mar 2020 13:12:38 +0300
Message-Id: <20200330101308.21702-52-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

Based on the common structure (kvmi_vcpu_hdr) used for all vCPU commands,
the receiving thread validates and dispatches the message to the proper
vCPU (adding the handling function to its jobs list).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst   |   8 ++
 include/uapi/linux/kvmi.h         |   6 ++
 virt/kvm/introspection/kvmi_int.h |   3 +
 virt/kvm/introspection/kvmi_msg.c | 169 +++++++++++++++++++++++++++++-
 4 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 748d786d1c08..271aed21f634 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -232,6 +232,14 @@ The following C structures are meant to be used directly when communicating
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
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 335e3d879df9..4a75bc28d7e0 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -100,6 +100,12 @@ struct kvmi_vm_write_physical {
 	__u8  data[0];
 };
 
+struct kvmi_vcpu_hdr {
+	__u16 vcpu;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 5d40d872e493..55500b89398b 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -32,6 +32,9 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
 void kvmi_msg_free(void *addr);
+int kvmi_add_job(struct kvm_vcpu *vcpu,
+		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
+		 void *ctx, void (*free_fct)(void *ctx));
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 1faf70945123..57e082c3bb43 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -9,6 +9,30 @@
 #include "kvmi_int.h"
 
 static bool is_vm_command(u16 id);
+static bool is_vcpu_command(u16 id);
+
+struct kvmi_vcpu_cmd_job {
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr cmd;
+	} *msg;
+	struct kvm_vcpu *vcpu;
+};
+
+static const char *const msg_IDs[] = {
+	[KVMI_GET_VERSION]       = "KVMI_GET_VERSION",
+	[KVMI_VM_CHECK_COMMAND]  = "KVMI_VM_CHECK_COMMAND",
+	[KVMI_VM_CHECK_EVENT]    = "KVMI_VM_CHECK_EVENT",
+	[KVMI_VM_CONTROL_EVENTS] = "KVMI_VM_CONTROL_EVENTS",
+	[KVMI_VM_GET_INFO]       = "KVMI_VM_GET_INFO",
+	[KVMI_VM_READ_PHYSICAL]  = "KVMI_VM_READ_PHYSICAL",
+	[KVMI_VM_WRITE_PHYSICAL] = "KVMI_VM_WRITE_PHYSICAL",
+};
+
+static const char *id2str(u16 id)
+{
+	return id < ARRAY_SIZE(msg_IDs) ? msg_IDs[id] : "unknown";
+}
 
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd)
 {
@@ -105,6 +129,28 @@ static bool is_command_allowed(struct kvm_introspection *kvmi, u16 id)
 	return id < KVMI_NUM_COMMANDS && test_bit(id, kvmi->cmd_allow_mask);
 }
 
+static bool invalid_vcpu_hdr(const struct kvmi_vcpu_hdr *hdr)
+{
+	return hdr->padding1 || hdr->padding2;
+}
+
+static int kvmi_get_vcpu(struct kvm_introspection *kvmi, unsigned int vcpu_idx,
+			 struct kvm_vcpu **dest)
+{
+	struct kvm *kvm = kvmi->kvm;
+	struct kvm_vcpu *vcpu;
+
+	if (vcpu_idx >= atomic_read(&kvm->online_vcpus))
+		return -KVM_EINVAL;
+
+	vcpu = kvm_get_vcpu(kvm, vcpu_idx);
+	if (!vcpu)
+		return -KVM_EINVAL;
+
+	*dest = vcpu;
+	return 0;
+}
+
 static int handle_get_version(struct kvm_introspection *kvmi,
 			      const struct kvmi_msg_hdr *msg, const void *req)
 {
@@ -125,7 +171,7 @@ static int handle_check_command(struct kvm_introspection *kvmi,
 
 	if (req->padding1 || req->padding2)
 		ec = -KVM_EINVAL;
-	else if (!is_vm_command(req->id))
+	else if (!is_vm_command(req->id) && !is_vcpu_command(req->id))
 		ec = -KVM_ENOENT;
 	else if (!is_command_allowed(kvmi, req->id))
 		ec = -KVM_EPERM;
@@ -261,6 +307,60 @@ static bool is_vm_command(u16 id)
 	return id < ARRAY_SIZE(msg_vm) && !!msg_vm[id];
 }
 
+/*
+ * These commands are executed from the vCPU thread. The receiving thread
+ * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
+ * and signals the vCPU to handle the command (which includes
+ * sending back the reply).
+ */
+static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
+			      const struct kvmi_msg_hdr *, const void *) = {
+};
+
+static bool is_vcpu_command(u16 id)
+{
+	return id < ARRAY_SIZE(msg_vcpu) && !!msg_vcpu[id];
+}
+
+static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
+{
+	struct kvmi_vcpu_cmd_job *job = ctx;
+	size_t id = job->msg->hdr.id;
+	int err;
+
+	job->vcpu = vcpu;
+
+	err = msg_vcpu[id](job, &job->msg->hdr, job->msg + 1);
+
+	if (err) {
+		struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
+
+		kvmi_err(kvmi, "%s: msg id %zu (%s) size %u err %d\n",
+			 __func__, id, id2str(id), job->msg->hdr.size, err);
+		kvmi_sock_shutdown(kvmi);
+	}
+}
+
+static void kvmi_free_ctx(void *_ctx)
+{
+	const struct kvmi_vcpu_cmd_job *ctx = _ctx;
+
+	kvmi_msg_free(ctx->msg);
+	kfree(ctx);
+}
+
+static int kvmi_msg_queue_to_vcpu(struct kvm_vcpu *vcpu,
+				  const struct kvmi_vcpu_cmd_job *cmd)
+{
+	return kvmi_add_job(vcpu, kvmi_job_vcpu_cmd, (void *)cmd,
+			    kvmi_free_ctx);
+}
+
+static bool is_vcpu_message(u16 id)
+{
+	return is_vcpu_command(id);
+}
+
 static struct kvmi_msg_hdr *kvmi_msg_recv(struct kvm_introspection *kvmi)
 {
 	struct kvmi_msg_hdr *msg;
@@ -308,9 +408,68 @@ static int kvmi_msg_vm_reply_ec(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+static bool vcpu_can_handle_commands(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
+}
+
+static bool kvmi_get_vcpu_if_ready(struct kvm_introspection *kvmi,
+				   unsigned int vcpu_idx,
+				   struct kvm_vcpu **vcpu)
+{
+	int err;
+
+	err = kvmi_get_vcpu(kvmi, vcpu_idx, vcpu);
+
+	return !err && vcpu_can_handle_commands(*vcpu);
+}
+
+static int kvmi_validate_vcpu_cmd(struct kvm_introspection *kvmi,
+				  struct kvmi_msg_hdr *msg,
+				  struct kvm_vcpu **vcpu)
+{
+	struct kvmi_vcpu_hdr *cmd = (struct kvmi_vcpu_hdr *)(msg + 1);
+	unsigned int vcpu_idx = cmd->vcpu;
+
+	if (invalid_vcpu_hdr(cmd))
+		return -KVM_EINVAL;
+
+	if (!kvmi_get_vcpu_if_ready(kvmi, vcpu_idx, vcpu))
+		return -KVM_EAGAIN;
+
+	return 0;
+}
+
+static int kvmi_msg_dispatch_vcpu_cmd(struct kvm_introspection *kvmi,
+				      struct kvmi_msg_hdr *msg,
+				      bool *queued)
+{
+	struct kvmi_vcpu_cmd_job *job_cmd;
+	struct kvm_vcpu *vcpu = NULL;
+	int err, ec;
+
+	ec = kvmi_validate_vcpu_cmd(kvmi, msg, &vcpu);
+	if (ec)
+		return kvmi_msg_vm_reply_ec(kvmi, msg, ec);
+
+	job_cmd = kzalloc(sizeof(*job_cmd), GFP_KERNEL);
+	if (!job_cmd)
+		return -KVM_ENOMEM;
+
+	job_cmd->msg = (void *)msg;
+
+	err = kvmi_msg_queue_to_vcpu(vcpu, job_cmd);
+	if (err)
+		kfree(job_cmd);
+
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
@@ -322,11 +481,17 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi)
 			err = kvmi_msg_dispatch_vm_cmd(kvmi, msg);
 		else
 			err = kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_EPERM);
+	} else if (is_vcpu_message(msg->id)) {
+		if (is_message_allowed(kvmi, msg->id))
+			err = kvmi_msg_dispatch_vcpu_cmd(kvmi, msg, &queued);
+		else
+			err = kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_EPERM);
 	} else {
 		err = kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_ENOSYS);
 	}
 
-	kvmi_msg_free(msg);
+	if (!queued)
+		kvmi_msg_free(msg);
 out:
 	return err == 0;
 }
