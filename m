Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4CD228AF6
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgGUVP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:15:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37794 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731193AbgGUVP6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:58 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 02791305D597;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CCF6E304FA12;
        Wed, 22 Jul 2020 00:09:26 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 50/84] KVM: introspection: handle vCPU commands
Date:   Wed, 22 Jul 2020 00:08:48 +0300
Message-Id: <20200721210922.7646-51-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
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
 virt/kvm/introspection/kvmi_msg.c | 155 +++++++++++++++++++++++++++++-
 4 files changed, 170 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index be5a92e20173..383bf39ec1e4 100644
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
index 9b2428963994..b206b7441859 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -99,6 +99,12 @@ struct kvmi_vm_write_physical {
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
index ceed50722dc1..fe5190ab31d6 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -34,6 +34,9 @@ void kvmi_msg_free(void *addr);
 bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_known_event(u8 id);
 bool kvmi_is_known_vm_event(u8 id);
+int kvmi_add_job(struct kvm_vcpu *vcpu,
+		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
+		 void *ctx, void (*free_fct)(void *ctx));
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index de9e38e8e24b..31a471df4b12 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -9,6 +9,15 @@
 #include "kvmi_int.h"
 
 static bool is_vm_command(u16 id);
+static bool is_vcpu_command(u16 id);
+
+struct kvmi_vcpu_msg_job {
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} *msg;
+	struct kvm_vcpu *vcpu;
+};
 
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd)
 {
@@ -100,6 +109,28 @@ static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
 	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
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
@@ -120,7 +151,7 @@ static int handle_vm_check_command(struct kvm_introspection *kvmi,
 
 	if (req->padding1 || req->padding2)
 		ec = -KVM_EINVAL;
-	else if (!is_vm_command(req->id))
+	else if (!is_vm_command(req->id) && !is_vcpu_command(req->id))
 		ec = -KVM_ENOENT;
 	else if (!kvmi_is_command_allowed(kvmi, req->id))
 		ec = -KVM_EPERM;
@@ -243,6 +274,60 @@ static bool is_vm_command(u16 id)
 	return id < ARRAY_SIZE(msg_vm) && !!msg_vm[id];
 }
 
+/*
+ * These functions are executed from the vCPU thread. The receiving thread
+ * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
+ * and signals the vCPU to handle the message (which includes
+ * sending back the reply if needed).
+ */
+static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
+			      const struct kvmi_msg_hdr *, const void *) = {
+};
+
+static bool is_vcpu_command(u16 id)
+{
+	return id < ARRAY_SIZE(msg_vcpu) && !!msg_vcpu[id];
+}
+
+static void kvmi_job_vcpu_msg(struct kvm_vcpu *vcpu, void *ctx)
+{
+	struct kvmi_vcpu_msg_job *job = ctx;
+	size_t id = job->msg->hdr.id;
+	int err;
+
+	job->vcpu = vcpu;
+
+	err = msg_vcpu[id](job, &job->msg->hdr, job->msg + 1);
+
+	/*
+	 * This is running from the vCPU thread.
+	 * Any error that is not sent with the reply
+	 * will shut down the socket.
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
+static bool is_vcpu_message(u16 id)
+{
+	return is_vcpu_command(id);
+}
+
 static struct kvmi_msg_hdr *kvmi_msg_recv(struct kvm_introspection *kvmi)
 {
 	struct kvmi_msg_hdr *msg;
@@ -299,9 +384,72 @@ static int kvmi_msg_handle_vm_cmd(struct kvm_introspection *kvmi,
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
+	int err;
+
+	err = kvmi_get_vcpu(kvmi, vcpu_idx, vcpu);
+
+	if (!err && !vcpu_can_handle_messages(*vcpu))
+		err = -KVM_EAGAIN;
+
+	return err;
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
+	if (!is_message_allowed(kvmi, msg->id))
+		return kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_EPERM);
+
+	if (invalid_vcpu_hdr(vcpu_hdr))
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
@@ -310,10 +458,13 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi)
 
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
